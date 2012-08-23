<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Words
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<h1>Words</h1>
<div id="centerPanel">
    <div class="controlButtonsWrapper">
        <div data-bind="visible: checkIndicatorVisible" class="processingIndicator">
            <img class="processingIndicator" src="/Content/Images/processing-loader.gif" alt="processing" />
        </div>
        <button class="control-button" data-bind="button: {text: true, label: 'Check Word', icons: {primary: 'ui-icon-check'}}, click: checkWord"></button>
        <button class="control-button" data-bind="button: {text: true, label: 'Add word', icons: {primary: 'ui-icon-plus'}}, click: addWord"></button>
    </div>
    <div data-bind="with: activeWord">
        <label for="spelling" data-bind="css: {correctHighlight: $parent.spellingCorrect() > 0, incorrectHighlight: $parent.spellingCorrect() < 0}">
            Spelling:
        </label>
        <input id="spelling" type="text" data-bind="value: Spelling"/>
        <label for="transcription">Transcription:</label>
        <input id="transcription" type="text" data-bind="value: Transcription"/>
        <label for="language" data-bind="css: {correctHighlight: $parent.languageCorrect() > 0, incorrectHighlight: $parent.languageCorrect() < 0}">
            Language:
        </label>
    </div>
    <select data-bind="options: availableLanguages, optionsText: 'Name', value: activeWord.Language, optionsCaption: 'Pick one:'" class="languageBox"></select>
</div>
<script type="text/javascript">
    var viewModel = {
        activeWord: new WordModel(null),
        availableLanguages: ko.observableArray(),
        vocabExtServiceRest: '<%:ViewData["VocabExtServiceRest"]%>',
        vocabServiceHost: '<%:ViewData["VocabExtServiceHost"] %>' + '/Infrastructure/easyXDM/cors/index.html',
        getLanguagesUrl: '<%:ViewData["VocabExtServiceRest"]%>' + 'GetLanguages',
        saveWordUrl: '<%:ViewData["VocabExtServiceRest"]%>' + 'SaveWord',
        validateWordUrl: '<%:ViewData["VocabExtServiceRest"]%>' + 'ValidateWord',
        spellingCorrect: ko.observable(0),
        languageCorrect: ko.observable(0),
        checkIndicatorVisible: ko.observable(false),

        resetValidationState: function () {
            viewModel.setValidationState(0, 0);
        },

        setValidationState: function (spelling, language) {
            viewModel.spellingCorrect(spelling);
            viewModel.languageCorrect(language);
        },

        analyseServiceResponse: function (responseData) {
            if (!responseData.Status) {
                if (responseData.ErrorMessage == "1") {
                    viewModel.setValidationState(-1, 0);
                } else if (responseData.ErrorMessage == "2") {
                    viewModel.setValidationState(0, -1);
                } else if (responseData.ErrorMessage == "3") {
                    viewModel.setValidationState(-1, 0);
                } else {
                    console.log('unknown error');
                }
            }
        },

        sendWordRequest: function (serviceUrl) {
            viewModel.resetValidationState();
            if (viewModel.activeWord && viewModel.activeWord.Spelling()) {
                var xhr = new easyXDM.Rpc({
                    remote: viewModel.vocabServiceHost
                }, {
                    remote: {
                        request: {}
                    }
                });

                viewModel.checkIndicatorVisible(true);
                xhr.request({
                    url: serviceUrl,
                    method: "POST",
                    data: ko.toJSON(viewModel.activeWord)
                }, function (response) {
                    viewModel.checkIndicatorVisible(false);
                    var responseData = JSON.parse(response.data);
                    viewModel.analyseServiceResponse(responseData);
                }, function () {
                    viewModel.checkIndicatorVisible(false);
                    viewModel.resetValidationState();
                });
            } else {
                viewModel.setValidationState(-1, 0);
            }
        },

        checkWord: function () {
            viewModel.sendWordRequest(viewModel.validateWordUrl);
        },

        addWord: function () {
            viewModel.sendWordRequest(viewModel.saveWordUrl);
        }
    };

    ko.computed(function () {
        console.log('getting languages');
        $.ajax({
            url: viewModel.getLanguagesUrl,
            dataType: 'jsonp',
            success: function (languagesData) {
                for (index in languagesData) {
                    viewModel.availableLanguages.push(new LanguageModel(languagesData[index]));
                }
            },
            error: function (language) {
                console.log(language);
                console.log('error getting languages');
            }
        });
    });

    ko.applyBindings(viewModel);
</script>
</asp:Content>
