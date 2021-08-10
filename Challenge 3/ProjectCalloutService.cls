public class ProjectCalloutService {
    
    public static final string token_name = 'ProjectServiceToken';
    
    @InvocableMethod
    //Complete the implementation for business and callout logic
    
	public static void postOpportunityToPMS(List<Id> opportunityIds){
        
        if(opportunityIds.size() > 0){
            System.enqueueJob(new QueueablePMSCall(opportunityIds));
        }
    } 
    
    public class QueueablePMSCall implements Queueable{
    
        List<Id> oppIdsToProcess;
    
        public QueueablePMSCall(List<Id> oppIds){
            oppIdsToProcess = oppIds;
        }
    
        public void execute(QueueableContext context){
            collectDataAndCallOut(oppIdsToProcess);
        }
    }
    
        static void collectDataAndCallOut(List<Id> opportunityIds){
    
            List<Opportunity> oppToProcess = [SELECT id, name, account.name, CloseDate, Amount
                                                FROM Opportunity
                                                WHERE id IN :opportunityIds];
            
            if(oppToProcess.size() > 0){
                makeCallOut(oppToProcess[0], ServiceTokens__c.getInstance(token_name).Token__c);
            }                                            
        }
    
    static void makeCallOut(Opportunity opp, string projectServiceToken){
        
        HttpRequest request = new HttpRequest();
        
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('token', projectServiceToken);
        request.setEndpoint('callout:ProjectService');
        request.setBody(JSON.serialize(new callOutRequestBody(opp)));

        HttpResponse response = new Http().send(request);

        if(response.getStatusCode() == 201){
            opp.StageName = 'Submitted Project';
        } else if(response.getStatusCode() == 500){
            opp.StageName = 'Resubmit Project';
        }
        update opp;
    }

    public class callOutRequestBody{

        string OpportunityId;
        string OpportunityName;
        string AccountName;
        string CloseDate;
        decimal Amount;

        public callOutRequestBody(Opportunity opp){

            this.OpportunityId = opp.Id;
            this.OpportunityName = opp.Name;
            this.AccountName = opp.Account.Name;
            this.CloseDate = String.valueOf(opp.CloseDate);
            this.Amount = opp.Amount;
        }
    }

}