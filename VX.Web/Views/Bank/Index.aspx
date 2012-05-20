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
        </tr></thead>
        <tbody data-bind="foreach: vocabularies">
            <tr data-bind="click: showTranslations">
                <td><input type="checkbox"/> </td>
                <td data-bind= "text: Name"></td>
                <td data-bind = "text: Description"></td>
                <td></td>
            </tr>
            <tr>
                <td colspan="4">empty</td>
            </tr>
        </tbody>
    </table>

    <script type="text/javascript">
        /*var mapping = {
            vocabularies: {
                key: function (data) {
                    return ko.utils.unwrapObservable(data.Id);
                },
                create: function (options) {
                    return new ListItemViewModel(options.data);
                }
            }
        };*/

        function ListItemViewModel(data) {
            var self = this;

            self.showTranslations = function() {
                console.log(self.Name());
            };

            ko.mapping.fromJS(data, {}, self);
        }

        var listViewModel = {
            vocabularies: ko.observableArray()
        };

        ko.computed(function () {
            $.ajax({
                url: 'http://vx-service.com/VocabExtService.svc/restService/GetVocabBanksList',
                dataType: 'json',
                success: function (data) {
                    for (index in data) {
                        /*listViewModel.vocabularies.push(data[index]);*/
                        listViewModel.vocabularies.push(new ListItemViewModel(data[index]));
                    }
                }
            });
        }, listViewModel);
        ko.applyBindings(listViewModel);
    </script>
</asp:Content>