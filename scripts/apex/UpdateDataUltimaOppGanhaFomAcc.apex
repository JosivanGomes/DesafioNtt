//Script atualização do campo DataUltimaOppGanha__c em Acc

List<Account> accList = new List<Account>();

for(Account acc : [SELECT Id, 
(SELECT CloseDate FROM Opportunities
 WHERE IsWON = true order by CloseDate desc limit 1)
From Account]){
	for(Opportunity opp: acc.Opportunities)
    {
        acc.DataUltimaOppGanha__c = opp.CloseDate;
    }                      
    accList.add(acc);
}

update accList;