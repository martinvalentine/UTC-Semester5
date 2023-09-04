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

        public CustomerBill(string cusID, string name, string addr, DateTime meterReadingDate, int lastmth, int thismth)
        {
            this.cusID = cusID;
            this.name = name;
            this.addr = addr;
            this.dayReadMeter = meterReadingDate.Date; // Use .Date to get only the date portion
            this.lastmth = lastmth;
            this.thismth = thismth;
        }

        public override string ToString()
        {
            return "Customer: " + cusID + " | " + name + " | " + addr + " | " + dayReadMeter.ToString("yyyy-MM-dd") + " | " + lastmth.ToString() + " | " + thismth.ToString() + " | Electric Bill: " + electricBillCal().ToString("0.00");
        }

        public float electricBillCal()
        {

            float totalBill = 0;

            // Calculate bill for the first 50 units at 100 dong/unit
            if (thismth <= 50)
            {
                totalBill = thismth * 100;
            }
            else
            {
                totalBill = 50 * 100; // First 50 units
                thismth -= 50;

                // Calculate bill for the next 50 units at 200 dong/unit
                if (thismth <= 50)
                {
                    totalBill += thismth * 200;
                }
                else
                {
                    totalBill += 50 * 200; // Next 50 units
                    thismth -= 50;

                    // Calculate bill for the next 100 units at 300 dong/unit
                    if (thismth <= 100)
                    {
                        totalBill += thismth * 300;
                    }
                    else
                    {
                        totalBill += 100 * 300; // Next 100 units
                        thismth -= 100;

                        // Calculate bill for the remaining units at 400 dong/unit
                        totalBill += thismth * 400;
                    }
                }
            }

            // Add VAT (10%)
            totalBill *= 1.1f;

            return totalBill;
        }
    }
}
