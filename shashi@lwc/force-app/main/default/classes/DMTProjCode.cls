public class DMTProjCode {

/*

========================================  HTML  ========================================
<template>

	<lightning-card icon-name="standard:case" title="Demand Masters">

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

					<!--
					<lightning-input type="text" value={solIdentifier} class="slds-m-left_x-small sol-Identifier"
						onchange={handleInputSolId} placeholder="Solution Identifier">
					</lightning-input><br>
					<lightning-input type="text" value={ibmDeliveryLead} class="slds-m-left_x-small delivery-Lead"
						onchange={handleInputIBMDelLead} placeholder="IBM Delivery Lead">
					</lightning-input>
					<lightning-button label="Search" slot="actions" class="slds-m-left_x-small search-btn"
						variant="brand-outline" onclick={onClickSearch}>
					</lightning-button>

					<button class="slds-button slds-button_icon slds-button_icon-border-filled" type="button" role="button" title="Show filters"
					aria-pressed="false" part="button button-icon" onclick={onClickSearch}>
						<lightning-icon icon-name="utility:filterList" size="small"
							class="slds-m-left_x-small filter-criteria" alternative-text="Indicates Filter">
						</lightning-icon>
					</button>

					<lightning-button class="slds-button test-filter-button" icon-name="utility:filterList"
						onclick={onClickSearch}>

					</lightning-button>
-->
					<lightning-button-icon icon-name="utility:filterList" variant="border-filled"
						alternative-text="Add Filter" class="slds-m-left_xx-small" title="Add user"
						onclick={onClickFilter}>
					</lightning-button-icon>



				</div>
			</div>
		</div>

		<div class="myTable" style="height: 450px;">
			<lightning-datatable class="slds-table_header-fixed_container slds-scrollable_x slds-border_top "
				key-field="Id" data={records} show-row-number-column row-number-offset={rowOffset}
				onrowselection={getSelectedRecord} sorted-by={sortBy} sorted-direction={sortDirection}
				onsort={doSorting} columns={columns} onsave={handleSave} draft-values={draftValues}>
			</lightning-datatable>
		</div>


		<!-- Modal popup for displaying Filter -->
		<template if:true={isFilterOpen}>
			<!-- Modal/Popup Box LWC starts here -->
			<section role="dialog" tabindex="-1" aria-labelledby="modal-heading-01" aria-modal="true"
				aria-describedby="modal-content-id-1" class="slds-modal slds-fade-in-open">
				<div class="slds-modal__container filter-modal" >

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
							<lightning-input type="text" value={solIdentifier}
								class="slds-m-left_x-small sol-Identifier2" onchange={handleInputSolId}
								placeholder="Enter Solution Identifier" label="Solution Identifier">
							</lightning-input><br>
						</div>
						<div class="slds-col">
								<lightning-input type="text" value={ibmDeliveryLead}
									class="slds-m-left_x-small delivery-Lead2" onchange={handleInputIBMDelLead}
									placeholder="Enter IBM Delivery Lead" label="IBM Delivery Lead">
								</lightning-input><br>
						</div>

						<div class="slds-col">
							<lightning-button label="Apply Filter" slot="actions"
								class="slds-m-left_x-small search-btn2" variant="brand-outline"
								onclick={onClickSearch}>
							</lightning-button>
						</div>
						<div class="slds-col">
							<a role="button" href="javascript:void(0);" class="addFilter">Add Filter</a>
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

		<!-- Modal popup for displaying Filter -->
		<!--		<template if:true={isFilterOpen}>

			<section role="dialog" tabindex="-1" aria-labelledby="modal-heading-01" aria-modal="true"
				aria-describedby="modal-content-id-1" class="slds-modal slds-fade-in-open">
				<div class="slds-modal__container">

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

					<div class="slds-modal__content slds-p-around_medium" id="filter-content-id-1">

						<div class="slds-grid  slds-form-element slds-form-element_horizontal">
							<div class="slds-col slds-size_6-of-6">
								<div class="filterClass1">
									
									<lightning-input type="text" value={solIdentifier} 
										class="slds-m-left_x-small sol-Identifier1" onchange={handleInputSolId}
										placeholder="Enter Solution Identifier">
									</lightning-input><br>
									<lightning-input type="text" value={ibmDeliveryLead}
										class="slds-m-left_x-small delivery-Lead1" onchange={handleInputIBMDelLead}
										placeholder="Enter IBM Delivery Lead">
									</lightning-input>
									<lightning-button label="Apply Filter" slot="actions"
										class="slds-m-left_x-small search-btn1" variant="brand-outline"
										onclick={onClickSearch}>
									</lightning-button>

								</div>
							</div>
						</div>

					</div>


					<footer class="slds-modal__footer">
						<button class="slds-button slds-button_neutral" onclick={closeModal} title="Cancel">Cancel</button>
					</footer>

				</div>
			</section>
			<div class="slds-backdrop slds-backdrop_open"></div>
		</template>
-->

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
						<h2 id="modal-heading-01" class="slds-text-heading_medium slds-hyphenate">Submit for Approval
						</h2>
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
	</lightning-card>
</template>


======================================== JS		========================================
import { LightningElement, wire, track } from 'lwc';
//import getDemandList from '@salesforce/apex/CustomListViewController.getDemandList';
import updateTotalGroupValue from '@salesforce/apex/CustomListViewController.updateTotalGroupValue';
import submitForApproval from '@salesforce/apex/CustomListViewController.submitForApproval';
import updateDemands from '@salesforce/apex/CustomListViewController.updateDemands';
import retriveCases from '@salesforce/apex/CustomListViewController.retriveCases';
import filteredCasesResult from '@salesforce/apex/CustomListViewController.filteredCases';
import fetchFilterMap from '@salesforce/apex/CustomListViewController.searchValuesResult';
import { refreshApex } from '@salesforce/apex';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//import Price_FIELD from '@salesforce/schema/Case.Price__c';
//import Id_FIELD from '@salesforce/schema/Case.Id';

const columns = [
    {
        label: 'Demand Master Number', fieldName: 'CaseNumber', cellAttributes: { alignment: 'left' }, editable: false, sortable: true,
        cellAttributes: {
            class: 'slds-theme_shade slds-theme_alert-texture'
        }
    },
    // { label: 'Transaction Cycle', fieldName: 'Transaction_Cycle__c', cellAttributes: { alignment: 'left' }, editable: false},
    { label: 'Band', fieldName: 'Band__c', sortable: true, cellAttributes: { alignment: 'left' }, editable: true },
    { label: 'Band for costing', fieldName: 'Band_for_costing__c', sortable: true, cellAttributes: { alignment: 'left' }, editable: true },
    { label: 'Daily Cost', fieldName: 'Daily_Cost__c', cellAttributes: { alignment: 'left' }, editable: true, sortable: true },
    { label: 'Price', fieldName: 'Price__c', cellAttributes: { alignment: 'left' }, editable: true, sortable: true },
    { label: 'Demand Status', fieldName: 'Demand_Status__c', cellAttributes: { alignment: 'left' }, editable: true, sortable: true },
    { label: 'PSL Rate Card', fieldName: 'PSL_Rate_Card__c', cellAttributes: { alignment: 'left' }, editable: true, sortable: true },
    { label: 'PSL Role', fieldName: 'PSL_Role__c', cellAttributes: { alignment: 'left' }, editable: true, sortable: true },
    { label: 'PSL Skillset(Only for', fieldName: 'PSL_Skillset_only_for_Dev_roles__c', cellAttributes: { alignment: 'left' }, editable: true, sortable: true },
    { label: 'Skills - Mapping to PMP', fieldName: 'Skills_Mapping_to_PMP__c', cellAttributes: { alignment: 'left' }, editable: true, sortable: true },
    { label: 'Daily Delivery GP', fieldName: 'Daily_Delivery_GP__c', cellAttributes: { alignment: 'left' }, editable: false, sortable: true },
    { label: 'Daily Release GP', fieldName: 'Daily_Release_GP__c', cellAttributes: { alignment: 'left' }, editable: false, sortable: true },
    { label: 'Solution identifier', fieldName: 'Solution_identifier__c', cellAttributes: { alignment: 'left' }, editable: true, sortable: true },
    { label: 'Total Group Value', fieldName: 'Total_Group_Value__c', cellAttributes: { alignment: 'left' }, editable: false, sortable: true },
    //{ label: 'Skills', fieldName: 'Skills__c', cellAttributes: { alignment: 'left' }, editable: false, hideDefaultActions: true },
    //{ label: 'Location', fieldName: 'Location__c', cellAttributes: { alignment: 'left' }, editable: false, hideDefaultActions: true },

];

export default class CustomListViewPage extends LightningElement {
    isModalOpen = false;
    isGPModalOpen = false;
    isFilterOpen = false;
    error;
    columns = columns;
    rowOffset = 0;
    totalDailyDeliveryGP = 0;
    selectedRows = [];
    message = 'Total Daily Delivery GP : '
    draftValues = [];
    records;
    oldrecordList = [];
    mapData = [];
    wiredRecords;
    @track sortBy;
    @track sortDirection;
    @track ibmDeliveryLead='';
    @track solIdentifier='';
    @track recSize;
    @track htm = '<input type="text" placeholder="Your state" class="data-input"/>';

    onClickAddFilter() {
        this.template.querySelector('.newFilter').innerHTML = this.htm;
    }


    @wire(fetchFilterMap)
    wireMapData({error, data}) {
        if (data) {
            console.log(data);
            var conts = data;
            for(var key in conts){
                this.mapData.push({value:conts[key], key:key});
                console.log('this.mapdata--> ',conts[key]);
                if(key == 'Delivery Lead'){
                    if(conts['Delivery Lead'] !== '' || conts['Delivery Lead'] !== null ){
                        this.ibmDeliveryLead = conts['Delivery Lead'];
                        console.log('this.ibmDeliveryLead wired--> ',this.ibmDeliveryLead );
                    }else{
                        this.ibmDeliveryLead = '';
                    }
                }
                if(key == 'Solution Identifier'){
                    if(conts['Solution Identifier'] !== '' || conts['Solution Identifier'] !== null ){
                        this.solIdentifier = conts['Solution Identifier'];
                        console.log('this.solIdentifier wired--> ',this.solIdentifier );
                    }else{
                        this.solIdentifier ='';
                    }
                }
            }
            this.onClickSearch();
            console.log('records-----> ',this.records);
        } else if (error) {
            this.error = error;
        }
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

    onClickFilter () {
        this.isFilterOpen = true;
    }

    openModal() {
        this.isModalOpen = true;
    }
    closeModal() {
        this.isModalOpen = false;
        this.isGPModalOpen = false;
        this.isFilterOpen = false;
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
            //this.records = this.oldrecordList;
            this.onClickSearch();

        }
    }
    //Added on 15 march 2023
    handleInputSolId(event){
        this.solIdentifier = event.target.value;
    }
    //Added on 15 march 2023
    handleInputIBMDelLead(event){
        this.ibmDeliveryLead = event.target.value
    }
    //Added on 15 march 2023
    onClickSearch(event){
        console.log('solution Identifier----> ',this.solIdentifier);
        console.log('IBM Delivery Lead----> ',this.ibmDeliveryLead);
        
        if (this.ibmDeliveryLead !== '' || this.solIdentifier !=='') {
            console.log('inside click of search button');
            filteredCasesResult({ solIdentifier: this.solIdentifier, deliveryHead: this.ibmDeliveryLead })
                .then(result => {
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
        }else if(this.ibmDeliveryLead == '' && this.solIdentifier ==''){
            console.log('inside click of search button when both search parameters are blank!!');
            filteredCasesResult({ solIdentifier: this.solIdentifier, deliveryHead: this.ibmDeliveryLead })
                .then(result => {
                    //this.records = this.oldrecordList;
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
            //this.records = this.oldrecordList;
            this.records = result;
        }
        this.recSize = this.records.length;
        console.log('at the end of the method..');
        this.isFilterOpen = false; 
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


========================================  CSS  ========================================
.wrapped-header-datatable .slds-table .slds-th__action .slds-truncate{
    max-width: 100%;
    overflow: hidden;
    text-overflow: unset;
    white-space: pre-line;
    /* word-wrap: break-word; * /
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

/* modal popup CSS * /
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
 


/* vertical allignment CSS * /
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


/*
 below working with custom icon  
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

.myTable table>thead .slds-cell-fixed.slds-has-button-menu, .myTable table>thead .slds-cell-fixed.slds-has-button-menu:hover{
  background: antiquewhite;
}
* /

*/  
}