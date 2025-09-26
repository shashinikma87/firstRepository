import { LightningElement, track } from 'lwc';

import templateSecondary from './childComponentTest.html';
 
export default class ChildComponentTest extends LightningElement {  
 
    constructor(){
        super(); //Calling Constructor of LightningElement
        console.log('Child Component Constructor called =>');
    }
 
    connectedCallback() {
        console.log('Child Component connectedCallback =>');
    }
 
    render()
    {
        console.log('Child Component render => ');
        return templateSecondary;
    }

    renderedCallback(){        
        console.log('Child Component renderedCallback from Parent Component =>');
    }
   
    
}