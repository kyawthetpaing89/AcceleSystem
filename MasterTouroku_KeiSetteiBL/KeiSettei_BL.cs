using Models;
using DL;
using System.Data.SqlClient;
using System.Data;
using System;

namespace KeiSetteiBL
{
    public class KeiSettei_BL
    {
        public string M_Keihi_Select(KeiSetteiModel Kmodel)
        {
            BaseDL bdl = new BaseDL();
            Kmodel.Sqlprms = new SqlParameter[5];
            Kmodel.Sqlprms[0] = new SqlParameter("@CostCD", SqlDbType.VarChar) { Value = Kmodel.CostCD };
            Kmodel.Sqlprms[1] = new SqlParameter("@CostName", SqlDbType.VarChar) { Value = Kmodel.CostName };
            Kmodel.Sqlprms[2] = new SqlParameter("@KanjoCD", SqlDbType.VarChar) { Value = Kmodel.KanjoCD };
            Kmodel.Sqlprms[3] = new SqlParameter("@HojoCD", SqlDbType.VarChar) { Value = Kmodel.HojoCD };
            Kmodel.Sqlprms[4] = new SqlParameter("@Accounting", SqlDbType.Tinyint) { Value = Kmodel.Accounting };
            Kmodel.Sqlprms[5] = new SqlParameter("@Allocation", SqlDbType.Tinyint) { Value = Kmodel.Allocation };

            return bdl.SelectJson("M_Keihi_Select", Kmodel.Sqlprms);
        }

        public string Keihi_CUD(KeiSetteiModel Kmodel)
        {
            BaseDL bdl = new BaseDL();
            if (Kmodel.Mode.Equals("New"))
            {
                Kmodel.SPName = "M_Keihi_Insert";
                Kmodel.Sqlprms = new SqlParameter[3];
                Kmodel.Sqlprms[0] = new SqlParameter("@CostCD", SqlDbType.VarChar) { Value = Kmodel.CostCD };
                Kmodel.Sqlprms[1] = new SqlParameter("@CostName", SqlDbType.VarChar) { Value = Kmodel.CostName };
                Kmodel.Sqlprms[2] = new SqlParameter("@Accounting", SqlDbType.Tinyint) { Value = Kmodel.Accounting };
                Kmodel.Sqlprms[3] = new SqlParameter("@Allocation", SqlDbType.Tinyint) { Value = Kmodel.Allocation };
        }

            return bdl.SelectJson(Kmodel.SPName, Kmodel.Sqlprms);
        }
}
