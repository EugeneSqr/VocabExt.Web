<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Vocabulary banks list
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Vocabulary banks</h2>
    <table>
        <thead><tr>
            <th>Used</th>
            <th>Name</th>
            <th>Descriprion</th>
            <th>Tag</th>
            <th>Test</th>
        </tr></thead>
        <tbody data-bind="foreach: vocabularies">
            <tr>
                <td><input type="checkbox" data-bind="checked: isUsed, click: sendUpdateRequest"/> </td>
                <td><span data-bind= "text: Name"/></td>
                <td data-bind = "text: Description"></td>
                <td><div data-bind="click: showTranslations">Expand</div></td>
                <td><div data-bind="click: check">asdf</div></td>
            </tr>
            <tr>
                <td colspan="5">
                    <table>
                        <tbody data-bind="foreach: translations">
                            <tr>
                                <td data-Bind="text: Source"></td>
                            </tr>
                        </tbody>
                    </table>
                </td>
            </tr>
        </tbody>
    </table>

    <script type="text/javascript">
        function ListItemViewModel(data) {
            var self = this;

            self.translationsShown = ko.observable(true);

            self.translations = ko.observableArray();

            self.isUsed = ko.observable(false);

            self.Id = ko.observable(data.Id);

            ko.computed(function () {
                self.isUsed(listViewModel.subscribedVocabularies().indexOf(this.Id()) != -1);
            }, self);

            self.sendUpdateRequest = function() {
                console.log(this);
                listViewModel.subscribedVocabularies.remove(this.Id());
                return true;
            };

            self.check = function() {
                listViewModel.subscribedVocabularies.push(this.Id());
                $.ajax({
                    type: 'POST',
                    url: 'http://vx.com/AccountMembershipService.svc/restService/PostVocabBanks/1',
                    data: {name:"John"}
                });
            };

            self.showTranslations = function () {
                if (self.translationsShown()) {
                    $.ajax({
                        url: 'http://vx-service.com/VocabExtService.svc/restService/GetTranslations/' + self.Id(),
                        datatype: 'json',
                        success: function (translationsData) {
                            var translations = eval(translationsData);
                            self.translations.removeAll();
                            for (index in translations) {
                                self.translations.push({ Source: translations[index].Source.Spelling });
                            }

                            self.translationsShown(false);
                        },
                        error: function () {
                            self.translationsShown(false);
                        }
                    });
                } else {
                    self.translations.removeAll();
                    self.translationsShown(true);
                }
            };

            ko.mapping.fromJS(data, {}, self);
        }

        var listViewModel = {
            vocabularies: ko.observableArray(),
            subscribedVocabularies: ko.observableArray(eval(<%:ViewData["SubscribedVocabularies"] %>))
        };

        ko.computed(function () {
            $.ajax({
                url: 'http://vx-service.com/VocabExtService.svc/restService/GetVocabBanksList',
                dataType: 'json',
                success: function (data) {
                    var vocabularies = eval(data);
                    for (index in vocabularies) {
                        listViewModel.vocabularies.push(new ListItemViewModel(vocabularies[index]));
                    }
                }
            });
        }, listViewModel);
        
        ko.applyBindings(listViewModel);
    </script>
</asp:Content>