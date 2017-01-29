using Npgsql;

namespace Database.DAO
{
    public abstract class Dao
    {
        protected readonly NpgsqlConnection Connection;

        protected Dao(NpgsqlConnection connection)
        {
            Connection = connection;
        }
    }
}