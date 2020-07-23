using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Models
{
    public class KeihiSetteiModel : BaseModel
    {
        public string CostCD { get; set; }
        public string CostName { get; set; }
        public string KanjoCD { get; set; }
        public string HojoCD { get; set; }
        public string Accounting { get; set; }
        public string Alloctaion { get; set; }

    }
}
