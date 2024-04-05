package mkcl.oesclient.pdfviewmodel;

import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElementWrapper;
import javax.xml.bind.annotation.XmlRootElement;

import mkcl.oesclient.viewmodel.ViewModelCandidateAcademicSummaryReport;
import mkcl.oesclient.viewmodel.ViewModelCandidateAcademicSummaryReportForPDF;

//@XmlRootElement(name = "candAcademicSummaryReportPDFData")
public class CandidateAcademicSummaryViewModelPDF {

	private List<ViewModelCandidateAcademicSummaryReportForPDF> candidateAcademicSummaryReportPdfViewModel;
	private String locale;

	public String getLocale() {
		return locale;
	}

	public void setLocale(String locale) {
		this.locale = locale;
	}

	/*@XmlElementWrapper(name = "listofCandidateSummaryReportPDFData")
	@XmlElement(name = "candidateSummaryReportPDFData")*/
	public List<ViewModelCandidateAcademicSummaryReportForPDF> getCandidateAcademicSummaryReports() {
		return candidateAcademicSummaryReportPdfViewModel;
	}

	public void setCandidateAcademicSummaryReports(
			List<ViewModelCandidateAcademicSummaryReportForPDF> candidateAcademicSummaryReports) {
		this.candidateAcademicSummaryReportPdfViewModel = candidateAcademicSummaryReports;
	}

}
