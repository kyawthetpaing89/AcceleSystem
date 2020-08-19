using System.Web.Http;
using Models;
using KanagataBL;

namespace AcceleSystem.Controllers
{
    public class Touroku_KeihiApiController : ApiController
    {
        // GET: Touroku_KeihiApi
        public string M_Keihi_ExistsCheck([FromBody] KanagataModel kgmodel)
        {
            Kanagata_BL kgbl = new Kanagata_BL();
            return kgbl.M_Casting_ExistsCheck(kgmodel);
        }
    }
}