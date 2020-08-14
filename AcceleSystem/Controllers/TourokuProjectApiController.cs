using System.Web.Http;
using System.Web.Http.Results;
using Models;
using TourokuProjectBL;

namespace AcceleSystem.Controllers
{
    public class TourokuProjectApiController : ApiController
    {
        [UserAuthentication]
        [HttpPost]
        public string M_Project_Select_List([FromBody] TourokuProjectModel Tmodel)
        {
            if (Tmodel == null)
            {
                Tmodel = new TourokuProjectModel();
            }
            TourokuProject_BL Ubl = new TourokuProject_BL();
            return Ubl.M_Project_Select_List(Tmodel);
        }
    }
}