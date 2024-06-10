@isTest
public class AccountTriggerTest {
    @isTest
    public static void createOppToPartnerAccountTest(){
        List<Account> listAcc = createAccounts(100, 'Parceiro');
        Test.startTest();
        insert listAcc;
        Test.stopTest();

        List<Opportunity> listOpp = [SELECT Id FROM Opportunity WHERE AccountId IN: listAcc];
        System.assertEquals(50, listOpp.size());
    }

    @isTest
    public static void createTasktoConsumidorFinalTest(){
        List<Account> listAcc = createAccounts(100, 'Consumidor Final');
        Test.startTest();
        insert listAcc;
        Test.stopTest();

        List<Task> listTask = [SELECT Id FROM Task WHERE WhatId IN: listAcc];
        System.assertEquals(50, listTask.size());
    }

    @isTest
    public static void validateErrorCPF(){
        List<Account> listAcc = createAccounts(10, 'CPF');
        Test.startTest();
        Database.SaveResult[] dr = Database.insert(listAcc, false);
        Test.stopTest();


        List<Database.Error> dbErrorsList = new List<Database.Error>();
        for(Database.SaveResult sr : dr){
            dbErrorsList.addAll(sr.getErrors());
        }
        

        System.assertEquals(dbErrorsList.size(), 5);
        for(Database.Error error : dbErrorsList){
            System.assert(error.getMessage().contains('Número do cliente é inválido'));
        }
        
    }

    @isTest
    public static void validateErrorCPFToUpdt(){
        List<Account> listAcc = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
            
            Account acc = new Account();
            acc.Name = 'Conta ' + i;
            acc.Type = 'CPF';
            acc.AccountNumber = '2222222222' + i;
            
            listAcc.add(acc);
            
        }

        insert listAcc;

        for(Account acc : listAcc){
            acc.AccountNumber = '11111111111';
        }

        Test.startTest();
        Database.SaveResult[] dr = Database.update(listAcc, false);
        Test.stopTest();


        List<Database.Error> dbErrorsList = new List<Database.Error>();
        for(Database.SaveResult sr : dr){
            dbErrorsList.addAll(sr.getErrors());
        }
        

        System.assertEquals(dbErrorsList.size(), 10);
        for(Database.Error error : dbErrorsList){
            System.assert(error.getMessage().contains('Número do cliente é inválido'));
        }
        
    }

    @isTest
    public static void validateErrorCPFToUpdt2(){
        List<Account> listAcc = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
            
            Account acc = new Account();
            acc.Name = 'Conta ' + i;
            acc.Type = 'CPF';
            acc.AccountNumber = '11111111111111';
            
            listAcc.add(acc);
            
        }

        insert listAcc;

        for(Account acc : listAcc){
            acc.Type = 'CNPJ';
        }

        Test.startTest();
        Database.SaveResult[] dr = Database.update(listAcc, false);
        Test.stopTest();


        List<Database.Error> dbErrorsList = new List<Database.Error>();
        for(Database.SaveResult sr : dr){
            dbErrorsList.addAll(sr.getErrors());
        }
        

        System.assertEquals(dbErrorsList.size(), 10);
        for(Database.Error error : dbErrorsList){
            System.assert(error.getMessage().contains('Número do cliente é inválido'));
        }
        
    }

    @isTest
    public static void validateErrorCNPJ(){
        List<Account> listAcc = createAccounts(10, 'CNPJ');
        System.debug('Teste Rápido --> ' + listAcc.size());
        for(Account acc : listAcc){
            System.debug(acc.AccountNumber);
        }
        Test.startTest();
        Database.SaveResult[] dr = Database.insert(listAcc, false);
        Test.stopTest();


        List<Database.Error> dbErrorsList = new List<Database.Error>();
        for(Database.SaveResult sr : dr){
            dbErrorsList.addAll(sr.getErrors());
        }
        

        System.assertEquals(dbErrorsList.size(), 5);
        for(Database.Error error : dbErrorsList){
            System.assert(error.getMessage().contains('Número do cliente é inválido'));
        }
        
    }

    @isTest
    public static void validateErrorCNPJToUpdt(){
        List<Account> listAcc = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
            
            Account acc = new Account();
            acc.Name = 'Conta ' + i;
            acc.Type = 'CNPJ';
            acc.AccountNumber = '2222222222' + i;
            
            listAcc.add(acc);
            
        }

        insert listAcc;

        for(Account acc : listAcc){
            acc.AccountNumber = '11111111111111';
        }

        Test.startTest();
        Database.SaveResult[] dr = Database.update(listAcc, false);
        Test.stopTest();


        List<Database.Error> dbErrorsList = new List<Database.Error>();
        for(Database.SaveResult sr : dr){
            dbErrorsList.addAll(sr.getErrors());
        }
        

        System.assertEquals(dbErrorsList.size(), 10);
        for(Database.Error error : dbErrorsList){
            System.assert(error.getMessage().contains('Número do cliente é inválido'));
        }
        
    }

    @isTest
    public static void validateErrorCNPJToUpdt2(){
        List<Account> listAcc = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
            
            Account acc = new Account();
            acc.Name = 'Conta ' + i;
            acc.Type = 'CNPJ';
            acc.AccountNumber = '11111111111';
            
            listAcc.add(acc);
            
        }

        insert listAcc;

        for(Account acc : listAcc){
            acc.Type = 'CPF';
        }

        Test.startTest();
        Database.SaveResult[] dr = Database.update(listAcc, false);
        Test.stopTest();


        List<Database.Error> dbErrorsList = new List<Database.Error>();
        for(Database.SaveResult sr : dr){
            dbErrorsList.addAll(sr.getErrors());
        }
        

        System.assertEquals(dbErrorsList.size(), 10);
        for(Database.Error error : dbErrorsList){
            System.assert(error.getMessage().contains('Número do cliente é inválido'));
        }
        
    }

    private static List<Account> createAccounts(Integer n, String type){
        List<Account> listAcc = new List<Account>();
        for (Integer i = 0; i < n; i++) {
            
            Account acc = new Account();
            acc.Name = 'Conta ' + i;

            if(type == 'Parceiro'){
                if(Math.MOD(i, 2) == 0){
                    acc.Type = 'Parceiro';
                }
            }

            if(type == 'Consumidor Final'){
                if(Math.MOD(i, 2) == 0){
                    acc.Type = 'Consumidor Final';
                }
            }

            if(type == 'CPF'){
                acc.type = 'CPF'; 
                if(Math.MOD(i, 2) == 0){
                    acc.AccountNumber = '11111111111';
                }else{
                    acc.AccountNumber = '2222222222' + i;
                }
            }

            if(type == 'CNPJ'){
                acc.Type = 'CNPJ';
                if(Math.MOD(i, 2) == 0){
                    acc.AccountNumber = '11111111111111';
                }else{
                    acc.AccountNumber = '22222222222222' + i;
                }
            }


            listAcc.add(acc);
            
        }
        
        return listAcc;
    }
}