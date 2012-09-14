function WordModel(wordData) {
    var self = this;
    
    self.__type = "WordContract:#VX.Domain.Entities.Impl";
    if (wordData) {
        self.Id = wordData.Id;
        self.Language = new LanguageModel(wordData.Language);
        self.Spelling = wordData.Spelling;
        self.Transcription = wordData.Transcription;
    } else {
        self.Spelling = "";
        self.Transcription = "";
    }
}

function LanguageModel(languageData) {
    var self = this;

    self.__type = "LanguageContract:#VX.Domain.Entities.Impl";
    self.Id = languageData.Id;
    self.Name = languageData.Name;
    self.Abbreviation = languageData.Abbreviation;
}

function TranslationModel(translationData) {
    var self = this;

    self.__type = "TranslationContract:#VX.Domain.Entities.Impl";
    if (translationData) {
        self.Id = translationData.Id;
        self.Source = new WordModel(translationData.Source);
        self.Target = new WordModel(translationData.Target);
    } else {
        self.Source = new WordModel(null);
        self.Target = new WordModel(null);
    }
}