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
                        <td data-bind="text: activeSource" />
                        <td data-bind="text: activeTarget" />
                        <td>
                            <input type="button" data-bind="click: openEditDialog" value="Edit"/>
                            <div data-bind="dialog: {autoOpen: false, title: 'testing' }, dialogVisible: editDialogVisible">
                                
	                            <input id="tags" data-bind="autocomplete: {source: sourceOptions }"/>
                                
                                <div data-bind="with: activeSource">
                                    <div data-bind="text: spelling"></div>
                                    <div data-bind="text: transcription"></div>
                                </div>
                                <div data-bind="with: activeTarget">
                                    <div data-bind="text: spelling"></div>
                                    <div data-bind="text: transcription"></div>
                                </div>
                                <a href="#" data-bind="click: closeEditDialog">close</a>
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
            
            self.loadingShown = ko.computed(function() {
                return !self.translationsShown();
            });
        }
        
        function TranslationModel(translationData) {
            var self = this;
            
            self.id = translationData.id;
            self.activeSource = new WordModel(translationData.Source);
            self.activeTarget = new WordModel(translationData.Target);
            self.editDialogVisible = ko.observable(false);
            
            self.sourceSearchString = ko.observable(self.activeSource.spelling());
            self.targetSearchString = ko.observable(self.activeTarget.spelling());

            self.sourceOptions = ko.observableArray([
                    "ActionScript",
                    "AppleScript",
                    "Asp",
                    "BASIC",
                    "C",
                    "C++",
                    "Clojure",
                    "COBOL",
                    "ColdFusion",
                    "Erlang",
                    "Fortran",
                    "Groovy",
                    "Haskell",
                    "Java",
                    "JavaScript",
                    "Lisp",
                    "Perl",
                    "PHP",
                    "Python",
                    "Ruby",
                    "Scala",
                    "Scheme"]);

            self.openEditDialog = function() {
                self.editDialogVisible(true);
            };
            self.closeEditDialog = function() {
                self.editDialogVisible(false);
            };
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