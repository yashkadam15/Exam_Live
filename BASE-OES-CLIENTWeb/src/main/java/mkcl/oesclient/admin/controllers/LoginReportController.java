package mkcl.oesclient.admin.controllers;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

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

import mkcl.oesclient.admin.services.CandidateLoginReportServicesImpl;
import mkcl.oesclient.admin.services.ExamScheduleServiceImpl;
import mkcl.oesclient.commons.services.ExamEventServiceImpl;
import mkcl.oesclient.commons.utilities.Constants;
import mkcl.oesclient.commons.utilities.FileUploadHelper;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.commons.utilities.Pagination;
import mkcl.oesclient.model.CollectionMaster;
import mkcl.oesclient.model.VenueUser;
import mkcl.oesclient.pdfgenerator.PDFComponent;
import mkcl.oesclient.pdfviewmodel.CandidateViewModelPDF;
import mkcl.oesclient.pdfviewmodel.LoginReportViewModelPDF;
import mkcl.oesclient.utilities.HTMLToPDFHelper;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.oesclient.viewmodel.CandidateTestReportViewModel;
import mkcl.oesclient.viewmodel.GroupScheduleViewModel;
import mkcl.oesclient.viewmodel.LoginReportViewModel;
import mkcl.oespcs.model.ExamEvent;



/**
 * @author amitk
 * 
 */
@Controller
@RequestMapping("loginReport")
public class LoginReportController {

	private static Logger LOGGER = LoggerFactory.getLogger(LoginReportController.class);
	private static final String ERRORPAGE = Constants.ERRORPAGE;
	private static final String EXCEPTIONSTRING = Constants.EXCEPTIONSTRING;
	private static final long ONE = 1;
	private static final String COLLECTIONID = "collectionID";
	private static final String ISADMIN = "isAdmin";
	private static final String LOGINREPORTJSP = "Admin/loginReport/CandidateLoginReport";
	private static final String EXAMEVENTID =  "examEventId"; 


	/**
	 * Method to fetch the Active Exam Event List
	 * @param request
	 * @return List<ExamEvent> this returns the active exam event list
	 */
	@ModelAttribute("activeExamEventList")
	public List<ExamEvent> getactiveExamEventList(HttpServletRequest request) {
		List<ExamEvent> activeExamEventList = null;
		try {
			ExamScheduleServiceImpl eServiceObj = new ExamScheduleServiceImpl();
			/* Active exam Event List */
			activeExamEventList = eServiceObj.getActiveExamEventList(SessionHelper.getLogedInUser(request));
		} catch (Exception e) {
		LOGGER.error("Exception occured in getactiveExamEventList",e);
		}
		return activeExamEventList;
	}

	/**
	 * Get method for Candidate Login Report
	 * @param model
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/CandidateLoginReport" }, method = RequestMethod.GET)
	public String examScheduling(Model model, HttpServletRequest request) {
		try {
			VenueUser user = SessionHelper.getLogedInUser(request);
			if (user.getFkRoleID() == 1) {
				model.addAttribute(ISADMIN, ONE);
			} else {
				model.addAttribute(ISADMIN, 0);
			}
			return LOGINREPORTJSP;
		} catch (Exception e) {
			LOGGER.error("Exception occured in examScheduling: " , e);
		}
		return LOGINREPORTJSP;

	}

	/**
	 * Post method to fetch Division Associated to Exam Event and Roles
	 * @param examEventID
	 * @param request
	 * @return List<CollectionMaster> this returns the Division List
	 */
	@RequestMapping(value = "/collectionAccEventRole.ajax", method = RequestMethod.POST)
	@ResponseBody
	public List<CollectionMaster> getDivisionList(
			@RequestBody ExamEvent examEventID, HttpServletRequest request) {
		List<CollectionMaster> collectionList=null;
		try {
			VenueUser user = SessionHelper.getLogedInUser(request);

			ExamScheduleServiceImpl eServiceObj = new ExamScheduleServiceImpl();
			collectionList = new ArrayList<CollectionMaster>();
			collectionList = eServiceObj.getCollectionMasterAccRole(user,
					examEventID.getExamEventID());
		} catch (Exception e) {
		LOGGER.error("Exception occured in LoginReportController - getDivisionList ",e);
		}
		return collectionList;
	}

	/**
	 * Get method to fetch the Candidate Login Report List
	 * @param model
	 * @param request
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/candidateloginReportList" }, method = {RequestMethod.POST,RequestMethod.GET})
	public String listGet(Model model, HttpServletRequest request, Locale locale) {
		
		CandidateLoginReportServicesImpl objCandidateLoginReportServicesImpl = new CandidateLoginReportServicesImpl();
		try {
			Long examEventId = Long.valueOf(request
					.getParameter("examEventSelect"));
			Long collectionId = Long.valueOf(request
					.getParameter("collectionTypeSelect"));

			/** Add message into model. */
			String messageId = request.getParameter("messageid");
			if (messageId != null && !(messageId.equals(""))) {
				MKCLUtility.addMessage(Integer.parseInt(messageId), model,
						locale);
			}

			/** 2 Get searchText. */
			String searchText = request.getParameter("searchText");
			Pagination pagination = new Pagination();
			pagination.setListName("listCandidateTestReportViewModels");

			// get user form session to find user role
			VenueUser user = SessionHelper.getLogedInUser(request);
			if (user.getFkRoleID() == 1) {
				model.addAttribute(ISADMIN, ONE);
			} else {
				model.addAttribute(ISADMIN, 0);
			}

			model.addAttribute(EXAMEVENTID, examEventId);
			model.addAttribute(COLLECTIONID, collectionId);


			/** 3 Get Object list. */
			if (searchText != null && !(searchText.equals(""))) {
				pagination.setPropertyName("CANDIDATEFIRSTNAME");
				/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
				objCandidateLoginReportServicesImpl.pagination(null,
						pagination, searchText, model);
			} else {
				/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
				objCandidateLoginReportServicesImpl.pagination(null,
						pagination, searchText, model);
			}
			
			String imgrelativePath = FileUploadHelper.getRelativeFolderPath(request, "UserPhotoUploadPath");
			model.addAttribute("imgPath", imgrelativePath);
			return LOGINREPORTJSP;
		} catch (Exception ex) {
			LOGGER.error("Exception occured in examScheduling-listGet: " , ex);
			model.addAttribute(EXCEPTIONSTRING, ex);
			return ERRORPAGE;
		}
	}

	/**
	 * Get method to Search Candidate
	 * @param model
	 * @param request
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/searchCandiate" }, method = RequestMethod.GET)
	public String searchCandiate(Model model, HttpServletRequest request, Locale locale ) {
		
		String  collectionTypeSelect=request.getParameter("collectionTypeSelect");
		String searchText=request.getParameter("searchText");
		String examEventSelect=request.getParameter("examEventSelect");
		
		return "redirect:../loginReport/candidateloginReportList?searchText="+searchText+"&examEventSelect="+examEventSelect+"&collectionTypeSelect="+collectionTypeSelect;
	}
	
	/**
	 * Post method for Candidate Test Report List Pagination - Next
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
		pagination.setListName("listCandidateTestReportViewModels");
		CandidateLoginReportServicesImpl objCandidateLoginReportServicesImpl = new CandidateLoginReportServicesImpl();
		try {
			Long examEventId = Long
					.valueOf(request.getParameter(EXAMEVENTID));
			Long divisionId = Long.valueOf(request.getParameter(COLLECTIONID));


			// get user form session to find user role
			VenueUser user = SessionHelper.getLogedInUser(request);
			if (user.getFkRoleID() == 1) {
				model.addAttribute(ISADMIN, ONE);
			} else {
				model.addAttribute(ISADMIN, 0);
			}

			model.addAttribute(EXAMEVENTID, examEventId);
			model.addAttribute(COLLECTIONID, divisionId);


			if (searchText != null && !(searchText.equals(""))) {
				pagination.setPropertyName("CANDIDATEFIRSTNAME");
				/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
				objCandidateLoginReportServicesImpl.paginationNext(null,
						pagination, searchText, model);
			} else {
				/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
				objCandidateLoginReportServicesImpl.paginationNext(null,
						pagination, searchText, model);
			}
			
			String imgrelativePath = FileUploadHelper.getRelativeFolderPath(request, "UserPhotoUploadPath");
			model.addAttribute("imgPath", imgrelativePath);
		} catch (Exception ex) {
			LOGGER.error("Exception occured in nextGet: " , ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		return LOGINREPORTJSP;
	}

	/**
	 * Post method for Candidate Test Report List Pagination - Previous
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
		pagination.setListName("listCandidateTestReportViewModels");
		CandidateLoginReportServicesImpl objCandidateLoginReportServicesImpl = new CandidateLoginReportServicesImpl();
		try {
			Long examEventId = Long
					.valueOf(request.getParameter(EXAMEVENTID));
			Long divisionId = Long.valueOf(request.getParameter(COLLECTIONID));

			// get user form session to find user role
			VenueUser user = SessionHelper.getLogedInUser(request);
			if (user.getFkRoleID() == 1) {
				model.addAttribute(ISADMIN, ONE);
			} else {
				model.addAttribute(ISADMIN, 0);
			}

			model.addAttribute(EXAMEVENTID, examEventId);
			model.addAttribute(COLLECTIONID, divisionId);


			if (searchText != null && !(searchText.equals(""))) {
				pagination.setPropertyName("CANDIDATEFIRSTNAME");
				/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
				objCandidateLoginReportServicesImpl.paginationPrev(null,
						pagination, searchText, model);
			} else {
				/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
				objCandidateLoginReportServicesImpl.paginationPrev(null,
						pagination, searchText, model);
			}
			String imgrelativePath = FileUploadHelper.getRelativeFolderPath(request, "UserPhotoUploadPath");
			model.addAttribute("imgPath", imgrelativePath);
		} catch (Exception ex) {
			LOGGER.error("Exception occured in prevGet: " , ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		return LOGINREPORTJSP;
	}
	
	/**
	 * Get method for Candidate Login Report PDF
	 * @param model
	 * @param request
	 * @param response
	 * @param locale
	 * @param lcoale
	 * @param examEventId
	 * @param collectionID
	 * @param collectionName
	 * @param exameventName
	 * @return String this returns the path of a view
	 */
	/*@RequestMapping({ "CandidateLoginReportPDF" })*/
	@RequestMapping(value = { "/CandidateLoginReportPDF" }, method ={ RequestMethod.GET})
	public String listGetPDF(Model model, HttpServletRequest request, HttpServletResponse response, Locale locale, Locale lcoale, long examEventId, long collectionID,String collectionName,String exameventName) {
		
		CandidateLoginReportServicesImpl objCandidateLoginReportServicesImpl = new CandidateLoginReportServicesImpl();
		try {
			List<CandidateTestReportViewModel> listOfCandidate = objCandidateLoginReportServicesImpl.getCandidateTestReportWithoutPagination(examEventId, collectionID);
			model.addAttribute("listOfCandidate", listOfCandidate);
			model.addAttribute("examEventName", exameventName);
			model.addAttribute("collectionName", collectionName);
			
			String imgrelativePath = FileUploadHelper.getRelativeFolderPath(request, "UserPhotoUploadPath");
			model.addAttribute("imgPath", imgrelativePath);
			
		} catch (Exception ex) {
			LOGGER.error("Exception occured in examScheduling-listGet: " , ex);
			try {
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			} catch (IOException e1) {
				//safe to ignore
			}
		}
		return "Admin/loginReport/CandidateLoginReportPDF";
	}
	
	/**
	 * Post method to Generate PDF from Paper Template
	 * @param request
	 * @param response
	 * @param loginReportViewModel
	 * @return String this returns the path of a view
	 */
	@ResponseBody
	@RequestMapping(value = { "/downloadCandidateLoginReport" }, method ={ RequestMethod.POST})
	public String generatePDFFromPaperTemplate(HttpServletRequest request,HttpServletResponse response,@RequestBody LoginReportViewModel loginReportViewModel){
		String pdfGeneratedpath = null;
		try {
			HTMLToPDFHelper htmlToPdfHelper = new HTMLToPDFHelper();
			List<String> listCmd=new ArrayList<String>();
			listCmd.add("--header-right");
			listCmd.add("[page]/[topage]");
			listCmd.add(htmlToPdfHelper.makeFullURL(request, "/loginReport/CandidateLoginReportPDF?examEventId="+loginReportViewModel.getExamEventID()+"&collectionID="+loginReportViewModel.getCollectionId()+"&collectionName="+loginReportViewModel.getCollectionName()+"&exameventName="+loginReportViewModel.getEventName()));
			listCmd.add("--cookie");
			listCmd.add("JSESSIONID");
			listCmd.add(request.getSession(false).getId());
			String fileName = "CandidateLoginReport.pdf";
			pdfGeneratedpath = htmlToPdfHelper.generateHTMLToPDF(listCmd, fileName);
			
		} catch (Exception e) {
			LOGGER.error("Exception occured in generatePDFFromPaperTemplate: ", e);
		}
		
		return pdfGeneratedpath;
	}

	
	
	/**
	 * Method to Export Candidate Report to PDF
	 * @param request
	 * @param response
	 * @param lcoale
	 * @param examEventId
	 * @param collectionID
	 * @param collectionName
	 * @param exameventName
	 */
	@RequestMapping({ "CandidateLoginReport.pdf" })
	public void exportCadidateReportToPDF(HttpServletRequest request,HttpServletResponse response,Locale lcoale, long examEventId, long collectionID,String collectionName,String exameventName){

		try {
			LoginReportViewModelPDF loginreportPDFData = getLoginReportViewModelPDFDate(lcoale,examEventId, collectionID, collectionName,exameventName,request);
			String collectiontype = new ExamEventServiceImpl().getExamEventByID(examEventId).getCollectionType().toString();
			loginreportPDFData.setEventCollectionType(collectiontype);
			loginreportPDFData.setEventName(exameventName);
			

			PDFComponent<LoginReportViewModelPDF> pdfGen = new PDFComponent<LoginReportViewModelPDF>(request, response);
			//	pdfGen.setPdfFileName("MyPDF");
				pdfGen.setInputsToXML(loginreportPDFData);
				pdfGen.setStyleSheetXSLName("templateLoginReport.xsl");
				boolean status = pdfGen.startPDFGeneratorEngine();

				//code to display message 
				if (!status) {
					pdfGen.writeErrorResponseContent();
				}
			
		
		} catch (Exception e) {
			LOGGER.error("Exception occured in exportCadidateReportToPDF: " , e);
		}

	}

	/**
	 * Method to fetch Login Report PDF Model
	 * @param locale
	 * @param examEventId
	 * @param collectionID
	 * @param collectionName
	 * @param exameventName
	 * @param request
	 * @return LoginReportViewModelPDF this returns the Login Report PDF Model
	 */
	public LoginReportViewModelPDF getLoginReportViewModelPDFDate(Locale locale ,long examEventId, long collectionID,String collectionName,String exameventName,HttpServletRequest request){

		String defaultPhotoName=getDefaultImageName("instruction.defaultPhoto");
		final String relativepath = "resources/WebFiles/UserImages/";
		String physicalFolderPath=FileUploadHelper.getPhysicalFolderPathWithinWebApp(request, "UserPhotoUploadPath");	
		LoginReportViewModelPDF candidateLoginReportViewmodelPDF = new LoginReportViewModelPDF(); 
		try {
			candidateLoginReportViewmodelPDF.setLocale("messages_"+locale.getLanguage() +".properties"); 
			
			candidateLoginReportViewmodelPDF.setCandidateCollectionType(collectionName);
	
			List<CandidateTestReportViewModel> listOfCandidate = new CandidateLoginReportServicesImpl()
			.getCandidateTestReportWithoutPagination(examEventId,
					collectionID);
			List<CandidateViewModelPDF> listCandidateViewModelData = new ArrayList<CandidateViewModelPDF>();
			//code to populate candidate ViewModel Data
			//counter
			long counter = 1;
			for (CandidateTestReportViewModel itr : listOfCandidate) {
				CandidateViewModelPDF candidatePDFObj = new CandidateViewModelPDF();
				candidatePDFObj.setSerialNumber(counter);
				counter++;

				candidatePDFObj.setCandidateFirstName(itr.getCandidate()
						.getCandidateFirstName());
				candidatePDFObj.setCandidateMiddleName(itr.getCandidate()
						.getCandidateMiddleName());
				candidatePDFObj.setCandidateLastName(itr.getCandidate()
						.getCandidateLastName());
				candidatePDFObj.setCandidateCode(itr.getCandidate()
						.getCandidateCode());
				candidatePDFObj.setCandidateLoginID(itr.getCandidate()
						.getCandidateUserName());
				candidatePDFObj.setCandidatePassword(itr.getCandidate()
						.getCandidatePassword());
				
				if(itr.getCandidate().getCandidatePhoto()!=null  &&  !itr.getCandidate().getCandidatePhoto().isEmpty())
				{
					File f = new File(physicalFolderPath+itr.getCandidate().getCandidatePhoto());
                    if(f.exists())
                    {
                    	candidatePDFObj.setCandidatePhoto(relativepath+itr.getCandidate().getCandidatePhoto());
                    }
                    else
                    {
                    	candidatePDFObj.setCandidatePhoto(relativepath+defaultPhotoName);
                    }
				}
				else
				{
					candidatePDFObj.setCandidatePhoto(relativepath+defaultPhotoName);
				}
				
				

				listCandidateViewModelData.add(candidatePDFObj);

			}
			candidateLoginReportViewmodelPDF
			.setListOfCandidateViewModelPDF(listCandidateViewModelData);
		} catch (Exception e) {
			LOGGER.error("Exception occured in getLoginReportViewModelPDFDate: " , e);
		}
		return candidateLoginReportViewmodelPDF;
	}
	
	/**
	 * Method to get the Default Image Name
	 * @param propertyName
	 * @return String this returns the path of a view
	 */
	public String getDefaultImageName(String propertyName)
	{
			Properties properties;	
			String photoName;
		
			properties=new Properties();
			try {
				properties.load(Thread.currentThread()
						.getContextClassLoader()
						.getResourceAsStream("messages_en.properties"));
			} catch (IOException e) {
				LOGGER.error("Error occured in getFolderPath: ", e);
				properties=null;
			}
			if(properties!=null)
			{
				photoName = properties.getProperty(propertyName);
			return photoName;
			}
			else
			{
				return null;
			}
	}

}
