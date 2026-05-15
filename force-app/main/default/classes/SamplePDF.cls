public with sharing class SamplePDF {
    public static void fetchBase64Image2(String response){
        Attachment attachment = new Attachment();
        attachment.ContentType = 'image/png';
        String name = System.now().format('ddMMyyyyHH:mm:ss');
        name = 'Test_'+ name.replaceAll(':', '');
        attachment.Name = name+'.jpeg';
        attachment.ParentId = '0013k00002uZtriAAC';
        attachment.Body = EncodingUtil.base64Decode(response);
        insert attachment;
        PageReference pageReference2 = new PageReference('/apex/SamplePDF?FileId='+attachment.Id);
        fetchContentDataFromPage(attachment.Id, name, pageReference2.getUrl(), '0013k00002uZtriAAC');
        //delete attachment;
    }
    
    @Future(Callout=true)
    public static void fetchContentDataFromPage(String attId, String name, String pageURL, String parentId){
        Attachment attachment = new Attachment();
        attachment.ContentType = 'application/pdf';
        attachment.Name = name+'.pdf';
        attachment.ParentId = parentId;
        attachment.Body = new PageReference(pageURL).getContent();
        insert attachment;
        delete [select Id from Attachment where id = :attId limit 1];
    }  
}