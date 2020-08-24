using System.Web.Http;
using Models;
using Touroku_KeihiBL;

namespace AcceleSystem.Controllers
{
    public class Touroku_KeihiApiController : ApiController
    {
        // GET: Touroku_KeihiApi
        public string M_Keihi_ExistsCheck([FromBody] Touroku_KeihiModel kgmodel)
        {
            Touroku_Keihi_BL kgbl = new Touroku_Keihi_BL();
            return kgbl.M_Keihi_ExistsCheck(kgmodel);
        }

        public string M_Cost_Select_List([FromBody] Touroku_KeihiModel kgmodel)
        {
            Touroku_Keihi_BL kgbl = new Touroku_Keihi_BL();
            return kgbl.M_Cost_Select_List(kgmodel);
        }

        public string M_Brand_ExistsCheck([FromBody] Touroku_KeihiModel kgmodel)
        {
            Touroku_Keihi_BL kgbl = new Touroku_Keihi_BL();
            return kgbl.M_Brand_ExistsCheck(kgmodel);
        }

        public string M_Project_ExistsCheck([FromBody] Touroku_KeihiModel kgmodel)
        {
            Touroku_Keihi_BL kgbl = new Touroku_Keihi_BL();
            return kgbl.M_Project_ExistsCheck(kgmodel);
        }

        public string M_HinBan_ExistsCheck([FromBody] Touroku_KeihiModel kgmodel)
        {
            Touroku_Keihi_BL kgbl = new Touroku_Keihi_BL();
            return kgbl.M_HinBan_ExistsCheck(kgmodel);
        }
    }
}