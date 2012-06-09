<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Banks
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1>Banks</h1>
    <div id="leftPanel">
        <div id="loading" align="center" data-bind="slideVisible : showLoading">
            <img style="background: transparent; border: 0px" src="/Content/Images/loader.gif" alt="loading"/>
        </div>
        <div id="dynamicContent" data-bind="slideVisible : showContent">
            <div data-bind="foreach: vocabularies">
                <div data-bind="text: Name"></div>
            </div>
        </div>
    </div>
    <div id="rightPanel">
        This is right panel
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
            self.getBanksListUrl = '<%:ViewData["VocabExtServiceRest"] %>' + 'GetVocabBanksList';

        }

        function BankDetailsModel(data) {
            var self = this;

            self.Name = data.Name;
            self.Description = self.Description;
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
