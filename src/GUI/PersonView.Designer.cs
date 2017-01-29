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
            this.SuspendLayout();
            // 
            // name
            // 
            this.name.AutoSize = true;
            this.name.Font = new System.Drawing.Font("Microsoft Sans Serif", 20F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(238)));
            this.name.Location = new System.Drawing.Point(13, 13);
            this.name.Name = "name";
            this.name.Size = new System.Drawing.Size(86, 31);
            this.name.TabIndex = 0;
            this.name.Text = "Name";
            // 
            // birthday
            // 
            this.birthday.AutoSize = true;
            this.birthday.Location = new System.Drawing.Point(375, 62);
            this.birthday.Name = "birthday";
            this.birthday.Size = new System.Drawing.Size(44, 13);
            this.birthday.TabIndex = 1;
            this.birthday.Text = "birthday";
            // 
            // deathday
            // 
            this.deathday.AutoSize = true;
            this.deathday.Location = new System.Drawing.Point(375, 101);
            this.deathday.Name = "deathday";
            this.deathday.Size = new System.Drawing.Size(51, 13);
            this.deathday.TabIndex = 2;
            this.deathday.Text = "deathday";
            // 
            // place_of_birth
            // 
            this.place_of_birth.AutoSize = true;
            this.place_of_birth.Location = new System.Drawing.Point(375, 75);
            this.place_of_birth.Name = "place_of_birth";
            this.place_of_birth.Size = new System.Drawing.Size(74, 13);
            this.place_of_birth.TabIndex = 3;
            this.place_of_birth.Text = "place_of_birth";
            // 
            // gender
            // 
            this.gender.AutoSize = true;
            this.gender.Location = new System.Drawing.Point(375, 88);
            this.gender.Name = "gender";
            this.gender.Size = new System.Drawing.Size(40, 13);
            this.gender.TabIndex = 4;
            this.gender.Text = "gender";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(268, 62);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(82, 13);
            this.label1.TabIndex = 5;
            this.label1.Text = "Data urodzenia:";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(268, 75);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(95, 13);
            this.label2.TabIndex = 6;
            this.label2.Text = "Miejsce urodzenia:";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(268, 88);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(33, 13);
            this.label3.TabIndex = 7;
            this.label3.Text = "Płeć:";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(268, 101);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(65, 13);
            this.label4.TabIndex = 8;
            this.label4.Text = "Data zgonu:";
            // 
            // biography
            // 
            this.biography.Location = new System.Drawing.Point(45, 147);
            this.biography.Name = "biography";
            this.biography.Size = new System.Drawing.Size(404, 236);
            this.biography.TabIndex = 9;
            this.biography.Text = "";
            // 
            // PersonView
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(667, 422);
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
    }
}