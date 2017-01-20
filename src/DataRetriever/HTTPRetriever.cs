using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web.Script.Serialization;
using Database;
using static System.String;

namespace DataRetriever
{
    public class HttpRetriever
    {
        private const string ConnectionString =
            "https://api.themoviedb.org/3/{0}/{1}?api_key=da401c8351bc545ba0a95b1847e3e654&language=en-US";

        private static int _jobId;
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
            var path = Format(ConnectionString, "movie", id);
            var response = Get(path);

            var dataPremiery = DateTime.Parse(response["release_date"]);
            return new Movie
            {
                ReleaseDate = dataPremiery,
                Revenue = response["revenue"],
                MovieId = id,
                Status = response["status"],
                Title = response["title"]
            };
        }

        public IEnumerable<Country> RetrieveCountriesFromFilm(int id)
        {
            var path = Format(ConnectionString, "movie", id);
            var response = Get(path);

            var countries = response["production_countries"];
            foreach (var country in countries)
                yield return new Country
                {
                    CountryId = country["iso_3166_1"],
                    Name = country["name"]
                };
        }

        public IEnumerable<Cast> RetrieveCastFromFilm(int id)
        {
            var path = Format(ConnectionString, "movie", id + @"/credits");
            var response = Get(path);
            var casts = response["cast"];
            foreach (var cast in casts)
            {
                var obsada = new Cast
                {
                    MovieId = id,
                    Character = cast["character"],
                    PersonId = cast["id"]
                };
                yield return obsada;
            }
        }

        public IEnumerable<Department> RetrieveDepartments()
        {
            var path = Format(ConnectionString, "job", "list");
            var response = Get(path);
            foreach (var department in response["jobs"])
            {
                var jobsNames = new List<string>();
                foreach (var job in department["job_list"])
                {
                    jobsNames.Add(job);
                }
                var newDepartment = new Department
                {
                    Name = department["department"],
                    Jobs = jobsNames.Select(name => new Job {Id = _jobId++, Name = name}),
                    Id = _departmentId++
                };
                yield return newDepartment;
            }
        }

        public IEnumerable<Crew> RetrieveCrewFromFilm(int id)
        {
            var path = Format(ConnectionString, "movie", id + @"/credits");
            var response = Get(path);
            var crews = response["crew"];
            foreach (var crew in crews)
            {
                var deserializedCrew = new Crew
                {
                    MovieId = id,
                    JobId = crew["job"],
                    PersonId = crew["id"]
                };
                yield return deserializedCrew;
            }
        }

        public Person RetrievePerson(int personId)
        {
            var path = Format(ConnectionString, "person", personId);
            var response = Get(path);
            var person = new Person
            {
                Biography = response["biography"],
                PersonId = personId,
                BirthDay = TryParse(response["birthday"]),
                PlaceOfBirth = response["place_of_birth"],
                Name = response["name"],
                Gender = response["gender"],
                DeathDay = TryParse(response["deathday"])
            };
            return person;
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