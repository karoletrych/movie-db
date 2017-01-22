using System;
using System.Collections.Generic;
using Database.Model;
using Npgsql;

namespace Database.DAO
{
    public class Dao
    {
        protected readonly NpgsqlConnection Connection;

        public Dao()
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
            Connection = new NpgsqlConnection(connectionStringBuilder);
            Connection.Open();
        }

        public void InsertPerson(Person person)
        {
            var command = Connection.CreateCommand();
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
            var command = Connection.CreateCommand();
            command.CommandText =
                @"insert into _cast (person_id, movie_id, character)
values(:person_id, :movie_id, :character) on conflict do nothing";
            command.Parameters.Add(new NpgsqlParameter("person_id", cast.PersonId));
            command.Parameters.Add(new NpgsqlParameter("movie_id", cast.MovieId));
            command.Parameters.Add(new NpgsqlParameter("character", cast.Character));
            command.ExecuteNonQuery();
        }

        public void InsertDepartments(IEnumerable<Department> departments)
        {
            foreach (var department in departments)
            {
                var insertDepartmentCommand = Connection.CreateCommand();
                insertDepartmentCommand.CommandText =
                    @"insert into department (department_id, name)
values(:department_id, :name) on conflict do nothing";
                insertDepartmentCommand.Parameters.Add(new NpgsqlParameter("department_id", department.Id));
                insertDepartmentCommand.Parameters.Add(new NpgsqlParameter("name", department.Name));
                insertDepartmentCommand.ExecuteNonQuery();
                foreach (var job in department.Jobs)
                {
                    var insertJobCommand = Connection.CreateCommand();
                    insertJobCommand.CommandText =
                        @"insert into job (job_name, department_id)
values(:job_name, :department_id) on conflict do nothing";
                    insertJobCommand.Parameters.Add(new NpgsqlParameter("department_id", department.Id));
                    insertJobCommand.Parameters.Add(new NpgsqlParameter("job_name", job.Name));
                    insertJobCommand.ExecuteNonQuery();
                }
            }
        }

        public void InsertCrew(Crew cast)
        {
            var command = Connection.CreateCommand();
            command.CommandText =
                @"insert into crew (person_id, movie_id, job_name)
values(:person_id, :movie_id, :job_name) on conflict do nothing";
            command.Parameters.Add(new NpgsqlParameter("person_id", cast.PersonId));
            command.Parameters.Add(new NpgsqlParameter("movie_id", cast.MovieId));
            command.Parameters.Add(new NpgsqlParameter("job_name", cast.JobName));
            command.ExecuteNonQuery();
        }

        public void InsertGenres(IEnumerable<Genre> genres)
        {
            foreach (var genre in genres)
            {
                var command = Connection.CreateCommand();
                command.CommandText =
                    @"insert into genre(name, genre_id)
values(:name, :genre_id) on conflict do nothing";
                command.Parameters.Add(new NpgsqlParameter("name", genre.Name));
                command.Parameters.Add(new NpgsqlParameter("genre_id", genre.GenreId));
                command.ExecuteNonQuery();
            }
        }

        public void InsertMovieGenres(IEnumerable<MovieGenre> movieGenres)
        {
            foreach (var movieGenre in movieGenres)
            {
                var command = Connection.CreateCommand();
                command.CommandText =
                    @"insert into movie_genre(movie_id, genre_id)
values(:movie_id, :genre_id) on conflict do nothing";
                command.Parameters.Add(new NpgsqlParameter("movie_id", movieGenre.MovieId));
                command.Parameters.Add(new NpgsqlParameter("genre_id", movieGenre.GenreId));
                command.ExecuteNonQuery();
            }
        }
    }
}