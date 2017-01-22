using System;
using System.Globalization;
using System.Linq;
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
        private readonly CastDao _castDao;
        private readonly CountriesDao _countriesDao;
        private readonly CrewDao _crewDao;
        private readonly GenresDao _genresDao;
        private readonly Movie _movie;

        public MovieView(int movieId, NpgsqlConnection connection)
        {
            _countriesDao = new CountriesDao(connection);
            _genresDao = new GenresDao(connection);
            _movie = new MovieDao(connection).GetMovieById(movieId);
            _castDao = new CastDao(connection);
            _crewDao = new CrewDao(connection);
            InitializeComponent();
        }

        private void MovieView_Load(object sender, EventArgs e)
        {
            ShowBasicInfo();
            ShowCountries();
            ShowGenres();
            ShowCast();
            ShowCrew();
//            ShowUserReviews();
        }

        private void ShowUserReviews()
        {
            throw new NotImplementedException();
        }

        private void ShowCrew()
        {
            crew.Columns.Add("Zadanie");
            crew.Columns.Add("Osoba");
            crew.View = View.Details;
            var crewData = _crewDao.GetCrewFromMovie(_movie.MovieId).ToList();
            var departmentGroupedCrew = crewData.GroupBy(x => x.Item1);
            foreach (var department in departmentGroupedCrew)
            {
                var listViewGroup = new ListViewGroup(department.Key, HorizontalAlignment.Left)
                {
                    Name = department.Key
                };
                crew.Groups.Add(listViewGroup);
                foreach (var job in department)
                {
                    var listView = new ListViewItem(new[] {job.Item2, job.Item3})
                    {
                        Group = crew.Groups[department.Key]
                    };
                    crew.Items.Add(listView);
                }
            }
            crew.AutoResizeColumns(ColumnHeaderAutoResizeStyle.ColumnContent);
            crew.AutoResizeColumns(ColumnHeaderAutoResizeStyle.HeaderSize);
        }

        private void ShowCast()
        {
            cast.Columns.Add("Aktor");
            cast.Columns.Add("Postać");
            cast.View = View.Details;
            var castData = _castDao.GetCastOfMovie(_movie.MovieId);
            foreach (var tuple in castData)
                cast.Items.Add(new ListViewItem(new[] {tuple.Item1, tuple.Item2}));
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
    }
}