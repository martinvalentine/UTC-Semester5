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
using Excel = Microsoft.Office.Interop.Excel;

namespace TestPaper1
{
    public partial class Form1 : Form
    {
        ProccessData db = new ProccessData();
        DataTable NhanVien = new DataTable();
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            NhanVien = db.DocBang("Select * From NhanVien");

            dgvNhanVien.DataSource = NhanVien;
            dgvNhanVien.Columns[0].HeaderText = "Mã nhân viên";
            dgvNhanVien.Columns[1].HeaderText = "Tên nhân viên";
            dgvNhanVien.Columns[2].HeaderText = "Số điện thoại";
            dgvNhanVien.Columns[3].HeaderText = "Giới tính";
            dgvNhanVien.Columns[4].HeaderText = "Tên ảnh";
            dgvNhanVien.Columns[5].HeaderText = "Phòng ban";
            dgvNhanVien.Columns[6].HeaderText = "Mức lương";
        }

        private void btnThoat_Click(object sender, EventArgs e)
        {
            if (MessageBox.Show("Bạn có muốn thoát không?", "Thông báo!", MessageBoxButtons.YesNo) == DialogResult.Yes)
            {
                this.Close();
            }
        }

        private void btnThem_Click(object sender, EventArgs e)
        {
            if (isValueValid())
            {
                if (isIdValid())
                {
                    string sql = $"Insert into NhanVien values ('{tbMaNV.Text}',N'{tbTenNV.Text}', '{tbSDT.Text}', N'{(rdbNam.Checked == true ? "Nam" : "Nữ")}', '{Path.GetFileName(openFileDialog1.FileName)}', N'{cbbPhongBan.Text}', '{tbMucLuong.Text}' )";
                    db.CapNhat(sql);
                    Form1_Load(sender, e);

                    // Thêm ảnh vào thư mục
                    string duongDanThuMuc = Path.Combine("D:\\UTC\\SEMESTER 5\\Visual Programming - Cao Thi Luyen\\De thi mau\\TestPaper1\\bin\\Debug\\Images\\");
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
                else
                {
                    MessageBox.Show("Mã nhân viên đã tồn tại! Vui lòng nhập lại");
                    tbMaNV.Focus();
                    return;
                }
            }
            else
            {
                MessageBox.Show("Vui nhập đủ dữ liệu khi sửa", "Thông báo", MessageBoxButtons.OK);
                return;
            }
        }

        private void btnAnh_Click(object sender, EventArgs e)
        {
            if (openFileDialog1.ShowDialog() == DialogResult.OK)
            {
                pbAnh.Image = new Bitmap(openFileDialog1.FileName);
            }
        }

        private void btnSua_Click(object sender, EventArgs e)
        {
            if (isValueValid())
            {
                string sql = $"UPDATE NhanVien \r\n SET Ma = '{int.Parse(tbMaNV.Text)}', Ten = N'{tbTenNV.Text}', SoDT = '{tbSDT.Text}', GioiTinh = N'{(rdbNam.Checked == true ? "Nam" : "Nữ")}', Anh = '{Path.GetFileName(openFileDialog1.FileName)}', PhongBan = N'{cbbPhongBan.Text}', MucLuong = '{int.Parse(tbMucLuong.Text)}' \r\nWHERE Ma = '{tbMaNV.Text}';";
                db.CapNhat(sql);
                Form1_Load(sender, e);

                // Thêm ảnh vào thư mục
                string duongDanThuMuc = Path.Combine("D:\\UTC\\SEMESTER 5\\Visual Programming - Cao Thi Luyen\\De thi mau\\TestPaper1\\bin\\Debug\\Images\\");
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
            else
            {
                MessageBox.Show("Vui nhập đủ dữ liệu khi sửa", "Thông báo", MessageBoxButtons.OK);
            }
        }

        private void btnXoa_Click(object sender, EventArgs e)
        {
            string sql = $"DELETE FROM NhanVien WHERE Ma = '{tbMaNV.Text}'";
            db.CapNhat(sql);
            Form1_Load(sender, e);
        }

        private void btnLamMoi_Click(object sender, EventArgs e)
        {
            btnXoa.Enabled = false;
            btnSua.Enabled = false;
            btnThem.Enabled = true;
            tbMaNV.Enabled = true;

            tbMaNV.Text = "";
            tbTenNV.Text = "";
            tbSDT.Text = "";
            rdbNam.Checked = false;
            rdbNu.Checked = false;
            pbAnh.Image = null;
            cbbPhongBan.SelectedIndex = -1;
            tbMucLuong.Text = "";

            Form1_Load(sender, e);
        }

        private bool isValueValid()
        {
            if (tbMaNV.Text.Trim() == "" || tbTenNV.Text.Trim() == "" || tbSDT.Text.Trim() == "" || (rdbNam.Checked == false && rdbNu.Checked == false) || cbbPhongBan.Text.Trim() == "" || tbMucLuong.Text.Trim() == "")
            {
                return false;
            }
            return true;
        }

        private bool isIdValid()
        {
            NhanVien = db.DocBang($"Select * from NhanVien Where Ma = '{tbMaNV.Text}'");
            if (NhanVien.Rows.Count > 0)
            {
                return false;
            }
            return true;
        }

        private void tbMaNV_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!char.IsControl(e.KeyChar) && !char.IsDigit(e.KeyChar) &&
                (e.KeyChar != '.'))
            {
                e.Handled = true;
            }

            // only allow one decimal point
            if ((e.KeyChar == '.') && ((sender as TextBox).Text.IndexOf('.') > -1))
            {
                e.Handled = true;
            }
        }

        private void dgvNhanVien_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            try
            {
                tbMaNV.Text = dgvNhanVien.SelectedRows[0].Cells["Ma"].Value.ToString();
                tbTenNV.Text = dgvNhanVien.SelectedRows[0].Cells["Ten"].Value.ToString();
                tbSDT.Text = dgvNhanVien.SelectedRows[0].Cells["SoDT"].Value.ToString();
                if (dgvNhanVien.SelectedRows[0].Cells["GioiTinh"].Value.ToString() == "Nam")
                {
                    rdbNam.Checked = true;
                }
                else
                {
                    rdbNu.Checked = true;
                }

                pbAnh.Image = Image.FromFile("D:/UTC/SEMESTER 5/Visual Programming - Cao Thi Luyen/De thi mau/TestPaper1/bin/Debug/Images/" + dgvNhanVien.SelectedRows[0].Cells["Anh"].Value.ToString());

                // Dành cho khi update, chọn ảnh mới thì sẽ lưu lại
                openFileDialog1.FileName = dgvNhanVien.SelectedRows[0].Cells["Anh"].Value.ToString();

                cbbPhongBan.Text = dgvNhanVien.SelectedRows[0].Cells["PhongBan"].Value.ToString();
                tbMucLuong.Text = dgvNhanVien.SelectedRows[0].Cells["MucLuong"].Value.ToString();

                btnThem.Enabled = false;
                btnLamMoi.Enabled = true;
                btnSua.Enabled = true;
                btnXoa.Enabled = true;

                // Khong cho sua ID
                tbMaNV.Enabled = false;
            }
            catch (Exception ex) { }
        }

        private void btnXuat_Click(object sender, EventArgs e)
        {
            if (NhanVien.Rows.Count > 0) //TH có dữ liệu để ghi 
            {
                //Khai báo và khởi tạo các đối tượng 
                Excel.Application exApp = new Excel.Application();
                Excel.Workbook exBook = exApp.Workbooks.Add(Excel.XlWBATemplate.xlWBATWorksheet);
                Excel.Worksheet exSheet2 = (Excel.Worksheet)exBook.Worksheets[1];

                // Tạo sheet2 trước 
                exSheet2.Name = "Chuc vu";

                //Định dạng chung 
                Excel.Range tenChucVu = exSheet2.Range["B2:D2"]; // Vì 3 ô nên cho chạy 3 ô để Merge
                tenChucVu.Merge();
                tenChucVu.Font.Size = 16;
                tenChucVu.Font.Bold = true;
                tenChucVu.Font.Color = System.Drawing.ColorTranslator.ToOle(System.Drawing.Color.Blue);
                tenChucVu.Value = "Danh sách chức vụ";
                tenChucVu.HorizontalAlignment = Excel.XlHAlign.xlHAlignCenter;

                // Định dạng tiêu đề bảng 
                Excel.Range headerRange2 = exSheet2.Range["B3:C3"];
                headerRange2.Font.Bold = true;
                headerRange2.HorizontalAlignment = Excel.XlHAlign.xlHAlignCenter;

                exSheet2.Cells[3, 2].Value = "STT";
                exSheet2.Cells[3, 3].Value = "Mã chức vụ";
                exSheet2.Cells[3, 4].Value = "Chức vụ";

                // In dữ liệu
                for (int i = 0; i < NhanVien.Rows.Count; i++)
                {
                    exSheet2.get_Range("B" + (i + 4).ToString() + ":C" + (i + 4).ToString()).Font.Bold = false;
                    exSheet2.get_Range("B" + (i + 4).ToString()).Value = (i + 1).ToString(); //STT
                    exSheet2.get_Range("C" + (i + 4).ToString()).Value = NhanVien.Rows[i]["Ma"].ToString(); // Tên cột trong Database
                    exSheet2.get_Range("D" + (i + 4).ToString()).Value = NhanVien.Rows[i]["Ten"].ToString(); // Tên cột trong Database
                }
                exSheet2.Cells.Columns.AutoFit(); // Tự động điều chỉnh cột sau khi thêm dữ liệu

                // Tạo sheet 1 để hiện thị đầu tiên khi ấn vào file đã tạo
                Excel.Worksheet exSheet = (Excel.Worksheet)exBook.Worksheets.Add();
                exSheet.Name = "NhanVien";

                //Định dạng chung 
                Excel.Range tenCuaHang = exSheet.Range["B2:I2"];
                tenCuaHang.Merge();
                tenCuaHang.Font.Size = 16;
                tenCuaHang.Font.Bold = true;
                tenCuaHang.Font.Color = System.Drawing.ColorTranslator.ToOle(System.Drawing.Color.Blue);
                tenCuaHang.Value = "Danh Sach Nhan Vien";
                tenCuaHang.HorizontalAlignment = Excel.XlHAlign.xlHAlignCenter;
                // Sheet 1 name

                // Định dạng tiêu đề bảng
                Excel.Range headerRange = exSheet.Range["B3:I3"];
                headerRange.Font.Bold = true;
                headerRange.HorizontalAlignment = Excel.XlHAlign.xlHAlignCenter;

                exSheet.Cells[3, 2].Value = "STT";
                exSheet.Cells[3, 3].Value = "Ma nhan vien";
                exSheet.Cells[3, 4].Value = "Tên NV";
                exSheet.Cells[3, 5].Value = "SDT";
                exSheet.Cells[3, 6].Value = "Gioi Tinh";
                exSheet.Cells[3, 7].Value = "Anh";
                exSheet.Cells[3, 8].Value = "Phong Ban";
                exSheet.Cells[3, 9].Value = "Muc luong";

                // In dữ liệu
                for (int i = 0; i < NhanVien.Rows.Count; i++)
                {
                    exSheet.get_Range("B" + (i + 4).ToString() + ":I" + (i + 4).ToString()).Font.Bold = false;
                    exSheet.get_Range("B" + (i + 4).ToString()).Value = (i + 1).ToString(); //STT
                    exSheet.get_Range("C" + (i + 4).ToString()).Value = NhanVien.Rows[i]["Ma"].ToString();
                    exSheet.get_Range("D" + (i + 4).ToString()).Value = NhanVien.Rows[i]["Ten"].ToString();
                    exSheet.get_Range("E" + (i + 4).ToString()).Value = NhanVien.Rows[i]["SoDT"].ToString();
                    exSheet.get_Range("F" + (i + 4).ToString()).Value = NhanVien.Rows[i]["GioiTinh"].ToString();
                    exSheet.get_Range("G" + (i + 4).ToString()).Value = NhanVien.Rows[i]["Anh"].ToString();
                    exSheet.get_Range("H" + (i + 4).ToString()).Value = NhanVien.Rows[i]["PhongBan"].ToString();
                    exSheet.get_Range("I" + (i + 4).ToString()).Value = NhanVien.Rows[i]["MucLuong"].ToString();
                }

                exSheet.Cells.Columns.AutoFit(); // Tự động điều chỉnh cột sau khi thêm dữ liệu


                exBook.Activate(); //Kích hoạt file Excel 

                // Luu file excel
                //Thiết lập các thuộc tính của SaveFileDialog 
                saveFileDialog1.Filter = "Excel Document(*.xls)|*.xls  |Word Document(*.doc) | *.doc | All files(*.*) | *.* ";
                saveFileDialog1.FilterIndex = 1;
                saveFileDialog1.AddExtension = true;
                saveFileDialog1.DefaultExt = ".xls";
                if (saveFileDialog1.ShowDialog() == System.Windows.Forms.DialogResult.OK)
                {
                    exBook.SaveAs(saveFileDialog1.FileName.ToString());//Lưu file Excel
                    MessageBox.Show("Xuat file thanh cong!");
                }

                exApp.Quit();//Thoát khỏi ứng dụng 
            }
            else
            {
                MessageBox.Show("Không có danh sách nhan vien để in");
            }
        }

        private void btnTim_Click(object sender, EventArgs e)
        {
            if (tbTenNV.Text.Trim().Length > 0)
            {
                string sql = $"Select * from NhanVien where Ten like N'%{tbTenNV.Text}%'";
                DataTable dt = db.DocBang(sql);
                if (dt.Rows.Count <= 0)
                {
                    MessageBox.Show("Không tồn tại! Vui lòng nhập lại!");
                    tbTenNV.Focus();
                }
                else
                {
                    dgvNhanVien.DataSource = dt;
                }
            }
            else
            {
                MessageBox.Show("Không được để trống tên cần tìm!");
                tbTenNV.Focus ();
            }
        }
    }
}
