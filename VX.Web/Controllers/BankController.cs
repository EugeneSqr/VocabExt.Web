using System.Web.Mvc;
using System.Web.Script.Serialization;
using VX.Web.Infrastructure;


namespace VX.Web.Controllers
{
    public class BankController : Controller
    {
        private readonly IMembershipService membershipService;
        private readonly ISettingsReader settingsReader;
        
        public BankController(IMembershipService membershipService, ISettingsReader settingsReader)
        {
            this.membershipService = membershipService;
            this.settingsReader = settingsReader;
        }

        public ActionResult Index()
        {
            ViewData["SubscribedVocabularies"] = Serialize(membershipService.GetVocabBanksCurrentUser());
            ViewData["VocabExtServiceRest"] = settingsReader.VocabExtServiceRest;
            ViewData["MembershipServiceRest"] = settingsReader.MembershipServiceRest;
            return View();
        }

        private static string Serialize(object objectToSerialize)
        {
            return new JavaScriptSerializer().Serialize(objectToSerialize);
        }
    }
}
