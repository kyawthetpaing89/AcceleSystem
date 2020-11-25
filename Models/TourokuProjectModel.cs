using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Models
{
    public class TourokuProjectModel : BaseModel
    {
        public string ProjectCD { get; set; }
        public string ProjectName { get; set; }
        public string Year { get; set; }
        public string BrandCD { get; set; }
        public string Season { get; set; }
        public string PeriodStart { get; set; }
        public string PeriodEnd { get; set; }
        public string ProjectManager { get; set; }
        public string AllocationCount { get; set; }
        public string BrandName { get; set; }
       
        public string TotalAmount { get; set; }
        public string StartPrice { get; set; }
        public string EndPrice { get; set; }
        public string UserName { get; set; }
        public string ProjectManagerName { get; set; }
        public string HinbanCD { get; set; }
        public string HinbanName { get; set; }
        public string Color { get; set; }
        public string CastingCD { get; set; }
        public string CastingName { get; set; }
        public string Production { get; set; }
        public string SalePrice { get; set; }
        public string Complete { get; set; }
        public string CompleteYM { get; set; }
        public string FreeItem1 { get; set; }
        public string FreeItem2 { get; set; }
        public string ProjectCD1 { get; set; }
        public string BrandCD1 { get; set; }
    }
}
