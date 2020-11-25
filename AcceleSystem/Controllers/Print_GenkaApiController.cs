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
        Print_Genka_BL pgbl = new Print_Genka_BL();
        public string M_Brand_ExistsCheck([FromBody] Print_GenkaModel pgmodel)
        {
            return pgbl.M_Brand_ExistsCheck(pgmodel);
        }

        public string M_Project_ExistsCheck([FromBody] Print_GenkaModel pgmodel)
        {
            return pgbl.M_Project_ExistsCheck(pgmodel);
        }
        public string Print_GenkaCSV([FromBody] Print_GenkaModel pgmodel)
        {
            return pgbl.Print_GenkaCSV(pgmodel);
        }

        public string Print_Genka_ProjectData([FromBody] Print_GenkaModel pmodel)
        {
            return pgbl.Print_Genka_ProjectData(pmodel);
        }

        public string M_Contrl_Year_ExitCheck([FromBody] Print_GenkaModel pgmodel) // for 対象年度
        {
            return pgbl.M_Contrl_Year_ExitCheck(pgmodel);
        }
    }
}
