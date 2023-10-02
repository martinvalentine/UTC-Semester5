using System;
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
    public partial class KetQua : Form
    {

        DateTime tgianbatdau;
        DateTime tgianketthuc; 
        int lanthi;
        string tenbai; 
        string dangbai;
        int diem;
        public KetQua(DateTime timestart, DateTime endtime, int lanlam,string ten, string dang, int diembailam)
        {
            tgianbatdau = timestart;
            tgianketthuc = endtime;
            lanthi = lanlam;
            tenbai = ten;
            dangbai = dang;
            diem = diembailam;
            InitializeComponent();
        }

        private void KetQua_Load(object sender, EventArgs e)
        {
            tbTgianBatDau.Text = tgianbatdau.ToString();
            tbTgianKetThuc.Text = tgianketthuc.ToString();
            tbLanLam.Text = lanthi.ToString();
            tbTenBai.Text = tenbai.ToString();
            tbDangBai.Text = dangbai.ToString();
            tbDiem.Text = diem.ToString();
        }
    }
}
