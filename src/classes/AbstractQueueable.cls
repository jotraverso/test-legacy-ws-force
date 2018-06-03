public abstract class AbstractQueueable implements Queueable, Database.AllowsCallouts {
	/**
	* Object names
	*/
	public static final List<String> SUPPORTED_OBJECTS = new List<String> {'Case', 'Account', 'Opportunity'};
	private QueueableMonitor__c qm;

	public AbstractQueueable() {
	}

	public virtual void execute(QueueableContext context) {
		try {
			executeJob(context);
			if (qm != null) {
				qm.Status__c = 'Success';
				update qm;
			}

		} catch (Exception ex) {
			String jsonJobString = JSON.serialize(this);
			String jobClass = String.valueOf(this).split(':')[0];
			String recordId = '';
			String objectName = '';
			String exMessage =  String.format('Exception: {0}: {1}',
			                                  new List<String> { ex.getTypeName(),
			                                          ex.getMessage()});
			String stackTrace = String.format('Exception: {0}\nMessage: {1}\nLine number:{2}\nStacktrace: {3}',
			                                  new List<String> { ex.getTypeName(),
			                                          ex.getMessage(),
			                                          '' + ex.getLineNumber(),
			                                          ex.getStackTraceString()
			                                                   } );
			List<Schema.DescribeSObjectResult> descResults = Schema.describeSObjects(SUPPORTED_OBJECTS);
			for (Schema.DescribeSObjectResult dr : descResults) {
				recordId = jsonJobString.replaceAll('.*\"(' + dr.getKeyPrefix() + '([a-zA-Z0-9]{12}|[a-zA-Z0-9]{15}))\".*', '$1');
				if (recordId.length() == 18 || recordId.length() == 15) {
					objectName = dr.getName();
					break;
				}
			}
			if (qm == null) {
				insert new QueueableMonitor__c(
				    JSON_Job__c = jsonJobString,
				    Job_Class__c = jobClass,
				    Job_Id__c = context.getJobId(),
				    ObjectName__c = objectName,
				    Record_Id__c = recordId,
				    Status__c = 'Failed',
				    ExceptionMessage__c = exMessage,
				    ExceptionStack__c = stackTrace);
			} else {
				update new QueueableMonitor__c(Id = qm.Id,
				                               Status__c = 'Failed',
				                               ExceptionMessage__c = exMessage,
				                               ExceptionStack__c = stackTrace);
			}
		}
	}

	public abstract void executeJob(QueueableContext context);

	@AuraEnabled
	public static String retryJob(String qmId) {
		System.debug('Retrying QueueableMonitor__c with Id: ' + qmId);
		QueueableMonitor__c qm = [select Id, JSON_Job__c, Job_Class__c from QueueableMonitor__c where Id = :qmId];
		System.debug('Deserializing for class: ' + qm.Job_Class__c + ':' + System.Type.forName(qm.Job_Class__c));
		AbstractQueueable qJob = (AbstractQueueable)JSON.deserialize(qm.JSON_Job__c, System.Type.forName(qm.Job_Class__c));
		qJob.qm = qm;
		System.enqueueJob(qJob);
		return qm.Job_Class__c + ' Job queued';
	}

}