using Models;
using System.Web.Mvc;

namespace AcceleSystem.Controllers
{
    public class KeihiSetteiController : Controller
    {
        // GET: KeihiSettei
        public ActionResult KeihiSetteiList()
        {
            return View();
        }

        public ActionResult KeihiSetteiEntry(KeihiSetteiModel Kmodel)
        {
            if (string.IsNullOrWhiteSpace(Kmodel.Mode))
                Kmodel.Mode = "New";
            return View(Kmodel);
        }
    }
}