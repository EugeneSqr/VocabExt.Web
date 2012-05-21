using System;
using System.Web.Security;

namespace VX.Web.Infrastructure
{
    public interface IMembershipService
    {
        int GetMinPasswordLength();
        
        bool ValidateUser(string userName, string password);
        
        MembershipCreateStatus CreateUser(string userName, string password, string email);
        
        bool ChangePassword(string userName, string oldPassword, string newPassword);

        Profile GetCurrentUserProfile();

        Profile GetUserProfileByToken(Guid token);
    }
}
