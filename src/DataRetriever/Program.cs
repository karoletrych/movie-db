using System;
using System.Collections.Generic;
using System.Linq;
using Database;

namespace DataRetriever
{
    internal class Program
    {
        private static void Main(string[] args)
        {
            var httpRetriever = new HttpRetriever();
            var dao = new DAO();

            var departments = httpRetriever.RetrieveDepartments();
            dao.InsertDepartments(departments);

            for (var id = 1; id < 900; id++)
            {
                Console.WriteLine(id);
                try
                {
                    RetrieveAndInsertFilm(httpRetriever, dao, id);
                    var cast = httpRetriever.RetrieveCastFromFilm(id);
                    foreach (var c in cast)
                    {
                        var person = RetrievePerson(httpRetriever, c.PersonId);
                        dao.InsertPerson(person);
                        dao.InsertCast(c);
                    }
                    var crew = httpRetriever.RetrieveCrewFromFilm(id);
                    foreach (var c in crew)
                    {
                        var person = RetrievePerson(httpRetriever, c.PersonId);
                        dao.InsertPerson(person);
                        dao.InsertCrew(c);
                    }

                }
                catch (KeyNotFoundException)
                {
                }
            }
        }

        private static void RetrieveAndInsertFilm(HttpRetriever httpRetriever, DAO dao, int id)
        {
            var film = httpRetriever.RetrieveMovie(id);
            dao.InsertMovie(film);
            var countries = httpRetriever.RetrieveCountriesFromFilm(id).ToList();
            dao.InsertCountries(countries);
            dao.InsertMovie_Countries(film.MovieId, countries.Select(x => x.CountryId));
        }

        private static Person RetrievePerson(HttpRetriever httpRetriever, int id)
        {
            var person = httpRetriever.RetrievePerson(id);
            return person;
        }
    }
}