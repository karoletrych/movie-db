using System;
using System.Windows.Forms;
using Database.DAO;

namespace GUI
{
    public partial class AddReview : Form
    {
        private readonly ReviewsDao _reviewsDao;
        private readonly int _movieId;

        public AddReview(ReviewsDao reviewsDao, int movieId)
        {
            _reviewsDao = reviewsDao;
            _movieId = movieId;
            InitializeComponent();
        }

        private void add_Click(object sender, EventArgs e)
        {
            _reviewsDao.AddReview(LoggedUser.Login, content.Text, (int)vote.Value, _movieId);
            Close();
        }
    }
}
