import { LightningElement,wire } from 'lwc';
import getAccount from '@salesforce/apex/CustomLookupController.getAccountRecord';
import getContact from '@salesforce/apex/CustomLookupController.getContactRecord';

export default class SalesLeadForm extends LightningElement {

    section1 = true;
    section2 = false;
    section3 = false;

    firstSection = true;
    middleSection = false;
    lastSection = false;

    selectedAccount = null;
    selectedAccountID = '';
    selectedAccountName = '';

    selectedContact = null;
    selectedContactID = '';
    selectedContactName = '';

    formData = {

    }
    
    handleAccountChange(event){
        this.selectedAccountID = event.detail.recordId;
        this.selectedAccountName = event.detail.record.Name;
        if(this.selectedAccountID && this.selectedAccountName){
            getAccount({recordId : this.selectedAccountID})
            .then((result) => {
                if(result){
                this.selectedAccount = result;
                }
            })
            .catch((error) => {
                console.error('Error fetching account:', error);
            });
        }
    }

    get accName(){
        return this.selectedAccount?.Name ? this.selectedAccount?.Name : '';
    }

    get accNumber(){
        return this.selectedAccount?.AccountNumber ? this.selectedAccount?.AccountNumber : '';
    }

    handleNext(event){
        //If first screen then open section2 and prepopulate the value
        if(this.section1){
            this.section1 = false;
            this.section2 = true;
            this.section3 = false;
            this.firstSection = false;
            this.middleSection = true;
            this.lastSection = false;
        }
        else if(this.section2){
            this.section1 = false;
            this.section2 = false;
            this.section3 = true;
            this.firstSection = false;
            this.middleSection = false;
            this.lastSection = true;
        }
    }

    handleContactChange(event){
        this.selectedContactID = event.detail.recordId;
        this.selectedContactName = event.detail.record.Name;
        if(this.selectedContactID && this.selectedContactName){
            getContact({recordId : this.selectedContactID})
            .then((result) => {
                if(result){
                this.selectedContact = result;
                }
            })
            .catch((error) => {
                console.error('Error fetching contact:', error);
            });
        }
    }

    get phone(){
        return this.selectedContact?.Phone ? this.selectedContact?.Phone : '';
    }

    handleOpportunityChange(event){

    }
}