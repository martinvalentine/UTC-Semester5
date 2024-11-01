﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Bai11_Tuan5
{
    public partial class MainForm : Form
    {
        string tenBai = "";
        string dangBai = "";
        public MainForm()
        {
            InitializeComponent();
        }

        private void bài1ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            tenBai = bài1ToolStripMenuItem.Text;
            dangBai = dạngBàiĐiềnTừToolStripMenuItem.Text;

            string contentPath = "Bai11_Tuan5.Files.BT1.Content.txt";
            string contentAnswersPath = "Bai11_Tuan5.Files.BT1.ContentAnswers.txt";
            string answersPath = "Bai11_Tuan5.Files.BT1.Answers.txt";

            Form1 f = new Form1(contentPath, contentAnswersPath, answersPath, tenBai, dangBai);
            f.ShowDialog();
        }

        private void bài2ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            tenBai = bài2ToolStripMenuItem.Text;
            dangBai = dạngBàiĐiềnTừToolStripMenuItem.Text;
            Form1 f = new Form1(@"E:\Documents\UTC\SEMESTER 5\Visual Programming - Cao Thi Luyen\QuanLyLamBaiTapTiengAnh(DatabaseConnect)\Source\BT1\Content.txt", @"E:\Documents\UTC\SEMESTER 5\Visual Programming - Cao Thi Luyen\QuanLyLamBaiTapTiengAnh(DatabaseConnect)\Source\BT1\ContentAnswers.txt", @"E:\Documents\UTC\SEMESTER 5\Visual Programming - Cao Thi Luyen\QuanLyLamBaiTapTiengAnh(DatabaseConnect)\Source\BT1\Answers.txt", tenBai, dangBai);
            f.ShowDialog();

        }
    }
}
