using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DL
{
    public class ReadIni
    {
        public string GetConnectionString()
        {
            string filePath = @"C:\DBConfig\DBConfig.ini";

            if (System.IO.File.Exists(filePath))
            {
                return GetInformationOfIniFile(filePath);
            }
            else
            {
                return "";
            }
        }

        private string GetInformationOfIniFile(string filePath)
        {
            IniFileReader ifd = new IniFileReader(filePath);

            return "Data Source=" + ifd.IniReadValue("Accele", "ConnectionString").Split(',')[0] +
                    ";Initial Catalog=" + ifd.IniReadValue("Accele", "ConnectionString").Split(',')[1] +
                    ";Persist Security Info=True;User ID=" + ifd.IniReadValue("Accele", "ConnectionString").Split(',')[2] +
                    ";Password=" + ifd.IniReadValue("Accele", "ConnectionString").Split(',')[3] +
                    ";Connection Timeout=" + ifd.IniReadValue("Accele", "ConnectionString").Split(',')[4]; 
        }
    }
}
