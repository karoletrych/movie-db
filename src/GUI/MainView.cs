using System;
using System.Linq;
using System.Windows.Forms;
using Database;
using Database.DAO;
using Npgsql;

namespace GUI
{
    public partial class MainView : Form
    {
        private readonly NpgsqlConnection _connection = DatabaseConnectionFactory.Create();
        private readonly MovieDao _movieDao;

        public MainView()
        {
            InitializeComponent();
            _movieDao = new MovieDao(_connection);
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
    }
}
