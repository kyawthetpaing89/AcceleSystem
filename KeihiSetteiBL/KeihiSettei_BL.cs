using Models;
using DL;
using System.Data.SqlClient;
using System.Data;
using System;

namespace KeihiSetteiBL
{
    public class KeihiSettei_BL
    {
        public string M_Keihi_Select_List(KeihiSetteiModel Kmodel)
        {
            BaseDL bdl = new BaseDL();
            Kmodel.Sqlprms = new SqlParameter[2];
            Kmodel.Sqlprms[0] = new SqlParameter("@CostCD", SqlDbType.VarChar) { Value = Kmodel.CostCD };
            Kmodel.Sqlprms[1] = new SqlParameter("@CostName", SqlDbType.VarChar) { Value = Kmodel.CostName };

            return bdl.SelectJson("M_Keihi_Select_List", Kmodel.Sqlprms);
        }

        public string M_Keihi_Select_Entry(KeihiSetteiModel Kmodel)
        {
            BaseDL bdl = new BaseDL();
            Kmodel.Sqlprms = new SqlParameter[1];
            Kmodel.Sqlprms[0] = new SqlParameter("@CostCD", SqlDbType.VarChar) { Value = Kmodel.CostCD };

            return bdl.SelectJson("M_Keihi_Select_Entry", Kmodel.Sqlprms);
        }

        public string M_Keihi_ExistsCheck(KeihiSetteiModel Kmodel)
        {
            BaseDL bdl = new BaseDL();
            Kmodel.Sqlprms = new SqlParameter[1];
            Kmodel.Sqlprms[0] = new SqlParameter("@CostCD", SqlDbType.VarChar) { Value = (object)Kmodel.CostCD ?? DBNull.Value };
            return bdl.SelectJson("M_Keihi_ExistsCheck", Kmodel.Sqlprms);
        }

        public string M_Kanjo_Name_Select(KanjoModel Kjmodel)
        {
            BaseDL bdl = new BaseDL();
            Kjmodel.Sqlprms = new SqlParameter[1];
            Kjmodel.Sqlprms[0] = new SqlParameter("@KanjoCD", SqlDbType.VarChar) { Value = (object)Kjmodel.KanjoCD ?? DBNull.Value };
            return bdl.SelectJson("M_Kanjo_Name_Select", Kjmodel.Sqlprms);
        }

        public string M_Hojo_Name_Select(HojoModel Hjmodel)
        {
            BaseDL bdl = new BaseDL();
            Hjmodel.Sqlprms = new SqlParameter[2];
            Hjmodel.Sqlprms[0] = new SqlParameter("@HojoCD", SqlDbType.VarChar) { Value = (object)Hjmodel.HojoCD ?? DBNull.Value };
            Hjmodel.Sqlprms[1] = new SqlParameter("@KanjoCD", SqlDbType.VarChar) { Value = (object)Hjmodel.KanjoCD ?? DBNull.Value };
            return bdl.SelectJson("M_Hojo_Name_Select", Hjmodel.Sqlprms);
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
                Kmodel.Sqlprms[4] = new SqlParameter("@Accounting", SqlDbType.TinyInt) { Value = Kmodel.Accounting };
                Kmodel.Sqlprms[5] = new SqlParameter("@Allocation", SqlDbType.TinyInt) { Value = Kmodel.Allocation };

            }
            else if (Kmodel.Mode.Equals("Edit"))
            {
                Kmodel.SPName = "M_Keihi_Update";
                Kmodel.Sqlprms = new SqlParameter[6];
                Kmodel.Sqlprms[0] = new SqlParameter("@CostCD", SqlDbType.VarChar) { Value = Kmodel.CostCD };
                Kmodel.Sqlprms[1] = new SqlParameter("@CostName", SqlDbType.VarChar) { Value = Kmodel.CostName };
                Kmodel.Sqlprms[2] = new SqlParameter("@KanjoCD", SqlDbType.VarChar) { Value = Kmodel.KanjoCD };
                Kmodel.Sqlprms[3] = new SqlParameter("@HojoCD", SqlDbType.VarChar) { Value = Kmodel.HojoCD };
                Kmodel.Sqlprms[4] = new SqlParameter("@Accounting", SqlDbType.TinyInt) { Value = Kmodel.Accounting };
                Kmodel.Sqlprms[5] = new SqlParameter("@Allocation", SqlDbType.TinyInt) { Value = Kmodel.Allocation };

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
