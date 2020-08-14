using System.Web.Http;
using System.Web.Http.Results;
using Models;
using TourokuBL;

namespace AcceleSystem.Controllers
{
    public class TourokuProjectApiController : ApiController
    {
        [UserAuthentication]
        [HttpPost]
        public string M_Project_Select_List([FromBody] TourokuModel Tmodel)
        {
            if (Tmodel == null)
            {
                Tmodel = new TourokuModel();
            }
            Touroku_BL Ubl = new Touroku_BL();
            return Ubl.M_Project_Select_List(Tmodel);
        }
    }
}