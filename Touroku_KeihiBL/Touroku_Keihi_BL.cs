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
            Kmodel.Sqlprms[0] = new SqlParameter("@CostCD", SqlDbType.VarChar) { Value = (object)Kmodel.CostCD ?? DBNull.Value };
            return bdl.SelectJson("M_Keihi_ExistsCheck", Kmodel.Sqlprms);
        }
    }
}
