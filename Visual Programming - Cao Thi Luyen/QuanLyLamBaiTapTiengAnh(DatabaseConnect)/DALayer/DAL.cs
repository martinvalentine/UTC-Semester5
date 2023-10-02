using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DALayer
{
    public class DAL
    {
        public SqlConnection con = new SqlConnection("Data Source=(local);Initial Catalog=QuanLyDiemTiengAnh;Persist Security Info=True;User ID=sa;Password=Qu@ng2003");
        public SqlCommand cmd  = new SqlCommand();
    }
}
