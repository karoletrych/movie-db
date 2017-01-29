using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;
using Database;
using Database.DAO;
using GUI.Properties;
using Npgsql;

namespace GUI
{
    public partial class MainView : Form
    {
        private readonly Authorization _authorization;
        private readonly NpgsqlConnection _connection = DatabaseConnectionFactory.Create();
        private readonly CountriesDao _countriesDao;
        private readonly GenresDao _genresDao;
        private readonly MovieDao _movieDao;

        public MainView()
        {
            InitializeComponent();
            _movieDao = new MovieDao();
            _authorization = new Authorization();
            _genresDao = new GenresDao();
            _countriesDao = new CountriesDao();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            passwordBox.UseSystemPasswordChar = true;
            var genresData = _genresDao.GetAllGenres();
            foreach (var genre in genresData)
                genres.Items.Add(genre.Name);

            var countriesData = _countriesDao.GetAllCountries();
            foreach (var country in countriesData)
                countries.Items.Add(country.Name);
        }

        private void searchBox_TextChanged(object sender, EventArgs e)
        {
            var films = _movieDao.GetMoviesByTitleLike(searchBox.Text).ToList();
            moviesView.DataSource = films.Select(x => new {x.MovieId, x.Title, x.ReleaseDate, x.AverageVote}).ToList();
            moviesView.Columns[0].Visible = false;
        }

        private void filmsView_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            var s = moviesView.Rows[e.RowIndex];
            var id = (int) s.Cells[0].Value;
            var movieView = new MovieView(id, _connection);
            movieView.Show();
        }

        private void register_Click(object sender, EventArgs e)
        {
            var registrationView = new RegistrationView();
            registrationView.Show();
        }

        private void login_Click(object sender, EventArgs e)
        {
            try
            {
                if (passwordBox.Text.Equals(""))
                {
                    MessageBox.Show(Resources.MainView_login_Click_passwordCannotBeEmpty);
                    return;
                }

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

        private void genresSelect_Click(object sender, EventArgs e)
        {
            MoveFromTo(genres, selectedGenres);
        }

        private void genresUnselect_Click(object sender, EventArgs e)
        {
            MoveFromTo(selectedGenres, genres);
        }

        private void selectCountry_Click(object sender, EventArgs e)
        {
            MoveFromTo(countries, selectedCountries);
        }

        private void unselectCountry_Click(object sender, EventArgs e)
        {
            MoveFromTo(selectedCountries, countries);
        }

        private void MoveFromTo(ListBox from, ListBox to)
        {
            var selected = from.SelectedItem;
            if (selected == null)
                return;
            to.Items.Add(selected);
            from.Items.Remove(selected);
        }

        private void search_Click(object sender, EventArgs e)
        {
            var genresList = new List<string>();
            foreach (var selectedGenresItem in selectedGenres.Items)
                genresList.Add(selectedGenresItem.ToString());

            var countriesList = new List<string>();
            foreach (var selectedCountriesItem in selectedCountries.Items)
                countriesList.Add(selectedCountriesItem.ToString());

            var films =
                _movieDao.GetMoviesByCriteria(releaseDateFrom: dateFrom.Value,
                    releaseDateTo: dateTo.Value,
                    voteAverageFrom: (int) voteFrom.Value,
                    voteAverageTo: (int) voteTo.Value,
                    genres: genresList,
                    countries: countriesList,
                    title: searchBox.Text,
                    voteCountFrom: (int) voteCountFrom.Value,
                    voteCountTo: (int) voteCountTo.Value);
            moviesView.DataSource = films.Select(movie => new
            {
                movie.MovieId,
                movie.Title,
                movie.ReleaseDate,
                movie.AverageVote
            }).ToList();
            moviesView.Columns[0].Visible = false;
        }
    }
}