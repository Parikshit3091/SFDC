import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getRecords from '@salesforce/apex/CustomLookupController.getRecords';
import fetchRelatedRecords from '@salesforce/apex/CustomLookupController.getRelatedRecords';

export default class CustomLookup extends LightningElement {
    _objectApiName;
    _selectedParentId;

    @api label = 'Search Records';
    @api placeholder = 'Search...';
    @api required = false;

    searchKey = '';
    selectedRecordId;
    records = [];
    showOptions = false;
    isLoading = false;
    requestId = 0;

    @api
    get objectApiName() {
        return this._objectApiName;
    }

    set objectApiName(value) {
        this._objectApiName = value;
        this.loadRelatedRecords();
    }

    @api
    get selectedParentId() {
        return this._selectedParentId;
    }

    set selectedParentId(value) {
        if (value === this._selectedParentId) {
            return;
        }
        this._selectedParentId = value;
        this.loadRelatedRecords();
    }

    @api
    get value() {
        return this.selectedRecordId;
    }

    set value(recordId) {
        this.selectedRecordId = recordId;
    }

    async loadRelatedRecords() {
        const parentId = this._selectedParentId;
        const objectApiName = this._objectApiName;
        const requestId = ++this.requestId;

        if (!parentId || !objectApiName) {
            this.records = [];
            this.showOptions = false;
            this.isLoading = false;
            return;
        }

        this.isLoading = true;
        try {
            const records = await fetchRelatedRecords({ parentId, objectApiName });
            if (requestId === this.requestId) {
                this.records = records || [];
                this.showOptions = this.records.length > 0;
            }
        } catch (error) {
            if (requestId === this.requestId) {
                this.records = [];
                this.showOptions = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error loading records',
                        message:
                            error.body?.message ||
                            error.message ||
                            'An unexpected error occurred.',
                        variant: 'error'
                    })
                );
            }
        } finally {
            if (requestId === this.requestId) {
                this.isLoading = false;
            }
        }
    }

    async handleInputChange(event) {
        const previousRecordId = this.selectedRecordId;
        this.selectedRecordId = null;
        this.searchKey = event.detail.value;
        this.records = [];
        this.showOptions = false;

        if (previousRecordId) {
            this.dispatchSelection(null, null);
        }

        const searchKey = this.searchKey.trim();
        const requestId = ++this.requestId;
        if (!searchKey) {
            this.isLoading = false;
            return;
        }

        this.isLoading = true;
        try {
            const records = await getRecords({
                searchKey,
                objectApiName: this.objectApiName,
                parentId: this.selectedParentId
            });
            if (requestId === this.requestId) {
                this.records = records;
                this.showOptions = records.length > 0;
            }
        } catch (error) {
            if (requestId === this.requestId) {
                this.records = [];
                this.showOptions = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error loading records',
                        message:
                            error.body?.message ||
                            error.message ||
                            'An unexpected error occurred.',
                        variant: 'error'
                    })
                );
            }
        } finally {
            if (requestId === this.requestId) {
                this.isLoading = false;
            }
        }
    }

    handleRecordSelect(event) {
        const recordId = event.currentTarget.dataset.recordId;
        const selectedRecord = this.records.find((record) => record.Id === recordId);
        if (!selectedRecord) {
            return;
        }

        this.selectedRecordId = selectedRecord.Id;
        this.searchKey = selectedRecord.Name;
        this.records = [];
        this.showOptions = false;
        this.isLoading = false;
        this.requestId += 1;
        this.dispatchSelection(selectedRecord.Id, selectedRecord);
    }

    @api
    clearSelection() {
        this.requestId += 1;
        this.isLoading = false;
        this.selectedRecordId = null;
        this.searchKey = '';
        this.records = [];
        this.showOptions = false;
        this.dispatchSelection(null, null);
    }

    dispatchSelection(recordId, record) {
        this.dispatchEvent(
            new CustomEvent('recordchange', {
                detail: { recordId, record }
            })
        );
    }
}