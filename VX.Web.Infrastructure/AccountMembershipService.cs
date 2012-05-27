using System;
using System.IO;
using System.ServiceModel.Activation;
using System.Web.Script.Serialization;
using System.Web.Security;

namespace VX.Web.Infrastructure
{
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class AccountMembershipService : IMembershipService
    {
        private readonly MembershipProvider provider;

        public AccountMembershipService()
            : this(null)
        {
        }

        public AccountMembershipService(MembershipProvider provider)
        {
            this.provider = provider ?? Membership.Provider;
        }

        public int GetMinPasswordLength()
        {
            return provider.MinRequiredPasswordLength;
        }

        public bool ValidateUser(string userName, string password)
        {
            return !String.IsNullOrEmpty(userName) && !String.IsNullOrEmpty(password) &&
                   provider.ValidateUser(userName, password);
        }

        public MembershipCreateStatus CreateUser(string userName, string password, string email)
        {
            if (String.IsNullOrEmpty(userName)) throw new ArgumentException("Value cannot be null or empty.", "userName");
            if (String.IsNullOrEmpty(password)) throw new ArgumentException("Value cannot be null or empty.", "password");
            if (String.IsNullOrEmpty(email)) throw new ArgumentException("Value cannot be null or empty.", "email");

            MembershipCreateStatus status;
            provider.CreateUser(userName, password, email, null, null, true, null, out status);
            return status;
        }

        public bool ChangePassword(string userName, string oldPassword, string newPassword)
        {
            if (String.IsNullOrEmpty(userName)) throw new ArgumentException("Value cannot be null or empty.", "userName");
            if (String.IsNullOrEmpty(oldPassword)) throw new ArgumentException("Value cannot be null or empty.", "oldPassword");
            if (String.IsNullOrEmpty(newPassword)) throw new ArgumentException("Value cannot be null or empty.", "newPassword");

            // The underlying ChangePassword() will throw an exception rather
            // than return false in certain failure scenarios.
            try
            {
                MembershipUser currentUser = provider.GetUser(userName, true /* userIsOnline */);
                return currentUser.ChangePassword(oldPassword, newPassword);
            }
            catch (ArgumentException)
            {
                return false;
            }
            catch (MembershipPasswordException)
            {
                return false;
            }
        }

        public int[] GetVocabBanks(string username, string password)
        {
            return ValidateUser(username, password)
                       ? Profile.GetCurrent(username).ActiveVocabularyBanks
                       : new int[] {};
        }

        public int[] GetVocabBanksCurrentUser()
        {
            var currentProfile = GetCurrentUserProfile();
            return currentProfile != null 
                ? currentProfile.ActiveVocabularyBanks 
                : new int[] { };
        }

        public bool PostVocabBanks(Stream data)
        {
            var currentProfile = GetCurrentUserProfile();
            if (currentProfile != null)
            {
                string message = new StreamReader(data).ReadToEnd();
                currentProfile.ActiveVocabularyBanks = new JavaScriptSerializer().Deserialize<int[]>(message);
                return true;
            }
            
            return false;
        }

        private static Profile GetCurrentUserProfile()
        {
            var currentUser = Membership.GetUser();
            return currentUser != null 
                ? Profile.GetCurrent(currentUser.UserName) 
                : null;
        }
    }
}
