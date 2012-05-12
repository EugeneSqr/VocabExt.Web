using System.Collections.Generic;
using System.ServiceModel.Activation;
using VX.Web.Models;

namespace VX.Web
{
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class ProfileService : IProfileService
    {
        public IList<int> GetVocabBanks(string username)
        {
            return Profile.GetCurrent(username).ActiveVocabularyBanks;
        }
    }
}
