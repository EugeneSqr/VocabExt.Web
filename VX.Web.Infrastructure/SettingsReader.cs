using System.Configuration;

namespace VX.Web.Infrastructure
{
    public class SettingsReader : ISettingsReader
    {
        private const string VocabExtServiceRestKey = "VocabExtServiceRest";
        private const string MembershipServiceRestKey = "MembershipServiceRest";
        
        public string VocabExtServiceRest
        {
            get { return ConfigurationManager.AppSettings[VocabExtServiceRestKey]; }
        }
        
        public string MembershipServiceRest
        {
            get { return ConfigurationManager.AppSettings[MembershipServiceRestKey]; }
        }
    }
}
