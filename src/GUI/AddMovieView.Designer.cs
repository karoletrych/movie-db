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
            this.dateFrom = new System.Windows.Forms.DateTimePicker();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.label7 = new System.Windows.Forms.Label();
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.textBox2 = new System.Windows.Forms.TextBox();
            this.textBox3 = new System.Windows.Forms.TextBox();
            this.textBox4 = new System.Windows.Forms.TextBox();
            this.button1 = new System.Windows.Forms.Button();
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
            // 
            // selectCountry
            // 
            this.selectCountry.Location = new System.Drawing.Point(338, 75);
            this.selectCountry.Name = "selectCountry";
            this.selectCountry.Size = new System.Drawing.Size(44, 23);
            this.selectCountry.TabIndex = 41;
            this.selectCountry.Text = ">>";
            this.selectCountry.UseVisualStyleBackColor = true;
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
            // 
            // genresSelect
            // 
            this.genresSelect.Location = new System.Drawing.Point(107, 75);
            this.genresSelect.Name = "genresSelect";
            this.genresSelect.Size = new System.Drawing.Size(44, 23);
            this.genresSelect.TabIndex = 37;
            this.genresSelect.Text = ">>";
            this.genresSelect.UseVisualStyleBackColor = true;
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
            // dateFrom
            // 
            this.dateFrom.Location = new System.Drawing.Point(12, 233);
            this.dateFrom.Name = "dateFrom";
            this.dateFrom.Size = new System.Drawing.Size(232, 20);
            this.dateFrom.TabIndex = 45;
            this.dateFrom.Value = new System.DateTime(1900, 1, 29, 15, 50, 0, 0);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(12, 214);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(75, 13);
            this.label1.TabIndex = 46;
            this.label1.Text = "Data premiery:";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(12, 280);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(32, 13);
            this.label2.TabIndex = 47;
            this.label2.Text = "Tytuł";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(12, 302);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(51, 13);
            this.label3.TabIndex = 48;
            this.label3.Text = "Przychód";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(12, 325);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(37, 13);
            this.label4.TabIndex = 49;
            this.label4.Text = "Status";
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(12, 346);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(61, 13);
            this.label7.TabIndex = 50;
            this.label7.Text = "Url plakatu:";
            // 
            // textBox1
            // 
            this.textBox1.Location = new System.Drawing.Point(73, 277);
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new System.Drawing.Size(100, 20);
            this.textBox1.TabIndex = 51;
            // 
            // textBox2
            // 
            this.textBox2.Location = new System.Drawing.Point(73, 299);
            this.textBox2.Name = "textBox2";
            this.textBox2.Size = new System.Drawing.Size(100, 20);
            this.textBox2.TabIndex = 52;
            // 
            // textBox3
            // 
            this.textBox3.Location = new System.Drawing.Point(73, 322);
            this.textBox3.Name = "textBox3";
            this.textBox3.Size = new System.Drawing.Size(100, 20);
            this.textBox3.TabIndex = 53;
            // 
            // textBox4
            // 
            this.textBox4.Location = new System.Drawing.Point(73, 343);
            this.textBox4.Name = "textBox4";
            this.textBox4.Size = new System.Drawing.Size(100, 20);
            this.textBox4.TabIndex = 54;
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(436, 346);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(82, 32);
            this.button1.TabIndex = 55;
            this.button1.Text = "Dodaj";
            this.button1.UseVisualStyleBackColor = true;
            // 
            // AddMovieView
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(530, 387);
            this.Controls.Add(this.button1);
            this.Controls.Add(this.textBox4);
            this.Controls.Add(this.textBox3);
            this.Controls.Add(this.textBox2);
            this.Controls.Add(this.textBox1);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.dateFrom);
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
        private System.Windows.Forms.DateTimePicker dateFrom;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.TextBox textBox1;
        private System.Windows.Forms.TextBox textBox2;
        private System.Windows.Forms.TextBox textBox3;
        private System.Windows.Forms.TextBox textBox4;
        private System.Windows.Forms.Button button1;
    }
}