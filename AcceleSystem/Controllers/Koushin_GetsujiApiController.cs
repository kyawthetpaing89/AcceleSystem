using System.Web.Http;
using Models;
using Koushin_GetsujiBL;

namespace AcceleSystem.Controllers
{
    public class Koushin_GetsujiApiController : ApiController
    {
        // GET: Koushin_GetsujiApi
        public string M_Contrl_YearMonth_ExitCheck([FromBody] Koushin_GetsujiModel kgmodel)
        {
            Koushin_Getsuji_BL kgbl = new Koushin_Getsuji_BL();
            return kgbl.M_Contrl_YearMonth_ExitCheck(kgmodel);
        }
    }
}