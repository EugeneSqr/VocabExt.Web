﻿<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Vocabulary banks list
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1>These are your <span class="white">vocabulary banks</span></h1>
    <div id="loading" align="center" data-bind="slideVisible : showLoading">
        <img style="background: transparent; border: 0px" src="/Content/Images/loader.gif" alt="loading"/>
    </div>
    <div id="dynamicContent" data-bind="slideVisible : showContent">
        <table>
            <thead><tr>
                <th>Used</th>
                <th>Name</th>
                <th>Descriprion</th>
            </tr></thead>
            <tbody data-bind="foreach: vocabularies">
                <tr data-bind="css: { odd: (index % 2 == 1), even: (index % 2 == 0) }">
                    <td><input type="checkbox" data-bind="checked: isUsed, click: sendUpdateRequest"/> </td>
                    <td style="cursor: pointer" data-bind="click: showTranslations"><span data-bind= "text: Name"/></td>
                    <td data-bind = "text: Description"></td>
                </tr>
                <tr data-bind="visible: translationsShown, css: { odd: (index % 2 == 1), even: (index % 2 == 0) }">
                    <td colspan="3">
                        <table class="borderless">
                            <tbody data-bind="template: { foreach: translations, 
                                                            afterAdd: showTranslation }">
                                <tr>
                                    <td data-Bind="text: SourceSpelling"></td>
                                    <td data-Bind="text: SourceTranscription"></td>
                                    <td data-Bind="text: TargetSpelling"></td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>

    <script type="text/javascript">
        function ListItemViewModel(data) {
            var self = this;

            self.translationsShown = ko.observable(false);

            self.translations = ko.observableArray();

            self.isUsed = ko.observable(false);

            self.Id = ko.observable(data.Id);

            ko.computed(function () {
                self.isUsed(listViewModel.subscribedVocabularies().indexOf(this.Id()) != -1);
            }, self);

            self.sendUpdateRequest = function() {
                if (self.isUsed()) {
                    if (listViewModel.subscribedVocabularies().indexOf(this.Id()) == -1) {
                        listViewModel.subscribedVocabularies.push(this.Id());   
                    }
                } else {
                    listViewModel.subscribedVocabularies.remove(this.Id());
                }
                
                $.ajax({
                    type: 'POST',
                    url: listViewModel.postBanksUrl,
                    data: JSON.stringify(listViewModel.subscribedVocabularies())
                });
                return true;
            };
            
            self.showTranslations = function () {
                if (!self.translationsShown()) {
                    $.ajax({
                        url: listViewModel.getTranslationsUrl + '/' + self.Id(),
                        dataType: 'jsonp',
                        jsonpCallback: "Translations",
                        success: function (translationsData) {
                            var translations = eval(translationsData);
                            self.translations.removeAll();
                            for (index in translations) {
                                self.translations.push({
                                    SourceSpelling: translations[index].Source.Spelling,
                                    SourceTranscription: translations[index].Source.Transcription,
                                    TargetSpelling: translations[index].Target.Spelling,
                                    TargetTranscription: translations[index].Target.Transcription
                                });
                            }

                            self.translationsShown(true);
                        },
                        error: function () {
                            self.translationsShown(true);
                        }
                    });
                } else {
                    self.translations.removeAll();
                    self.translationsShown(false);
                }
            };

            self.showTranslation = function(elem) {
                if (elem.nodeType === 1) $(elem).hide().fadeIn('slow');
            };

            ko.mapping.fromJS(data, {}, self);
        }

        function ListViewModel() {
            var self = this;

            self.showLoading = ko.observable(true);
            self.showContent = ko.computed(function() {
                return !self.showLoading();
            });

            self.vocabExtServiceRestUrl = '<%:ViewData["VocabExtServiceRest"] %>';
            self.vocabularies = ko.observableArray();
            self.subscribedVocabularies = ko.observableArray(eval(<%:ViewData["SubscribedVocabularies"] %>));
            self.getTranslationsUrl = self.vocabExtServiceRestUrl  + 'GetTranslations';
            self.getBanksListUrl = self.vocabExtServiceRestUrl + 'GetVocabBanksList';
            self.postBanksUrl = '<%:ViewData["MembershipServiceRest"] %>' + 'PostVocabBanks';
        }
        
        var listViewModel = new ListViewModel();

        ko.computed(function () {
            $.ajax({
                url: listViewModel.getBanksListUrl,
                dataType: 'jsonp',
                jsonpCallback: "BanksList",
                success: function (data) {
                    var vocabularies = eval(data);
                    for (index in vocabularies) {
                        listViewModel.vocabularies.push(new ListItemViewModel(vocabularies[index]));
                    }
                    listViewModel.showLoading(false);
                },
                error: function(data, textStatus, errorThrown) {
                    console.log(data);
                    console.log(textStatus);
                    console.log(errorThrown);
                }
                
            });
        }, listViewModel);
        ko.applyBindings(listViewModel);
    </script>
</asp:Content>
