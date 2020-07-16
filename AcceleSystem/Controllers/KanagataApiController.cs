using System.Web.Http;
using Models;
using KanagataBL;

namespace AcceleSystem.Controllers
{
    [RoutePrefix("Accele/api/KanagataApi")]
    public class KanagataApiController : ApiController
    {
        // GET: KanagataApi
        [UserAuthentication]
        [HttpPost]
        public string M_Casting_Select([FromBody] KanagataModel kgmodel)
        {
            Kanagata_BL kgbl = new Kanagata_BL();
            return kgbl.M_Casting_Select(kgmodel);
        }

        [UserAuthentication]
        [HttpPost]
        public string Casting_CUD([FromBody] KanagataModel kgmodel)
        {
            Kanagata_BL kgbl = new Kanagata_BL();
            return kgbl.Casting_CUD(kgmodel);
        }
    }
}