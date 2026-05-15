global class AccContactResponse {

    public class AccountWrapper{
        private String Id{get;set;}
        private String name{get;set;}
        private String email{get;set;}
        private String phone{get;set;}
        private List<ContactWrapper> contacts{get;set;}
    }
    
    public class ContactWrapper{
        private String Id{get;set;}
        private String firstName{get;set;}
        private String lastName{get;set;}
    }
    
    public static AccountWrapper prepareResponse(List<Account> accLst){
        AccountWrapper wrapper = new AccountWrapper();
        List<ContactWrapper> contactsLst = new List<ContactWrapper>();
        for(Account acc : accLst){
            wrapper.Id = acc.Id;
            wrapper.name = acc.Name;
            wrapper.email = acc.Site;
            wrapper.phone = acc.Phone;
            for(Contact c : acc.Contacts){
                ContactWrapper newContact = new ContactWrapper();
                newContact.Id = c.Id;
                newContact.firstName = c.FirstName;
                newcontact.lastName = c.LastName;
                contactsLst.add(newContact);
            }
            wrapper.contacts = contactsLst;
        }
        return wrapper;
    }
}