using System;
using System.Linq;
using System.Windows.Forms;
using Database.DAO;
using Database.Model;
using GUI.Properties;
using Npgsql;

namespace GUI
{
    public partial class PersonView : Form
    {
        private readonly CastDao _castDao;
        private readonly NpgsqlConnection _connection;
        private readonly CrewDao _crewDao;
        private readonly PersonDao _personDao;
        private readonly int _personId;

        public PersonView(int personId, PersonDao personDao, CrewDao crewDao, CastDao castDao, NpgsqlConnection connection)
        {
            InitializeComponent();
            _personId = personId;
            _personDao = personDao;
            _crewDao = crewDao;
            _castDao = castDao;
            _connection = connection;
        }

        private void PersonView_Load(object sender, EventArgs e)
        {
            var person = _personDao.GetPersonById(_personId);
            ShowBasicInfo(person);
            ShowCrew(person);
            ShowCast(person);
        }

        private void ShowBasicInfo(Person person)
        {
            name.Text = person.Name;
            deathday.Text = person.DeathDay != null
                ? deathday.Text = person.DeathDay.Value.ToString("yyyy-MM-dd")
                : "";
            birthday.Text = person.BirthDay != null
                ? birthday.Text = person.BirthDay.Value.ToString("yyyy-MM-dd")
                : "";
            place_of_birth.Text = person.PlaceOfBirth ?? "nieznane";
            gender.Text = person.Gender.ToString();
            biography.Text = person.Biography ?? "";
        }

        private void ShowCrew(Person person)
        {
            var crewData = _crewDao.GetCrewOfPerson(person.PersonId).ToList();
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
            crew.Columns[2].HeaderText = Resources.PersonView_ShowCrew_Movie;
            crew.Columns[3].Visible = false;
        }

        private void ShowCast(Person person)
        {
            var castData = _castDao.GetCastOfPerson(person.PersonId).ToList();
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

        private void cast_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex == -1)
                return;
            if (cast[e.ColumnIndex, e.RowIndex] is DataGridViewLinkCell)
            {
                var movieId = (int) cast[2, e.RowIndex].Value;
                var movieView = new MovieView(movieId, _connection);
                movieView.Show();
                Close();
            }
        }

        private void crew_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex == -1)
                return;
            if (crew[e.ColumnIndex, e.RowIndex] is DataGridViewLinkCell)
            {
                var movieId = (int) crew[3, e.RowIndex].Value;
                var movieView = new MovieView(movieId, _connection);
                movieView.Show();
                Close();
            }
        }
    }
}