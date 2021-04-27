using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace AcceleSystem.Controllers
{
    public class SearchController : Controller
    {
        // GET: Search
        public ActionResult BrandSearch()
        {
            return View();
        }

        public ActionResult BSearch()
        {
            return PartialView();
        }
    }
}