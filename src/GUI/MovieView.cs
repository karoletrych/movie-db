using System;
using System.Globalization;
using System.Linq;
using System.Windows.Forms;
using Database.DAO;
using Database.Model;
using GUI.Properties;
using Npgsql;
using static System.String;

namespace GUI
{
    public partial class MovieView : Form
    {
        private const string ImagePath = @"http://image.tmdb.org/t/p/{0}//{1}";
        private const string ImageSize = "w185";
        private readonly CastDao _castDao;
        private readonly NpgsqlConnection _connection;
        private readonly CountriesDao _countriesDao;
        private readonly CrewDao _crewDao;
        private readonly GenresDao _genresDao;
        private readonly Movie _movie;
        private readonly PersonDao _personDao;
        private readonly ReviewsDao _reviewsDao;

        public MovieView(int movieId, NpgsqlConnection connection)
        {
            _connection = connection;
            _countriesDao = new CountriesDao();
            _genresDao = new GenresDao();
            _movie = new MovieDao().GetMovieById(movieId);
            _castDao = new CastDao();
            _crewDao = new CrewDao();
            _reviewsDao = new ReviewsDao();
            _personDao = new PersonDao();
            InitializeComponent();
        }

        public void MovieView_Load(object sender, EventArgs e)
        {
            ShowBasicInfo();
            ShowCountries();
            ShowGenres();
            ShowCast();
            ShowCrew();
            ShowUserReviews();
        }

        private void ShowUserReviews()
        {
            reviews.View = View.Details;
            reviews.Columns.Add("ocena");
            reviews.Columns.Add("recenzja");
            reviews.Columns.Add("recenzent");
            var reviewsData = _reviewsDao.GetReviewsOfMovie(_movie.MovieId);
            foreach (var tuple in reviewsData)
                reviews.Items.Add(
                    new ListViewItem(new[]
                    {
                        tuple.Item1.ToString(CultureInfo.CurrentCulture), tuple.Item2.TruncateLongString(180),
                        tuple.Item3
                    }));
            reviews.AutoResizeColumns(ColumnHeaderAutoResizeStyle.ColumnContent);
            reviews.AutoResizeColumns(ColumnHeaderAutoResizeStyle.HeaderSize);
        }

        private void ShowCrew()
        {
            var crewData = _crewDao.GetCrewFromMovie(_movie.MovieId).ToList();
            crew.DataSource = crewData;

            foreach (DataGridViewRow row in crew.Rows)
            {
                var linkCell = new DataGridViewLinkCell
                {
                    Value = row.Cells[2].Value
                };
                row.Cells[2] = linkCell;
            }
            crew.Columns[0].HeaderText = Resources.MovieView_ShowCrew_Category;
            crew.Columns[1].HeaderText = Resources.MovieView_ShowCrew_Job;
            crew.Columns[2].HeaderText = Resources.MovieView_ShowCrew_Person;
            crew.Columns[3].Visible = false;
        }

        private void ShowCast()
        {
            var castData = _castDao.GetCastOfMovie(_movie.MovieId).ToList();
            cast.DataSource = castData;

            foreach (DataGridViewRow row in cast.Rows)
            {
                var linkCell = new DataGridViewLinkCell
                {
                    Value = row.Cells[0].Value
                };
                row.Cells[0] = linkCell;
            }
            cast.Columns[0].HeaderText = Resources.MovieView_ShowCast_Actor;
            cast.Columns[1].HeaderText = Resources.MovieView_ShowCast_Character;
            cast.Columns[2].Visible = false;
        }

        private void ShowGenres()
        {
            var genreNames = _genresDao.GetGenresOfMovie(_movie.MovieId);
            genres.Text = Join(", ", genreNames);
        }

        private void ShowCountries()
        {
            var countries = _countriesDao.GetCountryNamesOfMovie(_movie.MovieId);
            productionCountries.Text = Join(", ", countries);
        }

        private void ShowBasicInfo()
        {
            movieTitle.Text = _movie.Title;
            if (_movie.ReleaseDate != null)
                releaseDate.Text = _movie.ReleaseDate.Value.ToString("yyyy-MM-dd");
            revenue.Text = _movie.Revenue != 0 ? _movie.Revenue.ToString(CultureInfo.CurrentCulture) + " USD" : "nieznany";
            if (_movie.AverageVote != null)
                averageVote.Text = _movie.AverageVote.Value.ToString(CultureInfo.CurrentCulture);

            status.Text = _movie.Status;
            var currentMovieImagePath = Format(ImagePath, ImageSize, _movie.PosterUrl);
            poster.ImageLocation = currentMovieImagePath;
        }

        private void addReview_Click(object sender, EventArgs e)
        {
            var addReviewView = new AddReview(_reviewsDao, _movie.MovieId, this);
            addReviewView.Show();
        }

        private void cast_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex == -1)
                return;
            if (cast[e.ColumnIndex, e.RowIndex] is DataGridViewLinkCell)
            {
                var personId = (int) cast[2, e.RowIndex].Value;
                var personView = new PersonView(personId, _personDao, _crewDao, _castDao, _connection);
                personView.Show();
                Close();
            }
        }

        private void crew_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex == -1)
                return;
            if (crew[e.ColumnIndex, e.RowIndex] is DataGridViewLinkCell)
            {
                var personId = (int) crew[3, e.RowIndex].Value;
                var personView = new PersonView(personId, _personDao, _crewDao, _castDao, _connection);
                personView.Show();
                Close();
            }
        }
    }
}