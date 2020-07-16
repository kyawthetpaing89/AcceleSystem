using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using MessageBL;
using Models;

namespace AcceleSystem.Controllers
{
    public class MessageApiController : ApiController
    {
        [UserAuthentication]
        [HttpPost]
        public string M_Message_Select([FromBody] MessageModel Mmodel)
        {
            if (Mmodel == null)
            {
                Mmodel = new MessageModel();
            }
            Message_BL msgBL = new Message_BL();
            return msgBL.M_Message_Select(Mmodel);
        }

    }
}
