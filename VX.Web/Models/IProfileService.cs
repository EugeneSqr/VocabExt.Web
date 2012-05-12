using System.Collections.Generic;
using System.ServiceModel;

namespace VX.Web.Models
{
    [ServiceContract]
    public interface IProfileService
    {
        [OperationContract]
        IList<int> GetVocabBanks(string username);
    }
}
