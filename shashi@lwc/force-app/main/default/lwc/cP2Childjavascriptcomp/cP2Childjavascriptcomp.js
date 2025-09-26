import { LightningElement } from 'lwc';

export default class CP2ChildComp extends LightningElement {

    handleChange(event){
        
        event.preventDefault();
        const name = event.target.value;
        const selectEvent = new CustomEvent('mycustomevent',{detail :name,bubbles:true});
        this.dispatchEvent(selectEvent);
    }
}