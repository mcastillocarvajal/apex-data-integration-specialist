# Synchronize Outbound Project Data

Business growth is growing fast! While this keeps the staff busy (which they love), it also means they haven’t had the time to implement their own management systems. At this point, they just want to implement a bare-bones integration from their Salesforce org to sync and track minimal project and billing information with Square Peg’s external systems.

When Round wins a new project opportunity, create a project record in the external PMS so the parent company can track the work:

When an existing opportunity’s type is a New Project and it’s stage is changed to Closed Won, make an outbound RESTful call. Then send a POST request to the service endpoint with a JSON packet containing the fields OpportunityId, OpportunityName, AccountName, CloseDate, and Amount.

Use the preconfigured ProjectService Named Credential previously defined.

Match the name and type of the fields based on the following sample JSON mapped to the Opportunity record.

## Sample POST JSON

{
  "opportunityId": "00641000004EKmFAAW",
  "opportunityName": "Super-Duper Big Deal",
  "accountName": "ACME Corp, Inc.",
  "closeDate": "2016-10-30",
  "amount": 150000
}

## Sample POST JSON

Create "Update Opportunity" Process
Round want’s you to use low-code solutions where possible—use Process Builder to create a new Update Opportunity process to call an Apex action (named Post Opportunity To PMS) to pass the Opportunity ID to the Apex logic that makes the callout.

Implement a method (named PostOpportunityToPMS) in an Apex class (named ProjectCalloutService), and invoke it from the process action. Ensure your method gets the necessary opportunity data and invokes an authenticated REST callout. We want to design for potential future enqueuing inside other asynchronous jobs, so implement asynchronous logic with queueable Apex in an inner class (named QueueablePMSCall) inside ProjectCalloutSevice to execute the callout logic.

In addition, include the Square Peg registration token you got during the registration process in the header of your service call with the key as "token"—this identifies your org.

If the call is successful, set the opportunity Stage to Submitted Project. However, if it’s not successful, set it to Resubmit Project, which lets a user reattempt the process.

To support these requirements, add New Project as an Opportunity Types value. Add the following values to opportunity Stage.

Stage Name	Probability	Type
Submitted Project	100	Closed/Won
Resubmit Project	100	Closed/Won

Note that this process is not designed to operate in bulk. It’s designed to only process the first ID passed even if activated on a bulk load of opportunities.

