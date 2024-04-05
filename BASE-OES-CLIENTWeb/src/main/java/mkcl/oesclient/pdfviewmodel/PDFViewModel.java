/**
 * 
 */
package mkcl.oesclient.pdfviewmodel;

import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElementWrapper;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlSeeAlso;

import mkcl.oesclient.viewmodel.ExamDisplayCategoryPaperViewModelPDF;
import mkcl.oesclient.viewmodel.ItemBankAndDifficultyLevelViewModelPDF;
import mkcl.oesclient.viewmodel.ResultAnalysisViewModelPDF;
import mkcl.oesclient.viewmodel.SectionViewModelPDF;

/**
 * @author amitk
 * 
 */
@XmlRootElement(name = "PDFViewModelData")
@XmlSeeAlso({ ExamDisplayCategoryPaperViewModelPDF.class,
		ResultAnalysisViewModelPDF.class
		})
public class PDFViewModel {
	private String righIconpath;
	private String wrongIconpath;
	private String eventName;
	private String candidateFirstName;
	private String candidateMiddleName;
	private String candidateLastName;
	private String candidateUserName;
	private String collectionType;
	private String candidateCollection;
	private String candidateImagePath;
	private int attemptNumber;
	private String locale;
	

	
	private ExamDisplayCategoryPaperViewModelPDF examDispalyCategoryPaperViewModelObj;
	private ResultAnalysisViewModelPDF resultAnalysisViewModelObj;
	private ItemBankAndDifficultyLevelViewModelPDF itemBankAndDifficultyLevelViewModelPDF;
	private ItemBankAndDifficultyLevelViewModelPDF difficultyLevelViewModelPDF;

	private String bestArea;
	private String weakArea;
	private List<Long> listRankDigits;
	private List<Long> listRankDigitsWithZero;
	private List<Long> listRankOutOfDigits;
	private List<SectionViewModelPDF> listOfSectionViewModelPDF;
	
	/**
	 * 
	 * topic wise analysis
	 */

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
	 * @return the attemptNumber
	 */
	public int getAttemptNumber() {
		return attemptNumber;
	}

	
	/**
	 * @return the listOfSectionViewModelPDF
	 */
	@XmlElementWrapper(name = "listofSectionviewModel")
	@XmlElement(name = "sectionviewModel")
	public List<SectionViewModelPDF> getListOfSectionViewModelPDF() {
		return listOfSectionViewModelPDF;
	}


	/**
	 * @param listOfSectionViewModelPDF the listOfSectionViewModelPDF to set
	 */
	public void setListOfSectionViewModelPDF(
			List<SectionViewModelPDF> listOfSectionViewModelPDF) {
		this.listOfSectionViewModelPDF = listOfSectionViewModelPDF;
	}


	/**
	 * @param attemptNumber the attemptNumber to set
	 */
	public void setAttemptNumber(int attemptNumber) {
		this.attemptNumber = attemptNumber;
	}


	public ResultAnalysisViewModelPDF getResultAnalysisViewModelObj() {
		return resultAnalysisViewModelObj;
	}

	public String getRighIconpath() {
		return righIconpath;
	}

	public void setRighIconpath(String righIconpath) {
		this.righIconpath = righIconpath;
	}

	public String getWrongIconpath() {
		return wrongIconpath;
	}

	public void setWrongIconpath(String wrongIconpath) {
		this.wrongIconpath = wrongIconpath;
	}

	public String getCandidateImagePath() {
		return candidateImagePath;
	}

	public void setCandidateImagePath(String candidateImagePath) {
		this.candidateImagePath = candidateImagePath;
	}

	public String getEventName() {
		return eventName;
	}

	public void setEventName(String eventName) {
		this.eventName = eventName;
	}

	/**
	 * @return the collectionType
	 */
	public String getCollectionType() {
		return collectionType;
	}


	/**
	 * @param collectionType the collectionType to set
	 */
	public void setCollectionType(String collectionType) {
		this.collectionType = collectionType;
	}


	/**
	 * @return the candidateCollection
	 */
	public String getCandidateCollection() {
		return candidateCollection;
	}


	/**
	 * @param candidateCollection the candidateCollection to set
	 */
	public void setCandidateCollection(String candidateCollection) {
		this.candidateCollection = candidateCollection;
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

	public String getCandidateUserName() {
		return candidateUserName;
	}

	public void setCandidateUserName(String candidateUserName) {
		this.candidateUserName = candidateUserName;
	}



	public String getBestArea() {
		return bestArea;
	}

	public void setBestArea(String bestArea) {
		this.bestArea = bestArea;
	}

	public String getWeakArea() {
		return weakArea;
	}

	public void setWeakArea(String weakArea) {
		this.weakArea = weakArea;
	}


	public void setResultAnalysisViewModelObj(
			ResultAnalysisViewModelPDF resultAnalysisViewModelObj) {
		this.resultAnalysisViewModelObj = resultAnalysisViewModelObj;
	}

	public ItemBankAndDifficultyLevelViewModelPDF getDifficultyLevelViewModelPDF() {
		return difficultyLevelViewModelPDF;
	}

	public void setDifficultyLevelViewModelPDF(
			ItemBankAndDifficultyLevelViewModelPDF difficultyLevelViewModelPDF) {
		this.difficultyLevelViewModelPDF = difficultyLevelViewModelPDF;
	}

	public ItemBankAndDifficultyLevelViewModelPDF getItemBankAndDifficultyLevelViewModelPDF() {
		return itemBankAndDifficultyLevelViewModelPDF;
	}

	public void setItemBankAndDifficultyLevelViewModelPDF(
			ItemBankAndDifficultyLevelViewModelPDF itemBankAndDifficultyLevelViewModelPDF) {
		this.itemBankAndDifficultyLevelViewModelPDF = itemBankAndDifficultyLevelViewModelPDF;
	}



	public PDFViewModel() {
		super();
		// TODO Auto-generated constructor stub
	}


	public ExamDisplayCategoryPaperViewModelPDF getExamDispalyCategoryPaperViewModelObj() {
		return examDispalyCategoryPaperViewModelObj;
	}

	public void setExamDispalyCategoryPaperViewModelObj(
			ExamDisplayCategoryPaperViewModelPDF examDispalyCategoryPaperViewModelObj) {
		this.examDispalyCategoryPaperViewModelObj = examDispalyCategoryPaperViewModelObj;
	}

	@XmlElementWrapper(name = "listRankDigits")
	@XmlElement(name = "rankdigits")
	public List<Long> getListRankDigits() {
		return listRankDigits;
	}

	public void setListRankDigits(List<Long> listRankDigits) {
		this.listRankDigits = listRankDigits;
	}

	@XmlElementWrapper(name = "listRankDigitsWithZero")
	@XmlElement(name = "rankdigitswithzero")
	public List<Long> getListRankDigitsWithZero() {
		return listRankDigitsWithZero;
	}

	public void setListRankDigitsWithZero(List<Long> listRankDigitsWithZero) {
		this.listRankDigitsWithZero = listRankDigitsWithZero;
	}

	@XmlElementWrapper(name = "listRankOutOfDigits")
	@XmlElement(name = "RankOutOfDigits")
	public List<Long> getListRankOutOfDigits() {
		return listRankOutOfDigits;
	}

	public void setListRankOutOfDigits(List<Long> listRankOutOfDigits) {
		this.listRankOutOfDigits = listRankOutOfDigits;
	}

	

}
