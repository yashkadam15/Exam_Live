package mkcl.oesclient.typingtest.controllers;
/**
 * Author Reena
 */
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.io.PrintStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mkcl.oesclient.commons.services.LoginServiceImpl;
import mkcl.oesclient.commons.services.OESAppInfoServicesImpl;
import mkcl.oesclient.commons.utilities.AppInfoHelper;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.model.Candidate;
import mkcl.oesclient.model.OESAppInfo;
import mkcl.oesclient.model.VenueUser;
import mkcl.oesclient.solo.services.CandidateServiceImpl;
import mkcl.oesclient.typingtest.services.CandidateService;
import mkcl.oesclient.viewmodel.TypingTestViewModel;
import mkcl.oespcs.model.ExamType;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;


@Controller
@RequestMapping("candidateTypingtest")
public class CandidateTypingTestController {
	private static final Logger LOGGER = LoggerFactory.getLogger(CandidateTypingTestController.class);
	
	@InitBinder
	public void initBinder(WebDataBinder dataBinder, Locale locale,
			HttpServletRequest request) {
		Properties properties = null;
		String dateFormatString;
		SimpleDateFormat dateFormat;

		properties = MKCLUtility.loadMKCLPropertiesFile();

		dateFormatString = properties
				.getProperty("global.dateFormatWithTime");

		dateFormat = new SimpleDateFormat(dateFormatString);
		dateFormat.setLenient(false);
		dataBinder.registerCustomEditor(Date.class, new CustomDateEditor(
				dateFormat, true));
	}
	
	/*
	 * not in use
	 * @RequestMapping(value = { "validateCandidateLogin" }, method = RequestMethod.POST)
	public void validateCandidateLogin(HttpServletRequest request, HttpServletResponse response) {
		try {
			TypingTestViewModel typingTestViewModel= new TypingTestViewModel();
			ObjectOutputStream oos=null;
			Candidate candidate=null;
			VenueUser dbUser = new LoginServiceImpl().getUserByUsername(request.getParameter("uname"));			
			
			if (dbUser == null) {
				//user does not exist
				typingTestViewModel.setMessageCode(1);
			}
			if (dbUser.getFkRoleID()!=3) {
				//invalid user
				typingTestViewModel.setMessageCode(2);
			}
			if (!dbUser.getPassword().equals(request.getParameter("upass"))) {
				//either username or password did not match
				typingTestViewModel.setMessageCode(3);
			}			
			
			candidate = new CandidateServiceImpl().getCandidateByCandidateUsername(dbUser.getUserName());	
			typingTestViewModel.setCandidate(candidate);
			
			new LoginServiceImpl().updateLastLoginDeatilsByUserId(dbUser.getUserID());	
			
			OutputStream out = response.getOutputStream();
			oos = new ObjectOutputStream(out);
			oos.writeObject(candidate);
			
			//return candidate.getCandidateID();
			
			
		} catch (Exception ex) {
			LOGGER.error("Exception occured in validateCandidateLogin: " , ex);
			
			//return 0;
		}

	}*/
	/**
	 * Post method to fetch Candidate Details for Exam 
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = { "getCandidateDetailsForExam" }, method = RequestMethod.POST)
	public void getCandidateDetailsForExam(HttpServletRequest request, HttpServletResponse response) {
		try {
			CandidateService candidateService= new CandidateService();
			TypingTestViewModel typingTestViewModel= new TypingTestViewModel();			
			String candId=request.getParameter("ceid");		
			
			// write service to get candidate details for test(paper)
			typingTestViewModel=candidateService.getCandidateDetails(Long.parseLong(candId));
			StringBuilder stringBuilder=new StringBuilder();
			double oesWebVersion=AppInfoHelper.appInfo.getWebVersion();
			if(typingTestViewModel.getCandidate()!=null)
			{					
				stringBuilder.append("<Candidate>");
				stringBuilder.append("<cand_code><![CDATA["+typingTestViewModel.getCandidate().getCandidateCode()+"]]></cand_code>");
				stringBuilder.append("<cand_name><![CDATA["+typingTestViewModel.getCandidate().getCandidateFirstName()+"]]></cand_name>");
				stringBuilder.append("<center_code><![CDATA["+ typingTestViewModel.getExamVenue().getExamVenueCode()+"]]></center_code>");
				stringBuilder.append("<center_name><![CDATA["+typingTestViewModel.getExamVenue().getExamVenueName()+"]]></center_name>");
				stringBuilder.append("<bypass_supervisor_pwd>"+typingTestViewModel.getEventPaperDetails().getSupervisorPwdStartExam()+"</bypass_supervisor_pwd>");
				stringBuilder.append("<hide_result>"+typingTestViewModel.getEventPaperDetails().getShowResultType()+"</hide_result>");
				stringBuilder.append("<center_sup_pwd><![CDATA["+typingTestViewModel.getExamCenterSupervisorAssociation().getSupervisorPassword()+"]]></center_sup_pwd>");
				stringBuilder.append("<exam_name><![CDATA["+typingTestViewModel.getPaper().getName()+"]]></exam_name>");
				if(typingTestViewModel.getCandidateExam().getIsExamCompleted())
				{
					stringBuilder.append("<attempt_no>"+(typingTestViewModel.getCandidateExam().getAttemptNo()+1)+"</attempt_no>");
				}			
				else
				{
					stringBuilder.append("<attempt_no>"+typingTestViewModel.getCandidateExam().getAttemptNo()+"</attempt_no>");
				}						
				stringBuilder.append("<cand_photo><![CDATA["+typingTestViewModel.getCandidate().getCandidatePhoto()+"]]></cand_photo>");				
				stringBuilder.append("<cand_sign><![CDATA["+typingTestViewModel.getCandidate().getCandidateSignature()+"]]></cand_sign>");
				stringBuilder.append("<test_dur><![CDATA["+typingTestViewModel.getPaper().getDuration()+"]]></test_dur>");
				stringBuilder.append("<event_id>"+typingTestViewModel.getCandidateExam().getFkExamEventID()+"</event_id>");
				stringBuilder.append("<cand_id>"+typingTestViewModel.getCandidate().getCandidateID()+"</cand_id>");
				stringBuilder.append("<oes_version>"+oesWebVersion+"</oes_version>");
				stringBuilder.append("</Candidate>");			
				
			}				
		
			response.getWriter().write(stringBuilder.toString());				
			
		} catch (Exception ex) {
			LOGGER.error("Exception occured in getCandidateDetailsForExam: " , ex);			
			
		}

	}
	
	/**
	 * Post method for Candidate Exam List
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = { "getCandidateExamList" }, method = RequestMethod.POST)
	public void getCandidateExamList(HttpServletRequest request, HttpServletResponse response) {
		try {
			CandidateService candidateService= new CandidateService();
			List<TypingTestViewModel> typingTestViewModelList= new ArrayList<TypingTestViewModel>();
			ObjectOutputStream oos=null;
			String candId=request.getParameter("candid");
			//papertype : practice or main
			
			// write service to get list of typing paper associated with logged in candidate
			typingTestViewModelList=candidateService.GetExamListDtls(Long.parseLong(candId),ExamType.Practice.ordinal());
			
			
			OutputStream out = response.getOutputStream();
			oos = new ObjectOutputStream(out);
			oos.writeObject(typingTestViewModelList);// set listCandExam here instead of new object;
				//return candidate.getCandidateID();
			
			
		} catch (Exception ex) {
			LOGGER.error("Exception occured in validateCandidateLogin: " , ex);
			
			//return 0;
		}

	}
	
	/**
	 * Post method for Candidate Attempted Exam List
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = { "getCandidateAttemptedExamtList" }, method = RequestMethod.POST)
	public void getCandidateAttemptedExamtList(HttpServletRequest request, HttpServletResponse response) {
		try {
			CandidateService candidateService= new CandidateService();
			List<TypingTestViewModel> typingTestViewModelList= new ArrayList<TypingTestViewModel>();
			ObjectOutputStream oos=null;
			String candId=request.getParameter("candid");
			//papertype : practice or main
			
			// write service to get attempt record of typing paper associated with loggedIn candidate
			typingTestViewModelList=candidateService.getExamAttemptList(Long.parseLong(candId));
			
			StringBuilder stringBuilder=new StringBuilder();
			
			
			OutputStream out = response.getOutputStream();
			oos = new ObjectOutputStream(out);
			oos.writeObject(typingTestViewModelList);// set listCandExam here instead of new object;
				
			
			
		} catch (Exception ex) {
			LOGGER.error("Exception occured in validateCandidateLogin: " , ex);
			
			//return 0;
		}

	}
	
	/**
	 * Post method for Result Data
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = { "getResultData" }, method = RequestMethod.POST)
	public void getResultData(HttpServletRequest request, HttpServletResponse response) {
		try {
			CandidateService candidateService= new CandidateService();
			TypingTestViewModel typingTestViewModel= new TypingTestViewModel();
			ObjectOutputStream oos=null;
			String candId=request.getParameter("ceid");
			//papertype : practice or main
			
			// write service to get attempt record of typing paper associated with loggedIn candidate
			typingTestViewModel=candidateService.getAttemptResultData(Long.parseLong(candId));
			
			StringBuilder stringBuilder=new StringBuilder();
			if(typingTestViewModel.getCandidateAnswer()!=null && typingTestViewModel.getCandidateExam()!=null)
			{				
				stringBuilder.append("<resultdata>");
				stringBuilder.append("<net_speed><![CDATA["+typingTestViewModel.getCandidateExam().getMarksObtained()+"]]></net_speed>");
				stringBuilder.append("<wrong_words_count>"+typingTestViewModel.getCandidateAnswer().getTotalIncorrectChars()+"</wrong_words_count>");
				stringBuilder.append("<accuracy>"+typingTestViewModel.getCandidateAnswer().getAccuracy()+"</accuracy>");
				stringBuilder.append("</resultdata>");
				
			}
			OutputStream out = response.getOutputStream();
			oos = new ObjectOutputStream(out);
			oos.writeObject(typingTestViewModel);// set listCandExam here instead of new object;
				
			
			
		} catch (Exception ex) {
			LOGGER.error("Exception occured in validateCandidateLogin: " , ex);
			
			//return 0;
		}

	}
	
	/**
	 * Post method for Check Exam Type
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = { "checkExamType" }, method = RequestMethod.POST)
	public void checkExamType(HttpServletRequest request, HttpServletResponse response) {
		try {
			CandidateService candidateService= new CandidateService();		
			String result="";
			String candId=request.getParameter("ceid");
			
			 result=candidateService.checkExamType(Long.parseLong(candId));
			 response.getWriter().write(result);				
			
		} catch (Exception ex) {
			LOGGER.error("Exception occured in checkExamType: " , ex);		
		}

	}
	
	/**
	 * Post method to get attempt record of typing paper associated with logged in candidate 
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = { "insertOesCandExam" }, method = RequestMethod.POST)
	public void insertOesCandExam(HttpServletRequest request, HttpServletResponse response) {
		try {
			CandidateService candidateService= new CandidateService();		
			ObjectOutputStream oos=null;
			String candId=request.getParameter("candid");
			//papertype : practice or main
			
			// write service to get attempt record of typing paper associated with loggedIn candidate
			candidateService.insertOesCandExam(Long.parseLong(candId));
			
			OutputStream out = response.getOutputStream();
			oos = new ObjectOutputStream(out);
			oos.writeObject(new Object());// set listCandExam here instead of new object;
				
			
			
		} catch (Exception ex) {
			LOGGER.error("Exception occured in validateCandidateLogin: " , ex);
			
			//return 0;
		}

	}


	}

