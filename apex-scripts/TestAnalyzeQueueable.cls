AnalyzeCaseQueueable q = new AnalyzeCaseQueueable([select Id, CaseNumber from Case limit 1]);
System.enqueueJob(q);