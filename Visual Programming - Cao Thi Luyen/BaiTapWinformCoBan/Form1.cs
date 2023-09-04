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

        private void Form1_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Alt && e.KeyCode == Keys.H)
            {
                // Display the exit confirmation dialog
                DialogResult result = MessageBox.Show("Bạn có muốn thoát không?", "Xác nhận thoát", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
                if (result == DialogResult.Yes)
                {
                    // Thực hiện thoát ứng dụng
                    Application.Exit();
                }
            }

            // Check if both Alt and T keys are pressed simultaneously
            if (e.Alt && e.KeyCode == Keys.T)
            {
                string cusID, name, addr;
                int lastmth, thismth;
                DateTime meterReadingDate;

                cusID = txtCustomerID.Text;
                name = txtCustomerName.Text;
                addr = txtCustomerAddress.Text;

                // Validate customer code length
                if (cusID.Length != 6)
                {
                    MessageBox.Show("Customer code must have exactly 6 characters.");
                    return;
                }

                // Validate customer name and address not empty
                if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(addr))
                {
                    MessageBox.Show("Customer name and address cannot be empty.");
                    return;
                }

                // Validate previous month's reading is less than current month's reading
                if (!int.TryParse(txtLastMonth.Text, out lastmth) ||
                    !int.TryParse(txtThisMonth.Text, out thismth))
                {
                    MessageBox.Show("Previous month's reading and current month's reading must be valid integers.");
                    return;
                }

                if (lastmth >= thismth)
                {
                    MessageBox.Show("Previous month's reading must be less than current month's reading.");
                    return;
                }

                meterReadingDate = datePKElectricMeter.Value;

                CustomerBill cs1 = new CustomerBill(cusID, name, addr, meterReadingDate, lastmth, thismth);
                lstCustomer.Items.Add(cs1);
            }

            if (e.Alt && e.KeyCode == Keys.M)
            {
                txtCustomerID.Text = string.Empty; // Clear the Customer ID TextBox
                txtCustomerName.Text = string.Empty; // Clear the Customer Name TextBox
                txtCustomerAddress.Text = string.Empty; // Clear the Customer Address TextBox
                txtLastMonth.Text = string.Empty; // Clear the Last Month TextBox
                txtThisMonth.Text = string.Empty; // Clear the This Month TextBox
                datePKElectricMeter.Value = DateTime.Now; // Reset the date picker to the current date

                // Set focus to the Customer ID TextBox to start inputting there
                txtCustomerID.Focus();
            }
        }

        private void btnAddtoList_Click(object sender, EventArgs e)
        {
            string cusID, name, addr;
            int lastmth, thismth;
            DateTime meterReadingDate;

            cusID = txtCustomerID.Text;
            name = txtCustomerName.Text;
            addr = txtCustomerAddress.Text;

            // Validate customer code length
            if (cusID.Length != 6)
            {
                MessageBox.Show("Customer code must have exactly 6 characters.");
                return;
            }

            // Validate customer name and address not empty
            if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(addr))
            {
                MessageBox.Show("Customer name and address cannot be empty.");
                return;
            }

            // Validate previous month's reading is less than current month's reading
            if (!int.TryParse(txtLastMonth.Text, out lastmth) ||
                !int.TryParse(txtThisMonth.Text, out thismth))
            {
                MessageBox.Show("Previous month's reading and current month's reading must be valid integers.");
                return;
            }

            if (lastmth >= thismth)
            {
                MessageBox.Show("Previous month's reading must be less than current month's reading.");
                return;
            }

            meterReadingDate = datePKElectricMeter.Value;

            CustomerBill cs1 = new CustomerBill(cusID, name, addr, meterReadingDate, lastmth, thismth);
            lstCustomer.Items.Add(cs1);
        }

        private void btnAddNew_Click(object sender, EventArgs e)
        {
            txtCustomerID.Text = string.Empty; // Clear the Customer ID TextBox
            txtCustomerName.Text = string.Empty; // Clear the Customer Name TextBox
            txtCustomerAddress.Text = string.Empty; // Clear the Customer Address TextBox
            txtLastMonth.Text = string.Empty; // Clear the Last Month TextBox
            txtThisMonth.Text = string.Empty; // Clear the This Month TextBox
            datePKElectricMeter.Value = DateTime.Now; // Reset the date picker to the current date

            // Set focus to the Customer ID TextBox to start inputting there
            txtCustomerID.Focus();
        }
    }
}
