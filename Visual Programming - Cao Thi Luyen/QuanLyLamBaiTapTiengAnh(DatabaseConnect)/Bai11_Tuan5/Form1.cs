using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using BELayer;
using BALayer;

namespace Bai11_Tuan5
{
    public partial class Form1 : Form
    {
        public BAL baobj = new BAL();
        public HocSinhBEL HSbeobj = new HocSinhBEL();
        public DangBaiTapBEL DangBaiTapbeboj = new DangBaiTapBEL();
        public PhieuDiemBEL PhieuDiembeobj = new PhieuDiemBEL();

        string cauHoi;
        string cauHoi_DapAn;
        DateTime tgianbatdau;
        DateTime tgianketthuc;
        string tenbai;
        string dangbai;
        int lanlam = 1;
        List<string> DapAn;

        public Form1(string duongdanCauHoi, string duongdanDA, string duongdanCH_DA, string tenbai, string dangbai)
        {
            cauHoi = FileIO.docCauHoi(duongdanCauHoi);
            cauHoi_DapAn = FileIO.docCauHoi(duongdanDA);
            DapAn = FileIO.docDapAn(duongdanCH_DA);
            this.tenbai = tenbai;
            this.dangbai = dangbai;

            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
        }

        private void btnBatDau_Click(object sender, EventArgs e)
        {
            tgianbatdau = DateTime.Now;
            QuanLyCauHoi qlch = new QuanLyCauHoi(cauHoi, DapAn, cauHoi_DapAn);
            richTextBox1.Text = cauHoi;
        }

        private void btnNopBai_Click_1(object sender, EventArgs e)
        {
            List<TextBox> lstTextBox = new List<TextBox> { tb1, tb2, tb3, tb4, tb5, tb6, tb7, tb8, tb9, tb10 };
            int diem = 0;
            for (int i = 0; i < lstTextBox.Count; i++)
            {
                if (lstTextBox[i].Text.Trim().Equals(DapAn[i], StringComparison.OrdinalIgnoreCase))
                {
                    diem++;
                    lstTextBox[i].BackColor = Color.AliceBlue;
                }
                else lstTextBox[i].BackColor = Color.Red;
            }

            tgianketthuc = DateTime.Now;
            KetQua ketQua = new KetQua(tgianbatdau, tgianketthuc, lanlam, tenbai, dangbai, diem);
            ketQua.Show();

        }

        private void btnDapAn_Click(object sender, EventArgs e)
        {
            richTextBox1.Text = cauHoi_DapAn;
        }

        private void btnLamLai_Click(object sender, EventArgs e)
        {
            lanlam++;
        }
    }
}
