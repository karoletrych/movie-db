using System;
using System.Collections.Generic;
using Database.Model;
using Npgsql;

namespace Database.DAO
{
    public class CrewDao : Dao
    {
        

        public CrewDao(NpgsqlConnection connection) : base(connection)
        {
        }

        public void InsertCrew(Crew crew)
        {
            var command = Connection.CreateCommand();
            command.CommandText =
                @"insert into crew (person_id, movie_id, job_name)
values(:person_id, :movie_id, :job_name) on conflict do nothing";
            command.Parameters.Add(new NpgsqlParameter("person_id", crew.PersonId));
            command.Parameters.Add(new NpgsqlParameter("movie_id", crew.MovieId));
            command.Parameters.Add(new NpgsqlParameter("job_name", crew.JobName));
            command.ExecuteNonQuery();
        }

        public IEnumerable<Tuple<string, string, string>> GetCrewFromMovie(int movieId)
        {
            var command = Connection.CreateCommand();
            command.CommandText =
                @"SELECT d.name as department_name, c.job_name, p.name AS person_name
FROM person  p
JOIN crew c
ON p.person_id = c.person_id
JOIN movie m
ON m.movie_id= c.movie_id
JOIN job j
ON j.job_name = c.job_name
JOIN department d
ON d.department_id = j.department_id
WHERE 
  m.movie_id = @movie_id";
            command.Parameters.Add(new NpgsqlParameter("movie_id", movieId));
            var reader = command.ExecuteReader();
            while (reader.Read())
                yield return Tuple.Create(reader.GetString(0), reader.GetString(1), reader.GetString(2));
            reader.Close();

           
        }
    }
}