using Models;
using DL;
using System.Data.SqlClient;
using System.Data;
using System;

namespace KeihiSetteiBL
{
    public class KeihiSettei_BL
    {
        public string M_Keihi_Select(KeihiSetteiModel Kmodel)
        {
            BaseDL bdl = new BaseDL();
            Kmodel.Sqlprms = new SqlParameter[6];
            Kmodel.Sqlprms[0] = new SqlParameter("@CostCD", SqlDbType.VarChar) { Value = Kmodel.CostCD };
            Kmodel.Sqlprms[1] = new SqlParameter("@CostName", SqlDbType.VarChar) { Value = Kmodel.CostName };
            Kmodel.Sqlprms[2] = new SqlParameter("@KanjoCD", SqlDbType.VarChar) { Value = Kmodel.KanjoCD };
            Kmodel.Sqlprms[3] = new SqlParameter("@HojoCD", SqlDbType.VarChar) { Value = Kmodel.HojoCD };
            Kmodel.Sqlprms[4] = new SqlParameter("@Accounting", SqlDbType.TinyInt) { Value = Kmodel.Accounting };
            Kmodel.Sqlprms[5] = new SqlParameter("@Allocation", SqlDbType.TinyInt) { Value = Kmodel.Allocation };


            return bdl.SelectJson("M_Keihi_Select", Kmodel.Sqlprms);
        }

        public string Keihi_CUD(KeihiSetteiModel Kmodel)
        {
            BaseDL bdl = new BaseDL();
            if (Kmodel.Mode.Equals("New"))
            {
                Kmodel.SPName = "M_Keihi_Insert";
                Kmodel.Sqlprms = new SqlParameter[6];
                Kmodel.Sqlprms[0] = new SqlParameter("@CostCD", SqlDbType.VarChar) { Value = Kmodel.CostCD };
                Kmodel.Sqlprms[1] = new SqlParameter("@CostName", SqlDbType.VarChar) { Value = Kmodel.CostName };
                Kmodel.Sqlprms[2] = new SqlParameter("@KanjoCD", SqlDbType.VarChar) { Value = Kmodel.KanjoCD };
                Kmodel.Sqlprms[3] = new SqlParameter("@HojoCD", SqlDbType.VarChar) { Value = Kmodel.HojoCD };
                Kmodel.Sqlprms[4] = new SqlParameter("@Acoounting", SqlDbType.TinyInt) { Value = Kmodel.Accounting };
                Kmodel.Sqlprms[5] = new SqlParameter("@Allocation", SqlDbType.TinyInt) { Value = Kmodel.Allocation };

            }
            else if (Kmodel.Mode.Equals("Edit"))
            {
                Kmodel.SPName = "M_Keihi_Update";
                Kmodel.Sqlprms = new SqlParameter[4];
                Kmodel.Sqlprms[0] = new SqlParameter("@CostCD", SqlDbType.VarChar) { Value = Kmodel.CostCD };
                Kmodel.Sqlprms[1] = new SqlParameter("@CostName", SqlDbType.VarChar) { Value = Kmodel.CostName };
                Kmodel.Sqlprms[2] = new SqlParameter("@Accounting", SqlDbType.TinyInt) { Value = Kmodel.Accounting };
                Kmodel.Sqlprms[3] = new SqlParameter("@Allocation", SqlDbType.TinyInt) { Value = Kmodel.Allocation };

            }
            else if (Kmodel.Mode.Equals("Delete"))
            {
                Kmodel.SPName = "M_Keihi_Delete";
                Kmodel.Sqlprms = new SqlParameter[1];
                Kmodel.Sqlprms[0] = new SqlParameter("@CostCD", SqlDbType.VarChar) { Value = Kmodel.CostCD };
            }
            return bdl.SelectJson(Kmodel.SPName, Kmodel.Sqlprms);
        }
    }
}
