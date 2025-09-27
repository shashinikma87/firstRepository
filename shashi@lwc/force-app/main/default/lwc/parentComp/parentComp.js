import { LightningElement } from 'lwc';

export default class ParentComp extends LightningElement {

    handleChangeEvent(event){
        this.template.querySelector('c-chiled-Comp').changeMessage(event.target.value);
    }
}