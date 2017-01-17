using System;
using System.Collections.Generic;
using System.Linq;
using Database;
using DataRetriever.DataRetriever;
using Npgsql;

namespace DataRetriever
{
    internal class Program
    {
        private static void Main(string[] args)
        {
            var httpRetriever = new HTTPRetriever();
            var dao = new DAO();
            for (var id = 1; id < 100000; id++)
            {
                Console.WriteLine(id);
                try
                {
                    var film = httpRetriever.RetrieveFilm(id);
                    var countries = httpRetriever.RetrieveCountriesFromFilm(id).ToList();

                    dao.InsertFilm(film);
                    dao.InsertCountries(countries);
                    dao.InsertFilm_Countries(film.FilmId, countries.Select(x=>x.KrajId));
                }
                catch (KeyNotFoundException)
                {
                }
            }
        }
    }
}