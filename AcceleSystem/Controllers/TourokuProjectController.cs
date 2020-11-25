using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Models;
using System.Web.Mvc;

namespace AcceleSystem.Controllers
{
    [SessionFilter]
    public class TourokuProjectController : Controller
    {
        // GET: Touroku
        public ActionResult TourokuProject_List(TourokuProjectModel Tmodel)
        {
            return View(Tmodel);
        }
        public ActionResult TourokuProject_Entry(TourokuProjectModel Tmodel)
        {
            if (string.IsNullOrWhiteSpace(Tmodel.Mode))
                Tmodel.Mode = "New";
            return View(Tmodel);
        }
        public ActionResult TourokuHinban_Entry(TourokuProjectModel Tmodel)
        {
            if (string.IsNullOrWhiteSpace(Tmodel.Mode))
                Tmodel.Mode = "New";
            return View(Tmodel);
        }

        public ActionResult TourokuHinban_List(TourokuProjectModel Tmodel)
        {
            return View(Tmodel);
        }
    }
}