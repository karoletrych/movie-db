using System;
using System.Globalization;
using System.Windows.Forms;
using Database.DAO;
using Database.Model;
using static System.String;

namespace GUI
{
    public partial class MovieView : Form
    {
        private const string ImagePath = @"http://image.tmdb.org/t/p/{0}//{1}";
        private readonly Movie _movie;

        public MovieView(int movieId)
        {
            _movie = new MovieDao().GetMovieById(movieId);
            InitializeComponent();
        }

        private void MovieView_Load(object sender, EventArgs e)
        {
            movieTitle.Text = _movie.Title;
            if (_movie.ReleaseDate != null)
                releaseDate.Text = _movie.ReleaseDate.Value.ToString("yyyy-MM-dd");
            revenue.Text = _movie.Revenue.ToString(CultureInfo.CurrentCulture);
            averageVote.Text = _movie.AverageVote.ToString(CultureInfo.CurrentCulture);

            status.Text = _movie.Status;
            try
            {
                var currentMovieImagePath = Format(ImagePath, "w185", _movie.PosterUrl);
                poster.ImageLocation = currentMovieImagePath;
            }
            catch (Exception)
            {
                // not crucial
            }
        }
    }
}