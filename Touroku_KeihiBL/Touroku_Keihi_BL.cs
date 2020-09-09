using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DL;
using Models;
using System.Data;
using System.Data.SqlClient;

namespace Touroku_KeihiBL
{
    public class Touroku_Keihi_BL
    {
        public string M_Keihi_ExistsCheck(Touroku_KeihiModel Kmodel)
        {
            BaseDL bdl = new BaseDL();
            Kmodel.Sqlprms = new SqlParameter[1];
            Kmodel.Sqlprms[0] = new SqlParameter("@CostCD", SqlDbType.Int) { Value = (object)Kmodel.CostCD ?? DBNull.Value };
            return bdl.SelectJson("M_Keihi_ExistsCheck", Kmodel.Sqlprms);
        }

        public string D_Cost_Select_List(Touroku_KeihiModel Kmodel)
        {
            BaseDL bdl = new BaseDL();
            Kmodel.Sqlprms = new SqlParameter[12];
            Kmodel.Sqlprms[0] = new SqlParameter("@CostCD", SqlDbType.Int) { Value = (object)Kmodel.CostCD ?? DBNull.Value };
            Kmodel.Sqlprms[1] = new SqlParameter("@CostName", SqlDbType.VarChar) { Value = (object)Kmodel.CostName ?? DBNull.Value };
            Kmodel.Sqlprms[2] = new SqlParameter("@CostDateFrom", SqlDbType.Date) { Value = (object)Kmodel.CostDateFrom ?? DBNull.Value };
            Kmodel.Sqlprms[3] = new SqlParameter("@CostDateTo", SqlDbType.Date) { Value = (object)Kmodel.CostDateTo ?? DBNull.Value };
            Kmodel.Sqlprms[4] = new SqlParameter("@BrandCD", SqlDbType.VarChar) { Value = (object)Kmodel.BrandCD ?? DBNull.Value };
            Kmodel.Sqlprms[5] = new SqlParameter("@BrandName", SqlDbType.VarChar) { Value = (object)Kmodel.BrandName ?? DBNull.Value };
            Kmodel.Sqlprms[6] = new SqlParameter("@Season", SqlDbType.TinyInt) { Value = (object)Kmodel.Season ?? DBNull.Value };
            Kmodel.Sqlprms[7] = new SqlParameter("@Year", SqlDbType.Int) { Value = (object)Kmodel.Year ?? DBNull.Value };
            Kmodel.Sqlprms[8] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = (object)Kmodel.ProjectCD ?? DBNull.Value };
            Kmodel.Sqlprms[9] = new SqlParameter("@ProjectName", SqlDbType.VarChar) { Value = (object)Kmodel.ProjectName ?? DBNull.Value };
            Kmodel.Sqlprms[10] = new SqlParameter("@HinbanCD", SqlDbType.VarChar) { Value = (object)Kmodel.HinbanCD ?? DBNull.Value };
            Kmodel.Sqlprms[11] = new SqlParameter("@HinbanName", SqlDbType.VarChar) { Value = (object)Kmodel.HinbanName ?? DBNull.Value };           

            return bdl.SelectJson("D_Cost_Select_List", Kmodel.Sqlprms);
        }

        public string M_Brand_ExistsCheck(Touroku_KeihiModel Kmodel)
        {
            BaseDL bdl = new BaseDL();
            Kmodel.Sqlprms = new SqlParameter[1];
            Kmodel.Sqlprms[0] = new SqlParameter("@BrandCD", SqlDbType.VarChar) { Value = Kmodel.BrandCD };
            return bdl.SelectJson("M_Brand_ExistsCheck", Kmodel.Sqlprms);
        }

        public string M_Project_ExistsCheck(Touroku_KeihiModel Kmodel)
        {
            BaseDL bdl = new BaseDL();
            Kmodel.Sqlprms = new SqlParameter[1];
            Kmodel.Sqlprms[0] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = Kmodel.ProjectCD };
            return bdl.SelectJson("M_Project_ExistsCheck", Kmodel.Sqlprms);
        }

        public string M_HinBan_ExistsCheck(Touroku_KeihiModel Kmodel)
        {
            BaseDL bdl = new BaseDL();
            Kmodel.Sqlprms = new SqlParameter[1];
            Kmodel.Sqlprms[0] = new SqlParameter("@HinbanCD", SqlDbType.VarChar) { Value = Kmodel.HinbanCD };
            return bdl.SelectJson("M_HinBan_ExistsCheck", Kmodel.Sqlprms);
        }

        public string D_Cost_Edit_List(Touroku_KeihiModel kmodel)
        {
            BaseDL bdl = new BaseDL();
            kmodel.Sqlprms = new SqlParameter[1];
            kmodel.Sqlprms[0] = new SqlParameter("@SEQ", SqlDbType.Int) { Value = kmodel.SEQ };
            return bdl.SelectJson("D_Cost_Edit_List", kmodel.Sqlprms);
        }

        public string M_Casting_ExistsCheck(Touroku_KeihiModel tkmodel)
        {
            BaseDL bdl = new BaseDL();
            tkmodel.Sqlprms = new SqlParameter[1];
            tkmodel.Sqlprms[0] = new SqlParameter("@CastingCD", SqlDbType.VarChar) { Value = tkmodel.CastingCD };
            return bdl.SelectJson("M_Casting_ExistsCheck", tkmodel.Sqlprms);
        }

        public string M_Control_FiscalCheck(BaseModel BModel)
        {
            BaseDL bdl = new BaseDL();
            BModel.Sqlprms = new SqlParameter[1];
            BModel.Sqlprms[0] = new SqlParameter("@CastDate", SqlDbType.Date) { Value = BModel.inputdate };
            return bdl.SelectJson("M_Control_FiscalCheck", BModel.Sqlprms);
        }

        public string D_Cost_CUD(Touroku_KeihiModel Kmodel)
        {
            BaseDL bdl = new BaseDL();
            if (Kmodel.Mode.Equals("New"))
            {
                Kmodel.SPName = "D_Cost_Insert";
                Kmodel.Sqlprms = new SqlParameter[13];
                Kmodel.Sqlprms[0] = new SqlParameter("@CostCD", SqlDbType.Int) { Value = (object)Kmodel.CostCD ?? DBNull.Value };
                Kmodel.Sqlprms[1] = new SqlParameter("@CostDate", SqlDbType.Date) { Value = (object)Kmodel.CostDate ?? DBNull.Value };
                Kmodel.Sqlprms[2] = new SqlParameter("@BrandCD", SqlDbType.VarChar) { Value = (object)Kmodel.BrandCD ?? DBNull.Value };
                Kmodel.Sqlprms[3] = new SqlParameter("@Season", SqlDbType.TinyInt) { Value = (object)Kmodel.Season ?? DBNull.Value };
                Kmodel.Sqlprms[4] = new SqlParameter("@Year", SqlDbType.Int) { Value = (object)Kmodel.Year ?? DBNull.Value };
                Kmodel.Sqlprms[5] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = (object)Kmodel.ProjectCD ?? DBNull.Value };
                Kmodel.Sqlprms[6] = new SqlParameter("@HinbanCD", SqlDbType.VarChar) { Value = (object)Kmodel.HinbanCD ?? DBNull.Value };
                Kmodel.Sqlprms[7] = new SqlParameter("@CastingCD", SqlDbType.VarChar) { Value = (object)Kmodel.CastingCD ?? DBNull.Value };
                Kmodel.Sqlprms[8] = new SqlParameter("@FreeItem1", SqlDbType.VarChar) { Value = (object)Kmodel.Item ?? DBNull.Value };
                Kmodel.Sqlprms[9] = new SqlParameter("@ZeikomiKBN", SqlDbType.TinyInt) { Value = (object)Kmodel.ZeikomiKBN ?? DBNull.Value };
                Kmodel.Sqlprms[10] = new SqlParameter("@CostAmount", SqlDbType.Int) { Value = (object)Kmodel.CostAmount ?? DBNull.Value };
                Kmodel.Sqlprms[11] = new SqlParameter("@InputAmount", SqlDbType.Int) { Value = (object)Kmodel.InputAmount ?? DBNull.Value };
                Kmodel.Sqlprms[12] = new SqlParameter("@Remarks", SqlDbType.VarChar) { Value = (object)Kmodel.Remarks ?? DBNull.Value };
                
            }
            else if (Kmodel.Mode.Equals("Edit"))
            {
                Kmodel.SPName = "D_Cost_UPDATE";
                Kmodel.Sqlprms = new SqlParameter[14];
                Kmodel.Sqlprms[0] = new SqlParameter("@CostCD", SqlDbType.Int) { Value = (object)Kmodel.CostCD ?? DBNull.Value };
                Kmodel.Sqlprms[1] = new SqlParameter("@CostDate", SqlDbType.Date) { Value = (object)Kmodel.CostDate ?? DBNull.Value };
                Kmodel.Sqlprms[2] = new SqlParameter("@BrandCD", SqlDbType.VarChar) { Value = (object)Kmodel.BrandCD ?? DBNull.Value };
                Kmodel.Sqlprms[3] = new SqlParameter("@Season", SqlDbType.TinyInt) { Value = (object)Kmodel.Season ?? DBNull.Value };
                Kmodel.Sqlprms[4] = new SqlParameter("@Year", SqlDbType.Int) { Value = (object)Kmodel.Year ?? DBNull.Value };
                Kmodel.Sqlprms[5] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = (object)Kmodel.ProjectCD ?? DBNull.Value };
                Kmodel.Sqlprms[6] = new SqlParameter("@HinbanCD", SqlDbType.VarChar) { Value = (object)Kmodel.HinbanCD ?? DBNull.Value };
                Kmodel.Sqlprms[7] = new SqlParameter("@CastingCD", SqlDbType.VarChar) { Value = (object)Kmodel.CastingCD ?? DBNull.Value };
                Kmodel.Sqlprms[8] = new SqlParameter("@FreeItem1", SqlDbType.VarChar) { Value = (object)Kmodel.Item ?? DBNull.Value };
                Kmodel.Sqlprms[9] = new SqlParameter("@ZeikomiKBN", SqlDbType.TinyInt) { Value = (object)Kmodel.ZeikomiKBN ?? DBNull.Value };
                Kmodel.Sqlprms[10] = new SqlParameter("@CostAmount", SqlDbType.Int) { Value = (object)Kmodel.CostAmount ?? DBNull.Value };
                Kmodel.Sqlprms[11] = new SqlParameter("@InputAmount", SqlDbType.Int) { Value = (object)Kmodel.InputAmount ?? DBNull.Value };
                Kmodel.Sqlprms[12] = new SqlParameter("@Remarks", SqlDbType.VarChar) { Value = (object)Kmodel.Remarks ?? DBNull.Value };
                Kmodel.Sqlprms[13] = new SqlParameter("@SEQ", SqlDbType.Int) { Value = (object)Kmodel.SEQ ?? DBNull.Value };
               
            }
            else if (Kmodel.Mode.Equals("Copy"))
            {
                Kmodel.SPName = "D_Cost_Insert";
                Kmodel.Sqlprms = new SqlParameter[13];
                Kmodel.Sqlprms[0] = new SqlParameter("@CostCD", SqlDbType.Int) { Value = (object)Kmodel.CostCD ?? DBNull.Value };
                Kmodel.Sqlprms[1] = new SqlParameter("@CostDate", SqlDbType.Date) { Value = (object)Kmodel.CostDate ?? DBNull.Value };
                Kmodel.Sqlprms[2] = new SqlParameter("@BrandCD", SqlDbType.VarChar) { Value = (object)Kmodel.BrandCD ?? DBNull.Value };
                Kmodel.Sqlprms[3] = new SqlParameter("@Season", SqlDbType.TinyInt) { Value = (object)Kmodel.Season ?? DBNull.Value };
                Kmodel.Sqlprms[4] = new SqlParameter("@Year", SqlDbType.Int) { Value = (object)Kmodel.Year ?? DBNull.Value };
                Kmodel.Sqlprms[5] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = (object)Kmodel.ProjectCD ?? DBNull.Value };
                Kmodel.Sqlprms[6] = new SqlParameter("@HinbanCD", SqlDbType.VarChar) { Value = (object)Kmodel.HinbanCD ?? DBNull.Value };
                Kmodel.Sqlprms[7] = new SqlParameter("@CastingCD", SqlDbType.VarChar) { Value = (object)Kmodel.CastingCD ?? DBNull.Value };
                Kmodel.Sqlprms[8] = new SqlParameter("@FreeItem1", SqlDbType.VarChar) { Value = (object)Kmodel.Item ?? DBNull.Value };
                Kmodel.Sqlprms[9] = new SqlParameter("@ZeikomiKBN", SqlDbType.TinyInt) { Value = (object)Kmodel.ZeikomiKBN ?? DBNull.Value };
                Kmodel.Sqlprms[10] = new SqlParameter("@CostAmount", SqlDbType.Int) { Value = (object)Kmodel.CostAmount ?? DBNull.Value };
                Kmodel.Sqlprms[11] = new SqlParameter("@InputAmount", SqlDbType.Int) { Value = (object)Kmodel.InputAmount ?? DBNull.Value };
                Kmodel.Sqlprms[12] = new SqlParameter("@Remarks", SqlDbType.VarChar) { Value = (object)Kmodel.Remarks ?? DBNull.Value };
                Kmodel.Sqlprms[13] = new SqlParameter("@SEQ", SqlDbType.Int) { Value = (object)Kmodel.SEQ ?? DBNull.Value };

            }
            else if (Kmodel.Mode.Equals("Delete"))
            {
                Kmodel.SPName = "D_Cost_Delete";
                Kmodel.Sqlprms = new SqlParameter[1];
                Kmodel.Sqlprms[0] = new SqlParameter("@SEQ", SqlDbType.Int) { Value = (object)Kmodel.SEQ ?? DBNull.Value };
                
            }
            return bdl.SelectJson(Kmodel.SPName, Kmodel.Sqlprms);
        }
    }
}
