import { LightningElement,wire } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import RECORD_SELECT_CHANNEL from '@salesforce/messageChannel/sendMessageUtilityBar__c';

export default class LmsPublisherComponent extends LightningElement {

    @wire(MessageContext)
    MessageContext

    handleButtonClick(){
        let payload = {
            recordId : '001KV000045qUPJYA2',
            name : 'Test Record Name From LMS'
        }

        publish(this.MessageContext, RECORD_SELECT_CHANNEL, payload);
    }
}