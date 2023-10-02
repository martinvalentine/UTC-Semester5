using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bai11_Tuan5
{
    internal class FileIO
    {
        static public string docCauHoi(string duongdan)
        {
            string s = "";

            StreamReader sr = new StreamReader(duongdan);
            s = sr.ReadToEnd();
            sr.Close();

            return s;
        }

        static public List<string> docDapAn (string duongdan) 
        {
            string dapan = "";

            List<string> ls = new List<string>();
            StreamReader sr = new StreamReader(duongdan);
            while((dapan = sr.ReadLine()) != null)
            {
                ls.Add(dapan);
            }    

            return ls;
        }
    }
}
