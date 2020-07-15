using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DL;
using Models;
using System.Data;
using System.Data.SqlClient;


namespace KanagataBL
{
    public class Kanagata_BL
    {
        public string M_Casting_Select(KanagataModel kgmodel)
        {
            BaseDL bdl = new BaseDL();
            kgmodel.Sqlprms = new SqlParameter[1];
            kgmodel.Sqlprms[0] = new SqlParameter("@CastingCD", SqlDbType.VarChar) { Value = (object)kgmodel.CastingCD ?? DBNull.Value };          
            return bdl.SelectJson("M_Casting_Select", kgmodel.Sqlprms);
        }
    }
}
