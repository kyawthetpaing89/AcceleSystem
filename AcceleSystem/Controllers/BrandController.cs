using Models;
using System.Web.Mvc;

namespace AcceleSystem.Controllers
{
    [SessionFilter]
    public class BrandController : Controller
    {
        // GET: Brand
        [SessionFilter]
        public ActionResult BrandList()
        {
            return View();
        }
        [SessionFilter]
        public ActionResult BrandEntry(BrandModel bmodel)
        {
            if(string.IsNullOrWhiteSpace(bmodel.Mode))
                bmodel.Mode = "New";
            return View(bmodel);
        }


    }
}