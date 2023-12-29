using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TestPaper1
{
	public class ProccessData
	{
		string stringCon = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=""D:\UTC\SEMESTER 5\Visual Programming - Cao Thi Luyen\De thi mau\TestPaper1\Database.mdf"";Integrated Security=True";
		SqlConnection con;

		public void KetNoi()
		{
			con = new SqlConnection(stringCon);
			if (con.State != ConnectionState.Open)
				con.Open();
		}

		public void DongKetNoi()
		{
			if (con.State != ConnectionState.Closed)
				con.Close();
			con.Dispose();
		}

		// Khi dung cau lenh tra ve ket qua
		public DataTable DocBang(string sql)
		{
			DataTable tb = new DataTable();
			KetNoi();
			SqlDataAdapter adapter = new SqlDataAdapter(sql, con);
			adapter.Fill(tb);
			DongKetNoi();
			return tb;
		}

		// Khi dung cau lenh them sua xoa
		public void CapNhat(string sql)
		{
			SqlCommand cmm = new SqlCommand();
			KetNoi();
			cmm.CommandText = sql;
			cmm.Connection = con;
			cmm.ExecuteNonQuery();
			DongKetNoi();
		}
	}
}
