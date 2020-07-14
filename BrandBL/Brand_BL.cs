using Models;
using DL;
using System.Data.SqlClient;
using System.Data;
using System;

namespace BrandBL
{
    public class Brand_BL
    {
        public string M_Brand_Insert(BrandModel Umodel)
        {
            BaseDL bdl = new BaseDL();
            Umodel.Sqlprms = new SqlParameter[2];
            Umodel.Sqlprms[0] = new SqlParameter("@BrandCD", SqlDbType.VarChar) { Value = Umodel.BrandCD };
            Umodel.Sqlprms[1] = new SqlParameter("@BrandName", SqlDbType.VarChar) { Value = Umodel.BrandName };

            return bdl.SelectJson("M_Brand_Insert", Umodel.Sqlprms);
        }
    }
}
