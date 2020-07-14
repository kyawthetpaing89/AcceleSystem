using System.Web.Http;
using System.Web.Http.Results;
using Models;
using BrandBL;

namespace AcceleSystem.Controllers
{
    public class BrandApiController : ApiController
    {

        [UserAuthentication]
        [HttpPost]
        public string M_Brand_Insert([FromBody] BrandModel Umodel)
        {
            Brand_BL Ubl = new Brand_BL();
            return Ubl.M_Brand_Insert(Umodel);
        }
    }
}
