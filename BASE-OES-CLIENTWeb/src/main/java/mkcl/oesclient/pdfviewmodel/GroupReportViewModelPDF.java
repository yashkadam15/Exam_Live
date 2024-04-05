package mkcl.oesclient.pdfviewmodel;

import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElementWrapper;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name = "groupReportPDFData")
public class GroupReportViewModelPDF {

	private String reportName;
	private String examEventName;
	private String locale;
	private List<ScheduleMasterViewModelPDF> scheduleMasterViewModelPDFList;
	
	
	public String getReportName() {
		return reportName;
	}
	public void setReportName(String reportName) {
		this.reportName = reportName;
	}
	public String getExamEventName() {
		return examEventName;
	}
	public void setExamEventName(String examEventName) {
		this.examEventName = examEventName;
	}
	@XmlElementWrapper(name = "listofgroupPDFData")
	@XmlElement(name = "groupReportViewModelData")
	public List<ScheduleMasterViewModelPDF> getScheduleMasterViewModelPDFList() {
		return scheduleMasterViewModelPDFList;
	}
	public void setScheduleMasterViewModelPDFList(
			List<ScheduleMasterViewModelPDF> scheduleMasterViewModelPDFList) {
		this.scheduleMasterViewModelPDFList = scheduleMasterViewModelPDFList;
	}
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
	
	

	
	

	

	
	
}
