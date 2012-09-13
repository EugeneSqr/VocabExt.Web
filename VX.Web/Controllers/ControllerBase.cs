using System.Web.Mvc;
using System.Web.Script.Serialization;
using VX.Web.Infrastructure;

namespace VX.Web.Controllers
{
    public class ControllerBase : Controller
    {
        protected readonly IMembershipService MembershipService;
        protected readonly ISettingsReader SettingsReader;

        public ControllerBase(IMembershipService membershipService, ISettingsReader settingsReader)
        {
            MembershipService = membershipService;
            SettingsReader = settingsReader;
            ViewData["test"] = "test";
        }

        protected static string Serialize(object objectToSerialize)
        {
            return new JavaScriptSerializer().Serialize(objectToSerialize);
        }
    }
}