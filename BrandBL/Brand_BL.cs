using Models;
using DL;
using System.Data.SqlClient;
using System.Data;
using System;

namespace BrandBL
{
    public class Brand_BL
    {
        public string M_Brand_Select(BrandModel Umodel)
        {
            BaseDL bdl = new BaseDL();
            Umodel.Sqlprms = new SqlParameter[2];
            Umodel.Sqlprms[0] = new SqlParameter("@BrandCD", SqlDbType.VarChar) { Value = Umodel.BrandCD };
            Umodel.Sqlprms[1] = new SqlParameter("@BrandName", SqlDbType.VarChar) { Value = Umodel.BrandName };

            return bdl.SelectJson("M_Brand_Select", Umodel.Sqlprms);
        }
        public string Brand_CUD(BrandModel Umodel)
        {
            BaseDL bdl = new BaseDL();
            if (Umodel.Mode.Equals("New"))
            {
                Umodel.SPName = "M_Brand_Insert";
                Umodel.Sqlprms = new SqlParameter[2];
                Umodel.Sqlprms[0] = new SqlParameter("@BrandCD", SqlDbType.VarChar) { Value = Umodel.BrandCD };
                Umodel.Sqlprms[1] = new SqlParameter("@BrandName", SqlDbType.VarChar) { Value = Umodel.BrandName };
                
            }
            else if (Umodel.Mode.Equals("Edit"))
            {
                Umodel.SPName = "M_Brand_Update";
                Umodel.Sqlprms = new SqlParameter[2];
                Umodel.Sqlprms[0] = new SqlParameter("@BrandCD", SqlDbType.VarChar) { Value = Umodel.BrandCD };
                Umodel.Sqlprms[1] = new SqlParameter("@BrandName", SqlDbType.VarChar) { Value = Umodel.BrandName };
                
            }
            else if (Umodel.Mode.Equals("Delete"))
            {
                Umodel.SPName = "M_Brand_Delete";
                Umodel.Sqlprms = new SqlParameter[1];
                Umodel.Sqlprms[0] = new SqlParameter("@BrandCD", SqlDbType.VarChar) { Value = Umodel.BrandCD };
            }
            return bdl.SelectJson(Umodel.SPName, Umodel.Sqlprms);
        }
    }
}
