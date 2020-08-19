using Models;
using DL;
using System.Data.SqlClient;
using System.Data;
using System;

namespace TourokuProjectBL
{
    public class TourokuProject_BL
    {
        public string M_Project_Select_List(TourokuProjectModel Tmodel)
        {
            BaseDL bdl = new BaseDL();
            Tmodel.Sqlprms = new SqlParameter[10];
            Tmodel.Sqlprms[0] = new SqlParameter("@BrandCD", SqlDbType.VarChar) { Value = Tmodel.BrandCD };
            Tmodel.Sqlprms[1] = new SqlParameter("@BrandName", SqlDbType.VarChar) { Value = Tmodel.BrandName };
            Tmodel.Sqlprms[2] = new SqlParameter("@Season", SqlDbType.TinyInt) { Value = Tmodel.Season };
            Tmodel.Sqlprms[3] = new SqlParameter("@Year", SqlDbType.Int) { Value = (object)Tmodel.Year ?? DBNull.Value};
            Tmodel.Sqlprms[4] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = Tmodel.ProjectCD };
            Tmodel.Sqlprms[5] = new SqlParameter("@ProjectName", SqlDbType.VarChar) { Value = Tmodel.ProjectName };
            Tmodel.Sqlprms[6] = new SqlParameter("@PeriodStart", SqlDbType.Int) { Value = (object)Tmodel.PeriodStart ?? DBNull.Value };
            Tmodel.Sqlprms[7] = new SqlParameter("@PeriodEnd", SqlDbType.Int) { Value = (object)Tmodel.PeriodEnd ?? DBNull.Value};
            Tmodel.Sqlprms[8] = new SqlParameter("@ProjectManager", SqlDbType.VarChar) { Value = Tmodel.ProjectManager };
            Tmodel.Sqlprms[9] = new SqlParameter("@UserName", SqlDbType.VarChar) { Value = Tmodel.UserName };

            return bdl.SelectJson("M_Project_Select_List", Tmodel.Sqlprms);
        }
        public string M_Casting_ExistsCheck(TourokuProjectModel Tmodel)
        {
            BaseDL bdl = new BaseDL();
            Tmodel.Sqlprms = new SqlParameter[1];
            Tmodel.Sqlprms[0] = new SqlParameter("@CastingCD", SqlDbType.VarChar) { Value = (object)Tmodel.CastingCD ?? DBNull.Value };
            return bdl.SelectJson("M_Casting_ExistsCheck", Tmodel.Sqlprms);

        }

        public string M_Hinan_Select(TourokuProjectModel Tmodel)
        {
            BaseDL bdl = new BaseDL();
            Tmodel.Sqlprms = new SqlParameter[2];
            Tmodel.Sqlprms[0] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = (object)Tmodel.ProjectCD  ?? DBNull.Value };
            Tmodel.Sqlprms[1] = new SqlParameter("@HinbanCD", SqlDbType.VarChar) { Value = (object)Tmodel.HinbanCD ?? DBNull.Value };
            return bdl.SelectJson("M_Hinan_Select", Tmodel.Sqlprms);

        }

    }
}