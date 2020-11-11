using Models;
using Print_GenkaBL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace AcceleSystem.Controllers
{
    public class Print_GenkaApiController : ApiController
    {
        public string M_Brand_ExistsCheck([FromBody] Print_GenkaModel pgmodel)
        {
            Print_Genka_BL kgbl = new Print_Genka_BL();
            return kgbl.M_Brand_ExistsCheck(pgmodel);
        }

        public string M_Project_ExistsCheck([FromBody] Print_GenkaModel pgmodel)
        {
            Print_Genka_BL kgbl = new Print_Genka_BL();
            return kgbl.M_Project_ExistsCheck(pgmodel);
        }
        public string Print_GenkaCSV([FromBody] Print_GenkaModel pgmodel)
        {
            Print_Genka_BL pgbl = new Print_Genka_BL();
            return pgbl.Print_GenkaCSV(pgmodel);
        }
    }
}
