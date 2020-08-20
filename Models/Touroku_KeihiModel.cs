using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Models
{
    public class Touroku_KeihiModel:BaseModel
    {
        public string CostCD { get; set; }
        public string CostName { get; set; }
        public string CostDateFrom { get; set; }
        public string CostDateTo { get; set; }
        public string BrandCD { get; set; }
        public string BrandName { get; set; }
        public string Season { get; set; }
        public string Year { get; set; }
        public string ProjectCD { get; set; }
        public string ProjectName { get; set; }
        public string HinbanCD { get; set; }
        public string HinbanName { get; set; }
    }
}
