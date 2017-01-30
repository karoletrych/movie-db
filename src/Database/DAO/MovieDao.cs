using System;
using System.Collections.Generic;
using System.Linq;
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
                @" INSERT INTO movie
            (
                        movie_id,
                        release_date,
                        status,
                        revenue,
                        poster_url,
                        title,
                        vote_average
            )
            VALUES
            (
                        :movie_id,
                        :release_date,
                        :status,
                        :revenue,
                        :poster_url,
                        :title,
                        :vote_average
            )
on conflict
            (
                        movie_id
            )
            do nothing;";
            command.Parameters.AddRange(
                new[]
                {
                    new NpgsqlParameter("release_date", movie.ReleaseDate),
                    new NpgsqlParameter("status", movie.Status),
                    new NpgsqlParameter("poster_url", (object) movie.PosterUrl ?? DBNull.Value),
                    new NpgsqlParameter("title", movie.Title),
                    new NpgsqlParameter("revenue", movie.Revenue),
                    new NpgsqlParameter("movie_id", movie.MovieId),
                    new NpgsqlParameter("vote_average", movie.AverageVote)
                });
            command.ExecuteNonQuery();
        }

        public IEnumerable<Movie> GetMoviesByTitleLike(string title)
        {
            var command = Connection.CreateCommand();
            command.CommandText =
                @"select * from movie where title ilike @title";
            command.Parameters.Add(new NpgsqlParameter("@title", "%" + title + "%"));
            var reader = command.ExecuteReader();
            while (reader.Read())
            {
                var movie = new Movie
                (
                    reader.GetDateTime(1),
                    reader.GetInt32(0),
                    reader.GetString(2),
                    reader.GetDecimal(3),
                    reader.GetValue(4) != DBNull.Value ? reader.GetString(4) : null,
                    reader.GetString(5),
                    reader.GetValue(6) != DBNull.Value ? reader.GetFloat(6) : (float?) null
                );
                yield return movie;
            }
            reader.Close();
        }

        public Movie GetMovieById(int id)
        {
            var command = Connection.CreateCommand();
            command.CommandText =
                @"select * from movie where movie_id = @id";
            command.Parameters.Add(new NpgsqlParameter("@id", id));
            var reader = command.ExecuteReader();
            if (!reader.Read())
                throw new NotFoundException();
            var movie = new Movie
            (
                reader.GetDateTime(1),
                reader.GetInt32(0),
                reader.GetString(2),
                reader.GetDecimal(3),
                reader.GetValue(4) != DBNull.Value ? reader.GetString(4) : null,
                reader.GetString(5),
                reader.GetValue(6) != DBNull.Value ? reader.GetFloat(6) : (float?) null
            );
            reader.Close();
            return movie;
        }

        public IEnumerable<Movie> GetMoviesByCriteria(DateTime releaseDateFrom, DateTime releaseDateTo,
            int voteAverageFrom,
            int voteAverageTo, IList<string> genres, IList<string> countries, string title,
            int voteCountFrom, int voteCountTo)
        {
            var command = Connection.CreateCommand();
            command.CommandText =
                @"
SELECT * FROM movie WHERE movie_id IN
(SELECT r.movie_id
FROM   movie m
       JOIN review r
         ON r.movie_id = m.movie_id
       JOIN movie_productioncountry mpc
         ON m.movie_id = mpc.movie_id
       JOIN country c
         ON c.country_id = mpc.country_id
       JOIN movie_genre mg
         ON m.movie_id = mg.movie_id
       JOIN genre g
         ON g.genre_id = mg.genre_id
WHERE  vote_average >= @vote_average_from
       AND vote_average <= @vote_average_to " +
                (genres.Any() ? "AND g.NAME IN ( @genres )" : "") +
                (countries.Any()
                    ? "AND c.NAME IN ( @countries )"
                    : "") +
                @"AND m.release_date >= @release_date_from
       AND m.release_date <= @release_date_to
       AND m.title ilike @title
GROUP  BY r.movie_id
HAVING Count(*) >= @vote_count_from
       AND Count(*) <= @vote_count_to);";
            var genresString = string.Join(",", genres);
            var countriesString = string.Join(",", countries);
            command.Parameters.AddRange(
                new[]
                {
                    new NpgsqlParameter("vote_average_from", voteAverageFrom),
                    new NpgsqlParameter("vote_average_to", voteAverageTo),
                    new NpgsqlParameter("genres", genresString),
                    new NpgsqlParameter("countries", countriesString),
                    new NpgsqlParameter("release_date_from", releaseDateFrom),
                    new NpgsqlParameter("release_date_to", releaseDateTo),
                    new NpgsqlParameter("title", "%" + title + "%"),
                    new NpgsqlParameter("vote_count_from", voteCountFrom),
                    new NpgsqlParameter("vote_count_to", voteCountTo),
                });
            var reader = command.ExecuteReader();
            while (reader.Read())
            {
                var movie = new Movie
                (
                    reader.GetDateTime(1),
                    reader.GetInt32(0),
                    reader.GetString(2),
                    reader.GetDecimal(3),
                    reader.GetValue(4) != DBNull.Value ? reader.GetString(4) : null,
                    reader.GetString(5),
                    reader.GetValue(6) != DBNull.Value ? reader.GetFloat(6) : (float?) null
                );
                yield return movie;
            }
            reader.Close();
        }

        public IEnumerable<Movie> GetTop100()
        {
            var command = Connection.CreateCommand();
            command.CommandText = "SELECT * FROM top100";
            var reader = command.ExecuteReader();
            while (reader.Read())
            {
                var movie = new Movie
                (
                    reader.GetDateTime(1),
                    reader.GetInt32(0),
                    reader.GetString(2),
                    reader.GetDecimal(3),
                    reader.GetValue(4) != DBNull.Value ? reader.GetString(4) : null,
                    reader.GetString(5),
                    reader.GetValue(6) != DBNull.Value ? reader.GetFloat(6) : (float?)null
                );
                yield return movie;
            }
            reader.Close();
        }
    }
}