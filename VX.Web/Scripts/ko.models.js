function WordModel(wordData) {
    var self = this;

    if (wordData) {
        self.Id = wordData.Id;
        self.Language = new LanguageModel(wordData.Language);
        self.Spelling = ko.observable(wordData.Spelling);
        self.Transcription = ko.observable(wordData.Transcription);
    } else {
        self.Id = -1;
        self.Spelling = ko.observable();
        self.Transcription = ko.observable();
    }
}

function LanguageModel(languageData) {
    var self = this;

    self.Id = languageData.Id;
    self.Name = languageData.Name;
    self.Abbreviation = languageData.Abbreviation;
}