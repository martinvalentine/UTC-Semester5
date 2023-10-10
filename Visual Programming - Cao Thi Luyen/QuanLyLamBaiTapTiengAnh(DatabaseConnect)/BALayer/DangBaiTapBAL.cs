using BELayer;
using DALayer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BALayer
{
    public class DangBaiTapBAL
    {
        DangBaiTapDAL DangBaidaobj = new DangBaiTapDAL();
        DangBaiTapBEL DangBaiTapbeboj = new DangBaiTapBEL();

        public int thongTinDangBai(DangBaiTapBEL DangBaiTapbeboj)
        {
            return DangBaidaobj.userInsertDangBai(DangBaiTapbeboj);
        }
    }
}
