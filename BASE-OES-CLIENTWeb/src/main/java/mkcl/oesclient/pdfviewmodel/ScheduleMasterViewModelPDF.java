package mkcl.oesclient.pdfviewmodel;

import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElementWrapper;
public class ScheduleMasterViewModelPDF {

	String scheduleStartDate;
	String collectionType;
  
	List<CollectionMasterViewModelPDF> collectionMasterViewModelPDFList;
    
	
	
	public String getScheduleStartDate() {
		return scheduleStartDate;
	}
	public void setScheduleStartDate(String scheduleStartDate) {
		this.scheduleStartDate = scheduleStartDate;
	}
	@XmlElementWrapper(name = "listofcollectionPDFData")
	@XmlElement(name = "collectionPDFData")
	public List<CollectionMasterViewModelPDF> getCollectionMasterViewModelPDFList() {
		return collectionMasterViewModelPDFList;
	}
	public void setCollectionMasterViewModelPDFList(
			List<CollectionMasterViewModelPDF> collectionMasterViewModelPDFList) {
		this.collectionMasterViewModelPDFList = collectionMasterViewModelPDFList;
	}
	
	  public String getCollectionType() {
			return collectionType;
		}
		public void setCollectionType(String collectionType) {
			this.collectionType = collectionType;
		}
}
