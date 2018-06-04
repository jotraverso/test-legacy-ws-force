public with sharing class SaveResultsInvocable {

	public class SaveResultsRequest {
		@InvocableVariable(label = 'Case the results will be saved for')
		public Case c;
		@InvocableVariable(label = 'Async job?')
		public Boolean async = false;
	}

	@InvocableMethod(label = 'Save Results for Case' description = 'Save Results for Case')
	public static List<string> saveResultsCase (List<SaveResultsRequest> requests) {
		List<string> results = new List<string>();
		Map<Case, String> resultsMap = new Map<Case, String>();
		for (SaveResultsRequest req : requests) {
			if (req.async) {
				SaveResultsQueueable q = new SaveResultsQueueable(req.c);
				System.enqueueJob(q);
				resultsMap.put(req.c, 'SaveResults Job Queued');
			} else {
				SaveResultsQueueable q = new SaveResultsQueueable(req.c);
				q.executeJob(null);
				resultsMap.put(req.c, q.result);
			}
		}
		for (SaveResultsRequest req : requests) {
			results.add(resultsMap.get(req.c));
		}
		return results;
	}
}