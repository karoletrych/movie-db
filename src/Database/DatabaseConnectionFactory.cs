using Npgsql;

namespace Database
{
    public static class DatabaseConnectionFactory
    {
        private static NpgsqlConnection _connection;

        public static NpgsqlConnection Create()
        {
            if (_connection == null)
            {
                var connectionStringBuilder = new NpgsqlConnectionStringBuilder
                {
                    Port = 5432,
                    Database = "postgres",
                    Username = "postgres",
                    Password = "q",
                    SearchPath = "moviedb",
                    Host = "localhost"
                };
                var connection = new NpgsqlConnection(connectionStringBuilder);
                connection.Open();
                _connection = connection;
            }
            return _connection;
        }
    }
}