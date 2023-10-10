using BELayer;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DALayer
{
    public class DangBaiTapDAL
    {
        public SqlConnection con = new SqlConnection("Data Source=(local);Initial Catalog=QuanLyDiemTiengAnh;Persist Security Info=True;User ID=sa;Password=Qu@ng2003");
        public SqlCommand cmd = new SqlCommand();

        public int userInsertDangBai(DangBaiTapBEL DangBaiTapbeboj)
        {
            cmd.Connection = con;
            con.Open();
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "spInsertDangBaiTap"; //Procedure đã tạo trong sql sever

            cmd.Parameters.AddWithValue("@dangBaiTap", DangBaiTapbeboj.dangbaitap);
            cmd.Parameters.AddWithValue("@tenBai", DangBaiTapbeboj.tenbai);
            cmd.Parameters.AddWithValue("@maBai", DangBaiTapbeboj.mabai);

            int i = cmd.ExecuteNonQuery();
            con.Close();
            return i;

        }
    }
}
