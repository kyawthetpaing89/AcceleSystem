using DL;
using Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Print_GenkaBL
{
    public class Print_Genka_BL
    {
        public string M_Brand_ExistsCheck(Print_GenkaModel Pmodel)
        {
            BaseDL bdl = new BaseDL();
            Pmodel.Sqlprms = new SqlParameter[1];
            Pmodel.Sqlprms[0] = new SqlParameter("@BrandCD", SqlDbType.VarChar) { Value = Pmodel.BrandCD };
            return bdl.SelectJson("M_Brand_ExistsCheck", Pmodel.Sqlprms);
        }

        public string M_Project_ExistsCheck(Print_GenkaModel Pmodel)
        {
            BaseDL bdl = new BaseDL();
            Pmodel.Sqlprms = new SqlParameter[1];
            Pmodel.Sqlprms[0] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = Pmodel.ProjectCD };
            return bdl.SelectJson("M_Project_ExistsCheck", Pmodel.Sqlprms);
        }
    }
}
