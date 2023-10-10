namespace Bai11_Tuan5
{
    partial class MainForm
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
            this.menuStrip2 = new System.Windows.Forms.MenuStrip();
            this.dạngBàiĐiềnTừToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.bài1ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.bài2ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.dạngBàiToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.biếnĐổiCâuToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.đặtCâuToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.thoátToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.menuStrip2.SuspendLayout();
            this.SuspendLayout();
            // 
            // menuStrip2
            // 
            this.menuStrip2.BackColor = System.Drawing.SystemColors.ButtonShadow;
            this.menuStrip2.BackgroundImageLayout = System.Windows.Forms.ImageLayout.None;
            this.menuStrip2.Font = new System.Drawing.Font("Segoe UI Semibold", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.menuStrip2.GripMargin = new System.Windows.Forms.Padding(2);
            this.menuStrip2.ImageScalingSize = new System.Drawing.Size(20, 16);
            this.menuStrip2.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.dạngBàiĐiềnTừToolStripMenuItem,
            this.dạngBàiToolStripMenuItem,
            this.biếnĐổiCâuToolStripMenuItem,
            this.đặtCâuToolStripMenuItem,
            this.thoátToolStripMenuItem});
            this.menuStrip2.LayoutStyle = System.Windows.Forms.ToolStripLayoutStyle.HorizontalStackWithOverflow;
            this.menuStrip2.Location = new System.Drawing.Point(0, 0);
            this.menuStrip2.Name = "menuStrip2";
            this.menuStrip2.Size = new System.Drawing.Size(488, 24);
            this.menuStrip2.TabIndex = 1;
            this.menuStrip2.Text = "menuStrip";
            // 
            // dạngBàiĐiềnTừToolStripMenuItem
            // 
            this.dạngBàiĐiềnTừToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.bài1ToolStripMenuItem,
            this.bài2ToolStripMenuItem});
            this.dạngBàiĐiềnTừToolStripMenuItem.Name = "dạngBàiĐiềnTừToolStripMenuItem";
            this.dạngBàiĐiềnTừToolStripMenuItem.Size = new System.Drawing.Size(107, 20);
            this.dạngBàiĐiềnTừToolStripMenuItem.Text = "Dạng bài điền từ";
            // 
            // bài1ToolStripMenuItem
            // 
            this.bài1ToolStripMenuItem.Name = "bài1ToolStripMenuItem";
            this.bài1ToolStripMenuItem.Size = new System.Drawing.Size(100, 22);
            this.bài1ToolStripMenuItem.Text = "Bài 1";
            this.bài1ToolStripMenuItem.Click += new System.EventHandler(this.bài1ToolStripMenuItem_Click);
            // 
            // bài2ToolStripMenuItem
            // 
            this.bài2ToolStripMenuItem.Name = "bài2ToolStripMenuItem";
            this.bài2ToolStripMenuItem.Size = new System.Drawing.Size(100, 22);
            this.bài2ToolStripMenuItem.Text = "Bài 2";
            // 
            // dạngBàiToolStripMenuItem
            // 
            this.dạngBàiToolStripMenuItem.Name = "dạngBàiToolStripMenuItem";
            this.dạngBàiToolStripMenuItem.Size = new System.Drawing.Size(84, 20);
            this.dạngBàiToolStripMenuItem.Text = "Biến đổi câu";
            // 
            // biếnĐổiCâuToolStripMenuItem
            // 
            this.biếnĐổiCâuToolStripMenuItem.Name = "biếnĐổiCâuToolStripMenuItem";
            this.biếnĐổiCâuToolStripMenuItem.Size = new System.Drawing.Size(122, 20);
            this.biếnĐổiCâuToolStripMenuItem.Text = "Trắc nghiệm giới từ";
            // 
            // đặtCâuToolStripMenuItem
            // 
            this.đặtCâuToolStripMenuItem.Name = "đặtCâuToolStripMenuItem";
            this.đặtCâuToolStripMenuItem.Size = new System.Drawing.Size(60, 20);
            this.đặtCâuToolStripMenuItem.Text = "Đặt câu";
            // 
            // thoátToolStripMenuItem
            // 
            this.thoátToolStripMenuItem.Name = "thoátToolStripMenuItem";
            this.thoátToolStripMenuItem.Size = new System.Drawing.Size(50, 20);
            this.thoátToolStripMenuItem.Text = "Thoát";
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(488, 283);
            this.Controls.Add(this.menuStrip2);
            this.Name = "MainForm";
            this.Text = "MainForm";
            this.menuStrip2.ResumeLayout(false);
            this.menuStrip2.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private System.Windows.Forms.MenuStrip menuStrip2;
        private System.Windows.Forms.ToolStripMenuItem dạngBàiĐiềnTừToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem bài1ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem bài2ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem dạngBàiToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem biếnĐổiCâuToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem đặtCâuToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem thoátToolStripMenuItem;
    }
}