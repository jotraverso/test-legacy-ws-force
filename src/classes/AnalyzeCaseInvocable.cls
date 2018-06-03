public with sharing class AnalyzeCaseInvocable {

	public class AnalyzeCaseRequest {
		@InvocableVariable(label='Case to analyze')
		public Case c;
		@InvocableVariable(label='Async job?')
		public Boolean async = false;
	}

	@InvocableMethod(label = 'Analyze Case' description = 'Analyze Case')
	public static List<String> analyzeCase (List<AnalyzeCaseRequest> requests) {
		List<string> results = new List<string>();
		Map<Case, String> resultsMap = new Map<Case, String>();
		for (AnalyzeCaseRequest req : requests) {
			if(req.async) {
				AnalyzeCaseQueueable q = new AnalyzeCaseQueueable(req.c);
				System.enqueueJob(q);
				resultsMap.put(req.c, 'Analyze Job Queued');
			} else {
				AnalyzeCaseQueueable q = new AnalyzeCaseQueueable(req.c);
				q.executeJob(null);
				resultsMap.put(req.c, q.result);
			}
		}
		for (AnalyzeCaseRequest req : requests) {
			results.add(resultsMap.get(req.c));
		}
		return results;
	}


}