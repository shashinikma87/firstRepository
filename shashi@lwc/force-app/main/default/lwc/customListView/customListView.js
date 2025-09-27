import { LightningElement, api, wire, track } from 'lwc';

//import updateTotalGroupValue from '@salesforce/apex/CustomListViewController.updateTotalGroupValue';
//import submitForApproval from '@salesforce/apex/CustomListViewController.submitForApproval';
import updateDemands from '@salesforce/apex/CustomListViewController.updateDemands';
import retriveCases from '@salesforce/apex/CustomListViewController.retriveCases';
import fetchFilterMap from '@salesforce/apex/CustomListViewController.searchValuesResult';
import returnAllCaseFields from '@salesforce/apex/CustomListViewController.returnColumns';
import returnSelectedColumns from '@salesforce/apex/CustomListViewController.returnSelectedColumns'
import updateColumns from '@salesforce/apex/CustomListViewController.updateColumnSelection'
import CASE_OBJECT from '@salesforce/schema/Case';

import { refreshApex } from '@salesforce/apex';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

const actions = [
    { label: 'View', name: 'view' },
    { label: 'Edit', name: 'edit' },
    { label: 'Clone', name: 'clone' }
];

export default class CustomListViewPage extends NavigationMixin(LightningElement)
{

    isModalOpen = false;
    isGPModalOpen = false;
    isFilterOpen = false;
    isColumnFilterOpen = false;
    error;

    @track columns = [
       
    ];

    @track columnAction = [{ type: 'action', typeAttributes: { rowActions: actions, menuAlignment: 'right' } }];

    rowOffset = 0;
    totalDailyDeliveryGP = 0;
    selectedRows = [];
    message = 'Total Daily Delivery GP : '
    draftValues = [];

    @track records = [];

    mapData = [];
    wiredRecords;
    @track sortBy;
    @track sortDirection;
    @track ibmDeliveryLead = '';
    @track solIdentifier = '';
    @track ibmDeliveryLeadModalVar = '';
    @track solIdentifierModalVar = '';
    @track recSize;
    @track htm = '<input type="text" placeholder="Your state" class="data-input"/>';
    @track multiselectAllValues = [
        {
            label: 'None',
            value: 'None'
        },
    ];
    @track finalLabel = [];
    @track finalChoosenVal = [];
    finalApiNamesList = [];
    finalApiCSV = ''; // it contains final CSV for api names of selected columns to display
    
    //const labelToAPINames = new Map();

    @track DataTableResponseWrappper;
    @track finalSObjectDataList;

    @track fieldValue = ''; //Case Number,Final Demand Status,FP Project Name,IBM Delivery Lead';

    get pickListValues() {
        console.log('Inside get picklist values---> ',JSON.parse(JSON.stringify(this.multiselectAllValues)));
        this.finalLabel = JSON.parse(JSON.stringify(this.multiselectAllValues));
        return this.finalLabel;
    }

    connectedCallback() {
        console.log('m in parent connected callback method');
        this.getCaseFields();       // TOTAL SCHEMA OF CASE OHJECT
    }

    

    handleCreateNew() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Case',
                actionName: 'new',
            },
            state: {
                nooverride: '1',
                // recordTypeId: '0128G0000000IThQAM' // T&M
            }
        });
    }

    renderedCallback() {
        console.log('Inside rendered callback!!!!' + this.fieldValue);
    }


    returnSelectedColumns() {
        console.log('Inside return selected colums!!!!!')
        // close the filter window
        this.isFilterOpen = false;
        this.columns = [];

        returnSelectedColumns({ solIdentifier: this.solIdentifier, deliveryHead: this.ibmDeliveryLead })
            .then(data => {
                if (data) {
                    let sObjectRelatedFieldListValues = [];

                    this.DataTableResponseWrappper = data;
                    this.columns = [...this.columns, ...data.lstDataTableColumns, ...this.columnAction];
                    let colms = ''
                    console.log('data.lstDataTableColumns : '+JSON.stringify(data.lstDataTableColumns));
                    console.log('data.lstDataTableData : '+JSON.stringify(data.lstDataTableData));
                    
                    for (let row of data.lstDataTableColumns) {
                        colms = colms + ',' + row.label ;
                        console.log('row.fieldType----> ',row.type);
                    }

                    this.fieldValue = colms.substring(1);
                    console.log('this.fieldValue : '+this.fieldValue);

                    sObjectRelatedFieldListValues = this.returnRows(data.lstDataTableData);

                    this.records = sObjectRelatedFieldListValues;

                }
                else if (error) {
                    this.error = error;
                    console.log('Error ==> ' + this.error);
                }
            })
    }

    returnRows(lstDataTableData1) {

        let sObjectRows = [];

        for (let row of lstDataTableData1) {
            const finalSobjectRow = {}
            let rowIndexes = Object.keys(row);
            rowIndexes.forEach((rowIndex) => {
                const relatedFieldValue = row[rowIndex];
                if (relatedFieldValue.constructor === Object) {
                    //console.log(rowIndex +'Inside from where flatten transform fn gets called!!!! if' + JSON.stringify(relatedFieldValue));
                    this._flattenTransformation(relatedFieldValue, finalSobjectRow, rowIndex)
                }
                else {
                    
                    //let rowIndexNew = rowIndex.toLowerCase();
                    //finalSobjectRow[rowIndexNew] = relatedFieldValue;

                    finalSobjectRow[rowIndex] = relatedFieldValue;
                    //console.log(rowIndexNew + 'Inside else '+finalSobjectRow[rowIndexNew]);
                }

            });
            sObjectRows.push(finalSobjectRow);
        }

        console.log('sObjectRows : '+JSON.stringify(sObjectRows));
        return sObjectRows;

    }

    _flattenTransformation = (fieldValue, finalSobjectRow, fieldName) => {
        let rowIndexes = Object.keys(fieldValue);
        rowIndexes.forEach((key) => {
            let finalKey = fieldName + '.' + key;
            finalSobjectRow[finalKey] = fieldValue[key];
            console.log('rowIndexNew : ' + JSON.stringify(finalKey));
            console.log('finalSobjectRow[rowIndexNew] : ' + JSON.stringify(finalSobjectRow[finalKey]));
        })
    }



    //Added on 15 march 2023
    onClickSearch() {

        this.returnSelectedColumns(); return;
        console.log('solution Identifier----> ', this.solIdentifier);
        console.log('IBM Delivery Lead----> ', this.ibmDeliveryLead);

        if (this.ibmDeliveryLead !== '' || this.solIdentifier !== '') {
            console.log('inside click of search button');
            filteredCasesResult({ solIdentifier: this.solIdentifier, deliveryHead: this.ibmDeliveryLead })
                .then(result => {
                    console.log('result : ' + JSON.parse(JSON.stringify(result)));
                    //this.records = JSON.parse(JSON.stringify(result));
                    this.sObjectRelatedFieldListValues1 = JSON.parse(JSON.stringify(result));//JSON.parse(JSON.stringify(result));
                    //console.log('sObjectRelatedFieldListValues1 : ' + this.sObjectRelatedFieldListValues1);
                    this.recSize = this.records.length;
                })
                .catch(error => {
                    this.records = undefined;
                    window.console.log('error =====> ' + JSON.stringify(error));
                    if (error) {
                        this.errorMsg = error.body.message;
                    }
                })
        } else if (this.ibmDeliveryLead == '' && this.solIdentifier == '') {
            console.log('inside click of search button when both search parameters are blank!!');
            filteredCasesResult({ solIdentifier: this.solIdentifier, deliveryHead: this.ibmDeliveryLead })
                .then(result => {

                    //this.records = result;
                    this.sObjectRelatedFieldListValues1 = result;

                    //sObjectRelatedFieldListValues1 = result;
                    console.log('records when both blank---> ', this.sObjectRelatedFieldListValues1);
                })
                .catch(error => {
                    this.records = undefined;
                    window.console.log('error =====> ' + JSON.stringify(error));
                    if (error) {
                        this.errorMsg = error.body.message;
                    }
                })
        }
        else {
            //this.records = result;
            this.sObjectRelatedFieldListValues1 = result;

            //sObjectRelatedFieldListValues1 = JSON.parse(JSON.stringify(result));
            console.log('inside else ---> ', this.sObjectRelatedFieldListValues1);
        }

        this.records = this.sObjectRelatedFieldListValues1;
        //console.log('sObjectRelatedFieldListValues1 : ' + this.sObjectRelatedFieldListValues1);

        let sObjectRelatedFieldListValues = [];

        //sObjectRelatedFieldListValues = this.returnRows(this.sObjectRelatedFieldListValues1);
        //console.log('sObjectRelatedFieldListValues : ' + sObjectRelatedFieldListValues);

        //this.records = sObjectRelatedFieldListValues;
        this.records = this.sObjectRelatedFieldListValues1;
        console.log('at the end of the method..' + JSON.stringify(this.records));
        this.isFilterOpen = false;
    }

    disconnectedCallback() {
        //code
    }

    @wire(fetchFilterMap)
    wireMapData({ error, data }) {

        console.log('m in parent wire method');

        if (data) {
            console.log(data);
            var conts = data;
            for (var key in conts) {
                this.mapData.push({ value: conts[key], key: key });

                if (key == 'Delivery Lead') {
                    if (conts['Delivery Lead'] !== '' || conts['Delivery Lead'] !== null) {
                        this.ibmDeliveryLead = conts['Delivery Lead'];
                        console.log('this.ibmDeliveryLead wired--> ', this.ibmDeliveryLead);
                    } else {
                        this.ibmDeliveryLead = '';
                    }
                }
                if (key == 'Solution Identifier') {
                    if (conts['Solution Identifier'] !== '' || conts['Solution Identifier'] !== null) {
                        this.solIdentifier = conts['Solution Identifier'];
                        console.log('this.solIdentifier wired--> ', this.solIdentifier);
                    } else {
                        this.solIdentifier = '';
                    }
                }
            }
            this.returnSelectedColumns();
        } else if (error) {
            this.error = error;
        }
    }


    getCaseFields() {

        console.log('I am inside getCaseFields ');
        let labelToAPINames = new Map();
        returnAllCaseFields()
            .then(response => {

                console.log('I am inside response : ', response);
                let caseAllFieldNames = [];

                for (let key in response) {
                    let value = response[key];
                    caseAllFieldNames.push({ label: `${value}`, value: `${key}` });
                    this.labelToAPINames.set(value, key);
                }

                this.multiselectAllValues = caseAllFieldNames;
                console.log('this.labelToAPINames : ' + JSON.stringify(this.labelToAPINames));
                console.log('this.labelToAPINames : ' + JSON.stringify(this.labelToAPINames.get('Band')));
            })
    }


    onsavefromchild(event) {
        console.log('Inside parent post save from child!!!!')
        let val = event.detail.value;
        this.fieldValue = event.detail.selectedvalues;
        console.log('event val from child----> ', val);
        console.log('event val from child of field names----> ', this.fieldValue);

        updateColumns({ columnString1 : this.fieldValue })
            .then(
                response => {
                    if (response) {
                        console.log('Custon setting update successfully...');
                    }
                }
            )
            .catch(error => {
                console.log('Custon setting update error...'+JSON.stringify(error));
            });
         
            this.returnSelectedColumns();
            window.location.reload();
            
    }

    multipicklistgenericevent(event) {
        let myObj = {};
        this.fieldValue = event.detail.value;

        console.log('in multipicklistgenericevent : this.fieldValue : ' + this.fieldValue);

        //below part  - Aakash on 06 April
        if (this.fieldValue.length >= 1) {
            for (let val in this.fieldValue) { // this will be used to check the api names against the field names coming from multiselect picklist
                let newVal = this.fieldValue[val];
                const filtered = this.finalLabel.find((obj) => {
                    return (obj.value === newVal);
                });
                this.finalChoosenVal.push(filtered);
                console.log('filtered---> ', JSON.stringify(filtered));
            }
            console.log('this.finalChoosenVal----> ', JSON.parse(JSON.stringify(this.finalChoosenVal)));

            myObj = JSON.parse(JSON.stringify(this.finalChoosenVal));

            for (let keys in myObj) {
                console.log('all val---> ', myObj[keys]['label']);
                this.finalApiNamesList.push(myObj[keys]['label']); // will push all api names of selected field in this array.
            }
            this.finalApiNamesList = this.removeDuplicates(this.finalApiNamesList); //remove duplicates from array

            console.log('this.finalApiNamesList ----> ', this.finalApiNamesList);

            this.finalApiCSV = this.finalApiNamesList.toString();
            console.log('this.finalApiCSV----> ', this.finalApiCSV); //String to get CSV values from array.
        }
    }

    // function to remove duplicates from array - Aakash
    removeDuplicates(arr) {
        var unique = arr.reduce(function (acc, curr) {
            if (!acc.includes(curr))
                acc.push(curr);
            return acc;
        }, []);
        return unique;
    }

    onClickAddFilter() {
        this.template.querySelector('.newFilter').innerHTML = this.htm;
    }



    getSelectedRecord(event) {
        const selectedRows = event.detail.selectedRows;
        this.selectedRows = selectedRows;
        console.log('You selected: ', selectedRows);
    }

    calculateTotalDailyDelGP() {
        console.log('You selected: 2', this.selectedRows);
        let calculateTotalGP = true;
        let solutionIdentifier = '';
        if (!!this.selectedRows[0].Solution_identifier__c === true) {
            solutionIdentifier = this.selectedRows[0].Solution_identifier__c;
        }
        console.log('solutionIdentifier-->', solutionIdentifier);
        if (this.selectedRows.length > 1) {
            for (let i = 0; i < this.selectedRows.length; i++) {
                if (this.selectedRows[i].Solution_identifier__c !== solutionIdentifier) {
                    calculateTotalGP = false;
                }
            }
            if (calculateTotalGP) {
                for (let i = 0; i < this.selectedRows.length; i++) {
                    if (!!this.selectedRows[i].Daily_Delivery_GP__c === true) {
                        this.totalDailyDeliveryGP = parseFloat(this.totalDailyDeliveryGP) + parseFloat(this.selectedRows[i].Daily_Delivery_GP__c);
                    }
                }
                this.message = this.message + this.totalDailyDeliveryGP;
                updateTotalGroupValue({ listOfDemands: JSON.stringify(this.selectedRows), totalGPValue: this.totalDailyDeliveryGP })
                    .then(result => {
                        console.log('result-->', result);
                        this.isGPModalOpen = true;
                    })
                    .catch(error => {
                        this.isGPModalOpen = true;
                        this.error = error;
                        this.message = this.error;
                    });


            } else {
                const event = new ShowToastEvent({
                    title: 'Error',
                    message: 'Solution identifier mismatch',
                    variant: 'error'
                });
                this.dispatchEvent(event);
            }
        }
        console.log('total--->', this.totalDailyDeliveryGP);
    }

    onClickFilter() {
        this.isFilterOpen = true;
        this.solIdentifierModalVar = this.solIdentifier;
        this.ibmDeliveryLeadModalVar = this.ibmDeliveryLead;
    }

    onClickOpenColumnFilter() {
        this.isColumnFilterOpen = true;
        console.log('this.isColumnFilterOpen : ', this.isColumnFilterOpen);
    }


    openModal() {
        this.isModalOpen = true;
    }
    closeModal() {
        this.isModalOpen = false;
        this.isGPModalOpen = false;
        this.isFilterOpen = false;
        this.solIdentifierModalVar = this.solIdentifier;
        this.ibmDeliveryLeadModalVar = this.ibmDeliveryLead;

        this.isColumnFilterOpen = false;

    }
    submitDetails() {
        console.log('You selected', this.selectedRows);
        let textarea = this.template.querySelector("lightning-textarea[data-id]").value;
        this.isModalOpen = false;
        var listOfDemand = [];

        for (let i = 0; i < this.selectedRows.length; i++) {
            listOfDemand.push(this.selectedRows[i].Id);
        }
        console.log('listOfDemand---->' + listOfDemand);
        submitForApproval({ comments: textarea, listOfDemand: listOfDemand })
    }


    async handleSave(event) {
        const updatedFields = event.detail.draftValues;

        await updateDemands({ data: updatedFields })
            .then(result => {

                console.log(JSON.stringify('Apex update result:' + result));
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Demand updated',
                        variant: 'success'
                    })
                );

                refreshApex(this.wiredRecords).then(() => {
                    this.draftValues = [];
                });
            }).catch(error => {

                console.log('Error is' + JSON.stringify(error));
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error updating or refreshing records',
                        message: error.body.message,
                        variant: 'error'
                    })
                );

            });

    }
    searchKey;
    handleKeywordChange(event) {
        this.searchKey = event.target.value;
        console.log(this.searchKey);
    }

    handleSearch(event) {
        console.log(this.searchKey);
        this.searchKey = event.target.value;
        if (this.searchKey !== '' && this.searchKey !== undefined) {
            console.log('inside search');
            if (!this.searchKey) {
                this.errorMsg = 'Please enter Case Number to search.';
                this.searchData = undefined;
                return;
            }
            retriveCases({ strcasenumber: this.searchKey })
                .then(result => {
                    console.log('result handle search ', result);
                    this.records = this.returnRows(result);
                    this.recSize = this.records.length;
                })
                .catch(error => {
                    this.records = undefined;
                    window.console.log('error =====> ' + JSON.stringify(error));
                    if (error) {
                        this.errorMsg = error.body.message;
                    }
                })
        }
        else {
            console.log('inside else');

            this.onClickSearch();

        }
    }

    // to view, edit and clone the selected record in lightning data table
    handleRowAction(event) {
        console.log('view record 1 ', event.detail.action.name);
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        this.recordId = row.id;
        console.log('row----> ', row.id, ' record id---> ', this.recordId);
        switch (actionName) {
            case 'view':
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: row.id,
                        actionName: 'view'
                    }
                });
                break;
            case 'clone':
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: row.id,
                        objectApiName: 'Account',
                        actionName: 'clone'
                    }
                });
                break;
            case 'edit':
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: row.id,
                        objectApiName: 'Account',
                        actionName: 'edit'
                    }
                });
                break;
        }
    }
    
    //Added on 15 march 2023
    handleInputSolId(event) {
        this.solIdentifierModalVar = event.target.value;
    }
    //Added on 15 march 2023
    handleInputIBMDelLead(event) {
        this.ibmDeliveryLeadModalVar = event.target.value
    }
    //Added on 21 March 2023 for solt filter cancel button.
    onBeforeClickSearch(event) {
        this.ibmDeliveryLead = this.ibmDeliveryLeadModalVar;
        this.solIdentifier = this.solIdentifierModalVar;
        this.onClickSearch();
    }
    //Added on 29 March 2023 - to clear all the filters 
    onClearFilterClick(event) {
        this.ibmDeliveryLeadModalVar = '';
        this.solIdentifierModalVar = '';
    }

    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.records));
        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldname];
        };
        // cheking reverse direction
        let isReverse = direction === 'asc' ? 1 : -1;
        // sorting data
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';
            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });
        this.records = parseData;
    }
}