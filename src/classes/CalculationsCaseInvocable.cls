public with sharing class CalculationsCaseInvocable {
	
		public class CalculationsCaseRequest {
			@InvocableVariable(label = 'Case to  calculate')
			public Case c;
			@InvocableVariable(label = 'Async job?')
			public Boolean async = false;
		}

		@InvocableMethod(label = 'Calculation Case' description = 'Calculation Case')
		public static List<String> calculationCase (List<CalculationsCaseRequest> requests) {
			List<string> results = new List<string>();
			Map<Case, String> resultsMap = new Map<Case, String>();
			for (CalculationsCaseRequest req : requests) {
				if (req.async) {
					CalculationsCaseQueueable q = new CalculationsCaseQueueable(req.c);
					System.enqueueJob(q);
					resultsMap.put(req.c, 'Calculations Job Queued');
				} else {
					CalculationsCaseQueueable q = new CalculationsCaseQueueable(req.c);
					q.executeJob(null);
					resultsMap.put(req.c, q.result);
				}
			}
			for (CalculationsCaseRequest req : requests) {
				results.add(resultsMap.get(req.c));
			}
			return results;
		}
}