using Models;
using DL;
using System.Data.SqlClient;
using System.Data;
using System;

namespace TourokuProjectBL
{
    public class TourokuProject_BL
    {
        public string M_Project_Select_List(TourokuProjectModel Tmodel)
        {
            BaseDL bdl = new BaseDL();
            Tmodel.Sqlprms = new SqlParameter[10];
            Tmodel.Sqlprms[0] = new SqlParameter("@BrandCD", SqlDbType.VarChar) { Value = Tmodel.BrandCD };
            Tmodel.Sqlprms[1] = new SqlParameter("@BrandName", SqlDbType.VarChar) { Value = Tmodel.BrandName };
            Tmodel.Sqlprms[2] = new SqlParameter("@Season", SqlDbType.TinyInt) { Value = Tmodel.Season };
            Tmodel.Sqlprms[3] = new SqlParameter("@Year", SqlDbType.Int) { Value = (object)Tmodel.Year ?? DBNull.Value};
            Tmodel.Sqlprms[4] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = Tmodel.ProjectCD };
            Tmodel.Sqlprms[5] = new SqlParameter("@ProjectName", SqlDbType.VarChar) { Value = Tmodel.ProjectName };
            Tmodel.Sqlprms[6] = new SqlParameter("@PeriodStart", SqlDbType.Int) { Value = (object)Tmodel.PeriodStart ?? DBNull.Value };
            Tmodel.Sqlprms[7] = new SqlParameter("@PeriodEnd", SqlDbType.Int) { Value = (object)Tmodel.PeriodEnd ?? DBNull.Value};
            Tmodel.Sqlprms[8] = new SqlParameter("@ProjectManager", SqlDbType.VarChar) { Value = Tmodel.ProjectManager };
            Tmodel.Sqlprms[9] = new SqlParameter("@UserName", SqlDbType.VarChar) { Value = Tmodel.UserName };

            return bdl.SelectJson("M_Project_Select_List", Tmodel.Sqlprms);
        }
        public string M_Project_Select_Entry(TourokuProjectModel Tmodel)
        {
            BaseDL bdl = new BaseDL();
            Tmodel.Sqlprms = new SqlParameter[1];
            Tmodel.Sqlprms[0] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = Tmodel.ProjectCD };
      
            return bdl.SelectJson("M_Project_Select_Entry", Tmodel.Sqlprms);
        }
        //public string Project_CUD(TourokuProjectModel Tmodel)
        //{
        //    BaseDL bdl = new BaseDL();
        //    if (Tmodel.Mode.Equals("New"))
        //    {
        //        Tmodel.SPName = "M_Project_Insert";
        //        Tmodel.Sqlprms = new SqlParameter[6];
        //        Tmodel.Sqlprms[0] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = Tmodel.ProjectCD };
        //        Tmodel.Sqlprms[1] = new SqlParameter("@ProjectName", SqlDbType.VarChar) { Value = Tmodel.ProjectName };
        //        Tmodel.Sqlprms[2] = new SqlParameter("@Year", SqlDbType.Int) { Value = Tmodel.Year };
        //        Tmodel.Sqlprms[3] = new SqlParameter("@BrandCD", SqlDbType.VarChar) { Value = Tmodel.BrandCD };



                

        //    }
        //}

            public string M_Casting_ExistsCheck(TourokuProjectModel Tmodel)
        {
            BaseDL bdl = new BaseDL();
            Tmodel.Sqlprms = new SqlParameter[1];
            Tmodel.Sqlprms[0] = new SqlParameter("@CastingCD", SqlDbType.VarChar) { Value = (object)Tmodel.CastingCD ?? DBNull.Value };
            return bdl.SelectJson("M_Casting_ExistsCheck", Tmodel.Sqlprms);

        }

        public string M_Project_ExistsCheck(TourokuProjectModel Tmodel)
        {
            BaseDL bdl = new BaseDL();
            Tmodel.Sqlprms = new SqlParameter[1];
            Tmodel.Sqlprms[0] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = (object)Tmodel.ProjectCD ?? DBNull.Value };
            return bdl.SelectJson("M_Project_ExistsCheck", Tmodel.Sqlprms);

        }

        public string M_Hinban_ProjectExistCheck(TourokuProjectModel Tmodel)
        {
            BaseDL bdl = new BaseDL();
            Tmodel.Sqlprms = new SqlParameter[2];
            Tmodel.Sqlprms[0] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = (object)Tmodel.ProjectCD  ?? DBNull.Value };
            Tmodel.Sqlprms[1] = new SqlParameter("@HinbanCD", SqlDbType.VarChar) { Value = (object)Tmodel.HinbanCD ?? DBNull.Value };
            return bdl.SelectJson("M_Hinban_ProjectExistCheck", Tmodel.Sqlprms);

        }

        public string M_HinBan_Select_List(TourokuProjectModel Tmodel)
        {
            BaseDL bdl = new BaseDL();
            Tmodel.Sqlprms = new SqlParameter[0];
            //Tmodel.Sqlprms[0] = new SqlParameter("@HinbanCD", SqlDbType.VarChar) { Value = Tmodel.HinbanCD };
            return bdl.SelectJson("M_HinBan_Select_List", Tmodel.Sqlprms);

        }

        public string M_HinBan_Search_List(TourokuProjectModel Tmodel)
        {
            BaseDL bdl = new BaseDL();
            Tmodel.Sqlprms = new SqlParameter[2];
            Tmodel.Sqlprms[0] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = Tmodel.ProjectCD };
            Tmodel.Sqlprms[1] = new SqlParameter("@HinbanCD", SqlDbType.VarChar) { Value = Tmodel.HinbanCD };
            return bdl.SelectJson("M_HinBan_Search_List", Tmodel.Sqlprms);

        }

        public string Hinban_CUD(TourokuProjectModel Tmodel)
        {
            BaseDL bdl = new BaseDL();
            if (Tmodel.Mode.Equals("New"))
            {
                Tmodel.SPName = "M_Hinban_Insert";
                Tmodel.Sqlprms = new SqlParameter[9];
                Tmodel.Sqlprms[0] = new SqlParameter("@CastingCD", SqlDbType.VarChar) { Value = Tmodel.CastingCD };
                Tmodel.Sqlprms[1] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = Tmodel.ProjectCD };
                Tmodel.Sqlprms[2] = new SqlParameter("@HinbanCD", SqlDbType.VarChar) { Value = Tmodel.HinbanCD };
                Tmodel.Sqlprms[3] = new SqlParameter("@HinbanName", SqlDbType.VarChar) { Value = Tmodel.HinbanName };
                Tmodel.Sqlprms[4] = new SqlParameter("@Color", SqlDbType.VarChar) { Value = Tmodel.Color };
                Tmodel.Sqlprms[5] = new SqlParameter("@Production", SqlDbType.VarChar) { Value = Tmodel.Production };
                Tmodel.Sqlprms[6] = new SqlParameter("@freeitem1", SqlDbType.VarChar) { Value = Tmodel.FreeItem1 };
                Tmodel.Sqlprms[7] = new SqlParameter("@freeitem2", SqlDbType.VarChar) { Value = Tmodel.FreeItem2  };
                Tmodel.Sqlprms[8] = new SqlParameter("@saleprice", SqlDbType.VarChar) { Value = Tmodel.SalePrice };

            }
            //else if (kgmodel.Mode.Equals("Edit"))
            //{
            //    kgmodel.SPName = "M_Casting_Update";
            //    kgmodel.Sqlprms = new SqlParameter[5];
            //    kgmodel.Sqlprms[0] = new SqlParameter("@CastingCD", SqlDbType.VarChar) { Value = kgmodel.CastingCD };
            //    kgmodel.Sqlprms[1] = new SqlParameter("@CastingName", SqlDbType.VarChar) { Value = kgmodel.CastingName };
            //    kgmodel.Sqlprms[2] = new SqlParameter("@BrandCD", SqlDbType.VarChar) { Value = kgmodel.BrandCD };
            //    kgmodel.Sqlprms[3] = new SqlParameter("@BrandName", SqlDbType.VarChar) { Value = kgmodel.BrandName };
            //    kgmodel.Sqlprms[4] = new SqlParameter("@UseLimit", SqlDbType.VarChar) { Value = kgmodel.UseLimit };

            //}
            //else if (kgmodel.Mode.Equals("Delete"))
            //{
            //    kgmodel.SPName = "M_Casting_Delete";
            //    kgmodel.Sqlprms = new SqlParameter[1];
            //    kgmodel.Sqlprms[0] = new SqlParameter("@CastingCD", SqlDbType.VarChar) { Value = kgmodel.CastingCD };
                
            //}
            return bdl.SelectJson(Tmodel.SPName, Tmodel.Sqlprms);
        }

        public string M_HinBan_ExistsCheck(TourokuProjectModel Tmodel)
        {
            BaseDL bdl = new BaseDL();
            Tmodel.Sqlprms = new SqlParameter[1];
            Tmodel.Sqlprms[0] = new SqlParameter("@HinbanCD", SqlDbType.VarChar) { Value = (object)Tmodel.HinbanCD ?? DBNull.Value };
            return bdl.SelectJson("M_HinBan_ExistsCheck", Tmodel.Sqlprms);

        }

        public string LessthanZero_Checking(string input)
        {
            string result = string.Empty;
            if (!String.IsNullOrWhiteSpace(input))
            {
                int data = int.Parse(input);
                if (data <= 0)
                {
                    result = "[{\"resultdata\" : \"" + input + "\", \"flg\" : \"false\"}]";
                    return result;
                }
                else
                {
                    result = "[{\"resultdata\" : \"" + input + "\", \"flg\" : \"true\"}]";
                    return result;
                }
            }
            else
            {
                return result;
            }

        }
    }
}