using System;
using System.Collections.Generic;
using Database.Model;
using Npgsql;

namespace Database.DAO
{
    public class MovieDao : Dao
    {
        public void InsertMovie(Movie movie)
        {
            var command = Connection.CreateCommand();
            command.CommandText =
                @"insert into movie (movie_id, release_date,
status, revenue, poster_url, title)
values(:movie_id, :release_date, :status,
:revenue, :poster_url, :title) on conflict(movie_id) DO NOTHING;";
            command.Parameters.AddRange(
                new[]
                {
                    new NpgsqlParameter("release_date", movie.ReleaseDate),
                    new NpgsqlParameter("status", movie.Status),
                    new NpgsqlParameter("poster_url", (object) movie.PosterUrl ?? DBNull.Value),
                    new NpgsqlParameter("title", movie.Title),
                    new NpgsqlParameter("revenue", movie.Revenue),
                    new NpgsqlParameter("movie_id", movie.MovieId)
                });
            command.ExecuteNonQuery();
        }

        public IEnumerable<Movie> GetMoviesByTitleLike(string title)
        {
            var command = Connection.CreateCommand();
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

        public Movie GetMovieById(int id)
        {
            var command = Connection.CreateCommand();
            command.CommandText =
                @"select * from movie where movie_id = @id";
            command.Parameters.AddWithValue("@id", id);
            var reader = command.ExecuteReader();
            if (!reader.Read())
                throw new NotFoundException();
            var movie = new Movie
            {
                MovieId = reader.GetInt32(0),
                ReleaseDate = reader.GetDateTime(1),
                Status = reader.GetString(2),
                Revenue = reader.GetDecimal(3),
                PosterUrl = reader.GetValue(4) != DBNull.Value ? reader.GetString(4) : null,
                Title = reader.GetString(5)
            };
            reader.Close();
            return movie;
        }
    }
}