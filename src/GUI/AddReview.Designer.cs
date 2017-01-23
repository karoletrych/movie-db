namespace GUI
{
    partial class AddReview
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
            this.label1 = new System.Windows.Forms.Label();
            this.vote = new System.Windows.Forms.NumericUpDown();
            this.add = new System.Windows.Forms.Button();
            this.content = new System.Windows.Forms.RichTextBox();
            ((System.ComponentModel.ISupportInitialize)(this.vote)).BeginInit();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(13, 13);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(66, 13);
            this.label1.TabIndex = 0;
            this.label1.Text = "Ocena(1-10)";
            // 
            // vote
            // 
            this.vote.Location = new System.Drawing.Point(85, 11);
            this.vote.Maximum = new decimal(new int[] {
            10,
            0,
            0,
            0});
            this.vote.Minimum = new decimal(new int[] {
            1,
            0,
            0,
            0});
            this.vote.Name = "vote";
            this.vote.Size = new System.Drawing.Size(120, 20);
            this.vote.TabIndex = 1;
            this.vote.Value = new decimal(new int[] {
            5,
            0,
            0,
            0});
            // 
            // add
            // 
            this.add.Location = new System.Drawing.Point(428, 318);
            this.add.Name = "add";
            this.add.Size = new System.Drawing.Size(75, 23);
            this.add.TabIndex = 2;
            this.add.Text = "Dodaj";
            this.add.UseVisualStyleBackColor = true;
            this.add.Click += new System.EventHandler(this.add_Click);
            // 
            // content
            // 
            this.content.Location = new System.Drawing.Point(12, 37);
            this.content.Name = "content";
            this.content.Size = new System.Drawing.Size(491, 275);
            this.content.TabIndex = 3;
            this.content.Text = "";
            // 
            // AddReview
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(515, 353);
            this.Controls.Add(this.content);
            this.Controls.Add(this.add);
            this.Controls.Add(this.vote);
            this.Controls.Add(this.label1);
            this.Name = "AddReview";
            this.Text = "AddReview";
            ((System.ComponentModel.ISupportInitialize)(this.vote)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.NumericUpDown vote;
        private System.Windows.Forms.Button add;
        private System.Windows.Forms.RichTextBox content;
    }
}