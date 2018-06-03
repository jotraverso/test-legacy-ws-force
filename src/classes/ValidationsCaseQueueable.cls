public with sharing class ValidationsCaseQueueable extends AbstractQueueable {
	private Case c;
	public transient String result;

	public ValidationsCaseQueueable(Case c) {
		this.c = c;
	}
	public override void executeJob(System.QueueableContext context) {
		try {
			c = [SELECT Id, CaseNumber, ContactId, AccountId, AssetId, ParentId, SuppliedName, SuppliedEmail,
			     SuppliedPhone, SuppliedCompany, Type, Status, Reason, Origin, Subject, Priority,
			     Description, IsClosed, ClosedDate, IsEscalated, OwnerId, ContactPhone, ContactMobile,
			     ContactEmail, ContactFax, LastViewedDate, LastReferencedDate, EngineeringReqNumber__c,
			     SLAViolation__c, Product__c, PotentialLiability__c, Phase__c
			     FROM Case where Id = :c.Id];
			LegacyValidations.LegacyPortType validationService = new LegacyValidations.LegacyPortType();
			result = validationService.LegacyValidations(c.Id, JSON.serialize(c));
			Case_Phase__c ph = new Case_Phase__c(Case__c = c.Id,
			                                     Phase__c = c.Phase__c,
			                                     Result__c = result.abbreviate(Schema.SObjectType.Case_Phase__c.fields.Result__c.getLength()),
			                                     Full_Result__c = result.abbreviate(Schema.SObjectType.Case_Phase__c.fields.Full_Result__c.getLength())
			                                    );
			insert ph;
			update new Case(Id = c.Id, Phase__c = 'Calculations');
		} catch (CalloutException ex) {
			System.debug(ex.getStackTraceString());
			throw new ValidationsCaseException(ex.getMessage());
		}
	}

	public class ValidationsCaseException extends Exception {

	}
}