public with sharing class ShipmentLabelPDF {
	public String gifLabelURL {get; set;}
	private Id gifLabelId;
	
    	public ShipmentLabelPDF() {
    		this.gifLabelId = ApexPages.currentPage().getParameters().get('id');
    		this.gifLabelURL = '/servlet/servlet.FileDownload?file=0693k00000G7OrwAAF';
	}
}