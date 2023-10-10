using BELayer;
using DALayer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BALayer
{
    public class HocSinhBAL
    {
        HocSinhDAL HocSinhdaobj = new HocSinhDAL();
        HocSinhBEL HSbeobj = new HocSinhBEL();

        public int thongTinHS(HocSinhBEL HSbeobj)
        {
            return HocSinhdaobj.userInsertHS(HSbeobj);
        }
    }
}
