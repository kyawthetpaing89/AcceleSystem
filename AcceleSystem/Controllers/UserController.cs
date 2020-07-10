﻿using System.Web.Mvc;
using Models;

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

        public ActionResult UserEntry(UserModel Umodel)
        {
            return View(Umodel);
        }
    }
}