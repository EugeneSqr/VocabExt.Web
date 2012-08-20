using System.Web.Mvc;
using VX.Web.Infrastructure;

namespace VX.Web.Controllers
{
    public class EntitiesController : ControllerBase
    {
        public EntitiesController(IMembershipService membershipService, ISettingsReader settingsReader) 
            : base(membershipService, settingsReader)
        {
        }

        [Authorize]
        public ActionResult Index()
        {
            return View();
        }

        [Authorize]
        public ActionResult Banks()
        {
            ViewData["VocabExtServiceRest"] = SettingsReader.VocabExtServiceRest;
            ViewData["VocabExtServiceHost"] = SettingsReader.VocabExtServiceHost;
            return View();
        }

        [Authorize]
        public ActionResult Words()
        {
            ViewData["VocabExtServiceRest"] = SettingsReader.VocabExtServiceRest;
            ViewData["VocabExtServiceHost"] = SettingsReader.VocabExtServiceHost;
            return View();
        }
    }
}
