using System.Web.Mvc;
using VX.Web.Infrastructure;

namespace VX.Web.Controllers
{
    [HandleError]
    public class HomeController : ControllerBase
    {
        public HomeController(IMembershipService membershipService, ISettingsReader settingsReader) : base(membershipService, settingsReader)
        {
        }

        [Authorize]
        public ActionResult Index()
        {
            ViewData["SubscribedVocabularies"] = Serialize(MembershipService.GetVocabBanksCurrentUser());
            ViewData["VocabExtServiceRest"] = SettingsReader.VocabExtServiceRest;
            ViewData["MembershipServiceRest"] = SettingsReader.MembershipServiceRest;
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
    }
}
