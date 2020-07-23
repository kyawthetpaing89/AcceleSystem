using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MasterTouroku_KeihiSetteiBL
{
    public class MasterTouroku_KeihiSettei_BL

    {
        public string M_Keihi_Select(KeihiModel Kmodel)
        {
            BaseDL bdl = new BaseDL();
            Kmodel.Sqlprms = new SqlParameter[5];
            Kmodel.Sqlprms[0] = new SqlParameter("@CostCD", SqlDbType.VarChar) { Value = Kmodel.CostCD };
            Kmodel.Sqlprms[1] = new SqlParameter("@CostName", SqlDbType.VarChar) { Value = Kmodel.CostName };
            bmodel.Sqlprms[0] = new SqlParameter("@BrandCD", SqlDbType.VarChar) { Value = bmodel.BrandCD };
            bmodel.Sqlprms[1] = new SqlParameter("@BrandName", SqlDbType.VarChar) { Value = bmodel.BrandName };
            bmodel.Sqlprms[0] = new SqlParameter("@BrandCD", SqlDbType.VarChar) { Value = bmodel.BrandCD };
            bmodel.Sqlprms[1] = new SqlParameter("@BrandName", SqlDbType.VarChar) { Value = bmodel.BrandName };

            return bdl.SelectJson("M_Brand_Select", bmodel.Sqlprms);
        }
    }
}
