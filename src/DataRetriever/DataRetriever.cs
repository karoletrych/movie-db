using System;
using System.Collections.Generic;
using System.Linq;
using Database;
using Database.DAO;
using Database.Model;
using Npgsql;

namespace DataRetriever
{
    public class DataRetriever
    {
        private readonly GenresDao _genresDao;
        private readonly CountriesDao _countriesDao;
        private readonly HttpRetriever _httpRetriever;
        private readonly MovieDao _movieDao;
        private readonly CastDao _castDao;
        private readonly CrewDao _crewDao;
        private readonly PersonDao _personDao;
        private readonly Authorization _authorization;
        private readonly ReviewsDao _reviewsDao;
        private readonly NpgsqlConnection _databaseConnection = DatabaseConnectionFactory.Create();

        public DataRetriever()
        {
            _castDao = new CastDao();
            _genresDao = new GenresDao();
            _countriesDao = new CountriesDao();
            _httpRetriever = new HttpRetriever();
            _movieDao = new MovieDao();
            _crewDao = new CrewDao();
            _personDao = new PersonDao();
            _authorization = new Authorization();
            _reviewsDao = new ReviewsDao();
        }

        private static readonly Random Random = new Random();

        public static string RandomString(int length)
        {
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            return new string(Enumerable.Repeat(chars, length)
              .Select(s => s[Random.Next(s.Length)]).ToArray());
        }

        public static string RandomEmail(int length)
        {
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            var str = new string(Enumerable.Repeat(chars, length)
              .Select(s => s[Random.Next(s.Length)]).ToArray()).ToCharArray();
            str[length/2]= '@';
            return new string(str);
        }

        public void Retrieve(int count)
        {
            var departments = _httpRetriever.RetrieveDepartments();
            _crewDao.InsertDepartments(departments);

            var genres = _httpRetriever.RetrieveGenres();
            _genresDao.InsertGenres(genres);

            var logins = InsertMembers();

            for (var id = 1; id < count; id++)
            {
                Console.WriteLine(id);
                try
                {
                    RetrieveAndInsertFilm(id);
                    foreach (var login in logins)
                    {
                        _reviewsDao.AddReview(login, RandomString(100), Random.Next(1,10),id);
                    }
                    var cast = _httpRetriever.RetrieveCastFromFilm(id);
                    foreach (var c in cast)
                    {
                        var person = RetrievePerson(_httpRetriever, c.PersonId);
                        _personDao.InsertPerson(person);
                        _castDao.InsertCast(c);
                    }
                    var crew = _httpRetriever.RetrieveCrewFromFilm(id);
                    foreach (var c in crew)
                    {
                        var person = RetrievePerson(_httpRetriever, c.PersonId);
                        _personDao.InsertPerson(person);
                        _crewDao.InsertCrew(c);
                    }
                }
                catch (KeyNotFoundException)
                {
                }
            }
            _databaseConnection.Close();
        }

        private IList<string> InsertMembers()
        {
            var logins = new List<string>();
            for (var i = 0; i < 20; i++)
            {
                var login = RandomString(10);
                _authorization.RegisterUser(login, RandomEmail(10), RandomString(10));
                logins.Add(login);
            }
            return logins;
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
            _countriesDao.InsertMovieCountries(film.MovieId, countries.Select(x => x.CountryId).ToList());
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