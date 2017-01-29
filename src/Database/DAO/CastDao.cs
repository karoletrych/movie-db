using System;
using System.Collections.Generic;
using Database.Model;
using Npgsql;

namespace Database.DAO
{
    public class CastDao : Dao
    {
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

        public IEnumerable<Tuple<string,string, int>> GetCastOfMovie(int movieId)
        {
            var command = Connection.CreateCommand();
            command.CommandText =
                @"SELECT name, character, p.person_id
FROM 
  person p JOIN _cast c on p.person_id = c.person_id
  JOIN movie m ON m.movie_id = c.movie_id
WHERE 
  m.movie_id = @movie_id";
            command.Parameters.Add(new NpgsqlParameter("movie_id", movieId));
            var reader = command.ExecuteReader();
            while (reader.Read())
                yield return Tuple.Create(reader.GetString(0), reader.GetString(1), reader.GetInt32(2));
            reader.Close();
        }

        public IEnumerable<Tuple<string, string, int>> GetCastOfPerson(int personId)
        {
            var command = Connection.CreateCommand();
            command.CommandText =
                @"SELECT m.title, character, m.movie_id
FROM 
  person p JOIN _cast c on p.person_id = c.person_id
  JOIN movie m ON m.movie_id = c.movie_id
WHERE 
  p.person_id = @person_id";
            command.Parameters.Add(new NpgsqlParameter("person_id", personId));
            var reader = command.ExecuteReader();
            while (reader.Read())
                yield return Tuple.Create(reader.GetString(0), reader.GetString(1), reader.GetInt32(2));
            reader.Close();
        }
    }
}