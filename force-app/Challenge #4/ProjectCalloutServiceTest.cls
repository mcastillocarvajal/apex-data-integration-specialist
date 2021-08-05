@isTest
private class ProjectCalloutServiceTest {
  //Implement mock callout tests here

  @TestSetup
  static void makeData(){
      
    ServiceTokens__c token = new ServiceTokens__c();
    token.name = ProjectCalloutService.token_name;
    token.Token__c = 'TestToken';
    insert token;

    Account acc = new Account(name = 'Test Account');
    insert acc;

    Opportunity opp = new Opportunity();
    opp.AccountId = acc.id;
    opp.Name = 'Test Opp';
    opp.Type = 'New Project';
    opp.CloseDate = date.today();
    opp.Amount = 1000;
    opp.StageName = 'Prospecting';
    insert opp;
  }

  @isTest
  static void testPMSFailure(){

    List<Opportunity> opps = [SELECT id FROM Opportunity WHERE name = 'Test Opp'];
    List<Id> oppsId = new List<Id>();
    
    for(Opportunity opp : opps){
        opp.StageName = 'Closed Won';
        oppsId.add(opp.Id);
    }

    update opps;

    test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());
    
    test.startTest(); 
    ProjectCalloutService.postOpportunityToPMS(oppsId);
    test.stopTest();

    List<Opportunity> testedOpps= [SELECT StageName FROM Opportunity WHERE name = 'Test Opp'];
    System.assertEquals('Resubmit Project', testedOpps[0].StageName);
  }

  @isTest
  static void testPMSSuccess(){

    List<Opportunity> opps = [SELECT id FROM Opportunity WHERE name = 'Test Opp'];
    List<Id> oppsId = new List<Id>();
    
    for(Opportunity opp : opps){
        opp.StageName = 'Closed Won';
        oppsId.add(opp.Id);
    }

    update opps;

    test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());

    test.startTest();
    ProjectCalloutService.postOpportunityToPMS(oppsId);
    test.stopTest();

    List<Opportunity> testedOpps= [SELECT StageName FROM Opportunity WHERE name = 'Test Opp'];
    System.assertEquals('Submitted Project', testedOpps[0].StageName);
  }
}