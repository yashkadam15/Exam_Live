/**
 * 
 */
package mkcl.oesclient.pdfviewmodel;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author amitk
 *
 */

public class CandidateViewModelPDF {
	private long serialNumber;
	private String candidateLoginID;
	private String candidateCode;
	private String candidatePassword;
	private String candidateFirstName;
	private String candidateMiddleName;
	private String candidateLastName;
	private String candidatePhoto;
	/**
	 * @return the candidatePhoto
	 */
	public String getCandidatePhoto() {
		return candidatePhoto;
	}
	/**
	 * @param candidatePhoto the candidatePhoto to set
	 */
	public void setCandidatePhoto(String candidatePhoto) {
		this.candidatePhoto = candidatePhoto;
	}
	public String getCandidateLoginID() {
		return candidateLoginID;
	}
	public void setCandidateLoginID(String candidateLoginID) {
		this.candidateLoginID = candidateLoginID;
	}
	public String getCandidateCode() {
		return candidateCode;
	}
	public void setCandidateCode(String candidateCode) {
		this.candidateCode = candidateCode;
	}
	public String getCandidatePassword() {
		return candidatePassword;
	}
	public void setCandidatePassword(String candidatePassword) {
		this.candidatePassword = candidatePassword;
	}
	public String getCandidateFirstName() {
		return candidateFirstName;
	}
	public void setCandidateFirstName(String candidateFirstName) {
		this.candidateFirstName = candidateFirstName;
	}
	public String getCandidateMiddleName() {
		return candidateMiddleName;
	}
	public void setCandidateMiddleName(String candidateMiddleName) {
		this.candidateMiddleName = candidateMiddleName;
	}
	public String getCandidateLastName() {
		return candidateLastName;
	}
	public void setCandidateLastName(String candidateLastName) {
		this.candidateLastName = candidateLastName;
	}
	public long getSerialNumber() {
		return serialNumber;
	}
	public void setSerialNumber(long serialNumber) {
		this.serialNumber = serialNumber;
	}
	
	
}
