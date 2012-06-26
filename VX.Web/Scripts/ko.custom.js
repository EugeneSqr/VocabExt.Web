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

ko.bindingHandlers.dialog = {
    init: function (element, valueAccessor, allBindingsAccessor) {
        var options = ko.utils.unwrapObservable(valueAccessor()) || {};
        options.close = function () {
            allBindingsAccessor().dialogVisible(false);
        };
        $(element).dialog(options);
    },
    update: function (element, valueAccessor, allBindingsAccessor) {
        var shouldBeOpen = ko.utils.unwrapObservable(allBindingsAccessor().dialogVisible);
        $(element).dialog(shouldBeOpen ? "open" : "close");
    }
};

ko.bindingHandlers.autocomplete = {
    init: function (element, parameters, allBindingsAccessor) {
        var $element = $(element);
        $element.keyup(function () {
            var newValue = $element.val();
            if (newValue.length > 1) {
                var searchString = allBindingsAccessor().searchString;
                console.log(searchString());
                if (newValue.substring(0, 2) != searchString().substring(0, 2)) {
                    searchString(newValue);
                }
            }
        });

        $element.autocomplete(parameters());
    },
    update: function (element, parameters) {
        $(element).autocomplete(parameters());
    }
}