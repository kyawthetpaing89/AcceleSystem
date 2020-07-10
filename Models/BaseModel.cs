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
    }
}
