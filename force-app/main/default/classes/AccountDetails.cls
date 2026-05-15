global class AccountDetails {

@AuraEnabled
    webservice  static void getAccDetails()
    {
        List<Account> accLst = [select ID from Account limit 10];
        //return accLst;
        //System.debug('accLst ### ' + accLst);
    }
}