using System;
using System.Windows.Forms;
using Database.DAO;

namespace GUI
{
    public partial class AddReview : Form
    {
        private readonly ReviewsDao _reviewsDao;
        private readonly int _movieId;
        private readonly MovieView _parent;

        public AddReview(ReviewsDao reviewsDao, int movieId, MovieView parent)
        {
            _reviewsDao = reviewsDao;
            _movieId = movieId;
            _parent = parent;
            InitializeComponent();
        }

        private void add_Click(object sender, EventArgs e)
        {
            _reviewsDao.AddReview(LoggedUser.Login, content.Text, (int)vote.Value, _movieId);
            _parent.MovieView_Load(this, new EventArgs());
            Close();
        }
    }
}
