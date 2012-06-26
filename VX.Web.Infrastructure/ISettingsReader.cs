namespace VX.Web.Infrastructure
{
    public interface ISettingsReader
    {
        string VocabExtServiceRest { get; }

        string MembershipServiceRest { get; }

        string VocabExtServiceHost { get; }
    }
}
