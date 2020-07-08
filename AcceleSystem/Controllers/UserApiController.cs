using System.Web.Http;
using System.Web.Http.Results;
using Models;
using UserBL;

namespace AcceleSystem.Controllers
{
    public class UserApiController : ApiController
    {
        [UserAuthentication]
        [HttpPost]
        public string UserLogin_Select([FromBody] UserModel Umodel)
        {
            User_BL Ubl = new User_BL();
            return Ubl.UserLogin_Select(Umodel);
        }
        [UserAuthentication]
        [HttpPost]
        public string M_User_Select([FromBody] UserModel Umodel)
        {
            User_BL Ubl = new User_BL();
            return Ubl.M_User_Select(Umodel);
        }
        [UserAuthentication]
        [HttpPost]
        public string User_Insert([FromBody] UserModel Umodel)
        {
            User_BL Ubl = new User_BL();
            return Ubl.User_Insert(Umodel);
        }
    }
}
