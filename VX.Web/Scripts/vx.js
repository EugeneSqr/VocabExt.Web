var vx = {};

vx.banksSummary = "GetVocabBanksSummary";
vx.getTranslations = "GetTranslations";
vx.saveTranslation = "SaveTranslation";
vx.detachTranslation = "DetachTranslation";
vx.getWords = "GetWords";
vx.updateBankSummary = "UpdateBankSummary";
vx.createVocabBank = "CreateVocabBank";
vx.deleteVocabBank = "DeleteVocabularyBank";

vx.initialize = function(serviceHost) {
    vx.serviceHost = serviceHost;
};

vx.BuildGetBanksSummaryUrl = function () {
    return vx.serviceHost + '/' + vx.banksSummary;
};

vx.BuildGetTranslationsUrl = function(vocabBankId) {
    return vx.serviceHost + '/' + vx.getTranslations + '/' + vocabBankId;
};

vx.BuildSaveTranslationUrl = function() {
    return vx.serviceHost + '/' + vx.saveTranslation;
};

vx.BuildDetachTranslationUrl = function() {
    return vx.serviceHost + '/' + vx.detachTranslation;
};

vx.BuildGetWordsUrl = function(searchString) {
    return vx.serviceHost + '/' + vx.getWords + '/' + searchString;
};

vx.BuildUpdateBankSummaryUrl = function() {
    return vx.serviceHost + '/' + vx.updateBankSummary;
};

vx.BuildCreateVocabBankUrl = function() {
    return vx.serviceHost + '/' + vx.createVocabBank;
};

vx.DeleteVocabularyBankUrl = function(vocabBankId) {
    return vx.serviceHost + '/' + vx.deleteVocabBank + '/' + vocabBankId;
};