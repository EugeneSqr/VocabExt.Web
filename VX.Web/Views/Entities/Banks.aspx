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
                <div class="banksList" data-bind="text: Name, click: $parent.DisplayDetails"></div>
            </div>
        </div>
    </div>
    <div id="rightPanel" data-bind="with: activeBank">
        Name: <br/>
        <input class="bankDetails" type="text" data-bind="value: Name"/><br/>
        Description: <br/>
        <textarea cols="200" rows="3" data-bind="value: Description" ></textarea><br/>
        Translations: <br/>
        <div data-bind="visible: LoadingShown" align="center">
            <img style="background: transparent; border: 0px" src="/Content/Images/loader.gif" alt="loading"/>
        </div>
        <div data-bind="slideVisible : TranslationsShown">
            <table>
                <tbody data-bind="foreach: Translations">
                    <tr data-bind="css: { odd: (index % 2 == 1), even: (index % 2 == 0) }">
                        <td data-bind="text: Source" />
                        <td data-bind="text: Target" />
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
    <div class="clear"></div>
    <script type="text/javascript">
        function BanksListViewModel() {
            var self = this;

            self.showLoading = ko.observable(true);
            self.showContent = ko.computed(function() {
                return !self.showLoading();
            });
            
            self.vocabularies = ko.observableArray();

            self.activeBank = ko.observable();
            self.getBanksListUrl = '<%:ViewData["VocabExtServiceRest"] %>' + 'GetVocabBanksList';
            self.getTranslationsUrl = '<%:ViewData["VocabExtServiceRest"] %>' + 'GetTranslations';

            self.DisplayDetails = function (bankDetailsModel) {
                self.activeBank(bankDetailsModel);
                $.ajax({
                    url: self.getTranslationsUrl + '/' + bankDetailsModel.id,
                    dataType: 'jsonp',
                    jsonpCallback: "Translations",
                    success: function (translationsData) {
                        var translations = eval(translationsData);
                        bankDetailsModel.Translations.removeAll();
                        console.log(translationsData);
                        for (index in translations) {
                            bankDetailsModel.Translations.push({
                                Source: translations[index].Source.Spelling,
                                Target: translations[index].Target.Spelling
                            });
                        }

                        bankDetailsModel.TranslationsShown(true);
                    },
                    error: function () {
                        bankDetailsModel.TranslationsShown(true);
                    }
                });
            };
        }

        function BankDetailsModel(data) {
            var self = this;

            self.id = -1;
            self.Name = "";
            self.Description = "";
            self.TranslationsShown = ko.observable(false);
            self.LoadingShown = ko.computed(function() {
                return !self.TranslationsShown(); 
            });
            self.Translations = ko.observableArray();

            if (data != undefined && data != null) {
                self.id = data.Id;
                self.Name = data.Name;
                self.Description = data.Description;
            }
        }

        var listViewModel = new BanksListViewModel();

        ko.computed(function () {
            $.ajax({
                url: listViewModel.getBanksListUrl,
                dataType: 'jsonp',
                jsonpCallback: "BanksList",
                success: function (data) {
                    var vocabularies = eval(data);
                    for (index in vocabularies) {
                        listViewModel.vocabularies.push(new BankDetailsModel(vocabularies[index]));
                    }
                    listViewModel.DisplayDetails(listViewModel.vocabularies()[0]);
                    listViewModel.showLoading(false);
                },
                error: function (data, textStatus, errorThrown) {
                    console.log(data);
                    console.log(textStatus);
                    console.log(errorThrown);
                }

            });
        }, listViewModel);
        ko.applyBindings(listViewModel);
    </script>
</asp:Content>
