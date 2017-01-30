using System;
using Npgsql;

namespace Database.DAO
{
    public class Authorization : Dao
    {
        public void RegisterUser(string login, string email, string password)
        {
            var command = Connection.CreateCommand();
            command.CommandText =
                @"SELECT create_member(@member_login, @email, @password)";
            command.Parameters.Add(new NpgsqlParameter("member_login", login));
            command.Parameters.Add(new NpgsqlParameter("email", email));
            command.Parameters.Add(new NpgsqlParameter("password", password));
            command.ExecuteNonQuery();
        }

        public string LoginUser(string login, string password)
        {
            var command = Connection.CreateCommand();
            command.CommandText =
                @"SELECT login_member(@login, @password)";
            command.Parameters.Add(new NpgsqlParameter("login", login));
            command.Parameters.Add(new NpgsqlParameter("password", password));
            var loggedUserLogin = command.ExecuteScalar();
            if(loggedUserLogin == DBNull.Value)
                throw new UnauthorizedAccessException();
            return (string)loggedUserLogin;
        }
    }
}


//SELECT create_member( 'ssdasds', 'dsasdas@gmail.com', 'asdasd');
//SELECT login_member('ssdasds', 'asdasd');
