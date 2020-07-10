using Models;
using DL;
using System.Data.SqlClient;
using System.Data;
using System;

namespace UserBL
{
    public class User_BL
    {
        public string UserLogin_Select(UserModel Umodel)
        {
            BaseDL bdl = new BaseDL();
            Umodel.Sqlprms = new SqlParameter[2];
            Umodel.Sqlprms[0] = new SqlParameter("@UserID", SqlDbType.VarChar) { Value = Umodel.UserID };
            Umodel.Sqlprms[1] = new SqlParameter("@Password", SqlDbType.VarChar) { Value = Umodel.Password };

            return bdl.SelectJson("UserLogin_Select", Umodel.Sqlprms);
        }
        public string M_User_Select(UserModel Umodel)
        {
            BaseDL bdl = new BaseDL();
            Umodel.Sqlprms = new SqlParameter[2];
            Umodel.Sqlprms[0] = new SqlParameter("@ID", SqlDbType.VarChar) { Value = (object)Umodel.UserID?? DBNull.Value };
            Umodel.Sqlprms[1] = new SqlParameter("@UserName", SqlDbType.VarChar) { Value = (object)Umodel.UserName ?? DBNull.Value };
            return bdl.SelectJson("M_User_Select", Umodel.Sqlprms);
        }
        public string User_CUD(UserModel Umodel)
        {
            BaseDL bdl = new BaseDL();
            if (Umodel.Mode.Equals("New"))
            {
                Umodel.SPName = "M_User_Insert";
                Umodel.Sqlprms = new SqlParameter[3];
                Umodel.Sqlprms[0] = new SqlParameter("@ID", SqlDbType.VarChar) { Value = Umodel.UserID };
                Umodel.Sqlprms[1] = new SqlParameter("@UserName", SqlDbType.VarChar) { Value = Umodel.UserName };
                Umodel.Sqlprms[2] = new SqlParameter("@Password", SqlDbType.VarChar) { Value = Umodel.Password };
            }
            else if (Umodel.Mode.Equals("Edit"))
            {
                Umodel.SPName = "M_User_Update";
                Umodel.Sqlprms = new SqlParameter[3];
                Umodel.Sqlprms[0] = new SqlParameter("@ID", SqlDbType.VarChar) { Value = Umodel.UserID };
                Umodel.Sqlprms[1] = new SqlParameter("@UserName", SqlDbType.VarChar) { Value = Umodel.UserName };
                Umodel.Sqlprms[2] = new SqlParameter("@Password", SqlDbType.VarChar) { Value = Umodel.Password };
            }                
            else if (Umodel.Mode.Equals("Delete"))
            {
                Umodel.SPName = "M_User_Delete";
                Umodel.Sqlprms = new SqlParameter[1];
                Umodel.Sqlprms[0] = new SqlParameter("@ID", SqlDbType.VarChar) { Value = Umodel.UserID };
            }

            return bdl.SelectJson(Umodel.SPName, Umodel.Sqlprms);
        }
    }
}
