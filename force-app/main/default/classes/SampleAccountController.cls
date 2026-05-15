public class SampleAccountController {

    public List<ContactWrapper> contactWrapper{get;set;}
    public Boolean oncomplete{get;set;}
    
    public SampleAccountController()
    {
        oncomplete = true;
        contactWrapper = new List<ContactWrapper>();
    	List<Contact> contactLst = [select Id,Name,Account.Name,MobilePhone,Email from Contact limit 2];
        Map<Id, List<Contact>> newMap = new Map<Id, List<Contact>>();
        for(Contact c1 : contactLst)
        {
            if(newMap.get(c1.AccountId) == null){
                List<contact> cont = new List<Contact>();
                cont.add(c1);
                newMap.put(c1.AccountId, cont);
            }else{
                List<Contact> cont = newMap.get(c1.AccountId);
                cont.add(c1);
                newMap.put(c1.AccountId, cont);
            }
        }
        
        if(newMap != null)
        {
            for(Id i : newMap.keyset())
            {
                ContactWrapper wrapper = new ContactWrapper();
                wrapper.contactLst = newMap.get(i);
                wrapper.count = newMap.get(i).size();
                wrapper.accName = newMap.get(i)[0].Account.Name;
                contactWrapper.add(wrapper);
            }
        }
        System.debug('contactWrapper ### ' + contactWrapper);
    }
    
    class ContactWrapper
    {
        public List<Contact> contactLst{get;set;}
        public Integer count{get;set;}
        public String accName{get;set;}
    }
    
    public void accountSave(){
        System.debug('line 46');
        oncomplete = false;
        PageReference pRef = Page.SampleAccount;
        Blob pgeBlob = pRef.getContent();
        String blobStr = pgeBlob.toString();
        //blobStr = blobStr.substringBetween('}(window.UITheme == window.UITheme || {}))','function dpf(f)');
        List<Messaging.EmailFileAttachment> attLst = new List<Messaging.EmailFileAttachment>();
        
        Map<String, String> strMap = new Map<String, String>();
        strMap.put('csv', 'application/vnd.ms-excel');
        strMap.put('docx', 'application/msword');
        strMap.put('txt', 'application/text');
        strMap.put('pdf', 'application/pdf');
        strMap.put('jpeg', 'application/jpeg');
        strMap.put('jpg', 'application/jpg');
        
        List<ContentVersion> cvLst = [select Id,Title,VersionData,FileExtension,FileType from ContentVersion where ContentDocumentId in ('0693k00000CB9jG','0693k00000CB9j6','0693k00000CB9ih','0693k00000CB9iI')];
        for(ContentVersion cv : cvLst){
            System.debug('cv fileExtension ### ' + cv.FileExtension);
            Messaging.EmailFileAttachment att = new Messaging.EmailFileAttachment();
            att.setFileName(cv.Title + '.' + cv.FileExtension);
            att.setBody(cv.VersionData);
            //att.setContentType(strMap.get(cv.FileExtension));
            attLst.add(att);
        }
        
        List<Messaging.SingleEmailMessage> mailLst = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new List<String>{'pvkoparkar@gmail.com'});
        mail.setSubject('Test Email');
        mail.setHtmlBody(blobStr);
        mail.setFileAttachments(attLst);
        mailLst.add(mail);
        
        Messaging.sendEmail(mailLst);
    }
}