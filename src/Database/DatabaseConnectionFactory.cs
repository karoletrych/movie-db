using System.Configuration;
using Npgsql;

namespace Database
{
    public static class DatabaseConnectionFactory
    {
        private static NpgsqlConnection _connection;

        public static NpgsqlConnection Create()
        {
            if (_connection != null)
                return _connection;
            var connectionString = ConfigurationManager.ConnectionStrings[0];
            var connection = new NpgsqlConnection(connectionString.ConnectionString);
            connection.Open();
            _connection = connection;
            return _connection;
        }
    }
}