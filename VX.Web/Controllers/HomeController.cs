using System.Web.Mvc;
using System.Web.Script.Serialization;
using VX.Web.Infrastructure;

namespace VX.Web.Controllers
{
    [HandleError]
    public class HomeController : Controller
    {
        private readonly IMembershipService membershipService;
        private readonly ISettingsReader settingsReader;

        public HomeController(IMembershipService membershipService, ISettingsReader settingsReader)
        {
            this.membershipService = membershipService;
            this.settingsReader = settingsReader;
        }

        [Authorize]
        public ActionResult Index()
        {
            ViewData["SubscribedVocabularies"] = Serialize(membershipService.GetVocabBanksCurrentUser());
            ViewData["VocabExtServiceRest"] = settingsReader.VocabExtServiceRest;
            ViewData["MembershipServiceRest"] = settingsReader.MembershipServiceRest;
            return View();
        }

        public ActionResult Downloads()
        {
            return View();
        }

        public ActionResult About()
        {
            return View();
        }

        private static string Serialize(object objectToSerialize)
        {
            return new JavaScriptSerializer().Serialize(objectToSerialize);
        }
    }
}
