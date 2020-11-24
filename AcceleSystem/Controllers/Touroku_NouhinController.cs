using Models;
using System.Web.Mvc;

namespace AcceleSystem.Controllers
{
    [SessionFilter]
    public class Touroku_NouhinController : Controller
    {
        // GET: Touroku_Nouhin
        public ActionResult Touroku_NouhinList(TourokuNouhinModel TnModel)
        {
            return View(TnModel);
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