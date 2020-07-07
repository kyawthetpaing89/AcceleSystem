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
    }
}
