using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Models
{
    public class MessageModel : BaseModel
    {
        public string MessageID { get; set; }
        public string MessageText1 { get; set; }
        public string MessageButton { get; set; }
    }
}
