using System.ServiceModel;
using System.Web.Security;

namespace VX.Web.Models
{
    [ServiceContract]
    public interface IMembershipService
    {
        [OperationContract]
        int GetMinPasswordLength();

        [OperationContract]
        bool ValidateUser(string userName, string password);

        [OperationContract]
        MembershipCreateStatus CreateUser(string userName, string password, string email);

        [OperationContract]
        bool ChangePassword(string userName, string oldPassword, string newPassword);

        [OperationContract]
        int[] GetVocabBanks(string username, string password);
    }
}
