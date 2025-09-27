import { LightningElement, track, wire, api } from 'lwc'
import templatePrimary from './sampleFirstTemplate.html';
import templateSecondary from './sampleSecondTemplate.html';
import getSearchData from '@salesforce/apex/MyContactListController.getMessage';

export default class SampleHelloWorld extends LightningElement {

    showTemplatePrimary = true;

    @track _isRendered = true;//boolean to check if component is rendered

    error;
    stack;

    @api textVal;

    @track testVar = 'ABCD';

    constructor() {
        super();    //Calling Constructor of LightningElement
        console.log('Constructor called =>');
    }

    connectedCallback() {
        let varElement = this.template;
        console.log('ConnectedCallback called =>' + varElement.isConnected);
    }


    handleChange(event) {
        try {
            this.textValue = event.detail.value;
        }
        catch (error) {
            console.log('error : ' + error.stack);
        }
    }

    // GETTER & SETTER FUNCTIONALITY 
    @api
    get textValue() {
        console.log('textValue getter called >> ');
        return this.textVal;
    }
    set textValue(value) {
        this.textVal = value.toUpperCase();
        console.log('textValue setter called >> ' + this.textVal);
    }


    @wire(getSearchData)
    wireMapData({ error, data }) {

        console.log('m in parent wire method');

        if (data) {
            console.log('data : ' + data);
            this.testVar = 'EFGH';
            console.log('this.testVar : ' + this.testVar);
        }
        else {
            console.log('error : ' + error);
        }
    }

    render() {
        console.log('Render called =>' + this.showTemplatePrimary);
        return this.showTemplatePrimary ? templatePrimary : templateSecondary;
    }

    renderedCallback() {
        if (this._isRendered) {
            console.log('Parent Component renderedCallback =>');
            this._isRendered = false;
        }
    }

    disconnectedCallback() {
        console.log('Disconnected Callback =>');
    }

    errorCallback(error, stack) {
        console.log('Error callBack called =>' + error);
        console.log('stack  =>' + stack);
        this.error = error;
        this.stack = stack;
    }
}