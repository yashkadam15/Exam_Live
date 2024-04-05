package mkcl.oesclient.pdfviewmodel;
import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElementWrapper;
public class CollectionMasterViewModelPDF {


	private long noOfCollectionCandidate;	
	private String collectionName;


	List<GroupMasterViewModelPDF> groupMasterViewModelPDFList;
	public String getCollectionName() {

		return collectionName;
	}
	public void setCollectionName(String collectionName) {
		this.collectionName = collectionName;
	}


	public long getNoOfCollectionCandidate() {
		return noOfCollectionCandidate;
	}
	public void setNoOfCollectionCandidate(long noOfCollectionCandidate) {
		this.noOfCollectionCandidate = noOfCollectionCandidate;
	}
	@XmlElementWrapper(name = "listofgroupMasterPDFData")
	@XmlElement(name = "groupMasterPDFData")
	public List<GroupMasterViewModelPDF> getGroupMasterViewModelPDFList() {
		return groupMasterViewModelPDFList;
	}
	public void setGroupMasterViewModelPDFList(
			List<GroupMasterViewModelPDF> groupMasterViewModelPDFList) {
		this.groupMasterViewModelPDFList = groupMasterViewModelPDFList;
	}


}
