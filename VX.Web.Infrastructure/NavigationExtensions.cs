using System.Web.Mvc;
using System.Web.Mvc.Html;

namespace VX.Web.Infrastructure
{
    public static class NavigationExtensions
    {
        public static string MenuItem(
            this HtmlHelper html, 
            string text, 
            string action, 
            string controller,
            string currentAction,
            string currentController)
        {
            TagBuilder tb = new TagBuilder("li");
            if (controller == currentController && action == currentAction)
                tb.GenerateId("current");

            tb.SetInnerText("{0}");
            return string.Format(
                tb.ToString(), 
                html.ActionLink(text, action, controller).ToHtmlString());
        }
    }
}
