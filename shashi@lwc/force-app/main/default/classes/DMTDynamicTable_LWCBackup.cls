public class DMTDynamicTable_LWCBackup {
    
   /*
	customListViewPage

	<template>

	<lightning-card icon-name="standard:case" title="Demand Masters">

		<lightning-button label="New" slot="actions" class="slds-m-left_x-small" title="Non-primary action"
			onclick={handleCreateNew} variant="brand-outline">
		</lightning-button>
		<lightning-button label="Total Daily Deliver GP" slot="actions" class="slds-m-left_x-small"
			title="Non-primary action" onclick={calculateTotalDailyDelGP} variant="brand-outline">
		</lightning-button>
		<lightning-button label="Submit for Approval" slot="actions" class="slds-m-left_x-small" variant="brand-outline"
			onclick={openModal}>
		</lightning-button>


		<div class="slds-grid  slds-form-element slds-form-element_horizontal">
			<div class="slds-col slds-size_4-of-8">
				<div><span class="countSortedByFilteredBy" aria-live="polite" role="status" aria-label="All">
			• {recSize} items • Filtered by - IBM Delivery Lead : <b>{ibmDeliveryLead}</b>, Solution Identifier :<b> {solIdentifier}</b> </span>
				</div>
			</div>
			<div class="slds-col slds-size_4-of-8">
				<div class="filterClass">
					<lightning-input type="search" value={searchKey} class="slds-m-left_x-small search-case"
						onchange={handleSearch} placeholder="Search Case Number">
					</lightning-input><br>

					<lightning-button-icon icon-name="utility:filterList" variant="border-filled"
						alternative-text="Add Filter" class="slds-m-left_xx-small" title="Add Filter"
						onclick={onClickFilter}>
					</lightning-button-icon>

					<lightning-button-icon icon-name="utility:filter" variant="border-filled"
						alternative-text="Add/Remove Columns" class="slds-m-left_xx-small" title="Add/Remove Columns"
						onclick={onClickOpenColumnFilter}>
					</lightning-button-icon>

				</div>
			</div>
		</div>

		<p> Selected Values: {fieldValue}</p>

		<div class="myTable" style="height: 450px;">
			<lightning-datatable class="slds-table_header-fixed_container slds-scrollable_x slds-border_top "
				key-field="Id" data={records} show-row-number-column row-number-offset={rowOffset}
				onrowselection={getSelectedRecord} sorted-by={sortBy} sorted-direction={sortDirection}
				onsort={doSorting} columns={columns} onsave={handleSave} draft-values={draftValues}
				onrowaction={handleRowAction}>

			</lightning-datatable>
		</div>


		<!-- Modal popup for displaying Filter -->
		<template if:true={isFilterOpen}>
			<!-- Modal/Popup Box LWC starts here -->
			<section role="dialog" tabindex="-1" aria-labelledby="modal-heading-01" aria-modal="true"
				aria-describedby="modal-content-id-1" class="slds-modal slds-fade-in-open">
				<div class="slds-modal__container filter-modal">

					<!-- Modal/Popup Box LWC header here -->
					<header class="slds-modal__header">
						<button class="slds-button slds-button_icon slds-modal__close slds-button_icon-inverse" title="Close" onclick={closeModal}>
							<lightning-icon icon-name="utility:close"
								alternative-text="close"
								variant="inverse"
								size="small" ></lightning-icon>
							<span class="slds-assistive-text">Close</span>
            			</button>
						<h2 id="filter-heading-01" class="slds-text-heading_medium slds-hyphenate">
							Filters
						</h2>
					</header>


					<!-- Modal/Popup Box LWC body starts here -->
					<div class="slds-modal__content slds-p-around_medium slds-grid  slds-grid_vertical"
						id="filter-content-id-1">

						<div class="slds-col">
							<lightning-input type="text" value={solIdentifierModalVar}
								class="slds-m-left_x-small sol-Identifier2" onchange={handleInputSolId}
								placeholder="Enter Solution Identifier" label="Solution Identifier">
							</lightning-input><br>
						</div>
							<div class="slds-col">
								<lightning-input type="text" value={ibmDeliveryLeadModalVar}
									class="slds-m-left_x-small delivery-Lead2" onchange={handleInputIBMDelLead}
									placeholder="Enter IBM Delivery Lead" label="IBM Delivery Lead">
								</lightning-input><br>
						</div>

						<div class="slds-col">
							<lightning-button label="Apply Filter" slot="actions"
								class="slds-m-left_x-small search-btn2" variant="brand-outline"
								onclick={onBeforeClickSearch}>
							</lightning-button>

							<lightning-button label="Clear Filter" slot="actions"
								class="slds-m-left_x-small search-btn2" variant="brand-outline"
								onclick={onClearFilterClick}>
							</lightning-button>
						</div>
					</div>

					<!-- Modal/Popup Box LWC footer starts here -->
					<footer class="slds-modal__footer">
						<button class="slds-button slds-button_neutral" onclick={closeModal} title="Cancel">Cancel</button>
					</footer>

				</div>
			</section>
			<div class="slds-backdrop slds-backdrop_open"></div>
		</template>


		<!-- Modal popup for displaying Total Daily Deliver GP -->
		<template if:true={isGPModalOpen}>
			<!-- Modal/Popup Box LWC starts here -->
			<section role="dialog" tabindex="-1" aria-labelledby="modal-heading-01" aria-modal="true"
				aria-describedby="modal-content-id-1" class="slds-modal slds-fade-in-open">
				<div class="slds-modal__container">

					<!-- Modal/Popup Box LWC header here -->
					<header class="slds-modal__header">
						<button class="slds-button slds-button_icon slds-modal__close slds-button_icon-inverse" title="Close" onclick={closeModal}>
							<lightning-icon icon-name="utility:close"
								alternative-text="close"
								variant="inverse"
								size="small" ></lightning-icon>
							<span class="slds-assistive-text">Close</span>
            			</button>
						<h2 id="GPmodal-heading-01" class="slds-text-heading_medium slds-hyphenate">Total Daily Deliver
							GP
						</h2>
					</header>

					<!-- Modal/Popup Box LWC body starts here -->
					<div class="slds-modal__content slds-p-around_medium" id="GPmodal-content-id-1">
						<p><b>
							{message}
						</b></p>
					</div>

					<!-- Modal/Popup Box LWC footer starts here -->
					<footer class="slds-modal__footer">
						<button class="slds-button slds-button_neutral" onclick={closeModal} title="Cancel">Cancel</button>
					</footer>

				</div>
			</section>
			<div class="slds-backdrop slds-backdrop_open"></div>
		</template>


		<!-- Modal popup to Submit for Approval -->
		<template if:true={isModalOpen}>
			<!-- Modal/Popup Box LWC starts here -->
			<section role="dialog" tabindex="-1" aria-labelledby="modal-heading-01" aria-modal="true"
				aria-describedby="modal-content-id-1" class="slds-modal slds-fade-in-open">
				<div class="slds-modal__container">
					<!-- Modal/Popup Box LWC header here -->
					<header class="slds-modal__header">
						<button class="slds-button slds-button_icon slds-modal__close slds-button_icon-inverse" title="Close" onclick={closeModal}>
                <lightning-icon icon-name="utility:close"
                    alternative-text="close"
                    variant="inverse"
                    size="small" ></lightning-icon>
                <span class="slds-assistive-text">Close</span>
            </button>
					<h2 id="modal-heading-01" class="slds-text-heading_medium slds-hyphenate">Submit for Approval</h2>
					</header>
					<!-- Modal/Popup Box LWC body starts here -->
					<div class="slds-modal__content slds-p-around_medium" id="modal-content-id-1">
						<p><b>
                <lightning-textarea class="slds-p-top_small" data-id="commentsData" label="Comments" ></lightning-textarea>
            </b></p>
				</div>
					<!-- Modal/Popup Box LWC footer starts here -->
					<footer class="slds-modal__footer">
						<button class="slds-button slds-button_neutral" onclick={closeModal} title="Cancel">Cancel</button>
						<button class="slds-button slds-button_brand" onclick={submitDetails} title="Submit">Submit</button>
					</footer>
				</div>
			</section>
			<div class="slds-backdrop slds-backdrop_open"></div>
		</template>


		<!-- Modal/Popup for List View Coulmn Selection  -->
		<template if:true={isColumnFilterOpen}>
			<section role="dialog" tabindex="-1" aria-labelledby="modal-heading-04" aria-modal="true"
				aria-describedby="modal-content-id-4" class="slds-modal slds-fade-in-open">
				<div class="slds-modal__container filter-modal">

					<!-- Modal/Popup Box LWC header here -->
					<header class="slds-modal__header">
						<button class="slds-button slds-button_icon slds-modal__close slds-button_icon-inverse" title="Close" onclick={closeModal}>
							<lightning-icon icon-name="utility:close"
								alternative-text="close"
								variant="inverse"
								size="small" ></lightning-icon>
							<span class="slds-assistive-text">Close</span>
            			</button>
						<h2 id="filter-heading-04" class="slds-text-heading_medium slds-hyphenate">
							Select Columns
						</h2>
					</header>


					<!-- Modal/Popup Box LWC body starts here -->
					<div class="slds-modal__content slds-p-around_medium slds-grid  slds-grid_vertical"
						id="filter-content-id-4">
						<!-- onmultipicklistgenericevent={multipicklistgenericevent}  -->
						<c-multi-pick-list-generic-component received-pick-list-values={pickListValues}
							onsaveevent={onsavefromchild} selected-values={fieldValue}
							field-api-name="Company_Category__c">
						</c-multi-pick-list-generic-component>
					</div>


					<!-- Modal/Popup Box LWC footer starts here -->
					<footer class="slds-modal__footer">
						<button class="slds-button slds-button_neutral" onclick={closeModal} title="Cancel">Cancel</button>
					</footer>

				</div>
			</section>
			<div class="slds-backdrop slds-backdrop_open"></div>
		</template>
		



	</lightning-card>
</template>



	JS 

	import { LightningElement, api, wire, track } from 'lwc';

import updateTotalGroupValue from '@salesforce/apex/CustomListViewController.updateTotalGroupValue';
import submitForApproval from '@salesforce/apex/CustomListViewController.submitForApproval';
import updateDemands from '@salesforce/apex/CustomListViewController.updateDemands';
import retriveCases from '@salesforce/apex/CustomListViewController.retriveCases';
import filteredCasesResult from '@salesforce/apex/CustomListViewController.filteredCases';
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
    labelToAPINames = new Map();

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
        //this.fieldValue = this.fieldValue.substring(1);
        console.log('Inside rendered callback!!!!' + this.fieldValue);
        //console.log('isReturnedFromChild : '+this.isReturnedFromChild);

        //updateColumns
    }


    _flattenTransformation = (fieldValue, finalSobjectRow, fieldName) => {
        let rowIndexes = Object.keys(fieldValue);
        rowIndexes.forEach((key) => {
            let finalKey = fieldName + '.' + key;
            finalSobjectRow[finalKey] = fieldValue[key];
            //console.log('finalSobjectRow in _flattenTransformation method : ' + finalSobjectRow);
        })
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
                    for (let row of data.lstDataTableColumns) {
                        colms = colms + ',' + row.label ;
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

    //lstDataTableData1;

    returnRows(lstDataTableData1) {

        //console.log('lstDataTableData : ' + lstDataTableData1);
        let sObjectRows = [];

        for (let row of lstDataTableData1) {
            const finalSobjectRow = {}
            let rowIndexes = Object.keys(row);
            rowIndexes.forEach((rowIndex) => {
                //console.log('row : ' + JSON.stringify(row));
                const relatedFieldValue = row[rowIndex];
                if (relatedFieldValue.constructor === Object) {
                    this._flattenTransformation(relatedFieldValue, finalSobjectRow, rowIndex)
                }
                else {
                    //finalSobjectRow[rowIndex] = relatedFieldValue;
                    let rowIndexNew = rowIndex.toLowerCase();

                    finalSobjectRow[rowIndexNew] = relatedFieldValue;
                    //console.log('in else finalSobjectRow : ' + JSON.stringify(finalSobjectRow));
                    //console.log('relatedFieldValue : ' + JSON.stringify(relatedFieldValue));
                }

            });
            sObjectRows.push(finalSobjectRow);
        }

        return sObjectRows;

    }

    sObjectRelatedFieldListValues1;

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
                //console.log('this.mapdata--> ', conts[key]);
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

            //this.onClickSearch();
            this.returnSelectedColumns();
            //console.log('records-----> ', this.records);
        } else if (error) {
            this.error = error;
        }
    }


    getCaseFields() {

        console.log('I am inside getCaseFields ');

        returnAllCaseFields()
            .then(response => {

                console.log('I am inside response : ', response);
                let caseAllFieldNames = [];

                for (let key in response) {
                    let value = response[key];

                    //caseAllFieldNames.push({ label: `${key}`, value: `${value}` });
                    caseAllFieldNames.push({ label: `${value}`, value: `${key}` });

                    this.labelToAPINames.set(value, key);
                }

                this.multiselectAllValues = caseAllFieldNames;
                console.log('this.labelToAPINames : ' + JSON.stringify(this.labelToAPINames));
            })
    }


    onsavefromchild(event) {
        console.log('Inside parent post save from child!!!!')
        let val = event.detail.value;
        this.fieldValue = event.detail.selectedvalues;
        console.log('event val from child----> ', val);
        console.log('event val from child of field names----> ', this.fieldValue);

        //var columnsCSV = this.fieldValue;

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
        // this.isSearchChangeExecuted = false;  
        this.searchKey = event.target.value;
        console.log(this.searchKey);
        //this.records= this.records.filter(item => item.CaseNumber===this.searchKey);
        //console.log('testss::'+this.records);

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
                    this.records = result;
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
   


	CSS

.wrapped-header-datatable .slds-table .slds-th__action .slds-truncate{
    max-width: 100%;
    overflow: hidden;
    text-overflow: unset;
    white-space: pre-line;
    /* word-wrap: break-word; 
}

.wrapped-header-datatable .slds-table .slds-th__action {
    height: 5rem;
}

.wrapped-header-datatable .slds-table .slds-line-height_reset{
    height: 3rem;
}

.filterClass{
    display: flex;
    margin-left: 18rem;
    margin-right: 12px;
}
.sol-Identifier{
    position: relative;
    left: -4rem;
    width: 169%;
    margin-left: -10rem;
}
.delivery-Lead{
    position: relative;
    left: -7rem;
    width: 169%;
    margin-right: -5rem;
}
.search-btn{
    position: relative;
    left: -17px;
    width: 37%;
}

.search-case{
    position: relative;
    left: 0rem;
    width: 200%;
}

.filter-criteria{
    margin-right: 10px;
    border: 3px solid #2574A9;
    border-width: 1px;
    border-radius: .25rem;
    object-position: 50% 50%;
    padding-top: 4px;
    padding-right: 4px;
    padding-left: 4px;
}

.test-filter-button {
    padding-right: 1px;
    padding-left: 1px;
}

/* modal popup CSS 
.filterClass1{
    display: flex;
}
.sol-Identifier1{
    position: relative;
    left: 6rem;
    width: 90%;
    margin-left: -13rem;
}
.delivery-Lead1{
    position: relative;
    left: 2.5rem;
    width: 90%;
    margin-left: -3rem;
}
.search-btn1{
    position: relative;
    left: 58px;
    width: 40%;
}
 


/* vertical allignment CSS 
.sol-Identifier2{
    position: relative;
    left: 1rem;
    width: 100%;
    padding-right: 10rem;
}
.delivery-Lead2{
    position: relative;
    left: 1rem;
    width: 100%;
    padding-right: 10rem;
}
.search-btn2{
    position: relative;
    left: 1rem;
    width: 40%;
}
.filter-modal {
    width: 50%;
    max-width: 30rem;
    min-width: 20rem;
}
.addFilter{
    color:var(--lwc-colorTextLink,#2574A9);
    line-height: 3.5rem;
    margin-left: 1.5rem;
}


    */
    
    
    /*
     multiPickListGenericComponent

	<template>
  <div class="slds-box slds-col slds-scrollable" style="height: 7rem; padding: initial; background-color: white;">
    <ul role="menu" style="min-width: 100%; width: fit-content;">
       <template for:each={pickListValues} for:item="eachPickList" for:index="index">  
      <!-- <template for:each={labelToAPINames} for:item="eachPickList" for:index="index">-->
       
        <div key={eachPickList}>
          <li onclick={handleSelection} data-value={eachPickList} data-selected={eachPickList} class="highlightRow">
            <div role="option">
              <span class="slds-media__figure" style="margin-right: 0.25rem;">
                <lightning-icon name="checkIcon" variant="inverse" icon-name="utility:check" size="xx-small"
                  class="addOrRemoveCheck slds-p-left_xx-small"></lightning-icon>
              </span>

              <span class="slds-media__body">
                <span class="slds-truncate" title={eachPickList}>{eachPickList}</span>
              </span>
            </div>
          </li>
        </div>
    

      </template>
    </ul>
  </div>
  <div>
    <lightning-button label="Save" class="slds-m-left_x-small"
			title="Save" onclick={onSave} variant="brand-outline">
		</lightning-button>
  </div>
</template>


		JS


	import { LightningElement, api, track } from 'lwc';

export default class MultiPickListGenericComponent extends LightningElement {

    @api receivedPickListValues; //Picklist values sent by parent component
    @api selectedValues; //Values that has been selected
    @api fieldApiName; //API Name which makes component to be generic
    @track pickListValues = [];
    @track fieldName;
    
    @track labelToAPINames = new Map();

    selectedPickListValues = [];

    connectedCallback() {
        console.log('receivedPickListValues -------> ', JSON.stringify(this.receivedPickListValues));
        console.log('selectedValues -------> ', this.selectedValues);
        var i;
        let pickListValues = [];
        let fieldApiNames = [];
        if (this.receivedPickListValues !== undefined) {
            this.receivedPickListValues.forEach(eachPicklistValue => {

                //console.log('eachPicklistValue : '+JSON.stringify(eachPicklistValue));

                if (eachPicklistValue.hasOwnProperty('value')) {
                    //pickListValues.push(eachPicklistValue.value);
                    //this.pickListValues = [...pickListValues];
                }
                if (eachPicklistValue.hasOwnProperty('label')) {
                    //console.log('Inside Labels!!!!! ',eachPicklistValue.label)
                    fieldApiNames.push(eachPicklistValue.label);
                    this.fieldName = [...fieldApiNames];

                    pickListValues.push(eachPicklistValue.label);
                    this.pickListValues = [...pickListValues];

                    //this.selectedPickListValues.push(this.receivedPickListValues[i].value);
                }

                this.labelToAPINames.set(eachPicklistValue.label, eachPicklistValue.value);
            });
        }
        console.log('this.pickListValues =>> ', this.pickListValues)
        console.log('this.labelToAPINames : ' + this.labelToAPINames);
    }

    renderedCallback() {

        console.log('I am in child rendered callback ');  //+JSON.stringify(this.receivedPickListValues));
        var i;
        if (this.receivedPickListValues !== null && this.receivedPickListValues !== undefined) {
            for (i = 0; i < this.receivedPickListValues.length; i++) {
                console.log('this.receivedPickListValues[i].value : ' + JSON.stringify(this.receivedPickListValues[i]));

                if (this.selectedValues !== undefined && this.selectedValues.includes(this.receivedPickListValues[i].label)) {
                    console.log('in first if...');
                    if (this.template.querySelectorAll('.highlightRow')[i].style !== undefined) {
                        console.log('in first if...if');
                        this.template.querySelectorAll('.highlightRow')[i].style = 'background-color: rgba(9, 106, 189, 0.85); color : white;cursor: pointer;';
                        this.selectedPickListValues.push(this.receivedPickListValues[i].label);
                    }
                } else {
                    console.log('in first else...');
                    if (this.template.querySelectorAll('.highlightRow')[i].style !== undefined) {
                        console.log('in first else...if');
                        this.template.querySelectorAll('.highlightRow')[i].style = 'background-color: white; cursor: pointer;';
                        this.template.querySelectorAll('.addOrRemoveCheck')[i].style = 'opacity :0;';
                    }
                }
            }
        }
    }


    handleSelection(event) {
        console.log('event.currentTarget : ' + event.currentTarget);
        var item = event.currentTarget;
        console.log('item----> ', JSON.stringify(item.dataset));
        var valueChoosen;
        var options;
        var i, j, k;
        let pickListValues = [];
       
        let found = false;
        if (item && item.dataset) {
            valueChoosen = item.dataset.value;
            console.log('valueChoosen : ' + valueChoosen);

            pickListValues = this.selectedPickListValues;
            options = pickListValues;

            for (i = 0; i < options.length; i++) {

                console.log('options[i] : ' + options[i]);
                console.log('valueChoosen : ' + valueChoosen);

                if (options[i] === valueChoosen) {
                    found = true;
                    for (k = 0; k < this.receivedPickListValues.length; k++) {
                        if (this.receivedPickListValues[k].hasOwnProperty('label')) {
                            if (this.receivedPickListValues[k].label.indexOf(valueChoosen) > -1) {
                                this.template.querySelectorAll('.highlightRow')[k].style = 'background-color: white; cursor: pointer;';
                                this.template.querySelectorAll('.addOrRemoveCheck')[k].style = 'opacity :0;';
                            }
                        }
                    }
                    delete pickListValues[i];
                }
            }

            if (!found) {
                console.log('in found if.. ');
                pickListValues.push(valueChoosen);
                for (i = 0; i < this.receivedPickListValues.length; i++) {
                    if (this.receivedPickListValues[i].hasOwnProperty('label')) {
                        if (this.receivedPickListValues[i].label.indexOf(valueChoosen) > -1) {
                            this.template.querySelectorAll('.highlightRow')[i].style = 'background-color: rgba(9, 106, 189, 0.85); color : white; cursor: pointer;';
                            this.template.querySelectorAll('.addOrRemoveCheck')[i].style = 'opacity :1;';
                        }
                    }
                }
            }
        }

        let updatedPicklistValues = [];
        for (i = 0; i < pickListValues.length; i++) {
            if (pickListValues[i]) {
                updatedPicklistValues.push(pickListValues[i]);
            }
        }

        this.selectedPickListValues = updatedPicklistValues;
        console.log('this.selectedPickListValues----> ', this.selectedPickListValues);

    }

    onSave(event) {
        console.log('on click of save from child')
        const saveEvent = new CustomEvent("saveevent", {
            detail: { value: 'yes', selectedvalues: this.selectedPickListValues }
        });
        this.dispatchEvent(saveEvent);
    }

}

    CSS

.dummy{
	color : black;
}
    
    
    
    */
}