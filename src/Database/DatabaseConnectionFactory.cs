using Database.Properties;
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
            var connectionString = Resources.ConnectionString;
            var connection = new NpgsqlConnection(connectionString);
            connection.Open();
            _connection = connection;
            return _connection;
        }
    }
}