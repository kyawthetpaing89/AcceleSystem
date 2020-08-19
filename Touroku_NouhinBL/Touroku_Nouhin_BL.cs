using Models;
using DL;
using System.Data.SqlClient;
using System.Data;
using System;

namespace TourokuNouhinBL
{
    public class Touroku_Nouhin_BL
    {
        public string UserLogin_Select(TourokuNouhinModel Tnmodel)
        {
            BaseDL bdl = new BaseDL();
            Tnmodel.Sqlprms = new SqlParameter[2];
            Tnmodel.Sqlprms[0] = new SqlParameter("@Year", SqlDbType.VarChar) { Value = Tnmodel.Year };
            Tnmodel.Sqlprms[1] = new SqlParameter("@BrandCD", SqlDbType.VarChar) { Value = Tnmodel.BrandCD };
            Tnmodel.Sqlprms[0] = new SqlParameter("@BrandName", SqlDbType.VarChar) { Value = Tnmodel.BrandName };
            Tnmodel.Sqlprms[1] = new SqlParameter("@Season", SqlDbType.VarChar) { Value = Tnmodel.Season };
            Tnmodel.Sqlprms[0] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = Tnmodel.ProjectCD };
            Tnmodel.Sqlprms[1] = new SqlParameter("@ProjectName", SqlDbType.VarChar) { Value = Tnmodel.ProjectName };
            Tnmodel.Sqlprms[0] = new SqlParameter("@HinbanCD", SqlDbType.VarChar) { Value = Tnmodel.HinbanCD };
            Tnmodel.Sqlprms[0] = new SqlParameter("@HinbanName", SqlDbType.VarChar) { Value = Tnmodel.HinbanName };
            Tnmodel.Sqlprms[1] = new SqlParameter("@DeliveryStartDate", SqlDbType.VarChar) { Value = Tnmodel.DeliveryStartDate };
            Tnmodel.Sqlprms[1] = new SqlParameter("@DeliveryEndDate", SqlDbType.VarChar) { Value = Tnmodel.DeliveryEndDate };

            return bdl.SelectJson("D_Delivery_Search", Tnmodel.Sqlprms);
        }
    }
}
