import { LightningElement, track } from 'lwc';

export default class HelloWorld extends LightningElement {

    @track
    fName = '';
    handleChange(e){
        this.fName = e.target.value;
    }

}