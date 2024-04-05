package mkcl.oesclient.pdfviewmodel;
import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElementWrapper;

import mkcl.oesclient.model.Candidate;
public class GroupMasterViewModelPDF {
    long firstGroup;
	String groupName;
	long noOFCandidate;
	List<Candidate> candidateList;
	public String getGroupName() {
		return groupName;
	}
	public void setGroupName(String groupName) {
		this.groupName = groupName;
	}
	
	@XmlElementWrapper(name = "listcandidatePDFData")
	@XmlElement(name = "candiatePDFData")
	public List<Candidate> getCandidateList() {
		return candidateList;
	}
	public void setCandidateList(List<Candidate> candidateList) {
		this.candidateList = candidateList;
	}
	
	public long getNoOFCandidate() {
		return noOFCandidate;
	}
	public void setNoOFCandidate(long noOFCandidate) {
		this.noOFCandidate = noOFCandidate;
	}
	public long getFirstGroup() {
		return firstGroup;
	}
	public void setFirstGroup(long firstGroup) {
		this.firstGroup = firstGroup;
	}
	
	
	
}
