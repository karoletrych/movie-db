namespace GUI
{
    partial class MovieView
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.movieTitle = new System.Windows.Forms.Label();
            this.releaseDate = new System.Windows.Forms.Label();
            this.status = new System.Windows.Forms.Label();
            this.revenue = new System.Windows.Forms.Label();
            this.poster = new System.Windows.Forms.PictureBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.averageVote = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.productionCountries = new System.Windows.Forms.Label();
            this.label6 = new System.Windows.Forms.Label();
            this.genres = new System.Windows.Forms.Label();
            this.label7 = new System.Windows.Forms.Label();
            this.cast = new System.Windows.Forms.ListView();
            this.crew = new System.Windows.Forms.ListView();
            this.label8 = new System.Windows.Forms.Label();
            this.reviews = new System.Windows.Forms.ListView();
            this.label9 = new System.Windows.Forms.Label();
            this.addReview = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.poster)).BeginInit();
            this.SuspendLayout();
            // 
            // movieTitle
            // 
            this.movieTitle.AutoSize = true;
            this.movieTitle.Font = new System.Drawing.Font("Microsoft Sans Serif", 20F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(238)));
            this.movieTitle.Location = new System.Drawing.Point(13, 13);
            this.movieTitle.Name = "movieTitle";
            this.movieTitle.Size = new System.Drawing.Size(86, 31);
            this.movieTitle.TabIndex = 0;
            this.movieTitle.Text = "label1";
            // 
            // releaseDate
            // 
            this.releaseDate.AutoSize = true;
            this.releaseDate.Location = new System.Drawing.Point(291, 47);
            this.releaseDate.Name = "releaseDate";
            this.releaseDate.Size = new System.Drawing.Size(64, 13);
            this.releaseDate.TabIndex = 1;
            this.releaseDate.Text = "releaseDate";
            // 
            // status
            // 
            this.status.AutoSize = true;
            this.status.Location = new System.Drawing.Point(291, 78);
            this.status.Name = "status";
            this.status.Size = new System.Drawing.Size(35, 13);
            this.status.TabIndex = 2;
            this.status.Text = "status";
            // 
            // revenue
            // 
            this.revenue.AutoSize = true;
            this.revenue.Location = new System.Drawing.Point(291, 107);
            this.revenue.Name = "revenue";
            this.revenue.Size = new System.Drawing.Size(46, 13);
            this.revenue.TabIndex = 3;
            this.revenue.Text = "revenue";
            // 
            // poster
            // 
            this.poster.Location = new System.Drawing.Point(19, 47);
            this.poster.Name = "poster";
            this.poster.Size = new System.Drawing.Size(185, 280);
            this.poster.SizeMode = System.Windows.Forms.PictureBoxSizeMode.CenterImage;
            this.poster.TabIndex = 4;
            this.poster.TabStop = false;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(210, 47);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(75, 13);
            this.label1.TabIndex = 5;
            this.label1.Text = "Data premiery:";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(210, 78);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(40, 13);
            this.label2.TabIndex = 6;
            this.label2.Text = "Status:";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(210, 107);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(54, 13);
            this.label3.TabIndex = 7;
            this.label3.Text = "Przychód:";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(210, 139);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(79, 13);
            this.label4.TabIndex = 8;
            this.label4.Text = "Średnia ocena:";
            // 
            // averageVote
            // 
            this.averageVote.AutoSize = true;
            this.averageVote.Location = new System.Drawing.Point(291, 139);
            this.averageVote.Name = "averageVote";
            this.averageVote.Size = new System.Drawing.Size(68, 13);
            this.averageVote.TabIndex = 9;
            this.averageVote.Text = "averageVote";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(381, 47);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(80, 13);
            this.label5.TabIndex = 10;
            this.label5.Text = "Kraje produkcji:";
            // 
            // productionCountries
            // 
            this.productionCountries.AutoSize = true;
            this.productionCountries.Location = new System.Drawing.Point(468, 47);
            this.productionCountries.Name = "productionCountries";
            this.productionCountries.Size = new System.Drawing.Size(101, 13);
            this.productionCountries.TabIndex = 11;
            this.productionCountries.Text = "productionCountries";
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(381, 78);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(47, 13);
            this.label6.TabIndex = 12;
            this.label6.Text = "Gatunki:";
            // 
            // genres
            // 
            this.genres.AutoSize = true;
            this.genres.Location = new System.Drawing.Point(468, 78);
            this.genres.Name = "genres";
            this.genres.Size = new System.Drawing.Size(39, 13);
            this.genres.TabIndex = 13;
            this.genres.Text = "genres";
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(213, 183);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(47, 13);
            this.label7.TabIndex = 14;
            this.label7.Text = "Obsada:";
            // 
            // cast
            // 
            this.cast.Location = new System.Drawing.Point(216, 200);
            this.cast.Name = "cast";
            this.cast.Size = new System.Drawing.Size(385, 127);
            this.cast.TabIndex = 15;
            this.cast.UseCompatibleStateImageBehavior = false;
            // 
            // crew
            // 
            this.crew.Location = new System.Drawing.Point(216, 352);
            this.crew.Name = "crew";
            this.crew.Size = new System.Drawing.Size(385, 150);
            this.crew.TabIndex = 16;
            this.crew.UseCompatibleStateImageBehavior = false;
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Location = new System.Drawing.Point(216, 333);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(37, 13);
            this.label8.TabIndex = 17;
            this.label8.Text = "Ekipa:";
            // 
            // reviews
            // 
            this.reviews.Location = new System.Drawing.Point(19, 514);
            this.reviews.Name = "reviews";
            this.reviews.Size = new System.Drawing.Size(582, 195);
            this.reviews.TabIndex = 18;
            this.reviews.UseCompatibleStateImageBehavior = false;
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Location = new System.Drawing.Point(19, 495);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(55, 13);
            this.label9.TabIndex = 19;
            this.label9.Text = "Recenzje:";
            // 
            // addReview
            // 
            this.addReview.Location = new System.Drawing.Point(607, 514);
            this.addReview.Name = "addReview";
            this.addReview.Size = new System.Drawing.Size(101, 23);
            this.addReview.TabIndex = 20;
            this.addReview.Text = "Dodaj recenzję";
            this.addReview.UseVisualStyleBackColor = true;
            this.addReview.Click += new System.EventHandler(this.addReview_Click);
            // 
            // MovieView
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(711, 737);
            this.Controls.Add(this.addReview);
            this.Controls.Add(this.label9);
            this.Controls.Add(this.reviews);
            this.Controls.Add(this.label8);
            this.Controls.Add(this.crew);
            this.Controls.Add(this.cast);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.genres);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.productionCountries);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.averageVote);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.poster);
            this.Controls.Add(this.revenue);
            this.Controls.Add(this.status);
            this.Controls.Add(this.releaseDate);
            this.Controls.Add(this.movieTitle);
            this.Name = "MovieView";
            this.Text = "Film";
            this.Load += new System.EventHandler(this.MovieView_Load);
            ((System.ComponentModel.ISupportInitialize)(this.poster)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label movieTitle;
        private System.Windows.Forms.Label releaseDate;
        private System.Windows.Forms.Label status;
        private System.Windows.Forms.Label revenue;
        private System.Windows.Forms.PictureBox poster;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label averageVote;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label productionCountries;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Label genres;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.ListView cast;
        private System.Windows.Forms.ListView crew;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.ListView reviews;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.Button addReview;
    }
}