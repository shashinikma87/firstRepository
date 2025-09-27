import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import fetchAccountsList from '@salesforce/apex/trainingClass.fetchAccountsList';
import fetchAccountsList1 from '@salesforce/apex/trainingClass.fetchAccountsList1';
import fetchAccountsList2 from '@salesforce/apex/trainingClass.fetchAccountsList2';

import{ NavigationMixin} from 'lightning/navigation';

export default class TrainingLwcDecorator extends NavigationMixin(LightningElement) {

    @track
    inputTagVal;
    
    @track
    inputTitle

    @track
    inputMessage

    @track
    inputVariant


    @api
    prop1;
    
    @api
    prop2;

    @api
    accounts;

    @api
    error;

    handleChange(event){
        console.log('event : '+event.target.value);
        this.inputTagVal = event.target.value;
    }

    titleChange(event) {
        this.inputTitle = event.target.value;
    }

    messageChange(event) {
        this.inputMessage = event.target.value;
    }

    variantChange(event) {
        this.inputVariant = event.target.value;
    }

    showToast()
    {
        let t = this.template.querySelector('.title').value; 
        let m = this.template.querySelector('.msg').value; 
        let v = this.template.querySelector('.varnt').value; 
        console.log('Title : '+t);
        console.log('msg : '+m);
        console.log('variant : '+v);

        const evt = new ShowToastEvent({
            title: this.inputTitle,
            message: this.inputMessage,
            variant: this.inputVariant,
        });
        this.dispatchEvent(evt);
    }

    callApexMethod()
    {
        let t = this.template.querySelector('.ipLimit').value;
 
        fetchAccountsList({accLimit : t})
            .then( result => {
                this.accounts = result;
                console.log('accounts : '+this.accounts);
            })
            .catch(error =>{
                this.error = error;
            });
    }

    getAcounts()
    {
        let d1 = this.template.querySelector('.date1').value;
        let d2 = this.template.querySelector('.date2').value;
        alert(d1);
 
        fetchAccountsList1({dt1 : d1,
            dt2: d2
        })
            .then( result => {
                this.accounts = result;
                console.log('accounts : '+this.accounts);
            })
            .catch(error =>{
                this.error = error;
            });
    }

    getOpportunity()
    {
        let d1 = this.template.querySelector('.date1').value;
        let d2 = this.template.querySelector('.date2').value;
        alert(d1);
 
        fetchAccountsList2({dt1 : d1,
            dt2: d2
        })
            .then( result => {
                this.accounts = result;
                console.log('accounts : '+this.accounts);
            })
            .catch(error =>{
                this.error = error;
            });
    }
    navigateRecord(event){

        var Id = event.target.dataset.id;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: Id,
                actionName: 'edit',
                //alert('ID---'+ attributes);
            },
        });
    }

    
}