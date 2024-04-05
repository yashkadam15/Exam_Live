/**
 * 
 */
package mkcl.oesclient.solo.controllers;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringEscapeUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import mkcl.baseoesclient.model.LoginType;
import mkcl.oes.commons.ExamHelper;
import mkcl.oesclient.admin.services.IUserServices;
import mkcl.oesclient.admin.services.UserServicesImpl;
import mkcl.oesclient.commons.services.ExamEventServiceImpl;
import mkcl.oesclient.commons.services.IOESPartnerService;
import mkcl.oesclient.commons.services.OESPartnerServiceImpl;
import mkcl.oesclient.commons.services.PaperServiceImpl;
import mkcl.oesclient.commons.utilities.Constants;
import mkcl.oesclient.commons.utilities.FileUploadHelper;
import mkcl.oesclient.commons.utilities.GatewayConstants;
import mkcl.oesclient.commons.utilities.SmartTagHelper;
import mkcl.oesclient.model.Candidate;
import mkcl.oesclient.model.ItemStatus;
import mkcl.oesclient.model.VenueUser;
import mkcl.oesclient.pdfgenerator.PDFComponent;
import mkcl.oesclient.pdfviewmodel.AnalysisBookletRequestParamViewModel;
import mkcl.oesclient.pdfviewmodel.PDFViewModel;
import mkcl.oesclient.solo.services.CandidateServiceImpl;
import mkcl.oesclient.solo.services.IResultAnalysisServices;
import mkcl.oesclient.solo.services.IpdfServices;
import mkcl.oesclient.solo.services.PDFServicesImpl;
import mkcl.oesclient.solo.services.QuestionByQusetionAnalysisServicesImpl;
import mkcl.oesclient.solo.services.ResultAnalysisServicesImpl;
import mkcl.oesclient.solo.services.SectionServiceImpl;
import mkcl.oesclient.typingtest.services.TypingTestService;
import mkcl.oesclient.utilities.HTMLToPDFHelper;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.oesclient.viewmodel.CandidateAnswerViewModelPDF;
import mkcl.oesclient.viewmodel.ExamDisplayCategoryPaperViewModel;
import mkcl.oesclient.viewmodel.ExamDisplayCategoryPaperViewModelPDF;
import mkcl.oesclient.viewmodel.ExamViewModel;
import mkcl.oesclient.viewmodel.ItemAnswersViewModel;
import mkcl.oesclient.viewmodel.ItemBankAndDifficultyLevelViewModel;
import mkcl.oesclient.viewmodel.ItemBankAndDifficultyLevelViewModelPDF;
import mkcl.oesclient.viewmodel.LoginReportViewModel;
import mkcl.oesclient.viewmodel.MultipleChoiceSingleCorrectViewModelPDF;
import mkcl.oesclient.viewmodel.OptionSingleCorrectViewModelPDF;
import mkcl.oesclient.viewmodel.ResultAnalysisViewModel;
import mkcl.oesclient.viewmodel.ResultAnalysisViewModelPDF;
import mkcl.oesclient.viewmodel.SectionItemBankViewModel;
import mkcl.oesclient.viewmodel.SectionViewModelPDF;
import mkcl.oesclient.viewmodel.TypingResultAnalysisViewModel;
import mkcl.oespcs.model.ExamEvent;
import mkcl.oespcs.model.ExamEventPaperDetails;
import mkcl.oespcs.model.OESPartnerMaster;
import mkcl.oespcs.model.PaperType;
import mkcl.oespcs.model.Section;
import mkcl.oespcs.model.ShowResultType;
import mkcl.oespcs.model.TemplateType;
import mkcl.oesserver.model.DifficultyLevel;
import mkcl.oesserver.model.Item;
import mkcl.oesserver.model.ItemType;
import mkcl.oesserver.model.OptionMultipleCorrect;
import mkcl.oesserver.model.OptionPictureIdentification;
import mkcl.oesserver.model.OptionSingleCorrect;
import mkcl.oesserver.model.OptionSubItem;
import mkcl.oesserver.model.PictureIdentificatonImg;
import mkcl.oesserver.model.SubItem;
import net.sf.saxon.functions.*;;

//Modified by Reena for setting based client 03-dec2013
/**
 * @author virajd,reenak,amitk(for pdf part)
 * 
 */
@Controller
@RequestMapping("ResultAnalysis")
public class ResultAnalysisController {
	private static final Logger LOGGER = LoggerFactory.getLogger(ResultAnalysisController.class);
	private static final String EXAMEVENTID = "examEventId";
	private static final String PAPERID = "paperId";
	private static final String ATTEMPTNO = "attemptNo";
	private static final String CANDIDATEID = "candidateId";
	private static final String COLLECTIONID = "collectionId";
	// private static final String SUBJECTID = "subjectId";
	private static final String DISPLAYCATEGORYID = "displayCategoryId";
	private static final String CANDIDATENAME = "candidateName";
	private static final String ISADMIN = "isAdmin";
	private static final String ITEMNO = "itemNo";
	private static final String WRONG_ICON_PATH = "resources/images/wrong.jpg";
	private static final String RIGHT_ICON_PATH = "resources/images/tick.jpg";
	private static final String RELATIVE_PATH = "resources/WebFiles/UserImages/";
	private static final String DEFAULT_CANDIDATE_IMAGE_PATH = "resources/WebFiles/UserImages/defaultCandidate.jpg";
	// private static final String EXAMSUBJECTPAPERVIEWMODELOBJ =
	// "examSubjectPaperViewModelObj";
	private static final String EXAMDISPLAYCATEGORYPAPERVIEWMODELOBJ = "examDisplayCategoryPaperViewModelObj";
	private static final String ITEMBANKANDDIFFICULTYLEVELVIEWMODELOBJ = "itemBankAndDifficultyLevelViewModelObj";
	private static final String LOGINTYPE = "loginType";

	private static final int TEN = 10;

	/**
	 * Post method to View Test Score
	 * @param model
	 * @param candidateId
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/viewtestscore" }, method = { RequestMethod.GET,
			RequestMethod.POST })
	public String viewtestscoreGet(
			Model model,
			@RequestParam(value = CANDIDATEID, required = false) String candidateId,
			HttpServletRequest request) {
		try {
			String examEventID = request.getParameter(EXAMEVENTID);
			String paperID = request.getParameter(PAPERID);
			String attemptNO = request.getParameter(ATTEMPTNO);
			long examEventId = 0;
			long paperId = 0;
			long candidateID = 0;
			long attemptNo = 0;
			TypingResultAnalysisViewModel resultAnalysisViewModel = null;
			
			// added this for Diabetes Admin Login
			int isddt=0;
			if(request.getParameter("ddt")!=null && request.getParameter("ddt").equals("1"))
			{
				isddt=Integer.parseInt(request.getParameter("ddt"));
			}

			if (examEventID != null && !examEventID.equals("")) {
				examEventId = Long.valueOf(examEventID);
			}
			if (paperID != null && !paperID.equals("")) {
				paperId = Long.valueOf(paperID);
			}

			// Set Attempt no.=1 if login type is Group
			LoginType objLoginType = SessionHelper.getLoginType(request);
			if (objLoginType != null && objLoginType.equals(LoginType.Group)) {
				attemptNo = 1;
			} else if (attemptNO != null && !attemptNO.equals("")) {
				attemptNo = Long.valueOf(attemptNO);
			}

			if (candidateId == null) {
				Candidate candidate = SessionHelper.getCandidate(request);
				if (candidate != null) {
					candidateID = candidate.getCandidateID();
				}
			} else {
				candidateID = Long.valueOf(candidateId);
			}

			// Get selected section id
			String sectionId = request.getParameter("sectionId");
			if (sectionId != null && !sectionId.equals("")) {
				model.addAttribute("sectionId", sectionId);
			} else {
				sectionId = "0";
				model.addAttribute("sectionId", sectionId);
			}

			String collectionId = request.getParameter(COLLECTIONID);
			String displayCategoryId = request.getParameter(DISPLAYCATEGORYID);
			String loginType = request.getParameter(LOGINTYPE);

			if (sectionId != null && Long.valueOf(sectionId) != 0) {
				return "redirect:/ResultAnalysis/questionByquestion?examEventId="
						+ examEventId
						+ "&paperId="
						+ paperId
						+ "&candidateId="
						+ candidateId
						+ "&collectionId="
						+ collectionId
						+ "&displayCategoryId="
						+ displayCategoryId
						+ "&loginType="
						+ loginType
						+ "&attemptNo="
						+ attemptNo
						+ "&sectionId=" + sectionId;
			}

			// get user role
			VenueUser user = SessionHelper.getLogedInUser(request);

			// get candidate object
			CandidateServiceImpl objCandidateServiceImpl = new CandidateServiceImpl();
			Candidate objCandidate = objCandidateServiceImpl
					.getCandidateByCandidateID(candidateID);
			String szCandidateName = "";
			if (objCandidate != null) {
				if (objCandidate.getCandidateFirstName() != null) {
					szCandidateName = objCandidate.getCandidateFirstName()
							+ " ";
				}
				if (objCandidate.getCandidateLastName() != null) {
					szCandidateName = szCandidateName
							+ objCandidate.getCandidateLastName();
				}
			}

			if (objCandidate != null) {
				model.addAttribute("candidateLoginId",
						objCandidate.getCandidateUserName());
			}
			if (user != null) {
				model.addAttribute(ISADMIN, user.getFkRoleID());
			}

			model.addAttribute(EXAMEVENTID, examEventId);
			model.addAttribute(PAPERID, paperId);
			model.addAttribute(ATTEMPTNO, attemptNo);
			model.addAttribute(COLLECTIONID, collectionId);
			model.addAttribute(DISPLAYCATEGORYID, displayCategoryId);
			model.addAttribute(CANDIDATEID, candidateID);
			model.addAttribute(LOGINTYPE, loginType);

			// test whether paper is of type TYPING
			PaperServiceImpl paperServicesObj = new PaperServiceImpl();
			PaperType paperType = paperServicesObj.getpaperByPaperID(paperId)
					.getPaperType();

			switch (paperType) {
			case Typing:
				TypingTestService servicesObj = new TypingTestService();
				resultAnalysisViewModel = servicesObj
						.getResultAnalysisViewModelTyping(candidateID,
								examEventId, paperId, attemptNo);
				// calculate gross speed
				int totalCharTyped = resultAnalysisViewModel
						.getTotalCharTyped();
				double grossSpeed = (totalCharTyped / 5)
						/ resultAnalysisViewModel.getDuration();
				resultAnalysisViewModel.setGrossSpeed(Math.round(grossSpeed));
				model.addAttribute("resultAnalysisViewModel",
						resultAnalysisViewModel);
				servicesObj = null;

				// to display beck to era button
				if (SessionHelper.getPartnerObject(request) != null) {
					model.addAttribute(
							"oesPartnerMaster",
							new OESPartnerServiceImpl().getOESPartnerMaster(Long
									.parseLong(SessionHelper.getPartnerObject(
											request).get(
													GatewayConstants.PARTNERID))));
				}
				
				ExamEventServiceImpl eventServiceImpl=new ExamEventServiceImpl();
				ExamEventPaperDetails examEventPaperDetails= eventServiceImpl.getExamEventPaperDetails(examEventId, paperId);
				String showtypscorecard= request.getParameter("showtypsc");
				// below code execute only when user going to see score card for typing test on confidential dashboard history
				if (examEventPaperDetails !=null && ShowResultType.No.equals(examEventPaperDetails.getShowResultType()) && showtypscorecard !=null && showtypscorecard.equals("1")) {
					String ceid = request.getParameter("ceid");
					String resultText=SmartTagHelper.getListOfReplacedTemplateTextFortyping(ceid,TemplateType.Result,request).get(0);					
					model.addAttribute("resultText",resultText);
				}
								
				model.addAttribute("showtypscorecard", showtypscorecard);
				model.addAttribute("examEventPaperDetails", examEventPaperDetails);
				return "Solo/candidateModule/viewtestscoreTyping";

			case careerInclination:
				return "redirect:../CareerInclinationTestReport/careerInclinationTestReport?candidateUserName="
				+ objCandidate.getCandidateUserName();
			case VisualArtInclination:
				model.asMap().clear();
				//return "redirect:../ArtInclinationTestReport/artInclinationTestReport?candidateUserName="+objCandidate.getCandidateUserName();
				return "redirect:../ArtInclinationTestReport/artInclinationTestReport?candidateUserName="+objCandidate.getCandidateUserName()+"&examEventId="+examEventID+"&paperId="+paperID+"&attemptNo="+attemptNo;
			case ShortVisualArtInclination:
				model.asMap().clear();
				return "redirect:../ShortArtInclinationTestReport/shortArtInclinationTestReport?candidateUserName="+objCandidate.getCandidateUserName()+"&examEventId="+examEventID+"&paperId="+paperID+"&attemptNo="+attemptNo;
			case DiabetesDiagnostic:
				if(isddt==0)
				{
					model.asMap().clear();
					return "redirect:../DiabetesDiagnosticTestReport/diabetesDiagnosticTestReport?candidateUserName="+objCandidate.getCandidateUserName()+"&examEventId="+examEventID+"&paperId="+paperID+"&attemptNo="+attemptNo;
				}
				break;
			default:
				break;
			}

			ResultAnalysisServicesImpl resultAnalysisServicesImplObj = new ResultAnalysisServicesImpl();
			ExamDisplayCategoryPaperViewModel examDisplayCategoryPaperViewModelObj = new ExamDisplayCategoryPaperViewModel();
			examDisplayCategoryPaperViewModelObj = resultAnalysisServicesImplObj
					.getPaperDetails(paperId, examEventId, candidateID,
							attemptNo, Long.valueOf(sectionId));

			ResultAnalysisViewModel resultAnalysisViewModelObj = new ResultAnalysisViewModel();
			resultAnalysisViewModelObj = resultAnalysisServicesImplObj
					.getBriefResultDetails(examEventId, paperId, candidateID,
							attemptNo);

			List<Long> listRankDigits = getDigitArray(resultAnalysisViewModelObj
					.getRank());
			List<Long> listRankOutOfDigits = getDigitArray(resultAnalysisViewModelObj
					.getRankOutOf());

			// display preceding zero in rank on view page
			int diff = 0;
			if (listRankDigits != null && listRankOutOfDigits != null) {
				diff = listRankOutOfDigits.size() - listRankDigits.size();
			}

			List<Long> listRankDigitsWithZero = new ArrayList<Long>();
			for (int i = 0; i < diff; i++) {
				listRankDigitsWithZero.add(0l);
			}

			// set total marks for Incorrect to -0.0
			// if no incorrect question found
			if (resultAnalysisViewModelObj.getTotalMarksObtainedForInCorrect() == 0.0) {
				resultAnalysisViewModelObj
				.setTotalMarksObtainedForInCorrect(-0.0);
			}

			// check isSectionRequired or not
			SectionServiceImpl sectionServiceImpl = new SectionServiceImpl();
			if (examDisplayCategoryPaperViewModelObj.getPaper()
					.getIsSectionRequired()) {
				List<Section> sectionList = sectionServiceImpl
						.getSectionListByPaperId(paperId);
				model.addAttribute("sectionList", sectionList);
			}

			model.addAttribute(CANDIDATENAME, szCandidateName);
			model.addAttribute(EXAMDISPLAYCATEGORYPAPERVIEWMODELOBJ,
					examDisplayCategoryPaperViewModelObj);
			model.addAttribute("resultAnalysisViewModelObj",
					resultAnalysisViewModelObj);
			model.addAttribute("listRankDigits", listRankDigits);
			model.addAttribute("listRankDigitsWithZero", listRankDigitsWithZero);
			model.addAttribute("listRankOutOfDigits", listRankOutOfDigits);

			// add OES Partner
			getOESPartner(model, request);

		} catch (Exception ex) {
			LOGGER.error("Error in viewtestscoreGet()", ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		return "Solo/candidateModule/viewtestscore";

	}

	/**
	 * Method to fetch the Digit Array
	 * @param number
	 * @return List<Long> this returns the digits list
	 */
	public List<Long> getDigitArray(Long number) {
		List<Long> listDigit = new ArrayList<Long>();
		while (number > 0) {
			listDigit.add(number % TEN);
			number = number / TEN;
		}
		Collections.reverse(listDigit);
		return listDigit;
	}

	/**
	 * Post method for Topic wise Result
	 * @param model
	 * @param candidateId
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/topicwise" }, method = { RequestMethod.GET,
			RequestMethod.POST })
	public String topicwiseGet(
			Model model,
			@RequestParam(value = CANDIDATEID, required = false) String candidateId,
			HttpServletRequest request) {
		try {
			String examEventID = request.getParameter(EXAMEVENTID);
			String paperID = request.getParameter(PAPERID);
			String attemptNO = request.getParameter(ATTEMPTNO);
			long examEventId = 0;
			long paperId = 0;
			long candidateID = 0;
			long attemptNo = 0;

			if (examEventID != null && !examEventID.equals("")) {
				examEventId = Long.valueOf(examEventID);
			}
			if (paperID != null && !paperID.equals("")) {
				paperId = Long.valueOf(paperID);
			}
			if (attemptNO != null && !attemptNO.equals("")) {
				attemptNo = Long.valueOf(attemptNO);
			}
			String collectionId = request.getParameter(COLLECTIONID);
			String displayCategoryId = request.getParameter(DISPLAYCATEGORYID);
			String loginType = request.getParameter(LOGINTYPE);

			if (candidateId == null) {
				Candidate candidate = SessionHelper.getCandidate(request);
				if (candidate != null) {
					candidateID = candidate.getCandidateID();
				}
			} else {
				candidateID = Long.valueOf(candidateId);
			}

			// Get selected section Id
			String sectionId = request.getParameter("sectionId");
			if (sectionId != null && !sectionId.equals("")) {
				model.addAttribute("sectionId", sectionId);
			} else {
				sectionId = "0";
				model.addAttribute("sectionId", sectionId);
			}

			String showBriefAnalysis = request
					.getParameter("showBriefAnalysis");
			if (sectionId != null && Long.valueOf(sectionId) == 0
					&& showBriefAnalysis != null
					&& showBriefAnalysis.equals("1")) {
				return "redirect:/ResultAnalysis/viewtestscore?examEventId="
						+ examEventId + "&paperId=" + paperId + "&candidateId="
						+ candidateId + "&collectionId=" + collectionId
						+ "&displayCategoryId=" + displayCategoryId
						+ "&loginType=" + loginType + "&attemptNo=" + attemptNo
						+ "&sectionId=" + sectionId;
			}

			ResultAnalysisServicesImpl resultAnalysisServicesImplObj = new ResultAnalysisServicesImpl();
			ExamDisplayCategoryPaperViewModel examDisplayCategoryPaperViewModelObj = new ExamDisplayCategoryPaperViewModel();
			examDisplayCategoryPaperViewModelObj = resultAnalysisServicesImplObj
					.getPaperDetails(paperId, examEventId, candidateID,
							attemptNo, Long.valueOf(sectionId));

			ItemBankAndDifficultyLevelViewModel itemBankAndDifficultyLevelViewModelObj = new ItemBankAndDifficultyLevelViewModel();
			itemBankAndDifficultyLevelViewModelObj = resultAnalysisServicesImplObj
					.getItemBankWiseResultDetails(examEventId, paperId,
							candidateID, attemptNo, Long.valueOf(sectionId));

			// get user role
			VenueUser user = SessionHelper.getLogedInUser(request);

			// get candidate object
			CandidateServiceImpl objCandidateServiceImpl = new CandidateServiceImpl();
			Candidate objCandidate = objCandidateServiceImpl
					.getCandidateByCandidateID(candidateID);
			String szCandidateName = "";
			if (objCandidate != null) {
				if (objCandidate.getCandidateFirstName() != null) {
					szCandidateName = objCandidate.getCandidateFirstName()
							+ " ";
				}
				if (objCandidate.getCandidateLastName() != null) {
					szCandidateName = szCandidateName
							+ objCandidate.getCandidateLastName();
				}
			}

			// check isSectionRequired or not
			SectionServiceImpl sectionServiceImpl = new SectionServiceImpl();
			if (examDisplayCategoryPaperViewModelObj.getPaper()
					.getIsSectionRequired()) {
				List<Section> sectionList = sectionServiceImpl
						.getSectionListByPaperId(paperId);
				model.addAttribute("sectionList", sectionList);
			}

			// int bestAreaPercentage=readBestAreaPercentage();
			model.addAttribute(CANDIDATENAME, szCandidateName);

			model.addAttribute(EXAMEVENTID, examEventId);
			model.addAttribute(PAPERID, paperId);
			model.addAttribute(ATTEMPTNO, attemptNo);
			model.addAttribute(COLLECTIONID, collectionId);
			model.addAttribute(DISPLAYCATEGORYID, displayCategoryId);
			model.addAttribute(CANDIDATEID, candidateID);
			if (objCandidate != null) {
				model.addAttribute("candidateLoginId",
						objCandidate.getCandidateUserName());
			}
			if (user != null) {
				model.addAttribute(ISADMIN, user.getFkRoleID());
			}

			model.addAttribute(EXAMDISPLAYCATEGORYPAPERVIEWMODELOBJ,
					examDisplayCategoryPaperViewModelObj);
			model.addAttribute(ITEMBANKANDDIFFICULTYLEVELVIEWMODELOBJ,
					itemBankAndDifficultyLevelViewModelObj);
			model.addAttribute(LOGINTYPE, loginType);
			// model.addAttribute("bestAreaPercentage", bestAreaPercentage);

			// add OES Partner
			getOESPartner(model, request);

		} catch (Exception e) {
			LOGGER.error("Error in topicwiseGet controller", e);
			model.addAttribute(Constants.EXCEPTIONSTRING, e);
			return Constants.ERRORPAGE;
		}
		return "Solo/candidateModule/topicwise";

	}

	/**
	 * Post method for Question by Question Result 
	 * @param model
	 * @param request
	 * @param candidateId
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/questionByquestion" }, method = {
			RequestMethod.GET, RequestMethod.POST })
	public String questionByquestionGet(
			Model model,
			HttpServletRequest request,
			@RequestParam(value = CANDIDATEID, required = false) String candidateId) {

		QuestionByQusetionAnalysisServicesImpl iQuestionByQuestionAnalysisServices = new QuestionByQusetionAnalysisServicesImpl();
		SectionServiceImpl sectionServiceImpl = new SectionServiceImpl();
		ExamViewModel examViewModel = null;

		try {
			LinkedHashMap<Long, Boolean> userAnswerMap = new LinkedHashMap<Long, Boolean>();
			int itemType = 0;
			long itemstatus = 0;
			String examEventID = request.getParameter(EXAMEVENTID);
			String paperID = request.getParameter(PAPERID);
			String attemptNO = request.getParameter(ATTEMPTNO);
			long examEventId = 0;
			long paperId = 0;
			long candidateID = 0;
			long attemptNo = 0;
			int count = 0;
			int flag = 0;
			if (examEventID != null && !examEventID.equals("")) {
				examEventId = Long.valueOf(examEventID);
			}
			if (paperID != null && !paperID.equals("")) {
				paperId = Long.valueOf(paperID);
			}
			if (attemptNO != null && !attemptNO.equals("")) {
				attemptNo = Long.valueOf(attemptNO);
			}
			String collectionId = request.getParameter(COLLECTIONID);
			String displayCategoryId = request.getParameter(DISPLAYCATEGORYID);
			String loginType = request.getParameter(LOGINTYPE);

			if (candidateId == null) {
				Candidate candidate = SessionHelper.getCandidate(request);
				if (candidate != null) {
					candidateID = candidate.getCandidateID();
				}
			} else {
				candidateID = Long.valueOf(candidateId);
			}

			String sectionId = request.getParameter("sectionId");
			if (sectionId != null && !sectionId.equals("")) {
				model.addAttribute("sectionId", sectionId);
			} else {
				sectionId = "0";
				model.addAttribute("sectionId", sectionId);
			}

			String showBriefAnalysis = request
					.getParameter("showBriefAnalysis");
			if (sectionId != null && Long.valueOf(sectionId) == 0
					&& showBriefAnalysis != null
					&& showBriefAnalysis.equals("1")) {
				return "redirect:/ResultAnalysis/viewtestscore?examEventId="
						+ examEventId + "&paperId=" + paperId + "&candidateId="
						+ candidateId + "&collectionId=" + collectionId
						+ "&displayCategoryId=" + displayCategoryId
						+ "&loginType=" + loginType + "&attemptNo=" + attemptNo
						+ "&sectionId=" + sectionId;
			}

			// code for topic analysis
			List<Item> itemList = new ArrayList<Item>();
			String itemBankID = request.getParameter("itemBankSelect");
			if (itemBankID != null) {
				model.addAttribute("itemBankID", itemBankID);
				long candidateExamId = iQuestionByQuestionAnalysisServices
						.getCandidateExamId(Long.parseLong(candidateId),
								paperId, examEventId, attemptNo);
				itemList = iQuestionByQuestionAnalysisServices
						.getItemListByItemBankId(Long.parseLong(itemBankID),
								examEventId, paperId,
								Long.parseLong(candidateId), candidateExamId,
								attemptNo, Long.parseLong(sectionId));
			}
			model.addAttribute("itemList", itemList);

			// code for testDetails
			ResultAnalysisServicesImpl resultAnalysisServicesImplObj = new ResultAnalysisServicesImpl();
			ExamDisplayCategoryPaperViewModel examDisplayCategoryPaperViewModelObj = new ExamDisplayCategoryPaperViewModel();
			examDisplayCategoryPaperViewModelObj = resultAnalysisServicesImplObj
					.getPaperDetails(paperId, examEventId, candidateID,
							attemptNo, Long.parseLong(sectionId));

			// check isSectionRequired or not
			if (examDisplayCategoryPaperViewModelObj.getPaper()
					.getIsSectionRequired()) {
				List<Section> sectionList = sectionServiceImpl
						.getSectionListByPaperId(paperId);
				model.addAttribute("sectionList", sectionList);
			}

			Map<Long, Long> itemAnswerMap = iQuestionByQuestionAnalysisServices
					.getQuestionCount(candidateID, examEventId, paperId,
							attemptNo, Long.parseLong(sectionId));
			if (itemList != null && itemList.size() != 0) {
				Map<Long, Long> newitemAnswerMap = new HashMap<Long, Long>();
				newitemAnswerMap = getStatusMap(itemAnswerMap, itemList);
				model.addAttribute("itemAnswerMap", newitemAnswerMap);
			} else {
				model.addAttribute("itemAnswerMap", itemAnswerMap);
			}

			String itemID = request.getParameter("itemID");
			String itemNo = request.getParameter(ITEMNO);

			if (itemAnswerMap != null && itemAnswerMap.size() > 0) {
				/* when particular item is selected show that item details */
				if (itemID != null) {
					itemType = Integer
							.parseInt(iQuestionByQuestionAnalysisServices
									.getItemType(Long.parseLong(itemID)));

					itemstatus = (long) itemAnswerMap.get(Long
							.parseLong(itemID));

					examViewModel = iQuestionByQuestionAnalysisServices
							.getItemDetailsFromID(Long.parseLong(itemID),
									examEventId, candidateID, paperId,
									itemstatus, userAnswerMap, attemptNo);

				}/* when no item is selected show first item details by default */
				else if (itemList.size() == 0) {

					itemType = Integer
							.parseInt(iQuestionByQuestionAnalysisServices
									.getItemType(itemAnswerMap.entrySet()
											.iterator().next().getKey()));

					itemstatus = (long) itemAnswerMap.get(itemAnswerMap
							.entrySet().iterator().next().getKey());
					examViewModel = iQuestionByQuestionAnalysisServices
							.getItemDetailsFromID(itemAnswerMap.entrySet()
									.iterator().next().getKey(), examEventId,
									candidateID, paperId, itemstatus,
									userAnswerMap, attemptNo);

				}/*
				 * when particular topic is selected show first item details of
				 * that topic
				 */
				else {
					itemType = Integer
							.parseInt(iQuestionByQuestionAnalysisServices
									.getItemType(itemList.get(0).getItemID()));
					itemstatus = (long) itemAnswerMap.get(itemList.get(0)
							.getItemID());
					examViewModel = iQuestionByQuestionAnalysisServices
							.getItemDetailsFromID(itemList.get(0).getItemID(),
									examEventId, candidateID, paperId,
									itemstatus, userAnswerMap, attemptNo);
				}
			}

			/* to show current active item */
			if (itemID != null) {
				model.addAttribute("itemId", itemID);
			} else if (itemList.size() == 0 && itemAnswerMap != null
					&& itemAnswerMap.size() > 0) {
				model.addAttribute("itemId", itemAnswerMap.entrySet()
						.iterator().next().getKey());
			} else if (itemList != null && itemList.size() > 0) {
				model.addAttribute("itemId", itemList.get(0).getItemID());
			}

			/* to show itemNo of first active item */
			if (itemNo != null) {
				model.addAttribute(ITEMNO, itemNo);
			} else if (itemList.size() != 0) {
				Set<Long> set = itemAnswerMap.keySet();
				Iterator<Long> itr = set.iterator();
				while (itr.hasNext() && flag == 0) {
					Long id = itr.next();
					count++;
					if (itemList.get(0).getItemID() == id) {
						model.addAttribute(ITEMNO, count);
						flag = 1;
					}
				}
			} else {
				model.addAttribute(ITEMNO, "1");
			}

			// get user role
			VenueUser user = SessionHelper.getLogedInUser(request);

			// get candidate object
			CandidateServiceImpl objCandidateServiceImpl = new CandidateServiceImpl();
			Candidate objCandidate = objCandidateServiceImpl
					.getCandidateByCandidateID(candidateID);
			String szCandidateName = "";
			if (objCandidate != null) {
				if (objCandidate.getCandidateFirstName() != null) {
					szCandidateName = objCandidate.getCandidateFirstName()
							+ " ";
				}
				if (objCandidate.getCandidateLastName() != null) {
					szCandidateName = szCandidateName
							+ objCandidate.getCandidateLastName();
				}
			}
			model.addAttribute(CANDIDATENAME, szCandidateName);

			model.addAttribute("itemstatus", itemstatus);
			model.addAttribute("itemType", ItemType.values()[itemType]);
			model.addAttribute("userAnswerMap", userAnswerMap);
			model.addAttribute("examViewModel", examViewModel);

			model.addAttribute(EXAMEVENTID, examEventId);
			model.addAttribute(PAPERID, paperId);
			model.addAttribute(ATTEMPTNO, attemptNo);
			model.addAttribute(COLLECTIONID, collectionId);
			model.addAttribute(DISPLAYCATEGORYID, displayCategoryId);
			model.addAttribute(CANDIDATEID, candidateID);
			if (objCandidate != null) {
				model.addAttribute("candidateLoginId",
						objCandidate.getCandidateUserName());
			}
			if (user != null) {
				model.addAttribute(ISADMIN, user.getFkRoleID());
			}
			model.addAttribute(EXAMDISPLAYCATEGORYPAPERVIEWMODELOBJ,
					examDisplayCategoryPaperViewModelObj);

			model.addAttribute("filepath", FileUploadHelper
					.getRelativeFolderPath(request, "FileUploadPath"));
			model.addAttribute(LOGINTYPE, loginType);

			// add OES Partner
			getOESPartner(model, request);

		} catch (NumberFormatException e) {
			LOGGER.error("Error in questionByquestionGet controller", e);
		}

		return "Solo/candidateModule/questionByquestion";

	}

	/**
	 * Method for Status Map
	 * @param map
	 * @param itemList
	 * @return Map<Long, Long> this returns the status map
	 */
	private Map<Long, Long> getStatusMap(Map<Long, Long> map,
			List<Item> itemList) {
		for (Item item : itemList) {
			for (Map.Entry<Long, Long> entry : map.entrySet()) {
				if (entry.getKey() == item.getItemID()) {

					if (entry.getValue() == 0l) {
						entry.setValue(10l);
					} else if (entry.getValue() == 1l) {
						entry.setValue((long) 11);
					} else if (entry.getValue() == 2l) {
						entry.setValue((long) 21);
					} else if (entry.getValue() == 3l) {
						entry.setValue((long) 31);
					} else if (entry.getValue() == 4l) {
						entry.setValue((long) 41);
					} else if (entry.getValue() == 81l) {
						entry.setValue((long) 811);
					} else if (entry.getValue() == 82l) {
						entry.setValue((long) 821);
					}
					else if (entry.getValue() == 9l) {
						entry.setValue((long) 91);
					}else if (entry.getValue() == 25l) {
						entry.setValue((long) 251);
					}
				}
			}
		}
		return map;
	}

	/**
	 * Post method for Difficulty Level wise Result
	 * @param model
	 * @param candidateId
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/difficultylevelwise" }, method = {
			RequestMethod.GET, RequestMethod.POST })
	public String difficultlevelwiseGet(
			Model model,
			@RequestParam(value = CANDIDATEID, required = false) String candidateId,
			HttpServletRequest request) {
		try {
			String examEventID = request.getParameter(EXAMEVENTID);
			String paperID = request.getParameter(PAPERID);
			String attemptNO = request.getParameter(ATTEMPTNO);
			long examEventId = 0;
			long paperId = 0;
			long candidateID = 0;
			long attemptNo = 0;
			if (examEventID != null && !examEventID.equals("")) {
				examEventId = Long.valueOf(examEventID);
			}
			if (paperID != null && !paperID.equals("")) {
				paperId = Long.valueOf(paperID);
			}
			if (attemptNO != null && !attemptNO.equals("")) {
				attemptNo = Long.valueOf(attemptNO);
			}
			String collectionId = request.getParameter(COLLECTIONID);
			String displayCategoryId = request.getParameter(DISPLAYCATEGORYID);
			String loginType = request.getParameter(LOGINTYPE);

			if (candidateId == null) {
				Candidate candidate = SessionHelper.getCandidate(request);
				if (candidate != null) {
					candidateID = candidate.getCandidateID();
				}
			} else {
				candidateID = Long.valueOf(candidateId);
			}

			// Get selected section Id
			String sectionId = request.getParameter("sectionId");
			if (sectionId != null && !sectionId.equals("")) {
				model.addAttribute("sectionId", sectionId);
			} else {
				sectionId = "0";
				model.addAttribute("sectionId", sectionId);
			}

			String showBriefAnalysis = request
					.getParameter("showBriefAnalysis");
			if (sectionId != null && Long.valueOf(sectionId) == 0
					&& showBriefAnalysis != null
					&& showBriefAnalysis.equals("1")) {
				return "redirect:/ResultAnalysis/viewtestscore?examEventId="
						+ examEventId + "&paperId=" + paperId + "&candidateId="
						+ candidateId + "&collectionId=" + collectionId
						+ "&displayCategoryId=" + displayCategoryId
						+ "&loginType=" + loginType + "&attemptNo=" + attemptNo
						+ "&sectionId=" + sectionId;
			}

			ResultAnalysisServicesImpl resultAnalysisServicesImplObj = new ResultAnalysisServicesImpl();
			ExamDisplayCategoryPaperViewModel examDisplayCategoryPaperViewModelObj = new ExamDisplayCategoryPaperViewModel();
			examDisplayCategoryPaperViewModelObj = resultAnalysisServicesImplObj
					.getPaperDetails(paperId, examEventId, candidateID,
							attemptNo, Long.valueOf(sectionId));

			ItemBankAndDifficultyLevelViewModel itemBankAndDifficultyLevelViewModelObj = new ItemBankAndDifficultyLevelViewModel();
			itemBankAndDifficultyLevelViewModelObj = resultAnalysisServicesImplObj
					.getDifficultyLevelWiseResultDetails(examEventId, paperId,
							candidateID, attemptNo, Long.valueOf(sectionId));

			// get user role
			VenueUser user = SessionHelper.getLogedInUser(request);

			// get candidate object
			CandidateServiceImpl objCandidateServiceImpl = new CandidateServiceImpl();
			Candidate objCandidate = objCandidateServiceImpl
					.getCandidateByCandidateID(candidateID);
			String szCandidateName = "";
			if (objCandidate != null) {
				if (objCandidate.getCandidateFirstName() != null) {
					szCandidateName = objCandidate.getCandidateFirstName()
							+ " ";
				}
				if (objCandidate.getCandidateLastName() != null) {
					szCandidateName = szCandidateName
							+ objCandidate.getCandidateLastName();
				}
			}

			// check isSectionRequired or not
			SectionServiceImpl sectionServiceImpl = new SectionServiceImpl();
			if (examDisplayCategoryPaperViewModelObj.getPaper()
					.getIsSectionRequired()) {
				List<Section> sectionList = sectionServiceImpl
						.getSectionListByPaperId(paperId);
				model.addAttribute("sectionList", sectionList);
			}

			model.addAttribute(CANDIDATENAME, szCandidateName);

			model.addAttribute(EXAMEVENTID, examEventId);
			model.addAttribute(PAPERID, paperId);
			model.addAttribute(ATTEMPTNO, attemptNo);
			model.addAttribute(COLLECTIONID, collectionId);
			model.addAttribute(DISPLAYCATEGORYID, displayCategoryId);
			model.addAttribute(CANDIDATEID, candidateID);
			if (objCandidate != null) {
				model.addAttribute("candidateLoginId",
						objCandidate.getCandidateUserName());
			}
			if (user != null) {
				model.addAttribute(ISADMIN, user.getFkRoleID());
			}

			model.addAttribute(EXAMDISPLAYCATEGORYPAPERVIEWMODELOBJ,
					examDisplayCategoryPaperViewModelObj);
			model.addAttribute(ITEMBANKANDDIFFICULTYLEVELVIEWMODELOBJ,
					itemBankAndDifficultyLevelViewModelObj);
			model.addAttribute(LOGINTYPE, loginType);

			// add OES Partner
			getOESPartner(model, request);

		} catch (Exception e) {
			LOGGER.error("Error in difficultlevelwiseGet controller", e);
		}
		return "Solo/candidateModule/difficultylevelwise";

	}

	/**
	 * Get method for Analysis Booklet PDF
	 * @param request
	 * @param response
	 * @param candidateId
	 * @param candidateLoginId
	 * @param attemptNo
	 * @param locale
	 */
	@RequestMapping(value = "/AnalysisBooklet_{file_name}.pdf", method = RequestMethod.GET)
	public void getpdf(
			HttpServletRequest request,
			HttpServletResponse response,
			@RequestParam(value = "candidateId", required = false) String candidateId,
			String candidateLoginId, String attemptNo, Locale locale) {
		try {
			String examEventID = request.getParameter("examEventId");
			String paperID = request.getParameter("paperId");

			long examEventId = 0;
			long paperId = 0;
			long candidateID = 0;
			int attemptNumber = 0;

			if (examEventID != null && examEventID != "") {
				examEventId = Long.valueOf(examEventID);
			}
			if (paperID != null && paperID != "") {
				paperId = Long.valueOf(paperID);
			}
			if (attemptNo != null && !attemptNo.equals("")) {
				attemptNumber = Integer.parseInt(attemptNo);
			}
			if (candidateId == null) {
				Candidate candidate = SessionHelper.getCandidate(request);
				if (candidate != null) {
					candidateID = candidate.getCandidateID();
				}
			} else {
				candidateID = Long.valueOf(candidateId);
			}

			PDFViewModel testDataObj = getAnalysisData(request, candidateID,
					examEventId, paperId, candidateLoginId, attemptNumber,
					locale);

			PDFComponent<PDFViewModel> pdfGen = new PDFComponent<PDFViewModel>(
					request, response);
			// pdfGen.setPdfFileName("MyPDF");
			pdfGen.setInputsToXML(testDataObj);
			pdfGen.setStyleSheetXSLName("template.xsl");
			boolean status = pdfGen.startPDFGeneratorEngine();
			// display message
			if (!status) {
				pdfGen.writeErrorResponseContent();
			}
			testDataObj = null;
		} catch (Exception e) {
			LOGGER.error("Exception occured in getpdf: ", e);
		}
	}

	// methods to populate pdf view model

	ItemBankAndDifficultyLevelViewModel itemBankAndDifficultyLevelViewModelObj = null;

	/**
	 * Method for Analysis Data
	 * @param request
	 * @param candidateID
	 * @param examEventID
	 * @param paperID
	 * @param candidateLoginId
	 * @param attemptNo
	 * @param locale
	 * @return PDFViewModel this returns the data for PDF
	 */
	@SuppressWarnings("unchecked")
	private PDFViewModel getAnalysisData(HttpServletRequest request,
			Long candidateID, long examEventID, long paperID,
			String candidateLoginId, int attemptNo, Locale locale) {
		// testdata i.e main view model for generated pdf.
		PDFViewModel pdfViewModelData = null;
		ResultAnalysisViewModelPDF briefAnalysisDetails = null;
		List<Object> listofSectionviewModelPDFAndBestAndWeakArea = null;
		List<SectionViewModelPDF> listOfSectionViewModelPDF = null;
		String bestArea = null;
		String weakArea = null;
		try {
			pdfViewModelData = new PDFViewModel();
			pdfViewModelData.setLocale("messages_" + locale.getLanguage()+ ".properties");

			// set candidate details and paper details
			setCandidateDetailsToPDF(examEventID, candidateID, paperID,pdfViewModelData, candidateLoginId, attemptNo, request);

			// call method to fill brief analysis details i.e in
			// resultanalysisviewmodelpdf
			briefAnalysisDetails = getBriefAnalysisDetails(examEventID,paperID, candidateID, attemptNo);
			pdfViewModelData.setResultAnalysisViewModelObj(briefAnalysisDetails);

			// call method to populate question by question detailed analysis
			// according to section and item bank.
			listofSectionviewModelPDFAndBestAndWeakArea = getQuestionByQuestionDetailsAndBestAndWeakArea(examEventID, paperID, candidateID, attemptNo, request);
			listOfSectionViewModelPDF = (List<SectionViewModelPDF>) listofSectionviewModelPDFAndBestAndWeakArea.get(0);
			bestArea = (String) listofSectionviewModelPDFAndBestAndWeakArea.get(1);
			weakArea = (String) listofSectionviewModelPDFAndBestAndWeakArea.get(2);

			pdfViewModelData.setListOfSectionViewModelPDF(listOfSectionViewModelPDF);
			pdfViewModelData.setBestArea(bestArea);
			pdfViewModelData.setWeakArea(weakArea);

			// method call to set difficulty level analysis.
			pdfViewModelData.setDifficultyLevelViewModelPDF(getDifficultyLevelAnalysisViewModelPDF(examEventID, paperID, candidateID, attemptNo, 0));
			// set right and wrong icon path
			pdfViewModelData.setWrongIconpath(WRONG_ICON_PATH);
			pdfViewModelData.setRighIconpath(RIGHT_ICON_PATH);
		} catch (Exception e) {
			LOGGER.error("Exception genrated while generating pdf -getAnalysisData: ",e);
		}

		return pdfViewModelData;
	}

	/**
	 * Method for Question Option Image Path
	 * @param imageName
	 * @param request
	 * @return String this returns the image path
	 */
	private String getQOImagePath(String imageName, HttpServletRequest request) {
		// set to default path to null Text
		String imageFullPath = "null";
		try {
			if (imageName != null && imageName.length() > 0) {
				String url = request.getScheme() + "://"
						+ request.getServerName() + ":"
						+ request.getLocalPort() + "/"
						+ request.getContextPath();
				imageFullPath = url + "/exam/displayImage?disImg=" + imageName;
			}
		} catch (Exception e) {
			LOGGER.error("Exception occured in getQOImagePath: ", e);
		}
		return imageFullPath;
	}

	/**
	 * Method to fetch OES Partner Data	 
	 * @param model
	 * @param request
	 */
	private void getOESPartner(Model model, HttpServletRequest request) {
		try {
			if (SessionHelper.getPartnerObject(request) != null) {
				String partnerID = SessionHelper.getPartnerObject(request).get(GatewayConstants.PARTNERID);
				IOESPartnerService partnerService = new OESPartnerServiceImpl();
				OESPartnerMaster oesPartnerMaster = partnerService.getOESPartnerMaster(Long.parseLong(partnerID));
				model.addAttribute("oesPartnerMaster", oesPartnerMaster);
			}
		} catch (Exception e) {
			LOGGER.error("Exception occured in getOESPartner: ", e);
		}
	}

	/**
	 * Method for Multiple Choice Single Correct View Model for PDF
	 * @param itemAnsItr
	 * @param request
	 * @return MultipleChoiceSingleCorrectViewModelPDF this returns multiple choice single correct view model
	 * @throws Exception
	 */
	private MultipleChoiceSingleCorrectViewModelPDF getMCSCViewModelForPDF(
			ItemAnswersViewModel itemAnsItr, HttpServletRequest request)
					throws Exception {

		MultipleChoiceSingleCorrectViewModelPDF MCSCObj = null;
		MCSCObj = new MultipleChoiceSingleCorrectViewModelPDF();
		MCSCObj.setItemType(ItemType.MCSC.ordinal());
		MCSCObj.setItemText(StringEscapeUtils.unescapeHtml(itemAnsItr
				.getMultipleChoiceSingleCorrect().getItemText()));
		// set multimedia type 11 in case of item type other than multimedia to
		// track(on xsl) question is of comprehension type or multimedia type
		MCSCObj.setMultiMediatype(11);

		if (itemAnsItr.getMultipleChoiceSingleCorrect().getItemImage() != null && !itemAnsItr.getMultipleChoiceSingleCorrect().getItemImage().isEmpty()) {
			MCSCObj.setItemImageDifficultyLevel(getQOImagePath(itemAnsItr.getMultipleChoiceSingleCorrect().getItemImage(), request));
		}
		// maintain sequence of option
		int optionIndex = 1;

		List<OptionSingleCorrectViewModelPDF> optionListSingleCorrectPDF = new ArrayList<OptionSingleCorrectViewModelPDF>();
		for (OptionSingleCorrect itrObj : itemAnsItr.getMultipleChoiceSingleCorrect().getOptionList()) {
			OptionSingleCorrectViewModelPDF obj = new OptionSingleCorrectViewModelPDF();

			/************************************************************************/
			obj.setOptionIndex(optionIndex);
			optionIndex++;
			obj.setOptionImage(getQOImagePath(itrObj.getOptionImage(), request));

			obj.setOptionID(itrObj.getOptionLanguage().getOption().getOptionID());
			obj.setOptionText(StringEscapeUtils.unescapeHtml(itrObj.getOptionText()));
			obj.setCorrect((itrObj.getOptionLanguage().getOption().getIsCorrect()) ? 1 : 0);

			// set justification to option and correct
			// answer

			obj.setJustification(StringEscapeUtils.unescapeHtml(itrObj.getOptionLanguage().getJustification()));
			obj.setJustificationImage(getQOImagePath(itrObj.getOptionLanguage().getJustificationImage(), request));
			optionListSingleCorrectPDF.add(obj);
			/************************************************************************/
			MCSCObj.setSequenceuserSelected(itrObj.getOptionLanguage().getOption().getOptionSequenceNo());
			if (itrObj.getOptionLanguage().getOption().getIsCorrect()) {
				MCSCObj.setSequenceRightAns(itrObj.getOptionLanguage().getOption().getOptionSequenceNo());
			}

		}
		MCSCObj.setOptionList(optionListSingleCorrectPDF);

		return MCSCObj;

	}

	/**
	 * Method for Practical View Model for PDF 
	 * @param itemAnsItr
	 * @param request
	 * @return MultipleChoiceSingleCorrectViewModelPDF this returns the practical view model for PDF
	 */
	private MultipleChoiceSingleCorrectViewModelPDF getPracticalViewModelForPDF(
			ItemAnswersViewModel itemAnsItr, HttpServletRequest request) {

		MultipleChoiceSingleCorrectViewModelPDF MCSCObj = null;
		MCSCObj = new MultipleChoiceSingleCorrectViewModelPDF();
		MCSCObj.setItemType(ItemType.PRT.ordinal());
		MCSCObj.setItemText(StringEscapeUtils.unescapeHtml(itemAnsItr.getPractical().getItemText()));
		MCSCObj.setPracticalSubjectName(itemAnsItr.getPractical().getPracticalSubject().getSubjectName());
		MCSCObj.setPracticalCategory(itemAnsItr.getPractical().getPracticalSubject().getPracticalCategory().getCategoryName());
		return MCSCObj;

	}

	/**
	 * Method for Multiple Choice Multiple Correct View Model for PDF
	 * @param itemAnsItr
	 * @param request
	 * @return MultipleChoiceSingleCorrectViewModelPDF this returns multiple choice multiple correct view model
	 * @throws Exception
	 */
	private MultipleChoiceSingleCorrectViewModelPDF getMCMCViewModelForPDF(ItemAnswersViewModel itemAnsItr, HttpServletRequest request)
			throws Exception {

		MultipleChoiceSingleCorrectViewModelPDF MCSCObj = null;

		MCSCObj = new MultipleChoiceSingleCorrectViewModelPDF();
		// set difficulty level
		MCSCObj.setDifficultyLevel(DifficultyLevel.values()[itemAnsItr.getDifficultyLevel().ordinal()].toString());
		MCSCObj.setItemType(ItemType.MCMC.ordinal());
		MCSCObj.setItemText(StringEscapeUtils.unescapeHtml(itemAnsItr.getMultipleChoiceMultipleCorrect().getItemText()));
		// set multimedia type 11 in case of item type other than multimedia to
		// track(on xsl) question is of comprehension type or multimedia type
		MCSCObj.setMultiMediatype(11);

		if (itemAnsItr.getMultipleChoiceMultipleCorrect().getItemImage() != null && !itemAnsItr.getMultipleChoiceMultipleCorrect().getItemImage().isEmpty()) {
			MCSCObj.setItemImageDifficultyLevel(getQOImagePath(itemAnsItr.getMultipleChoiceMultipleCorrect().getItemImage(), request));
		}

		List<OptionSingleCorrectViewModelPDF> optionListSingleCorrectPDF = new ArrayList<OptionSingleCorrectViewModelPDF>();

		int optionIndex = 1;
		for (OptionMultipleCorrect itrObj : itemAnsItr.getMultipleChoiceMultipleCorrect().getOptionList()) {
			OptionSingleCorrectViewModelPDF obj = new OptionSingleCorrectViewModelPDF();

			/************************************************************************/
			obj.setOptionIndex(optionIndex);
			optionIndex++;
			if (itrObj.getOptionImage() != null && !itrObj.getOptionImage().isEmpty()) {
				obj.setOptionImage(getQOImagePath(itrObj.getOptionImage(),request));
			}

			obj.setOptionID(itrObj.getOptionLanguage().getOption().getOptionID());
			obj.setOptionText(StringEscapeUtils.unescapeHtml(itrObj.getOptionText()));
			obj.setCorrect((itrObj.getOptionLanguage().getOption().getIsCorrect()) ? 1 : 0);

			// set justification to option and correct
			// answer

			obj.setJustification(StringEscapeUtils.unescapeHtml(itrObj.getOptionLanguage().getJustification()));
			if (itrObj.getOptionLanguage().getJustificationImage() != null && !itrObj.getOptionLanguage().getJustificationImage().isEmpty()) {
				obj.setJustificationImage(getQOImagePath(itrObj.getOptionLanguage().getJustificationImage(), request));
			}
			optionListSingleCorrectPDF.add(obj);

			/************************************************************************/
			MCSCObj.setSequenceuserSelected(itrObj.getOptionLanguage().getOption().getOptionSequenceNo());
			if (itrObj.getOptionLanguage().getOption().getIsCorrect()) {
				MCSCObj.setSequenceRightAns(itrObj.getOptionLanguage().getOption().getOptionSequenceNo());
			}
		}
		MCSCObj.setOptionList(optionListSingleCorrectPDF);
		return MCSCObj;
	}

	/**
	 * Method for Picture Identification View Model for PDF
	 * @param itemAnsItr
	 * @param request
	 * @return MultipleChoiceSingleCorrectViewModelPDF this returns the picture identification view model 
	 * @throws Exception
	 */
	private MultipleChoiceSingleCorrectViewModelPDF getPIViewModelForPDF(
			ItemAnswersViewModel itemAnsItr, HttpServletRequest request)
					throws Exception {

		MultipleChoiceSingleCorrectViewModelPDF MCSCObj = null;

		MCSCObj = new MultipleChoiceSingleCorrectViewModelPDF();

		if (itemAnsItr.getPictureIdentification() != null) {
			MCSCObj.setItemType(ItemType.PI.ordinal());
			MCSCObj.setItemText(StringEscapeUtils.unescapeHtml(itemAnsItr.getPictureIdentification().getItemText()));
			// set multimedia type 11 in case of item type other than multimedia
			// to track(on xsl) question is of comprehension type or multimedia
			// type
			MCSCObj.setMultiMediatype(11);
			if (itemAnsItr.getPictureIdentification().getPictureIdentificatonImgList() != null || !itemAnsItr.getPictureIdentification().getPictureIdentificatonImgList().isEmpty()) {
				for(PictureIdentificatonImg picIdentificationImg : itemAnsItr.getPictureIdentification().getPictureIdentificatonImgList()){
					picIdentificationImg.setItemImage(getQOImagePath(picIdentificationImg.getItemImage(), request)); 
				}

				MCSCObj.setItemImageList(itemAnsItr.getPictureIdentification().getPictureIdentificatonImgList());
			}


			int optionIndex = 1;
			OptionSingleCorrectViewModelPDF obj = null;
			List<OptionSingleCorrectViewModelPDF> optionListSingleCorrectPDF  = new ArrayList<OptionSingleCorrectViewModelPDF>();
			for (OptionPictureIdentification itrObj : itemAnsItr.getPictureIdentification().getOptionList()) {
				obj = new OptionSingleCorrectViewModelPDF();

				obj.setOptionIndex(optionIndex);
				optionIndex++;

				obj.setOptionID(itrObj.getOptionLanguage().getOption().getOptionID());
				obj.setOptionText(StringEscapeUtils.unescapeHtml(itrObj.getOptionText()));
				if (itrObj.getOptionimage() != null&& !itrObj.getOptionimage().isEmpty()) {
					obj.setOptionImage(getQOImagePath(itrObj.getOptionimage(),request));
				}
				obj.setCorrect((itrObj.getOptionLanguage().getOption().getIsCorrect()) ? 1 : 0);

				// set justification to option and correct
				// answer

				obj.setJustification(StringEscapeUtils.unescapeHtml(itrObj.getOptionLanguage().getJustification()));
				obj.setJustificationImage(getQOImagePath(itrObj.getOptionLanguage().getJustificationImage(), request));
				optionListSingleCorrectPDF.add(obj);
				/************************************************************************/

				MCSCObj.setSequenceuserSelected(itrObj.getOptionLanguage().getOption().getOptionSequenceNo());
				if (itrObj.getOptionLanguage().getOption().getIsCorrect()) {
					MCSCObj.setSequenceRightAns(itrObj.getOptionLanguage().getOption().getOptionSequenceNo());
				}
			}
			MCSCObj.setOptionList(optionListSingleCorrectPDF);



		}
		return MCSCObj;
	}

	/**
	 * Method for CMPS View Model for PDF
	 * @param itemAnsItr
	 * @param request
	 * @return MultipleChoiceSingleCorrectViewModelPDF this returns CMPS view model
	 * @throws Exception
	 */
	private MultipleChoiceSingleCorrectViewModelPDF getCMPSViewModelForPDF(
			ItemAnswersViewModel itemAnsItr, HttpServletRequest request)
					throws Exception {
		MultipleChoiceSingleCorrectViewModelPDF MCSCObj = null;
		MCSCObj = new MultipleChoiceSingleCorrectViewModelPDF();
		if (itemAnsItr.getComprehension() != null) {
			// set item type
			MCSCObj.setItemType(ItemType.CMPS.ordinal());

			// main item text
			MCSCObj.setItemText(StringEscapeUtils.unescapeHtml(itemAnsItr.getComprehension().getItemText()));

			// set multimedia type 11 in case of item type other than multimedia
			// to track(on xsl) question is of comprehension type or multimedia
			// type
			MCSCObj.setMultiMediatype(11);

			if (itemAnsItr.getComprehension().getItemFilePath() != null && !itemAnsItr.getComprehension().getItemFilePath().isEmpty()) {

				MCSCObj.setItemImageDifficultyLevel(getQOImagePath(itemAnsItr.getComprehension().getItemFilePath(), request));
			}

			List<MultipleChoiceSingleCorrectViewModelPDF> compSubItemList = new ArrayList<MultipleChoiceSingleCorrectViewModelPDF>();
			MultipleChoiceSingleCorrectViewModelPDF compSubItemVMPdf = null;
			long subItemIndex = 1;
			for (SubItem compSubItem : itemAnsItr.getComprehension().getSubItemList()) {
				compSubItemVMPdf = new MultipleChoiceSingleCorrectViewModelPDF();
				compSubItemVMPdf.setItemText(StringEscapeUtils.unescapeHtml(compSubItem.getSubItemText()));
				compSubItemVMPdf.setSubItemLanguageID(compSubItem.getFkItemLanguageID());
				/****************************************/

				if (compSubItem.getSubItemImage() != null
						&& !compSubItem.getSubItemImage().isEmpty()) {

					compSubItemVMPdf
					.setItemImageDifficultyLevel(getQOImagePath(
							compSubItem.getSubItemImage(), request));
				}

				List<OptionSingleCorrectViewModelPDF> optionListSingleCorrectPDF = new ArrayList<OptionSingleCorrectViewModelPDF>();

				int optionIndex = 1;
				for (OptionSubItem itrObj : compSubItem.getOptionList()) {
					OptionSingleCorrectViewModelPDF obj = new OptionSingleCorrectViewModelPDF();

					/************************************************************************/
					obj.setOptionIndex(optionIndex);
					optionIndex++;
					if (itrObj.getSubOptionImage() != null && !itrObj.getSubOptionImage().isEmpty()) {
						obj.setOptionImage(getQOImagePath(itrObj.getSubOptionImage(), request));
					}

					obj.setOptionID(itrObj.getOptionLanguage().getOption().getOptionID());
					obj.setOptionText(StringEscapeUtils.unescapeHtml(itrObj.getSubOptionText()));
					obj.setCorrect((itrObj.getOptionLanguage().getOption().getIsCorrect()) ? 1 : 0);

					// set justification to option and correct
					// answer

					obj.setJustification(StringEscapeUtils.unescapeHtml(itrObj.getOptionLanguage().getJustification()));
					if (itrObj.getOptionLanguage().getJustificationImage() != null&& !itrObj.getOptionLanguage().getJustificationImage().isEmpty()) {
						obj.setJustificationImage(getQOImagePath(itrObj.getOptionLanguage().getJustificationImage(),request));
					}
					optionListSingleCorrectPDF.add(obj);
					compSubItemVMPdf.setOptionList(optionListSingleCorrectPDF);

					/************************************************************************/

					compSubItemVMPdf.setSequenceuserSelected(itrObj.getOptionLanguage().getOption().getOptionSequenceNo());
					if (itrObj.getOptionLanguage().getOption().getIsCorrect()) {
						compSubItemVMPdf.setSequenceRightAns(itrObj.getOptionLanguage().getOption().getOptionSequenceNo());
					}
				}
				/***********************************/
				compSubItemVMPdf.setItemIndex(subItemIndex);
				subItemIndex++;
				compSubItemList.add(compSubItemVMPdf);
			} // End of subitem fill

			MCSCObj.setSubItemsList(compSubItemList);

		}
		return MCSCObj;
	}

	/**
	 * Method foe MP View Model for PDF
	 * @param itemAnsItr
	 * @param request
	 * @return MultipleChoiceSingleCorrectViewModelPDF this returns MP view model
	 * @throws Exception
	 */
	private MultipleChoiceSingleCorrectViewModelPDF getMPViewModelForPDF(
			ItemAnswersViewModel itemAnsItr, HttpServletRequest request)
					throws Exception {

		MultipleChoiceSingleCorrectViewModelPDF MCSCObj = null;

		MCSCObj = new MultipleChoiceSingleCorrectViewModelPDF();
		if (itemAnsItr.getMatchingPair() != null) {
			MCSCObj.setItemType(ItemType.MP.ordinal());

			// main item text
			MCSCObj.setItemText(StringEscapeUtils.unescapeHtml(itemAnsItr.getMatchingPair().getItemText()));

			// set multimedia type 11 in case of item type other than multimedia
			// to track(on xsl) question is of comprehension type or multimedia
			// type
			MCSCObj.setMultiMediatype(11);

			if (itemAnsItr.getMatchingPair().getItemImage() != null && !itemAnsItr.getMatchingPair().getItemImage().isEmpty()) {
				MCSCObj.setItemImageDifficultyLevel(getQOImagePath(itemAnsItr.getMatchingPair().getItemImage(), request));
			}

			List<MultipleChoiceSingleCorrectViewModelPDF> matchingPairSubItemList = new ArrayList<MultipleChoiceSingleCorrectViewModelPDF>();
			MultipleChoiceSingleCorrectViewModelPDF matchingPairSubItemVMPdf = null;
			long subItemIndex = 1;
			for (SubItem matchingPairSubItem : itemAnsItr.getMatchingPair().getSubItemList()) {
				matchingPairSubItemVMPdf = new MultipleChoiceSingleCorrectViewModelPDF();
				matchingPairSubItemVMPdf.setItemText(StringEscapeUtils.unescapeHtml(matchingPairSubItem.getSubItemText()));
				matchingPairSubItemVMPdf.setSubItemLanguageID(matchingPairSubItem.getFkItemLanguageID());

				if (matchingPairSubItem.getSubItemImage() != null && !matchingPairSubItem.getSubItemImage().isEmpty()) {
					matchingPairSubItemVMPdf.setItemImageDifficultyLevel(getQOImagePath(matchingPairSubItem.getSubItemImage(),request));
				}

				List<OptionSingleCorrectViewModelPDF> optionListSingleCorrectPDF = new ArrayList<OptionSingleCorrectViewModelPDF>();

				int optionIndex = 1;
				for (OptionSubItem itrObj : matchingPairSubItem.getOptionList()) {
					OptionSingleCorrectViewModelPDF obj = new OptionSingleCorrectViewModelPDF();
					obj.setOptionIndex(optionIndex);
					optionIndex++;
					if (itrObj.getSubOptionImage() != null && !itrObj.getSubOptionImage().isEmpty()) {
						obj.setOptionImage(getQOImagePath(itrObj.getSubOptionImage(), request));
					}

					obj.setOptionID(itrObj.getOptionLanguage().getOption().getOptionID());
					obj.setOptionText(StringEscapeUtils.unescapeHtml(itrObj.getSubOptionText()));
					obj.setCorrect((itrObj.getOptionLanguage().getOption().getIsCorrect()) ? 1 : 0);

					// set justification to option and correct answer

					obj.setJustification(StringEscapeUtils.unescapeHtml(itrObj.getOptionLanguage().getJustification()));
					if (itrObj.getOptionLanguage().getJustificationImage() != null && !itrObj.getOptionLanguage().getJustificationImage().isEmpty()) {
						obj.setJustificationImage(getQOImagePath(itrObj.getOptionLanguage().getJustificationImage(),request));
					}
					optionListSingleCorrectPDF.add(obj);
					matchingPairSubItemVMPdf.setOptionList(optionListSingleCorrectPDF);

					matchingPairSubItemVMPdf.setSequenceuserSelected(itrObj.getOptionLanguage().getOption().getOptionSequenceNo());
					if (itrObj.getOptionLanguage().getOption().getIsCorrect()) {
						matchingPairSubItemVMPdf.setSequenceRightAns(itrObj.getOptionLanguage().getOption().getOptionSequenceNo());
					}
				}
				matchingPairSubItemVMPdf.setItemIndex(subItemIndex);
				subItemIndex++;
				matchingPairSubItemList.add(matchingPairSubItemVMPdf);
			} // End of subitem fill
			MCSCObj.setSubItemsList(matchingPairSubItemList);

		}
		return MCSCObj;
	}
	/**
	 * Method to fetch list of view model for simulation type questions	 * 
	 * @param itemAnsItr
	 * @param request
	 * @return MultipleChoiceSingleCorrectViewModelPDF this returns the simulation view model
	 * @throws Exception
	 */
	private MultipleChoiceSingleCorrectViewModelPDF getSimulationViewModelPDF(
			ItemAnswersViewModel itemAnsItr, HttpServletRequest request)
					throws Exception {
		MultipleChoiceSingleCorrectViewModelPDF MCSCObj = null;

		MCSCObj = new MultipleChoiceSingleCorrectViewModelPDF();
		if (itemAnsItr.getSimulation() != null) {
			MCSCObj.setItemType(ItemType.SML.ordinal());
			// main item text
			MCSCObj.setItemText(StringEscapeUtils.unescapeHtml(itemAnsItr.getSimulation().getItemText()));
			MCSCObj.setMultiMediatype(ItemType.SML.ordinal());

		}
		return MCSCObj;
	}
	
	/**
	 * Method to fetch the list of view model for RIFORM type questions	 * 
	 * @param itemAnsItr
	 * @param request
	 * @return MultipleChoiceSingleCorrectViewModelPDF this returns the RIFORM view model
	 * @throws Exception
	 */
	private MultipleChoiceSingleCorrectViewModelPDF getRIFORMViewModelPDF(
			ItemAnswersViewModel itemAnsItr, HttpServletRequest request)
					throws Exception {
		MultipleChoiceSingleCorrectViewModelPDF MCSCObj = null;

		MCSCObj = new MultipleChoiceSingleCorrectViewModelPDF();
		if (itemAnsItr.getRiform() != null) {
			MCSCObj.setItemType(ItemType.RIFORM.ordinal());
			// main item text
			MCSCObj.setItemText(StringEscapeUtils.unescapeHtml(itemAnsItr.getRiform().getItemText()));
			MCSCObj.setMultiMediatype(itemAnsItr.getRiform().getAnsweringMode().ordinal());
			MCSCObj.setAnswerDuration(itemAnsItr.getRiform().getAnswerDuration());
		}
		return MCSCObj;
	}


	/**
	 * Method for the Multi-Media View Model List
	 * @param itemAnsItr
	 * @param request
	 * @return MultipleChoiceSingleCorrectViewModelPDF this returns multimedia view model
	 * @throws Exception
	 */
	private MultipleChoiceSingleCorrectViewModelPDF getMMViewModelForPDF(
			ItemAnswersViewModel itemAnsItr, HttpServletRequest request)
					throws Exception {
		MultipleChoiceSingleCorrectViewModelPDF MCSCObj = null;

		MCSCObj = new MultipleChoiceSingleCorrectViewModelPDF();
		if (itemAnsItr.getMultimedia() != null) {
			// main item text
			MCSCObj.setItemType(ItemType.MM.ordinal());
			MCSCObj.setItemText(StringEscapeUtils.unescapeHtml(itemAnsItr.getMultimedia().getItemText()));

			// set multimedia type
			MCSCObj.setMultiMediatype(itemAnsItr.getMultimedia().getMultimediaType().ordinal());
			List<MultipleChoiceSingleCorrectViewModelPDF> multimediaSubItemList = new ArrayList<MultipleChoiceSingleCorrectViewModelPDF>();
			MultipleChoiceSingleCorrectViewModelPDF multimediaSubItemVMPdf = null;
			long subItemIndex = 1;
			for (SubItem multimediaSubItem : itemAnsItr.getMultimedia().getSubItemList()) {
				multimediaSubItemVMPdf = new MultipleChoiceSingleCorrectViewModelPDF();
				multimediaSubItemVMPdf.setItemText(StringEscapeUtils.unescapeHtml(multimediaSubItem.getSubItemText()));
				multimediaSubItemVMPdf.setSubItemLanguageID(multimediaSubItem.getFkItemLanguageID());
				if (multimediaSubItem.getSubItemImage() != null && !multimediaSubItem.getSubItemImage().isEmpty()) {
					multimediaSubItemVMPdf.setItemImageDifficultyLevel(getQOImagePath(multimediaSubItem.getSubItemImage(),request));
				}
				List<OptionSingleCorrectViewModelPDF> optionListSingleCorrectPDF = new ArrayList<OptionSingleCorrectViewModelPDF>();
				int optionIndex = 1;
				for (OptionSubItem itrObj : multimediaSubItem.getOptionList()) {
					OptionSingleCorrectViewModelPDF obj = new OptionSingleCorrectViewModelPDF();
					obj.setOptionIndex(optionIndex);
					optionIndex++;
					if (itrObj.getSubOptionImage() != null&& !itrObj.getSubOptionImage().isEmpty()) {
						obj.setOptionImage(getQOImagePath(itrObj.getSubOptionImage(), request));
					}

					obj.setOptionID(itrObj.getOptionLanguage().getOption().getOptionID());
					obj.setOptionText(StringEscapeUtils.unescapeHtml(itrObj.getSubOptionText()));
					obj.setCorrect((itrObj.getOptionLanguage().getOption().getIsCorrect()) ? 1 : 0);

					// set justification to option and correct
					// answer

					obj.setJustification(StringEscapeUtils.unescapeHtml(itrObj.getOptionLanguage().getJustification()));
					if (itrObj.getOptionLanguage().getJustificationImage() != null && !itrObj.getOptionLanguage().getJustificationImage().isEmpty()) {
						obj.setJustificationImage(getQOImagePath(itrObj.getOptionLanguage().getJustificationImage(),request));
					}
					optionListSingleCorrectPDF.add(obj);
					multimediaSubItemVMPdf.setOptionList(optionListSingleCorrectPDF);
					multimediaSubItemVMPdf.setSequenceuserSelected(itrObj.getOptionLanguage().getOption().getOptionSequenceNo());
					if (itrObj.getOptionLanguage().getOption().getIsCorrect()) {
						multimediaSubItemVMPdf.setSequenceRightAns(itrObj.getOptionLanguage().getOption().getOptionSequenceNo());
					}
				}
				/***********************************/
				multimediaSubItemVMPdf.setItemIndex(subItemIndex);
				subItemIndex++;
				multimediaSubItemList.add(multimediaSubItemVMPdf);
			} // End of subitem fill

			MCSCObj.setSubItemsList(multimediaSubItemList);

		}
		return MCSCObj;
	}

	/**
	 * Method to set the Candidate Answer Data
	 * @param MCSCObj
	 * @param itemtype
	 * @param itemLangIDOfCurrentItemAnsItr
	 * @return MultipleChoiceSingleCorrectViewModelPDF this returns the multiple choice single correct view model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	private MultipleChoiceSingleCorrectViewModelPDF setCandidateAnswerData(MultipleChoiceSingleCorrectViewModelPDF MCSCObj, ItemType itemtype,long itemLangIDOfCurrentItemAnsItr) throws Exception {
		String marksObtained = null;
		String isCorrect = null;
		short itemStatus = 0;
		String candidateAnswer = null;
		List<CandidateAnswerViewModelPDF> listCandidateAnsViewModelPDF = null;
		Map<Long, Boolean> userAnswerMap = null;
		Map<Long, List<Object>> mapOfItemLangIDAndListOfMarksAndAnsMap = itemBankAndDifficultyLevelViewModelObj.getUserAnswerMap();

		switch (itemtype) {
		case CMPS:
		case MP:
		case MM:
			for (MultipleChoiceSingleCorrectViewModelPDF mcscSubItem : MCSCObj.getSubItemsList()) {
				if (mapOfItemLangIDAndListOfMarksAndAnsMap.get(mcscSubItem.getSubItemLanguageID()) != null) {
					userAnswerMap = (Map<Long, Boolean>) mapOfItemLangIDAndListOfMarksAndAnsMap.get(mcscSubItem.getSubItemLanguageID()).get(1);
					marksObtained = (String) mapOfItemLangIDAndListOfMarksAndAnsMap.get(mcscSubItem.getSubItemLanguageID()).get(0);
					isCorrect = (String) mapOfItemLangIDAndListOfMarksAndAnsMap.get(mcscSubItem.getSubItemLanguageID()).get(2);
					candidateAnswer = (String) mapOfItemLangIDAndListOfMarksAndAnsMap.get(mcscSubItem.getSubItemLanguageID()).get(3);
					LOGGER.info("candidate Answer ::"+candidateAnswer);
					mcscSubItem.setIsCorrectAnswer(Integer.parseInt(isCorrect));
					mcscSubItem.setCandidateAnswer(candidateAnswer);

				}

				// set option sequence of user selection
				for (OptionSingleCorrectViewModelPDF subItemOptionItr : mcscSubItem.getOptionList()) {
					if (userAnswerMap != null && userAnswerMap.get(subItemOptionItr.getOptionID()) != null) {
						userAnswerMap.get(subItemOptionItr.getOptionID());
						subItemOptionItr.setOptionIdUserselected(subItemOptionItr.getOptionID());
						subItemOptionItr.setUserselectedTrue(1);

					}
				}

				// set list of candidateanswer
				listCandidateAnsViewModelPDF = new ArrayList<CandidateAnswerViewModelPDF>();
				Map<Long, Boolean> childMap = null;
				for (Map.Entry<Long, List<Object>> mainMapEntry : mapOfItemLangIDAndListOfMarksAndAnsMap.entrySet()) {
					if (mapOfItemLangIDAndListOfMarksAndAnsMap.get(mcscSubItem.getSubItemLanguageID()) != null) {
						childMap = (Map<Long, Boolean>) mapOfItemLangIDAndListOfMarksAndAnsMap.get(mcscSubItem.getSubItemLanguageID()).get(1);
					}
					if (mcscSubItem.getSubItemLanguageID() == mainMapEntry
							.getKey() && childMap != null) {
						for (Map.Entry<Long, Boolean> entry : childMap
								.entrySet()) {
							// in below code mainMapitr.next().getValue() will
							// indicates main map that is map of fllnaguage id
							// and map of option id and answer
							CandidateAnswerViewModelPDF candidateAnsPDFobj = new CandidateAnswerViewModelPDF();
							candidateAnsPDFobj.setIsCorrect(entry.getValue());
							candidateAnsPDFobj.setOptionID(entry.getKey());
							listCandidateAnsViewModelPDF.add(candidateAnsPDFobj);
						}
					}
				}
				// set whether question is attempted or not by user '1' for
				// attempted and '0' for not attempted
				if (listCandidateAnsViewModelPDF != null && !listCandidateAnsViewModelPDF.isEmpty()) {
					mcscSubItem.setIsAttempted(1);
				}
				if(mcscSubItem.getIsAttempted()==1)
				{
					mcscSubItem.setMarksObtained(marksObtained);
					mcscSubItem.setListCandidateAnswerViewModelPDF(listCandidateAnsViewModelPDF);
				}
			}
			break;

		case MCSC:
		case MCMC:
		case PI:
			if (mapOfItemLangIDAndListOfMarksAndAnsMap.get(itemLangIDOfCurrentItemAnsItr) != null) {
				userAnswerMap = (Map<Long, Boolean>) mapOfItemLangIDAndListOfMarksAndAnsMap.get(itemLangIDOfCurrentItemAnsItr).get(1);
				marksObtained = (String) mapOfItemLangIDAndListOfMarksAndAnsMap.get(itemLangIDOfCurrentItemAnsItr).get(0);
				isCorrect = (String) mapOfItemLangIDAndListOfMarksAndAnsMap.get(itemLangIDOfCurrentItemAnsItr).get(2);

				MCSCObj.setIsCorrectAnswer(Integer.parseInt(isCorrect));

			}
			// set list of candidateanswer
			listCandidateAnsViewModelPDF = new ArrayList<CandidateAnswerViewModelPDF>();
			Map<Long, Boolean> childMap = null;
			for (Map.Entry<Long, List<Object>> mainMapEntry : mapOfItemLangIDAndListOfMarksAndAnsMap.entrySet()) {

				if (mapOfItemLangIDAndListOfMarksAndAnsMap.get(itemLangIDOfCurrentItemAnsItr) != null) {
					childMap = (Map<Long, Boolean>) mapOfItemLangIDAndListOfMarksAndAnsMap.get(itemLangIDOfCurrentItemAnsItr).get(1);
				}
				if (itemLangIDOfCurrentItemAnsItr == mainMapEntry.getKey() && childMap != null) {
					for (Map.Entry<Long, Boolean> entry : childMap.entrySet()) {
						// in below code mainMapitr.next().getValue() will indicates main map that is map of fllnaguage id and map of option id and answer
						CandidateAnswerViewModelPDF candidateAnsPDFobj = new CandidateAnswerViewModelPDF();
						candidateAnsPDFobj.setIsCorrect(entry.getValue());
						candidateAnsPDFobj.setOptionID(entry.getKey());
						/* candidateAnsPDFobj.setIndex(counter); */
						listCandidateAnsViewModelPDF.add(candidateAnsPDFobj);
					}
				}
			}
			MCSCObj.setMarksObtained(marksObtained);
			MCSCObj.setListCandidateAnswerViewModelPDF(listCandidateAnsViewModelPDF);

			// set whether question is attempted or not by user '1' for
			// attempted and '0' for not attempted
			if (listCandidateAnsViewModelPDF != null && !listCandidateAnsViewModelPDF.isEmpty()) {
				MCSCObj.setIsAttempted(1);
			}
			for (OptionSingleCorrectViewModelPDF itr : MCSCObj.getOptionList()) {
				if (userAnswerMap != null && userAnswerMap.get(itr.getOptionID()) != null) {
					userAnswerMap.get(itr.getOptionID());
					itr.setOptionIdUserselected(itr.getOptionID());
					itr.setUserselectedTrue(1);
				}
			}
			break;

		case SML :
			if (mapOfItemLangIDAndListOfMarksAndAnsMap.get(itemLangIDOfCurrentItemAnsItr) != null) 
			{
				marksObtained = (String) mapOfItemLangIDAndListOfMarksAndAnsMap.get(itemLangIDOfCurrentItemAnsItr).get(0);
				isCorrect = (String) mapOfItemLangIDAndListOfMarksAndAnsMap.get(itemLangIDOfCurrentItemAnsItr).get(1);
				MCSCObj.setIsCorrectAnswer(Integer.parseInt(isCorrect));
			}
			// set list of candidateanswer
			MCSCObj.setMarksObtained(marksObtained);

			// set whether question is attempted or not by user '1' for attempted and '0' for not attempted
			if (mapOfItemLangIDAndListOfMarksAndAnsMap != null && !mapOfItemLangIDAndListOfMarksAndAnsMap.isEmpty()) {
				MCSCObj.setIsAttempted(1);
			}

			break;

		case PRT:
		case EC :
			if (mapOfItemLangIDAndListOfMarksAndAnsMap.get(itemLangIDOfCurrentItemAnsItr) != null) {
				String typedText = null;
				marksObtained = (String) mapOfItemLangIDAndListOfMarksAndAnsMap.get(itemLangIDOfCurrentItemAnsItr).get(0);
				isCorrect = (String) mapOfItemLangIDAndListOfMarksAndAnsMap.get(itemLangIDOfCurrentItemAnsItr).get(1);
				itemStatus = (Short) mapOfItemLangIDAndListOfMarksAndAnsMap.get(itemLangIDOfCurrentItemAnsItr).get(2);
				if(itemtype.equals(ItemType.EC)){
					typedText = (String) mapOfItemLangIDAndListOfMarksAndAnsMap.get(itemLangIDOfCurrentItemAnsItr).get(3);
				LOGGER.info("Typed text :: "+typedText);
				MCSCObj.setTypedText(typedText);
				}
				MCSCObj.setIsCorrectAnswer(Integer.parseInt(isCorrect));
			}
			if (itemStatus == ItemStatus.NotAnswered.ordinal() || itemStatus == ItemStatus.Skipped.ordinal()) 
			{
				MCSCObj.setIsAttempted(0);
			} 
			else if (itemStatus == ItemStatus.Answered.ordinal()) 
			{
				MCSCObj.setIsAttempted(1);
				MCSCObj.setMarksObtained(marksObtained);

			}

			break;
			
		case RIFORM:
	
		
			String optionFilepath = null;
			int timetakenInSec = 0;
			if (mapOfItemLangIDAndListOfMarksAndAnsMap.get(itemLangIDOfCurrentItemAnsItr) != null) 
			{
				optionFilepath = (String) mapOfItemLangIDAndListOfMarksAndAnsMap.get(itemLangIDOfCurrentItemAnsItr).get(0);
				timetakenInSec = (Integer) mapOfItemLangIDAndListOfMarksAndAnsMap.get(itemLangIDOfCurrentItemAnsItr).get(1);
			}
			MCSCObj.setTimeTakenInSec(ExamHelper.getTImeInMinAndSecForm(String.valueOf(timetakenInSec)));
			MCSCObj.setOptionFIlepath(optionFilepath);
			
			if (MCSCObj.getOptionFIlepath()!=null && !MCSCObj.getOptionFIlepath().isEmpty()) {
				MCSCObj.setIsAttempted(1);
			}
			break;
		/*case EC :
			MCSCObj.setTypedText("Dummy Text");
			break;*/
		default:
			LOGGER.error("item type not found");
			break;
		}
		return MCSCObj;
	}

	/**
	 * Method for Difficulty Level Analysis View Model for PDF
	 * @param examEventID
	 * @param paperID
	 * @param candidateID
	 * @param attemptNo
	 * @param sectionID
	 * @return ItemBankAndDifficultyLevelViewModelPDF this returns the Difficulty Level Analysis View Model
	 */
	private ItemBankAndDifficultyLevelViewModelPDF getDifficultyLevelAnalysisViewModelPDF(
			long examEventID, long paperID, long candidateID, int attemptNo,
			int sectionID) {
		ItemBankAndDifficultyLevelViewModelPDF difficultyLevelVMPDF = null;
		try {
			ItemBankAndDifficultyLevelViewModel itemBankAndDifficultyLevelViewModelObj1 = new ResultAnalysisServicesImpl().getDifficultyLevelWiseResultDetails(examEventID, paperID,candidateID, attemptNo, 0);
			difficultyLevelVMPDF = null;

			List<ResultAnalysisViewModelPDF> listresAnalysisViewModelPDF1 = new ArrayList<ResultAnalysisViewModelPDF>();
			ResultAnalysisViewModelPDF resAnalysisViewModelPDFPecentagepart = null;
			for (ResultAnalysisViewModel resAnalysisItr : itemBankAndDifficultyLevelViewModelObj1.getListResultAnalysisViewModel()) {
				resAnalysisViewModelPDFPecentagepart = new ResultAnalysisViewModelPDF();
				resAnalysisViewModelPDFPecentagepart.setTotalItem(resAnalysisItr.getTotalItem());
				resAnalysisViewModelPDFPecentagepart.setTotalCorrectAnswer(resAnalysisItr.getTotalCorrectAnswer());
				resAnalysisViewModelPDFPecentagepart.setDifficultyLevel(resAnalysisItr.getDifficultyLevel().toString());
				// added after itemtype RIFORM introduced into system.
				resAnalysisViewModelPDFPecentagepart.setTotalEvaluationPendingItem(resAnalysisItr.getTotalEvaluationPendingItem());
				
				// set percentage
				Double percentage = null;
				if (resAnalysisItr.getTotalAttemptedItem()-resAnalysisItr.getTotalEvaluationPendingItem()!=0) 
				{
					percentage = (double) resAnalysisItr.getTotalCorrectAnswer()/ (resAnalysisItr.getTotalAttemptedItem()-resAnalysisItr.getTotalEvaluationPendingItem()) * 100.0;
					resAnalysisViewModelPDFPecentagepart.setPercentage(percentage);
				} else 
				{
					resAnalysisViewModelPDFPecentagepart.setPercentage(0.0);
				}
				resAnalysisViewModelPDFPecentagepart.setTotalAttemptedItem(resAnalysisItr.getTotalAttemptedItem());
				listresAnalysisViewModelPDF1.add(resAnalysisViewModelPDFPecentagepart);
			}
			difficultyLevelVMPDF = new ItemBankAndDifficultyLevelViewModelPDF();
			difficultyLevelVMPDF.setListResultAnalysisViewModelPDF(listresAnalysisViewModelPDF1);
		} catch (Exception e) {
			LOGGER.error("Exception in getDifficultyLevelAnalysisViewModelPDF of ResultAnalysisController",e);
		}
		return difficultyLevelVMPDF;
	}

	/**
	 * Method to set Candidate Details to PDF
	 * @param examEventID
	 * @param candidateID
	 * @param paperID
	 * @param pdfViewModelData
	 * @param candidateLoginId
	 * @param attemptNo
	 * @param request
	 */
	private void setCandidateDetailsToPDF(long examEventID, long candidateID,
			long paperID, PDFViewModel pdfViewModelData,
			String candidateLoginId, int attemptNo, HttpServletRequest request) {
		IpdfServices pdfServicesobj = new PDFServicesImpl();
		IUserServices userServices = new UserServicesImpl();
		try {
			List<Object> canidatebasicDetailsPDF = pdfServicesobj.getExamEventCandiadteDEtailsForPDF(examEventID,candidateID, paperID);
			// get and set event name
			ExamEvent examEventObj = (ExamEvent) canidatebasicDetailsPDF.get(0);
			pdfViewModelData.setEventName(examEventObj.getName());
			// set attempt number
			pdfViewModelData.setAttemptNumber(attemptNo);

			// get and set candidate details
			Candidate candidateObj = (Candidate) canidatebasicDetailsPDF.get(1);

			pdfViewModelData.setCandidateFirstName(candidateObj.getCandidateFirstName());
			pdfViewModelData.setCandidateMiddleName(candidateObj.getCandidateMiddleName());
			pdfViewModelData.setCandidateLastName(candidateObj.getCandidateLastName());
			pdfViewModelData.setCandidateUserName(candidateObj.getCandidateUserName());
			// set division
			String collectionName = (String) canidatebasicDetailsPDF.get(2);
			String collectiontype = (String) canidatebasicDetailsPDF.get(3);
			pdfViewModelData.setCandidateCollection(collectionName);
			pdfViewModelData.setCollectionType(collectiontype);

			// set candidate image path
			List<VenueUser> venueUserList = SessionHelper.getLogedInUsers(request);
			String candidateImagepath = null;

			VenueUser venueUserObj = null;
			// if condition is applied because in case of admin login,candidate
			// id is not available in venue user object.
			for (VenueUser userItrObj : venueUserList) {
				if (userItrObj.getFkRoleID() == 3) {
					if (userItrObj.getObject().equals(candidateID)) {
						venueUserObj = userItrObj;
						break;
					}
				} else {
					// in case of admin login or subject admin login
					venueUserObj = userServices.getUserOneByUserName(candidateLoginId);
				}
			}
			if (venueUserObj != null && venueUserObj.getUserPhoto() != null&& !venueUserObj.getUserPhoto().isEmpty()) {
				candidateImagepath = RELATIVE_PATH + venueUserObj.getUserPhoto();
				pdfViewModelData.setCandidateImagePath(candidateImagepath);
			} else {
				pdfViewModelData.setCandidateImagePath(DEFAULT_CANDIDATE_IMAGE_PATH);
			}

			ExamDisplayCategoryPaperViewModel examDisplayCategoryPaperViewModelObj = new ExamDisplayCategoryPaperViewModel();
			examDisplayCategoryPaperViewModelObj = (ExamDisplayCategoryPaperViewModel) canidatebasicDetailsPDF.get(4);

			ExamDisplayCategoryPaperViewModelPDF examDisplayCategorypaperViewModelPDFObj = new ExamDisplayCategoryPaperViewModelPDF();
			examDisplayCategorypaperViewModelPDFObj.setPaperName(examDisplayCategoryPaperViewModelObj.getPaper().getName());
			if (examDisplayCategoryPaperViewModelObj.getPaper().getIsSectionRequired()) {
				examDisplayCategorypaperViewModelPDFObj.setIsSectionRequired("Y");
			} else {
				examDisplayCategorypaperViewModelPDFObj.setIsSectionRequired("N");
			}
			examDisplayCategorypaperViewModelPDFObj.setDisplayCategoryName(examDisplayCategoryPaperViewModelObj.getDisplayCategoryLanguage().getDisplayCategoryName());
			examDisplayCategorypaperViewModelPDFObj.setAssessmentType(examDisplayCategoryPaperViewModelObj.getAssessmentType().toString());

			examDisplayCategorypaperViewModelPDFObj.setAttemptDate(new SimpleDateFormat("dd-MMM-yyyy").format(examDisplayCategoryPaperViewModelObj.getCandidateExam().getAttemptDate()));
			examDisplayCategorypaperViewModelPDFObj.setDuration(examDisplayCategoryPaperViewModelObj.getPaper().getDuration());

			// set section wise item bank list
			examDisplayCategorypaperViewModelPDFObj.setListOfSectionViewModelPDF(pdfServicesobj.getSectionWiseitembankList(paperID));

			pdfViewModelData.setExamDispalyCategoryPaperViewModelObj(examDisplayCategorypaperViewModelPDFObj);
		} catch (Exception e) {
			LOGGER.error("Exception in setCandidateDetailsToPDF of Result analysis controller",e);
		}

	}

	/**
	 * Method to fetch Brief Analysis Details
	 * @param examEventID
	 * @param paperID
	 * @param candidateID
	 * @param attemptNo
	 * @return ResultAnalysisViewModelPDF this returns result analysis view model
	 */
	private ResultAnalysisViewModelPDF getBriefAnalysisDetails(
			long examEventID, long paperID, long candidateID, int attemptNo) {
		IResultAnalysisServices resultAnalysisServices = new ResultAnalysisServicesImpl();
		ResultAnalysisViewModel resultAnalysisViewModelObj = resultAnalysisServices.getBriefResultDetails(examEventID, paperID, candidateID,attemptNo);

		ResultAnalysisViewModelPDF resultAnalysisViewModelPDF = new ResultAnalysisViewModelPDF();
		try {
			resultAnalysisViewModelPDF.setTotalItem(resultAnalysisViewModelObj.getTotalMainItem());
			resultAnalysisViewModelPDF.setTotalMainItem(resultAnalysisViewModelObj.getTotalMainItem());
			resultAnalysisViewModelPDF.setTotalAttemptedMainItem(resultAnalysisViewModelObj.getTotalAttemptedMainItem());
			resultAnalysisViewModelPDF.setTotalMainItemCorrectAnswer(resultAnalysisViewModelObj.getTotalMainItemCorrectAnswer());
			resultAnalysisViewModelPDF.setTotalSubItem(resultAnalysisViewModelObj.getTotalSubItem());
			resultAnalysisViewModelPDF.setTotalAttemptedSubItem(resultAnalysisViewModelObj.getTotalAttemptedSubItem());
			resultAnalysisViewModelPDF.setTotalSubItemCorrectAnswer(resultAnalysisViewModelObj.getTotalSubItemCorrectAnswer());
			resultAnalysisViewModelPDF.setPaperContainCMPSItem(resultAnalysisViewModelObj.getPaperContainCMPSItem());
			resultAnalysisViewModelPDF.setTotalEvaluationPendingItem(resultAnalysisViewModelObj.getTotalEvaluationPendingItem());
			resultAnalysisViewModelPDF.setTotalEvaluationPendingMainItem(resultAnalysisViewModelObj.getTotalEvaluationPendingMainItem());
			resultAnalysisViewModelPDF.setTotalEvaluationPendingSubItem(resultAnalysisViewModelObj.getTotalEvaluationPendingSubItem());

			// set totalMarksObtainedForCorrect and
			// totalMarksObtainedForInCorrect
			resultAnalysisViewModelPDF.setTotalMarksObtainedForCorrect(resultAnalysisViewModelObj.getTotalMarksObtainedForCorrect());
			resultAnalysisViewModelPDF.setTotalMarksObtainedForInCorrect(resultAnalysisViewModelObj.getTotalMarksObtainedForInCorrect());
			resultAnalysisViewModelPDF.setTotalAttemptedItem(resultAnalysisViewModelObj.getTotalAttemptedMainItem());
			resultAnalysisViewModelPDF.setTotalCorrectAnswer(resultAnalysisViewModelObj.getTotalMainItemCorrectAnswer());
			resultAnalysisViewModelPDF.setTotalMarks(resultAnalysisViewModelObj.getTotalMarks());
			resultAnalysisViewModelPDF.setTotalObtainedMarks(resultAnalysisViewModelObj.getTotalObtainedMarks());
			resultAnalysisViewModelPDF.setMinimumPassingMarks(resultAnalysisViewModelObj.getMinimumPassingMarks());

			Double exactPercentage = (double) resultAnalysisViewModelObj.getTotalObtainedMarks()/ resultAnalysisViewModelObj.getTotalMarks() * 100;
			resultAnalysisViewModelPDF.setPercentage(exactPercentage);

			// set rank
			resultAnalysisViewModelPDF.setRank(resultAnalysisViewModelObj.getRank());
			resultAnalysisViewModelPDF.setRankOutOf(resultAnalysisViewModelObj.getRankOutOf());
		} catch (Exception e) {
			LOGGER.error("Exception in getBriefAnalysisDetails of result analysysi controller",e);
		}
		return resultAnalysisViewModelPDF;
	}

	/**
	 * Method to fetch Question by Question Details and Best and Weak Area
	 * @param examEventID
	 * @param paperID
	 * @param candidateID
	 * @param attemptNo
	 * @param request
	 * @return List<Object> this returns the question details list
	 */
	private List<Object> getQuestionByQuestionDetailsAndBestAndWeakArea(
			long examEventID, long paperID, long candidateID, int attemptNo,HttpServletRequest request) {
		IResultAnalysisServices resultAnalysisServices = new ResultAnalysisServicesImpl();
		itemBankAndDifficultyLevelViewModelObj = resultAnalysisServices.getItemBankWiseResultDetailsForPDF(examEventID, paperID,candidateID, attemptNo);

		List<Object> listOfQuestionByQuestionDetailsAndBestAndWeakArea = null;
		List<ResultAnalysisViewModelPDF> listTpociWiseAnalysisViewModelPDF = null;
		List<ResultAnalysisViewModelPDF> tempListTpociWiseAnalysisViewModelPDF = null;
		List<SectionViewModelPDF> listofSectionviewModelPDF = new ArrayList<SectionViewModelPDF>();

		SectionViewModelPDF sectionViewModelPDF = null;
		ItemType itemtype = null;
		MultipleChoiceSingleCorrectViewModelPDF MCSCObj = null;

		ResultAnalysisViewModelPDF resAnalysisViewModelPDF = null;
		// fetch section list
		String tempBestArea, tempWeakArea;
		try {
			List<Section> sectionlist = new SectionServiceImpl().getSectionListByPaperId(paperID);
			int itemIndex = 1;
			listTpociWiseAnalysisViewModelPDF = new ArrayList<ResultAnalysisViewModelPDF>();
			for (Section sectionitr : sectionlist) {
				tempListTpociWiseAnalysisViewModelPDF = new ArrayList<ResultAnalysisViewModelPDF>();

				for (ResultAnalysisViewModel resAnalysisItr : itemBankAndDifficultyLevelViewModelObj.getListResultAnalysisViewModel()) {

					if (resAnalysisItr.getSectionName().equals(sectionitr.getSectionName())) {

						List<MultipleChoiceSingleCorrectViewModelPDF> listMCSCViewModelPDF = new ArrayList<MultipleChoiceSingleCorrectViewModelPDF>();
						resAnalysisViewModelPDF = new ResultAnalysisViewModelPDF();
						resAnalysisViewModelPDF.setSectionName(resAnalysisItr.getSectionName());
						resAnalysisViewModelPDF.setItemBankName(resAnalysisItr.getItemBank().getName());
						resAnalysisViewModelPDF.setTotalItem(resAnalysisItr.getTotalItem());
						resAnalysisViewModelPDF.setTotalCorrectAnswer(resAnalysisItr.getTotalCorrectAnswer());
						
						// added after new itemtype RIFORM introduced
						resAnalysisViewModelPDF.setTotalEvaluationPendingItem(resAnalysisItr.getTotalEvaluationPendingItem());

						// set percentage
						if (resAnalysisItr.getTotalAttemptedItem()-resAnalysisItr.getTotalEvaluationPendingItem()!= 0) {
							double accuracyPercentage = (double) resAnalysisItr.getTotalCorrectAnswer()/ (resAnalysisItr.getTotalAttemptedItem()-resAnalysisItr.getTotalEvaluationPendingItem())* 100;
							resAnalysisViewModelPDF.setPercentage(accuracyPercentage);
						} else {
							resAnalysisViewModelPDF.setPercentage(0.0);
						}
						resAnalysisViewModelPDF.setTotalAttemptedItem(resAnalysisItr.getTotalAttemptedItem());

						if (resAnalysisItr.getDifficultyLevel() != null) {
							resAnalysisViewModelPDF.setDifficultyLevel(DifficultyLevel.values()[resAnalysisItr.getDifficultyLevel().ordinal()].toString());
						}

						// counter to maintain serial number.
						List<ItemAnswersViewModel> listOfItemAnsViewModel = resAnalysisItr.getListItemAnswersViewModels();
						for (ItemAnswersViewModel itemAnsItr : listOfItemAnsViewModel) {
							// fill multiple choice single correct view model
							// according to itemtype
							itemtype = itemAnsItr.getItemType();
							switch (itemtype) {
							case MCSC:
								MCSCObj = getMCSCViewModelForPDF(itemAnsItr,request);
								break;
							case MCMC:
								MCSCObj = getMCMCViewModelForPDF(itemAnsItr,request);
								break;
							case PI:
								MCSCObj = getPIViewModelForPDF(itemAnsItr,request);
								break;
							case CMPS:
								MCSCObj = getCMPSViewModelForPDF(itemAnsItr,request);
								break;
							case MP:
								MCSCObj = getMPViewModelForPDF(itemAnsItr,request);
								break;
							case MM:
								MCSCObj = getMMViewModelForPDF(itemAnsItr,request);
								break;
							case PRT:
								MCSCObj = getPracticalViewModelForPDF(itemAnsItr, request);
								break;
							case SML:
								MCSCObj = getSimulationViewModelPDF(itemAnsItr,request);
								break;
							case RIFORM:
								MCSCObj = getRIFORMViewModelPDF(itemAnsItr, request);
								break;
							case EC:
								MCSCObj = getECMViewModelPDF(itemAnsItr, request);
								break;

							default:
								LOGGER.error("ITEM TYPE NOT FOUND");
								break;
							}
							// set difficulty level
							MCSCObj.setDifficultyLevel(DifficultyLevel.values()[itemAnsItr.getDifficultyLevel().ordinal()].toString());

							// set main question counter
							MCSCObj.setItemIndex(itemIndex);
							// call method to set candidateAnswer related
							setCandidateAnswerData(MCSCObj, itemtype,itemAnsItr.getFkItemLanguageID());
							listMCSCViewModelPDF.add(MCSCObj);
							// set sequence of user selected option
							resAnalysisViewModelPDF.setListOfMCSCViewModelPDF(listMCSCViewModelPDF);
							itemIndex++;
						}
						tempListTpociWiseAnalysisViewModelPDF.add(resAnalysisViewModelPDF);

					}

				}
				sectionViewModelPDF = new SectionViewModelPDF();
				sectionViewModelPDF.setSectionName(sectionitr.getSectionName());
				sectionViewModelPDF.setTopicWiseAnalysisViewModelPDF(tempListTpociWiseAnalysisViewModelPDF);
				listofSectionviewModelPDF.add(sectionViewModelPDF);
				listTpociWiseAnalysisViewModelPDF.addAll(tempListTpociWiseAnalysisViewModelPDF);
			}// end of loop of section iteration

			// set best area and weak area.
			double tempMaxPercentage = 0;
			double tempminPercentage = 100;
			tempBestArea = "";
			tempWeakArea = "";

			for (ResultAnalysisViewModelPDF resAnalysisitrObj : listTpociWiseAnalysisViewModelPDF) {
				if (resAnalysisitrObj.getPercentage() >= tempMaxPercentage) {
					tempMaxPercentage = resAnalysisitrObj.getPercentage();
				}
				if (resAnalysisitrObj.getPercentage() <= tempminPercentage) {
					tempminPercentage = resAnalysisitrObj.getPercentage();
				}
			}

			for (ResultAnalysisViewModelPDF resAnalysisitrObj : listTpociWiseAnalysisViewModelPDF) {
				if (resAnalysisitrObj.getPercentage() == tempMaxPercentage && tempMaxPercentage > 0) {
					tempBestArea = tempBestArea + resAnalysisitrObj.getItemBankName() + ", ";
				}

				if (resAnalysisitrObj.getPercentage() == tempminPercentage) {
					tempWeakArea = tempWeakArea + resAnalysisitrObj.getItemBankName() + ", ";
				}
			}

			// remove comma from last occurrences for best area
			if (tempBestArea.length() > 0) {
				char lastChar = tempBestArea.charAt(tempBestArea.length() - 2);
				if (lastChar == ',') {
					tempBestArea = tempBestArea.substring(0,tempBestArea.length() - 2);
				}
			}

			// remove comma from last occurrences for weak area
			if (tempWeakArea.length() > 0) {
				char lastChar = tempWeakArea.charAt(tempWeakArea.length() - 2);
				if (lastChar == ',') {
					tempWeakArea = tempWeakArea.substring(0,tempWeakArea.length() - 2);
				}
			}
			// add list of section view model and best and weak area code
			listOfQuestionByQuestionDetailsAndBestAndWeakArea = new ArrayList<Object>();
			listOfQuestionByQuestionDetailsAndBestAndWeakArea.add(listofSectionviewModelPDF);
			listOfQuestionByQuestionDetailsAndBestAndWeakArea.add(tempBestArea);
			listOfQuestionByQuestionDetailsAndBestAndWeakArea.add(tempWeakArea);

		} catch (Exception e) {
			LOGGER.error("Exception in getQuestionByQuestionDetailsAndBestAndWeakArea of ResultAnalysisController",e);
		}

		return listOfQuestionByQuestionDetailsAndBestAndWeakArea;
	}

	/**
	 * Method for ECM View Model for PDF
	 * @param itemAnsItr
	 * @param request
	 * @return MultipleChoiceSingleCorrectViewModelPDF this returns ECM view model
	 * @throws Exception
	 */
	private MultipleChoiceSingleCorrectViewModelPDF getECMViewModelPDF(
			ItemAnswersViewModel itemAnsItr, HttpServletRequest request)
					throws Exception {
		MultipleChoiceSingleCorrectViewModelPDF MCSCObj = null;

		MCSCObj = new MultipleChoiceSingleCorrectViewModelPDF();
		if (itemAnsItr.getErrorCorrection() != null) {
			MCSCObj.setItemType(ItemType.EC.ordinal());
			// main item text
			MCSCObj.setItemText(StringEscapeUtils.unescapeHtml(itemAnsItr.getErrorCorrection().getItemText()));
			
		}
		return MCSCObj;
	}
	
	/**
	 * Post method to View Test Score
	 * @param model
	 * @param request
	 * @param examEventID
	 * @param paperID
	 * @param candidateId
	 * @param collectionId
	 * @param displayCategoryId
	 * @param attemptNO
	 * @param loginType
	 * @param sectionId
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/viewtestscore_wkhtml" }, method = { RequestMethod.GET,RequestMethod.POST })
	public String wkhtmlViewtestscoreGet(Model model,HttpServletRequest request,String examEventID,String paperID,String candidateId,String collectionId,String displayCategoryId,String attemptNO,String loginType,String sectionId) {
		 sectionId = "0";
		try {
			long examEventId = Long.valueOf(examEventID);
			long paperId = Long.valueOf(paperID);
			long candidateID = Long.valueOf(candidateId);
			int attmptNo = Integer.valueOf(attemptNO);
			TypingResultAnalysisViewModel resultAnalysisViewModel = null;

			// get user role
			VenueUser user = SessionHelper.getLogedInUser(request);

			// get candidate object
			CandidateServiceImpl objCandidateServiceImpl = new CandidateServiceImpl();
			Candidate objCandidate = objCandidateServiceImpl.getCandidateByCandidateID(Long.valueOf(candidateId));
			String szCandidateName = "";
			if (objCandidate != null) {
				if (objCandidate.getCandidateFirstName() != null) {
					szCandidateName = objCandidate.getCandidateFirstName()+ " ";
				}
				if (objCandidate.getCandidateLastName() != null) {
					szCandidateName = szCandidateName+ objCandidate.getCandidateLastName();
				}
			}

			if (objCandidate != null) {
				model.addAttribute("candidateLoginId",objCandidate.getCandidateUserName());
			}
			
			ResultAnalysisServicesImpl resultAnalysisServicesImplObj = new ResultAnalysisServicesImpl();
			ExamDisplayCategoryPaperViewModel examDisplayCategoryPaperViewModelObj = new ExamDisplayCategoryPaperViewModel();
			examDisplayCategoryPaperViewModelObj = resultAnalysisServicesImplObj.getPaperDetails(paperId, examEventId, candidateID,attmptNo, Long.valueOf(sectionId));

			ResultAnalysisViewModel resultAnalysisViewModelObj = new ResultAnalysisViewModel();
			resultAnalysisViewModelObj = resultAnalysisServicesImplObj.getBriefResultDetails(examEventId, paperId, candidateID,attmptNo);

			List<Long> listRankDigits = getDigitArray(resultAnalysisViewModelObj.getRank());
			List<Long> listRankOutOfDigits = getDigitArray(resultAnalysisViewModelObj.getRankOutOf());

			// display preceding zero in rank on view page
			int diff = 0;
			if (listRankDigits != null && listRankOutOfDigits != null) {
				diff = listRankOutOfDigits.size() - listRankDigits.size();
			}

			List<Long> listRankDigitsWithZero = new ArrayList<Long>();
			for (int i = 0; i < diff; i++) {
				listRankDigitsWithZero.add(0l);
			}

			// set total marks for Incorrect to -0.0
			// if no incorrect question found
			if (resultAnalysisViewModelObj.getTotalMarksObtainedForInCorrect() == 0.0) {
				resultAnalysisViewModelObj.setTotalMarksObtainedForInCorrect(-0.0);
			}

			// check isSectionRequired or not
			SectionServiceImpl sectionServiceImpl = new SectionServiceImpl();
			if (examDisplayCategoryPaperViewModelObj.getPaper().getIsSectionRequired()) {
				List<Section> sectionList = sectionServiceImpl.getSectionListByPaperId(paperId);
				model.addAttribute("sectionList", sectionList);
			}

			model.addAttribute(CANDIDATENAME, szCandidateName);
			model.addAttribute(EXAMDISPLAYCATEGORYPAPERVIEWMODELOBJ,examDisplayCategoryPaperViewModelObj);
			model.addAttribute("resultAnalysisViewModelObj",resultAnalysisViewModelObj);
			model.addAttribute("listRankDigits", listRankDigits);
			model.addAttribute("listRankDigitsWithZero", listRankDigitsWithZero);
			model.addAttribute("listRankOutOfDigits", listRankOutOfDigits);

			// add OES Partner
			getOESPartner(model, request);
			
			
			/**********************************************Topic wise********************************************************/
			try {

				if (candidateId == null) {
					Candidate candidate = SessionHelper.getCandidate(request);
					if (candidate != null) {
						candidateID = candidate.getCandidateID();
					}
				} else {
					candidateID = Long.valueOf(candidateId);
				}

				// Get selected section Id
			/*	String sectionId = request.getParameter("sectionId");*/
				if (sectionId != null && !sectionId.equals("")) {
					model.addAttribute("sectionId", sectionId);
				} else {
					sectionId = "0";
					model.addAttribute("sectionId", sectionId);
				}

				 resultAnalysisServicesImplObj = new ResultAnalysisServicesImpl();
				// ExamDisplayCategoryPaperViewModel examDisplayCategoryPaperViewModelObjTopicWise = new ExamDisplayCategoryPaperViewModel();
				 //examDisplayCategoryPaperViewModelObjTopicWise = resultAnalysisServicesImplObj.getPaperDetails(paperId, examEventId, candidateID,attmptNo, Long.valueOf(sectionId));

				ItemBankAndDifficultyLevelViewModel itemBankAndDifficultyLevelViewModelObj = new ItemBankAndDifficultyLevelViewModel();
				itemBankAndDifficultyLevelViewModelObj = resultAnalysisServicesImplObj.getItemBankWiseResultDetails(examEventId, paperId,candidateID, attmptNo, Long.valueOf(sectionId));

				// get user role
			//	VenueUser user = SessionHelper.getLogedInUser(request);

				// get candidate object
				//CandidateServiceImpl objCandidateServiceImpl = new CandidateServiceImpl();
				 objCandidate = objCandidateServiceImpl.getCandidateByCandidateID(candidateID);
				 szCandidateName = "";
				if (objCandidate != null) {
					if (objCandidate.getCandidateFirstName() != null) {
						szCandidateName = objCandidate.getCandidateFirstName()+ " ";
					}
					if (objCandidate.getCandidateLastName() != null) {
						szCandidateName = szCandidateName+ objCandidate.getCandidateLastName();
					}
				}

				// check isSectionRequired or not
				//SectionServiceImpl sectionServiceImpl = new SectionServiceImpl();
				if (examDisplayCategoryPaperViewModelObj.getPaper().getIsSectionRequired()) {
					List<Section> sectionList = sectionServiceImpl.getSectionListByPaperId(paperId);
					model.addAttribute("sectionList", sectionList);
				}

				// int bestAreaPercentage=readBestAreaPercentage();
				model.addAttribute(CANDIDATENAME, szCandidateName);

				/*model.addAttribute(EXAMEVENTID, examEventId);
				model.addAttribute(PAPERID, paperId);
				model.addAttribute(ATTEMPTNO, attemptNo);
				model.addAttribute(COLLECTIONID, collectionId);
				model.addAttribute(DISPLAYCATEGORYID, displayCategoryId);
				model.addAttribute(CANDIDATEID, candidateID);*/
				if (objCandidate != null) {
					model.addAttribute("candidateLoginId",objCandidate.getCandidateUserName());
				}
				if (user != null) {
					model.addAttribute(ISADMIN, user.getFkRoleID());
				}

				model.addAttribute("examDisplayCategoryPaperViewModelObjTopicWise",examDisplayCategoryPaperViewModelObj);
				model.addAttribute("itemBankAndDifficultyLevelViewModelObj_TopicWise",itemBankAndDifficultyLevelViewModelObj);
				//model.addAttribute(LOGINTYPE, loginType);
				// model.addAttribute("bestAreaPercentage", bestAreaPercentage);

				// add OES Partner
				getOESPartner(model, request);

			} catch (Exception e) {
				LOGGER.error("Error in topicwiseGet controller", e);
				model.addAttribute(Constants.EXCEPTIONSTRING, e);
				return Constants.ERRORPAGE;
			}
			
			/*************************************************End of topic wise************************************************************/
			
			/**************Difficulty level wise*******************/
			try {
				
		
				//ResultAnalysisServicesImpl resultAnalysisServicesImplObj = new ResultAnalysisServicesImpl();
				// examDisplayCategoryPaperViewModelObj = new ExamDisplayCategoryPaperViewModel();
				examDisplayCategoryPaperViewModelObj = resultAnalysisServicesImplObj.getPaperDetails(paperId, examEventId, candidateID,attmptNo, Long.valueOf(sectionId));

				ItemBankAndDifficultyLevelViewModel itemBankAndDifficultyLevelViewModelObj_DiffLevel = new ItemBankAndDifficultyLevelViewModel();
				itemBankAndDifficultyLevelViewModelObj_DiffLevel = resultAnalysisServicesImplObj.getDifficultyLevelWiseResultDetails(examEventId, paperId,candidateID, attmptNo, Long.valueOf(sectionId));

			// check isSectionRequired or not
				//SectionServiceImpl sectionServiceImpl = new SectionServiceImpl();
				if (examDisplayCategoryPaperViewModelObj.getPaper().getIsSectionRequired()) {
					List<Section> sectionList = sectionServiceImpl.getSectionListByPaperId(paperId);
					model.addAttribute("sectionList", sectionList);
				}

				model.addAttribute(CANDIDATENAME, szCandidateName);
				model.addAttribute("itemBankAndDifficultyLevelViewModelObj_DiffLevel",itemBankAndDifficultyLevelViewModelObj_DiffLevel);
				//model.addAttribute(LOGINTYPE, loginType);

				// add OES Partner
				getOESPartner(model, request);

			} catch (Exception e) {
				LOGGER.error("Error in difficultlevelwiseGet controller", e);
			}
			
			/************End of difficulty level wise************************************/
			
			/***********Question By Question************************************/
			QuestionByQusetionAnalysisServicesImpl iQuestionByQuestionAnalysisServices = new QuestionByQusetionAnalysisServicesImpl();
			//SectionServiceImpl sectionServiceImpl = new SectionServiceImpl();
			ExamViewModel examViewModel = null;
			try {
				LinkedHashMap<Long, Boolean> userAnswerMap = new LinkedHashMap<Long, Boolean>();
				int itemType = 0;
				long itemstatus = 0;

				if (candidateId == null) {
					Candidate candidate = SessionHelper.getCandidate(request);
					if (candidate != null) {
						candidateID = candidate.getCandidateID();
					}
				} else {
					candidateID = Long.valueOf(candidateId);
				}

				// code for topic analysis
				List<Item> itemList = new ArrayList<Item>();
			//	String itemBankID = request.getParameter("itemBankSelect");
				
			
					long candidateExamId = iQuestionByQuestionAnalysisServices.getCandidateExamId(Long.parseLong(candidateId),paperId, examEventId, attmptNo);
						List<SectionItemBankViewModel> sectionVmList = iQuestionByQuestionAnalysisServices.getSectionItemBankListByCandidateExamID(candidateExamId);
						Map<Long, Long> itemAnswerMap = new HashMap<>();
						for(SectionItemBankViewModel sectionVm : sectionVmList)
			{
						itemList.addAll(iQuestionByQuestionAnalysisServices.getItemListByItemBankIds(sectionVm.getItemBankIds(),examEventId, paperId,Long.parseLong(candidateId),candidateExamId,attmptNo, sectionVm.getSectionID()));
						itemAnswerMap.putAll(iQuestionByQuestionAnalysisServices.getQuestionCount(candidateID, examEventId, paperId,attmptNo, Long.parseLong(sectionId)));
			}	
				model.addAttribute("itemList", itemList);
				Map<Long, Long> newitemAnswerMap = new HashMap<Long, Long>();
				newitemAnswerMap = getStatusMap(itemAnswerMap, itemList);
				model.addAttribute("itemAnswerMap", newitemAnswerMap);

				long itemID = 0l;
				long itemNo = 0l;

				List<ExamViewModel> examViewModelList = new ArrayList<ExamViewModel>();
				for(Entry<Long,Long> itemMap : itemAnswerMap.entrySet()) {
					/* when particular item is selected show that item details */
						itemID = itemMap.getKey();
						itemType = Integer.parseInt(iQuestionByQuestionAnalysisServices.getItemType(itemID));

						itemstatus = (long) itemAnswerMap.get(itemID);
						examViewModel = iQuestionByQuestionAnalysisServices.getItemDetailsFromID(itemID,examEventId, candidateID, paperId,itemstatus, userAnswerMap, attmptNo);
						examViewModel.setItemType(ItemType.values()[itemType]);
						examViewModel.setItemStatus(itemstatus);
						userAnswerMap.putAll(userAnswerMap);
						examViewModelList.add(examViewModel);
					
				}

				
				if (objCandidate != null) {
					if (objCandidate.getCandidateFirstName() != null) {
						szCandidateName = objCandidate.getCandidateFirstName()+ " ";
					}
					if (objCandidate.getCandidateLastName() != null) {
						szCandidateName = szCandidateName+ objCandidate.getCandidateLastName();
					}
				}
				model.addAttribute(CANDIDATENAME, szCandidateName);

			/*	model.addAttribute("itemstatus", itemstatus);
				model.addAttribute("itemType", ItemType.values()[itemType]);*/
				model.addAttribute("userAnswerMap", userAnswerMap);
				model.addAttribute("examViewModelList", examViewModelList);
				
				model.addAttribute(ATTEMPTNO, attmptNo);
				model.addAttribute("candidateLoginId",objCandidate.getCandidateUserName());
				model.addAttribute(EXAMDISPLAYCATEGORYPAPERVIEWMODELOBJ,examDisplayCategoryPaperViewModelObj);
				model.addAttribute("filepath", FileUploadHelper.getRelativeFolderPath(request, "FileUploadPath"));

				// add OES Partner
				getOESPartner(model, request);

			} catch (NumberFormatException e) {
				LOGGER.error("Error in questionByquestionGet controller", e);
			}
			
			/****************End of question by question*************************************************/
			
			

		} catch (Exception ex) {
			LOGGER.error("Error in viewtestscoreGet()", ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		return "Solo/candidateModule/viewtestscore_Report";

	}
	
	/**
	 * Post method to Generate Analysis Booklet Report
	 * @param request
	 * @param response
	 * @param requestParamsViewModel
	 * @return String this returns the path of a view
	 */
	@ResponseBody
	@RequestMapping(value = { "/generateAnalysisBookletReport" }, method ={ RequestMethod.POST})
	public String generateAnalysisTestReport(HttpServletRequest request,HttpServletResponse response,@RequestBody AnalysisBookletRequestParamViewModel requestParamsViewModel){
		String pdfGeneratedpath = null;
		try {
			HTMLToPDFHelper htmlToPdfHelper = new HTMLToPDFHelper();
			List<String> listCmd=new ArrayList<String>();
			listCmd.add("--header-right");
			listCmd.add("[page]/[topage]");
			//http://localhost:8080/OES-CLIENTWeb/ResultAnalysis/viewtestscore_wkhtml?examEventId=69&paperId=1223&candidateId=464215&collectionId=276&displayCategoryId=0&loginType=&attemptNo=1&sectionId=0
			listCmd.add(htmlToPdfHelper.makeFullURL(request, "/ResultAnalysis/viewtestscore_wkhtml?examEventID="+requestParamsViewModel.getExamEventID()+"&paperID="+requestParamsViewModel.getPaperID()+"&candidateId="+requestParamsViewModel.getCandidateId()+"&collectionId="+requestParamsViewModel.getCollectionID()+"&displayCategoryId="+requestParamsViewModel.getDisplayCategoryId()+"&attemptNO="+requestParamsViewModel.getAttemptNo()+"&loginType="+requestParamsViewModel.getLoginType()+"&sectionId="+requestParamsViewModel.getSectionID()));
			listCmd.add("--cookie");
			listCmd.add("JSESSIONID");
			listCmd.add(request.getSession(false).getId());
			String fileName = "Analysis_booklet_CandID_"+requestParamsViewModel.getCandidateId()+new Date().getTime()+".pdf";
			pdfGeneratedpath = htmlToPdfHelper.generateHTMLToPDF(listCmd, fileName);
			
		} catch (Exception e) {
			LOGGER.error("Exception occured in generatePDFFromPaperTemplate: ", e);
		}
		
		return pdfGeneratedpath;
	}
	
}
