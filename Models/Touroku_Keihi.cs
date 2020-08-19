using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Models
{
    public class Touroku_Keihi:BaseModel
    {
        public string CostCD { get; set; }
        public string CostName { get; set; }
        public string KanjoCD { get; set; }
        public string HojoCD { get; set; }
        public string KanjoName { get; set; }
        public string HojoName { get; set; }
        public string Accounting { get; set; }
        public string Allocation { get; set; }
    }
}
