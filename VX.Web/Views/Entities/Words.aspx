<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Words
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<h1>Words</h1>
<div id="centerPanel">
    <div class="controlButtonsWrapper">
        <button data-bind="button: { 
            text: true, 
            label: 'Add word', 
            icons: { primary: 'ui-icon-plus' } 
        }, click: addWord"/>
    </div>
    
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
        selectedLanguage: ko.observable(),
        vocabExtServiceRest: '<%:ViewData["VocabExtServiceRest"]%>',
        vocabServiceHost: '<%:ViewData["VocabExtServiceHost"] %>' + '/Infrastructure/easyXDM/cors/index.html',
        getLanguagesUrl: '<%:ViewData["VocabExtServiceRest"]%>' + 'GetLanguages',
        saveWordUrl: '<%:ViewData["VocabExtServiceRest"]%>' + 'SaveWord',
        addWord: function () {
            var xhr = new easyXDM.Rpc({
                remote: viewModel.vocabServiceHost
            }, {
                remote: {
                    request: {}
                }
            });

            xhr.request({
                url: viewModel.saveWordUrl,
                method: "POST",
                data: ko.toJSON({
                    Spelling: viewModel.activeWord.Spelling,
                    Transcription: viewModel.activeWord.Transcription,
                    LanguageId: viewModel.selectedLanguage()
                })
            }, function (response) {
                /*var responseData = JSON.parse(response.data);
                if (responseData.Status) {
                if (responseData.OperationActionCode == 0) {
                self.commitSelections();
                }
                if (responseData.OperationActionCode == 1) {
                self.translations.push(self.activeTranslation);
                }
                self.saveTranslationDialogVisible(false);
                } else {
                self.rollbackSelections();
                console.log("update failed, reason: " + data.errorMessage);
                }*/
            });
        }
    };

    ko.computed(function () {
        $.ajax({
            url: viewModel.getLanguagesUrl,
            dataType: 'jsonp',
            jsonpCallback: "Languages",
            success: function (languagesData) {
                for (index in languagesData) {
                    viewModel.availableLanguages.push(languagesData[index]);
                }
            },
            error: function () {
                console.log('error getting languages');
            }
        });
    });
    ko.applyBindings(viewModel);
</script>
</asp:Content>
