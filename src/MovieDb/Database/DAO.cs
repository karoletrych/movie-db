using System;
using System.Collections.Generic;
using Npgsql;

namespace Database
{
    public class DAO
    {
        private const string ConnectionString = @"Server=127.0.0.1;
Port=5432;
Database=postgres;
User Id=postgres;
Password=q;
Search Path=filmdb";

        private readonly NpgsqlConnection _connection;

        public DAO()
        {
            _connection = new NpgsqlConnection(ConnectionString);
            _connection.Open();
        }

        public void InsertFilm(film film)
        {
            var command = _connection.CreateCommand();
            command.CommandText =
                @"insert into film (film_id, data_premiery,
status, dochod, url_plakatu, tytul)
values(:film_id, :data_premiery, :status,
:dochod, :url_plakatu, :tytul)";
            command.Parameters.Add(new NpgsqlParameter("film_id", film.FilmId));
            command.Parameters.Add(new NpgsqlParameter("data_premiery", film.DataPremiery));
            command.Parameters.Add(new NpgsqlParameter("status", film.Status));
            command.Parameters.Add(new NpgsqlParameter("url_plakatu", (object) film.UrlPlakatu ?? DBNull.Value));
            command.Parameters.Add(new NpgsqlParameter("tytul", film.Tytul));
            command.Parameters.Add(new NpgsqlParameter("film_id", film.FilmId));
            command.Parameters.Add(new NpgsqlParameter("dochod", film.Dochod));
            command.ExecuteNonQuery();
        }

        public IEnumerable<film> GetFilmsByTitleLike(string title)
        {
            var command = _connection.CreateCommand();
            command.CommandText =
                @"select * from film where tytul ilike @title";
            command.Parameters.AddWithValue("@title", "%" + title + "%");
            var reader = command.ExecuteReader();
            while(reader.Read())
            {
                var film = new film
                {
                    FilmId = reader.GetInt32(0),
                    DataPremiery = reader.GetDateTime(1),
                    Status = reader.GetString(2),
                    Dochod = reader.GetDecimal(3),
                    UrlPlakatu = reader.GetValue(4) != DBNull.Value?reader.GetString(4):null,
                    Tytul = reader.GetString(5)
                };
                yield return film;
            }
            reader.Close();
        }

        public void InsertCountries(ICollection<kraj> krajs)
        {
            var command = _connection.CreateCommand();
            foreach (var kraj in krajs)
            {
                command.CommandText =
                @"insert into kraj (kraj_id, nazwa)
values(:kraj_id, :nazwa) ON CONFLICT (kraj_id) DO UPDATE 
  SET kraj_id = excluded.kraj_id, 
      nazwa = excluded.nazwa;";
                command.Parameters.Add(new NpgsqlParameter("kraj_id", kraj.KrajId));
                command.Parameters.Add(new NpgsqlParameter("nazwa", kraj.Nazwa));
                command.ExecuteNonQuery();
            }
        }

        public void InsertFilm_Countries(int filmId, IEnumerable<string> countries)
        {
            var command = _connection.CreateCommand();
            foreach (var country in countries)
            {
                command.CommandText =
                @"insert into film_krajprodukcji(kraj_id, film_id)
values(:kraj_id, :film_id)";
                command.Parameters.Add(new NpgsqlParameter("kraj_id", country));
                command.Parameters.Add(new NpgsqlParameter("film_id", filmId));
                command.ExecuteNonQuery();
            }
        }
    }
}