using System;
using System.Security.Cryptography;
using Npgsql;

namespace Database.DAO
{
    public class Authorization : Dao
    {
        public Authorization(NpgsqlConnection connection) : base(connection)
        {
        }

        public void RegisterUser(string login, string email, string password)
        {
            var command = Connection.CreateCommand();
            command.CommandText =
                @"insert into member(member_login, email, password_hash)
values(:member_login, :email, :password_hash)";
            command.Parameters.Add(new NpgsqlParameter("member_login", login));
            command.Parameters.Add(new NpgsqlParameter("email", email));
            var hash = Hash(password);
            command.Parameters.Add(new NpgsqlParameter("password_hash", hash));
            command.ExecuteNonQuery();
        }

        public void LoginUser(string login, string password)
        {
            var command = Connection.CreateCommand();
            command.CommandText =
                @"SELECT password_hash FROM member WHERE
member_login = @member_login";
            command.Parameters.Add(new NpgsqlParameter("@member_login", login));
            var passwordHash = (string)command.ExecuteScalar();
            VerifyHash(password, passwordHash);
        }

        private string Hash(string password)
        {
            //STEP 1 Create the salt value with a cryptographic PRNG:
            byte[] salt;
            new RNGCryptoServiceProvider().GetBytes(salt = new byte[16]);

            //STEP 2 Create the Rfc2898DeriveBytes and get the hash value:
            var pbkdf2 = new Rfc2898DeriveBytes(password, salt, 10000);
            var hash = pbkdf2.GetBytes(20);

            //STEP 3 Combine the salt and password bytes for later use:
            var hashBytes = new byte[36];
            Array.Copy(salt, 0, hashBytes, 0, 16);
            Array.Copy(hash, 0, hashBytes, 16, 20);

            //STEP 4 Turn the combined salt+hash into a string for storage
            return Convert.ToBase64String(hashBytes);
        }

        private void VerifyHash(string enteredPassword, string savedPasswordHash)
        {
            /* Extract the bytes */
            byte[] hashBytes = Convert.FromBase64String(savedPasswordHash);
            /* Get the salt */
            byte[] salt = new byte[16];
            Array.Copy(hashBytes, 0, salt, 0, 16);
            /* Compute the hash on the password the user entered */
            var pbkdf2 = new Rfc2898DeriveBytes(enteredPassword, salt, 10000);
            byte[] hash = pbkdf2.GetBytes(20);
            /* Compare the results */
            for (int i = 0; i < 20; i++)
                if (hashBytes[i + 16] != hash[i])
                    throw new UnauthorizedAccessException();
        }
    }
}