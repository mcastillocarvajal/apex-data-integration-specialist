
@isTest
private class BillingCalloutServiceTest {

    @TestSetup
    static void setup(){

        ServiceCredentials__c credential = new ServiceCredentials__c();
        credential.Name = BillingCalloutService.BILLING_SERVICE_CREDENTIAL_NAME;
        credential.Username__c = 'userTest';
        credential.Password__c = 'passTest';
        insert credential;

        Account acc = new Account(Name = 'accTest');
        insert acc; 

        Opportunity opp = new Opportunity();
        opp.AccountId = acc.Id;
        opp.Name = 'oppTest';
        opp.Type = 'newTest';
        opp.CloseDate = date.today();
        opp.StageName = 'Prospecting';
        opp.Amount  = 1000;
        insert opp;

        Project__c proj = new Project__c();
        proj.Name = 'projTest';
        proj.ProjectRef__c = 'fakeRef';
        proj.Billable_Amount__c  = 10000;
        proj.Status__c = 'Running';
        proj.Opportunity__c = opp.Id;
        insert proj;
    }

    @isTest
    static void BillingCalloutFailure() {

        List<Project__c> projs = [SELECT id FROM Project__c WHERE name = 'projTest'];

        for(Project__c proj : projs){
            proj.Status__c = 'Running';
        }
        
        test.startTest();

        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure());
        update projs;

        test.stopTest();

        projs = [SELECT id FROM Project__c WHERE name = 'projTest'];
        System.assertEquals('Running', projs[0].Status__c);
    }

    @isTest
    static void BillingCalloutSuccess() {

        List<Project__c> projs = [SELECT id FROM Project__c WHERE name = 'projTest'];

        for(Project__c proj : projs){
            proj.Status__c = 'Billable';
        }
        
        test.startTest();

        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure());
        update projs;

        test.stopTest();

        projs = [SELECT id FROM Project__c WHERE name = 'projTest'];
        System.assertEquals('Billed', projs[0].Status__c);
    }
}
