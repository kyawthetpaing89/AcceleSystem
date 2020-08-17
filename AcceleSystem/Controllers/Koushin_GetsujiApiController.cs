using System.Web.Http;
using Koushin_GetsujiBL;
using Models;


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

        public string M_Contrl_YearMonth_Update([FromBody] Koushin_GetsujiModel kgmodel)
        {
            Koushin_Getsuji_BL kgbl = new Koushin_Getsuji_BL();

            return kgbl.M_Contrl_YearMonth_Update(kgmodel);
        }
    }
}