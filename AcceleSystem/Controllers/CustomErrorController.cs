using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace AcceleSystem.Controllers
{
    public class CustomErrorController : Controller
    {
        // GET: CustomError
        [HandleError]
      
        public ActionResult CustomErrorView()
        {
            return View();
        }
    }
}