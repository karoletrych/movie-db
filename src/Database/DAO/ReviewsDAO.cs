using System;
using System.Collections.Generic;
using Npgsql;

namespace Database.DAO
{
    public class ReviewsDao : Dao
    {
        public ReviewsDao(NpgsqlConnection connection) : base(connection)
        {
        }

        public IEnumerable<Tuple<float, string, string>> GetReviewsOfMovie(int movieId)
        {
            var command = Connection.CreateCommand();
            command.CommandText =
                @"SELECT r.vote, r.content, login
FROM 
  member  JOIN review r on user_id = r.user_id
  JOIN movie m ON m.movie_id = r.movie_id
WHERE 
  m.movie_id = @movie_id";
            command.Parameters.Add(new NpgsqlParameter("movie_id", movieId));
            var reader = command.ExecuteReader();
            while (reader.Read())
                yield return Tuple.Create(reader.GetFloat(0), reader.GetString(1), reader.GetString(2));
            reader.Close();
        }
    }
}