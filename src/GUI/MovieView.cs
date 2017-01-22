using System;
using System.Globalization;
using System.Windows.Forms;
using Database.DAO;
using Database.Model;
using Npgsql;
using static System.String;

namespace GUI
{
    public partial class MovieView : Form
    {
        private const string ImagePath = @"http://image.tmdb.org/t/p/{0}//{1}";
        private const string ImageSize = "w185";
        private readonly Movie _movie;
        private readonly CountriesDao _countriesDao;
        private readonly GenresDao _genresDao;
        private readonly CastDao _castDao;

        public MovieView(int movieId, NpgsqlConnection connection)
        {
            _countriesDao = new CountriesDao(connection);
            _genresDao = new GenresDao(connection);
            _movie = new MovieDao(connection).GetMovieById(movieId);
            _castDao = new CastDao(connection);
            InitializeComponent();
        }

        private void MovieView_Load(object sender, EventArgs e)
        {
            ShowBasicInfo();
            ShowCountries();
            ShowGenres();
            ShowCast();
//            ShowCrew();
//            ShowUserReviews();
        }

        private void ShowUserReviews()
        {
            throw new NotImplementedException();
        }

        private void ShowCrew()
        {
            throw new NotImplementedException();
        }

        private void ShowCast()
        {
            cast.Columns.Add("Aktor");
            cast.Columns.Add("Postać");
            cast.View = View.Details;
            var castData = _castDao.GetCastOfMovie(_movie.MovieId);
            foreach (var tuple in castData)
            {
                cast.Items.Add(new ListViewItem(new[] { tuple.Item1, tuple.Item2}));
            }
            cast.AutoResizeColumns(ColumnHeaderAutoResizeStyle.ColumnContent);
            cast.AutoResizeColumns(ColumnHeaderAutoResizeStyle.HeaderSize);
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
            revenue.Text = _movie.Revenue.ToString(CultureInfo.CurrentCulture);
            if (_movie.AverageVote != null)
                averageVote.Text = _movie.AverageVote.Value.ToString(CultureInfo.CurrentCulture);

            status.Text = _movie.Status;
            var currentMovieImagePath = Format(ImagePath, ImageSize, _movie.PosterUrl);
            poster.ImageLocation = currentMovieImagePath;
        }

        private void label7_Click(object sender, EventArgs e)
        {

        }
    }
}