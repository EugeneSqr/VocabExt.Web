namespace VX.Web.Infrastructure
{
    public interface ISettingsReader
    {
        string VocabExtServiceRest { get; }

        string VocabExtServiceSoap { get; }

        string MembershipServiceRest { get; }

        string MembershipServiceSoap { get; }
    }
}
