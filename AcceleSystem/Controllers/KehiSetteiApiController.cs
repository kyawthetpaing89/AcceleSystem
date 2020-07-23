using System.Web.Http;
using System.Web.Http.Results;
using Models;
using KeiSetteiBL;

namespace AcceleSystem.Controllers
{
    public class KeiSetteiApiController : ApiController
    {
        [UserAuthentication]
        [HttpPost]
        public string M_Keihi_Select([FromBody] KeihiModel Kmodel)
        {
            if (Kmodel == null)
            {
                Kmodel = new KeihiModel();
            }
            Brand_BL Ubl = new Brand_BL();
            return Ubl.M_Brand_Select(bmodel);
        }

        [UserAuthentication]
        [HttpPost]
        public string M_Brand_ExistsCheck([FromBody] BrandModel bmodel)
        {
            if (bmodel == null)
            {
                bmodel = new BrandModel();
            }
            Brand_BL Ubl = new Brand_BL();
            return Ubl.M_Brand_ExistsCheck(bmodel);
        }

        [UserAuthentication]
        [HttpPost]
        public string Brand_CUD([FromBody] BrandModel bmodel)
        {
            Brand_BL Ubl = new Brand_BL();
            return Ubl.Brand_CUD(bmodel);
        }
    }
}