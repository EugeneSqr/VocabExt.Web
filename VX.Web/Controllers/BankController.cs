using System.Web.Mvc;
using System.Web.Script.Serialization;
using VX.Web.Infrastructure;

namespace VX.Web.Controllers
{
    public class BankController : Controller
    {
        private readonly IMembershipService membershipService;
        
        public BankController(IMembershipService membershipService)
        {
            this.membershipService = membershipService;
        }

        public ActionResult Index()
        {
            ViewData["SubscribedVocabularies"] =
                new JavaScriptSerializer().Serialize(
                    membershipService.GetVocabBanksCurrentUser());
            return View();
        }
    }
}
