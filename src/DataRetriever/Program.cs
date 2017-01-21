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

            var genres = httpRetriever.RetrieveGenres();
            dao.InsertGenres(genres);

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
            // some of the genres are not contained in  /genre/movie/list
            var genres = httpRetriever.RetrieveGenresFromMovie(id); 
            var movieGenres = httpRetriever.RetrieveMovieGenres(id);
            var countries = httpRetriever.RetrieveMovieProductionCountries(id).ToList();

            dao.InsertMovie(film);
            dao.InsertCountries(countries);
            dao.InsertMovieCountries(film.MovieId, countries.Select(x => x.CountryId));
            dao.InsertGenres(genres);
            dao.InsertMovieGenres(movieGenres);
        }

        private static Person RetrievePerson(HttpRetriever httpRetriever, int id)
        {
            var person = httpRetriever.RetrievePerson(id);
            return person;
        }
    }
}