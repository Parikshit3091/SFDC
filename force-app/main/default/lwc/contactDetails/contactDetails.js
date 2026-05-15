import { LightningElement,track,wire } from 'lwc';
import getContactDetails from "@salesforce/apex/ContactController.getContactDetails";
import Object_API_Name from '@salesforce/schema/Contact';
import LightningModal from 'lightning/modal';

const actions = [
    {label:'Edit', name:'edit'},
    {label:'Delete', name:'delete'},
]

const column = [
    {label:"Id", fieldName:"Id"},
    {label:"Name", fieldName:"Name"},
    {label:"Email",fieldName:"Email"},
    {label:"Account Name",fieldName:"Account.Name"},
    {
        type:'action',
        typeAttributes:{
            rowActions:actions,
            menuAlignment:'right'
        }
    }
];


export default class ContactDetails extends LightningElement {

    @track contactData;
    columns = column;
    @track recId;
    @track objApiName;
    @track showEdit;

    @wire(getContactDetails)
    contactsData({error, data}){
        debugger;
        this.showEdit = false;
        console.log('data ### ' + data);
        if(data){
           //this is the final array into which the flattened response will be pushed. 
           /*let contactsArray = [];
            
           for (let row of data) {
                // this const stroes a single flattened row. 
                const flattenedRow = {}
                
                // get keys of a single row — Name, Phone, LeadSource and etc
                let rowKeys = Object.keys(row); 
               
                //iterate 
                rowKeys.forEach((rowKey) => {
                    
                    //get the value of each key of a single row. John, 999-999-999, Web and etc
                    const singleNodeValue = row[rowKey];
                    
                    //check if the value is a node(object) or a string
                    if(singleNodeValue.constructor === Object){
                        
                        //if it's an object flatten it
                        this._flatten(singleNodeValue, flattenedRow, rowKey)        
                    }else{
                        
                        //if it’s a normal string push it to the flattenedRow array
                        flattenedRow[rowKey] = singleNodeValue;
                    }
                    
                });
               
                //push all the flattened rows to the final array 
                contactsArray.push(flattenedRow);
            }*/

            let contactsArray = [];
            for(let index in data){
                let obj = {};
                obj['Id'] = data[index].Id;
                obj['Name'] = data[index].Name;
                obj['Email'] = data[index].Email;
                obj['Account.Name'] = data[index].Account?.Name;
                contactsArray.push(obj);
            }    
            
            //assign the array to an array that's used in the template file
            this.contactData = contactsArray;
        }else if(error){
            console.log(error)
        }
    }

    _flatten = (nodeValue, flattenedRow, nodeName) => {        
        let rowKeys = Object.keys(nodeValue);
        rowKeys.forEach((key) => {
            let finalKey = nodeName + '.'+ key;
            flattenedRow[finalKey] = nodeValue[key];
        })
    }

    handleRowAction(event){
        let rowId = event.detail.row.Id;
        debugger;
        let action = event.detail.action.name;
        if(action == 'edit'){
            this.showEdit = true;
            this.recId = event.detail.row.Id;
            //this.name = 'ABC';
            //this.email = 'abc@gmail.com';
            this.objApiName = Object_API_Name.objectApiName;
        }
        else{

        }
    }

    updateRecord(event){
        event.preventDefault();

    // Get the fields from the submit event
    let fields = event.detail.fields;
    
    // check, compare, modify field values
    console.log(fields.Country);
        debugger;
    }
}