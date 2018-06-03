public with sharing class ValidationsCaseInvocable {

	public class ValidationsCaseRequest {
		@InvocableVariable(label = 'Case to Validate')
		public Case c;
		@InvocableVariable(label = 'Async job?')
		public Boolean async = false;
	}

	@InvocableMethod(label = 'Validate Case' description = 'Validate Case')
	public static List<String> validateCase (List<ValidationsCaseRequest> requests) {
		List<string> results = new List<string>();
		Map<Case, String> resultsMap = new Map<Case, String>();
		for (ValidationsCaseRequest req : requests) {
			if (req.async) {
				ValidationsCaseQueueable q = new ValidationsCaseQueueable(req.c);
				System.enqueueJob(q);
				resultsMap.put(req.c, 'Validations Job Queued');
			} else {
				ValidationsCaseQueueable q = new ValidationsCaseQueueable(req.c);
				q.executeJob(null);
				resultsMap.put(req.c, q.result);
			}
		}
		for (ValidationsCaseRequest req : requests) {
			results.add(resultsMap.get(req.c));
		}
		return results;
	}

}