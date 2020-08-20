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

        public string M_Cost_Select_List(Touroku_KeihiModel Kmodel)
        {
            BaseDL bdl = new BaseDL();
            Kmodel.Sqlprms = new SqlParameter[12];
            Kmodel.Sqlprms[0] = new SqlParameter("@CostCD", SqlDbType.Int) { Value = (object)Kmodel.CostCD ?? DBNull.Value };
            Kmodel.Sqlprms[1] = new SqlParameter("@CostName", SqlDbType.VarChar) { Value = Kmodel.CostName };
            Kmodel.Sqlprms[2] = new SqlParameter("@CostDateFrom", SqlDbType.Date) { Value = Kmodel.CostDateFrom  };
            Kmodel.Sqlprms[3] = new SqlParameter("@CostDateTo", SqlDbType.Date) { Value = Kmodel.CostDateTo  };
            Kmodel.Sqlprms[4] = new SqlParameter("@BrandCD", SqlDbType.VarChar) { Value = Kmodel.BrandCD };
            Kmodel.Sqlprms[5] = new SqlParameter("@BrandName", SqlDbType.VarChar) { Value = Kmodel.BrandName };
            Kmodel.Sqlprms[6] = new SqlParameter("@Season", SqlDbType.TinyInt) { Value = (object)Kmodel.Season ?? DBNull.Value };
            Kmodel.Sqlprms[7] = new SqlParameter("@Year", SqlDbType.Int) { Value = (object)Kmodel.Year ?? DBNull.Value };
            Kmodel.Sqlprms[8] = new SqlParameter("@ProjectCD", SqlDbType.VarChar) { Value = Kmodel.ProjectCD };
            Kmodel.Sqlprms[9] = new SqlParameter("@ProjectName", SqlDbType.VarChar) { Value = Kmodel.ProjectName };
            Kmodel.Sqlprms[10] = new SqlParameter("@HinbanCD", SqlDbType.VarChar) { Value = Kmodel.HinbanCD };
            Kmodel.Sqlprms[11] = new SqlParameter("@HinbanName", SqlDbType.VarChar) { Value = Kmodel.HinbanName };

            return bdl.SelectJson("M_Cost_Select_List", Kmodel.Sqlprms);
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
            Kmodel.Sqlprms[0] = new SqlParameter("@HinbanCD", SqlDbType.VarChar) { Value = Kmodel.HinbanCD  };
            return bdl.SelectJson("M_HinBan_ExistsCheck", Kmodel.Sqlprms);
        }
    }
}
