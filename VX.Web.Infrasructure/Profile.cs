using System;
using System.Web.Profile;

namespace VX.Web.Infrastructure
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

        public int[] ActiveVocabularyBanks
        {
            get
            {
                var result = base["ActiveVocabularyBanks"] as int[];
                return result ?? new int[] { };
            }

            set
            {
                base["ActiveVocabularyBanks"] = value;
                Save();
            }
        }

        public Guid ActiveToken
        {
            get { return base["ActiveToken"] is Guid ? (Guid) base["ActiveToken"] : Guid.Empty; }
            set
            {
                base["ActiveToken"] = value;
                Save();
            }
        }
    }
}