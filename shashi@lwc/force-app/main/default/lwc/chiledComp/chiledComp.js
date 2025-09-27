import { LightningElement ,track,api} from 'lwc';

export default class ChiledComp extends LightningElement {
@track Message ;
    @api
    changeMessage(strString){
    this.Message = strString;
    }
}