using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;
using Database.DAO;
using Database.Model;

namespace GUI
{
    public partial class AddMovieView : Form
    {
        private readonly CastDao _castDao;
        private readonly CountriesDao _countriesDao;
        private readonly CrewDao _crewDao;
        private readonly GenresDao _genresDao;
        private readonly MovieDao _movieDao;
        private readonly PersonDao _personDao;

        public AddMovieView()
        {
            InitializeComponent();
            _castDao = new CastDao();
            _personDao = new PersonDao();
            _genresDao = new GenresDao();
            _countriesDao = new CountriesDao();
            _crewDao = new CrewDao();
            _movieDao = new MovieDao();

            var persons =
                _personDao
                    .GetAllPersons()
                    .Select(personDto => $"{personDto.Name}/{personDto.Id}")
                    .OrderBy(s => s);

            castPerson.DataSource = persons.ToList();
            crewPerson.DataSource = persons.ToList();

            var genresData = _genresDao.GetAllGenres();
            foreach (var genre in genresData)
                genres.Items.Add($"{genre.Name}/{genre.GenreId}");

            var countriesData = _countriesDao.GetAllCountries();
            foreach (var country in countriesData)
                countries.Items.Add($"{country.Name}/{country.CountryId}");

            var jobsData = _crewDao.GetAllJobs().OrderBy(x => x);
            crewJob.DataSource = jobsData.ToList();
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

        private void addCast_Click(object sender, EventArgs e)
        {
            var cast = $"{castCharacter.Text}/{castPerson.Text}";
            castListbox.Items.Add(cast);
        }

        private void addCrew_Click(object sender, EventArgs e)
        {
            var crew = $"{crewJob.Text}/{crewPerson.Text}";
            crewListbox.Items.Add(crew);
        }

        private void removeCast_Click(object sender, EventArgs e)
        {
            if (castListbox.SelectedItem != null)
                castListbox.Items.Remove(castListbox.SelectedItem);
        }

        private void removeCrew_Click(object sender, EventArgs e)
        {
            if (crewListbox.SelectedItem != null)
                crewListbox.Items.Remove(crewListbox.SelectedItem);
        }

        private void addMovie_Click(object sender, EventArgs e)
        {
            var movie = new Movie(releaseDate.Value.Date,
                (int) id.Value,
                status.Text,
                revenue.Value,
                posterUrl.Text,
                title.Text,
                0);

            try
            {
                _movieDao.InsertMovie(movie);
                var countriesList =
                    (from object country in selectedCountries.Items select SplitInto2Vars(country.ToString()).Item2)
                    .ToList();
                var movieId = int.Parse(id.Text);
                _countriesDao.InsertMovieCountries(movieId, countriesList);

                var genresList = new List<string>();
                genresList.AddRange(from object genre in selectedGenres.Items select genre.ToString());
                _genresDao.InsertMovieGenres(genresList.Select(x =>
                {
                    var genreId = int.Parse(SplitInto2Vars(x).Item2);
                    return new MovieGenre(movieId, genreId);
                }));

                foreach (var crewItem in crewListbox.Items)
                {
                    var separated = SplitInto3Vars(crewItem.ToString());
                    var crewPersonId = int.Parse(separated.Item3);
                    var crew = new Crew(crewPersonId, movieId, crewJob.Text);
                    _crewDao.InsertCrew(crew);
                }
                foreach (var castItem in castListbox.Items)
                {
                    var separate = SplitInto3Vars(castItem.ToString());
                    var castPersonId = int.Parse(separate.Item3);
                    var cast = new Cast(castPersonId, movieId, castCharacter.Text);
                    _castDao.InsertCast(cast);
                }
                Close();
            }
            catch (Exception exception)
            {
                MessageBox.Show(exception.Message);
            }
        }

        public Tuple<string, string> SplitInto2Vars(string toSplit)
        {
            var split = toSplit.Split('/');
            return Tuple.Create(split[0], split[1]);
        }

        public Tuple<string, string, string> SplitInto3Vars(string toSplit)
        {
            var split = toSplit.Split('/');
            return Tuple.Create(split[0], split[1], split[2]);
        }
    }
}