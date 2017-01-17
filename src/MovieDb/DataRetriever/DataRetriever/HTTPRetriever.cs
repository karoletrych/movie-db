using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web.Script.Serialization;
using Database;
using static System.String;

namespace DataRetriever.DataRetriever
{
    public class HTTPRetriever
    {
        private readonly HttpClient _client;
        private const string ConnectionString = "https://api.themoviedb.org/3/{0}/{1}?api_key=da401c8351bc545ba0a95b1847e3e654&language=en-US";

        public HTTPRetriever()
        {
            _client = new HttpClient();
            _client.DefaultRequestHeaders.Accept.Clear();
            _client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        }
        
        public film RetrieveFilm(int id)
        {
            var path = Format(ConnectionString, "movie", id);
            var response = _client.GetAsync(path).Result.Content.ReadAsStringAsync().Result;
            var deserialized = new JavaScriptSerializer().Deserialize<dynamic>(response);

            var dataPremiery = DateTime.Parse(deserialized["release_date"]);
            return new film
            {
                DataPremiery = dataPremiery,
                Dochod = deserialized["revenue"],
                FilmId = id,
                Status = deserialized["status"],
                Tytul = deserialized["title"]
            };
        }

        public IEnumerable<kraj> RetrieveCountriesFromFilm(int id)
        {
            var path = Format(ConnectionString, "movie", id);
            var response = _client.GetAsync(path).Result.Content.ReadAsStringAsync().Result;
            var deserialized = new JavaScriptSerializer().Deserialize<dynamic>(response);
            var countries = deserialized["production_countries"];
            foreach (var country in countries)
            {
                yield return new kraj {KrajId = country["iso_3166_1"], Nazwa = country["name"]};
            }

        }
    }
}