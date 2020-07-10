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

            return "Data Source=" + ifd.IniReadValue("Database", "AcceleDB").Split(',')[0] +
                    ";Initial Catalog=" + ifd.IniReadValue("Database", "AcceleDB").Split(',')[1] +
                    ";Persist Security Info=True;User ID=" + ifd.IniReadValue("Database", "AcceleDB").Split(',')[2] +
                    ";Password=" + ifd.IniReadValue("Database", "AcceleDB").Split(',')[3] +
                    ";";
        }
    }
}
