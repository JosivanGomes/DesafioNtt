//Script atualização do campo DataUltimaTaskCriada__c em Acc

List<Account> accList = new List<Account>();

for(Account acc : [SELECT id, (select CreatedDate from Tasks
order by CreatedDate desc limit 1)
FROM Account]){
	for(Task tk: acc.Tasks)
    {
        acc.DataUltimaTaskCriada__c = tk.CreatedDate.date();
    }                      
    accList.add(acc);
}

update accList;