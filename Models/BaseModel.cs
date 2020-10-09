using System.Data.SqlClient;

namespace Models
{
    public class BaseModel
    {
        public string Mode { get; set; }
        public string SPName { get; set; }
        public string CreatedBy { get; set; }
        public string CreatedDate { get; set; }
        public SqlParameter[] Sqlprms { get; set; }
        public string inputdate { get; set; }
        public string startDate { get; set; }
        public string endDate { get; set; }
        public string flg { get; set; }
        public string value { get; set; }
        public string value1 { get; set; }
    }
}
