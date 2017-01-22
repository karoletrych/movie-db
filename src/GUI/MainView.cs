using System;
using System.Linq;
using System.Windows.Forms;
using Database;
using Database.DAO;

namespace GUI
{
    public partial class MainView : Form
    {
        private readonly MovieDao _dao = new MovieDao();
        public MainView()
        {
            InitializeComponent();
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
            var films = _dao.GetMoviesByTitleLike(searchBox.Text).ToList();
            moviesView.DataSource = films.Select(x=> new {x.MovieId, x.Title, x.ReleaseDate}).ToList();
            moviesView.Columns[0].Visible = false;
        }

        private void filmsView_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            var s = moviesView.Rows[e.RowIndex];
            var id = (int)s.Cells[0].Value;
            var movieView = new MovieView(id);
            movieView.Show();
        }
    }
}
