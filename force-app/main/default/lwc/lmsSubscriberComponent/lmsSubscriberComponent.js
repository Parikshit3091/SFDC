// subscriberComp.js
import { LightningElement, wire } from 'lwc';
// 1. Import message scope and utilities
import { subscribe, unsubscribe, APPLICATION_SCOPE, MessageContext } from 'lightning/messageService';
import RECORD_SELECT_CHANNEL from '@salesforce/messageChannel/sendMessageUtilityBar__c';

export default class LMSSubscriberComponent extends LightningElement {
    receivedId = 'No data received yet';
    receivedSource = '';
    subscription = null; // Keeps track of our active subscription token

    @wire(MessageContext)
    messageContext;

    // 2. Automatically listen to the channel as soon as the component enters the DOM
    connectedCallback() {
        this.subscribeToMessageChannel();
    }

    subscribeToMessageChannel() {
        if (!this.subscription) {
            // 3. Register the listener
            this.subscription = subscribe(
                this.messageContext,
                RECORD_SELECT_CHANNEL,
                (message) => this.handleMessage(message), // Callback function
                { scope: APPLICATION_SCOPE } // APPLICATION_SCOPE lets it listen across the entire page layout
            );
        }
    }

    // 4. Process the incoming payload data
    handleMessage(message) {
        this.receivedId = message.recordId;
        this.receivedSource = message.name;
        console.log('Received data from LMS:', this.receivedId);
    }

    // 5. Clean up the listener when the component is unmounted to prevent memory leaks
    disconnectedCallback() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }
}