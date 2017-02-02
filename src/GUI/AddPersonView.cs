using System;
using System.Windows.Forms;
using Database.DAO;
using Database.Model;

namespace GUI
{
    public partial class AddPersonView : Form
    {
        private readonly PersonDao _movieDao = new PersonDao();

        public AddPersonView()
        {
            InitializeComponent();
        }

        private void AddPersonView_Load(object sender, EventArgs e)
        {
        }

        private void addButton_Click(object sender, EventArgs e)
        {
            var person = new Person(name.Text,
                (int)id.Value,
                noBirthDay.Checked?(DateTime?)null:birthDay.Value,
                noDeathDay.Checked?(DateTime?)null:deathDay.Value,
                biography.Text,
                gender.SelectedIndex,
                placeOfBirth.Text);
            _movieDao.InsertPerson(person);
            Close();
        }
    }
}