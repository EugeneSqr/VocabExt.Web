using System;
using System.ServiceModel;

namespace VX.Web.Infrastructure
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "IAuthService" in both code and config file together.
    [ServiceContract]
    public interface IAuthService
    {
        [OperationContract]
        Guid Login(string userName, string password);
    }
}
