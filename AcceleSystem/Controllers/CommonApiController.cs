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

        [UserAuthentication]
        [HttpPost]
        public string LessthanZero_Checking([FromBody] BaseModel BModel)
        {
            if (!string.IsNullOrWhiteSpace(BModel.value))
            {
                BModel.value = BModel.value.Replace(",", "");
            }
            Common_BL cmbl = new Common_BL();
            return cmbl.LessthanZero_Checking(BModel.value);

        }

        public string DoubleByte_Checking([FromBody] BaseModel BModel)
        {
            Common_BL cmbl = new Common_BL();
            return cmbl.DoubleByte_Checking(BModel.value);

        }
    }
}