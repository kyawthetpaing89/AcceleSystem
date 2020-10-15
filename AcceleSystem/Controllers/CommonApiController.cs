using System.Web.Http;
using System.Web.Http.Results;
using System.Data;
using Newtonsoft.Json;
using Models;
using CommonBL;
using System.Collections.Generic;
using System.Text;
using System.Linq;

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

        public string Year_Checking([FromBody] BaseModel BModel)
        {
            Common_BL cmbl = new Common_BL();
            return cmbl.Year_Checking(BModel.inputdate);

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

        //public void ExportCSVfile([FromBody] BaseModel BModel)
        //{
        //    string data = BModel.value;
        //    var response = System.Web.HttpContext.Current.Response;
        //    if (!data.Equals("[]"))
        //    {
        //        DataTable dt = (DataTable)JsonConvert.DeserializeObject(data, (typeof(DataTable)));
        //        if (dt.Rows.Count > 0)
        //        {
        //            StringBuilder sb = new StringBuilder();

        //            IEnumerable<string> columnNames = dt.Columns.Cast<DataColumn>().
        //                                              Select(column => column.ColumnName);
        //            sb.AppendLine(string.Join(",", columnNames));

        //            foreach (DataRow row in dt.Rows)
        //            {
        //                IEnumerable<string> fields = row.ItemArray.Select(field =>
        //                  string.Concat("\"", field.ToString().Replace("\"", "\"\""), "\""));
        //                sb.AppendLine(string.Join(",", fields));
        //            }
        //            response.Clear();
        //            response.Buffer = true;
        //            response.AddHeader("content-disposition", "attachment;filename=ProductDetails.csv");
        //            response.Charset = "";
        //            response.ContentType = "application/text";
        //            response.Output.Write(sb);
        //            response.Flush();
        //            response.End();


        //        }
        //    }
        //}
        public string ExportCSVfile([FromBody] BaseModel BModel)
        {
            Common_BL cmbl = new Common_BL();
            return cmbl.ExportCSVfile(BModel.value, BModel.value1);
        }

        public string M_Control_FiscalCheck([FromBody] BaseModel BModel)
        {
            Common_BL cmbl = new Common_BL();
            return cmbl.M_Control_FiscalCheck(BModel);
        }
    }
}