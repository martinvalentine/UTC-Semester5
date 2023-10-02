using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BELayer
{
    public class PhieuDiemBEL
    {
        public string _mahs;

        public string mahs
        {
            get { return _mahs; }
            set { _mahs = value; }
        }

        public int _diem;

        public int diem
        {
            get { return _diem; }
            set { _diem = value; }
        }

        public DateTime _tgianbatdau;

        public DateTime tgianbatdau
        {
            get { return _tgianbatdau; }
            set { _tgianbatdau = value; }
        }

        public DateTime _tgianketthuc;

        public DateTime tgianketthuc
        {
            get { return _tgianketthuc; }
            set { _tgianketthuc = value; }
        }

        public string _mabai;

        public string mabai
        {
            get { return _mabai; }
            set { _mabai = value; }
        }

        public int _solanlam;

        public int solanlam
        {
            get { return _solanlam; }
            set { _solanlam = value; }
        }

    }
}
