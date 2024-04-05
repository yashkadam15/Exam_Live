package mkcl.oesclient.pdfviewmodel;

import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElementWrapper;
import javax.xml.bind.annotation.XmlRootElement;

import mkcl.oespcs.viewmodel.CandidateAttemptPDF;

@XmlRootElement(name = "CandidateAttemptPDFModel")
public class CandidateAttemptPDFViewModel {
	private String locale;
	private String eventName;
	private String candidateCode;
	private String attemptedDate;
	private String venueCode;
	private String venueName;
	private long paperID;
	private String paperName;
	private String firstName;
	private String middleName;
	private String lastName;
	private long attemptNo;
	private boolean examStatus;
	private String totQuestions;
	private long attemptedQuestions;
	private long remainingQuestios;
	private String marksObtained;
	private List<CandidateAttemptPDF> attemptPDFs;	
	private String candidatePaperLanguage;
	
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
	
	/**
	 * @return the eventName
	 */
	public String getEventName() {
		return eventName;
	}
	/**
	 * @param eventName the eventName to set
	 */
	public void setEventName(String eventName) {
		this.eventName = eventName;
	}
	/**
	 * @return the attemptPDFs
	 */
	@XmlElementWrapper(name = "CandidateAttemptReportList")
	@XmlElement(name = "CandidateAttemptReport")
	public List<CandidateAttemptPDF> getAttemptPDFs() {
		return attemptPDFs;
	}
	/**
	 * @param attemptPDFs the attemptPDFs to set
	 */
	public void setAttemptPDFs(List<CandidateAttemptPDF> attemptPDFs) {
		this.attemptPDFs = attemptPDFs;
	}
	
	/**
	 * @return the attemptedDate
	 */
	public String getAttemptedDate() {
		return attemptedDate;
	}
	/**
	 * @param attemptedDate the attemptedDate to set
	 */
	public void setAttemptedDate(String attemptedDate) {
		this.attemptedDate = attemptedDate;
	}
	/**
	 * @return the venueCode
	 */
	public String getVenueCode() {
		return venueCode;
	}
	/**
	 * @param venueCode the venueCode to set
	 */
	public void setVenueCode(String venueCode) {
		this.venueCode = venueCode;
	}
	/**
	 * @return the venueName
	 */
	public String getVenueName() {
		return venueName;
	}
	/**
	 * @param venueName the venueName to set
	 */
	public void setVenueName(String venueName) {
		this.venueName = venueName;
	}
	/**
	 * @return the paperID
	 */
	public long getPaperID() {
		return paperID;
	}
	/**
	 * @param paperID the paperID to set
	 */
	public void setPaperID(long paperID) {
		this.paperID = paperID;
	}
	/**
	 * @return the paperName
	 */
	public String getPaperName() {
		return paperName;
	}
	/**
	 * @param paperName the paperName to set
	 */
	public void setPaperName(String paperName) {
		this.paperName = paperName;
	}
	
	/**
	 * @return the firstName
	 */
	public String getFirstName() {
		return firstName;
	}
	/**
	 * @param firstName the firstName to set
	 */
	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}
	/**
	 * @return the candidateCode
	 */
	public String getCandidateCode() {
		return candidateCode;
	}
	/**
	 * @param candidateCode the candidateCode to set
	 */
	public void setCandidateCode(String candidateCode) {
		this.candidateCode = candidateCode;
	}
	
	/**
	 * @return the attemptNo
	 */
	public long getAttemptNo() {
		return attemptNo;
	}
	/**
	 * @param attemptNo the attemptNo to set
	 */
	public void setAttemptNo(long attemptNo) {
		this.attemptNo = attemptNo;
	}
	/**
	 * @return the examStatus
	 */
	public boolean isExamStatus() {
		return examStatus;
	}
	/**
	 * @param examStatus the examStatus to set
	 */
	public void setExamStatus(boolean examStatus) {
		this.examStatus = examStatus;
	}
	
	/**
	 * @return the totQuestions
	 */
	public String getTotQuestions() {
		return totQuestions;
	}
	/**
	 * @param totQuestions the totQuestions to set
	 */
	public void setTotQuestions(String totQuestions) {
		this.totQuestions = totQuestions;
	}
	/**
	 * @return the attemptedQuestions
	 */
	public long getAttemptedQuestions() {
		return attemptedQuestions;
	}
	/**
	 * @param attemptedQuestions the attemptedQuestions to set
	 */
	public void setAttemptedQuestions(long attemptedQuestions) {
		this.attemptedQuestions = attemptedQuestions;
	}
	/**
	 * @return the remainingQuestios
	 */
	public long getRemainingQuestios() {
		return remainingQuestios;
	}
	/**
	 * @param remainingQuestios the remainingQuestios to set
	 */
	public void setRemainingQuestios(long remainingQuestios) {
		this.remainingQuestios = remainingQuestios;
	}
	/**
	 * @return the marksObtained
	 */
	public String getMarksObtained() {
		return marksObtained;
	}
	/**
	 * @param marksObtained the marksObtained to set
	 */
	public void setMarksObtained(String marksObtained) {
		this.marksObtained = marksObtained;
	}
	/**
	 * @return the middleName
	 */
	public String getMiddleName() {
		return middleName;
	}
	/**
	 * @param middleName the middleName to set
	 */
	public void setMiddleName(String middleName) {
		this.middleName = middleName;
	}
	/**
	 * @return the lastName
	 */
	public String getLastName() {
		return lastName;
	}
	/**
	 * @param lastName the lastName to set
	 */
	public void setLastName(String lastName) {
		this.lastName = lastName;
	}
	/**
	 * @return the candidatePaperLanguage
	 */
	public String getCandidatePaperLanguage() {
		return candidatePaperLanguage;
	}
	/**
	 * @param candidatePaperLanguage the candidatePaperLanguage to set
	 */
	public void setCandidatePaperLanguage(String candidatePaperLanguage) {
		this.candidatePaperLanguage = candidatePaperLanguage;
	}
	
}
