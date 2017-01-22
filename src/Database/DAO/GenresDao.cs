﻿using System.Collections.Generic;
using Database.Model;
using Npgsql;

namespace Database.DAO
{
    public class GenresDao : Dao
    {
        public GenresDao(NpgsqlConnection connection) : base(connection)
        {
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

        public IEnumerable<string> GetGenresOfMovie(int movieId)
        {
            var command = Connection.CreateCommand();
            command.CommandText =
                @"SELECT name
FROM 
  genre g JOIN movie_genre mg on g.genre_id = mg.genre_id
  JOIN movie m ON m.movie_id = mg.movie_id
WHERE 
  m.movie_id = @movie_id";
            command.Parameters.Add(new NpgsqlParameter("movie_id", movieId));
            var reader = command.ExecuteReader();
            while (reader.Read())
                yield return reader.GetString(0);
            reader.Close();
        }
    }
}