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
    
    <label for="spelling" data-bind="css: {correctHighlight: spellingCorrect() > 0, incorrectHighlight: spellingCorrect() < 0}">
        Spelling:
    </label>
    <input id="spelling" type="text" data-bind="value: spelling"/>
    <label for="transcription">Transcription:</label>
    <input id="transcription" type="text" data-bind="value: transcription"/>
    <label for="language" data-bind="css: {correctHighlight: languageCorrect() > 0, incorrectHighlight: languageCorrect() < 0}">
        Language:
    </label>
    
    <select data-bind="options: languages, optionsText: 'Name', value: language, optionsCaption: 'Pick one:'" class="languageBox"></select>
</div>
<script type="text/javascript">
(function () {
    vx.initialize('<%:ViewData["VocabExtServiceRest"]%>', '<%:ViewData["VocabExtServiceHost"] %>');

    var viewModel = {
        wordModel: new WordModel(null),
        spelling: ko.observable(""),
        transcription: ko.observable(""),
        language: ko.observable(),
        languages: ko.observableArray(),

        spellingCorrect: ko.observable(0),
        languageCorrect: ko.observable(0),
        checkIndicatorVisible: ko.observable(false),

        resetValidationState: function () {
            viewModel.setValidationState(0, 0);
        },

        setValidationState: function (spellingState, languageState) {
            viewModel.spellingCorrect(spellingState);
            viewModel.languageCorrect(languageState);
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

            var xhr = new easyXDM.Rpc({
                remote: vx.BuildServiceHostUrl()
            }, {
                remote: {
                    request: {}
                }
            });

            viewModel.checkIndicatorVisible(true);
            xhr.request({
                url: serviceUrl,
                method: "POST",
                data: ko.toJSON(viewModel.wordModel)
            }, function (response) {
                viewModel.checkIndicatorVisible(false);
                var responseData = JSON.parse(response.data);
                viewModel.analyseServiceResponse(responseData);
            }, function () {
                viewModel.checkIndicatorVisible(false);
                viewModel.resetValidationState();
            });

        },

        checkWord: function () {
            viewModel.sendWordRequest(vx.BuildValidateWordUrl());
        },

        addWord: function () {
            viewModel.sendWordRequest(vx.BuildSaveWordUrl());
        }
    };

    ko.computed(function () {
        $.ajax({
            url: vx.BuildGetLanguagesUrl(),
            dataType: 'jsonp',
            success: function (languagesData) {
                for (index in languagesData) {
                    viewModel.languages.push(new LanguageModel(languagesData[index]));
                }
            },
            error: function (language) {
                console.log(language);
                console.log('error getting languages');
            }
        });
    });

    ko.computed(function () {
        viewModel.wordModel.Spelling = viewModel.spelling();
        viewModel.wordModel.Transcription = viewModel.transcription();
        viewModel.wordModel.Language = viewModel.language();
    });

    ko.applyBindings(viewModel);
})();
</script>
</asp:Content>
