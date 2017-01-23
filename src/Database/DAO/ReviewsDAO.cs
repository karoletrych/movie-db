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
                @"SELECT r.vote, r.content, mb.member_login
FROM 
  member mb JOIN review r on mb.member_login = r.member_login
  JOIN movie m ON m.movie_id = r.movie_id
WHERE 
  m.movie_id = @movie_id";
            command.Parameters.Add(new NpgsqlParameter("movie_id", movieId));
            var reader = command.ExecuteReader();
            while (reader.Read())
                yield return Tuple.Create(reader.GetFloat(0), reader.GetString(1), reader.GetString(2));
            reader.Close();
        }

        public void AddReview(string memberLogin, string content, int vote, int movieId)
        {
            var command = Connection.CreateCommand();
            command.CommandText =
                @"insert into review(member_login, content, vote, movie_id)
values(:member_login, :content, :vote, :movie_id)";
            command.Parameters.Add(new NpgsqlParameter("member_login", memberLogin));
            command.Parameters.Add(new NpgsqlParameter("content", content));
            command.Parameters.Add(new NpgsqlParameter("vote", vote));
            command.Parameters.Add(new NpgsqlParameter("movie_id", movieId));
            command.ExecuteNonQuery();
        }
    }
}