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
        public string Print_GenkaCSV(Print_GenkaModel Pmodel)
        {
            BaseDL bdl = new BaseDL();
            Pmodel.Sqlprms = new SqlParameter[8];
            Pmodel.Sqlprms[0] = new SqlParameter("@targetyear", SqlDbType.VarChar) { Value = (object)Pmodel.TargetYear ?? DBNull.Value };
            Pmodel.Sqlprms[1] = new SqlParameter("@BrandCD", SqlDbType.VarChar) { Value = (object)Pmodel.BrandCD ?? DBNull.Value };
            Pmodel.Sqlprms[2] = new SqlParameter("@BrandName", SqlDbType.VarChar) { Value = (object)Pmodel.BrandName ?? DBNull.Value };
            Pmodel.Sqlprms[3] = new SqlParameter("@Season", SqlDbType.VarChar) { Value = (object)Pmodel.Season ?? DBNull.Value };
            Pmodel.Sqlprms[4] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = (object)Pmodel.ProjectCD ?? DBNull.Value };
            Pmodel.Sqlprms[5] = new SqlParameter("@ProjectName", SqlDbType.VarChar) { Value = (object)Pmodel.ProjectName ?? DBNull.Value };
            Pmodel.Sqlprms[6] = new SqlParameter("@DeliveryStatus", SqlDbType.VarChar) { Value = (object)Pmodel.DeliveryStatus ?? DBNull.Value };
            Pmodel.Sqlprms[7] = new SqlParameter("@LoginID", SqlDbType.VarChar) { Value = (object)Pmodel.LoginID ?? DBNull.Value };
            //Pmodel.Sqlprms[6] = new SqlParameter("@FiscalYYYYMM", SqlDbType.Int) { Value = (object)Pmodel.Year ?? DBNull.Value };
            return bdl.SelectJson("Print_GenkaCSV", Pmodel.Sqlprms);
        }

        public string Print_Genka_ProjectData(Print_GenkaModel Pmodel)
        {
            BaseDL bdl = new BaseDL();
            Pmodel.Sqlprms = new SqlParameter[5];
            Pmodel.Sqlprms[0] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = (object)Pmodel.ProjectCD ?? DBNull.Value };
            Pmodel.Sqlprms[1] = new SqlParameter("@BrandCD", SqlDbType.VarChar) { Value = (object)Pmodel.BrandCD ?? DBNull.Value };
            Pmodel.Sqlprms[2] = new SqlParameter("@LoginID", SqlDbType.VarChar) { Value = (object)Pmodel.LoginID ?? DBNull.Value };
            Pmodel.Sqlprms[3] = new SqlParameter("@HinbanCD", SqlDbType.VarChar) { Value = (object)Pmodel.HinbanCD ?? DBNull.Value };
            Pmodel.Sqlprms[4] = new SqlParameter("@Type", SqlDbType.VarChar) { Value = (object)Pmodel.Type ?? DBNull.Value };
            return bdl.SelectJson("Print_Genka_ProjectData", Pmodel.Sqlprms);
        }

        public string M_Contrl_Year_ExitCheck(Print_GenkaModel Pmodel) // for 対象年度
        {
            BaseDL bdl = new BaseDL();
            Pmodel.Sqlprms = new SqlParameter[0];
            return bdl.SelectJson("M_Contrl_Year_ExitCheck");
        }
    }
}
