using System;
using System.ServiceModel;
using System.ServiceModel.Web;

namespace VX.Web.Infrastructure
{
    [ServiceContract]
    public interface IProfileService
    {
        [OperationContract]
        int[] GetVocabBanks(Guid token);

        [OperationContract]
        int[] GetCurrentUserVocabBanks();

        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "PostVocabBanks/{vocabBanks}", BodyStyle = WebMessageBodyStyle.Wrapped)]
        bool PostVocabBanks(string vocabBanks);
    }
}
