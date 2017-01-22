using System;
using System.Collections.Generic;
using Database.Model;
using Npgsql;

namespace Database.DAO
{
    public class Dao
    {
        protected readonly NpgsqlConnection Connection;

        public Dao(NpgsqlConnection connection)
        {
            Connection = connection;
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