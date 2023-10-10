using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Bai11_Tuan5
{
    internal class FileIO
    {
        static public string docCauHoi(string duongdan)
        {
            string s = "";

            Assembly asm = Assembly.GetExecutingAssembly();
            StreamReader reader = new StreamReader(asm.GetManifestResourceStream(duongdan));
            s = reader.ReadToEnd();
            reader.Close();

            return s;
        }

        static public List<string> docDapAn (string duongdan) 
        {
            string dapan = "";

            List<string> ls = new List<string>();
            Assembly asm = Assembly.GetExecutingAssembly();
            StreamReader reader = new StreamReader(asm.GetManifestResourceStream(duongdan));
            while ((dapan = reader.ReadLine()) != null)
            {
                ls.Add(dapan);
            }    

            return ls;
        }
    }
}
