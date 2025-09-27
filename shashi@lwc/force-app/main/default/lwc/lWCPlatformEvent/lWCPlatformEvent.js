import { LightningElement, api, track } from 'lwc';
import { subscribe, unsubscribe, onError, setDebugFlag, isEmpEnabled } from 'lightning/empApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
 
export default class LWCPlatformEvent extends LightningElement {
    @track status;
    @track message;
    @track recordId;
 
    subscription = {};
    @api channelName = '/event/Order_Shipping_Tracking_Event__e';
 
    connectedCallback() {
        // Register error listener     
        this.registerErrorListener();
        this.handleSubscribe();
    }
 
    // Handles subscribe button click
    handleSubscribe() {
        // Callback invoked whenever a new event message is received
        const self = this;
        const messageCallback = function (response) {
            console.log('New message received 1: ', JSON.stringify(response));
            console.log('New message received 2: ', response);
            var obj = JSON.parse(JSON.stringify(response));
            console.log(obj.data.payload);
            console.log(self.channelName);
            
            let objData = obj.data.payload;
            self.status = objData.Order_Status__c;
            self.recordId = objData.Order_Number__c;
            self.ShowToast('Techdicer Plaform Event', self.Order_Status__c, 'success', 'dismissable');
        };
 
        // Invoke subscribe method of empApi. Pass reference to messageCallback
        subscribe(this.channelName, -1, messageCallback).then(response => {
            // Response contains the subscription information on subscribe call
            console.log('Subscription request sent to: ', JSON.stringify(response.channel));
            this.subscription = response;
        });
    }
 
    //handle Error
    registerErrorListener() {
        onError(error => {
            console.log('Received error from server: ', JSON.stringify(error));
        });
    }
 
    ShowToast(title, message, variant, mode) {
        const evt = new ShowToastEvent({
            title: title,
            //message: message,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(evt);
    }
}