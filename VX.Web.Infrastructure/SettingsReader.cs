using System.Configuration;

namespace VX.Web.Infrastructure
{
    public class SettingsReader : ISettingsReader
    {
        private const string VocabExtServiceRestKey = "VocabExtServiceRest";
        private const string VocabExtServiceSoapKey = "VocabExtServiceSoap";
        private const string MembershipServiceRestKey = "MembershipServiceRest";
        private const string MembershipServiceSoapKey = "MembershipServiceSoap";
        
        public string VocabExtServiceRest
        {
            get { return ConfigurationManager.AppSettings[VocabExtServiceRestKey]; }
        }

        public string VocabExtServiceSoap
        {
            get { return ConfigurationManager.AppSettings[VocabExtServiceSoapKey]; }
        }

        public string MembershipServiceRest
        {
            get { return ConfigurationManager.AppSettings[MembershipServiceRestKey]; }
        }

        public string MembershipServiceSoap
        {
            get { return ConfigurationManager.AppSettings[MembershipServiceSoapKey]; }
        }
    }
}
