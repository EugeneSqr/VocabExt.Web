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
                        <td data-bind="text: source" />
                        <td data-bind="text: target" />
                        <td><input type="button" data-bind="click: $parent.editTranslation" value="Edit"/></td>
                        <td><input type="button" value="Delete"/></td>
                    </tr>
                </tbody>
            </table>
        </div>
        
        <div id="dialog" title="Dialog Title" data-bind="text: bankName">
            <div data-bind="text: source"></div>
		    <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
        </div>
    
    <div class="clear"></div>
    <script type="text/javascript">
        window.$editTranslationDialog = $('#dialog');
        window.$editTranslationDialog.dialog({
            autoOpen: false,
            width: 600,
            buttons: {
                "Ok": function () {
                    $(this).dialog("close");
                },
                "Cancel": function () {
                    $(this).dialog("close");
                }
            }
        });
        
        function BanksListModel() {
            var self = this;

            self.showLoading = ko.observable(true);
            self.showContent = ko.computed(function() {
                return !self.showLoading();
            });
            
            self.vocabularies = ko.observableArray();
            self.activeBank = ko.observable();
            self.getBanksListUrl = '<%:ViewData["VocabExtServiceRest"] %>' + 'GetVocabBanksList';
            self.getTranslationsUrl = '<%:ViewData["VocabExtServiceRest"] %>' + 'GetTranslations';

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
            self.activeTranslation = ko.observable(self.translations[0]);
            
            self.loadingShown = ko.computed(function() {
                return !self.translationsShown();
            });

            self.editTranslation = function (translation) {
                self.activeTranslation(translation);
                window.$editTranslationDialog.dialog('open');
            };
        }
        
        function TranslationModel(translationData) {
            var self = this;
            
            self.id = translationData.id;
            self.source = new WordModel(translationData.Source);
            self.target = new WordModel(translationData.Target);
        }
        
        function WordModel(wordData) {
            var self = this;
            
            self.id = wordData.id;
            self.spelling = ko.observable(wordData.Spelling);
            self.transcription = ko.observable(wordData.Transcription);
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
        ko.applyBindings(banksListViewModel);
    </script>
</asp:Content>