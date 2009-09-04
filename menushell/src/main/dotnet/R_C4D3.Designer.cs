namespace R_C4D3
{
    partial class R_C4D3
    {
        /// <summary>
        /// Required form designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Reference to the web control
        /// </summary>
        private System.Windows.Forms.WebBrowser webbie;


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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(R_C4D3));
            this.webbie = new System.Windows.Forms.WebBrowser();
            this.SuspendLayout();
            // 
            // webbie
            // 
            this.webbie.Dock = System.Windows.Forms.DockStyle.Fill;
            this.webbie.Location = new System.Drawing.Point(0, 0);
            this.webbie.Margin = new System.Windows.Forms.Padding(0);
            this.webbie.MinimumSize = new System.Drawing.Size(20, 20);
            this.webbie.Name = "webbie";
            this.webbie.ScriptErrorsSuppressed = true;
            this.webbie.ScrollBarsEnabled = false;
            this.webbie.Size = new System.Drawing.Size(800, 600);
            this.webbie.TabIndex = 0;
            this.webbie.TabStop = false;
            this.webbie.WebBrowserShortcutsEnabled = false;
            // 
            // R_C4D3
            // 
            this.AllowDrop = true;
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Black;
            this.ClientSize = new System.Drawing.Size(800, 600);
            this.Controls.Add(this.webbie);
            this.ForeColor = System.Drawing.Color.White;
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "R_C4D3";
            this.SizeGripStyle = System.Windows.Forms.SizeGripStyle.Hide;
            this.Text = "R.C4D3";
            this.ResumeLayout(false);

        }

        #endregion
    }
}

