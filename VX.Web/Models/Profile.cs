using System.Collections.Generic;
using System.Web.Profile;

namespace VX.Web.Models
{
    public class Profile : ProfileBase
    {
        public static Profile GetCurrent(ProfileBase profileBase)
        {
            return (Profile)Create(profileBase.UserName);
        }

        public static Profile GetCurrent(string userName)
        {
            return (Profile)Create(userName);
        }

        public List<int> ActiveVocabularyBanks
        {
            get
            {
                var result = base["ActiveVocabularyBanks"] as List<int>;
                return result ?? new List<int>();
            }

            set
            {
                base["ActiveVocabularyBanks"] = value;
                Save();
            }
        }
    }
}