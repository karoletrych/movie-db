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
    }
}