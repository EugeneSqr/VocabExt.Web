using System;
using System.ServiceModel.Activation;

namespace VX.Web.Infrastructure
{
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class ProfileService : IProfileService
    {
        private readonly IMembershipService membershipService;
        
        public ProfileService(IMembershipService membershipService)
        {
            this.membershipService = membershipService;
        }

        public int[] GetVocabBanks(Guid token)
        {
            var profile = membershipService.GetUserProfileByToken(token);
            
            return profile != null
                ? profile.ActiveVocabularyBanks
                : new int[] { };
        }

        public int[] GetCurrentUserVocabBanks()
        {
            var profile = membershipService.GetCurrentUserProfile();
            return profile != null
                ? profile.ActiveVocabularyBanks
                : new int[] { };
        }

        public bool PostVocabBanks(string vocabBanks)
        {
            var profile = membershipService.GetCurrentUserProfile();
            if (profile != null)
            {
                //TODO: convertion
                //profile.ActiveVocabularyBanks = vocabBanks
                return true;
            }

            return false;
        }
    }
}
