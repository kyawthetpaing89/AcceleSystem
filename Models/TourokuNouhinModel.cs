using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Models
{
     public class TourokuNouhinModel : BaseModel
     {
        public string SEQ { get; set; }
        public string DeliveryStartDate { get; set; }
        public string DeliveryEndDate { get; set; }
        public string BrandCD { get; set; }
        public string BrandName { get; set; }
        public string Season { get; set; }
        public string Year { get; set; }
        public string ProjectCD { get; set; }
        public string ProjectName { get; set; }
        public string HinbanCD { get; set; }
        public string HinbanName { get; set; }
        public string Production { get; set; }
        public string DeliveryStatus { get; set; }
        public string Remarks { get; set; }
        public string DeliveryAmount { get; set; }
        public string PeriodStart { get; set; }
        public string PeriodEnd { get; set; }
        public string TableData { get; set; }
    }
}
