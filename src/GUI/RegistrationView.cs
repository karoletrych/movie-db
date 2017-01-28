using System;
using System.Windows.Forms;
using Database.DAO;
using Npgsql;

namespace GUI
{
    public partial class RegistrationView : Form
    {
        private readonly Authorization _authorization;
        public RegistrationView(NpgsqlConnection connection)
        {
            InitializeComponent();
            _authorization = new Authorization(connection);
        }

        private void RegistrationView_Load(object sender, EventArgs e)
        {
            password.UseSystemPasswordChar = true;
        }

        private void register_Click(object sender, EventArgs e)
        {
            _authorization.RegisterUser(login.Text, email.Text, password.Text);
            Close();
        }
    }
}
