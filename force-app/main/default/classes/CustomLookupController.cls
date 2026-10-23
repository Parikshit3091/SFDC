public with sharing class CustomLookupController {
    @AuraEnabled(cacheable=true)
    public static List<SObject> getRecords(String searchKey, String objectApiName, String parentId) {
        if (String.isBlank(objectApiName)) {
            throw new AuraHandledException('An object API name is required.');
        }

        Schema.SObjectType objectType = Schema.getGlobalDescribe().get(objectApiName);
        if (objectType == null) {
            throw new AuraHandledException('The requested object is not available.');
        }

        Schema.DescribeSObjectResult objectDescribe = objectType.getDescribe();
        Schema.SObjectField nameField = objectDescribe.fields.getMap().get('Name');
        if (!objectDescribe.isAccessible()) {
            throw new AuraHandledException('You do not have access to search this object.');
        }
        if (nameField == null) {
            throw new AuraHandledException('The requested object cannot be searched by name.');
        }
        if (!nameField.getDescribe().isAccessible()) {
            throw new AuraHandledException('You do not have access to search this object.');
        }

        if (String.isBlank(searchKey)) {
            return new List<SObject>();
        }

        if (!String.isBlank(parentId)) {
            String parentFieldName = objectDescribe.getName() == 'Contact' ? 'AccountId' : null;
            if (parentFieldName != null) {
                String query =
                    'SELECT Id, Name FROM ' +
                    objectDescribe.getName() +
                    ' WHERE Name LIKE :searchPattern AND ' + parentFieldName + ' = :parentId ORDER BY Name LIMIT 10';
                String searchPattern = '%' + searchKey.trim() + '%';
                return Database.queryWithBinds(
                    query,
                    new Map<String, Object>{ 'searchPattern' => searchPattern, 'parentId' => parentId },
                    AccessLevel.USER_MODE
                );
            }
        }
        String query =
            'SELECT Id, Name FROM ' +
            objectDescribe.getName() +
            ' WHERE Name LIKE :searchPattern ORDER BY Name LIMIT 10';
        String searchPattern = '%' + searchKey.trim() + '%';
        return Database.queryWithBinds(
            query,
            new Map<String, Object>{ 'searchPattern' => searchPattern },
            AccessLevel.USER_MODE
        );
    }

    @AuraEnabled(cacheable=true)
    public static Account getAccountRecord(String recordId) {
        String query =
            'SELECT Id, Name, AccountNumber FROM Account WHERE Id = :recordId';
        return Database.queryWithBinds(
            query,
            new Map<String, Object>{ 'recordId' => recordId },
            AccessLevel.USER_MODE
        );
    }

    @AuraEnabled(cacheable=true)
    public static List<sObject> getRelatedRecords(String parentId, String objectApiName) {
        Schema.SObjectType objectType = Schema.getGlobalDescribe().get(objectApiName);
        Schema.DescribeSObjectResult objectDescribe = objectType.getDescribe();
        System.debug('Fetching related records for parent ID: ' + parentId);
        String query = '';
        List<String> stageList = new List<String>{'Closed Lost','Closed Won'};
        if(objectApiName == 'Contact'){
             query =
            'SELECT Id, Name, Phone FROM ' +
            objectDescribe.getName() +
            ' WHERE AccountId = :parentId ';
            System.debug('query #### ' + query);
        }else if(objectApiName == 'Opportunity'){
            query =
            'SELECT Id, Name FROM ' +
            objectDescribe.getName() +
            ' WHERE AccountId = :parentId AND stageName NOT IN :stageList';
            System.debug('query #### ' + query);
        }
        return Database.queryWithBinds(
            query, 
            new Map<String,Object> { 'parentId' => parentId, 'stageList' => stageList },
            AccessLevel.USER_MODE  
        );
    }

     @AuraEnabled(cacheable=true)
    public static Contact getContactRecord(String recordId) {
        String query =
            'SELECT Id, Name, Phone FROM Contact WHERE Id = :recordId';
        return Database.queryWithBinds(
            query,
            new Map<String, Object>{ 'recordId' => recordId },
            AccessLevel.USER_MODE
        );
    }

}