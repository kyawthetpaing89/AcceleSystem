using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Models;

namespace AcceleSystem.Controllers
{
    public class Touroku_KeihiController : Controller
    {
        // GET: Touroku_Keihi
        [SessionFilter]
        public ActionResult Touroku_KeihiEntry(Touroku_KeihiModel kmodel)
        {
            if (string.IsNullOrWhiteSpace(kmodel.Mode))
                kmodel.Mode = "New";
            return View(kmodel);
        }
        [SessionFilter]
        public ActionResult Touroku_KeihiList(Touroku_KeihiModel kmodel)
        {
            return View(kmodel);
        }
    }
}