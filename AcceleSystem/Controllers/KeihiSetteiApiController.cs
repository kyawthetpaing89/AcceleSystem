using System.Web.Http;
using System.Web.Http.Results;
using Models;
using KeihiSetteiBL;

namespace AcceleSystem.Controllers
{
    public class KeihiSetteiApiController : ApiController
    {
        [UserAuthentication]
        [HttpPost]
        public string M_Keihi_Select_List([FromBody] KeihiSetteiModel Kmodel)
        {
            if (Kmodel == null)
            {
                Kmodel = new KeihiSetteiModel();
            }
            KeihiSettei_BL Ubl = new KeihiSettei_BL();
            return Ubl.M_Keihi_Select_List(Kmodel);
        }

        [UserAuthentication]
        [HttpPost]
        public string M_Keihi_Select_Entry([FromBody] KeihiSetteiModel Kmodel)
        {
            if (Kmodel == null)
            {
                Kmodel = new KeihiSetteiModel();
            }
            KeihiSettei_BL Ubl = new KeihiSettei_BL();
            return Ubl.M_Keihi_Select_Entry(Kmodel);
        }

        [UserAuthentication]
        [HttpPost]
        public string M_Keihi_ExistsCheck([FromBody] KeihiSetteiModel Kmodel)
        {
            if (Kmodel == null)
            {
                Kmodel = new KeihiSetteiModel();
            }
            KeihiSettei_BL Ubl = new KeihiSettei_BL();
            return Ubl.M_Keihi_ExistsCheck(Kmodel);
        }

        [UserAuthentication]
        [HttpPost]
        public string Keihi_CUD([FromBody] KeihiSetteiModel Kmodel)
        {
            KeihiSettei_BL Ubl = new KeihiSettei_BL();
            return Ubl.Keihi_CUD(Kmodel);
        }
    }
}