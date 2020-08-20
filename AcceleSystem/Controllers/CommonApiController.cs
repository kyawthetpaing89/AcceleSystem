using System.Web.Http;
using System.Web.Http.Results;
using Models;
using CommonBL;

namespace AcceleSystem.Controllers
{
    
    public class CommonApiController : ApiController
    {
        // GET: CommonApi
        [UserAuthentication]
        [HttpPost]
        public string Date_Checking([FromBody] BaseModel BModel)
        {
            Common_BL cmbl = new Common_BL();
            return cmbl.Date_Checking(BModel.inputdate);
        }

        [UserAuthentication]
        [HttpPost]
        public string YearMonth_Checking([FromBody] BaseModel BModel)
        {
            Common_BL cmbl = new Common_BL();
            return cmbl.YearMonth_Checking(BModel.inputdate);

        }

        public string DateComapre([FromBody] BaseModel BModel)
        {
            Common_BL cmbl = new Common_BL();
            return cmbl.DateComapre(BModel.startDate, BModel.endDate);
        }
    }
}