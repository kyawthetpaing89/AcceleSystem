using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Models;
using System.Web.Mvc;

namespace AcceleSystem.Controllers
{
    public class TourokuProjectController : Controller
    {
        // GET: Touroku
        public ActionResult TourokuProject_List()
        {
            return View();
        }
        public ActionResult TourokuProject_Entry()
        {
            return View();
        }
        public ActionResult TourokuHinban_Entry(TourokuProjectModel Tmodel)
        {
            if (string.IsNullOrWhiteSpace(Tmodel.Mode))
                Tmodel.Mode = "New";
            return View(Tmodel);
        }

        public ActionResult TourokuHinban_List()
        {
            return View();
        }
    }
}