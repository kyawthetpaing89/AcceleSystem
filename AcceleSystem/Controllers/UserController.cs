﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
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

        public ActionResult UserEntry()
        {
            return View();
        }
    }
}