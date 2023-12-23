using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace _2Table
{
    public partial class Form1 : Form
    {
        ProcessData db = new ProcessData();

        DataTable NhanVien = new DataTable();
        DataTable ChucVu = new DataTable();
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            dgvNhanVien.DataSource = db.DocBang("Select * from NhanVien");

            //Retrieve data to combobox
            cbbChucVu.DataSource = db.DocBang("Select ChucVu from ChucVu");
            cbbChucVu.DisplayMember = "ChucVu";
            cbbChucVu.ValueMember = "ChucVu";
        }

        private void btnThem_Click(object sender, EventArgs e)
        {
            string sql = $"Insert into NhanVien values ('{txtMaNV.Text}',N'{txtTenNV.Text}', '{txtSDT.Text}',  N'{(rdbNam.Checked == true ? "Nam" : "Nữ")}', '{dtpNgaySinh.Value}', '{Path.GetFileName(openFileDialog1.FileName)}', '{(cbbChucVu.Text == "Bảo vệ" ? "1" : (cbbChucVu.Text == "Kế Toán" ? "2" : "3"))}', '{txtMucLuong.Text}' )";
            db.DocBang(sql);
            Form1_Load(sender, e);

            // Thêm ảnh vào thư mục
            string duongDanThuMuc = Path.Combine("C:\\Users\\Martin Valentine\\Desktop\\2Table\\bin\\Debug\\Images\\");
            // Đường dẫn đầy đủ cho việc lưu ảnh vào thư mục
            string duongDanLuu = Path.Combine(duongDanThuMuc, Path.GetFileName(openFileDialog1.FileName));
            // Copy tệp tin ảnh vào thư mục
            if (File.Exists(duongDanLuu))
            {
                return;
            }
            else
            {
                File.Copy(openFileDialog1.FileName.Trim(), duongDanLuu);
            }
        }

        private void btnThoat_Click(object sender, EventArgs e)
        {
            if (MessageBox.Show("Ban co muon thoat khong?", "Thong bao", MessageBoxButtons.YesNo) == DialogResult.Yes)
            {
                this.Close();
            }
        }

        private void btnAnh_Click(object sender, EventArgs e)
        {
            // nut ThemAnh sau khi hien File Dialog
            if (openFileDialog1.ShowDialog() == DialogResult.OK)
            {
                pbAnh.Image = new Bitmap(openFileDialog1.FileName);
            }
        }

        private void btnSua_Click(object sender, EventArgs e)
        {
            string sql = $"UPDATE table_name\r\nSET MaNV ='{txtMaNV.Text}',TenNV = N'{txtTenNV.Text}', SoDT = '{txtSDT.Text}', GioiTinh N'{(rdbNam.Checked == true ? "Nam" : "Nữ")}', NgaySinh = '{dtpNgaySinh.Value}', '{Path.GetFileName(openFileDialog1.FileName)}', '{(cbbChucVu.Text == "Bảo vệ" ? "1" : (cbbChucVu.Text == "Kế Toán" ? "2" : "3"))}', '{int.Parse(txtMucLuong.Text)}'\r\nWHERE MaNV = '{txtMaNV.Text}'";
            db.DocBang(sql);
            Form1_Load(sender, e);

            // Thêm ảnh vào thư mục
            string duongDanThuMuc = Path.Combine("C:\\Users\\Martin Valentine\\Desktop\\2Table\\bin\\Debug\\Images\\");
            // Đường dẫn đầy đủ cho việc lưu ảnh vào thư mục
            string duongDanLuu = Path.Combine(duongDanThuMuc, Path.GetFileName(openFileDialog1.FileName));
            // Copy tệp tin ảnh vào thư mục
            if (File.Exists(duongDanLuu))
            {
                return;
            }
            else
            {
                File.Copy(openFileDialog1.FileName.Trim(), duongDanLuu);
            }

            txtMaNV.Enabled = false;
            btnThem.Enabled = false;
        }

        private void btnXoa_Click(object sender, EventArgs e)
        {
            string sql = $"DELETE FROM NhanVien WHERE MaNV = '{txtMaNV.Text}'";
            if (MessageBox.Show("Bạn có muốn xoá?", "Thông báo", MessageBoxButtons.YesNo) == DialogResult.Yes)
            {
                db.CapNhat(sql);

                // Làm mới form
                txtMaNV.Text = "";
                txtTenNV.Text = "";
                txtSDT.Text = "";
                rdbNam.Checked = false;
                rdbNu.Checked = false;
                pbAnh.Image = null;
                cbbChucVu.SelectedIndex = -1;
                txtMucLuong.Text = "";

                Form1_Load(sender, e);
            }
        }

        private void btnTim_Click(object sender, EventArgs e)
        {
            if (txtTenNV.Text.Trim().Length > 0)
            {
                string sql = $"Select * from NhanVien where TenNV like N'%{txtTenNV.Text}%'";
                DataTable dt = db.DocBang(sql);
                if (dt.Rows.Count <= 0)
                {
                    MessageBox.Show("Không tồn tại! Vui lòng nhập lại!");
                    txtTenNV.Focus();
                }
                else
                {
                    dgvNhanVien.DataSource = dt;
                }
            }
            else
            {
                MessageBox.Show("Không được để trống tên cần tìm!");
                txtTenNV.Focus();
            }
        }

        private void btnLamMoi_Click(object sender, EventArgs e)
        {
            btnXoa.Enabled = false;
            btnSua.Enabled = false;
            btnThem.Enabled = true;
            txtMaNV.Enabled = true;

            txtMaNV.Text = "";
            txtTenNV.Text = "";
            txtSDT.Text = "";
            rdbNam.Checked = false;
            rdbNu.Checked = false;
            pbAnh.Image = null;
            cbbChucVu.SelectedIndex = -1;
            txtMucLuong.Text = "";

            Form1_Load(sender, e);
        }

        private void dgvNhanVien_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            try
            {
                txtMaNV.Text = dgvNhanVien.SelectedRows[0].Cells["MaNV"].Value.ToString();
                txtTenNV.Text = dgvNhanVien.SelectedRows[0].Cells["TenNV"].Value.ToString();
                txtSDT.Text = dgvNhanVien.SelectedRows[0].Cells["SoDT"].Value.ToString();
                if (dgvNhanVien.SelectedRows[0].Cells["GioiTinh"].Value.ToString() == "Nam")
                {
                    rdbNam.Checked = true;
                }
                else
                {
                    rdbNu.Checked = true;
                }

                dtpNgaySinh.Text = dgvNhanVien.SelectedRows[0].Cells["NgaySinh"].Value.ToString();

                pbAnh.Image = Image.FromFile("C:/Users/Martin Valentine/Desktop/2Table/bin/Debug/Images/" + dgvNhanVien.SelectedRows[0].Cells["Anh"].Value.ToString());

                // Dành cho khi update, chọn ảnh mới thì sẽ lưu lại
                openFileDialog1.FileName = dgvNhanVien.SelectedRows[0].Cells["Anh"].Value.ToString();

                cbbChucVu.Text = dgvNhanVien.SelectedRows[0].Cells["MaChucVu"].Value.ToString();
                txtMucLuong.Text = dgvNhanVien.SelectedRows[0].Cells["MucLuong"].Value.ToString();

                btnThem.Enabled = false;
                btnLamMoi.Enabled = true;
                btnSua.Enabled = true;
                btnXoa.Enabled = true;

                // Khong cho sua ID
                txtMaNV.Enabled = false;
            }
            catch (Exception ex) { }
        }

        private void btnXuatReport_Click(object sender, EventArgs e)
        {
            Report report = new Report();
            report.ShowDialog();
        }
    }
}
