using System;
using System.ServiceModel.Activation;
using System.ServiceModel.Web;
using System.Web.Security;
using VX.Web.Models;

namespace VX.Web
{
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class AccountMembershipService : IMembershipService
    {
        private readonly MembershipProvider _provider;

        public AccountMembershipService()
            : this(null)
        {
        }

        public AccountMembershipService(MembershipProvider provider)
        {
            _provider = provider ?? Membership.Provider;
        }

        public int GetMinPasswordLength()
        {
            return _provider.MinRequiredPasswordLength;
        }

        public bool ValidateUser(string userName, string password)
        {
            if (String.IsNullOrEmpty(userName)) throw new ArgumentException("Value cannot be null or empty.", "userName");
            if (String.IsNullOrEmpty(password)) throw new ArgumentException("Value cannot be null or empty.", "password");

            return _provider.ValidateUser(userName, password);
        }

        public MembershipCreateStatus CreateUser(string userName, string password, string email)
        {
            if (String.IsNullOrEmpty(userName)) throw new ArgumentException("Value cannot be null or empty.", "userName");
            if (String.IsNullOrEmpty(password)) throw new ArgumentException("Value cannot be null or empty.", "password");
            if (String.IsNullOrEmpty(email)) throw new ArgumentException("Value cannot be null or empty.", "email");

            MembershipCreateStatus status;
            _provider.CreateUser(userName, password, email, null, null, true, null, out status);
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
                MembershipUser currentUser = _provider.GetUser(userName, true /* userIsOnline */);
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
            var userNameNotEmpty = string.IsNullOrEmpty(username)
                ? "anonymous" 
                : username;
            var passwordNotNull = string.IsNullOrEmpty(password) 
                ? "anonymous" 
                : password;

            return ValidateUser(userNameNotEmpty, passwordNotNull)
                ? Profile.GetCurrent(userNameNotEmpty).ActiveVocabularyBanks 
                : new int[] {};
        }

        public bool PostVocabBanks(string vocabBanks)
        {
            var currentUser = Membership.GetUser();
            Profile.GetCurrent(currentUser.UserName).ActiveVocabularyBanks = new [] { 1 ,2 , 3};
            return true;
        }
    }
}
