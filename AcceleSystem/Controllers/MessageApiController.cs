using System.Web.Http;
using Models;
using MessageBL;

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
            Message_BL Mbl = new Message_BL();
            return Mbl.M_Message_Select(Mmodel);
        }
    }
}
