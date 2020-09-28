using Koushin_GenkaBL;
using Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace AcceleSystem.Controllers
{
    public class Koushin_GenkaApiController : ApiController
    {
        public string M_Contrl_YearMonth_ExitCheck([FromBody] Koushin_GenkaModel kgmodel)
        {
            Koushin_Genka_BL kgbl = new Koushin_Genka_BL();
            return kgbl.M_Contrl_YearMonth_ExitCheck(kgmodel);
        }

        public string M_Contrl_YearMonth_Genka_Update([FromBody] Koushin_GenkaModel kgmodel)
        {
            Koushin_Genka_BL kgbl = new Koushin_Genka_BL();

            return kgbl.M_Contrl_YearMonth_Genka_Update(kgmodel);
        }
    }
}
