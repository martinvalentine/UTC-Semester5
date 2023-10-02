using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bai11_Tuan5
{
    internal class QuanLyCauHoi
    {
        string cauhoi;
        List<string> dapan;
        string cauhoi_kemdapan;

        public QuanLyCauHoi()
        {
        }

        public QuanLyCauHoi(string cauhoi, List<string> dapan, string cauhoi_kemdapan)
        {
            this.cauhoi = cauhoi;
            this.dapan = dapan;
            this.cauhoi_kemdapan = cauhoi_kemdapan;
        }

        public string Cauhoi { get => cauhoi; set => cauhoi = value; }
        public List<string> Dapan { get => dapan; set => dapan = value; }
        public string Cauhoi_kemdapan { get => cauhoi_kemdapan; set => cauhoi_kemdapan = value; }
    }

}
