using Npgsql;

namespace Database.DAO
{
    public abstract class Dao
    {
        protected readonly NpgsqlConnection Connection;

        protected Dao()
        {
            Connection = DatabaseConnectionFactory.Create();
        }
    }
}