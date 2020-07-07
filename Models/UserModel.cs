using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Models
{
    public class UserModel : BaseModel
    {
        public string UserID { get; set; }
        public string Password { get; set; }
        public string UserName { get; set; }
    }
}
