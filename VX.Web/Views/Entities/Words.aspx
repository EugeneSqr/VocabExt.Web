<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Words
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<h1>Words</h1>
<div id="centerPanel">
    <div data-bind="with: activeWord">
        Spelling: <br/>
        <input type="text" data-bind="value: Spelling"/> <br/>
        Transcription: <br/>
        <input type="text" data-bind="value: Transcription"/> <br/>
        Language: <br/>
    </div>

    <select data-bind="options: availableLanguages, 
        optionsText: 'Name', 
        optionsValue: 'Id',
        value: selectedLanguage, 
        optionsCaption: 'select language:'" /><br/>​
</div>
 
<script type="text/javascript">
    var viewModel = {
        activeWord: new WordModel(null),
        availableLanguages: ko.observableArray(),
        selectedLanguage: ko.observable()
    };

    ko.computed(function () {
        viewModel.availableLanguages.push({ Name: "English", Id: "1" });
        viewModel.availableLanguages.push({ Name: "Russian", Id: "2" });
    });
    ko.applyBindings(viewModel);
</script>
</asp:Content>
