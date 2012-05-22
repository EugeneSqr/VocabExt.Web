using System.IO;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Web.Security;

namespace VX.Web.Infrastructure
{
    [ServiceContract]
    public interface IMembershipService
    {
        [OperationContract]
        int GetMinPasswordLength();

        [OperationContract]
        [WebInvoke(BodyStyle = WebMessageBodyStyle.Wrapped)]
        bool ValidateUser(string userName, string password);

        [OperationContract]
        [WebInvoke(BodyStyle = WebMessageBodyStyle.Wrapped)]
        MembershipCreateStatus CreateUser(string userName, string password, string email);

        [OperationContract]
        [WebInvoke(BodyStyle = WebMessageBodyStyle.Wrapped)]
        bool ChangePassword(string userName, string oldPassword, string newPassword);

        [OperationContract]
        [WebInvoke(BodyStyle = WebMessageBodyStyle.Wrapped)]
        int[] GetVocabBanks(string username, string password);

        [OperationContract]
        int[] GetVocabBanksCurrentUser();

        [OperationContract]
        [WebInvoke(Method = "POST")]
        bool PostVocabBanks(Stream data);
    }
}
