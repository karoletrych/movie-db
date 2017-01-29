namespace GUI
{
    partial class PersonView
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
            this.name = new System.Windows.Forms.Label();
            this.birthday = new System.Windows.Forms.Label();
            this.deathday = new System.Windows.Forms.Label();
            this.place_of_birth = new System.Windows.Forms.Label();
            this.gender = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.biography = new System.Windows.Forms.RichTextBox();
            this.label5 = new System.Windows.Forms.Label();
            this.cast = new System.Windows.Forms.DataGridView();
            this.label6 = new System.Windows.Forms.Label();
            this.crew = new System.Windows.Forms.DataGridView();
            this.label7 = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.cast)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.crew)).BeginInit();
            this.SuspendLayout();
            // 
            // name
            // 
            this.name.AutoSize = true;
            this.name.Font = new System.Drawing.Font("Microsoft Sans Serif", 20F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(238)));
            this.name.Location = new System.Drawing.Point(12, 9);
            this.name.Name = "name";
            this.name.Size = new System.Drawing.Size(86, 31);
            this.name.TabIndex = 0;
            this.name.Text = "Name";
            // 
            // birthday
            // 
            this.birthday.AutoSize = true;
            this.birthday.Location = new System.Drawing.Point(122, 40);
            this.birthday.Name = "birthday";
            this.birthday.Size = new System.Drawing.Size(44, 13);
            this.birthday.TabIndex = 1;
            this.birthday.Text = "birthday";
            // 
            // deathday
            // 
            this.deathday.AutoSize = true;
            this.deathday.Location = new System.Drawing.Point(122, 79);
            this.deathday.Name = "deathday";
            this.deathday.Size = new System.Drawing.Size(51, 13);
            this.deathday.TabIndex = 2;
            this.deathday.Text = "deathday";
            // 
            // place_of_birth
            // 
            this.place_of_birth.AutoSize = true;
            this.place_of_birth.Location = new System.Drawing.Point(122, 53);
            this.place_of_birth.Name = "place_of_birth";
            this.place_of_birth.Size = new System.Drawing.Size(74, 13);
            this.place_of_birth.TabIndex = 3;
            this.place_of_birth.Text = "place_of_birth";
            // 
            // gender
            // 
            this.gender.AutoSize = true;
            this.gender.Location = new System.Drawing.Point(122, 66);
            this.gender.Name = "gender";
            this.gender.Size = new System.Drawing.Size(40, 13);
            this.gender.TabIndex = 4;
            this.gender.Text = "gender";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(15, 40);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(82, 13);
            this.label1.TabIndex = 5;
            this.label1.Text = "Data urodzenia:";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(15, 53);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(95, 13);
            this.label2.TabIndex = 6;
            this.label2.Text = "Miejsce urodzenia:";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(15, 66);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(33, 13);
            this.label3.TabIndex = 7;
            this.label3.Text = "Płeć:";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(15, 79);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(68, 13);
            this.label4.TabIndex = 8;
            this.label4.Text = "Data śmierci:";
            // 
            // biography
            // 
            this.biography.Location = new System.Drawing.Point(246, 53);
            this.biography.Name = "biography";
            this.biography.ReadOnly = true;
            this.biography.Size = new System.Drawing.Size(260, 214);
            this.biography.TabIndex = 9;
            this.biography.Text = "";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(243, 37);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(51, 13);
            this.label5.TabIndex = 10;
            this.label5.Text = "Biografia:";
            // 
            // cast
            // 
            this.cast.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.cast.Location = new System.Drawing.Point(18, 450);
            this.cast.Name = "cast";
            this.cast.Size = new System.Drawing.Size(488, 173);
            this.cast.TabIndex = 12;
            this.cast.CellContentClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.cast_CellContentClick);
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(15, 434);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(32, 13);
            this.label6.TabIndex = 13;
            this.label6.Text = "Role:";
            // 
            // crew
            // 
            this.crew.AllowUserToAddRows = false;
            this.crew.AllowUserToDeleteRows = false;
            this.crew.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.crew.Location = new System.Drawing.Point(18, 273);
            this.crew.Name = "crew";
            this.crew.ReadOnly = true;
            this.crew.Size = new System.Drawing.Size(488, 158);
            this.crew.TabIndex = 14;
            this.crew.CellContentClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.crew_CellContentClick);
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(15, 254);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(58, 13);
            this.label7.TabIndex = 15;
            this.label7.Text = "Produkcja:";
            // 
            // PersonView
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(523, 635);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.crew);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.cast);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.biography);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.gender);
            this.Controls.Add(this.place_of_birth);
            this.Controls.Add(this.deathday);
            this.Controls.Add(this.birthday);
            this.Controls.Add(this.name);
            this.Name = "PersonView";
            this.Text = "PersonView";
            this.Load += new System.EventHandler(this.PersonView_Load);
            ((System.ComponentModel.ISupportInitialize)(this.cast)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.crew)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label name;
        private System.Windows.Forms.Label birthday;
        private System.Windows.Forms.Label deathday;
        private System.Windows.Forms.Label place_of_birth;
        private System.Windows.Forms.Label gender;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.RichTextBox biography;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.DataGridView cast;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.DataGridView crew;
        private System.Windows.Forms.Label label7;
    }
}