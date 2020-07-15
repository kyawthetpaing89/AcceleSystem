﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DL;
using Models;
using System.Data;
using System.Data.SqlClient;


namespace KanagataBL
{
    public class Kanagata_BL
    {
        public string M_Casting_Select(KanagataModel kgmodel)
        {
            BaseDL bdl = new BaseDL();
            kgmodel.Sqlprms = new SqlParameter[1];
            kgmodel.Sqlprms[0] = new SqlParameter("@CastingCD", SqlDbType.VarChar) { Value = (object)kgmodel.CastingCD ?? DBNull.Value };          
            return bdl.SelectJson("M_Casting_Select", kgmodel.Sqlprms);
        }

        public string Casting_CUD(KanagataModel kgmodel)
        {
            BaseDL bdl = new BaseDL();
            if (kgmodel.Mode.Equals("New"))
            {
                kgmodel.SPName = "M_Casting_Insert";
                kgmodel.Sqlprms = new SqlParameter[5];
                kgmodel.Sqlprms[0] = new SqlParameter("@CastingCD", SqlDbType.VarChar) { Value = kgmodel.CastingCD };
                kgmodel.Sqlprms[1] = new SqlParameter("@CastingName", SqlDbType.VarChar) { Value = kgmodel.CastingName };
                kgmodel.Sqlprms[2] = new SqlParameter("@BrandCD", SqlDbType.VarChar) { Value = kgmodel.BrandCD };
                kgmodel.Sqlprms[3] = new SqlParameter("@BrandName", SqlDbType.VarChar) { Value = kgmodel.BrandName };
                kgmodel.Sqlprms[4] = new SqlParameter("@UseLimit", SqlDbType.Date) { Value = kgmodel.UseLimit };

            }
            else if (kgmodel.Mode.Equals("Edit"))
            {
                kgmodel.SPName = "M_Casting_Update";
                kgmodel.Sqlprms = new SqlParameter[5];
                kgmodel.Sqlprms[0] = new SqlParameter("@CastingCD", SqlDbType.VarChar) { Value = kgmodel.CastingCD };
                kgmodel.Sqlprms[1] = new SqlParameter("@CastingName", SqlDbType.VarChar) { Value = kgmodel.CastingName };
                kgmodel.Sqlprms[2] = new SqlParameter("@BrandCD", SqlDbType.VarChar) { Value = kgmodel.BrandCD };
                kgmodel.Sqlprms[3] = new SqlParameter("@BrandName", SqlDbType.VarChar) { Value = kgmodel.BrandName };
                kgmodel.Sqlprms[4] = new SqlParameter("@UseLimit", SqlDbType.Date) { Value = kgmodel.UseLimit };

            }
            else if (kgmodel.Mode.Equals("Delete"))
            {
                kgmodel.SPName = "M_Casting_Delete";
                kgmodel.Sqlprms = new SqlParameter[5];
                kgmodel.Sqlprms[0] = new SqlParameter("@CastingCD", SqlDbType.VarChar) { Value = kgmodel.CastingCD };
                kgmodel.Sqlprms[1] = new SqlParameter("@CastingName", SqlDbType.VarChar) { Value = kgmodel.CastingName };
                kgmodel.Sqlprms[2] = new SqlParameter("@BrandCD", SqlDbType.VarChar) { Value = kgmodel.BrandCD };
                kgmodel.Sqlprms[3] = new SqlParameter("@BrandName", SqlDbType.VarChar) { Value = kgmodel.BrandName };
                kgmodel.Sqlprms[4] = new SqlParameter("@UseLimit", SqlDbType.Date) { Value = kgmodel.UseLimit };
            }
            return bdl.SelectJson(kgmodel.SPName, kgmodel.Sqlprms);
        }
    }
}
