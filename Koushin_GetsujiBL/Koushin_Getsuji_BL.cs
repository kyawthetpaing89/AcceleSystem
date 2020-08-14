using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DL;
using Models;
using System.Data;
using System.Data.SqlClient;

namespace Koushin_GetsujiBL
{
    public class Koushin_Getsuji_BL
    {
        public string M_Contrl_YearMonth_ExitCheck(Koushin_GetsujiModel kgmodel)
        {
            BaseDL bdl = new BaseDL();
            kgmodel.Sqlprms = new SqlParameter[0];
            return bdl.SelectJson("M_Contrl_YearMonth_ExitCheck");
        }

        public string M_Contrl_YearMonth_Insert(Koushin_GetsujiModel kgmodel)
        {
            BaseDL bdl = new BaseDL();
            kgmodel.Sqlprms = new SqlParameter[1];
            kgmodel.Sqlprms[0] = new SqlParameter("@Date", SqlDbType.Int) { Value = (object)kgmodel.processing_date ?? DBNull.Value };
            return bdl.SelectJson("M_Contrl_YearMonth_Insert", kgmodel.Sqlprms);
        }
    }
}
