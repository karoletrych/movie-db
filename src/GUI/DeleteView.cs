using System;
using System.Linq;
using System.Windows.Forms;
using Database.DAO;

namespace GUI
{
    public partial class DeleteView : Form
    {
        private readonly PersonDao _personDao = new PersonDao();
        private readonly MovieDao _movieDao = new MovieDao();

        public DeleteView()
        {
            InitializeComponent();
        }

        private void DeleteMovieView_Load(object sender, EventArgs e)
        {
            ReloadPersons();
            ReloadMovies();
        }

        private void ReloadPersons()
        {
            person.Items.Clear();
            var persons =
                _personDao
                    .GetAllPersons()
                    .Select(personDto => $"{personDto.Name}/{personDto.Id}")
                    .OrderBy(s => s);

            foreach (var person1 in persons)
            {
                person.Items.Add(person1);
            }
        }

        private void ReloadMovies()
        {
            movie.Items.Clear();
            var movies =
                _movieDao
                    .GetAllMovies()
                    .Select(personDto => $"{personDto.Title}/{personDto.Id}")
                    .OrderBy(s => s);

            foreach (var movie1 in movies)
            {
                movie.Items.Add(movie1);
            }
        }

        private void deleteMovie_Click(object sender, EventArgs e)
        {
            var movieId = movie.GetItemText(movie.SelectedItem).SplitInto2Vars().Item2;
            var movieIdInt = int.Parse(movieId);
            _movieDao.DeleteMovie(movieIdInt);
            movie.SelectedItem = null;
            ReloadMovies();
        }

        private void deletePerson_Click(object sender, EventArgs e)
        {
            var personId = person.GetItemText(person.SelectedItem).SplitInto2Vars().Item2;
            var personIdInt = int.Parse(personId);
            _personDao.DeletePerson(personIdInt);
            person.SelectedItem = null;
            ReloadPersons();
        }
    }
}
