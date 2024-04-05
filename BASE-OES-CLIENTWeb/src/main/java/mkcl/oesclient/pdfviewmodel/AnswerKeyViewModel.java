package mkcl.oesclient.pdfviewmodel;

public class AnswerKeyViewModel {
	// examEventID" : '${eventID}', "paperID":'${paperobj.paperID}',
	// "langID":'${langID}
	// String candidateID, String eventID,String paperID,String attemptNo
	private Long examEventID;
	private long paperID;
	private String langID;
	private Long candidateID;
	private Integer attemptNo; 
	

	public Long getCandidateID() {
		return candidateID;
	}

	public void setCandidateID(Long candidateID) {
		this.candidateID = candidateID;
	}

	public Integer getAttemptNo() {
		return attemptNo;
	}

	public void setAttemptNo(Integer attemptNo) {
		this.attemptNo = attemptNo;
	}

	public Long getExamEventID() {
		return examEventID;
	}

	public void setExamEventID(Long examEventID) {
		this.examEventID = examEventID;
	}

	public long getPaperID() {
		return paperID;
	}

	public void setPaperID(long paperID) {
		this.paperID = paperID;
	}

	public String getLangID() {
		return langID;
	}

	public void setLangID(String langID) {
		this.langID = langID;
	}

}
