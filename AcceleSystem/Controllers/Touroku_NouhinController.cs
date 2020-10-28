using Models;
using System.Web.Mvc;

namespace AcceleSystem.Controllers
{
    public class Touroku_NouhinController : Controller
    {
        // GET: Touroku_Nouhin
        public ActionResult Touroku_NouhinList()
        {
            return View();
        }

        public ActionResult Touroku_NouhinEntry(TourokuNouhinModel TnModel)
        {
            if(string.IsNullOrWhiteSpace(TnModel.Mode))
                TnModel.Mode = "New";
            return View(TnModel);
        }

        public ActionResult Touroku_BSNouhinEntry(TourokuNouhinModel TnModel)
        {
            if (string.IsNullOrWhiteSpace(TnModel.Mode))
                TnModel.Mode = "New";
            return View(TnModel);
        }
    }
}