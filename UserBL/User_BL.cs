using Models;
using DL;
using System.Data.SqlClient;
using System.Data;

namespace UserBL
{
    public class User_BL
    {
        public string UserLogin_Select(UserModel Umodel)
        {
            BaseDL bdl = new BaseDL();
            SqlParameter[] prms = new SqlParameter[2];
            prms[0] = new SqlParameter("@UserID", SqlDbType.VarChar) { Value = Umodel.UserID };
            prms[1] = new SqlParameter("@Password", SqlDbType.VarChar) { Value = Umodel.Password };

            return bdl.SelectJson("UserLogin_Select", prms);
        }
    }
}
