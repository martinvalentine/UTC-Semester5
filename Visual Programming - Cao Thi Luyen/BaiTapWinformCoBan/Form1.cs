using System;
using System.Windows.Forms;

namespace BaiTapWinformCoBan
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void btnExit_Click(object sender, EventArgs e)
        {
            DialogResult result = MessageBox.Show("Bạn có muốn thoát không?", "Xác nhận thoát", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
            if (result == DialogResult.Yes)
            {
                // Thực hiện thoát ứng dụng
                Application.Exit();
            }
            // Nếu người dùng chọn No, không làm gì cả, form vẫn được giữ lại.
        }
    }
}
