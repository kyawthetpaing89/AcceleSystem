using Models;
using DL;
using System.Data.SqlClient;
using System.Data;
using System;

namespace BrandBL
{
    public class Brand_BL
    { 
        public string M_Brand_Select(BrandModel bmodel)
        {
            BaseDL bdl = new BaseDL();
            bmodel.Sqlprms = new SqlParameter[2];
            bmodel.Sqlprms[0] = new SqlParameter("@BrandCD", SqlDbType.VarChar) { Value = bmodel.BrandCD };
            bmodel.Sqlprms[1] = new SqlParameter("@BrandName", SqlDbType.VarChar) { Value = bmodel.BrandName };

            return bdl.SelectJson("M_Brand_Select", bmodel.Sqlprms);
        }
        public string Brand_CUD(BrandModel bmodel)
        {
            BaseDL bdl = new BaseDL();
            if (bmodel.Mode.Equals("New"))
            {
                bmodel.SPName = "M_Brand_Insert";
                bmodel.Sqlprms = new SqlParameter[2];
                bmodel.Sqlprms[0] = new SqlParameter("@BrandCD", SqlDbType.VarChar) { Value = bmodel.BrandCD };
                bmodel.Sqlprms[1] = new SqlParameter("@BrandName", SqlDbType.VarChar) { Value = bmodel.BrandName };
                
            }
            else if (bmodel.Mode.Equals("Edit"))
            {
                bmodel.SPName = "M_Brand_Update";
                bmodel.Sqlprms = new SqlParameter[2];
                bmodel.Sqlprms[0] = new SqlParameter("@BrandCD", SqlDbType.VarChar) { Value = bmodel.BrandCD };
                bmodel.Sqlprms[1] = new SqlParameter("@BrandName", SqlDbType.VarChar) { Value = bmodel.BrandName };
                
            }
            else if (bmodel.Mode.Equals("Delete"))
            {
                bmodel.SPName = "M_Brand_Delete";
                bmodel.Sqlprms = new SqlParameter[1];
                bmodel.Sqlprms[0] = new SqlParameter("@BrandCD", SqlDbType.VarChar) { Value = bmodel.BrandCD };
            }
            return bdl.SelectJson(bmodel.SPName, bmodel.Sqlprms);
        }
    }
}
