using System;
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
    }
}