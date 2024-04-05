/**
 * 
 */
package mkcl.oesclient.pdfviewmodel;

import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElementWrapper;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author amitk
 * 
 */

@XmlRootElement(name = "candLoginReportPDFData")

public class LoginReportViewModelPDF {
	private String eventName;
	private String candidateCollectionType;
	private String eventCollectionType;
	private String locale;
	private List<CandidateViewModelPDF> listOfCandidateViewModelPDF;

	
	/**
	 * @return the locale
	 */
	public String getLocale() {
		return locale;
	}

	/**
	 * @param locale the locale to set
	 */
	public void setLocale(String locale) {
		this.locale = locale;
	}

	@XmlElementWrapper(name = "listofCandidatePDFData")
	@XmlElement(name = "candidateViewModelData")
	public List<CandidateViewModelPDF> getListOfCandidateViewModelPDF() {
		return listOfCandidateViewModelPDF;
	}

	public String getCandidateCollectionType() {
		return candidateCollectionType;
	}

	public void setCandidateCollectionType(String candidateCollectionType) {
		this.candidateCollectionType = candidateCollectionType;
	}

	public String getEventCollectionType() {
		return eventCollectionType;
	}

	public void setEventCollectionType(String eventCollectionType) {
		this.eventCollectionType = eventCollectionType;
	}

	public void setListOfCandidateViewModelPDF(
			List<CandidateViewModelPDF> listOfCandidateViewModelPDF) {
		this.listOfCandidateViewModelPDF = listOfCandidateViewModelPDF;
	}

	public String getEventName() {
		return eventName;
	}

	public void setEventName(String eventName) {
		this.eventName = eventName;
	}

	
	
	

}
