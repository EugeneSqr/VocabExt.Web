using System.Web.Mvc;

namespace VX.Web.Controllers
{
    [HandleError]
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            /*var service = new VocabServiceFacade();*/
            /*ViewData["Message"] = service.GetData(1);*/
            /*ViewData["Message"] = service.GetLanguage().Name;*/
            /*ViewData["Message"] = service.GetTask().Question.Spelling;*/

            return View();
        }

        public ActionResult About()
        {
            return View();
        }
    }
}
