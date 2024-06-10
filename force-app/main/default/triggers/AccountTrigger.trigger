trigger AccountTrigger on Account (before insert, before update, after insert, after update) {
    if(Trigger.isInsert){
        if(Trigger.isBefore){
            validaCpfCnpj(Trigger.new, null);
        }
        if(Trigger.isAfter){
            createOppToPartnerAccount(Trigger.new);
            createTasktoConsumidorFinal(Trigger.new);
        }
    }

    if(Trigger.isUpdate){
        if(Trigger.isBefore){
            validaCpfCnpj(Trigger.new, Trigger.oldMap);
        }
    }

    private void createTasktoConsumidorFinal(List<Account> listAcc){
        List<Task> listTask = new List<Task>();
        for(Account acc : listAcc){
            if(acc.Type == 'Consumidor final'){
                Task task = new Task();
                task.Subject = 'Consumidor Final';
                task.WhatId = acc.Id;
                task.Status = 'Not Started';
                task.Priority = 'Normal';

                listTask.add(task);
            }
        }


        if(!listTask.isEmpty()){
            insert listTask;
        }
    }

    private void createOppToPartnerAccount(List<Account> listAcc){

        List<Opportunity> listOpp = new List<Opportunity>();
        for(Account acc : listAcc){
            if(acc.Type == 'Parceiro'){
                Opportunity opp = new Opportunity();
                opp.Name = acc.Name + ' - opp Parceiro';
                opp.AccountId = acc.Id;
                opp.CloseDate = System.today().addDays(30);
                opp.StageName = 'Qualification';

                listOpp.add(opp);
            }
        }

        if(!listOpp.isEmpty()){
            insert listOpp;
        }
    }

    private void validaCpfCnpj(List<Account> newListAcc, Map<Id, Account> oldMapAcc){
        List<Account> listAccCpf = new List<Account>();
        List<Account> listAccCnpj = new List<Account>();

        if(oldMapAcc == null){
            for(Account acc : newListAcc){
                if(acc.Type == 'CPF'){
                    listAccCpf.add(acc);
                }
    
                if(acc.Type == 'CNPJ'){
                    listAccCnpj.add(acc);
                }
            }
        }else{
            for(Account acc : newListAcc){
                Account oldAcc = oldMapAcc.get(acc.Id);
                if(acc.Type == 'CPF' && 
                (acc.AccountNumber != oldAcc.AccountNumber ||
                 acc.Type != oldAcc.Type)){
                    listAccCpf.add(acc);
                }
    
                if(acc.Type == 'CNPJ' && 
                (acc.AccountNumber != oldAcc.AccountNumber ||
                 acc.Type != oldAcc.Type)){
                    listAccCnpj.add(acc);
                }
            }
        }

        if(!listAccCpf.isEmpty()){
            for(Account acc : listAccCpf){
                if(!Utils.validaCpf(acc.AccountNumber)){
                    acc.AccountNumber.addError('Número do cliente é inválido');
                }
            }
        }

        if(!listAccCnpj.isEmpty()){
            for(Account acc : listAccCnpj){
                if(!Utils.validaCnpj(acc.AccountNumber)){
                    acc.AccountNumber.addError('Número do cliente é inválido');
                }
            }
        }
    }

        
}