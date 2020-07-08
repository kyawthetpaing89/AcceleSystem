using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace AcceleSystem.Controllers
{
    public class BrandController : Controller
    {
        // GET: Brand
        public ActionResult BrandList()
        {
            return View();
        }
    }
}