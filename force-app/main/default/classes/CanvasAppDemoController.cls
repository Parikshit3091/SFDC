public class CanvasAppDemoController {     

    public boolean displayPopup {get; set;}     
    public String accountId{get;set;}
    public Account accDetails{get;set;}
    public List<CountryMappingWrapper> countryMappingList{get;set;}
    
    public CanvasAppDemoController(){
        accountId = ApexPages.currentPage().getParameters().get('accId');
        accDetails = [select Id,Country__c from Account where id = :accountId];
        
        countryMappingList = new List<CountryMappingWrapper>();
        CountryMappingWrapper w1 = new CountryMappingWrapper();
        w1.isPrimary = true;
        w1.primarySector = 'India';
        countryMappingList.add(w1);
        
        CountryMappingWrapper w2 = new CountryMappingWrapper();
        w2.isPrimary = false;
        w2.primarySector = 'UK';
        countryMappingList.add(w2);
    }
    
    class CountryMappingWrapper{
        public Boolean isPrimary{get;set;}
        public String primarySector{get;set;}
    }
    
    public void closePopup() {        
        displayPopup = false;    
    }     
    public void showPopup() {        
        displayPopup = true;    
    }
    
    public void saveValues(){
        CountryMappingWrapper wrapper = new CountryMappingWrapper();
        wrapper.isPrimary = true;
        String newCounty = ApexPages.currentPage().getParameters().get('country');
        System.debug('newCounty ### ' + newCounty);
        wrapper.primarySector = newCounty;
        countryMappingList.add(wrapper);
    }
  }