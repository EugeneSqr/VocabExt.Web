using System.Web.Mvc;
using System.Web.Script.Serialization;

namespace VX.Web.Controllers
{
    public class BankController : Controller
    {
        public ActionResult Index()
        {
            // TODO: just a stub. Replace with proper implementation (with autofac)
            ViewData["SubscribedVocabularies"] = new JavaScriptSerializer().Serialize(new[] { 1, 3, 4 });
            return View();
        }
    }
}
