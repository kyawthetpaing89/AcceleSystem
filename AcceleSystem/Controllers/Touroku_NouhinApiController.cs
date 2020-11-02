using System.Web.Http;
using System.Web.Http.Results;
using Models;
using TourokuNouhinBL;

namespace AcceleSystem.Controllers
{
    public class Touroku_NouhinApiController : ApiController
    {
        [UserAuthentication]
        [HttpPost]
        public string D_Delivery_Search([FromBody] TourokuNouhinModel Tnmodel)
        {
            Touroku_Nouhin_BL tnbl = new Touroku_Nouhin_BL();
            return tnbl.D_Delivery_Search(Tnmodel);
        }

        [UserAuthentication]
        [HttpPost]
        public string M_Project_Nouhin_ShowData([FromBody] TourokuNouhinModel Tnmodel)
        {
            Touroku_Nouhin_BL tnbl = new Touroku_Nouhin_BL();
            return tnbl.M_Project_Nouhin_ShowData(Tnmodel);
        }

        [UserAuthentication]
        [HttpPost]
        public string M_Project_Select_NouhinEntry([FromBody] TourokuNouhinModel Tnmodel)
        {
            Touroku_Nouhin_BL tnbl = new Touroku_Nouhin_BL();
            return tnbl.M_Project_Select_NouhinEntry(Tnmodel);
        }

        [UserAuthentication]
        [HttpPost]
        public string Nouhin_CUD([FromBody] TourokuNouhinModel Tnmodel)
        {
            Touroku_Nouhin_BL tnbl = new Touroku_Nouhin_BL();
            return tnbl.Nouhin_CUD(Tnmodel);
        }

        [UserAuthentication]
        [HttpPost]
        public string M_NouhinBS_Select([FromBody] TourokuNouhinModel Tnmodel)
        {
            Touroku_Nouhin_BL tnbl = new Touroku_Nouhin_BL();
            return tnbl.M_NouhinBS_Select(Tnmodel);
        }
    }
}