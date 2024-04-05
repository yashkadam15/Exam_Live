/**
 * 
 */
package mkcl.oesclient.admin.controllers;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.ObjectMapper;

import mkcl.oesclient.admin.services.CertificateServicesImpl;
import mkcl.oesclient.admin.services.EligibilityCertificateServicesImpl;
import mkcl.oesclient.admin.services.ExamScheduleServiceImpl;
import mkcl.oesclient.commons.services.ExamEventConfigurationServiceImpl;
import mkcl.oesclient.commons.services.PaperServiceImpl;
import mkcl.oesclient.commons.utilities.AppInfoHelper;
import mkcl.oesclient.commons.utilities.Constants;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.model.CandidateExam;
import mkcl.oesclient.model.VenueUser;
import mkcl.oesclient.pdfgenerator.PDFComponent;
import mkcl.oesclient.solo.services.CandidateExamServiceImpl;
import mkcl.oesclient.systemaudit.AuditVerificationMethods;
import mkcl.oesclient.systemaudit.BrowserInfo;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.oesclient.viewmodel.BatchCertificateViewModel;
import mkcl.oespcs.model.ExamEvent;
import mkcl.oespcs.model.ExamEventPaperDetails;
import mkcl.oespcs.model.Paper;
import mkcl.oespcs.model.PaperType;

/**
 * @author virajd
 * 
 */
@Controller
@RequestMapping("EligibilityCertificate")
public class EligibilityCertificateController {
	private static final Logger LOGGER = LoggerFactory
			.getLogger(EligibilityCertificateController.class);
	private static final String ERRORPAGE = Constants.ERRORPAGE;
	private static final String EXCEPTIONSTRING = Constants.EXCEPTIONSTRING;

	private static final String EXAMEVENTID = "examEventId";
	private static final String PAPERID = "paperId";
	private static final String LISTCANDIDATEEXAM = "listCandidateExam";
	private static final String ELIGIBILITYCERTIFICATE = "Admin/EligibilityCertificate/EligibilityCertificateCandidateList";
	private static final String ELIGIBILITY_CERTS_NOTYPING = "Admin/EligibilityCertificate/EligibilityCertsListNoTyping";

	/**
	 * Method to fetch the Active Exam Event List
	 * @param request
	 * @return String this returns the path of a view
	 */
	@ModelAttribute("activeExamEventList")
	public List<ExamEvent> getActiveExamEventList(HttpServletRequest request) {
		List<ExamEvent> activeExamEventList = null;
		try {
			ExamScheduleServiceImpl eServiceObj = new ExamScheduleServiceImpl();
			/* Active exam Event List */
			VenueUser user = SessionHelper.getLogedInUser(request);
			activeExamEventList = eServiceObj.getActiveExamEventList(user);

		} catch (Exception e) {
			LOGGER.error("Exception occured in getActiveExamEventList", e);
		}
		return activeExamEventList;
	}

	/**
	 * Post method to List Paper Associated to Exam Event
	 * @param examEvent
	 * @param request
	 * @return List<Paper> this returns the PaperList
	 */
	@RequestMapping(value = "/listPaperAssociatedToEvent.ajax", method = RequestMethod.POST)
	@ResponseBody
	public List<Paper> getPaperList(@RequestBody ExamEvent examEvent,
			HttpServletRequest request) {
		List<Paper> paperList = null;
		try {
			PaperServiceImpl objPaperServiceImpl = new PaperServiceImpl();
			paperList = new ArrayList<Paper>();
			paperList = objPaperServiceImpl.getPaperAssociatedWithEvent(examEvent.getExamEventID(),true);
		} catch (Exception e) {
			LOGGER.error("Exception in getPaperList: ", e);
		}
		return paperList;
	}

	/**
	 * Post method to fetch the List of Non-Typing Papers Associated to the Exam Event
	 * @param examEvent
	 * @param request
	 * @return List<Paper> this returns the PaperList
	 */
	@RequestMapping(value = "/listPaperAssociatedToEventNoTyping.ajax", method = RequestMethod.POST)
	@ResponseBody
	public List<Paper> getPaperListNoTyping(@RequestBody ExamEvent examEvent,
			HttpServletRequest request) {
		List<Paper> paperList = null;
		try {
			PaperServiceImpl objPaperServiceImpl = new PaperServiceImpl();
			paperList = new ArrayList<Paper>();
			paperList = objPaperServiceImpl.getPaperAssociatedWithEvent(examEvent.getExamEventID(),false);
		} catch (Exception e) {
			LOGGER.error("Exception in getPaperList: ", e);
		}
		return paperList;
	}

	/**
	 * Post method for Paper Attempt Dates List
	 * @param examEventPaperDetails
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/listPaperAttemptDates.ajax", method = RequestMethod.POST)
	@ResponseBody
	public void getPaperAttemptDateList(
			@RequestBody ExamEventPaperDetails examEventPaperDetails,
			HttpServletRequest request, HttpServletResponse response) {
		List<Date> paperAttemptDateList = null;
		try {
			CandidateExamServiceImpl objCandidateExamServiceImpl = new CandidateExamServiceImpl();
			paperAttemptDateList = new ArrayList<Date>();
			paperAttemptDateList = objCandidateExamServiceImpl.getPaperAttemptDates(examEventPaperDetails.getExamEventID(),examEventPaperDetails.getFkPaperID());
		
		ObjectMapper objectMapper = new ObjectMapper();
		objectMapper.setDateFormat(new SimpleDateFormat("dd-MM-yyyy"));
		objectMapper.writeValue(response.getOutputStream(), paperAttemptDateList);
		} catch (Exception e) {
			LOGGER.error("Exception in getPaperAttemptDateList: ", e);
		}
	}

	/**
	 * Get method for Eligibility Certificate
	 * @param model
	 * @param request
	 * @param messageid
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/eligibilityCertificate" }, method = RequestMethod.GET)
	public String eligibilityCertificateGet(Model model,
			HttpServletRequest request, String messageid, Locale locale) {
		if (messageid != null && !messageid.isEmpty()) {
			MKCLUtility.addMessage(Integer.parseInt(messageid), model, locale);
		}

		return ELIGIBILITYCERTIFICATE;
	}

	/**
	 * Post method for Eligibility Certificate Candidate List
	 * @param model
	 * @param request
	 * @param locale
	 * @return  String this returns the path of a view
	 */
	@RequestMapping(value = { "/EligibilityCerticateCandidatelist" }, method = RequestMethod.POST)
	public String listGet(Model model, HttpServletRequest request, Locale locale) {

		EligibilityCertificateServicesImpl objEligibilityCertificateServicesImpl = new EligibilityCertificateServicesImpl();
		List<CandidateExam> listCandidateExam = new LinkedList<CandidateExam>();
		try {
			Long examEventId = 0l;
			Long paperId = 0l;
			String strExamEventId = request.getParameter("examEventSelect");
			if (strExamEventId != null && !(strExamEventId.equals(""))) {
				examEventId = Long.valueOf(strExamEventId);
			}

			String strPaperId = request.getParameter("paperSelect");
			if (strPaperId != null && !(strPaperId.equals(""))) {
				paperId = Long.valueOf(strPaperId);
			}

			String strAttemptDate = request.getParameter("paperAttemptDateSelect");

			/** Add message into model. */
			String messageId = request.getParameter("messageid");
			if (messageId != null && !(messageId.equals(""))) {
				MKCLUtility.addMessage(Integer.parseInt(messageId), model,locale);
			}

			listCandidateExam = objEligibilityCertificateServicesImpl.getCandidateEligibilityReport(examEventId, paperId,strAttemptDate);
			// for display message of record not found
			if (listCandidateExam == null || listCandidateExam.size() == 0) {

				model.addAttribute("errorclass", "notDisplayInfo");
				model.addAttribute("message", "info");
				model.addAttribute("messageText", "<b>Record not found</b>");
			}

			// Get paper passing marks
			ExamEventConfigurationServiceImpl objEventConfigurationServiceImpl = new ExamEventConfigurationServiceImpl();
			Double objPassingMarks = objEventConfigurationServiceImpl.getPassingMarksForPaper(examEventId, paperId);

			model.addAttribute(EXAMEVENTID, examEventId);
			model.addAttribute(PAPERID, paperId);
			model.addAttribute("paperAttemptDate", strAttemptDate);
			model.addAttribute(LISTCANDIDATEEXAM, listCandidateExam);
			model.addAttribute("objPassingMarks", objPassingMarks);
			return ELIGIBILITYCERTIFICATE;
		} catch (Exception ex) {
			LOGGER.error("Exception in listGet EligibilityCertificateController:",ex);
			model.addAttribute(EXCEPTIONSTRING, ex);
			return ERRORPAGE;
		}
	}

	// method to generate certificate
	/**
	 * Post method to Print Certificate
	 * @param request
	 * @param response
	 * @param model
	 * @param pID
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "/PrintCertificate", method = RequestMethod.POST)
	public String getCertificatepdf(HttpServletRequest request,
			HttpServletResponse response, Model model,String pID) {
		BatchCertificateViewModel batchCertificates = null;
		try {
			/*Changes for loading client wise dynamic loading of logos:Yograj 15-Jul-2015*/
			long clientID=AppInfoHelper.appInfo.getClientID();
			model.addAttribute("logo", clientID+"_mkclLogo.png");
			
			// code to fetch selected candidate examid in string split by '|'
			String listOfCandidateExamID = request
					.getParameter("hdnExamIdList");
			if (listOfCandidateExamID != null
					&& !listOfCandidateExamID.isEmpty()) {
				String[] arrayOfCandidateExamID = listOfCandidateExamID
						.split("\\|");
				List<String> listOfceID = Arrays.asList(arrayOfCandidateExamID);
				List<Long> listOfcandidateExamID = new ArrayList<Long>();
				for (String ceID : listOfceID) {
					listOfcandidateExamID.add(Long.valueOf(ceID));
				}
				
				// validation if browser is compatible to generate certificate in html format.
				// get browser information
				String userAgent = request.getHeader("User-Agent");
				BrowserInfo browserInfo = AuditVerificationMethods.verifyCompatibleBrowser(userAgent);
				LOGGER.info("broswer name :: "+browserInfo.getBrowserName());
				if(!browserInfo.getBrowserName().equalsIgnoreCase("Firefox")){
					return "forward:PrintCertificateInHTMLTyping";
				}

				batchCertificates = new CertificateServicesImpl().getCertificateData(listOfcandidateExamID);
				batchCertificates.setRequestURL(request.getRequestURL().toString());
				/*Changes for loading client wise dynamic loading of logos:Yograj 15-Jul-2015*/
				batchCertificates.setLogoName("resources/images/"+clientID+"_mkclLogo.png");

				PDFComponent<BatchCertificateViewModel> pdfGen = new PDFComponent<BatchCertificateViewModel>(request, response);
				String timestamp = new java.text.SimpleDateFormat("MMddyyyyHmmssa").format(new Date());
				pdfGen.setPdfFileName("EligibiltyCertificate_Typing_"+timestamp);
				pdfGen.setInputsToXML(batchCertificates);
				pdfGen.setStyleSheetXSLName("templateCertificate_Typing.xsl");
				boolean status = pdfGen.startPDFGeneratorEngine();
				// code to display message
				if (!status) {
					pdfGen.writeErrorResponseContent();
				}
				batchCertificates = null;
			} else {
				return "redirect:eligibilityCertificate?messageid=" + 1001;
			}
		} catch (Exception e) {
			LOGGER.error("Exception occured in getpdf: ", e);
			model.addAttribute(EXCEPTIONSTRING, e);
			return ERRORPAGE;

		}
		return null;
	}

	// code to generate certificate whose paper type is not typing
	/**
	 * Get method for Non-typing Eligibility Certificate 
	 * @param model
	 * @param request
	 * @param messageid
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/eligibilityCertificateNoTyping" }, method = RequestMethod.GET)
	public String eligibilityCertificateGetNoTyping(Model model,
			HttpServletRequest request, String messageid, Locale locale) {
		if (messageid != null && !messageid.isEmpty()) {
			MKCLUtility.addMessage(Integer.parseInt(messageid), model, locale);
		}

		return ELIGIBILITY_CERTS_NOTYPING;
	}

	/**
	 * Post method for Non-typing Eligibility Certificate Candidate List
	 * @param model
	 * @param request
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/EligibilityCerticateCandidatelistNoTyping" }, method = RequestMethod.POST)
	public String listGetNoTyping(Model model, HttpServletRequest request, Locale locale) {
		EligibilityCertificateServicesImpl objEligibilityCertificateServicesImpl = new EligibilityCertificateServicesImpl();
		List<CandidateExam> listCandidateExam = new LinkedList();
		try
		{
			Long examEventId = Long.valueOf(0L);
			Long paperId = Long.valueOf(0L);
			Double dTotalMarks = Double.valueOf(0.0D);

			String strExamEventId = request.getParameter("examEventSelect");
			if ((strExamEventId != null) && (!strExamEventId.equals(""))) {
				examEventId = Long.valueOf(strExamEventId);
			}
			String strPaperId = request.getParameter("paperSelect");
			if ((strPaperId != null) && (!strPaperId.equals(""))) {
				paperId = Long.valueOf(strPaperId);
			}
			String strAttemptDate = request.getParameter("paperAttemptDateSelect");
			String messageId = request.getParameter("messageid");
			if ((messageId != null) && (!messageId.equals(""))) {
				MKCLUtility.addMessage(Integer.parseInt(messageId), model, locale);
			}
			listCandidateExam = objEligibilityCertificateServicesImpl.getCandidateEligibilityReport(examEventId.longValue(), paperId.longValue(),strAttemptDate);
			if ((listCandidateExam == null) || (listCandidateExam.size() == 0))
			{
				model.addAttribute("errorclass", "notDisplayInfo");
				model.addAttribute("message", "info");
				model.addAttribute("messageText", "<b>Record not found</b>");
			}
			ExamEventConfigurationServiceImpl objEventConfigurationServiceImpl = new ExamEventConfigurationServiceImpl();
			Double objPassingMarks = objEventConfigurationServiceImpl.getPassingMarksForPaper(examEventId.longValue(), paperId.longValue());

			model.addAttribute("examEventId", examEventId);
			model.addAttribute("paperId", paperId);
			model.addAttribute("paperAttemptDate", strAttemptDate);
			model.addAttribute("listCandidateExam", listCandidateExam);
			model.addAttribute("objPassingMarks", objPassingMarks);
			return ELIGIBILITY_CERTS_NOTYPING;
		}
		catch (Exception ex)
		{
			LOGGER.error("Exception in listGet EligibilityCertificateController:",ex);
			model.addAttribute("exception", ex);
		}
		return "Common/Error/error";
	}

	// method to generate certificate
	/**
	 * Post method for Non-typing Print Certificate
	 * @param request
	 * @param response
	 * @param model
	 * @param pID
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "/PrintCertificateNoTyping", method = RequestMethod.POST)
	public String getCertificatepdfNoTyping(HttpServletRequest request,
			HttpServletResponse response, Model model,String pID ) {
		BatchCertificateViewModel batchCertificates = null;
		try
		{
			String listOfCandidateExamID = request
					.getParameter("hdnExamIdList");
			if ((listOfCandidateExamID != null) && 
					(!listOfCandidateExamID.isEmpty()))
			{
				String[] arrayOfCandidateExamID = listOfCandidateExamID
						.split("\\|");
				List<String> listOfceID = Arrays.asList(arrayOfCandidateExamID);
				List<Long> listOfcandidateExamID = new ArrayList();
				for (String ceID : listOfceID) {
					listOfcandidateExamID.add(Long.valueOf(ceID));
				}
				// validation if browser is compatible to generate certificate in html format.
				// get browser information
				String userAgent = request.getHeader("User-Agent");
				BrowserInfo browserInfo = AuditVerificationMethods.verifyCompatibleBrowser(userAgent);
				LOGGER.info("broswer name :: "+browserInfo.getBrowserName());
				if(!browserInfo.getBrowserName().equalsIgnoreCase("Firefox")){
					return "forward:PrintCertificateInHTMLNoTyping";
				}

				batchCertificates = new CertificateServicesImpl().getCertificateData(listOfcandidateExamID);
				batchCertificates.setRequestURL(request.getRequestURL().toString());

				PDFComponent<BatchCertificateViewModel> pdfGen = new PDFComponent( request, response);
				String timestamp = new SimpleDateFormat("MMddyyyyHmmssa").format(new Date());
				pdfGen.setPdfFileName("EligibiltyCertificate_" + timestamp);
				pdfGen.setInputsToXML(batchCertificates);
				pdfGen.setStyleSheetXSLName("templateCertificate.xsl");
				boolean status = pdfGen.startPDFGeneratorEngine();
				if (!status) {
					pdfGen.writeErrorResponseContent();
				}
				batchCertificates = null;
			}
			else
			{
				return "redirect:eligibilityCertificate?messageid=1001";
			}
		}
		catch (Exception e)
		{
			LOGGER.error("Exception occured in getpdf: ", e);
			model.addAttribute("exception", e);
			return "Common/Error/error";
		}
		return null;
	}


	// method to generate certificate in html certificate
	/**
	 * Post method to Print Typing Certificate in HTML
	 * @param request
	 * @param response
	 * @param model
	 * @param pID
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "/PrintCertificateInHTMLTyping", method = RequestMethod.POST)
	public String getCertificateInHTMLTyping(HttpServletRequest request,
			HttpServletResponse response, Model model,String pID) {
		BatchCertificateViewModel batchCertificates = null;
		try {
			PaperType paperType = new PaperServiceImpl().getpaperByPaperID(Long.parseLong(pID)).getPaperType();
			// code to fetch selected candidate examid in string split by '|'
			String listOfCandidateExamID = request
					.getParameter("hdnExamIdList");
			if (listOfCandidateExamID != null&& !listOfCandidateExamID.isEmpty()) {
				String[] arrayOfCandidateExamID = listOfCandidateExamID.split("\\|");
				List<String> listOfceID = Arrays.asList(arrayOfCandidateExamID);
				List<Long> listOfcandidateExamID = new ArrayList<Long>();
				for (String ceID : listOfceID) {
					listOfcandidateExamID.add(Long.valueOf(ceID));
				}

				batchCertificates = new CertificateServicesImpl().getCertificateData(listOfcandidateExamID);
				batchCertificates.setRequestURL(request.getRequestURL().toString());

				model.addAttribute("batchCerts", batchCertificates.getListofCertificateViewModel());


			} else {
				return "redirect:eligibilityCertificate?messageid=" + 1001;
			}
		} catch (Exception e) {
			LOGGER.error("Exception occured in getpdf: ", e);
			model.addAttribute(EXCEPTIONSTRING, e);
			return ERRORPAGE;

		}
		return "Admin/EligibilityCertificate/certificatesTyping";
	}

	// method to generate certificate in html certificate
	/**
	 * Post method to Print Non-typing Certificate in HTML
	 * @param request
	 * @param response
	 * @param model
	 * @param pID
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "/PrintCertificateInHTMLNoTyping", method = RequestMethod.POST)
	public String getCertificateInHTMLNoTyping(HttpServletRequest request,
			HttpServletResponse response, Model model,String pID) {
		BatchCertificateViewModel batchCertificates = null;
		try {
			PaperType paperType = new PaperServiceImpl().getpaperByPaperID(Long.parseLong(pID)).getPaperType();
			// code to fetch selected candidate examid in string split by '|'
			String listOfCandidateExamID = request
					.getParameter("hdnExamIdList");
			if (listOfCandidateExamID != null&& !listOfCandidateExamID.isEmpty()) {
				String[] arrayOfCandidateExamID = listOfCandidateExamID.split("\\|");
				List<String> listOfceID = Arrays.asList(arrayOfCandidateExamID);
				List<Long> listOfcandidateExamID = new ArrayList<Long>();
				for (String ceID : listOfceID) {
					listOfcandidateExamID.add(Long.valueOf(ceID));
				}

				batchCertificates = new CertificateServicesImpl().getCertificateData(listOfcandidateExamID);
				batchCertificates.setRequestURL(request.getRequestURL().toString());

				model.addAttribute("batchCerts", batchCertificates.getListofCertificateViewModel());


			} else {
				return "redirect:eligibilityCertificate?messageid=" + 1001;
			}
		} catch (Exception e) {
			LOGGER.error("Exception occured in getpdf: ", e);
			model.addAttribute(EXCEPTIONSTRING, e);
			return ERRORPAGE;

		}
		return "Admin/EligibilityCertificate/certificatesNoTyping";
	}



}
