using Npgsql;

namespace Database
{
    public static class DatabaseConnectionFactory
    {
        public static NpgsqlConnection Create()
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
            return connection;
        }
    }
}