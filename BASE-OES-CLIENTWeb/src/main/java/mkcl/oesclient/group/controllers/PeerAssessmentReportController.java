package mkcl.oesclient.group.controllers;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Queue;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import mkcl.baseoesclient.model.LoginType;
import mkcl.baseoesclient.model.UserColor;
import mkcl.oesclient.admin.services.CandidateLoginReportServicesImpl;
import mkcl.oesclient.admin.services.GroupScheduleServiceImpl;
import mkcl.oesclient.commons.services.ExamEventConfigurationServiceImpl;
import mkcl.oesclient.commons.services.ExamEventServiceImpl;
import mkcl.oesclient.commons.services.IExamEventConfigurationService;
import mkcl.oesclient.commons.services.PaperServiceImpl;
import mkcl.oesclient.commons.utilities.Constants;
import mkcl.oes.commons.EncryptionHelper;
import mkcl.oesclient.commons.utilities.FileUploadHelper;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.commons.utilities.Pagination;
import mkcl.oesclient.group.services.GroupCandidateExamServiceImpl;
import mkcl.oesclient.group.services.IGroupCandidateExamService;
import mkcl.oesclient.group.services.PeerAssessmentReportServiceImpl;
import mkcl.oesclient.model.Candidate;
import mkcl.oesclient.model.CandidateAnswer;
import mkcl.oesclient.model.CandidateExam;
import mkcl.oesclient.model.CandidateItemAssociation;
import mkcl.oesclient.model.CollectionMaster;
import mkcl.oesclient.model.ConfidenceLevel;
import mkcl.oesclient.model.ItemStatus;
import mkcl.oesclient.model.VenueUser;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.oesclient.viewmodel.ExamPaperSetting;
import mkcl.oesclient.viewmodel.ExamViewModel;
import mkcl.oesclient.viewmodel.PeerAssessmentRptViewModel;
import mkcl.oespcs.model.ExamEvent;
import mkcl.oespcs.model.Instructions;
import mkcl.oespcs.model.MarkingScheme;
import mkcl.oespcs.model.MediumOfPaper;
import mkcl.oespcs.model.Paper;
import mkcl.oesserver.model.DifficultyLevel;
import mkcl.oesserver.model.ItemType;
import mkcl.oesserver.model.OptionMultipleCorrect;
import mkcl.oesserver.model.OptionPictureIdentification;
import mkcl.oesserver.model.OptionSingleCorrect;
import mkcl.os.security.AESHelper;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

//import com.itextpdf.text.log.SysoCounter;

/**
 * 
 * @author sonamm
 * 
 */
@Controller("PeerAssessmentReportController")
@RequestMapping(value = "/peerAssessmentRpt")
public class PeerAssessmentReportController {
	private static final Logger LOGGER = LoggerFactory.getLogger(PeerAssessmentReportController.class);
	String selectedLang = "defaultLang";
	
/**
 * Get method for Confidence Report	
 * @param model
 * @param session
 * @param locale
 * @param request
 * @return String this returns the path of a view
 */
@RequestMapping(value="confidenceRpt", method= RequestMethod.GET)
public String confidenceRptGet(Model model,HttpSession session, Locale locale,HttpServletRequest request) {

PeerAssessmentReportServiceImpl assessmentReportServiceImpl=new PeerAssessmentReportServiceImpl();
List<ExamEvent> examEventList=new ArrayList<ExamEvent>();
examEventList=assessmentReportServiceImpl.getgroupEnabledExamEventList();

model.addAttribute("examEventList",examEventList);
			return "Group/PeerAssessmentReport/confidenceReport";
		
	}
	
/**
 * Post method for Confidence Report	
 * @param action
 * @param response
 * @param model
 * @param session
 * @param locale
 * @param request
 * @return String this returns the path of a view
 */
@RequestMapping(value="confidenceRpt", method= RequestMethod.POST)
public String confidenceRptPost(@RequestParam String action, HttpServletResponse response,Model model,HttpSession session, Locale locale,HttpServletRequest request) {
PeerAssessmentReportServiceImpl assessmentReportServiceImpl=new PeerAssessmentReportServiceImpl();
List<ExamEvent> examEventList=new ArrayList<ExamEvent>();
List<PeerAssessmentRptViewModel> assessmentRptViewModelList=new ArrayList<PeerAssessmentRptViewModel>();
examEventList=assessmentReportServiceImpl.getgroupEnabledExamEventList();
			long examEventID=Long.parseLong( request.getParameter("hid_ExamEventID"));
		long paperID=Long.parseLong( request.getParameter("hid_PaperID"));	
	
		
		 if( action.equals("Export To Excel") ){
		    assessmentReportServiceImpl.getExcelForConfidenceReport(examEventID, paperID, request, response);
		    }
		   
		 
		
		 
		 

			/** 2 Get searchText. */
			String searchText = request.getParameter("searchText");
			Pagination pagination = new Pagination();
			pagination.setListName("assessmentRptViewModelList");

			// get user form session to find user role
			VenueUser user = SessionHelper.getLogedInUser(request);

			model.addAttribute("examEventID", examEventID);
			model.addAttribute("paperID", paperID);


			/** 3 Get Object list. */
			if (searchText != null && !(searchText.equals(""))) {
				pagination.setPropertyName("CANDIDATEFIRSTNAME");
				/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
				try {
					assessmentReportServiceImpl.pagination(null,
							pagination, searchText, model);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			} else {
				/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
				try {
					assessmentReportServiceImpl.pagination(null,
							pagination, searchText, model);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			
			
			
	
			
			
			

//
// assessmentRptViewModelList=assessmentReportServiceImpl.getPeerAssessmentReport(11112, 1136);
//model.addAttribute("assessmentRptViewModelList",assessmentRptViewModelList);
model.addAttribute("examEventList",examEventList);
			return "Group/PeerAssessmentReport/confidenceReport";
		
	}
	
	
	/**
	 * Post method for Assessment Report View Model List Pagination - Next
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
		pagination.setListName("assessmentRptViewModelList");
		PeerAssessmentReportServiceImpl assessmentReportServiceImpl=new PeerAssessmentReportServiceImpl();
		try {
			Long examEventId = Long.valueOf(request.getParameter("examEventID"));
			Long paperID = Long.valueOf(request.getParameter("paperID"));

			// get user form session to find user role
			VenueUser user = SessionHelper.getLogedInUser(request);

			model.addAttribute("examEventID", examEventId);
			model.addAttribute("paperID", paperID);


			if (searchText != null && !(searchText.equals(""))) {
				pagination.setPropertyName("CANDIDATEFIRSTNAME");
				/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
				assessmentReportServiceImpl.paginationNext(null,
						pagination, searchText, model);
			} else {
				/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
				assessmentReportServiceImpl.paginationNext(null,
						pagination, searchText, model);
			}
			
			List<ExamEvent> examEventList=new ArrayList<ExamEvent>();
			examEventList=assessmentReportServiceImpl.getgroupEnabledExamEventList();

			model.addAttribute("examEventList",examEventList);
			
			

		} catch (Exception ex) {
			LOGGER.error("Exception occured in nextGet: " , ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		return "Group/PeerAssessmentReport/confidenceReport";
	}

	/**
	 * Post method for Assessment Report View Model List Pagination - Previous
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
		pagination.setListName("assessmentRptViewModelList");
		PeerAssessmentReportServiceImpl assessmentReportServiceImpl=new PeerAssessmentReportServiceImpl();
		try {
			Long examEventId = Long.valueOf(request.getParameter("examEventID"));
			Long paperID = Long.valueOf(request.getParameter("paperID"));

			// get user form session to find user role
			VenueUser user = SessionHelper.getLogedInUser(request);


			model.addAttribute("examEventID", examEventId);
			model.addAttribute("paperID", paperID);


			if (searchText != null && !(searchText.equals(""))) {
				pagination.setPropertyName("CANDIDATEFIRSTNAME");
				/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
				assessmentReportServiceImpl.paginationPrev(null,
						pagination, searchText, model);
			} else {
				/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
				assessmentReportServiceImpl.paginationPrev(null,
						pagination, searchText, model);
			}
			
			List<ExamEvent> examEventList=new ArrayList<ExamEvent>();
			examEventList=assessmentReportServiceImpl.getgroupEnabledExamEventList();

			model.addAttribute("examEventList",examEventList);
			
			
			
		} catch (Exception ex) {
			LOGGER.error("Exception occured in prevGet: " , ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		return "Group/PeerAssessmentReport/confidenceReport";
	}

	
	/**
	 * Post method to fetch Paper List	
	 * @param examEventID
	 * @param request
	 * @return List<Paper> this returns the Paper List
	 */
	@RequestMapping(value = "/paperList.ajax", method = RequestMethod.POST)
	@ResponseBody
	public List<Paper> getPaperList(
			@RequestBody ExamEvent examEventID, HttpServletRequest request) {	
		PeerAssessmentReportServiceImpl assessmentReportServiceImpl=new PeerAssessmentReportServiceImpl();
		List<Paper> paperList = new ArrayList<Paper>();
		paperList = assessmentReportServiceImpl.getPaperList(examEventID.getExamEventID());
		return paperList;
	}
	
}
