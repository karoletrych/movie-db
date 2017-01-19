using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web.Script.Serialization;
using Database;
using static System.String;

namespace DataRetriever
{
    public class HTTPRetriever
    {
        private const string ConnectionString =
            "https://api.themoviedb.org/3/{0}/{1}?api_key=da401c8351bc545ba0a95b1847e3e654&language=en-US";

        private readonly HttpClient _client;

        public HTTPRetriever()
        {
            _client = new HttpClient();
            _client.DefaultRequestHeaders.Accept.Clear();
            _client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        }

        public Film RetrieveFilm(int id)
        {
            var path = Format(ConnectionString, "movie", id);
            var response = Get(path);

            var dataPremiery = DateTime.Parse(response["release_date"]);
            return new Film
            {
                DataPremiery = dataPremiery,
                Dochod = response["revenue"],
                FilmId = id,
                Status = response["status"],
                Tytul = response["title"]
            };
        }

        public IEnumerable<Kraj> RetrieveCountriesFromFilm(int id)
        {
            var path = Format(ConnectionString, "movie", id);
            var response = Get(path);

            var countries = response["production_countries"];
            foreach (var country in countries)
            {
                yield return new Kraj
                {
                    KrajId = country["iso_3166_1"],
                    Nazwa = country["name"]
                };
            }
        }

        public IEnumerable<Obsada> RetrieveCastFromFilm(int id)
        {
            var path = Format(ConnectionString, "movie", id + @"/credits");
            var response = Get(path);
            var casts = response["cast"];
            foreach (var cast in casts)
            {
                var obsada = new Obsada
                {
                    FilmId = id,
                    Postac = cast["character"],
                    CzlowiekId = cast["id"]
                };
                yield return obsada;
            }
        }

        public Czlowiek RetrievePerson(int person_id)
        {
            var path = Format(ConnectionString, "person", person_id);
            var response = Get(path);
            var person = new Czlowiek
            {
                Biografia = response["biography"],
                CzlowiekId = person_id,
                DataUrodzenia = TryParse(response["birthday"]),
                MiejsceUrodzenia = response["place_of_birth"],
                Nazwisko = response["name"],
                Plec = response["gender"],
                DataZgonu = TryParse(response["deathday"])
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