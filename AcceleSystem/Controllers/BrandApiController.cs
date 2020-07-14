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
        public string M_Brand_Select([FromBody] BrandModel Umodel)
        {
            if (Umodel == null)
            {
                Umodel = new BrandModel();
            }
            Brand_BL Ubl = new Brand_BL();
            return Ubl.M_Brand_Select(Umodel);
        }

        [UserAuthentication]
        [HttpPost]
        public string Brand_CUD([FromBody] BrandModel Umodel)
        {
            Brand_BL Ubl = new Brand_BL();
            return Ubl.Brand_CUD(Umodel);
        }
    }
}
