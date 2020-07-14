using System.Web.Http;
using Models;
using UserBL;

namespace AcceleSystem.Controllers
{
    [RoutePrefix("Accele/api/UserApi")]
    public class UserApiController : ApiController
    {
        [UserAuthentication]
        [HttpPost]
        public string UserLogin_Select([FromBody] UserModel Umodel)
        {
            User_BL Ubl = new User_BL();
            return Ubl.UserLogin_Select(Umodel);
        }
        //public IHttpActionResult UserLogin_Select([FromBody] UserModel Umodel)
        //{
        //    User_BL Ubl = new User_BL();
        //    return Ok(Ubl.UserLogin_Select(Umodel));
        //}

        [UserAuthentication]
        [HttpPost]
        public string M_User_Select([FromBody] UserModel Umodel)
        {
            if(Umodel == null)
            {
                Umodel = new UserModel();
            }
            User_BL Ubl = new User_BL();
            return Ubl.M_User_Select(Umodel);
        }

        [UserAuthentication]
        [HttpPost]
        public string User_CUD([FromBody] UserModel Umodel)
        {
            User_BL Ubl = new User_BL();
            return Ubl.User_CUD(Umodel);
        }


    }
}
