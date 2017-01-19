﻿using System;
using System.Collections.Generic;
using System.Linq;
using Database;

namespace DataRetriever
{
    internal class Program
    {
        private static void Main(string[] args)
        {
            var httpRetriever = new HTTPRetriever();
            var dao = new DAO();
            for (var id = 1; id < 900; id++)
            {
                Console.WriteLine(id);
                try
                {
                    RetrieveFilm(httpRetriever, dao, id);
                    var cast = httpRetriever.RetrieveCastFromFilm(id);
                    foreach (var person in cast)
                    {
                        RetrievePerson(httpRetriever, dao, person.PersonId);
                    }

                    RetrievePerson(httpRetriever, dao, id);
                }
                catch (KeyNotFoundException)
                {
                }
            }
        }

        private static void RetrieveFilm(HTTPRetriever httpRetriever, DAO dao, int id)
        {
            var film = httpRetriever.RetrieveFilm(id);
            dao.InsertMovie(film);
            var countries = httpRetriever.RetrieveCountriesFromFilm(id).ToList();
            dao.InsertCountries(countries);
            dao.InsertMovie_Countries(film.MovieId, countries.Select(x => x.CountryId));
        }

        private static void RetrievePerson(HTTPRetriever httpRetriever, DAO dao, int id)
        {
            var person = httpRetriever.RetrievePerson(id);
            dao.InsertPerson(person);
        }
    }
}