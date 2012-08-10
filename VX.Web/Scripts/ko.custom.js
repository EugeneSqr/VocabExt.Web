ko.bindingHandlers.slideVisible = {
    init: function (element, valueAccessor) {
        var value = valueAccessor();
        $(element).toggle(ko.utils.unwrapObservable(value));
    },
    update: function (element, valueAccessor) {
        var value = valueAccessor();
        ko.utils.unwrapObservable(value) ? $(element).slideDown() : $(element).slideUp();
    }
};

ko.bindingHandlers.editTranslationDialog = {
    init: function (element, parameters) {
        var options = ko.utils.unwrapObservable(parameters()) || {};
        options.open = function () {
            $(this).parent().children().children('.ui-dialog-titlebar-close').hide();
        };
        var $element = $(element);
        $element.css({ overflow: 'hidden' });
        $element.dialog(options);
    },
    update: function (element, valueAccessor, allBindingsAccessor) {
        var visible = ko.utils.unwrapObservable(allBindingsAccessor().visible);
        $(element).dialog(visible ? "open" : "close");
    }
};

ko.bindingHandlers.confirmationDialog = {
    init: function (element, parameters) {
        var options = {
            open: function () { $(this).parent().children().children('.ui-dialog-titlebar-close').hide(); },
            title: 'Confirm action',
            closeOnEscape: false,
            resizable: false,
            draggable: false,
            modal : true,
            buttons: { "Yes": parameters().confirm, "No": parameters().abort }
        };
        $(element).dialog(options);
    },

    update: function (element, valueAccessor, allBindingsAccessor) {
        var visible = ko.utils.unwrapObservable(allBindingsAccessor().visible);
        $(element).dialog(visible ? "open" : "close");
    }
};

ko.bindingHandlers.autocomplete = {
    init: function (element, parameters, allBindingsAccessor) {
        var $element = $(element);
        var allBindings = allBindingsAccessor();
        var minLength = allBindings.autocomplete.minLength;
        $element.keyup(function () {
            var newValue = $element.val();
            if (newValue.length > minLength - 1) {
                var searchString = allBindings.searchString;
                if (newValue.substring(0, minLength) != searchString().substring(0, minLength)) {
                    searchString(newValue);
                }
            }
        });

        $element.autocomplete(parameters());
    },
    update: function (element, parameters) {
        $(element).autocomplete(parameters());
    }
};

ko.bindingHandlers.button = {
    update: function (element, parameters, allBindingsAccessor) {
        var $element = $(element);
        $element.button(ko.utils.unwrapObservable(parameters()) || {});
        $element.click = ko.utils.unwrapObservable(allBindingsAccessor().click);
    }
};