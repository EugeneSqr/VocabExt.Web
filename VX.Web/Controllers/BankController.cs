using System.Web.Mvc;
using System.Web.Script.Serialization;
using VX.Web.ProfileServiceReference;

namespace VX.Web.Controllers
{
    public class BankController : Controller
    {
        public ActionResult Index()
        {
            // TODO: just a stub. Replace with proper implementation (with autofac)
            ProfileServiceClient serviceClient = new ProfileServiceClient();
            ViewData["SubscribedVocabularies"] = new JavaScriptSerializer()
                .Serialize(serviceClient.GetCurrentUserVocabBanks());
            return View();
        }
    }
}
