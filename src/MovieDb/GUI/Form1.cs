using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Database;

namespace GUI
{
    public partial class Form1 : Form
    {
        private DAO _dao = new DAO();
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {

        }

        private void Form1_Load(object sender, EventArgs e)
        {
            passwordBox.UseSystemPasswordChar = true;
        }

        private void searchBox_TextChanged(object sender, EventArgs e)
        {
            var films = _dao.GetFilmsByTitleLike(searchBox.Text).ToList();
            

            filmsView.DataSource = films;
        }
    }
}
