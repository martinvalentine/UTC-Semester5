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
    public class PhieuDiemDAL
    {
        public SqlConnection con = new SqlConnection("Data Source=(local);Initial Catalog=QuanLyDiemTiengAnh;Persist Security Info=True;User ID=sa;Password=Qu@ng2003");
        public SqlCommand cmd = new SqlCommand();

        public int userInsertPhieuDiem(PhieuDiemBEL PhieuDiembeobj)
        {
            cmd.Connection = con;
            con.Open();
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "spInsertPhieuDiem"; //Procedure đã tạo trong sql sever

            cmd.Parameters.AddWithValue("@mahs", PhieuDiembeobj.mahs);
            cmd.Parameters.AddWithValue("@diem", PhieuDiembeobj.diem);
            cmd.Parameters.AddWithValue("@tgBatDau", PhieuDiembeobj.tgianbatdau.ToString("yyyy/MM/dd"));
            cmd.Parameters.AddWithValue("@tgKetThuc", PhieuDiembeobj.tgianketthuc.ToString("yyyy/MM/dd"));
            cmd.Parameters.AddWithValue("@maBai", PhieuDiembeobj.mabai);
            cmd.Parameters.AddWithValue("@soLanLam", PhieuDiembeobj.solanlam);

            int i = cmd.ExecuteNonQuery();
            con.Close();
            return i;
        }
    }
}
