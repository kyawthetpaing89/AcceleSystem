using Models;
using DL;
using System.Data.SqlClient;
using System.Data;
using System;

namespace TourokuNouhinBL
{
    public class Touroku_Nouhin_BL
    {
        public string D_Delivery_Search(TourokuNouhinModel Tnmodel)
        {
            BaseDL bdl = new BaseDL();
            Tnmodel.Sqlprms = new SqlParameter[11];
            Tnmodel.Sqlprms[0] = new SqlParameter("@Year", SqlDbType.Int) { Value = Tnmodel.Year };
            Tnmodel.Sqlprms[1] = new SqlParameter("@BrandCD", SqlDbType.VarChar) { Value = Tnmodel.BrandCD };
            Tnmodel.Sqlprms[2] = new SqlParameter("@BrandName", SqlDbType.VarChar) { Value = Tnmodel.BrandName };
            Tnmodel.Sqlprms[3] = new SqlParameter("@Season", SqlDbType.TinyInt) { Value = Tnmodel.Season };
            Tnmodel.Sqlprms[4] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = Tnmodel.ProjectCD };
            Tnmodel.Sqlprms[5] = new SqlParameter("@ProjectName", SqlDbType.VarChar) { Value = Tnmodel.ProjectName };
            Tnmodel.Sqlprms[6] = new SqlParameter("@HinbanCD", SqlDbType.VarChar) { Value = Tnmodel.HinbanCD };
            Tnmodel.Sqlprms[7] = new SqlParameter("@HinbanName", SqlDbType.VarChar) { Value = Tnmodel.HinbanName };
            Tnmodel.Sqlprms[8] = new SqlParameter("@DeliveryStartDate", SqlDbType.Date) { Value = Tnmodel.DeliveryStartDate };
            Tnmodel.Sqlprms[9] = new SqlParameter("@DeliveryEndDate", SqlDbType.Date) { Value = Tnmodel.DeliveryEndDate };
            Tnmodel.Sqlprms[10] = new SqlParameter("@DeliveryStatus", SqlDbType.TinyInt) { Value = Tnmodel.DeliveryStatus };

            return bdl.SelectJson("D_Delivery_Search", Tnmodel.Sqlprms);
        }

        public string M_Project_Nouhin_ShowData(TourokuNouhinModel Tnmodel)
        {
            BaseDL bdl = new BaseDL();
            Tnmodel.Sqlprms = new SqlParameter[1];
            Tnmodel.Sqlprms[0] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = Tnmodel.ProjectCD };

            return bdl.SelectJson("M_Project_Nouhin_ShowData", Tnmodel.Sqlprms);
        }

        public string D_Delivery_Select_NouhinEntry(TourokuNouhinModel Tnmodel)
        {
            BaseDL bdl = new BaseDL();
            Tnmodel.Sqlprms = new SqlParameter[1];
            Tnmodel.Sqlprms[0] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = Tnmodel.ProjectCD };

            return bdl.SelectJson("D_Delivery_Select_NouhinEntry", Tnmodel.Sqlprms);
        }
    }
}
