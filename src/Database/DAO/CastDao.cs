﻿using System;
using System.Collections.Generic;
using Database.Model;
using Npgsql;

namespace Database.DAO
{
    public class CastDao : Dao
    {
        public CastDao(NpgsqlConnection connection) : base(connection)
        {
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

        public IEnumerable<Tuple<string,string>> GetCastOfMovie(int movieId)
        {
            var command = Connection.CreateCommand();
            command.CommandText =
                @"SELECT name, character
FROM 
  person p JOIN _cast c on p.person_id = c.person_id
  JOIN movie m ON m.movie_id = c.movie_id
WHERE 
  m.movie_id = @movie_id";
            command.Parameters.Add(new NpgsqlParameter("movie_id", movieId));
            var reader = command.ExecuteReader();
            while (reader.Read())
                yield return Tuple.Create(reader.GetString(0), reader.GetString(1));
            reader.Close();
        }
    }
}