﻿using System;
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
        private readonly PersonDao _personDao;

        public MainView()
        {
            InitializeComponent();
            _personDao = new PersonDao();
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
        }

        private void filmsView_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex == -1)
                return;
            var s = moviesView.Rows[e.RowIndex];
            var id = (int) s.Cells[0].Value;
            var movieView = new MovieView(id);
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
                _movieDao.GetMoviesByCriteria(
                    dateFrom.Value,
                    dateTo.Value,
                    (int) voteFrom.Value,
                    (int) voteTo.Value,
                    genresList,
                    countriesList,
                    searchBox.Text,
                    (int) voteCountFrom.Value,
                    (int) voteCountTo.Value);
            moviesView.DataSource = films.Select(movie => new
            {
                movie.MovieId,
                movie.Title,
                movie.ReleaseDate,
                movie.AverageVote
            }).ToList();
            moviesView.Columns[0].Visible = false;
        }

        private void top100_Click(object sender, EventArgs e)
        {
            var films = _movieDao.GetTop100();
            moviesView.DataSource = films.Select(movie => new
            {
                movie.MovieId,
                movie.Title,
                movie.ReleaseDate,
                movie.AverageVote
            }).ToList();
        }

        private void top100director_Click(object sender, EventArgs e)
        {
            var persons = _personDao.GetTop100Directors();
            personView.DataSource = persons.Select(x=> new {x.Id, x.Name, x.VoteAverage}).ToList();
        }

        private void personView_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex == -1)
                return;
            var s = personView.Rows[e.RowIndex];
            var id = (int)s.Cells[0].Value;
            var person = new PersonView(id);
            person.Show();
        }

        private void allPerson_Click(object sender, EventArgs e)
        {
            var persons = _personDao.GetAllPersons();
            personView.DataSource = persons.Select(x => new { x.Id, x.Name }).ToList();
        }

        private void addMovie_Click(object sender, EventArgs e)
        {
            if (CheckIfNotAdmin()) return;
            var addMovieView = new AddMovieView();
            addMovieView.Show();
        }

        private static bool CheckIfNotAdmin()
        {
            if (LoggedUser.Login != "admin")
            {
                MessageBox.Show(Resources.MainView_addMovie_Click_Not_authorized);
                return true;
            }
            return false;
        }

        private void deleteMovie_Click(object sender, EventArgs e)
        {
            if (CheckIfNotAdmin()) return;
            var deleteView = new DeleteView();
            deleteView.Show();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (CheckIfNotAdmin()) return;
            var addPersonView = new AddPersonView();
            addPersonView.Show();
        }

        private void logout_Click(object sender, EventArgs e)
        {
            LoggedUser.Login = null;
            loggedUser.Text = "";
        }
    }
}