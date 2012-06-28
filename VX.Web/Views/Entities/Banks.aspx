<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Banks
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1>Banks</h1>
    <div id="leftPanel">
        <div align="center" data-bind="slideVisible : showLoading">
            <img style="background: transparent; border: 0px" src="/Content/Images/loader.gif" alt="loading"/>
        </div>
        <div data-bind="slideVisible : showContent">
            <div data-bind="foreach: vocabularies">
                <div class="banksList" data-bind="text: bankName, click: $parent.displayDetails"></div>
            </div>
        </div>
    </div>
    <div id="rightPanel" data-bind="with: activeBank">
        Name: <br/>
        <input class="bankDetails" type="text" data-bind="value: bankName"/><br/>
        Description: <br/>
        <textarea cols="200" rows="3" data-bind="value: bankDescription" ></textarea><br/>
        Translations: <br/>
        <div data-bind="visible: loadingShown" align="center">
            <img style="background: transparent; border: 0px" src="/Content/Images/loader.gif" alt="loading"/>
        </div>
        <div data-bind="slideVisible : translationsShown">
            <table>
                <tbody data-bind="foreach: translations">
                    <tr data-bind="css: { odd: (index % 2 == 1), even: (index % 2 == 0) }">
                        <td data-bind="text: activeSource().Spelling" />
                        <td data-bind="text: activeTarget().Spelling" />
                        <td>
                            <input type="button" data-bind="click: openEditDialog" value="Edit"/>
                            <div data-bind="dialog: {
                                    autoOpen: false,
                                    draggable: false,
                                    resizable: false,
                                    modal: true,
                                    width: 480,
                                    height: 275,
                                    title: 'Edit',
                                    buttons: { 
                                        'Save': submitEditDialog, 
                                        'Cancel': cancelEditDialog
                                    } 
                                }, 
                                visible: editDialogVisible">
                                
	                            <div class="dialog-left-column">
	                                
	                                <div>Specify source:</div>
                                    <input class="dialog-text-input" data-bind="autocomplete: { 
                                            source: banksListViewModel.sourceOptions(), 
                                            select: fillSourceFromAutocomplete,
                                            minLength: 2
                                        }, 
                                        searchString: banksListViewModel.sourceSearchString"/>
                                    
                                    <div>Active source:</div>
                                    <div class="dialog-group">
                                        <div data-bind="with: activeSource">
                                            <div>Spelling</div>
                                            <input data-bind="value: Spelling" class="dialog-text-input" type="text" disabled="disabled"></input>
                                            <div>Transcription</div>
                                            <input data-bind="value: Transcription" class="dialog-text-input" type="text" disabled="disabled"></input>
                                        </div>
                                    </div>
                                </div>

                                <div class="dialog-middle-column"></div>
                                
                                <div class="dialog-right-column">
                                    <div>Specify target:</div>
                                    <input class="dialog-text-input" data-bind="autocomplete: { 
                                            source: banksListViewModel.targetOptions(), 
                                            select: fillTargetFromAutocomplete,
                                            minLength: 2
                                        }, 
                                        searchString: banksListViewModel.targetSearchString"/>
                                    <div>Active target:</div>
                                    <div class="dialog-group">
                                        <div data-bind="with: activeTarget">
                                            <div>Spelling</div>
                                            <input data-bind="value: Spelling" type="text" class="dialog-text-input" disabled="disabled"></input>
                                            <div>Transcription</div>
                                            <input data-bind="value: Transcription" type="text" class="dialog-text-input" disabled="disabled"></input>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="clear" />
                            </div>
                        </td>
                        <td><input type="button" value="Delete"/></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
    <div class="clear"></div>
    <script type="text/javascript">
        function BanksListModel() {
            var self = this;

            self.showLoading = ko.observable(true);
            self.showContent = ko.computed(function() {
                return !self.showLoading();
            });
            
            self.vocabularies = ko.observableArray();
            self.activeBank = ko.observable();
            self.getBanksListUrl = '<%:ViewData["VocabExtServiceRest"]%>' + 'GetVocabBanksList';
            self.getTranslationsUrl = '<%:ViewData["VocabExtServiceRest"]%>' + 'GetTranslations';
            self.updateTranslationUrl = '<%:ViewData["VocabExtServiceRest"]%>' + 'UpdateTranslation';
            self.getWordsUrl = '<%:ViewData["VocabExtServiceRest"]%>' + 'GetWords';
            self.vocabServiceHost = '<%:ViewData["VocabExtServiceHost"] %>' + '/Infrastructure/easyXDM/cors/index.html';

            self.sourceOptions = ko.observableArray();
            self.sourceOptionsRaw = [];
            self.targetOptions = ko.observableArray();
            self.targetOptionsRaw = [];

            self.sourceSearchString = ko.observable("");
            self.targetSearchString = ko.observable("");

            self.displayDetails = function (bankDetailsModel) {
                self.activeBank(bankDetailsModel);
                $.ajax({
                    url: self.getTranslationsUrl + '/' + bankDetailsModel.id,
                    dataType: 'jsonp',
                    jsonpCallback: "Translations",
                    success: function (translationsData) {
                        var translations = eval(translationsData);
                        bankDetailsModel.translations.removeAll();
                        for (index in translations) {
                            bankDetailsModel.translations.push(new TranslationModel(translations[index]));
                        }

                        bankDetailsModel.translationsShown(true);
                    },
                    error: function () {
                        bankDetailsModel.translationsShown(true);
                    }
                });
            };
        }

        function BankDetailsModel(bankData) {
            var self = this;

            self.id = bankData.Id;
            self.bankName = bankData.Name;
            self.bankDescription = bankData.Description;
            self.translationsShown = ko.observable(false);
            self.translations = ko.observableArray();
            
            self.loadingShown = ko.computed(function() {
                return !self.translationsShown();
            });
        }
        
        function TranslationModel(translationData) {
            var self = this;

            self.__type = translationData.__type;
            self.Id = translationData.Id;
            self.originalSource = new WordModel(translationData.Source);
            self.originalTarget = new WordModel(translationData.Target);
            self.activeSource = ko.observable(self.originalSource);
            self.activeTarget = ko.observable(self.originalTarget);
            self.editDialogVisible = ko.observable(false);

            self.openEditDialog = function () {
                self.editDialogVisible(true);
            };

            self.submitEditDialog = function () {
                var xhr = new easyXDM.Rpc({
                    remote: banksListViewModel.vocabServiceHost
                }, {
                    remote: {
                        request: {}
                    }
                });

                xhr.request({
                    url: banksListViewModel.updateTranslationUrl,
                    method: "POST",
                    data: ko.toJSON({ __type: self.__type, Id: self.Id, Source: self.activeSource, Target: self.activeTarget })
                }, function () {
                    console.log("done");
                });

                self.originalSource = self.activeSource();
                self.originalTarget = self.activeTarget();
                self.editDialogVisible(false);
            };

            self.cancelEditDialog = function () {
                self.activeSource(self.originalSource);
                self.activeTarget(self.originalTarget);
                self.editDialogVisible(false);
            };

            self.fillSourceFromAutocomplete = function (event, ui) {
                self.fillFromAutocomplete(banksListViewModel.sourceOptionsRaw, self.activeSource, ui.item.value);
            };

            self.fillTargetFromAutocomplete = function (event, ui) {
                self.fillFromAutocomplete(banksListViewModel.targetOptionsRaw, self.activeTarget, ui.item.value);
            };

            self.fillFromAutocomplete = function (source, target, selected) {
                for (index in source) {
                    if (source[index].Spelling == selected) {
                        target(new WordModel(source[index]));
                        break;
                    }
                }
            };
        }
        
        function WordModel(wordData) {
            var self = this;

            self.__type = wordData.__type;
            self.Id = wordData.Id;
            self.Language = new LanguageModel(wordData.Language);
            self.Spelling = ko.observable(wordData.Spelling);
            self.Transcription = ko.observable(wordData.Transcription);
        }
        
        function LanguageModel(languageData) {
            var self = this;

            self.__type = languageData.__type;
            self.Id = languageData.Id;
            self.Name = languageData.Name;
            self.Abbreviation = languageData.Abbreviation;
        }

        var banksListViewModel = new BanksListModel();

        ko.computed(function () {
            $.ajax({
                url: banksListViewModel.getBanksListUrl,
                dataType: 'jsonp',
                jsonpCallback: "BanksList",
                success: function (data) {
                    var vocabularies = eval(data);
                    for (index in vocabularies) {
                        banksListViewModel.vocabularies.push(new BankDetailsModel(vocabularies[index]));
                    }
                    banksListViewModel.displayDetails(banksListViewModel.vocabularies()[0]);
                    banksListViewModel.showLoading(false);
                },
                error: function (data, textStatus, errorThrown) {
                    console.log(data);
                    console.log(textStatus);
                    console.log(errorThrown);
                }

            });
        }, banksListViewModel);

        ko.computed(function () {
            function getWords(searchString, successCallback, jsonpCallbackName) {
                if (searchString != "") {
                    $.ajax({
                        url: banksListViewModel.getWordsUrl + "/" + searchString,
                        dataType: 'jsonp',
                        jsonpCallback: jsonpCallbackName,
                        success: successCallback,
                        error: function (data, textStatus, errorThrown) {
                            console.log(data);
                            console.log(textStatus);
                            console.log(errorThrown);
                        }
                    });
                }
            }

            getWords(
                banksListViewModel.sourceSearchString(),
                function (wordsData) {
                    banksListViewModel.sourceOptions.removeAll();
                    banksListViewModel.sourceOptionsRaw = wordsData;
                    for (index in wordsData) {
                        banksListViewModel.sourceOptions().push(wordsData[index].Spelling);
                    }
                },
                "SourceWordsList");

            getWords(
                banksListViewModel.targetSearchString(),
                function(wordsData) {
                    banksListViewModel.targetOptions.removeAll();
                    banksListViewModel.targetOptionsRaw = wordsData;
                    for (index in wordsData) {
                        banksListViewModel.targetOptions().push(wordsData[index].Spelling);
                    }
                },
                "TargetWordsList");
        }, banksListViewModel);
        ko.applyBindings(banksListViewModel);
    </script>
</asp:Content>