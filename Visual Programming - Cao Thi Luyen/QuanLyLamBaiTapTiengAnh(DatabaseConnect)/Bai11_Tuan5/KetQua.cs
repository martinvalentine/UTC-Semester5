using BALayer;
using BELayer;
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
        public HocSinhBAL HocSinhbaobj = new HocSinhBAL();
        public PhieuDiemBAL PhieuDiembaobj = new PhieuDiemBAL();
        public DangBaiTapBAL DangBaiTapbaobj = new DangBaiTapBAL();

        public HocSinhBEL HSbeobj = new HocSinhBEL();
        public DangBaiTapBEL DangBaiTapbeboj = new DangBaiTapBEL();
        public PhieuDiemBEL PhieuDiembeobj = new PhieuDiemBEL();

        DateTime tgianbatdau;
        DateTime tgianketthuc; 
        int lanthi;
        string tenbai; 
        string dangbai;
        int diem;
        string hoten;
        string mahs;
        string Lop;

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

        private void btnLuuKQ_Click(object sender, EventArgs e)
        {
            HSbeobj.hoten = tbHoten.Text;
            HSbeobj.mahs = tbMaHs.Text;
            HSbeobj.lop = tbLop.Text;

            DangBaiTapbeboj.dangbaitap = dangbai;
            DangBaiTapbeboj.tenbai= tenbai;
            DangBaiTapbeboj.mabai = "00000";

            PhieuDiembeobj.mabai= "00000";
            PhieuDiembeobj.tgianbatdau = tgianbatdau;
            PhieuDiembeobj.tgianketthuc = tgianketthuc;
            PhieuDiembeobj.mahs = tbMaHs.Text;
            PhieuDiembeobj.solanlam = lanthi;
            PhieuDiembeobj.diem = diem;

            if (HocSinhbaobj.thongTinHS(HSbeobj) > 0 && DangBaiTapbaobj.thongTinDangBai(DangBaiTapbeboj) > 0 && PhieuDiembaobj.thongTinPhieuDiem(PhieuDiembeobj) > 0)
            {
                MessageBox.Show("Insert Thanh cong du lieu vao database!");
            }
            
        }
    }
}
