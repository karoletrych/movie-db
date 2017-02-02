namespace GUI
{
    partial class AddMovieView
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
            this.label6 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.unselectCountry = new System.Windows.Forms.Button();
            this.selectCountry = new System.Windows.Forms.Button();
            this.selectedCountries = new System.Windows.Forms.ListBox();
            this.countries = new System.Windows.Forms.ListBox();
            this.genresUnselect = new System.Windows.Forms.Button();
            this.genresSelect = new System.Windows.Forms.Button();
            this.selectedGenres = new System.Windows.Forms.ListBox();
            this.genres = new System.Windows.Forms.ListBox();
            this.releaseDate = new System.Windows.Forms.DateTimePicker();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.label7 = new System.Windows.Forms.Label();
            this.title = new System.Windows.Forms.TextBox();
            this.status = new System.Windows.Forms.TextBox();
            this.posterUrl = new System.Windows.Forms.TextBox();
            this.addMovie = new System.Windows.Forms.Button();
            this.crewJob = new System.Windows.Forms.ComboBox();
            this.castCharacter = new System.Windows.Forms.TextBox();
            this.crewPerson = new System.Windows.Forms.ComboBox();
            this.castPerson = new System.Windows.Forms.ComboBox();
            this.crewListbox = new System.Windows.Forms.ListBox();
            this.castListbox = new System.Windows.Forms.ListBox();
            this.label8 = new System.Windows.Forms.Label();
            this.label9 = new System.Windows.Forms.Label();
            this.addCrew = new System.Windows.Forms.Button();
            this.addCast = new System.Windows.Forms.Button();
            this.removeCrew = new System.Windows.Forms.Button();
            this.removeCast = new System.Windows.Forms.Button();
            this.revenue = new System.Windows.Forms.NumericUpDown();
            this.label10 = new System.Windows.Forms.Label();
            this.id = new System.Windows.Forms.NumericUpDown();
            ((System.ComponentModel.ISupportInitialize)(this.revenue)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.id)).BeginInit();
            this.SuspendLayout();
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(250, 9);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(74, 13);
            this.label6.TabIndex = 44;
            this.label6.Text = "Kraj produkcji:";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(12, 9);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(51, 13);
            this.label5.TabIndex = 43;
            this.label5.Text = "Gatunek:";
            // 
            // unselectCountry
            // 
            this.unselectCountry.Location = new System.Drawing.Point(338, 120);
            this.unselectCountry.Name = "unselectCountry";
            this.unselectCountry.Size = new System.Drawing.Size(44, 23);
            this.unselectCountry.TabIndex = 42;
            this.unselectCountry.Text = "<<";
            this.unselectCountry.UseVisualStyleBackColor = true;
            this.unselectCountry.Click += new System.EventHandler(this.unselectCountry_Click);
            // 
            // selectCountry
            // 
            this.selectCountry.Location = new System.Drawing.Point(338, 75);
            this.selectCountry.Name = "selectCountry";
            this.selectCountry.Size = new System.Drawing.Size(44, 23);
            this.selectCountry.TabIndex = 41;
            this.selectCountry.Text = ">>";
            this.selectCountry.UseVisualStyleBackColor = true;
            this.selectCountry.Click += new System.EventHandler(this.selectCountry_Click);
            // 
            // selectedCountries
            // 
            this.selectedCountries.FormattingEnabled = true;
            this.selectedCountries.Location = new System.Drawing.Point(388, 35);
            this.selectedCountries.Name = "selectedCountries";
            this.selectedCountries.Size = new System.Drawing.Size(80, 160);
            this.selectedCountries.Sorted = true;
            this.selectedCountries.TabIndex = 40;
            // 
            // countries
            // 
            this.countries.FormattingEnabled = true;
            this.countries.Location = new System.Drawing.Point(250, 35);
            this.countries.Name = "countries";
            this.countries.Size = new System.Drawing.Size(82, 160);
            this.countries.Sorted = true;
            this.countries.TabIndex = 39;
            // 
            // genresUnselect
            // 
            this.genresUnselect.Location = new System.Drawing.Point(107, 120);
            this.genresUnselect.Name = "genresUnselect";
            this.genresUnselect.Size = new System.Drawing.Size(44, 23);
            this.genresUnselect.TabIndex = 38;
            this.genresUnselect.Text = "<<";
            this.genresUnselect.UseVisualStyleBackColor = true;
            this.genresUnselect.Click += new System.EventHandler(this.genresUnselect_Click);
            // 
            // genresSelect
            // 
            this.genresSelect.Location = new System.Drawing.Point(107, 75);
            this.genresSelect.Name = "genresSelect";
            this.genresSelect.Size = new System.Drawing.Size(44, 23);
            this.genresSelect.TabIndex = 37;
            this.genresSelect.Text = ">>";
            this.genresSelect.UseVisualStyleBackColor = true;
            this.genresSelect.Click += new System.EventHandler(this.genresSelect_Click);
            // 
            // selectedGenres
            // 
            this.selectedGenres.FormattingEnabled = true;
            this.selectedGenres.Location = new System.Drawing.Point(157, 35);
            this.selectedGenres.Name = "selectedGenres";
            this.selectedGenres.Size = new System.Drawing.Size(87, 160);
            this.selectedGenres.Sorted = true;
            this.selectedGenres.TabIndex = 36;
            // 
            // genres
            // 
            this.genres.FormattingEnabled = true;
            this.genres.Location = new System.Drawing.Point(12, 35);
            this.genres.Name = "genres";
            this.genres.Size = new System.Drawing.Size(88, 160);
            this.genres.Sorted = true;
            this.genres.TabIndex = 35;
            // 
            // releaseDate
            // 
            this.releaseDate.Location = new System.Drawing.Point(15, 222);
            this.releaseDate.Name = "releaseDate";
            this.releaseDate.Size = new System.Drawing.Size(161, 20);
            this.releaseDate.TabIndex = 45;
            this.releaseDate.Value = new System.DateTime(1900, 1, 29, 15, 50, 0, 0);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(12, 206);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(75, 13);
            this.label1.TabIndex = 46;
            this.label1.Text = "Data premiery:";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(12, 340);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(32, 13);
            this.label2.TabIndex = 47;
            this.label2.Text = "Tytuł";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(12, 362);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(51, 13);
            this.label3.TabIndex = 48;
            this.label3.Text = "Przychód";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(12, 385);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(37, 13);
            this.label4.TabIndex = 49;
            this.label4.Text = "Status";
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(12, 406);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(61, 13);
            this.label7.TabIndex = 50;
            this.label7.Text = "Url plakatu:";
            // 
            // title
            // 
            this.title.Location = new System.Drawing.Point(73, 337);
            this.title.Name = "title";
            this.title.Size = new System.Drawing.Size(100, 20);
            this.title.TabIndex = 51;
            // 
            // status
            // 
            this.status.Location = new System.Drawing.Point(73, 382);
            this.status.Name = "status";
            this.status.Size = new System.Drawing.Size(100, 20);
            this.status.TabIndex = 53;
            // 
            // posterUrl
            // 
            this.posterUrl.Location = new System.Drawing.Point(73, 403);
            this.posterUrl.Name = "posterUrl";
            this.posterUrl.Size = new System.Drawing.Size(100, 20);
            this.posterUrl.TabIndex = 54;
            // 
            // addMovie
            // 
            this.addMovie.Location = new System.Drawing.Point(418, 379);
            this.addMovie.Name = "addMovie";
            this.addMovie.Size = new System.Drawing.Size(82, 46);
            this.addMovie.TabIndex = 55;
            this.addMovie.Text = "Dodaj film";
            this.addMovie.UseVisualStyleBackColor = true;
            this.addMovie.Click += new System.EventHandler(this.addMovie_Click);
            // 
            // crewJob
            // 
            this.crewJob.FormattingEnabled = true;
            this.crewJob.Location = new System.Drawing.Point(289, 221);
            this.crewJob.Name = "crewJob";
            this.crewJob.Size = new System.Drawing.Size(121, 21);
            this.crewJob.TabIndex = 56;
            // 
            // castCharacter
            // 
            this.castCharacter.Location = new System.Drawing.Point(179, 221);
            this.castCharacter.Name = "castCharacter";
            this.castCharacter.Size = new System.Drawing.Size(101, 20);
            this.castCharacter.TabIndex = 57;
            // 
            // crewPerson
            // 
            this.crewPerson.FormattingEnabled = true;
            this.crewPerson.Location = new System.Drawing.Point(289, 248);
            this.crewPerson.Name = "crewPerson";
            this.crewPerson.Size = new System.Drawing.Size(121, 21);
            this.crewPerson.TabIndex = 58;
            // 
            // castPerson
            // 
            this.castPerson.FormattingEnabled = true;
            this.castPerson.Location = new System.Drawing.Point(179, 247);
            this.castPerson.Name = "castPerson";
            this.castPerson.Size = new System.Drawing.Size(101, 21);
            this.castPerson.TabIndex = 59;
            // 
            // crewListbox
            // 
            this.crewListbox.FormattingEnabled = true;
            this.crewListbox.Location = new System.Drawing.Point(289, 276);
            this.crewListbox.Name = "crewListbox";
            this.crewListbox.Size = new System.Drawing.Size(121, 95);
            this.crewListbox.TabIndex = 60;
            // 
            // castListbox
            // 
            this.castListbox.FormattingEnabled = true;
            this.castListbox.Location = new System.Drawing.Point(179, 276);
            this.castListbox.Name = "castListbox";
            this.castListbox.Size = new System.Drawing.Size(101, 95);
            this.castListbox.TabIndex = 61;
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Location = new System.Drawing.Point(179, 202);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(47, 13);
            this.label8.TabIndex = 62;
            this.label8.Text = "Obsada:";
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Location = new System.Drawing.Point(286, 202);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(37, 13);
            this.label9.TabIndex = 63;
            this.label9.Text = "Ekipa:";
            // 
            // addCrew
            // 
            this.addCrew.Location = new System.Drawing.Point(289, 378);
            this.addCrew.Name = "addCrew";
            this.addCrew.Size = new System.Drawing.Size(121, 23);
            this.addCrew.TabIndex = 64;
            this.addCrew.Text = "Dodaj";
            this.addCrew.UseVisualStyleBackColor = true;
            this.addCrew.Click += new System.EventHandler(this.addCrew_Click);
            // 
            // addCast
            // 
            this.addCast.Location = new System.Drawing.Point(179, 378);
            this.addCast.Name = "addCast";
            this.addCast.Size = new System.Drawing.Size(101, 23);
            this.addCast.TabIndex = 65;
            this.addCast.Text = "Dodaj";
            this.addCast.UseVisualStyleBackColor = true;
            this.addCast.Click += new System.EventHandler(this.addCast_Click);
            // 
            // removeCrew
            // 
            this.removeCrew.Location = new System.Drawing.Point(289, 401);
            this.removeCrew.Name = "removeCrew";
            this.removeCrew.Size = new System.Drawing.Size(121, 23);
            this.removeCrew.TabIndex = 66;
            this.removeCrew.Text = "Usuń";
            this.removeCrew.UseVisualStyleBackColor = true;
            this.removeCrew.Click += new System.EventHandler(this.removeCrew_Click);
            // 
            // removeCast
            // 
            this.removeCast.Location = new System.Drawing.Point(179, 401);
            this.removeCast.Name = "removeCast";
            this.removeCast.Size = new System.Drawing.Size(101, 23);
            this.removeCast.TabIndex = 67;
            this.removeCast.Text = "Usuń";
            this.removeCast.UseVisualStyleBackColor = true;
            this.removeCast.Click += new System.EventHandler(this.removeCast_Click);
            // 
            // revenue
            // 
            this.revenue.Location = new System.Drawing.Point(73, 360);
            this.revenue.Maximum = new decimal(new int[] {
            1000000000,
            0,
            0,
            0});
            this.revenue.Name = "revenue";
            this.revenue.Size = new System.Drawing.Size(100, 20);
            this.revenue.TabIndex = 68;
            // 
            // label10
            // 
            this.label10.AutoSize = true;
            this.label10.Location = new System.Drawing.Point(12, 317);
            this.label10.Name = "label10";
            this.label10.Size = new System.Drawing.Size(16, 13);
            this.label10.TabIndex = 69;
            this.label10.Text = "Id";
            // 
            // id
            // 
            this.id.Location = new System.Drawing.Point(73, 315);
            this.id.Maximum = new decimal(new int[] {
            10000000,
            0,
            0,
            0});
            this.id.Name = "id";
            this.id.Size = new System.Drawing.Size(100, 20);
            this.id.TabIndex = 70;
            // 
            // AddMovieView
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(513, 442);
            this.Controls.Add(this.id);
            this.Controls.Add(this.label10);
            this.Controls.Add(this.revenue);
            this.Controls.Add(this.removeCast);
            this.Controls.Add(this.removeCrew);
            this.Controls.Add(this.addCast);
            this.Controls.Add(this.addCrew);
            this.Controls.Add(this.label9);
            this.Controls.Add(this.label8);
            this.Controls.Add(this.castListbox);
            this.Controls.Add(this.crewListbox);
            this.Controls.Add(this.castPerson);
            this.Controls.Add(this.crewPerson);
            this.Controls.Add(this.castCharacter);
            this.Controls.Add(this.crewJob);
            this.Controls.Add(this.addMovie);
            this.Controls.Add(this.posterUrl);
            this.Controls.Add(this.status);
            this.Controls.Add(this.title);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.releaseDate);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.unselectCountry);
            this.Controls.Add(this.selectCountry);
            this.Controls.Add(this.selectedCountries);
            this.Controls.Add(this.countries);
            this.Controls.Add(this.genresUnselect);
            this.Controls.Add(this.genresSelect);
            this.Controls.Add(this.selectedGenres);
            this.Controls.Add(this.genres);
            this.Name = "AddMovieView";
            this.Text = "AddMovieView";
            ((System.ComponentModel.ISupportInitialize)(this.revenue)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.id)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Button unselectCountry;
        private System.Windows.Forms.Button selectCountry;
        private System.Windows.Forms.ListBox selectedCountries;
        private System.Windows.Forms.ListBox countries;
        private System.Windows.Forms.Button genresUnselect;
        private System.Windows.Forms.Button genresSelect;
        private System.Windows.Forms.ListBox selectedGenres;
        private System.Windows.Forms.ListBox genres;
        private System.Windows.Forms.DateTimePicker releaseDate;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.TextBox title;
        private System.Windows.Forms.TextBox status;
        private System.Windows.Forms.TextBox posterUrl;
        private System.Windows.Forms.Button addMovie;
        private System.Windows.Forms.ComboBox crewJob;
        private System.Windows.Forms.TextBox castCharacter;
        private System.Windows.Forms.ComboBox crewPerson;
        private System.Windows.Forms.ComboBox castPerson;
        private System.Windows.Forms.ListBox crewListbox;
        private System.Windows.Forms.ListBox castListbox;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.Button addCrew;
        private System.Windows.Forms.Button addCast;
        private System.Windows.Forms.Button removeCrew;
        private System.Windows.Forms.Button removeCast;
        private System.Windows.Forms.NumericUpDown revenue;
        private System.Windows.Forms.Label label10;
        private System.Windows.Forms.NumericUpDown id;
    }
}