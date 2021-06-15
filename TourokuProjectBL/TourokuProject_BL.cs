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
            Tmodel.Sqlprms[2] = new SqlParameter("@Season", SqlDbType.VarChar) { Value = Tmodel.Season };
            Tmodel.Sqlprms[3] = new SqlParameter("@Year", SqlDbType.Int) { Value = (object)Tmodel.Year ?? DBNull.Value };
            Tmodel.Sqlprms[4] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = (object)Tmodel.ProjectCD ?? DBNull.Value };
            Tmodel.Sqlprms[5] = new SqlParameter("@ProjectName", SqlDbType.VarChar) { Value = Tmodel.ProjectName };
            Tmodel.Sqlprms[6] = new SqlParameter("@PeriodStart", SqlDbType.Int) { Value = (object)Tmodel.PeriodStart ?? DBNull.Value };
            Tmodel.Sqlprms[7] = new SqlParameter("@PeriodEnd", SqlDbType.Int) { Value = (object)Tmodel.PeriodEnd ?? DBNull.Value };
            Tmodel.Sqlprms[8] = new SqlParameter("@ProjectManager", SqlDbType.VarChar) { Value = Tmodel.ProjectManager };
            Tmodel.Sqlprms[9] = new SqlParameter("@ProjectManagerName", SqlDbType.VarChar) { Value = Tmodel.ProjectManagerName };

            return bdl.SelectJson("M_Project_Select_List", Tmodel.Sqlprms);
        }
        public string M_Project_Select_Entry(TourokuProjectModel Tmodel)
        {
            BaseDL bdl = new BaseDL();
            Tmodel.Sqlprms = new SqlParameter[1];
            Tmodel.Sqlprms[0] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = (object)Tmodel.ProjectCD ?? DBNull.Value };

            return bdl.SelectJson("M_Project_Select_Entry", Tmodel.Sqlprms);
        }
        public string Project_CUD(TourokuProjectModel Tmodel)
        {
            BaseDL bdl = new BaseDL();
            if (Tmodel.Mode.Equals("New"))
            {
                Tmodel.SPName = "M_Project_Insert";
                Tmodel.Sqlprms = new SqlParameter[9];
                Tmodel.Sqlprms[0] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = Tmodel.ProjectCD };
                Tmodel.Sqlprms[1] = new SqlParameter("@ProjectName", SqlDbType.VarChar) { Value = Tmodel.ProjectName };
                Tmodel.Sqlprms[2] = new SqlParameter("@Year", SqlDbType.Int) { Value = (object)Tmodel.Year ?? DBNull.Value };
                Tmodel.Sqlprms[3] = new SqlParameter("@BrandCD", SqlDbType.VarChar) { Value = Tmodel.BrandCD };
                Tmodel.Sqlprms[4] = new SqlParameter("@Season", SqlDbType.TinyInt) { Value = Tmodel.Season };
                Tmodel.Sqlprms[5] = new SqlParameter("@PeriodStart", SqlDbType.Int) { Value = (object)Tmodel.PeriodStart ?? DBNull.Value };
                Tmodel.Sqlprms[6] = new SqlParameter("@PeriodEnd", SqlDbType.Int) { Value = (object)Tmodel.PeriodEnd ?? DBNull.Value };
                Tmodel.Sqlprms[7] = new SqlParameter("@ProjectManager", SqlDbType.VarChar) { Value = Tmodel.ProjectManager };
                Tmodel.Sqlprms[8] = new SqlParameter("@AllocationCount", SqlDbType.Int) { Value = (object)Tmodel.AllocationCount ?? DBNull.Value };


            }
            else if (Tmodel.Mode.Equals("Edit"))
            {
                Tmodel.SPName = "M_Project_Update";
                Tmodel.Sqlprms = new SqlParameter[9];
                Tmodel.Sqlprms[0] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = Tmodel.ProjectCD };
                Tmodel.Sqlprms[1] = new SqlParameter("@ProjectName", SqlDbType.VarChar) { Value = Tmodel.ProjectName };
                Tmodel.Sqlprms[2] = new SqlParameter("@Year", SqlDbType.Int) { Value = (object)Tmodel.Year ?? DBNull.Value };
                Tmodel.Sqlprms[3] = new SqlParameter("@BrandCD", SqlDbType.VarChar) { Value = Tmodel.BrandCD };
                Tmodel.Sqlprms[4] = new SqlParameter("@Season", SqlDbType.TinyInt) { Value = Tmodel.Season };
                Tmodel.Sqlprms[5] = new SqlParameter("@PeriodStart", SqlDbType.Int) { Value = (object)Tmodel.PeriodStart ?? DBNull.Value };
                Tmodel.Sqlprms[6] = new SqlParameter("@PeriodEnd", SqlDbType.Int) { Value = (object)Tmodel.PeriodEnd ?? DBNull.Value };
                Tmodel.Sqlprms[7] = new SqlParameter("@ProjectManager", SqlDbType.VarChar) { Value = Tmodel.ProjectManager };
                Tmodel.Sqlprms[8] = new SqlParameter("@AllocationCount", SqlDbType.Int) { Value = (object)Tmodel.AllocationCount ?? DBNull.Value };
           

            }
            else if (Tmodel.Mode.Equals("Copy"))
            {
                Tmodel.SPName = "M_Project_Insert";
                Tmodel.Sqlprms = new SqlParameter[9];
                Tmodel.Sqlprms[0] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = Tmodel.ProjectCD };
                Tmodel.Sqlprms[1] = new SqlParameter("@ProjectName", SqlDbType.VarChar) { Value = Tmodel.ProjectName };
                Tmodel.Sqlprms[2] = new SqlParameter("@Year", SqlDbType.Int) { Value = (object)Tmodel.Year ?? DBNull.Value };
                Tmodel.Sqlprms[3] = new SqlParameter("@BrandCD", SqlDbType.VarChar) { Value = Tmodel.BrandCD };
                Tmodel.Sqlprms[4] = new SqlParameter("@Season", SqlDbType.TinyInt) { Value = Tmodel.Season };
                Tmodel.Sqlprms[5] = new SqlParameter("@PeriodStart", SqlDbType.Int) { Value = (object)Tmodel.PeriodStart ?? DBNull.Value };
                Tmodel.Sqlprms[6] = new SqlParameter("@PeriodEnd", SqlDbType.Int) { Value = (object)Tmodel.PeriodEnd ?? DBNull.Value };
                Tmodel.Sqlprms[7] = new SqlParameter("@ProjectManager", SqlDbType.VarChar) { Value = Tmodel.ProjectManager };
                Tmodel.Sqlprms[8] = new SqlParameter("@AllocationCount", SqlDbType.Int) { Value = (object)Tmodel.AllocationCount ?? DBNull.Value };


            }
            else if (Tmodel.Mode.Equals("Delete"))
            {
                Tmodel.SPName = "M_Project_Delete";
                Tmodel.Sqlprms = new SqlParameter[1];
                Tmodel.Sqlprms[0] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = Tmodel.ProjectCD };

            }

            return bdl.SelectJson(Tmodel.SPName, Tmodel.Sqlprms);
        }

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

        public string M_Hinban_Check_List(TourokuProjectModel Tmodel)
        {
            BaseDL bdl = new BaseDL();
            Tmodel.Sqlprms = new SqlParameter[1];
            //Tmodel.Sqlprms[0] = new SqlParameter("@HinbanCD", SqlDbType.VarChar) { Value = Tmodel.HinbanCD };
            Tmodel.Sqlprms[0] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = Tmodel.ProjectCD };
            return bdl.SelectJson("M_Hinban_Check_List", Tmodel.Sqlprms);

        }

        public string M_HinBan_Select_Edit(TourokuProjectModel Tmodel)
        {
            BaseDL bdl = new BaseDL();
            Tmodel.Sqlprms = new SqlParameter[2];
            Tmodel.Sqlprms[0] = new SqlParameter("@HinbanCD", SqlDbType.VarChar) { Value = Tmodel.HinbanCD };
            Tmodel.Sqlprms[1] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = Tmodel.ProjectCD };
            return bdl.SelectJson("M_Hinban_Select_Entry", Tmodel.Sqlprms);

        }
        

        public string M_HinBan_Search_List(TourokuProjectModel Tmodel)
        {
            BaseDL bdl = new BaseDL();
            Tmodel.Sqlprms = new SqlParameter[9];
            Tmodel.Sqlprms[0] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = Tmodel.ProjectCD };
            Tmodel.Sqlprms[1] = new SqlParameter("@ProjectName", SqlDbType.VarChar) { Value = Tmodel.ProjectName };
            Tmodel.Sqlprms[2] = new SqlParameter("@HinbanCD", SqlDbType.VarChar) { Value = Tmodel.HinbanCD };
            Tmodel.Sqlprms[3] = new SqlParameter("@HinbanName", SqlDbType.VarChar) { Value = Tmodel.HinbanName };
            Tmodel.Sqlprms[4] = new SqlParameter("@CastingCD", SqlDbType.VarChar) { Value = Tmodel.CastingCD }; 
            Tmodel.Sqlprms[5] = new SqlParameter("@CastingName", SqlDbType.VarChar) { Value = Tmodel.CastingName };
            Tmodel.Sqlprms[6] = new SqlParameter("@StartPrice", SqlDbType.Int) { Value = (object)Tmodel.StartPrice ?? DBNull.Value };
            Tmodel.Sqlprms[7] = new SqlParameter("@EndPrice", SqlDbType.Int) { Value = (object)Tmodel.EndPrice ?? DBNull.Value };
            Tmodel.Sqlprms[8] = new SqlParameter("@CompleteYM", SqlDbType.VarChar) { Value = Tmodel.CompleteYM  };
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
                Tmodel.Sqlprms[4] = new SqlParameter("@Color", SqlDbType.TinyInt) { Value = (object)Tmodel.Color ?? DBNull.Value };
                Tmodel.Sqlprms[5] = new SqlParameter("@Production", SqlDbType.Int) { Value = (object)Tmodel.Production ?? DBNull.Value };
                Tmodel.Sqlprms[6] = new SqlParameter("@freeitem1", SqlDbType.VarChar) { Value = Tmodel.FreeItem1 };
                Tmodel.Sqlprms[7] = new SqlParameter("@freeitem2", SqlDbType.Int) { Value = (object)Tmodel.FreeItem2 ?? DBNull.Value };
                //Tmodel.Sqlprms[7] = new SqlParameter("@freeitem2", SqlDbType.Int) { Value = Tmodel.FreeItem2};
                Tmodel.Sqlprms[8] = new SqlParameter("@saleprice", SqlDbType.Int) { Value = (object)Tmodel.SalePrice ?? DBNull.Value };

            }
            else if (Tmodel.Mode.Equals("Edit"))
            {
                Tmodel.SPName = "M_Hinban_Update";
                Tmodel.Sqlprms = new SqlParameter[9];
                Tmodel.Sqlprms[0] = new SqlParameter("@CastingCD", SqlDbType.VarChar) { Value = Tmodel.CastingCD };
                Tmodel.Sqlprms[1] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = Tmodel.ProjectCD };
                Tmodel.Sqlprms[2] = new SqlParameter("@HinbanCD", SqlDbType.VarChar) { Value = Tmodel.HinbanCD };
                Tmodel.Sqlprms[3] = new SqlParameter("@HinbanName", SqlDbType.VarChar) { Value = Tmodel.HinbanName };
                Tmodel.Sqlprms[4] = new SqlParameter("@Color", SqlDbType.TinyInt) { Value = (object)Tmodel.Color ?? DBNull.Value };
                Tmodel.Sqlprms[5] = new SqlParameter("@Production", SqlDbType.Int) { Value = (object)Tmodel.Production ?? DBNull.Value };
                Tmodel.Sqlprms[6] = new SqlParameter("@freeitem1", SqlDbType.VarChar) { Value = Tmodel.FreeItem1 };
                Tmodel.Sqlprms[7] = new SqlParameter("@freeitem2", SqlDbType.Int) { Value = (object)Tmodel.FreeItem2 ?? DBNull.Value };
                Tmodel.Sqlprms[8] = new SqlParameter("@saleprice", SqlDbType.Int) { Value = (object)Tmodel.SalePrice ?? DBNull.Value };
            }
            else if(Tmodel.Mode.Equals("Copy"))
            {
                Tmodel.SPName = "M_Hinban_Insert";
                Tmodel.Sqlprms = new SqlParameter[9];
                Tmodel.Sqlprms[0] = new SqlParameter("@CastingCD", SqlDbType.VarChar) { Value = Tmodel.CastingCD };
                Tmodel.Sqlprms[1] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = Tmodel.ProjectCD };
                Tmodel.Sqlprms[2] = new SqlParameter("@HinbanCD", SqlDbType.VarChar) { Value = Tmodel.HinbanCD };
                Tmodel.Sqlprms[3] = new SqlParameter("@HinbanName", SqlDbType.VarChar) { Value = Tmodel.HinbanName };
                Tmodel.Sqlprms[4] = new SqlParameter("@Color", SqlDbType.TinyInt) { Value = (object)Tmodel.Color ?? DBNull.Value };
                Tmodel.Sqlprms[5] = new SqlParameter("@Production", SqlDbType.Int) { Value = (object)Tmodel.Production ?? DBNull.Value };
                Tmodel.Sqlprms[6] = new SqlParameter("@freeitem1", SqlDbType.VarChar) { Value  = Tmodel.FreeItem1};
                Tmodel.Sqlprms[7] = new SqlParameter("@freeitem2", SqlDbType.Int) { Value = (object)Tmodel.FreeItem2 ?? DBNull.Value };
                Tmodel.Sqlprms[8] = new SqlParameter("@saleprice", SqlDbType.Int) { Value = (object)Tmodel.SalePrice ?? DBNull.Value };
            }
            else if (Tmodel.Mode.Equals("Delete"))
            {
                Tmodel.SPName = "M_Hinban_Delete";
                Tmodel.Sqlprms = new SqlParameter[2];
                Tmodel.Sqlprms[0] = new SqlParameter("@HinbanCD", SqlDbType.VarChar) { Value = Tmodel.HinbanCD };
                Tmodel.Sqlprms[1] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = Tmodel.ProjectCD };
            }
            return bdl.SelectJson(Tmodel.SPName, Tmodel.Sqlprms);
        }

        public string M_HinBan_ExistsCheck(TourokuProjectModel Tmodel)
        {
            BaseDL bdl = new BaseDL();
            Tmodel.Sqlprms = new SqlParameter[1];
            Tmodel.Sqlprms[0] = new SqlParameter("@HinbanCD", SqlDbType.VarChar) { Value = (object)Tmodel.HinbanCD ?? DBNull.Value };
            return bdl.SelectJson("M_HinBan_ExistsCheck", Tmodel.Sqlprms);

        }

        public string M_HinBan_DCost_Check(TourokuProjectModel Tmodel)
        {
            BaseDL bdl = new BaseDL();
            Tmodel.Sqlprms = new SqlParameter[2];
            Tmodel.Sqlprms[0] = new SqlParameter("@HinbanCD", SqlDbType.VarChar) { Value = (object)Tmodel.HinbanCD ?? DBNull.Value };
            Tmodel.Sqlprms[1] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = (object)Tmodel.ProjectCD ?? DBNull.Value };
            return bdl.SelectJson("M_Hinban_DCost_Check", Tmodel.Sqlprms);

        }

        public string D_Devliery_ExistsDeleteCheck(TourokuProjectModel Tmodel)
        {
            BaseDL bdl = new BaseDL();
            Tmodel.Sqlprms = new SqlParameter[2];
            Tmodel.Sqlprms[0] = new SqlParameter("@HinbanCD", SqlDbType.VarChar) { Value = (object)Tmodel.HinbanCD ?? DBNull.Value };
            Tmodel.Sqlprms[1] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = (object)Tmodel.ProjectCD ?? DBNull.Value };
            return bdl.SelectJson("D_Devliery_ExistsDeleteCheck", Tmodel.Sqlprms);

        }

        public string D_Cost_ExistsDeleteCheck(TourokuProjectModel Tmodel)
        {
            BaseDL bdl = new BaseDL();
            Tmodel.Sqlprms = new SqlParameter[2];
            Tmodel.Sqlprms[0] = new SqlParameter("@HinbanCD", SqlDbType.VarChar) { Value = (object)Tmodel.HinbanCD ?? DBNull.Value };
            Tmodel.Sqlprms[1] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = (object)Tmodel.ProjectCD ?? DBNull.Value };
            return bdl.SelectJson("D_Cost_ExistsDeleteCheck", Tmodel.Sqlprms);

        }

        //public string LessthanZero_Checking(string input)
        //{
        //    string result = string.Empty;
        //    if (!String.IsNullOrWhiteSpace(input))
        //    {
        //        int data = int.Parse(input);
        //        if (data <= 0)
        //        {
        //            result = "[{\"resultdata\" : \"" + input + "\", \"flg\" : \"false\"}]";
        //            return result;
        //        }
        //        else
        //        {
        //            result = "[{\"resultdata\" : \"" + input + "\", \"flg\" : \"true\"}]";
        //            return result;
        //        }
        //    }
        //    else
        //    {
        //        return result;
        //    }

        //}

        public string M_Hinban_Price_Check(TourokuProjectModel tmodel)
        {
            string result = string.Empty;
            if (!string.IsNullOrWhiteSpace(tmodel.StartPrice) && !string.IsNullOrWhiteSpace(tmodel.EndPrice))
            {
                int startprice = int.Parse(tmodel.StartPrice);
                int endprice = int.Parse(tmodel.EndPrice);

                if (startprice >= endprice)
                {
                    result = "[{\"resultdata\" : \"" + endprice + "\", \"flg\" : \"false\"}]";
                    return result;
                }
                else
                {
                    result = "[{\"resultdata\" : \"" + endprice + "\", \"flg\" : \"true\"}]";
                    return result;
                }
            }
            else
            {
                return result;
            }
            
        }

        public string M_Project_CSV(TourokuProjectModel Tmodel)
        {
            BaseDL bdl = new BaseDL();
            Tmodel.Sqlprms = new SqlParameter[10];
            Tmodel.Sqlprms[0] = new SqlParameter("@BrandCD", SqlDbType.VarChar) { Value = Tmodel.BrandCD };
            Tmodel.Sqlprms[1] = new SqlParameter("@BrandName", SqlDbType.VarChar) { Value = Tmodel.BrandName };
            Tmodel.Sqlprms[2] = new SqlParameter("@Season", SqlDbType.VarChar) { Value = Tmodel.Season };
            Tmodel.Sqlprms[3] = new SqlParameter("@Year", SqlDbType.Int) { Value = (object)Tmodel.Year ?? DBNull.Value };
            Tmodel.Sqlprms[4] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = (object)Tmodel.ProjectCD ?? DBNull.Value };
            Tmodel.Sqlprms[5] = new SqlParameter("@ProjectName", SqlDbType.VarChar) { Value = Tmodel.ProjectName };
            Tmodel.Sqlprms[6] = new SqlParameter("@PeriodStart", SqlDbType.Int) { Value = (object)Tmodel.PeriodStart ?? DBNull.Value };
            Tmodel.Sqlprms[7] = new SqlParameter("@PeriodEnd", SqlDbType.Int) { Value = (object)Tmodel.PeriodEnd ?? DBNull.Value };
            Tmodel.Sqlprms[8] = new SqlParameter("@ProjectManager", SqlDbType.VarChar) { Value = Tmodel.ProjectManager };
            Tmodel.Sqlprms[9] = new SqlParameter("@UserName", SqlDbType.VarChar) { Value = Tmodel.ProjectManagerName };

            return bdl.SelectJson("M_Project_CSV", Tmodel.Sqlprms);
        }
    }
}