import { LightningElement, api, track } from 'lwc';
export default class MultiPickListGenericComponent extends LightningElement {

    @api receivedPickListValues; //Picklist values sent by parent component
    @api selectedValues; //Values that has been selected
    @api fieldApiName; //API Name which makes component to be generic

    options = [];
    values = [];

    selectedPickListValues = [];

    connectedCallback() {
        console.log('receivedPickListValues : ' + this.receivedPickListValues);
        console.log('selectedValues : ' + this.selectedValues);

        var localValues = [];

        //const defaultSelectedValues = new Set();
        var split_string = new Set(this.selectedValues.split(","));
        //split_string.push('casenumber');
        //this.values.push(...split_string);
        
        
        console.log('this.values 1 : ' + JSON.stringify(this.values));

        if (this.receivedPickListValues !== undefined) {
            this.receivedPickListValues.forEach(eachPicklistValue => {
                
                const items = [];
                items.push({
                    label: eachPicklistValue.label,
                    value: eachPicklistValue.value,
                });

                this.options.push(...items);

                if(split_string.has(eachPicklistValue.label)){
                    //split_string.push('casenumber');
                    localValues.push(eachPicklistValue.value);
                    console.log(localValues);
                }
            })
            this.values.push(...localValues);

            
            console.log('this.options : ' + JSON.stringify(this.options));
            console.log('this.values 2 : ' + JSON.stringify(this.values));
            
        }
    }

    onSave(event) {
        console.log('on click of save from child' + JSON.stringify(this.values));
        const saveEvent = new CustomEvent("saveevent", {
            detail: { value: 'yes', selectedvalues: this.values }
        });
        this.dispatchEvent(saveEvent);
    }
}