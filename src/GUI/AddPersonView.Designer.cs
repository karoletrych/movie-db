namespace GUI
{
    partial class AddPersonView
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
            this.label22 = new System.Windows.Forms.Label();
            this.deathDay = new System.Windows.Forms.DateTimePicker();
            this.birthDay = new System.Windows.Forms.DateTimePicker();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.label6 = new System.Windows.Forms.Label();
            this.label33 = new System.Windows.Forms.Label();
            this.addButton = new System.Windows.Forms.Button();
            this.name = new System.Windows.Forms.TextBox();
            this.biography = new System.Windows.Forms.RichTextBox();
            this.placeOfBirth = new System.Windows.Forms.TextBox();
            this.noDeathDay = new System.Windows.Forms.CheckBox();
            this.id = new System.Windows.Forms.NumericUpDown();
            this.gender = new System.Windows.Forms.ComboBox();
            this.noBirthDay = new System.Windows.Forms.CheckBox();
            ((System.ComponentModel.ISupportInitialize)(this.id)).BeginInit();
            this.SuspendLayout();
            // 
            // label22
            // 
            this.label22.AutoSize = true;
            this.label22.Location = new System.Drawing.Point(13, 38);
            this.label22.Name = "label22";
            this.label22.Size = new System.Drawing.Size(29, 13);
            this.label22.TabIndex = 0;
            this.label22.Text = "płeć";
            // 
            // deathDay
            // 
            this.deathDay.Location = new System.Drawing.Point(110, 270);
            this.deathDay.Name = "deathDay";
            this.deathDay.Size = new System.Drawing.Size(194, 20);
            this.deathDay.TabIndex = 1;
            // 
            // birthDay
            // 
            this.birthDay.Location = new System.Drawing.Point(110, 242);
            this.birthDay.Name = "birthDay";
            this.birthDay.Size = new System.Drawing.Size(194, 20);
            this.birthDay.TabIndex = 2;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(13, 65);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(51, 13);
            this.label2.TabIndex = 3;
            this.label2.Text = "nazwisko";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(13, 90);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(47, 13);
            this.label3.TabIndex = 4;
            this.label3.Text = "biografia";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(13, 213);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(91, 13);
            this.label4.TabIndex = 5;
            this.label4.Text = "miejsce urodzenia";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(13, 271);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(63, 13);
            this.label5.TabIndex = 6;
            this.label5.Text = "data smierci";
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(13, 242);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(77, 13);
            this.label6.TabIndex = 7;
            this.label6.Text = "data urodzenia";
            // 
            // label33
            // 
            this.label33.AutoSize = true;
            this.label33.Location = new System.Drawing.Point(13, 11);
            this.label33.Name = "label33";
            this.label33.Size = new System.Drawing.Size(15, 13);
            this.label33.TabIndex = 8;
            this.label33.Text = "id";
            // 
            // addButton
            // 
            this.addButton.Location = new System.Drawing.Point(263, 301);
            this.addButton.Name = "addButton";
            this.addButton.Size = new System.Drawing.Size(75, 23);
            this.addButton.TabIndex = 9;
            this.addButton.Text = "Dodaj";
            this.addButton.UseVisualStyleBackColor = true;
            this.addButton.Click += new System.EventHandler(this.addButton_Click);
            // 
            // name
            // 
            this.name.Location = new System.Drawing.Point(70, 62);
            this.name.Name = "name";
            this.name.Size = new System.Drawing.Size(268, 20);
            this.name.TabIndex = 10;
            // 
            // biography
            // 
            this.biography.Location = new System.Drawing.Point(70, 90);
            this.biography.Name = "biography";
            this.biography.Size = new System.Drawing.Size(268, 104);
            this.biography.TabIndex = 11;
            this.biography.Text = "";
            // 
            // placeOfBirth
            // 
            this.placeOfBirth.Location = new System.Drawing.Point(110, 210);
            this.placeOfBirth.Name = "placeOfBirth";
            this.placeOfBirth.Size = new System.Drawing.Size(228, 20);
            this.placeOfBirth.TabIndex = 12;
            // 
            // noDeathDay
            // 
            this.noDeathDay.AutoSize = true;
            this.noDeathDay.Location = new System.Drawing.Point(310, 270);
            this.noDeathDay.Name = "noDeathDay";
            this.noDeathDay.Size = new System.Drawing.Size(47, 17);
            this.noDeathDay.TabIndex = 13;
            this.noDeathDay.Text = "brak";
            this.noDeathDay.UseVisualStyleBackColor = true;
            // 
            // id
            // 
            this.id.Location = new System.Drawing.Point(70, 9);
            this.id.Maximum = new decimal(new int[] {
            1410065408,
            2,
            0,
            0});
            this.id.Name = "id";
            this.id.Size = new System.Drawing.Size(47, 20);
            this.id.TabIndex = 14;
            // 
            // gender
            // 
            this.gender.FormattingEnabled = true;
            this.gender.Items.AddRange(new object[] {
            "nieznana",
            "F",
            "M"});
            this.gender.Location = new System.Drawing.Point(70, 35);
            this.gender.Name = "gender";
            this.gender.Size = new System.Drawing.Size(47, 21);
            this.gender.TabIndex = 15;
            // 
            // noBirthDay
            // 
            this.noBirthDay.AutoSize = true;
            this.noBirthDay.Location = new System.Drawing.Point(310, 245);
            this.noBirthDay.Name = "noBirthDay";
            this.noBirthDay.Size = new System.Drawing.Size(47, 17);
            this.noBirthDay.TabIndex = 16;
            this.noBirthDay.Text = "brak";
            this.noBirthDay.UseVisualStyleBackColor = true;
            // 
            // AddPersonView
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(363, 332);
            this.Controls.Add(this.noBirthDay);
            this.Controls.Add(this.gender);
            this.Controls.Add(this.id);
            this.Controls.Add(this.noDeathDay);
            this.Controls.Add(this.placeOfBirth);
            this.Controls.Add(this.biography);
            this.Controls.Add(this.name);
            this.Controls.Add(this.addButton);
            this.Controls.Add(this.label33);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.birthDay);
            this.Controls.Add(this.deathDay);
            this.Controls.Add(this.label22);
            this.Name = "AddPersonView";
            this.Text = "AddPersonView";
            this.Load += new System.EventHandler(this.AddPersonView_Load);
            ((System.ComponentModel.ISupportInitialize)(this.id)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label22;
        private System.Windows.Forms.DateTimePicker deathDay;
        private System.Windows.Forms.DateTimePicker birthDay;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Label label33;
        private System.Windows.Forms.Button addButton;
        private System.Windows.Forms.TextBox name;
        private System.Windows.Forms.RichTextBox biography;
        private System.Windows.Forms.TextBox placeOfBirth;
        private System.Windows.Forms.CheckBox noDeathDay;
        private System.Windows.Forms.NumericUpDown id;
        private System.Windows.Forms.ComboBox gender;
        private System.Windows.Forms.CheckBox noBirthDay;
    }
}