var vx = {};

vx.banksSummary = "GetVocabBanksSummary";
vx.getTranslations = "GetTranslations";
vx.saveTranslation = "SaveTranslation";
vx.detachTranslation = "DetachTranslation";
vx.getWords = "GetWords";
vx.saveWord = "SaveWord";
vx.validateWord = "ValidateWord";
vx.updateBankSummary = "UpdateBankSummary";
vx.createVocabBank = "CreateVocabularyBank";
vx.deleteVocabBank = "DeleteVocabularyBank";
vx.getLanguages = "GetLanguages";

vx.initialize = function (restBase, serviceHost) {
    vx.serviceHost = serviceHost;
    vx.restBase = restBase;
};

vx.BuildGetBanksSummaryUrl = function () {
    return vx.restBase + '/' + vx.banksSummary;
};

vx.BuildGetTranslationsUrl = function(vocabBankId) {
    return vx.restBase + '/' + vx.getTranslations + '/' + vocabBankId;
};

vx.BuildSaveTranslationUrl = function() {
    return vx.restBase + vx.saveTranslation;
};

vx.BuildDetachTranslationUrl = function() {
    return vx.restBase + '/' + vx.detachTranslation;
};

vx.BuildGetWordsUrl = function(searchString) {
    return vx.restBase + '/' + vx.getWords + '/' + searchString;
};

vx.BuildSaveWordUrl = function() {
    return vx.restBase + '/' + vx.saveWord;
};

vx.BuildValidateWordUrl = function() {
    return vx.restBase + '/' + vx.validateWord;
};

vx.BuildUpdateBankSummaryUrl = function() {
    return vx.restBase + '/' + vx.updateBankSummary;
};

vx.BuildCreateVocabBankUrl = function() {
    return vx.restBase + vx.createVocabBank;
};

vx.BuildDeleteVocabularyBankUrl = function(vocabBankId) {
    return vx.restBase + '/' + vx.deleteVocabBank + '/' + vocabBankId;
};

vx.BuildServiceHostUrl = function () {
    return vx.serviceHost + '/Infrastructure/easyXDM/cors/index.html';
};

vx.BuildGetLanguagesUrl = function () {
    return vx.restBase + '/' + vx.getLanguages;
};