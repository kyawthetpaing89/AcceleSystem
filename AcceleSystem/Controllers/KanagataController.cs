﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Models;

namespace AcceleSystem.Controllers
{
    [SessionFilter]
    public class KanagataController : Controller
    {
        // GET: Kanagata
        public ActionResult KanagataEntry(KanagataModel kgmodel)
        {
            if (string.IsNullOrWhiteSpace(kgmodel.Mode))
                kgmodel.Mode = "New";
            return View(kgmodel);
        }

        public ActionResult KanagataList()
        {
            return View();
        }
    }
}