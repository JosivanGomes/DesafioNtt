global class BatchAccDeletation implements Database.Batchable<sObject>, Schedulable{
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        return Database.getQueryLocator('SELECT Id FROM Account where Inativa__c = true');
    }
    global void execute(Database.BatchableContext bc, List<Account> scope){
        delete scope;
    }

    global void finish(Database.BatchableContext bc){}

    global void execute(SchedulableContext sc){
        BatchAccDeletation bdd = new BatchAccDeletation();
        Id BatchId = Database.executeBatch(bdd, 500);
    }


}