<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Entities list
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1>Available<span class="white"> entities</span></h1>
    <ul>
        <li><%: Html.ActionLink("Vocabulary banks", "banks", "Entities") %></li>
        <li><%: Html.ActionLink("Words", "words", "Entities") %></li>
    </ul>
</asp:Content>
