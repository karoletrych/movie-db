using System.Collections.Generic;
using Database.Model;
using Npgsql;

namespace Database.DAO
{
    public class CountriesDao : Dao
    {
        public void InsertCountries(ICollection<Country> countrys)
        {
            var command = Connection.CreateCommand();
            foreach (var country in countrys)
            {
                command.CommandText =
                    @"insert into country (country_id, name)
values(:country_id, :name) ON CONFLICT (country_id) DO NOTHING;";
                command.Parameters.Add(new NpgsqlParameter("country_id", country.CountryId));
                command.Parameters.Add(new NpgsqlParameter("name", country.Name));
                command.ExecuteNonQuery();
            }
        }

        public void InsertMovieCountries(int movieId, IEnumerable<string> countries)
        {
            var command = Connection.CreateCommand();
            foreach (var country in countries)
            {
                command.CommandText =
                    @"insert into movie_productioncountry(country_id, movie_id)
values(:country_id, :movie_id)";
                command.Parameters.Add(new NpgsqlParameter("country_id", country));
                command.Parameters.Add(new NpgsqlParameter("movie_id", movieId));
                command.ExecuteNonQuery();
            }
        }

        public IEnumerable<string> GetCountryNamesOfMovie(int movieId)
        {
            var command = Connection.CreateCommand();
            command.CommandText =
                @"SELECT c.country_id
FROM 
  country c JOIN movie_productioncountry mc on c.country_id = mc.country_id
  JOIN movie m ON m.movie_id = mc.movie_id
WHERE 
  m.movie_id = @movie_id";
            command.Parameters.Add(new NpgsqlParameter("movie_id", movieId));
            var reader = command.ExecuteReader();
            while (reader.Read())
                yield return reader.GetString(0);
            reader.Close();
        }

        public IEnumerable<Country> GetAllCountries()
        {
            var command = Connection.CreateCommand();
            command.CommandText =
                @"SELECT * FROM country";
            var reader = command.ExecuteReader();
            while (reader.Read())
                yield return new Country(reader.GetString(0), reader.GetString(1));
            reader.Close();
        }
    }
}