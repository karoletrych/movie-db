using System;
using System.Collections.Generic;
using Database.Model;
using Npgsql;

namespace Database.DAO
{
    public class PersonDao : Dao
    {
        public void InsertPerson(Person person)
        {
            var command = Connection.CreateCommand();
            command.CommandText =
                @" INSERT INTO person
            (
                        person_id,
                        birthday,
                        deathday,
                        biography,
                        gender,
                        place_of_birth,
                        NAME
            )
            VALUES
            (
                        :person_id,
                        :birthday,
                        :deathday,
                        :biography,
                        :gender,
                        :place_of_birth,
                        :name
            )
on conflict do nothing ";
            command.Parameters.Add(new NpgsqlParameter("person_id", person.PersonId));
            command.Parameters.Add(new NpgsqlParameter("birthday", (object) person.BirthDay ?? DBNull.Value));
            command.Parameters.Add(new NpgsqlParameter("deathday", (object) person.DeathDay ?? DBNull.Value));
            command.Parameters.Add(new NpgsqlParameter("biography", person.Biography ?? ""));
            command.Parameters.Add(new NpgsqlParameter("gender", person.Gender));
            command.Parameters.Add(new NpgsqlParameter("place_of_birth", person.PlaceOfBirth ?? ""));
            command.Parameters.Add(new NpgsqlParameter("name", person.Name));
            command.ExecuteNonQuery();
        }

        public Person GetPersonById(int personId)
        {
            var command = Connection.CreateCommand();
            command.CommandText =
                @"SELECT * FROM person WHERE person_id = @person_id";
            command.Parameters.Add(new NpgsqlParameter("@person_id", personId));
            var reader = command.ExecuteReader();
            if (!reader.Read())
                throw new NotFoundException();
            var person = new Person(
                reader.GetString(6),
                personId,
                reader.GetValue(1) != DBNull.Value ? reader.GetDateTime(1) : (DateTime?) null,
                reader.GetValue(2) != DBNull.Value ? reader.GetDateTime(2) : (DateTime?) null,
                reader.GetString(3),
                reader.GetInt32(4),
                reader.GetString(5)
            );
            reader.Close();
            return person;
        }

        public class Director
        {
            public string Name { get; }
            public double VoteAverage { get; }
            public int Id { get; }

            public Director(int id, string name, double voteAverage)
            {
                Name = name;
                VoteAverage = voteAverage;
                Id = id;
            }
        }

        public class PersonDto
        {
            public string Name { get; }
            public int Id { get; }

            public PersonDto(int id, string name)
            {
                Name = name;
                Id = id;
            }
        }

        public IEnumerable<Director> GetTop100Directors()
        {
            var command = Connection.CreateCommand();
            command.CommandText = "SELECT * FROM top100director";
            var reader = command.ExecuteReader();
            while (reader.Read())
            {
                var person = new Director(
                    reader.GetInt32(0),
                    reader.GetString(1),
                    reader.GetDouble(2)
                );
                yield return person;
            }
            reader.Close();
        }

        public IEnumerable<PersonDto> GetAllPersons()
        {
            var command = Connection.CreateCommand();
            command.CommandText = "SELECT person_id, name FROM person ORDER BY person_id ASC";
            var reader = command.ExecuteReader();
            while (reader.Read())
            {
                var person = new PersonDto(
                    reader.GetInt32(0),
                    reader.GetString(1)
                );
                yield return person;
            }
            reader.Close();
        }
    }
}