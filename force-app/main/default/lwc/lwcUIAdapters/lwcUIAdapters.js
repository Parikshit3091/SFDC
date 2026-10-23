import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi'
import ACCOUNT_NAME from '@salesforce/schema/Account.Name';
import INDUSTRY_FIELD from '@salesforce/schema/Account.Industry';
import ACC_ID from '@salesforce/schema/Account.Id';
import PHONE_FIELD from '@salesforce/schema/Account.Phone';
import {updateRecord} from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class LwcUIAdapters extends LightningElement {
    @api recordId;

    @wire(getRecord, {
        recordId: '$recordId',
        fields: [ACCOUNT_NAME, INDUSTRY_FIELD]
    })
    account;

    @wire(getPicklistValues, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId', 
        fieldApiName : INDUSTRY_FIELD
    })
    industryValues;
    
    get name() {
        return this.account?.data ? getFieldValue(this.account.data, ACCOUNT_NAME) : '';
    }

    get industry(){
        return this.industryValues;
    }

    handleSubmit(){

        const inputPhoneValue  = this.template.querySelector("lightning-input[data-name='accPhone']").value;
        let fields = {
            [ACC_ID.fieldApiName] : this.recordId,
            [PHONE_FIELD.fieldApiName] : inputPhoneValue
        }

        const recData = {fields};
        updateRecord(recData)
        .then(result => {
            debugger;
            console.log('saved successfully');
            this.showToast('Success', 'Account updated successfully!', 'success');
        })
        .catch(error =>{
 debugger;
            console.log('saved not successfully');
        })
    }

    showToast(title, msg, variant){
        this.dispatchEvent(
            new ShowToastEvent({title, msg, variant})
        )
    }
}