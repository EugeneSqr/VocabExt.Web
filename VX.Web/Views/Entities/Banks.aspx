﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

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
    <div data-bind="with: activeBank">
        <div id="controlPanel">
        <button class="banksControlButton" data-bind="button: { 
                                    text: true, 
                                    label: 'Create bank',
                                    icons: { primary: 'ui-icon-circle-plus' }
                                }"/>
        <button class="banksControlButton" data-bind="button: { 
                                    text: true, 
                                    label: 'Delete bank',
                                    icons: { primary: 'ui-icon-trash' }
                                }"/>
        <button class="banksControlButton" data-bind="button: { 
                                    text: true, 
                                    label: 'Add translation',
                                    icons: { primary: 'ui-icon-plus' }
                                }, click: attachTranslation"/>
        <button class="banksControlButton" data-bind="button: { 
                                    text: true, 
                                    label: 'Apply changes',
                                    icons: { primary: 'ui-icon-check' }
                                }, click: updateHeaders"/>
    </div>
        <div id="rightPanel">
        Name: <br/>
        <input class="bankDetails" type="text" data-bind="value: bankName"/><br/>
        Description: <br/>
        <textarea cols="200" rows="3" data-bind="value: bankDescription" ></textarea><br/>
        Translations: <br/>
        <div data-bind="visible: loadingShown" align="center">
            <img style="background: transparent; border: 0px" src="/Content/Images/loader.gif" alt="loading"/>
        </div>
        <div data-bind="editTranslationDialog: { autoOpen: false, draggable: false, resizable: false, modal: true, width: 480, height: 285,
                title: 'Edit', closeOnEscape: false,
                buttons: { 
                    'Save': submitEditDialog, 
                    'Cancel': cancelEditDialog
                },
                activeTranslation: activeTranslation
            }, 
            visible: saveTranslationDialogVisible">
                                
	        <div class="dialog-left-column">
	                                
	            <div>Specify source:</div>
                <input class="dialog-text-input" data-bind="autocomplete: { 
                        source: banksListViewModel.sourceOptions(), 
                        select: fillTranslationSourceFromAutocomplete,
                        minLength: 2
                    },
                    value: banksListViewModel.sourceSearchString"/>
                                    
                <div>Active source:</div>
                <div class="dialog-group">
                    <div data-bind="with: activeTranslation">
                        <div>Spelling</div>
                        <input data-bind="value: activeSource().Spelling" class="dialog-text-input" type="text" disabled="disabled"></input>
                        <div>Transcription</div>
                        <input data-bind="value: activeSource().Transcription" class="dialog-text-input" type="text" disabled="disabled"></input>
                    </div>
                </div>
            </div>

            <div class="dialog-middle-column"></div>
                                
            <div class="dialog-right-column">
                <div>Specify target:</div>
                <input class="dialog-text-input" data-bind="autocomplete: { 
                        source: banksListViewModel.targetOptions(), 
                        select: fillTranslationTargetFromAutocomplete,
                        minLength: 2
                    },
                    value: banksListViewModel.targetSearchString"/>
                <div>Active target:</div>
                <div class="dialog-group">
                    <div data-bind="with: activeTranslation">
                        <div>Spelling</div>
                        <input data-bind="value: activeTarget().Spelling" type="text" class="dialog-text-input" disabled="disabled"></input>
                        <div>Transcription</div>
                        <input data-bind="value: activeTarget().Transcription" type="text" class="dialog-text-input" disabled="disabled"></input>
                    </div>
                </div>
            </div>
            
            <div data-bind="confirmationDialog: { confirm: confirmTranslationDelete, abort: abortTranslationDelete }, 
                visible: deleteConfirmationDialogVisible">
                Are you sure you want to delete this translation?
            </div>
        </div>
        <div data-bind="slideVisible : translationsShown">
            <table>
                <tbody data-bind="foreach: translations">
                    <tr data-bind="css: { odd: (index % 2 == 1), even: (index % 2 == 0) }">
                        <td data-bind="text: activeSource().Spelling" />
                        <td data-bind="text: activeTarget().Spelling" />
                        <td width="65">
                            <button class="translation-button" data-bind="button: {
                                    text: true, 
                                    label: '&nbsp;',
                                    icons: { primary: 'ui-icon-gear' }
                                },
                                click: openEditDialog" />
                            
                            <button class="translation-button" data-bind="button: { 
                                    text: true, 
                                    label: '&nbsp;',
                                    icons: { primary: 'ui-icon-trash' }
                                }, 
                                click: openDeleteDialog"/>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
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
            self.saveTranslationUrl = '<%:ViewData["VocabExtServiceRest"]%>' + 'SaveTranslation';
            self.detachTranslationUrl = '<%:ViewData["VocabExtServiceRest"] %>' + 'DetachTranslation';
            self.getWordsUrl = '<%:ViewData["VocabExtServiceRest"]%>' + 'GetWords';
            self.updateHeaders = '<%:ViewData["VocabExtServiceRest"]%>' + 'UpdateBankHeaders';
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
                            bankDetailsModel.translations.push(new TranslationModel(translations[index], bankDetailsModel));
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

            // Save translation
            self.saveTranslationDialogVisible = ko.observable(false);
            self.activeTranslation = ko.observable();

            self.editTranslation = function (translation) {
                self.setActiveTranslation(translation);
                self.saveTranslationDialogVisible(true);
            };

            self.attachTranslation = function () {
                self.setActiveTranslation(new TranslationModel(null, self));
                self.saveTranslationDialogVisible(true);
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
                    url: banksListViewModel.saveTranslationUrl,
                    method: "POST",
                    data: ko.toJSON({
                        VocabBankId: self.id,
                        Translation: {
                            Id: self.activeTranslation().Id,
                            Source: self.activeTranslation().activeSource,
                            Target: self.activeTranslation().activeTarget
                        }
                    })
                }, function (response) {
                    var responseData = JSON.parse(response.data);
                    if (responseData.Status) {
                        console.log(responseData);
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
                    }
                });
            };

            self.cancelEditDialog = function () {
                self.rollbackSelections();
                self.saveTranslationDialogVisible(false);
            };

            self.fillTranslationSourceFromAutocomplete = function (event, ui) {
                self.fillFromAutocomplete(
                    banksListViewModel.sourceOptionsRaw,
                    self.activeTranslation().activeSource, 
                    ui.item.value);
            };

            self.fillTranslationTargetFromAutocomplete = function (event, ui) {
                self.fillFromAutocomplete(
                    banksListViewModel.targetOptionsRaw,
                    self.activeTranslation().activeTarget, 
                    ui.item.value);
            };

            self.fillFromAutocomplete = function (source, target, selected) {
                for (index in source) {
                    if (source[index].Spelling == selected) {
                        target(new WordModel(source[index]));
                        break;
                    }
                }
            };

            self.commitSelections = function () {
                self.activeTranslation().originalSource = self.activeTranslation().activeSource();
                self.activeTranslation().originalTarget = self.activeTranslation().activeTarget();
            };

            self.rollbackSelections = function () {
                self.activeTranslation().activeSource(self.activeTranslation().originalSource);
                self.activeTranslation().activeTarget(self.activeTranslation().originalTarget);
                banksListViewModel.sourceSearchString("");
                banksListViewModel.targetSearchString("");
            };

            // Delete translation confirmation dialog
            self.deleteConfirmationDialogVisible = ko.observable(false);

            self.deleteTranslation = function (translation) {
                self.setActiveTranslation(translation);
                self.deleteConfirmationDialogVisible(true);
            };

            self.confirmTranslationDelete = function () {
                var xhr = new easyXDM.Rpc({
                    remote: banksListViewModel.vocabServiceHost
                }, {
                    remote: {
                        request: {}
                    }
                });

                xhr.request({
                    url: banksListViewModel.detachTranslationUrl,
                    method: "POST",
                    data: JSON.stringify({
                        parent: self.id,
                        child: self.activeTranslation().Id
                    })
                }, 
                function (response) {
                    if (JSON.parse(response.data).Status) {
                        self.translations.remove(function (item) {
                            return item.Id == self.activeTranslation().Id;
                        });
                    }
                });

                self.deleteConfirmationDialogVisible(false);
            };

            self.abortTranslationDelete = function () {
                self.deleteConfirmationDialogVisible(false);
            };

            // Update headers
            self.updateHeaders = function() {
                var xhr = new easyXDM.Rpc({
                    remote: banksListViewModel.vocabServiceHost
                }, {
                    remote: {
                        request: {}
                    }
                });

                xhr.request({
                    url: banksListViewModel.updateHeaders,
                    method: "POST",
                    data: ko.toJSON({
                        VocabBankId: self.id,
                        Name: self.bankName,
                        Description: self.bankDescription
                    })
                }, function (response) {
                    var responseData = JSON.parse(response.data);
                    if (responseData.Status) {
                        console.log(responseData);
                    } else {
                        self.rollbackSelections();
                        console.log("update failed, reason: " + data.errorMessage);
                    }
                });
            };

            // Common
            self.setActiveTranslation = function (translation) {
                self.activeTranslation(translation);
            };
        }
        
        function TranslationModel(translationData, bankDetailsModel) {
            var self = this;
            self.parent = bankDetailsModel;
            
            if (translationData) {
                /*self.__type = translationData.__type;*/
                self.Id = translationData.Id;
                self.originalSource = new WordModel(translationData.Source);
                self.originalTarget = new WordModel(translationData.Target);
            } else {
                /*self.__type = "TranslationContract:#VX.Domain.DataContracts";*/
                self.Id = -1;
                self.originalSource = new WordModel(null);
                self.originalTarget = new WordModel(null);
            }
            
            self.activeSource = ko.observable(self.originalSource);
            self.activeTarget = ko.observable(self.originalTarget);

            self.openEditDialog = function () {
                self.parent.editTranslation(self);
            };

            self.openDeleteDialog = function () {
                self.parent.deleteTranslation(self);
            };
        }
        
        function WordModel(wordData) {
            var self = this;

            if (wordData) {
                /*self.__type = wordData.__type;*/
                self.Id = wordData.Id;
                self.Language = new LanguageModel(wordData.Language);
                self.Spelling = ko.observable(wordData.Spelling);
                self.Transcription = ko.observable(wordData.Transcription);
            } else {
                /*self.__type = "WordContract:#VX.Domain.DataContracts";*/
                self.Id = -1;
                self.Spelling = ko.observable();
                self.Transcription = ko.observable();
            }
        }
        
        function LanguageModel(languageData) {
            var self = this;

            /*self.__type = languageData.__type;*/
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