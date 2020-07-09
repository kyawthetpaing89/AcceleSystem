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
        public string M_User_Select(UserModel Umodel)
        {
            
            BaseDL bdl = new BaseDL();
            SqlParameter[] prms = new SqlParameter[1];
            prms[0] = new SqlParameter("@UserName", SqlDbType.VarChar) { Value = Umodel.UserName };

            return bdl.SelectJson("M_User_Select", prms);
        }
        public string User_Insert(UserModel Umodel)
        {
            BaseDL bdl = new BaseDL();
            SqlParameter[] prms = new SqlParameter[3];
            prms[0] = new SqlParameter("@UserID", SqlDbType.VarChar) { Value = Umodel.UserID };
            prms[1] = new SqlParameter("@UserName", SqlDbType.VarChar) { Value = Umodel.UserName };
            prms[2] = new SqlParameter("@Password", SqlDbType.VarChar) { Value = Umodel.Password };

            return bdl.InsertUpdateDeleteData("cc", prms);
        }
    }
}
