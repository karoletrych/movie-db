using System;
using System.Collections.Generic;
using Npgsql;

namespace Database
{
    public class DAO
    {
        private readonly NpgsqlConnection _connection;

        public DAO()
        {
            var connectionStringBuilder = new NpgsqlConnectionStringBuilder
            {
                Port = 5432,
                Database = "postgres",
                Username = "postgres",
                Password = "q",
                SearchPath = "moviedb",
                Host = "localhost"
            };
            _connection = new NpgsqlConnection(connectionStringBuilder);
            _connection.Open();
        }

        public void InsertMovie(Movie movie)
        {
            var command = _connection.CreateCommand();
            command.CommandText =
                @"insert into movie (movie_id, release_date,
status, revenue, poster_url, title)
values(:movie_id, :release_date, :status,
:revenue, :poster_url, :title) on conflict(movie_id) DO NOTHING;";
            command.Parameters.Add(new NpgsqlParameter("movie_id", movie.MovieId));
            command.Parameters.Add(new NpgsqlParameter("release_date", movie.ReleaseDate));
            command.Parameters.Add(new NpgsqlParameter("status", movie.Status));
            command.Parameters.Add(new NpgsqlParameter("poster_url", (object) movie.PosterUrl ?? DBNull.Value));
            command.Parameters.Add(new NpgsqlParameter("title", movie.Title));
            command.Parameters.Add(new NpgsqlParameter("revenue", movie.Revenue));
            command.ExecuteNonQuery();
        }

        public IEnumerable<Movie> GetMoviesByTitleLike(string title)
        {
            var command = _connection.CreateCommand();
            command.CommandText =
                @"select * from movie where title ilike @title";
            command.Parameters.AddWithValue("@title", "%" + title + "%");
            var reader = command.ExecuteReader();
            while (reader.Read())
            {
                var movie = new Movie
                {
                    MovieId = reader.GetInt32(0),
                    ReleaseDate = reader.GetDateTime(1),
                    Status = reader.GetString(2),
                    Revenue = reader.GetDecimal(3),
                    PosterUrl = reader.GetValue(4) != DBNull.Value ? reader.GetString(4) : null,
                    Title = reader.GetString(5)
                };
                yield return movie;
            }
            reader.Close();
        }

        public void InsertCountries(ICollection<Country> countrys)
        {
            var command = _connection.CreateCommand();
            foreach (var country in countrys)
            {
                command.CommandText =
                    @"insert into country (country_id, name)
values(:country_id, :name) ON CONFLICT (country_id) DO NOTHING;";
                command.Parameters.Add(new NpgsqlParameter("country_id", country.CountryId));
                command.Parameters.Add(new NpgsqlParameter("name", country.Name));
                command.ExecuteNonQuery();
            }
        }

        public void InsertMovie_Countries(int movieId, IEnumerable<string> countries)
        {
            var command = _connection.CreateCommand();
            foreach (var country in countries)
            {
                command.CommandText =
                    @"insert into movie_productioncountry(country_id, movie_id)
values(:country_id, :movie_id)";
                command.Parameters.Add(new NpgsqlParameter("country_id", country));
                command.Parameters.Add(new NpgsqlParameter("movie_id", movieId));
                command.ExecuteNonQuery();
            }
        }

        public void InsertPerson(Person person)
        {
            var command = _connection.CreateCommand();
            command.CommandText =
                @"insert into person (person_id, birthday, deathday, biography, gender, place_of_birth, name)
values(:person_id, :birthday, :deathday, :biography, :gender, :place_of_birth, :name) ON CONFLICT DO NOTHING";
            command.Parameters.Add(new NpgsqlParameter("person_id", person.PersonId));
            command.Parameters.Add(new NpgsqlParameter("birthday", (object) person.BirthDay ?? DBNull.Value));
            command.Parameters.Add(new NpgsqlParameter("deathday", (object) person.DeathDay ?? DBNull.Value));
            command.Parameters.Add(new NpgsqlParameter("biography", person.Biography ?? ""));
            command.Parameters.Add(new NpgsqlParameter("gender", person.Gender));
            command.Parameters.Add(new NpgsqlParameter("place_of_birth", person.PlaceOfBirth ?? ""));
            command.Parameters.Add(new NpgsqlParameter("name", person.Name));
            command.ExecuteNonQuery();
        }

        public void InsertCast(Cast cast)
        {
            var command = _connection.CreateCommand();
            command.CommandText =
                @"insert into _cast (person_id, movie_id, character)
values(:person_id, :movie_id, :character)";
            command.Parameters.Add(new NpgsqlParameter("person_id", cast.PersonId));
            command.Parameters.Add(new NpgsqlParameter("movie_id", cast.MovieId));
            command.Parameters.Add(new NpgsqlParameter("character", cast.Character));
            command.ExecuteNonQuery();
        }

        public void InsertDepartments(IEnumerable<Department> departments)
        {
            foreach (var department in departments)
            {
                var insertDepartmentCommand = _connection.CreateCommand();
                insertDepartmentCommand.CommandText =
                    @"insert into department (department_id, name)
values(:department_id, :name) on conflict do nothing";
                insertDepartmentCommand.Parameters.Add(new NpgsqlParameter("department_id", department.Id));
                insertDepartmentCommand.Parameters.Add(new NpgsqlParameter("name", department.Name));
                insertDepartmentCommand.ExecuteNonQuery();
                foreach (var job in department.Jobs)
                {
                    var insertJobCommand = _connection.CreateCommand();
                    insertJobCommand.CommandText =
                        @"insert into job (job_id, department_id, name)
values(:job_id, :department_id, :name) on conflict do nothing";
                    insertJobCommand.Parameters.Add(new NpgsqlParameter("department_id", department.Id));
                    insertJobCommand.Parameters.Add(new NpgsqlParameter("name", job.Name));
                    insertJobCommand.ExecuteNonQuery();
                }
            }
        }

        public void InsertCrew(Crew cast)
        {
            var command = _connection.CreateCommand();
            command.CommandText =
                @"insert into crew (person_id, movie_id, job)
values(:person_id, :movie_id, :job)";
            command.Parameters.Add(new NpgsqlParameter("person_id", cast.PersonId));
            command.Parameters.Add(new NpgsqlParameter("movie_id", cast.MovieId));
            command.Parameters.Add(new NpgsqlParameter("job", cast.JobName));
            command.ExecuteNonQuery();
        }
    }
}