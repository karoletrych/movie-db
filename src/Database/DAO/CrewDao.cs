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

        public IEnumerable<Tuple<string, string, string, int>> GetCrewFromMovie(int movieId)
        {
            var command = Connection.CreateCommand();
            command.CommandText =
                @"SELECT d.name as department_name, c.job_name, p.name AS person_name, p.person_id
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
                yield return
                    Tuple.Create(reader.GetString(0), reader.GetString(1), reader.GetString(2), reader.GetInt32(3));
            reader.Close();
        }

        public IEnumerable<Tuple<string, string, string, int>> GetCrewOfPerson(int personId)
        {
            var command = Connection.CreateCommand();
            command.CommandText =
                @"SELECT d.name as department_name, c.job_name, m.title AS person_name, m.movie_id
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
  p.person_id = @person_id";
            command.Parameters.Add(new NpgsqlParameter("person_id", personId));
            var reader = command.ExecuteReader();
            while (reader.Read())
                yield return
                    Tuple.Create(reader.GetString(0), reader.GetString(1), reader.GetString(2), reader.GetInt32(3));
            reader.Close();
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
    }
}