using System;
using System.Linq;
using System.Linq.Expressions;
using System.Windows.Forms;
using Database;
using Database.DAO;
using GUI.Properties;
using Npgsql;

namespace GUI
{
    public partial class MainView : Form
    {
        private readonly NpgsqlConnection _connection = DatabaseConnectionFactory.Create();
        private readonly MovieDao _movieDao;
        private readonly Authorization _authorization;

        public MainView()
        {
            InitializeComponent();
            _movieDao = new MovieDao(_connection);
            _authorization = new Authorization(_connection);
        }

        private void button1_Click(object sender, EventArgs e)
        {

        }

        private void Form1_Load(object sender, EventArgs e)
        {
            passwordBox.UseSystemPasswordChar = true;
        }

        private void searchBox_TextChanged(object sender, EventArgs e)
        {
            var films = _movieDao.GetMoviesByTitleLike(searchBox.Text).ToList();
            moviesView.DataSource = films.Select(x=> new {x.MovieId, x.Title, x.ReleaseDate}).ToList();
            moviesView.Columns[0].Visible = false;
        }

        private void filmsView_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            var s = moviesView.Rows[e.RowIndex];
            var id = (int)s.Cells[0].Value;
            var movieView = new MovieView(id, _connection);
            movieView.Show();
        }

        private void register_Click(object sender, EventArgs e)
        {
            var registrationView = new RegistrationView(_connection);
            registrationView.Show();
        }

        private void login_Click(object sender, EventArgs e)
        {
            try
            {
                var enteredLogin = loginBox.Text;
                _authorization.LoginUser(enteredLogin, passwordBox.Text);
                LoggedUser.Login = enteredLogin;
                loggedUser.Text = enteredLogin;
                loginBox.Text = "";
                passwordBox.Text = "";
            }
            catch (UnauthorizedAccessException)
            {
                MessageBox.Show(Resources.MainView_login_Click_WrongPassword);
            }
        }
    }
}
