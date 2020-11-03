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
            Tnmodel.Sqlprms[0] = new SqlParameter("@Year", SqlDbType.Int) { Value = (object)Tnmodel.Year ?? DBNull.Value };
            Tnmodel.Sqlprms[1] = new SqlParameter("@BrandCD", SqlDbType.VarChar) { Value = Tnmodel.BrandCD };
            Tnmodel.Sqlprms[2] = new SqlParameter("@BrandName", SqlDbType.VarChar) { Value = Tnmodel.BrandName };
            Tnmodel.Sqlprms[3] = new SqlParameter("@Season", SqlDbType.VarChar) { Value = Tnmodel.Season };
            Tnmodel.Sqlprms[4] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = Tnmodel.ProjectCD };
            Tnmodel.Sqlprms[5] = new SqlParameter("@ProjectName", SqlDbType.VarChar) { Value = Tnmodel.ProjectName };
            Tnmodel.Sqlprms[6] = new SqlParameter("@HinbanCD", SqlDbType.VarChar) { Value = Tnmodel.HinbanCD };
            Tnmodel.Sqlprms[7] = new SqlParameter("@HinbanName", SqlDbType.VarChar) { Value = Tnmodel.HinbanName };
            Tnmodel.Sqlprms[8] = new SqlParameter("@DeliveryStartDate", SqlDbType.Date) { Value = Tnmodel.DeliveryStartDate };
            Tnmodel.Sqlprms[9] = new SqlParameter("@DeliveryEndDate", SqlDbType.Date) { Value = Tnmodel.DeliveryEndDate };
            Tnmodel.Sqlprms[10] = new SqlParameter("@DeliveryStatus", SqlDbType.TinyInt) { Value = (object)Tnmodel.DeliveryStatus ??  DBNull.Value };

            return bdl.SelectJson("D_Delivery_Search", Tnmodel.Sqlprms);
        }

        public string M_Project_Nouhin_ShowData(TourokuNouhinModel Tnmodel)
        {
            BaseDL bdl = new BaseDL();
            Tnmodel.Sqlprms = new SqlParameter[1];
            Tnmodel.Sqlprms[0] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = Tnmodel.ProjectCD };

            return bdl.SelectJson("M_Project_Nouhin_ShowData", Tnmodel.Sqlprms);
        }

        public string M_Project_Select_NouhinEntry(TourokuNouhinModel Tnmodel)
        {
            BaseDL bdl = new BaseDL();
            Tnmodel.Sqlprms = new SqlParameter[3];
            Tnmodel.Sqlprms[0] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = Tnmodel.ProjectCD };
            Tnmodel.Sqlprms[1] = new SqlParameter("@Mode", SqlDbType.VarChar) { Value = Tnmodel.Mode };
            Tnmodel.Sqlprms[2] = new SqlParameter("@DeliveryDate", SqlDbType.VarChar) { Value = Tnmodel.DeliveryStartDate };

            return bdl.SelectJson("M_Project_Select_NouhinEntry", Tnmodel.Sqlprms);
        }

        public string Nouhin_CUD(TourokuNouhinModel Tnmodel)
        {
            BaseDL bdl = new BaseDL();
            if (Tnmodel.Mode.Equals("New"))
            {
                Tnmodel.SPName = "M_Nouhin_Insert";
                Tnmodel.Sqlprms = new SqlParameter[5];
                Tnmodel.Sqlprms[0] = new SqlParameter("@DeliveryDate", SqlDbType.VarChar) { Value = Tnmodel.DeliveryStartDate };
                Tnmodel.Sqlprms[1] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = Tnmodel.ProjectCD };
                Tnmodel.Sqlprms[2] = new SqlParameter("@HinbanCD", SqlDbType.VarChar) { Value = Tnmodel.HinbanCD };
                Tnmodel.Sqlprms[3] = new SqlParameter("@Remarks", SqlDbType.VarChar) { Value = Tnmodel.Remarks };
                Tnmodel.Sqlprms[4] = new SqlParameter("@DeliveryAmount", SqlDbType.VarChar) { Value = Tnmodel.DeliveryAmount };
            }
            else if (Tnmodel.Mode.Equals("Edit"))
            {
                Tnmodel.SPName = "M_Nouhin_Update";
                Tnmodel.Sqlprms = new SqlParameter[5];
                Tnmodel.Sqlprms[0] = new SqlParameter("@DeliveryDate", SqlDbType.VarChar) { Value = Tnmodel.DeliveryStartDate };
                Tnmodel.Sqlprms[1] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = Tnmodel.ProjectCD };
                Tnmodel.Sqlprms[2] = new SqlParameter("@HinbanCD", SqlDbType.VarChar) { Value = Tnmodel.HinbanCD };
                Tnmodel.Sqlprms[3] = new SqlParameter("@Remarks", SqlDbType.VarChar) { Value = Tnmodel.Remarks };
                Tnmodel.Sqlprms[4] = new SqlParameter("@DeliveryAmount", SqlDbType.VarChar) { Value = Tnmodel.DeliveryAmount };
            }
            else if (Tnmodel.Mode.Equals("Delete"))
            {
                Tnmodel.SPName = "M_Nouhin_Delete";
                Tnmodel.Sqlprms = new SqlParameter[1];
                Tnmodel.Sqlprms[0] = new SqlParameter("@DeliveryDate", SqlDbType.VarChar) { Value = Tnmodel.DeliveryStartDate };
            }

            return bdl.SelectJson(Tnmodel.SPName, Tnmodel.Sqlprms);
        }

        public string M_NouhinBS_Select(TourokuNouhinModel Tnmodel)
        {
            BaseDL bdl = new BaseDL();
            Tnmodel.Sqlprms = new SqlParameter[5];
            Tnmodel.Sqlprms[0] = new SqlParameter("@Year", SqlDbType.Int) { Value = (object)Tnmodel.Year ?? DBNull.Value};
            Tnmodel.Sqlprms[1] = new SqlParameter("@BrandCD", SqlDbType.VarChar) { Value = Tnmodel.BrandCD };
            Tnmodel.Sqlprms[2] = new SqlParameter("@Season", SqlDbType.TinyInt) { Value = (object)Tnmodel.Season ?? DBNull.Value};
            Tnmodel.Sqlprms[3] = new SqlParameter("@PeriodStart", SqlDbType.Int) { Value = (object)Tnmodel.PeriodStart ?? DBNull.Value};
            Tnmodel.Sqlprms[4] = new SqlParameter("@PeriodEnd", SqlDbType.Int) { Value = (object)Tnmodel.PeriodEnd ?? DBNull.Value};

            return bdl.SelectJson("M_NouhinBS_Select", Tnmodel.Sqlprms);
        }

        public string M_NouhinBS_Insert(TourokuNouhinModel Tnmodel)
        {
            BaseDL bdl = new BaseDL();
            Tnmodel.Sqlprms = new SqlParameter[3];
            Tnmodel.Sqlprms[0] = new SqlParameter("@DeliveryDate", SqlDbType.VarChar) { Value = Tnmodel.DeliveryStartDate };
            Tnmodel.Sqlprms[1] = new SqlParameter("@Remarks", SqlDbType.VarChar) { Value = Tnmodel.Remarks };
            Tnmodel.Sqlprms[2] = new SqlParameter("@TableData", SqlDbType.VarChar) { Value = Tnmodel.TableData };

            return bdl.SelectJson("M_NouhinBS_Insert", Tnmodel.Sqlprms);
        }
    }
}
