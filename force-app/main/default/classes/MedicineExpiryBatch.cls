public class MedicineExpiryBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        // Query for medicines that are set to expire within the next seven days
        Date currentDate = Date.today();
        Date sevenDaysFromNow = currentDate.addDays(7);
        String query = 'SELECT Name, Quantity__c, ExpirationDate__c FROM MedicineInventory__c ' +
                       'WHERE ExpirationDate__c >= :currentDate AND ExpirationDate__c <= :sevenDaysFromNow';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<MedicineInventory__c> scope) {
        List<String> csvLines = new List<String>();
        
        for (MedicineInventory__c med : scope) {
            // Create a CSV line for each expiring medicine
            String csvLine = med.Name + ',' + String.valueOf(med.Quantity__c) + ',' + String.valueOf(med.ExpirationDate__c);
            csvLines.add(csvLine);
        }
        
        // Generate the CSV content
        String csvContent = 'Medicine Name,Quantity,Expiration Date\n' + String.join(csvLines, '\n');
        
        // Send the CSV content to the pharmacy manager's email address
        sendEmailToPharmacyManager(csvContent);
    }

    public void finish(Database.BatchableContext BC) {
        // Batch processing completed
    }

    // Helper method to send email
    private void sendEmailToPharmacyManager(String csvContent) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[]{'pharmacy.manager@example.com'});
        email.setSubject('Expiring Medicines Report');
        email.setPlainTextBody('Please find the attached report for expiring medicines within the next seven days.');
        
        // Create a blob from the CSV content and attach it to the email
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName('Expiring_Medicines_Report.csv');
        attachment.setBody(Blob.valueOf(csvContent));
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{attachment});
        
        // Send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
    }
}