global class CalculationsCaseWS {
	
	global class CalculationsCaseResut {
		webservice String analyzeResult { get; set; }
		webservice String caseId {get; set;}
		webservice Boolean error {get; set;}
		webservice String returnCode {get; set;}
		webservice String errorMessage {get; set;}
	}

	public CalculationsCaseWS() {
		
	}

	webservice static String caseCalculationsResult(CalculationsCaseResut result) {
		System.debug(JSON.serialize(result));
		Case c = [SELECT Id, CaseNumber, ContactId, AccountId, AssetId, ParentId, SuppliedName, SuppliedEmail, SuppliedPhone, SuppliedCompany, Type, Status, Reason, Origin, Subject, Priority, Description, IsClosed, ClosedDate, IsEscalated, OwnerId, LastViewedDate, LastReferencedDate, EngineeringReqNumber__c, SLAViolation__c, Product__c, PotentialLiability__c, Phase__c FROM Case where Id = :result.caseId];
		Case_Phase__c ph = new Case_Phase__c(Case__c = c.Id,
		                                     Phase__c = c.Phase__c,
		                                     Status__c = !result.error ? 'Valid' : 'Error',
		                                     Result__c = result.analyzeResult.abbreviate(Schema.SObjectType.Case_Phase__c.fields.Result__c.getLength()),
		                                     Full_Result__c = result.analyzeResult.abbreviate(Schema.SObjectType.Case_Phase__c.fields.Full_Result__c.getLength())
		                                    );
		insert ph;
		if (ph.Status__c == 'Valid') {
			update new Case(Id = c.Id, Phase__c = 'SaveResults');
		}
		return 'done';
	}
}