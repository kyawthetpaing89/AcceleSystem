using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Models
{
    public class Print_GenkaModel:BaseModel
    { 
        public string TargetYear { get; set; }
        public string BrandName { get; set; }
        public string BrandCD { get; set; }
        public string Season { get; set; }
        public string ProjectCD { get; set; }
        public string ProjectName { get; set; }
        public string Year { get; set; }
        public string DeliveryStatus { get; set; }
        public string LoginID { get; set; }
        public string Type { get; set; }
        public string HinbanCD { get; set; }
    }
}
