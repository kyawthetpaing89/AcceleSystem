using DL;
using Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Koushin_GenkaBL
{
    public class Koushin_Genka_BL
    {
        public string M_Contrl_YearMonth_ExitCheck(Koushin_GenkaModel kgmodel)
        {
            BaseDL bdl = new BaseDL();
            kgmodel.Sqlprms = new SqlParameter[0];
            return bdl.SelectJson("M_Contrl_YearMonth_ExitCheck");
        }
        public string M_Contrl_YearMonth_Genka_Update(Koushin_GenkaModel kgmodel)
        {
            BaseDL bdl = new BaseDL();
            kgmodel.Sqlprms = new SqlParameter[0];
            //kgmodel.Sqlprms[0] = new SqlParameter("@Date", SqlDbType.VarChar) { Value = (object)kgmodel.processing_date ?? DBNull.Value };
            return bdl.InsertUpdateDeleteData("M_Contrl_YearMonth_Genka_Update", kgmodel.Sqlprms);
        }

    }
}
