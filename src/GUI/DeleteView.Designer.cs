namespace GUI
{
    partial class DeleteView
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
            this.deleteMovie = new System.Windows.Forms.Button();
            this.movie = new System.Windows.Forms.ComboBox();
            this.deletePerson = new System.Windows.Forms.Button();
            this.person = new System.Windows.Forms.ComboBox();
            this.SuspendLayout();
            // 
            // deleteMovie
            // 
            this.deleteMovie.Location = new System.Drawing.Point(248, 8);
            this.deleteMovie.Name = "deleteMovie";
            this.deleteMovie.Size = new System.Drawing.Size(75, 23);
            this.deleteMovie.TabIndex = 2;
            this.deleteMovie.Text = "Usuń film";
            this.deleteMovie.UseVisualStyleBackColor = true;
            this.deleteMovie.Click += new System.EventHandler(this.deleteMovie_Click);
            // 
            // movie
            // 
            this.movie.FormattingEnabled = true;
            this.movie.Location = new System.Drawing.Point(25, 8);
            this.movie.Name = "movie";
            this.movie.Size = new System.Drawing.Size(208, 21);
            this.movie.TabIndex = 3;
            // 
            // deletePerson
            // 
            this.deletePerson.Location = new System.Drawing.Point(248, 38);
            this.deletePerson.Name = "deletePerson";
            this.deletePerson.Size = new System.Drawing.Size(75, 23);
            this.deletePerson.TabIndex = 4;
            this.deletePerson.Text = "Usuń osobę";
            this.deletePerson.UseVisualStyleBackColor = true;
            this.deletePerson.Click += new System.EventHandler(this.deletePerson_Click);
            // 
            // person
            // 
            this.person.FormattingEnabled = true;
            this.person.Location = new System.Drawing.Point(25, 38);
            this.person.Name = "person";
            this.person.Size = new System.Drawing.Size(208, 21);
            this.person.TabIndex = 5;
            // 
            // DeleteView
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(359, 84);
            this.Controls.Add(this.person);
            this.Controls.Add(this.deletePerson);
            this.Controls.Add(this.movie);
            this.Controls.Add(this.deleteMovie);
            this.Name = "DeleteView";
            this.Text = "DeleteView";
            this.Load += new System.EventHandler(this.DeleteMovieView_Load);
            this.ResumeLayout(false);

        }

        #endregion
        private System.Windows.Forms.Button deleteMovie;
        private System.Windows.Forms.ComboBox movie;
        private System.Windows.Forms.Button deletePerson;
        private System.Windows.Forms.ComboBox person;
    }
}