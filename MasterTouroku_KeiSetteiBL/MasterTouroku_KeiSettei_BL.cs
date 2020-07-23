using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MasterTouroku_KeiSetteiBL
{
    public class MasterTouroku_KeiSettei_BL
    {
        public string M_Keihi_Select(KeihiModel Kmodel)
        {
            BaseDL bdl = new BaseDL();
            bmodel.Sqlprms = new SqlParameter[2];
            bmodel.Sqlprms[0] = new SqlParameter("@BrandCD", SqlDbType.VarChar) { Value = bmodel.BrandCD };
            bmodel.Sqlprms[1] = new SqlParameter("@BrandName", SqlDbType.VarChar) { Value = bmodel.BrandName };

            return bdl.SelectJson("M_Brand_Select", bmodel.Sqlprms);
        }
    }
}
