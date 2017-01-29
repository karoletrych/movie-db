namespace GUI
{
    partial class MainView
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
            this.searchBox = new System.Windows.Forms.TextBox();
            this.moviesView = new System.Windows.Forms.DataGridView();
            this.labelx = new System.Windows.Forms.Label();
            this.loginBox = new System.Windows.Forms.TextBox();
            this.passwordBox = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.login = new System.Windows.Forms.Button();
            this.register = new System.Windows.Forms.Button();
            this.label3 = new System.Windows.Forms.Label();
            this.loggedUser = new System.Windows.Forms.Label();
            this.genres = new System.Windows.Forms.ListBox();
            this.selectedGenres = new System.Windows.Forms.ListBox();
            this.genresSelect = new System.Windows.Forms.Button();
            this.genresUnselect = new System.Windows.Forms.Button();
            this.countries = new System.Windows.Forms.ListBox();
            this.selectedCountries = new System.Windows.Forms.ListBox();
            this.selectCountry = new System.Windows.Forms.Button();
            this.unselectCountry = new System.Windows.Forms.Button();
            this.dateFrom = new System.Windows.Forms.DateTimePicker();
            this.dateTo = new System.Windows.Forms.DateTimePicker();
            this.voteFrom = new System.Windows.Forms.NumericUpDown();
            this.voteTo = new System.Windows.Forms.NumericUpDown();
            this.voteCountFrom = new System.Windows.Forms.NumericUpDown();
            this.voteCountTo = new System.Windows.Forms.NumericUpDown();
            this.radioButton1 = new System.Windows.Forms.RadioButton();
            this.radioButton2 = new System.Windows.Forms.RadioButton();
            this.radioButton3 = new System.Windows.Forms.RadioButton();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.label4 = new System.Windows.Forms.Label();
            this.search = new System.Windows.Forms.Button();
            this.label5 = new System.Windows.Forms.Label();
            this.label6 = new System.Windows.Forms.Label();
            this.label7 = new System.Windows.Forms.Label();
            this.label8 = new System.Windows.Forms.Label();
            this.label9 = new System.Windows.Forms.Label();
            this.label10 = new System.Windows.Forms.Label();
            this.label11 = new System.Windows.Forms.Label();
            this.button1 = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.moviesView)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.voteFrom)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.voteTo)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.voteCountFrom)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.voteCountTo)).BeginInit();
            this.groupBox1.SuspendLayout();
            this.SuspendLayout();
            // 
            // searchBox
            // 
            this.searchBox.Location = new System.Drawing.Point(124, 25);
            this.searchBox.Name = "searchBox";
            this.searchBox.Size = new System.Drawing.Size(100, 20);
            this.searchBox.TabIndex = 0;
            this.searchBox.TextChanged += new System.EventHandler(this.searchBox_TextChanged);
            // 
            // moviesView
            // 
            this.moviesView.AllowUserToAddRows = false;
            this.moviesView.AllowUserToDeleteRows = false;
            this.moviesView.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells;
            this.moviesView.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.moviesView.Location = new System.Drawing.Point(5, 177);
            this.moviesView.Name = "moviesView";
            this.moviesView.ReadOnly = true;
            this.moviesView.Size = new System.Drawing.Size(888, 455);
            this.moviesView.TabIndex = 1;
            this.moviesView.CellClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.filmsView_CellContentClick);
            // 
            // labelx
            // 
            this.labelx.AutoSize = true;
            this.labelx.Location = new System.Drawing.Point(2, 9);
            this.labelx.Name = "labelx";
            this.labelx.Size = new System.Drawing.Size(65, 13);
            this.labelx.TabIndex = 2;
            this.labelx.Text = "Użytkownik:";
            // 
            // loginBox
            // 
            this.loginBox.Location = new System.Drawing.Point(5, 49);
            this.loginBox.Name = "loginBox";
            this.loginBox.Size = new System.Drawing.Size(100, 20);
            this.loginBox.TabIndex = 3;
            // 
            // passwordBox
            // 
            this.passwordBox.Location = new System.Drawing.Point(5, 91);
            this.passwordBox.Name = "passwordBox";
            this.passwordBox.Size = new System.Drawing.Size(100, 20);
            this.passwordBox.TabIndex = 4;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(2, 33);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(33, 13);
            this.label1.TabIndex = 5;
            this.label1.Text = "Login";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(2, 75);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(36, 13);
            this.label2.TabIndex = 6;
            this.label2.Text = "Hasło";
            // 
            // login
            // 
            this.login.Location = new System.Drawing.Point(5, 118);
            this.login.Name = "login";
            this.login.Size = new System.Drawing.Size(100, 23);
            this.login.TabIndex = 7;
            this.login.Text = "Zaloguj";
            this.login.UseVisualStyleBackColor = true;
            this.login.Click += new System.EventHandler(this.login_Click);
            // 
            // register
            // 
            this.register.Location = new System.Drawing.Point(5, 148);
            this.register.Name = "register";
            this.register.Size = new System.Drawing.Size(100, 23);
            this.register.TabIndex = 8;
            this.register.Text = "Zarejestruj";
            this.register.UseVisualStyleBackColor = true;
            this.register.Click += new System.EventHandler(this.register_Click);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(88, 9);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(0, 13);
            this.label3.TabIndex = 9;
            // 
            // loggedUser
            // 
            this.loggedUser.AutoSize = true;
            this.loggedUser.Location = new System.Drawing.Point(70, 9);
            this.loggedUser.Name = "loggedUser";
            this.loggedUser.Size = new System.Drawing.Size(0, 13);
            this.loggedUser.TabIndex = 10;
            // 
            // genres
            // 
            this.genres.FormattingEnabled = true;
            this.genres.Location = new System.Drawing.Point(230, 35);
            this.genres.Name = "genres";
            this.genres.Size = new System.Drawing.Size(88, 134);
            this.genres.Sorted = true;
            this.genres.TabIndex = 13;
            // 
            // selectedGenres
            // 
            this.selectedGenres.FormattingEnabled = true;
            this.selectedGenres.Location = new System.Drawing.Point(375, 35);
            this.selectedGenres.Name = "selectedGenres";
            this.selectedGenres.Size = new System.Drawing.Size(87, 134);
            this.selectedGenres.Sorted = true;
            this.selectedGenres.TabIndex = 14;
            // 
            // genresSelect
            // 
            this.genresSelect.Location = new System.Drawing.Point(325, 33);
            this.genresSelect.Name = "genresSelect";
            this.genresSelect.Size = new System.Drawing.Size(44, 23);
            this.genresSelect.TabIndex = 15;
            this.genresSelect.Text = ">>";
            this.genresSelect.UseVisualStyleBackColor = true;
            this.genresSelect.Click += new System.EventHandler(this.genresSelect_Click);
            // 
            // genresUnselect
            // 
            this.genresUnselect.Location = new System.Drawing.Point(325, 75);
            this.genresUnselect.Name = "genresUnselect";
            this.genresUnselect.Size = new System.Drawing.Size(44, 23);
            this.genresUnselect.TabIndex = 16;
            this.genresUnselect.Text = "<<";
            this.genresUnselect.UseVisualStyleBackColor = true;
            this.genresUnselect.Click += new System.EventHandler(this.genresUnselect_Click);
            // 
            // countries
            // 
            this.countries.FormattingEnabled = true;
            this.countries.Location = new System.Drawing.Point(468, 35);
            this.countries.Name = "countries";
            this.countries.Size = new System.Drawing.Size(82, 134);
            this.countries.Sorted = true;
            this.countries.TabIndex = 17;
            // 
            // selectedCountries
            // 
            this.selectedCountries.FormattingEnabled = true;
            this.selectedCountries.Location = new System.Drawing.Point(606, 35);
            this.selectedCountries.Name = "selectedCountries";
            this.selectedCountries.Size = new System.Drawing.Size(80, 134);
            this.selectedCountries.Sorted = true;
            this.selectedCountries.TabIndex = 18;
            // 
            // selectCountry
            // 
            this.selectCountry.Location = new System.Drawing.Point(556, 33);
            this.selectCountry.Name = "selectCountry";
            this.selectCountry.Size = new System.Drawing.Size(44, 23);
            this.selectCountry.TabIndex = 19;
            this.selectCountry.Text = ">>";
            this.selectCountry.UseVisualStyleBackColor = true;
            this.selectCountry.Click += new System.EventHandler(this.selectCountry_Click);
            // 
            // unselectCountry
            // 
            this.unselectCountry.Location = new System.Drawing.Point(556, 75);
            this.unselectCountry.Name = "unselectCountry";
            this.unselectCountry.Size = new System.Drawing.Size(44, 23);
            this.unselectCountry.TabIndex = 20;
            this.unselectCountry.Text = "<<";
            this.unselectCountry.UseVisualStyleBackColor = true;
            this.unselectCountry.Click += new System.EventHandler(this.unselectCountry_Click);
            // 
            // dateFrom
            // 
            this.dateFrom.Location = new System.Drawing.Point(692, 35);
            this.dateFrom.Name = "dateFrom";
            this.dateFrom.Size = new System.Drawing.Size(200, 20);
            this.dateFrom.TabIndex = 21;
            this.dateFrom.Value = new System.DateTime(1900, 1, 29, 15, 50, 0, 0);
            // 
            // dateTo
            // 
            this.dateTo.Location = new System.Drawing.Point(693, 61);
            this.dateTo.Name = "dateTo";
            this.dateTo.Size = new System.Drawing.Size(200, 20);
            this.dateTo.TabIndex = 22;
            // 
            // voteFrom
            // 
            this.voteFrom.Location = new System.Drawing.Point(760, 87);
            this.voteFrom.Maximum = new decimal(new int[] {
            10,
            0,
            0,
            0});
            this.voteFrom.Name = "voteFrom";
            this.voteFrom.Size = new System.Drawing.Size(48, 20);
            this.voteFrom.TabIndex = 23;
            this.voteFrom.Value = new decimal(new int[] {
            1,
            0,
            0,
            0});
            // 
            // voteTo
            // 
            this.voteTo.Location = new System.Drawing.Point(828, 87);
            this.voteTo.Maximum = new decimal(new int[] {
            10,
            0,
            0,
            0});
            this.voteTo.Minimum = new decimal(new int[] {
            1,
            0,
            0,
            0});
            this.voteTo.Name = "voteTo";
            this.voteTo.Size = new System.Drawing.Size(64, 20);
            this.voteTo.TabIndex = 24;
            this.voteTo.Value = new decimal(new int[] {
            10,
            0,
            0,
            0});
            // 
            // voteCountFrom
            // 
            this.voteCountFrom.Location = new System.Drawing.Point(760, 118);
            this.voteCountFrom.Maximum = new decimal(new int[] {
            1000000,
            0,
            0,
            0});
            this.voteCountFrom.Name = "voteCountFrom";
            this.voteCountFrom.Size = new System.Drawing.Size(48, 20);
            this.voteCountFrom.TabIndex = 25;
            // 
            // voteCountTo
            // 
            this.voteCountTo.Location = new System.Drawing.Point(828, 118);
            this.voteCountTo.Maximum = new decimal(new int[] {
            1000000,
            0,
            0,
            0});
            this.voteCountTo.Minimum = new decimal(new int[] {
            1,
            0,
            0,
            0});
            this.voteCountTo.Name = "voteCountTo";
            this.voteCountTo.Size = new System.Drawing.Size(64, 20);
            this.voteCountTo.TabIndex = 26;
            this.voteCountTo.Value = new decimal(new int[] {
            1000000,
            0,
            0,
            0});
            // 
            // radioButton1
            // 
            this.radioButton1.AutoSize = true;
            this.radioButton1.Checked = true;
            this.radioButton1.Location = new System.Drawing.Point(6, 19);
            this.radioButton1.Name = "radioButton1";
            this.radioButton1.Size = new System.Drawing.Size(90, 17);
            this.radioButton1.TabIndex = 27;
            this.radioButton1.TabStop = true;
            this.radioButton1.Text = "liczba głosów";
            this.radioButton1.UseVisualStyleBackColor = true;
            // 
            // radioButton2
            // 
            this.radioButton2.AutoSize = true;
            this.radioButton2.Location = new System.Drawing.Point(6, 42);
            this.radioButton2.Name = "radioButton2";
            this.radioButton2.Size = new System.Drawing.Size(55, 17);
            this.radioButton2.TabIndex = 28;
            this.radioButton2.TabStop = true;
            this.radioButton2.Text = "ocena";
            this.radioButton2.UseVisualStyleBackColor = true;
            // 
            // radioButton3
            // 
            this.radioButton3.AutoSize = true;
            this.radioButton3.Location = new System.Drawing.Point(6, 65);
            this.radioButton3.Name = "radioButton3";
            this.radioButton3.Size = new System.Drawing.Size(88, 17);
            this.radioButton3.TabIndex = 29;
            this.radioButton3.TabStop = true;
            this.radioButton3.Text = "data premiery";
            this.radioButton3.UseVisualStyleBackColor = true;
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.radioButton1);
            this.groupBox1.Controls.Add(this.radioButton3);
            this.groupBox1.Controls.Add(this.radioButton2);
            this.groupBox1.Location = new System.Drawing.Point(124, 62);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(100, 109);
            this.groupBox1.TabIndex = 30;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Sortowanie:";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(121, 9);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(35, 13);
            this.label4.TabIndex = 31;
            this.label4.Text = "Tytuł:";
            // 
            // search
            // 
            this.search.Location = new System.Drawing.Point(805, 148);
            this.search.Name = "search";
            this.search.Size = new System.Drawing.Size(88, 20);
            this.search.TabIndex = 32;
            this.search.Text = "Wyszukaj";
            this.search.UseVisualStyleBackColor = true;
            this.search.Click += new System.EventHandler(this.search_Click);
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(230, 9);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(51, 13);
            this.label5.TabIndex = 33;
            this.label5.Text = "Gatunek:";
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(468, 9);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(74, 13);
            this.label6.TabIndex = 34;
            this.label6.Text = "Kraj produkcji:";
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(690, 9);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(76, 13);
            this.label7.TabIndex = 35;
            this.label7.Text = "Data Premiery:";
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Location = new System.Drawing.Point(690, 87);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(42, 13);
            this.label8.TabIndex = 36;
            this.label8.Text = "Ocena:";
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Location = new System.Drawing.Point(690, 118);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(68, 13);
            this.label9.TabIndex = 37;
            this.label9.Text = "Liczba ocen:";
            // 
            // label10
            // 
            this.label10.AutoSize = true;
            this.label10.Location = new System.Drawing.Point(814, 89);
            this.label10.Name = "label10";
            this.label10.Size = new System.Drawing.Size(10, 13);
            this.label10.TabIndex = 38;
            this.label10.Text = "-";
            // 
            // label11
            // 
            this.label11.AutoSize = true;
            this.label11.Location = new System.Drawing.Point(814, 120);
            this.label11.Name = "label11";
            this.label11.Size = new System.Drawing.Size(10, 13);
            this.label11.TabIndex = 39;
            this.label11.Text = "-";
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(693, 148);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(106, 20);
            this.button1.TabIndex = 40;
            this.button1.Text = "TOP100";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // MainView
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(905, 644);
            this.Controls.Add(this.button1);
            this.Controls.Add(this.label11);
            this.Controls.Add(this.label10);
            this.Controls.Add(this.label9);
            this.Controls.Add(this.label8);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.search);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.voteCountTo);
            this.Controls.Add(this.voteCountFrom);
            this.Controls.Add(this.voteTo);
            this.Controls.Add(this.voteFrom);
            this.Controls.Add(this.dateTo);
            this.Controls.Add(this.dateFrom);
            this.Controls.Add(this.unselectCountry);
            this.Controls.Add(this.selectCountry);
            this.Controls.Add(this.selectedCountries);
            this.Controls.Add(this.countries);
            this.Controls.Add(this.genresUnselect);
            this.Controls.Add(this.genresSelect);
            this.Controls.Add(this.selectedGenres);
            this.Controls.Add(this.genres);
            this.Controls.Add(this.loggedUser);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.register);
            this.Controls.Add(this.login);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.passwordBox);
            this.Controls.Add(this.loginBox);
            this.Controls.Add(this.labelx);
            this.Controls.Add(this.moviesView);
            this.Controls.Add(this.searchBox);
            this.Name = "MainView";
            this.Text = "MovieDb";
            this.Load += new System.EventHandler(this.Form1_Load);
            ((System.ComponentModel.ISupportInitialize)(this.moviesView)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.voteFrom)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.voteTo)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.voteCountFrom)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.voteCountTo)).EndInit();
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox searchBox;
        private System.Windows.Forms.DataGridView moviesView;
        private System.Windows.Forms.Label labelx;
        private System.Windows.Forms.TextBox loginBox;
        private System.Windows.Forms.TextBox passwordBox;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Button login;
        private System.Windows.Forms.Button register;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label loggedUser;
        private System.Windows.Forms.ListBox genres;
        private System.Windows.Forms.ListBox selectedGenres;
        private System.Windows.Forms.Button genresSelect;
        private System.Windows.Forms.Button genresUnselect;
        private System.Windows.Forms.ListBox countries;
        private System.Windows.Forms.ListBox selectedCountries;
        private System.Windows.Forms.Button selectCountry;
        private System.Windows.Forms.Button unselectCountry;
        private System.Windows.Forms.DateTimePicker dateFrom;
        private System.Windows.Forms.DateTimePicker dateTo;
        private System.Windows.Forms.NumericUpDown voteFrom;
        private System.Windows.Forms.NumericUpDown voteTo;
        private System.Windows.Forms.NumericUpDown voteCountFrom;
        private System.Windows.Forms.NumericUpDown voteCountTo;
        private System.Windows.Forms.RadioButton radioButton1;
        private System.Windows.Forms.RadioButton radioButton2;
        private System.Windows.Forms.RadioButton radioButton3;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Button search;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.Label label10;
        private System.Windows.Forms.Label label11;
        private System.Windows.Forms.Button button1;
    }
}

