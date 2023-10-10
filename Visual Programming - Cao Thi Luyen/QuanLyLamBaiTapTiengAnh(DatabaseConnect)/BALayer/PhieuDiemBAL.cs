using BELayer;
using DALayer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BALayer
{
    public class PhieuDiemBAL
    {
        PhieuDiemDAL PhieuDiemdaobj = new PhieuDiemDAL();
        PhieuDiemBEL PhieuDiembeboj = new PhieuDiemBEL();

        public int thongTinPhieuDiem(PhieuDiemBEL PhieuDiembeobj)
        {
            return PhieuDiemdaobj.userInsertPhieuDiem(PhieuDiembeboj);
        }
    }
}
