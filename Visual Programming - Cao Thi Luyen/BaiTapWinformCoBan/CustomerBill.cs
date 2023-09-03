using System;

namespace BaiTapWinformCoBan
{
    internal class CustomerBill
    {
        string cusID, name, addr;
        int lastmth, thismth;
        DateTime dayReadMeter;

        public CustomerBill()
        {

        }

        public CustomerBill(string cusID, string name, string addr, DateTime dayReadMeter, int lastmth, int thismth)
        {
            this.cusID = cusID;
            this.name = name;
            this.addr = addr;
            this.dayReadMeter = dayReadMeter;
            this.lastmth = lastmth;
            this.thismth = thismth;
        }

        public override string ToString()
        {
            return "Customer: " + cusID + " " + name + " " + addr + " " + dayReadMeter.ToString() + " " + lastmth.ToString() + " " + thismth.ToString();
        }
    }
}
