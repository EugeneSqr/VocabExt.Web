<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Words
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<h1>Words</h1>
<div id="centerPanel">
    <div class="controlButtonsWrapper">
        <button class="control-button" data-bind="button: { 
                                                text: true, 
                                                label: 'Check Word',
                                                icons: { primary: 'ui-icon-check' }
                                            }, click: checkWord"/>
        <button class="control-button" data-bind="button: { 
            text: true, 
            label: 'Add word', 
            icons: { primary: 'ui-icon-plus' } 
        }, click: addWord"/>
    </div>
    
    <div data-bind="with: activeWord, css: { wordBoxCorrect: wordExists() > 0, wordBoxIncorrect: wordExists() < 0 }" class="wordBox">
        <div>
            <div data-bind="css: { correctHighlight: $parent.spellingCorrect() > 0, incorrectHighlight: $parent.spellingCorrect() < 0 }">
                Spelling:
            </div>
            <input type="text" data-bind="value: Spelling"/>
        </div>
        <div>
            Transcription: <br/>
            <input type="text" data-bind="value: Transcription"/>
        </div>
        <div>
            <div data-bind="css: { correctHighlight: $parent.languageCorrect() > 0, incorrectHighlight: $parent.languageCorrect() < 0 }">
                Language:
            </div>
            <select data-bind="options: $parent.availableLanguages, 
                optionsText: 'Name',
                value: $parent.selectedLanguage, 
                optionsCaption: 'select language:'" />
        </div>
    </div>
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
        validateWordUrl: '<%:ViewData["VocabExtServiceRest"]%>' + 'ValidateWord',
        spellingCorrect: ko.observable(0),
        languageCorrect: ko.observable(0),
        wordExists: ko.observable(0),

        resetValidationState: function () {
            viewModel.setValidationState(0, 0, 0);
        },

        setValidationState: function (spelling, language, word) {
            viewModel.spellingCorrect(spelling);
            viewModel.languageCorrect(language);
            viewModel.wordExists(word);
        },

        checkWord: function () {
            viewModel.resetValidationState();
            console.log(viewModel.selectedLanguage);
            console.log(viewModel.activeWord);
            if (viewModel.activeWord && viewModel.activeWord.Spelling()) {
                var xhr = new easyXDM.Rpc({
                    remote: viewModel.vocabServiceHost
                }, {
                    remote: {
                        request: {}
                    }
                });

                xhr.request({
                    url: viewModel.validateWordUrl,
                    method: "POST",
                    data: ko.toJSON({
                        // TODO: should just send wordmodel, no custom rebuild
                        Id: -1,
                        Spelling: viewModel.activeWord.Spelling,
                        Transcription: viewModel.activeWord.Transcription,
                        Language: viewModel.selectedLanguage()
                    })
                }, function (response) {
                    var responseData = JSON.parse(response.data);
                    if (responseData.Status) {
                        viewModel.setValidationState(0, 0, 1);
                    } else {
                        console.log(responseData);
                    }
                });
            } else {
                viewModel.setValidationState(-1, 0, 0);
            }
        },

        addWord: function () {
            console.log(viewModel.activeWord);
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
                    // TODO: should just send wordmodel, no custom rebuild
                    Id: -1,
                    Spelling: viewModel.activeWord.Spelling,
                    Transcription: viewModel.activeWord.Transcription,
                    Language: viewModel.selectedLanguage()
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

    ko.computed(function() {
        $.ajax({
            url: viewModel.getLanguagesUrl,
            dataType: 'jsonp',
            jsonpCallback: "Languages",
            success: function(languagesData) {
                for (index in languagesData) {
                    viewModel.availableLanguages.push(new LanguageModel(languagesData[index]));
                }
            },
            error: function() {
                console.log('error getting languages');
            }
        });
    });
    
    ko.applyBindings(viewModel);
</script>
</asp:Content>
