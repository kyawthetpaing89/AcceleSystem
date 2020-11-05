using Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace AcceleSystem.Controllers
{
    public class Print_GenkaController : Controller
    {
        // GET: Print_Genka
        public ActionResult Print_Genka(Print_GenkaModel pgModel)
        {
            if (string.IsNullOrWhiteSpace(pgModel.Mode))
                pgModel.Mode = "New";
            return View(pgModel);
        }
    }
}