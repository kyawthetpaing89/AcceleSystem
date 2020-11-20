using Models;
using System.Web.Mvc;

namespace AcceleSystem.Controllers
{
    public class BrandController : Controller
    {
        // GET: Brand
        
        public ActionResult BrandList()
        {
            return View();
        }
        public ActionResult BrandEntry(BrandModel bmodel)
        {
            if(string.IsNullOrWhiteSpace(bmodel.Mode))
                bmodel.Mode = "New";
            return View(bmodel);
        }


    }
}