using System;
using System.Globalization;
using System.Linq;
using System.Windows.Forms;
using Database.DAO;
using Database.Model;
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

        public MovieView(int movieId)
        {
            _countriesDao = new CountriesDao();
            _genresDao = new GenresDao();
            _movie = new MovieDao().GetMovieById(movieId);
            InitializeComponent();
        }

        private void MovieView_Load(object sender, EventArgs e)
        {
            ShowBasicInfo();
            ShowCountries();
            ShowGenres();
//            ShowCast();
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
            throw new NotImplementedException();
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
            averageVote.Text = _movie.AverageVote.ToString(CultureInfo.CurrentCulture);

            status.Text = _movie.Status;
            var currentMovieImagePath = Format(ImagePath, ImageSize, _movie.PosterUrl);
            poster.ImageLocation = currentMovieImagePath;
        }
    }
}