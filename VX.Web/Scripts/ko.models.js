function WordModel(wordData) {
    var self = this;
    
    self.__type = "WordContract:#VX.Domain.Entities.Impl";
    if (wordData) {
        self.Id = wordData.Id;
        self.Language = ko.observable(new LanguageModel(wordData.Language));
        self.Spelling = ko.observable(wordData.Spelling);
        self.Transcription = ko.observable(wordData.Transcription);
    } else {
        self.Spelling = ko.observable();
        self.Transcription = ko.observable();
    }
}

function LanguageModel(languageData) {
    var self = this;

    self.__type = "LanguageContract:#VX.Domain.Entities.Impl";
    self.Id = languageData.Id;
    self.Name = languageData.Name;
    self.Abbreviation = languageData.Abbreviation;
}