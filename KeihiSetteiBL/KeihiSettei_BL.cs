using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace KeihiSetteiBL
{
    public class KeihiSettei_BL
    {
        public string M_Keihi_Select(KeihiSetteiModel Kmodel)
        {
            BaseDL bdl = new BaseDL();
            Kmodel.Sqlprms = new SqlParameter[5];
            Kmodel.Sqlprms[0] = new SqlParameter("@CostCD", SqlDbType.VarChar) { Value = Kmodel.CostCD };
            Kmodel.Sqlprms[1] = new SqlParameter("@CostName", SqlDbType.VarChar) { Value = Kmodel.CostName };
            Kmodel.Sqlprms[2] = new SqlParameter("@KanjoCD", SqlDbType.VarChar) { Value = Kmodel.KanjoCD };
            Kmodel.Sqlprms[3] = new SqlParameter("@HojoCD", SqlDType.VarChar) { Value = Kmodel.HojoCD };
            Kmodel.Sqlprms[4] = new SqlParameter("@Accounting", SqlDType.tinyint) { Value = Kmodel.Accounting };
            Kmodel.Sqlprms[5] = new SqlParameter("@Allocation", SqlDType.tinyint) { Value = Kmodel.Allocation };


            return bdl.SelectJson("M_Keihi_Select", Kmodel.Sqlprms);
        }
    }
}
