public with sharing class SampleExcelDemo {
public List<Account> accountList{get;set;}
public List<Contact> contactList{get;set;}
public String xlsHeader {
        get {
            String strHeader = '';
            strHeader += '<?xml version="1.0"?>';
            strHeader += '<?mso-application progid="Excel.Sheet"?>';
            return strHeader;
        }
    }
 
public SampleExcelDemo(){
    accountList = [select id, name from Account LIMIT 50];
    contactList = [Select id, name, account.name, email from Contact LIMIT 50];
 
}
 
public Pagereference exportAll(){
    return new Pagereference('/apex/exportAll');
 
 
}
 
}