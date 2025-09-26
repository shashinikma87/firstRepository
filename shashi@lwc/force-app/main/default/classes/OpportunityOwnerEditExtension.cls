public with sharing class OpportunityOwnerEditExtension {  
      public Opportunity opportunity;  
      public OpportunityOwnerEditExtension(Apexpages.Standardcontroller stdController){       
           this.opportunity = (Opportunity)stdController.getRecord();  
      }  
      public void save(){  
           Apexpages.Message msg = new Apexpages.Message(Apexpages.Severity.Info, 'Changes saved successfully!');  
           Apexpages.Message error_msg = new Apexpages.Message(Apexpages.Severity.Error, 'An error occurred while saving changes !');  
           if(this.opportunity.Opportunity_Owner__c == null || this.opportunity.Opportunity_Owner__c.equals('')){  
                Apexpages.Message errorMessage = new Apexpages.Message(Apexpages.Severity.Error, '<b>Opportunity Owner<b>: Validation Error: Value is required.');  
                Apexpages.addMessage(errorMessage);  
                return;  
           }  
           try{  
                update this.opportunity;  
                Apexpages.addMessage(msg);  
           } catch(Exception e){  
                Apexpages.addMessage(error_msg);  
                System.debug('@@@@ calling save on OpportunityOwnerEditExtension. Following error occured while saving changes: ' + e);  
           }  
      }  
      public void cancel(){  
      }  
 }