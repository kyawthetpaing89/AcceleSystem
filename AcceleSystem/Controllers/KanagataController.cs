using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace AcceleSystem.Controllers
{
    public class KanagataController : Controller
    {
        // GET: Kanagata
        public ActionResult KanagataEntry()
        {
            return View();
        }

        public ActionResult KanagataList()
        {
            return View();
        }
    }
}