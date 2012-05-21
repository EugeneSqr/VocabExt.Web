using System;
using System.ServiceModel.Activation;

namespace VX.Web.Infrastructure
{
    // TODO: rename to ProfileService
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class AuthService : IAuthService
    {
        public IMembershipService MembershipService { get; set; }

        public AuthService(IMembershipService membershipService)
        {
            MembershipService = membershipService;
        }

        public Guid Login(string userName, string password)
        {
            var result = Guid.Empty;
            if (MembershipService.ValidateUser(userName, password))
            {
                var user = Profile.GetCurrent(userName);
                result = Guid.NewGuid();
                user.ActiveToken = result;
            }

            return result;
        }
    }
}
