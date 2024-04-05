package mkcl.oesclient.pdfviewmodel;

import mkcl.baseoesclient.model.LoginType;

public class AnalysisBookletRequestParamViewModel {
	private Long candidateId;
	private Long examEventID;
	private Long paperID;
	private String candidateLoginId;
	private Integer attemptNo;
	private Integer collectionID;
	private LoginType loginType;
	private Long displayCategoryId;
	private Long sectionID;
	
	
	public Long getSectionID() {
		return sectionID;
	}
	public void setSectionID(Long sectionID) {
		this.sectionID = sectionID;
	}
	public Long getCandidateId() {
		return candidateId;
	}
	public void setCandidateId(Long candidateId) {
		this.candidateId = candidateId;
	}
	public Long getExamEventID() {
		return examEventID;
	}
	public void setExamEventID(Long examEventID) {
		this.examEventID = examEventID;
	}
	public Long getPaperID() {
		return paperID;
	}
	public void setPaperID(Long paperID) {
		this.paperID = paperID;
	}
	public String getCandidateLoginId() {
		return candidateLoginId;
	}
	public void setCandidateLoginId(String candidateLoginId) {
		this.candidateLoginId = candidateLoginId;
	}
	public Integer getAttemptNo() {
		return attemptNo;
	}
	public void setAttemptNo(Integer attemptNo) {
		this.attemptNo = attemptNo;
	}
	public Integer getCollectionID() {
		return collectionID;
	}
	public void setCollectionID(Integer collectionID) {
		this.collectionID = collectionID;
	}
	public LoginType getLoginType() {
		return loginType;
	}
	public void setLoginType(LoginType loginType) {
		this.loginType = loginType;
	}
	public Long getDisplayCategoryId() {
		return displayCategoryId;
	}
	public void setDisplayCategoryId(Long displayCategoryId) {
		this.displayCategoryId = displayCategoryId;
	}
	
	
	
	
}
