<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Banks
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<h1>Banks</h1>
<div id="leftPanel">
    <div align="center" data-bind="visible: showLoading">
        <img style="background: transparent; border: 0px" src="/Content/Images/loader.gif" alt="loading" />
    </div>
    <div data-bind="slideVisible : showContent">
        <div class="controlButtonsWrapper">
            <button class="control-button" data-bind="button: { 
                                        text: true, 
                                        label: 'Delete',
                                        icons: { primary: 'ui-icon-trash' }
                                    }, click: deleteBank">
            </button>
            <button class="control-button" data-bind="button: { 
                                        text: true, 
                                        label: 'Create',
                                        icons: { primary: 'ui-icon-circle-plus' }
                                    }, click: createNewBank">
            </button>
        </div>
        <div data-bind="foreach: { data: vocabularies }">
            <div class="banksList" data-bind="text: bankName, click: $parent.displayDetails">
            </div>
        </div>
    </div>
</div>
<div data-bind="with: activeBank">
    <div id="rightPanel">
        <div class="controlButtonsWrapper">
            <button class="control-button" data-bind="button: { 
                                        text: true, 
                                        label: 'Add translation',
                                        icons: { primary: 'ui-icon-plus' }
                                    }, click: attachTranslation"></button>
            <button class="control-button" data-bind="button: { 
                                        text: true, 
                                        label: 'Apply changes',
                                        icons: { primary: 'ui-icon-check' }
                                    }, click: updateHeaders"></button>
        </div>
        <label for="bankName">Name:</label>
        <input id="bankName" class="bankDetails" type="text" data-bind="value: bankName"/>

        <label for="description">Description:</label>
        <textarea id="description" cols="200" rows="3" data-bind="value: bankDescription" ></textarea>
        <label>Translations:</label>
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
                    source: $parent.sourceOptions(), 
                    select: fillTranslationSourceFromAutocomplete,
                    minLength: 2
                },
                searchString: $parent.sourceSearchString"/>
                                    
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
                        source: $parent.targetOptions(), 
                        select: fillTranslationTargetFromAutocomplete,
                        minLength: 2
                    },
                    searchString: $parent.targetSearchString"/>
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
                        <td width="72">
                            <button class="imageonly-button" data-bind="button: {
                                    text: true, 
                                    label: '&nbsp;',
                                    icons: { primary: 'ui-icon-gear' }
                                },
                                click: openEditDialog"></button>
                            
                            <button class="imageonly-button" data-bind="button: { 
                                    text: true, 
                                    label: '&nbsp;',
                                    icons: { primary: 'ui-icon-trash' }
                                }, 
                                click: openDeleteDialog"></button>
                        </td>
                    </tr>
                </tbody>
            </table>    
        </div>
    </div>
</div>
<div class="clear"></div>
<script type="text/javascript">
(function () {
    vx.initialize('<%:ViewData["VocabExtServiceRest"]%>');
    function banksListModel() {
        var self = this;

        self.showLoading = ko.observable(true);
        self.showContent = ko.computed(function () {
            return !self.showLoading();
        });
        
        self.vocabularies = ko.observableArray();
        self.activeBank = ko.observable();
        self.vocabServiceHost = '<%:ViewData["VocabExtServiceHost"] %>' + '/Infrastructure/easyXDM/cors/index.html';
        self.headersBeforeUpdate = {};

        self.sourceOptions = ko.observableArray();
        self.sourceOptionsRaw = [];
        self.targetOptions = ko.observableArray();
        self.targetOptionsRaw = [];

        self.sourceSearchString = ko.observable("");
        self.targetSearchString = ko.observable("");

        self.checkId = function (entity) {
            return (typeof entity != 'undefined' && entity.hasOwnProperty("id") && entity.id > 0);
        };

        self.displayDetails = function (detailsViewModel) {
            if (self.checkId(detailsViewModel)) {
                self.activeBank(detailsViewModel);
                $.ajax({
                    url: vx.BuildGetTranslationsUrl(detailsViewModel.id),
                    dataType: 'jsonp',
                    success: function (translationsData) {
                        var translations = eval(translationsData);
                        detailsViewModel.translations.removeAll();
                        for (index in translations) {
                            detailsViewModel.translations.push(new translationModel(translations[index], detailsViewModel));
                        }

                        detailsViewModel.translationsShown(true);
                    },
                    error: function () {
                        detailsViewModel.translationsShown(true);
                    }
                });
            }
        };

        self.createNewBank = function () {
            $.ajax({
                url: vx.BuildCreateVocabBankUrl(),
                dataType: 'jsonp',
                success: function (vocabBankData) {
                    var newVocabBank = new bankDetailsModel(vocabBankData);
                    self.vocabularies.push(newVocabBank);
                    self.displayDetails(newVocabBank);
                },
                error: function () {
                    console.log('error creating new bank');
                }
            });
        };

        self.deleteBank = function () {
            $.ajax({
                url: vx.DeleteVocabularyBankUrl(self.activeBank().id),
                dataType: 'jsonp',
                success: function (response) {
                    if (response.Status) {
                        self.vocabularies.remove(function (item) {
                            return item.id == response.StatusMessage;
                        });
                        if (self.vocabularies().length > 0) {
                            self.displayDetails(self.vocabularies()[0]);
                        } else {
                            self.displayDetails({});
                        }
                    } else {
                        console.log("error creating new bank, reason: " + response.errorMessage);
                    }

                },
                error: function () {
                    console.log('error creating new bank');
                }
            }); ;
        };
    }

    function bankDetailsModel(bankData) {
        var self = this;

        self.id = bankData.Id;
        self.bankName = ko.observable(bankData.Name);
        self.bankDescription = bankData.Description;
        self.translationsShown = ko.observable(false);
        self.translations = ko.observableArray();

        self.loadingShown = ko.computed(function () {
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
            self.setActiveTranslation(new translationModel(null, self));
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
                url: vx.BuildSaveTranslationUrl(),
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
                    if (responseData.OperationActionCode == 0) {
                        self.commitSelections();
                    }
                    if (responseData.OperationActionCode == 1) {
                        self.translations.push(self.activeTranslation());
                    }

                } else {
                    self.rollbackSelections();
                    console.log("update failed, reason: " + responseData.ErrorMessage);
                }

                self.saveTranslationDialogVisible(false);
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
                url: vx.BuildDetachTranslationUrl(),
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
        self.updateHeaders = function () {
            self.oldHeaders = {
                Name: self.bankName,
                Description: self.bankDescription
            };
            var xhr = new easyXDM.Rpc({
                remote: banksListViewModel.vocabServiceHost
            }, {
                remote: {
                    request: {}
                }
            });

            xhr.request({
                url: vx.BuildUpdateBankSummaryUrl(),
                method: "POST",
                data: ko.toJSON({
                    VocabBankId: self.id,
                    Name: self.bankName,
                    Description: self.bankDescription
                })
            }, function (response) {
                var responseData = JSON.parse(response.data);
                if (!responseData.Status) {
                    self.bankName = self.oldHeaders.Name;
                    self.bankDescription = self.oldHeaders.Description;
                    console.log("update failed, reason: " + data.errorMessage);
                }
            });
        };

        // Common
        self.setActiveTranslation = function (translation) {
            self.activeTranslation(translation);
        };
    }

    function translationModel(translationData, detailsViewModel) {
        var self = this;
        self.parent = detailsViewModel;

        if (translationData) {
            self.Id = translationData.Id;
            self.originalSource = new WordModel(translationData.Source);
            self.originalTarget = new WordModel(translationData.Target);
        } else {
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

    var banksListViewModel = new banksListModel();

    ko.computed(function () {
        $.ajax({
            url: vx.BuildGetBanksSummaryUrl(),
            dataType: 'jsonp',
            success: function (data) {
                var vocabularies = eval(data);
                for (index in vocabularies) {
                    banksListViewModel.vocabularies.push(new bankDetailsModel(vocabularies[index]));
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
        function getWords(searchString, successCallback) {
            if (searchString != "") {
                $.ajax({
                    url: vx.BuildGetWordsUrl(searchString),
                    dataType: 'jsonp',
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
            });

        getWords(
            banksListViewModel.targetSearchString(),
            function (wordsData) {
                banksListViewModel.targetOptions.removeAll();
                banksListViewModel.targetOptionsRaw = wordsData;
                for (index in wordsData) {
                    banksListViewModel.targetOptions().push(wordsData[index].Spelling);
                }
            });
    }, banksListViewModel);
    ko.applyBindings(banksListViewModel);
} ());
</script>
</asp:Content>