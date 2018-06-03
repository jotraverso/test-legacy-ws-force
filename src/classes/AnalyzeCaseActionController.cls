public with sharing class AnalyzeCaseActionController {
	public AnalyzeCaseActionController() {

	}

	@AuraEnabled
	public static String analyzeCase(String caseId) {
		update new Case(Id = caseId, Phase__c = 'Analyze');
		return 'Analysis Started';
	}
}