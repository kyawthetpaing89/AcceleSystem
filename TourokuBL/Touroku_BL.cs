using Models;
using DL;
using System.Data.SqlClient;
using System.Data;
using System;

namespace TourokuBL
{
    public class Touroku_BL
    {
        public string M_Project_Select_List(TourokuModel Tmodel)
        {
            BaseDL bdl = new BaseDL();
            Tmodel.Sqlprms = new SqlParameter[10];
            Tmodel.Sqlprms[0] = new SqlParameter("@BrandCD", SqlDbType.VarChar) { Value = Tmodel.BrandCD };
            Tmodel.Sqlprms[1] = new SqlParameter("@BrandName", SqlDbType.VarChar) { Value = Tmodel.BrandName };
            Tmodel.Sqlprms[2] = new SqlParameter("@Season", SqlDbType.TinyInt) { Value = Tmodel.Season };
            Tmodel.Sqlprms[3] = new SqlParameter("@Year", SqlDbType.Int) { Value = Tmodel.Year };
            Tmodel.Sqlprms[4] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = Tmodel.ProjectCD };
            Tmodel.Sqlprms[5] = new SqlParameter("@ProjecName", SqlDbType.VarChar) { Value = Tmodel.ProjecName };
            Tmodel.Sqlprms[6] = new SqlParameter("@PeriodStart", SqlDbType.Int) { Value = Tmodel.PeriodStart };
            Tmodel.Sqlprms[7] = new SqlParameter("@PeriodEnd", SqlDbType.Int) { Value = Tmodel.PeriodEnd };
            Tmodel.Sqlprms[8] = new SqlParameter("@ProjectManager", SqlDbType.VarChar) { Value = Tmodel.ProjectManager };
            Tmodel.Sqlprms[9] = new SqlParameter("@UserName", SqlDbType.VarChar) { Value = Tmodel.UserName };

            return bdl.SelectJson("M_Project_Select_List", Tmodel.Sqlprms);    
        }
    }

    
}

