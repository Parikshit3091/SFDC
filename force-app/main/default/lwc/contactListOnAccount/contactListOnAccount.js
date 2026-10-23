import { LightningElement, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import ACCOUNT_NAME_FIELD from '@salesforce/schema/Account.Name';
import getContactsList from '@salesforce/apex/AccountContactsList.getContactList';

export default class ContactListOnAccount extends LightningElement {
    recordId;

    @wire(CurrentPageReference)
    setCurrentPageReference(pageRef) {
        debugger;
        if (pageRef && pageRef.state) {
            this.recordId = pageRef.state.c__recordId;
        }
    }

    // Fetch the account name independently of the contacts list
    @wire(getRecord, { recordId: '$recordId', fields: [ACCOUNT_NAME_FIELD] })
    account;

    @wire(getContactsList, { accountId: '$recordId' })
    contactsList;

    get accountName() {
        return getFieldValue(this.account.data, ACCOUNT_NAME_FIELD);
    }

    get contacts() {
        debugger;
        return this.contactsList && this.contactsList.data ? this.contactsList.data : [];
    }
}