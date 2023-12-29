using Microsoft.Reporting.WinForms;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace _2Table
{
    public partial class Report : Form
    {
        ProcessData db = new ProcessData();
        public Report()
        {
            InitializeComponent();
        }

        private void Report_Load(object sender, EventArgs e)
        {

            this.reportViewer1.RefreshReport();
            try
            {
                this.reportViewer1.RefreshReport();
                reportViewer1.LocalReport.ReportEmbeddedResource = "_2Table.Report.rdlc";
                ReportDataSource rpd = new ReportDataSource();
                rpd.Name = "DataSet1";
                rpd.Value = db.DocBang("select * from NhanVien");
                reportViewer1.LocalReport.DataSources.Add(rpd);
                this.reportViewer1.RefreshReport();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
        }
    }
}
