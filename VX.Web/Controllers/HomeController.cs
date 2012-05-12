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
            /*Profile.GetCurrent(HttpContext.Profile).ActiveVocabularyBanks = new List<int> { 3, 4 };*/
            return View();
        }

        public ActionResult About()
        {
            return View();
        }
    }
}
