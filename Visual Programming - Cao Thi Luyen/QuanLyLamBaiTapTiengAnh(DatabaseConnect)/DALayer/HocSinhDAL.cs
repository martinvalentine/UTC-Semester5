using BELayer;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DALayer
{
    public class HocSinhDAL
    {
        public SqlConnection con = new SqlConnection("Data Source=(local);Initial Catalog=QuanLyDiemTiengAnh;Persist Security Info=True;User ID=sa;Password=Qu@ng2003");
        public SqlCommand cmd  = new SqlCommand();

        public int userInsertHS(HocSinhBEL HSbeobj)
        {
            cmd.Connection = con;
            con.Open();
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "spInsertHS"; //Procedure đã tạo trong sql sever

            cmd.Parameters.AddWithValue("@mahs", HSbeobj.mahs);
            cmd.Parameters.AddWithValue("@hoten", HSbeobj.hoten);
            cmd.Parameters.AddWithValue("@lop", HSbeobj.lop);

            int i = cmd.ExecuteNonQuery();
            con.Close();
            return i;
        }
    }

}
