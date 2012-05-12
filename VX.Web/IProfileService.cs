using System.Collections.Generic;
using System.ServiceModel;

namespace VX.Web
{
    [ServiceContract]
    public interface IProfileService
    {
        [OperationContract]
        IList<int> GetVocabBanks(string username);
    }
}
