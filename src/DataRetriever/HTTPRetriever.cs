using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web.Script.Serialization;
using Database.Model;
using static System.String;

namespace DataRetriever
{
    public class HttpRetriever
    {
        private const string ConnectionString =
            "https://api.themoviedb.org/3/{0}?api_key=da401c8351bc545ba0a95b1847e3e654&language=en-US";

        private static int _departmentId;

        private readonly HttpClient _client;

        public HttpRetriever()
        {
            _client = new HttpClient();
            _client.DefaultRequestHeaders.Accept.Clear();
            _client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        }

        public Movie RetrieveMovie(int id)
        {
            var path = Format(ConnectionString, "movie/" + id);
            var response = Get(path);

            var releaseDate = DateTime.Parse(response["release_date"]);
            return new Movie
            (
                releaseDate: releaseDate,
                movieId: id,
                status: response["status"],
                revenue: response["revenue"],
                posterUrl: response["poster_path"],
                title: response["title"],
                averageVote: 0
            );
        }

        public IEnumerable<Country> RetrieveMovieProductionCountries(int id)
        {
            var path = Format(ConnectionString, "movie/" + id);
            var response = Get(path);

            var countries = response["production_countries"];
            foreach (var country in countries)
                yield return new Country
                (
                    countryId: country["iso_3166_1"],
                    name: country["name"]
                );
        }

        public IEnumerable<MovieGenre> RetrieveMovieGenres(int id)
        {
            var path = Format(ConnectionString, "movie/" + id);
            var response = Get(path);

            var genres = response["genres"];
            foreach (var genre in genres)
                yield return new MovieGenre
                (
                    movieId: id,
                    genreId: genre["id"]
                );
        }

        public IEnumerable<Genre> RetrieveGenres()
        {
            var path = Format(ConnectionString, "genre/movie/list");
            var response = Get(path);

            foreach (var genre in response["genres"])
                yield return new Genre
                (
                    genreId: genre["id"],
                    name: genre["name"]
                );
        }

        public IEnumerable<Cast> RetrieveCastFromFilm(int id)
        {
            var path = Format(ConnectionString, "movie/" + id + "/credits");
            var response = Get(path);
            var casts = response["cast"];
            foreach (var cast in casts)
            {
                var obsada = new Cast
                (
                    person: cast["id"],
                    movie: id,
                    character: cast["character"]
                );
                yield return obsada;
            }
        }

        public IEnumerable<Department> RetrieveDepartments()
        {
            var path = Format(ConnectionString, "job/list");
            var response = Get(path);
            foreach (var department in response["jobs"])
            {
                var jobsNames = new List<string>();
                foreach (var job in department["job_list"])
                    jobsNames.Add(job);
                var newDepartment = new Department
                (
                    id: _departmentId++,
                    name: department["department"],
                    jobs: jobsNames.Select(name => new Job (name))
                );
                yield return newDepartment;
            }
        }

        public IEnumerable<Crew> RetrieveCrewFromFilm(int id)
        {
            var path = Format(ConnectionString, "movie/" + id + "/credits");
            var response = Get(path);
            var crews = response["crew"];
            foreach (var crew in crews)
            {
                var deserializedCrew = new Crew
                (
                    person: crew["id"],
                    movie: id,
                    jobName: crew["job"]
                );
                yield return deserializedCrew;
            }
        }

        public Person RetrievePerson(int personId)
        {
            var path = Format(ConnectionString, "person/" + personId);
            var response = Get(path);
            var person = new Person
            (
                name: response["name"],
                personId: personId,
                birthDay: TryParse(response["birthday"]),
                deathDay: response["deathday"],
                biography: response["biography"],
                gender: response["gender"],
                placeOfBirth: TryParse(response["place_of_birth"])
            );
            return person;
        }

        public IEnumerable<Genre> RetrieveGenresFromMovie(int id)
        {
            var path = Format(ConnectionString, "movie/" + id);
            var response = Get(path);

            var genres = response["genres"];
            foreach (var genre in genres)
                yield return new Genre
                (
                    genreId: genre["id"],
                    name: genre["name"]
                );
        }

        private dynamic Get(string path)
        {
            var response = _client.GetAsync(path).Result.Content.ReadAsStringAsync().Result;
            var deserialized = new JavaScriptSerializer().Deserialize<dynamic>(response);
            return deserialized;
        }

        private static DateTime? TryParse(string text)
        {
            DateTime date;
            return DateTime.TryParse(text, out date) ? date : (DateTime?) null;
        }
    }
}