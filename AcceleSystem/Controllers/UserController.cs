using Models;
using System.Web.Mvc;

namespace AcceleSystem.Controllers
{
    public class UserController : Controller
    {
        // GET: User
        public ActionResult UserList()
        {
            return View();
        }
       
        public ActionResult UserLogIn()
        {
            return View();            
        }

        public ActionResult UserEntry(UserModel Umodel)
        {
            if (string.IsNullOrWhiteSpace(Umodel.Mode))
                Umodel.Mode = "New";
            return View(Umodel);
        }
    }
}