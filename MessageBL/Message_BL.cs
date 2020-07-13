using Models;
using DL;
using System.Data.SqlClient;
using System.Data;

namespace MessageBL
{
    public class Message_BL
    {
        public string M_Message_Select(MessageModel Mmodel)
        {
            BaseDL bdl = new BaseDL();           
            Mmodel.Sqlprms = new SqlParameter[1];
            Mmodel.Sqlprms[0] = new SqlParameter("@MessageID", SqlDbType.VarChar) { Value = Mmodel.MessageID };
            return bdl.SelectJson("M_Message_Select", Mmodel.Sqlprms);
        }
    }
}
