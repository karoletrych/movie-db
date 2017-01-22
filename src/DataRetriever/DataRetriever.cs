using System;
using System.Collections.Generic;
using System.Linq;
using Database.DAO;
using Database.Model;

namespace DataRetriever
{
    public class DataRetriever
    {
        private readonly GenresDao _genresDao;
        private readonly CountriesDao _countriesDao;
        private readonly HttpRetriever _httpRetriever;
        private readonly MovieDao _movieDao;
        private readonly Dao _dao;

        public DataRetriever()
        {
            _genresDao = new GenresDao();
            _countriesDao = new CountriesDao();
            _httpRetriever = new HttpRetriever();
            _movieDao = new MovieDao();
            _dao = new Dao();
        }

        public void Retrieve()
        {
            var departments = _httpRetriever.RetrieveDepartments();
            _dao.InsertDepartments(departments);

            var genres = _httpRetriever.RetrieveGenres();
            _genresDao.InsertGenres(genres);

            for (var id = 1; id < 900; id++)
            {
                Console.WriteLine(id);
                try
                {
                    RetrieveAndInsertFilm(id);
                    var cast = _httpRetriever.RetrieveCastFromFilm(id);
                    foreach (var c in cast)
                    {
                        var person = RetrievePerson(_httpRetriever, c.PersonId);
                        _dao.InsertPerson(person);
                        _dao.InsertCast(c);
                    }
                    var crew = _httpRetriever.RetrieveCrewFromFilm(id);
                    foreach (var c in crew)
                    {
                        var person = RetrievePerson(_httpRetriever, c.PersonId);
                        _dao.InsertPerson(person);
                        _dao.InsertCrew(c);
                    }
                }
                catch (KeyNotFoundException)
                {
                }
            }
        }

        private void RetrieveAndInsertFilm(int id)
        {
            var film = _httpRetriever.RetrieveMovie(id);
            // some of the genres are not contained in /genre/movie/list
            var genres = _httpRetriever.RetrieveGenresFromMovie(id);
            var movieGenres = _httpRetriever.RetrieveMovieGenres(id);
            var countries = _httpRetriever.RetrieveMovieProductionCountries(id).ToList();

            _movieDao.InsertMovie(film);
            _countriesDao.InsertCountries(countries);
            _countriesDao.InsertMovieCountries(film.MovieId, countries.Select(x => x.CountryId));
            _genresDao.InsertGenres(genres);
            _genresDao.InsertMovieGenres(movieGenres);
        }

        private static Person RetrievePerson(HttpRetriever httpRetriever, int id)
        {
            var person = httpRetriever.RetrievePerson(id);
            return person;
        }
    }
}