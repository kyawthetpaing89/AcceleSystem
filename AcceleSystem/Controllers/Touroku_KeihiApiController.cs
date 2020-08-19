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
    }
}