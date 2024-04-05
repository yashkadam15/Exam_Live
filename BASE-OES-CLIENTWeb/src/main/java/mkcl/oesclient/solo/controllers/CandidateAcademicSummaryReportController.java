package mkcl.oesclient.solo.controllers;

import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mkcl.oesclient.admin.services.ExamScheduleServiceImpl;
import mkcl.oesclient.commons.services.DisplayCategoryLanguageServImpl;
import mkcl.oesclient.commons.utilities.Constants;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.commons.utilities.Pagination;
import mkcl.oesclient.model.CollectionMaster;
import mkcl.oesclient.model.VenueUser;
import mkcl.oesclient.pdfgenerator.PDFComponent;
import mkcl.oesclient.pdfviewmodel.CASViewModel;
import mkcl.oesclient.pdfviewmodel.CandidateAcademicSummaryViewModelPDF;
import mkcl.oesclient.solo.services.CandidateAcademicSummaryReportServices;
import mkcl.oesclient.utilities.HTMLToPDFHelper;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.oespcs.model.DisplayCategoryLanguage;
import mkcl.oespcs.model.ExamEvent;
import mkcl.oesserver.model.NaturalLanguage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
/**
 * @author reenak
 * 
 */
@Controller
@RequestMapping("candidateReport")
public class CandidateAcademicSummaryReportController {

	private static Logger LOGGER = LoggerFactory.getLogger(CandidateAcademicSummaryReportController.class);
	private static final String ERRORPAGE = Constants.ERRORPAGE;
	private static final String EXCEPTIONSTRING = Constants.EXCEPTIONSTRING;
	private static final long ONE = 1;
	private static final String COLLECTIONID = "collectionId";
	private static final String USERROLE = "userRole";
	private String CANDIDATEACADEMICSUMMARYJSP="";
	private static final String EXAMEVENTID =  "examEventId"; 
	private static final String CANDIDATEID="candidateId";
	private static final String DISPLAYCATEGORYID="displayCategoryId";
	private static final String CANDNAME="candidateName";
	private static final String CANDLOGINID="loginId";


	/*
	 * Get Active Exam Event List
	 */
	//@ModelAttribute("activeExamEventList")
	/**
	 * Method to fetch the Active Exam Event List
	 * @param user
	 * @return List<ExamEvent> this returns the ExamEventList
	 */
	public List<ExamEvent> getactiveExamEventList(VenueUser user ) {
		List<ExamEvent> activeExamEventList = null;
		try {
			
			ExamScheduleServiceImpl eServiceObj = new ExamScheduleServiceImpl();
			/* Active exam Event List */
			activeExamEventList = eServiceObj.getActiveExamEventList(user);
		} catch (Exception e) {
		LOGGER.error("Exception occured in getactiveExamEventList",e);
		}
		return activeExamEventList;
	}

	
	/*
	 * Ajax call to get Collection based on Selected Exam event
	 */
	/**
	 * Post method for Collection List Associated to the Exam Event and Role
	 * @param examEventID
	 * @param request
	 * @return List<CollectionMaster> this returns the Collection List
	 */
	@RequestMapping(value = "/collectionMasterAccEventRole.ajax", method = RequestMethod.POST)
	@ResponseBody
	public List<CollectionMaster> getEventWiseCollectionList(
			@RequestBody ExamEvent examEventID, HttpServletRequest request) {
		List<CollectionMaster> collectionList=null;
		try {
			VenueUser user = SessionHelper.getLogedInUser(request);

			ExamScheduleServiceImpl eServiceObj = new ExamScheduleServiceImpl();
			collectionList = new ArrayList<CollectionMaster>();
			collectionList = eServiceObj.getCollectionMasterAccRole(user,
					examEventID.getExamEventID());
		} catch (Exception e) {
		LOGGER.error("Exception occured in CandidateAcademicSummaryReportController - getEventWiseCollectionList ",e);
		}
		return collectionList;
	}
	
	/*
	 * Ajax call to get Display Category based on Selected Exam event
	 */
	/*@RequestMapping(value = "/dispalyCategoryAccExamEvent.ajax", method = RequestMethod.POST)
	@ResponseBody*/
	//@ModelAttribute("displayCategoryList")
	/**
	 * Method to fetch the Exam Event wise Display Category List
	 * @param examEventID
	 * @return List<DisplayCategoryLanguage> this returns the DisplayCategoryLanguageList
	 */
	public List<DisplayCategoryLanguage> getEventWiseDisplayCategoryList(long examEventID
			) {
		//@RequestBody ExamEvent examEventID, HttpServletRequest request
		List<DisplayCategoryLanguage> displayCategoryLanguageList=null;
		try {		
			
			DisplayCategoryLanguageServImpl disLanguageServiceObj = new DisplayCategoryLanguageServImpl();
			displayCategoryLanguageList = new ArrayList<DisplayCategoryLanguage>();
			displayCategoryLanguageList = disLanguageServiceObj.getDisplayCategoryLanguageByEventID(examEventID);
		} catch (Exception e) {
		LOGGER.error("Exception occured in CandidateAcademicSummaryReportController - getEventWiseCollectionList ",e);
		}
		return displayCategoryLanguageList;
	}
	
	/*
	 * CandidateAcademic Summary Report View
	 */
	/**
	 * Get method for Candidate Academic Summary Report
	 * @param model
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/CandidateAcademicSummaryReport" }, method = RequestMethod.GET)
	public String candidateSummaryReportView(Model model, HttpServletRequest request) {
		
		try {
			
			VenueUser user = SessionHelper.getLogedInUser(request);
			if (user.getFkRoleID() == 1) {
				model.addAttribute(USERROLE, ONE);
				List<ExamEvent> events=getactiveExamEventList(user);
				model.addAttribute("activeExamEventList",events);
				return "Solo/CandidateAcademicSummaryReport/CandidateSummaryReportList";
				
			} else if (user.getFkRoleID() == 3){
				model.addAttribute(USERROLE, 3);
				
				List<DisplayCategoryLanguage> categoryLanguages=getEventWiseDisplayCategoryList(SessionHelper.getExamEvent(request).getExamEventID());
				
				model.addAttribute("displayCategoryList",categoryLanguages);
				return "Solo/CandidateAcademicSummaryReport/CandidateSummaryReport";
				
			}
			
		} catch (Exception e) {
			LOGGER.error("Exception occured in candidateSummaryReportView: " , e);
		}
		model.addAttribute("errorMsg", "user role not found");
		return "Common/Error/GenericError";

	}

	/**
	 * Post method for Candidate Academic Summary Report
	 * @param model
	 * @param request
	 * @param locale
	 * @param response
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/CandidateAcademicSummaryReport" }, method = RequestMethod.POST)
	public String listGet(Model model, HttpServletRequest request, Locale locale,HttpServletResponse response) 
	{
		
		CandidateAcademicSummaryReportServices candidateAcademicSummaryReportServices = new CandidateAcademicSummaryReportServices();
		long collectionId = 0;
		long examEventId = 0;
		long displayCategoryId = 0;
		long candidateId = 0;
		String loginId="";
		String candidateName="";
		try {	
			
			
			
			if(request.getParameter("displayCategorySelect")!=null)
				displayCategoryId = Long.valueOf(request.getParameter("displayCategorySelect"));
			
			if(request.getParameter("candidateId")!=null)
				candidateId=Long.valueOf(request.getParameter("candidateId"));
			if(request.getParameter("candidateName")!=null)
				candidateName=request.getParameter("candidateName").toString();
			if(request.getParameter("loginId")!=null)
				loginId=request.getParameter("loginId").toString();
			
			/** Add message into model. */
			String messageId = request.getParameter("messageid");
			if (messageId != null && !(messageId.equals(""))) 
			{
				MKCLUtility.addMessage(Integer.parseInt(messageId), model,locale);
			}
			// get user form session to find user role
			VenueUser user = SessionHelper.getLogedInUser(request);
			if (user.getFkRoleID() == 1) 
			{
				examEventId = Long.valueOf(request.getParameter("examEventSelect"));		
				if(request.getParameter("searchCand")!=null)
				{
					/** 2 Get searchText. */
					String searchText = request.getParameter("searchText");
					Pagination pagination = new Pagination();
					pagination.setListName("listCandidateAcademicSummaryReport");
					
					model.addAttribute(EXAMEVENTID, examEventId);
					model.addAttribute(COLLECTIONID, collectionId);
					model.addAttribute(CANDIDATEID,candidateId);
					model.addAttribute(CANDNAME,candidateName);			
					model.addAttribute(CANDLOGINID,loginId);
					model.addAttribute(DISPLAYCATEGORYID, displayCategoryId);


					/** 3 Get Object list. */
					if (searchText != null && !(searchText.equals(""))) 
					{
						pagination.setPropertyName("CANDIDATEFIRSTNAME");
						/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
						candidateAcademicSummaryReportServices.pagination(null,
								pagination, searchText, model);
					} 
					else 
					{
						/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
						candidateAcademicSummaryReportServices.pagination(null,
								pagination, searchText, model);
					}
					
					if(request.getParameter("collectionSelect")!=null)			
						collectionId = Long.valueOf(request.getParameter("collectionSelect"));
					model.addAttribute(USERROLE, ONE);
					List<ExamEvent> events=getactiveExamEventList(user);
					model.addAttribute("activeExamEventList",events);
					return "Solo/CandidateAcademicSummaryReport/CandidateSummaryReportList";
				}		
				
			} 
			else if (user.getFkRoleID() == 3)
			{
				model.addAttribute(USERROLE, 3);
				examEventId = SessionHelper.getExamEvent(request).getExamEventID();	
				collectionId=SessionHelper.getCollectionID(request);
				/*if(request.getParameter("collectionId")!=null)			
					collectionId = Long.valueOf(request
							.getParameter("collectionId"));*/
				List<DisplayCategoryLanguage> categoryLanguages=getEventWiseDisplayCategoryList(SessionHelper.getExamEvent(request).getExamEventID());
				/** 2 Get searchText. */
				String searchText = request.getParameter("searchText");
				Pagination pagination = new Pagination();
				pagination.setListName("listCandidateAcademicSummaryReport");
				
				model.addAttribute(EXAMEVENTID, examEventId);
				model.addAttribute(COLLECTIONID, collectionId);
				model.addAttribute(CANDIDATEID,candidateId);
				model.addAttribute(CANDNAME,candidateName);			
				model.addAttribute(CANDLOGINID,loginId);
				model.addAttribute(DISPLAYCATEGORYID, displayCategoryId);


				/** 3 Get Object list. */
				if (searchText != null && !(searchText.equals(""))) 
				{
					pagination.setPropertyName("CANDIDATEFIRSTNAME");
					/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
					candidateAcademicSummaryReportServices.pagination(null,
							pagination, searchText, model);
				} 
				else 
				{
					/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
					candidateAcademicSummaryReportServices.pagination(null,
							pagination, searchText, model);
				}
				model.addAttribute("displayCategoryList",categoryLanguages);
				return "Solo/CandidateAcademicSummaryReport/CandidateSummaryReport";
				
			}			
			model.addAttribute("errorMsg", "user role not found");
			return "Common/Error/GenericError";
		} 
		catch (Exception ex) 
		{
			LOGGER.error("Exception occured in CandidateAcademicSummaryReportController-listGet: " , ex);
			model.addAttribute(EXCEPTIONSTRING, ex);
			return ERRORPAGE;
		}
	}
	
	/**
	 * Post method for Candidate Academic Summary Report from HTML to PDF
	 * @param model
	 * @param request
	 * @param locale
	 * @param response
	 * @param casViewModel
	 * @return String this returns the generated PDF file name
	 */
	@ResponseBody
	@RequestMapping(value = { "/CasReportFromHtml" }, method = RequestMethod.POST)
	public String ajaxGet(Model model, HttpServletRequest request, Locale locale,HttpServletResponse response,  @RequestBody CASViewModel casViewModel) 
	{
		
		//CandidateAcademicSummaryReportServices candidateAcademicSummaryReportServices = new CandidateAcademicSummaryReportServices();
		long collectionId = casViewModel.getCollectionID();
		long examEventId = casViewModel.getExamEventID();
		long candidateId = casViewModel.getCandidateID();
		try {	
			
			HTMLToPDFHelper htmlToPdfHelper = new HTMLToPDFHelper();
			List<String> listCmd=new ArrayList<String>();
			
			listCmd.add("--footer-font-name");
			listCmd.add("APARAJ");
			
			listCmd.add("--footer-font-size");
			listCmd.add("8");
			listCmd.add("--footer-left");
			listCmd.add("Candidate(s) Academic Summary Report");
			listCmd.add("--footer-right");
			listCmd.add("[page] of [topage]");
			
			listCmd.add(htmlToPdfHelper.makeFullURL(request, "/candidateReport/createCASReprotFromHtml?examEventId="+examEventId+"&collectionId="+collectionId+"&candidateId="+candidateId));
			listCmd.add("--cookie");
			listCmd.add("JSESSIONID");
			listCmd.add(request.getSession(false).getId());
		
		
			ExamEvent examEvent = new ExamEvent();					
			String fileName = "CSR_" +  examEvent.getExamEventID()+"_" + new java.util.Date().getTime() + ".pdf";
			String generatedPdfFileName = new HTMLToPDFHelper().generateHTMLToPDF(listCmd, fileName);
			return generatedPdfFileName;
		} 
		catch (Exception ex) 
		{
			LOGGER.error("Exception occured in CandidateAcademicSummaryReportController-listGet: " , ex);
			model.addAttribute(EXCEPTIONSTRING, ex);
			return ERRORPAGE;
		}
	}
	
	/**
	 * Post method for Candidate Academic Summary Report List Pagination - Next
	 * @param model
	 * @param pagination
	 * @param searchText
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/next" }, method = RequestMethod.POST)
	public String nextGet(Model model,
			@ModelAttribute("pagination") Pagination pagination,
			String searchText, HttpServletRequest request) {
		pagination.setListName("listCandidateAcademicSummaryReport");
		CandidateAcademicSummaryReportServices candidateAcademicSummaryReportServices = new CandidateAcademicSummaryReportServices();
		Long collectionId=0l;
		Long examEventId=0l;
		Long displayCategoryId=0l;
		Long candidateId=0l;
		String loginId="";
		String candidateName="";
		try {
			examEventId = Long.valueOf(request
					.getParameter("examEventId"));			
			
			if(request.getParameter("collectionId")!=null)
				collectionId = Long.valueOf(request
					.getParameter("collectionId"));
			
			if(request.getParameter("displayCategoryId")!=null)
				displayCategoryId = Long.valueOf(request
					.getParameter("displayCategoryId"));
			
			if(request.getParameter("candidateId")!=null)
			candidateId=Long.valueOf(request
					.getParameter("candidateId"));
			if(request.getParameter("candidateName")!=null)
			candidateName=request
					.getParameter("candidateName").toString();
			if(request.getParameter("loginId")!=null)
			loginId=request
					.getParameter("loginId").toString();

			// get user form session to find user role
			VenueUser user = SessionHelper.getLogedInUser(request);
			if (user.getFkRoleID() == 1) {
				
				List<ExamEvent> events=getactiveExamEventList(user);
				model.addAttribute("activeExamEventList",events);
				model.addAttribute(USERROLE, ONE);
				CANDIDATEACADEMICSUMMARYJSP="Solo/CandidateAcademicSummaryReport/CandidateSummaryReportList";
				
			} else if (user.getFkRoleID() == 3){
				model.addAttribute(USERROLE, 3);				
				List<DisplayCategoryLanguage> categoryLanguages=getEventWiseDisplayCategoryList(SessionHelper.getExamEvent(request).getExamEventID());
				
				model.addAttribute("displayCategoryList",categoryLanguages);
				CANDIDATEACADEMICSUMMARYJSP="Solo/CandidateAcademicSummaryReport/CandidateSummaryReport";
				
			}
			else {				
				model.addAttribute(USERROLE, 0);
				List<ExamEvent> events=getactiveExamEventList(user);
				model.addAttribute("activeExamEventList",events);
				CANDIDATEACADEMICSUMMARYJSP="Solo/CandidateAcademicSummaryReport/CandidateSummaryReportList";
			}
			
			/** 2 Get searchText. */
			searchText = request.getParameter("searchText");
			
			pagination.setListName("listCandidateAcademicSummaryReport");
			
			model.addAttribute(EXAMEVENTID, examEventId);
			model.addAttribute(COLLECTIONID, collectionId);
			model.addAttribute(CANDIDATEID,candidateId);
			model.addAttribute(CANDNAME,candidateName);			
			model.addAttribute(CANDLOGINID,loginId);
			model.addAttribute(DISPLAYCATEGORYID, displayCategoryId);
			
			
			/** 3 Get Object list. */
			if (searchText != null && !(searchText.equals(""))) {
				pagination.setPropertyName("CANDIDATEFIRSTNAME");
				/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
				candidateAcademicSummaryReportServices.paginationNext(null,
						pagination, searchText, model);
			} else {
				/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
				candidateAcademicSummaryReportServices.paginationNext(null,
						pagination, searchText, model);
			}
			
			
			return CANDIDATEACADEMICSUMMARYJSP;
			} catch (Exception ex) {
			LOGGER.error("Exception occured in CandidateAcademicSummaryReportController-listGet: " , ex);
			model.addAttribute(EXCEPTIONSTRING, ex);
			return ERRORPAGE;
			}
	}

	/**
	 * Post method for Candidate Academic Summary Report List Pagination - Previous
	 * @param model
	 * @param pagination
	 * @param searchText
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/prev" }, method = RequestMethod.POST)
	public String prevGet(Model model,
			@ModelAttribute("pagination") Pagination pagination,
			String searchText, HttpServletRequest request) {
		pagination.setListName("listCandidateAcademicSummaryReport");
		CandidateAcademicSummaryReportServices candidateAcademicSummaryReportServices = new CandidateAcademicSummaryReportServices();
		Long collectionId=0l;
		Long examEventId=0l;
		Long displayCategoryId=0l;
		Long candidateId=0l;
		String loginId="";
		String candidateName="";
		try {
			examEventId = Long.valueOf(request
					.getParameter("examEventId"));			
			
			if(request.getParameter("displayCategoryId")!=null)
				displayCategoryId = Long.valueOf(request
					.getParameter("displayCategoryId"));
			
			if(request.getParameter("collectionId")!=null)
				collectionId = Long.valueOf(request
					.getParameter("collectionId"));
			
			if(request.getParameter("candidateId")!=null)
			candidateId=Long.valueOf(request
					.getParameter("candidateId"));
			if(request.getParameter("candidateName")!=null)
			candidateName=request
					.getParameter("candidateName").toString();
			if(request.getParameter("loginId")!=null)
			loginId=request
					.getParameter("loginId").toString();

			// get user form session to find user role
			VenueUser user = SessionHelper.getLogedInUser(request);
			if (user.getFkRoleID() == 1) {
				
				List<ExamEvent> events=getactiveExamEventList(user);
				model.addAttribute("activeExamEventList",events);
				model.addAttribute(USERROLE, ONE);
				CANDIDATEACADEMICSUMMARYJSP="Solo/CandidateAcademicSummaryReport/CandidateSummaryReportList";
				
			} else if (user.getFkRoleID() == 3){
				model.addAttribute(USERROLE, 3);
				List<DisplayCategoryLanguage> categoryLanguages=getEventWiseDisplayCategoryList(SessionHelper.getExamEvent(request).getExamEventID());
				
				model.addAttribute("displayCategoryList",categoryLanguages);
				CANDIDATEACADEMICSUMMARYJSP="Solo/CandidateAcademicSummaryReport/CandidateSummaryReport";
				
			}
			else {				
				model.addAttribute(USERROLE, 0);
				List<ExamEvent> events=getactiveExamEventList(user);
				model.addAttribute("activeExamEventList",events);
				CANDIDATEACADEMICSUMMARYJSP="Solo/CandidateAcademicSummaryReport/CandidateSummaryReportList";
			}
			
			/** 2 Get searchText. */
			searchText = request.getParameter("searchText");			
			pagination.setListName("listCandidateAcademicSummaryReport");
			
			model.addAttribute(EXAMEVENTID, examEventId);
			model.addAttribute(COLLECTIONID, collectionId);
			model.addAttribute(CANDIDATEID,candidateId);
			model.addAttribute(CANDNAME,candidateName);			
			model.addAttribute(CANDLOGINID,loginId);
			model.addAttribute(DISPLAYCATEGORYID, displayCategoryId);
			
			
			/** 3 Get Object list. */
			if (searchText != null && !(searchText.equals(""))) {
				pagination.setPropertyName("CANDIDATEFIRSTNAME");
				/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
				candidateAcademicSummaryReportServices.paginationPrev(null,
						pagination, searchText, model);
			} else {
				/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
				candidateAcademicSummaryReportServices.paginationPrev(null,
						pagination, searchText, model);
			}
			
			return CANDIDATEACADEMICSUMMARYJSP;
			} catch (Exception ex) {
			LOGGER.error("Exception occured in CandidateAcademicSummaryReportController-listGet: " , ex);
			model.addAttribute(EXCEPTIONSTRING, ex);
			return ERRORPAGE;
			}
	}

	/**
	 * Method to Export Candidate Academic Summary Report to PDF	
	 * @param model
	 * @param request
	 * @param response
	 * @param locale
	 * @param examEventId
	 * @param collectionId
	 * @param candidateId
	 * @return String this returns the path of a view
	 */
	@RequestMapping({ "CandidateAcademicSummaryReport.pdf" })	
	public String exportCadidateAcademicSummaryReportToPDF(Model model,HttpServletRequest request,HttpServletResponse response,Locale locale ,long examEventId, long collectionId,long candidateId){

		try {

			CandidateAcademicSummaryViewModelPDF candidateAcademicSummaryViewModelPDF=new CandidateAcademicSummaryViewModelPDF();
			candidateAcademicSummaryViewModelPDF.setLocale("messages_"+locale.getLanguage() +".properties"); 

			candidateAcademicSummaryViewModelPDF.setCandidateAcademicSummaryReports(new CandidateAcademicSummaryReportServices().getCandidateAcademicSummaryReportWithoutPagination(examEventId, collectionId, candidateId));
			

			PDFComponent<CandidateAcademicSummaryViewModelPDF> pdfGen = new PDFComponent<CandidateAcademicSummaryViewModelPDF>(request, response);
			//	pdfGen.setPdfFileName("MyPDF");
				pdfGen.setInputsToXML(candidateAcademicSummaryViewModelPDF);
				pdfGen.setStyleSheetXSLName("templateCandidateAcademicSummryReport.xsl");
				boolean status = pdfGen.startPDFGeneratorEngine();

				//code to display message 
				if (!status) {
					pdfGen.writeErrorResponseContent();
				}
				
				/*********************************************************/
				
				
				//model.addAttribute("candidateSummaryRptData", new CandidateAcademicSummaryReportServices().getCandidateAcademicSummaryReportWithoutPagination(examEventId, collectionId, candidateId));
				
				
		
		} catch (Exception e) {
			LOGGER.error("Exception occured in CandidateAcademicSummaryReportPDF :  " , e);
		}
		return "candidateReport/templateCandidateSummaryReport";
	}
	
	/**
	 * Get method for Generate Answer Key Using HTML 	
	 * @param model
	 * @param request
	 * @param response
	 * @param locale
	 * @param examEventId
	 * @param collectionId
	 * @param candidateId
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/createCASReprotFromHtml" }, method = RequestMethod.GET)
	public String generateAnswerKeyUsingWktml(Model model, HttpServletRequest request, HttpServletResponse response, Locale locale, @RequestParam("examEventId") long examEventId, @RequestParam("collectionId") long collectionId, @RequestParam("candidateId") long candidateId) {
		try {
			
			CandidateAcademicSummaryViewModelPDF candidateAcademicSummaryViewModelPDF=new CandidateAcademicSummaryViewModelPDF();
			candidateAcademicSummaryViewModelPDF.setLocale("messages_"+locale.getLanguage() +".properties"); 

			candidateAcademicSummaryViewModelPDF.setCandidateAcademicSummaryReports(new CandidateAcademicSummaryReportServices().getCandidateAcademicSummaryReportWithoutPagination(examEventId, collectionId, candidateId));
			
			

			model.addAttribute("candidateSummaryRptData", new CandidateAcademicSummaryReportServices().getCandidateAcademicSummaryReportWithoutPagination(examEventId, collectionId, candidateId));
	
		

		} catch (Exception ex) {
			try {
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			} catch (IOException e1) {
				LOGGER.error("Exception in generateAnswerKeyUsingWktml while setting status to response", ex);
			} 
		}
		
		return "Solo/CandidateAcademicSummaryReport/templateCandidateSummaryReport";
	}
	
	/**
	 * Method to fetch Question Paper Server Path 		
	 * @param request
	 * @return String this returns the Server Path 
	 */
	public String getServerPath(HttpServletRequest request)
	{
		Properties properties;
		String path;
		properties = new Properties();
		try {
			properties.load(Thread.currentThread().getContextClassLoader().getResourceAsStream("mkclproperties.properties"));
		} catch (IOException e) {
			properties = null;
			LOGGER.error("Error in getServerPath", e);
		}
		if (properties != null) {
			path = properties.getProperty("QuestionPaperPath");
			String serverpath = request.getSession().getServletContext().getRealPath("/");
			return serverpath + path;

		}
		return null;

	}

	
}
