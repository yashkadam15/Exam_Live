package mkcl.oesclient.solo.controllers;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.OutputStream;
import java.net.SocketException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.TimeUnit;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import mkcl.baseoesclient.model.LogType;
import mkcl.grievance.model.ClaimCode;
import mkcl.oes.commons.EncryptionHelper;
import mkcl.oes.commons.MIMETypeHelper;
import mkcl.oesclient.admin.services.ExamScheduleServiceImpl;
import mkcl.oesclient.commons.controllers.ExamLocaleThemeResolver;
import mkcl.oesclient.commons.controllers.OESLogger;
import mkcl.oesclient.commons.services.ExamClientServiceImpl;
import mkcl.oesclient.commons.services.ExamEventConfigurationServiceImpl;
import mkcl.oesclient.commons.services.ExamEventServiceImpl;
import mkcl.oesclient.commons.services.IExamEventConfigurationService;
import mkcl.oesclient.commons.services.PaperServiceImpl;
import mkcl.oesclient.commons.utilities.AppInfoHelper;
import mkcl.oesclient.commons.utilities.FileUploadHelper;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.commons.utilities.OESException;
import mkcl.oesclient.model.Candidate;
import mkcl.oesclient.model.CandidateAnswer;
import mkcl.oesclient.model.CandidateAttemptDetails;
import mkcl.oesclient.model.CandidateExam;
import mkcl.oesclient.model.CandidateItemAssociation;
import mkcl.oesclient.model.ItemStatus;
import mkcl.oesclient.model.VenueUser;
import mkcl.oesclient.security.AESHelperExtended;
import mkcl.oesclient.solo.services.BonusWeekServiceImpl;
import mkcl.oesclient.solo.services.CandidateExamServiceImpl;
import mkcl.oesclient.solo.services.MSCITServiceImpl;
import mkcl.oesclient.solo.services.SchedulePaperAssociationServicesImpl;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.oesclient.utilities.md5Helper;
import mkcl.oesclient.viewmodel.ExamPaperSetting;
import mkcl.oesclient.viewmodel.ExamViewModel;
import mkcl.oesclient.viewmodel.InstructionTemplateViewModel;
import mkcl.oesclient.viewmodel.MSCITViewModel;
import mkcl.oesclient.viewmodel.QuestionPaperPartialViewModel;
import mkcl.oespcs.model.AssessmentType;
import mkcl.oespcs.model.ExamEvent;
import mkcl.oespcs.model.ExamType;
import mkcl.oespcs.model.MarkingScheme;
import mkcl.oespcs.model.MediumOfPaper;
import mkcl.oespcs.model.Paper;
import mkcl.oespcs.model.PaperType;
import mkcl.oespcs.model.SchedulePaperAssociation;
import mkcl.oespcs.model.ScheduleType;
import mkcl.oespcs.model.Section;
import mkcl.oesserver.model.DifficultyLevel;
import mkcl.oesserver.model.FileTypeExtension;
import mkcl.oesserver.model.ItemType;
import mkcl.oesserver.model.MatchingPairs;
import mkcl.oesserver.model.MultimediaType;
import mkcl.oesserver.model.OptionMultipleCorrect;
import mkcl.oesserver.model.OptionPictureIdentification;
import mkcl.oesserver.model.OptionSingleCorrect;
import mkcl.oesserver.model.OptionSubItem;
import mkcl.oesserver.model.OptionSuccess;
import mkcl.oesserver.model.ReportItem;
import mkcl.oesserver.model.SubItem;
import mkcl.oesserver.viewmodel.FillInBlanksDetailsViewModel;
import mkcl.os.security.AESHelper;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.type.TypeFactory;

/**
 * 
 * @author amoghs
 * 
 */
@Controller
@RequestMapping(value = "/exam")
public class ExamController
{
	private static final Logger LOGGER = LoggerFactory.getLogger(ExamController.class);
	public static CandidateExamServiceImpl candidateExamServiceImpl = new CandidateExamServiceImpl();
	public static final String  CESessionVeriable = "candidateExam"; 
	public static final String ItemSessionVeriable = "itemId";
	public static final String MD5Rnum = "Rnum";
	public static final String SDT = "serverDateTime";
	
	@Autowired
	private ExamLocaleThemeResolver examLocaleThemeResolver;

	/**
	 * Post method for Authentication
	 * @param response
	 * @param model
	 * @param request
	 * @param session
	 * @param locale
	 * @return String this returns the path of a view
	 * @throws Exception
	 */
	
	
	
	
	
	@RequestMapping(value = "/AuthenticationGet", method = RequestMethod.POST)
	public String Authentication(HttpServletResponse response, Model model, HttpServletRequest request, HttpSession session, Locale locale) throws Exception 
	{
		long candidateExamId=0l;
		Map<String,Object> authData = new LinkedHashMap<String, Object>();
		Candidate candidate=null;

		//Code For dynamic logo render:13-july-2015:Yograjs
		model.addAttribute("clientid", AppInfoHelper.appInfo.getClientID());
		model.addAttribute("isCopyRightEnabled", AppInfoHelper.appInfo.getIsCopyRightEnabled());
		try
		{
			/* Added by Reena : 24 July 2015
			 * This call should always be on the top of each function as locale further 
			 accessed will not behave as required 
			 This call will set Exam Locale as per Medium of Paper.
			 */
			examLocaleThemeResolver.setExamLocaleAndTheme(request, response);	

			candidate = SessionHelper.getCandidate(request);

			if (candidate == null) {
				return "Common/Exam/SessionOut";
			}

			if(request.getParameter("ceid")!=null && !request.getParameter("ceid").isEmpty())
			{
				candidateExamId = Long.parseLong(request.getParameter("ceid"));				
			}
			else
			{
				LOGGER.error("Exam :: Parameter CandidateExamID is missing or empty.");
				response.sendError(HttpServletResponse.SC_FORBIDDEN, "Exam :: Parameter CandidateExamID is missing or empty.");
				return null;
			}

			authData = candidateExamServiceImpl.getDataForAuthentication(candidateExamId);

			if(authData != null && Boolean.parseBoolean(authData.get("EPD.SUPERVISORPWDSTARTEXAM").toString()))
			{
				model.addAttribute("paperNm", authData.get("P.NAME"));
				model.addAttribute("paperId", authData.get("P.PAPERID"));
				model.addAttribute("vid", authData.get("CECA.FKEXAMVENUEID"));
				model.addAttribute("imgPath", FileUploadHelper.getRelativeFolderPath(request, "CandidatePhotoUploadPath"));
				
				ExamEvent examEvent = SessionHelper.getExamEvent(request);
				model.addAttribute("examClientConfig", new ExamClientServiceImpl().getConfiguration(examEvent.getExamEventID()));
				model.addAttribute("evurl", AppInfoHelper.appInfo.getEvidenceURL());
				model.addAttribute("ec", candidateExamServiceImpl.getExamCenterVenue(candidate.getCandidateID(), examEvent.getExamEventID()));
				model.addAttribute("candidate", SessionHelper.getLogedInUser(request));
			//	model.addAttribute("camshotResolution", AppInfoHelper.appInfo.getCamshotResolution());
				model.addAttribute("screenshotResolution", AppInfoHelper.appInfo.getScreenshotResolution());
				
				if(request.getParameter("ceid")!=null && !request.getParameter("ceid").isEmpty())
				{
					model.addAttribute("ceid", request.getParameter("ceid"));		
				}
				if(request.getParameter("se")!=null && !request.getParameter("se").isEmpty())
				{
					model.addAttribute("se", request.getParameter("se"));	
				}
				if(request.getParameter("b")!=null && !request.getParameter("b").isEmpty()) 
				{
					model.addAttribute("b", request.getParameter("b"));	
				}
				if(request.getParameter("dcid")!=null && !request.getParameter("dcid").isEmpty())
				{
					model.addAttribute("dcid", request.getParameter("dcid"));	
				}
				Random random = new Random();
				int rnum = random.nextInt(100);
				model.addAttribute(MD5Rnum, rnum);
				SessionHelper.addVariable(MD5Rnum, rnum, session);
				model.addAttribute("jsTime", session.getId());
				model.addAttribute("jsTime1", new Date().getTime());
				model.addAttribute(SDT, new Date()); // This time used evidence date time set
				return "Solo/Exam/Authentication";
			}
			else
			{
				LOGGER.error("Exam :: Authentication Data not found.");
				model.addAttribute("error", "Authentication Data not found.");
				response.sendError(HttpServletResponse.SC_FORBIDDEN,"Exam :: Authentication Data not found.");
				return null;
			}
		}
		catch(Exception e)
		{
			LOGGER.error("Exam :: error in processing Authentication request",e);
			model.addAttribute("error", "Unable to process authentication request.");
			response.sendError(HttpServletResponse.SC_FORBIDDEN, e.getMessage());
			return null;
		}
		finally
		{
			authData=null;
		}
	}
	
	/**
	 * Post method for Instruction
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return String this returns the path of a view
	 * @throws Exception
	 */
	@RequestMapping(value = "/instruction", method = {RequestMethod.POST})
	public String Instruction(Model model, HttpServletRequest request, HttpServletResponse response,HttpSession session) throws Exception 
	{
		try 
		{
			examLocaleThemeResolver.setExamLocaleAndTheme(request, response);
			model.addAttribute("clientid", AppInfoHelper.appInfo.getClientID());
			model.addAttribute("isCopyRightEnabled", AppInfoHelper.appInfo.getIsCopyRightEnabled());
			model.addAttribute("imgPath", FileUploadHelper.getRelativeFolderPath(request, "CandidatePhotoUploadPath"));
			if(request.getParameter("ceid")!=null && !request.getParameter("ceid").isEmpty())
			{
				model.addAttribute("ceid", request.getParameter("ceid"));		
			}
			if(request.getParameter("se")!=null && !request.getParameter("se").isEmpty())
			{
				model.addAttribute("se", request.getParameter("se"));	
			}
			if(request.getParameter("b")!=null && !request.getParameter("b").isEmpty()) 
			{
				model.addAttribute("b", request.getParameter("b"));	
			}
			if(request.getParameter("dcid")!=null && !request.getParameter("dcid").isEmpty())
			{
				model.addAttribute("dcid", request.getParameter("dcid"));	
			}
			
			if(request.getParameter("ispw") != null && request.getParameter("authBtn") != null)
			{
				boolean res = AuthenticationPost(response, model, request);
				if(!res)
				{
					return "Solo/Exam/Authentication";
				}
			}
			SessionHelper.removeVariable(MD5Rnum, request);
			Candidate candidate = SessionHelper.getCandidate(request);
			long candidateExamId=0;
			long scheduleEnd=0;

			if (candidate == null) {
				return "Common/Exam/SessionOut";
			}			
			ExamEvent examEvent = SessionHelper.getExamEvent(request);

			if(request.getParameter("ceid")!=null && !request.getParameter("ceid").isEmpty())
			{
				candidateExamId = Long.parseLong(request.getParameter("ceid"));				
			}
			else
			{
				LOGGER.error("Exam :: Parameter CandidateExamID is missing or empty.");
				response.sendError(HttpServletResponse.SC_FORBIDDEN, "Exam :: Parameter CandidateExamID is missing or empty.");
				return null;
			}
			
			// validate user authorized or not
			CandidateExam candidateExam = candidateExamServiceImpl.getCandidateExamBycandidateExamID(candidateExamId);
			
			
			if (candidateExam ==null || ! candidate.getCandidateID().equals(candidateExam.getFkCandidateID())) {
				response.sendError(HttpServletResponse.SC_FORBIDDEN, "Requested exam is not authorized to logged in candidate");
				return null;
			}
			SessionHelper.addVariable(CESessionVeriable, candidateExam, session);			
			//To check schedule is available or not if not then schedule is expired.
			if(request.getParameter("dcid")!=null && !request.getParameter("dcid").isEmpty() && request.getParameter("dcid") != "0" && candidateExamId != 0l)
			{
				SchedulePaperAssociationServicesImpl schedulePaperAssociationServicesImpl = new SchedulePaperAssociationServicesImpl();
				long scheduleId = schedulePaperAssociationServicesImpl.getTodaysScheduleIdByScheduleType(ScheduleType.Week,examEvent.getExamEventID());				
				if(scheduleId==0l)
				{
					schedulePaperAssociationServicesImpl=null;
					return "redirect:../commonExam/scheduleExpired";
				}
			}
			
			if (candidateExam.getIsExamCompleted() && candidateExamServiceImpl.getExamTypeByCandidateExamId(candidateExamId).equals(ExamType.Main)) {
				return "redirect:../commonExam/alreadyAttempted";
			}
			
			if(request.getParameter("se")!=null && !request.getParameter("se").isEmpty())
			{
				scheduleEnd = Long.parseLong(request.getParameter("se"));	
				//check for schedule expiry
				if(!compareScheduleDateExpiry(scheduleEnd)){
					return "redirect:../commonExam/scheduleExpired";
				}
			}
			else if(request.getParameter("dcid") == null)
			{
				LOGGER.error("Exam :: Parameter SchduleEnd is missing or empty.");
				response.sendError(HttpServletResponse.SC_FORBIDDEN,"Exam :: Parameter SchduleEnd is missing or empty.");
				return null;
			}			

			InstructionTemplateViewModel instructions=candidateExamServiceImpl.getInstructionTemplatsByPaperIDandEventID(candidateExam.getFkPaperID(), candidateExam.getFkExamEventID());

			List<MediumOfPaper> mediumOfPapersList = candidateExamServiceImpl.getLanguageListByPaperID(candidateExam.getFkPaperID());
			Paper paper = new PaperServiceImpl().getpaperByPaperID(candidateExam.getFkPaperID());
			/*Start::Added code for the Showing Media Player on Instruction Page Date:23-Jul-2015:Yograj*/
			/*Modified By Reena : 20 apr 16,to get item type count instead of true false,as to enable support for RIFORM item type*/
			//boolean isMMAvailable=false;
			//isMMAvailable=candidateExamServiceImpl.getIsAnyMMItemForCandidatePaper(paper.getPaperID());			
			List<ItemType> MMItemTypeList=candidateExamServiceImpl.getIsAnyMMItemForCandidatePaper(paper.getPaperID());
			if(MMItemTypeList!=null && MMItemTypeList.contains(ItemType.RIFORM))
				model.addAttribute("isRIFORMItem", true);
			else
				model.addAttribute("isRIFORMItem", false);
			
			if(MMItemTypeList!=null && MMItemTypeList.contains(ItemType.PRT)) {
				model.addAttribute("isPRTItem", true);
				/*
				 * ItemType
				 * itemType=candidateExamServiceImpl.getItemTypeByCandidateExamID(candidateExam.
				 * getCandidateExamID(), paper.getPaperID()); if(itemType !=null &&
				 * itemType.equals(ItemType.PRT)) model.addAttribute("isPRTItem", true); else
				 * model.addAttribute("isPRTItem", false);
				 */
			}
			else
				model.addAttribute("isPRTItem", false);
			List<CandidateItemAssociation> candidateItemAssociations = candidateExamServiceImpl.getCandidateItemAssociationsByCandidateExamID(candidateExam.getCandidateExamID(),paper.getPaperID());
			String examStartDate=candidateExamServiceImpl.getAttemptDate(candidateExamId);
			model.addAttribute("MMItemTypeList", MMItemTypeList);
			/*End::Added code for the Showing Media Player on Instruction Page*/
			String timeLeft = calculateElapsedTime(candidateExam, paper,scheduleEnd);
			model.addAttribute("examClientConfig", new ExamClientServiceImpl().getConfiguration(examEvent.getExamEventID()));
			model.addAttribute("paper", paper);
			model.addAttribute("timeLeft", timeLeft);
			model.addAttribute("examStartDate", examStartDate);
			model.addAttribute("candidateItemAssociations", candidateItemAssociations);
			model.addAttribute("mediumOfPapersList", mediumOfPapersList);
			model.addAttribute("instructions", instructions);
			model.addAttribute("examEvent",examEvent);
			model.addAttribute("candidate", candidate);
			model.addAttribute("ec", candidateExamServiceImpl.getExamCenterVenue(candidateExam.getFkCandidateID(), candidateExam.getFkExamEventID()));
			model.addAttribute("evurl", AppInfoHelper.appInfo.getEvidenceURL());
		} 
		catch (Exception e) 
		{
			LOGGER.error("Exception occured in getInstructions: ", e);
			response.sendError(HttpServletResponse.SC_FORBIDDEN, e.getMessage());
			return null;
		}

		return "Solo/Exam/instructions";
	}

	/**
	 * Method for Authentication
	 * @param response
	 * @param model
	 * @param request
	 * @return boolean this returns true when valid
	 * @throws Exception
	 */
	boolean AuthenticationPost(HttpServletResponse response, Model model, HttpServletRequest request) throws Exception 
	{
		try 
		{
			if(request.getParameter("pwd") == null || request.getParameter("pwd").isEmpty())
			{
				ExamEvent examEvent = SessionHelper.getExamEvent(request);
				model.addAttribute("paperNm", request.getParameter("paperNm"));
				model.addAttribute("vid", request.getParameter("vid"));
				model.addAttribute("examClientConfig", new ExamClientServiceImpl().getConfiguration(examEvent.getExamEventID()));
				model.addAttribute("evurl", AppInfoHelper.appInfo.getEvidenceURL());
				model.addAttribute("ec", candidateExamServiceImpl.getExamCenterVenue(SessionHelper.getCandidate(request).getCandidateID(), examEvent.getExamEventID()));
				model.addAttribute("candidate", SessionHelper.getLogedInUser(request));
				model.addAttribute("paperId", request.getParameter("pid"));
				model.addAttribute("messageText", "Password cannot be blank.");
				model.addAttribute(SDT, new Date()); // This time used evidence date time set
				return false;
			}		
			md5Helper md5 = new md5Helper();
			String saltMd5 = md5.getsaltMD5(candidateExamServiceImpl.getSupervisorPwd(Long.parseLong(request.getParameter("vid"))),SessionHelper.getVariable("Rnum", request).toString());
			if(!saltMd5.equals(request.getParameter("pwd")))
			{
				ExamEvent examEvent = SessionHelper.getExamEvent(request);
				model.addAttribute("paperNm", request.getParameter("paperNm"));
				model.addAttribute("vid", request.getParameter("vid"));
				model.addAttribute("examClientConfig", new ExamClientServiceImpl().getConfiguration(examEvent.getExamEventID()));
				model.addAttribute("evurl", AppInfoHelper.appInfo.getEvidenceURL());
				model.addAttribute("ec", candidateExamServiceImpl.getExamCenterVenue(SessionHelper.getCandidate(request).getCandidateID(), examEvent.getExamEventID()));
				model.addAttribute("candidate", SessionHelper.getLogedInUser(request));
				model.addAttribute("paperId", request.getParameter("pid"));
				model.addAttribute("messageText", "Password did not match.");
				model.addAttribute(SDT, new Date()); // This time used evidence date time set
				return false;
			}
			return true;
		} 
		catch (Exception e) 
		{
			LOGGER.error("Exam while authenticating supervisor password.",e);
			throw e;
		}
	}

	/**
	 * Post method for Take a test
	 * @param response
	 * @param model
	 * @param request
	 * @param session
	 * @param locale
	 * @return String this returns the path of a view
	 * @throws Exception
	 */
	@RequestMapping(value = "/TakeTest", method = RequestMethod.POST)
	public String TakeTest(HttpServletResponse response, Model model, HttpServletRequest request, HttpSession session, Locale locale) throws Exception {
		String isPRTItem = request.getParameter("isPRTItem");
		model.addAttribute("isPRTItem", isPRTItem);
		String view=GenrateAndValidateTest(response, model, request, session, locale);
		SessionHelper.addVariable("SPWDverifyStatus", false, session);
		return view;			
	}

	/**
	 * Method to Compare Schedule Date Expiry
	 * @param scheduleEndDate
	 * @return boolean this returns true if the schedule has not expired yet
	 */
	public boolean compareScheduleDateExpiry(long scheduleEndDate){
		if(scheduleEndDate!=0l){
			Date now=new Date();
			if(now.compareTo(new Date(scheduleEndDate))==-1){
				return true;
			}
		}
		return false;
	}

	/**
	 * Method to Calculate Elapsed Time 
	 * @param candidateExam
	 * @param paper
	 * @param scheduleEnd
	 * @return String this returns the elapsed time
	 */
	String calculateElapsedTime(CandidateExam candidateExam, Paper paper,long scheduleEnd) {
		Date now=new Date();		
		if(new Date(scheduleEnd).before(now))
		{
			return  0 + ":" + 0;
		}
		
		long remainingElapsedTimeInSec = (Long.parseLong(paper.getDuration())) - Long.parseLong(candidateExam.getElapsedTime());
		long remainingTimeToScheduleEndInSec = (scheduleEnd-now.getTime()) / 1000;
		if(remainingElapsedTimeInSec > 0 && remainingTimeToScheduleEndInSec > 0)
		{
			if(remainingTimeToScheduleEndInSec >= remainingElapsedTimeInSec)
			{
				long min = TimeUnit.MINUTES.convert(remainingElapsedTimeInSec, TimeUnit.SECONDS);
				remainingElapsedTimeInSec -= TimeUnit.SECONDS.convert(min, TimeUnit.MINUTES);				
				return min + ":" + remainingElapsedTimeInSec;
			}
			else
			{
				long min = TimeUnit.MINUTES.convert(remainingTimeToScheduleEndInSec, TimeUnit.SECONDS);
				remainingTimeToScheduleEndInSec -= TimeUnit.SECONDS.convert(min, TimeUnit.MINUTES);					
				return min + ":" + remainingTimeToScheduleEndInSec;
			}
		}
		return 0 + ":" + 0;
	}

	/**
	 * Method for Sub-Question Container
	 * @param response
	 * @param model
	 * @param request
	 * @param session
	 * @param subQID
	 * @param selectedLang
	 * @return String this returns the path of a view
	 * @throws Exception
	 */
	@RequestMapping(value = "/sub_QuestionContainer/{subQID}/{selectedLang}", method = RequestMethod.GET)
	public String sub_QuestionContainer(HttpServletResponse response, Model model, HttpServletRequest request, HttpSession session,@PathVariable("subQID") long subQID, @PathVariable("selectedLang") String selectedLang) throws Exception 
	{
		try 
		{
			CandidateExam candidateExam = (CandidateExam)SessionHelper.getVariable(CESessionVeriable, request);
			ExamViewModel examViewModel = candidateExamServiceImpl.loadCMPSMQTSubQuestionByItemID(candidateExam.getCandidateExamID() ,subQID, selectedLang);
			List<CandidateAnswer> candidateAnswers = null;
			if(examViewModel == null || examViewModel.getCandidateItemAssociation() == null || examViewModel.getCandidateItemAssociation().getCandidateSubItemAssociation() == null)
			{
				throw new NullPointerException("Some of the sub item models are not found.");
			}
			
			if(examViewModel.getCandidateItemAssociation().getCandidateSubItemAssociation().getItemStatus() == ItemStatus.Answered)
			{
				candidateAnswers = candidateExamServiceImpl.getCandidateAnswersByItemIdandCandidateExamItemId(examViewModel.getCandidateItemAssociation().getCandidateSubItemAssociation().getFkItemID(), examViewModel.getCandidateItemAssociation().getCandidateSubItemAssociation().getCandidateExamItemID());
				if (candidateAnswers != null && candidateAnswers.size() != 0) {
					model.addAttribute("mode", "update");
				}
			}
			switch (examViewModel.getItemType()) 
			{
				case MCSC:
				case TRUEFALSE:
				case YN:
					candidateAnswers = getCandidateAnswerForMCSC(request, examViewModel, candidateAnswers);
					examViewModel.getCandidateItemAssociation().getCandidateSubItemAssociation().setCandidateAnswers(candidateAnswers);
					break;
				case MCMC:
					candidateAnswers = getCandidateAnswerForMCMC(request, examViewModel, candidateAnswers);
					examViewModel.getCandidateItemAssociation().getCandidateSubItemAssociation().setCandidateAnswers(candidateAnswers);
					break;
				case EW:
					candidateAnswers = getCandidateAnswerForEW(request, examViewModel, candidateAnswers);
					examViewModel.getCandidateItemAssociation().getCandidateSubItemAssociation().setCandidateAnswers(candidateAnswers);
					break;
				default:
					response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Some data is missing or Unknown item type in sub_QuestionContainer");
					return null;
			}
			
			if(examViewModel.getItemType() != ItemType.MM)
			{
				model.addAttribute("examViewModel", examViewModel);
				model.addAttribute("candidateItemAssociation", examViewModel.getCandidateItemAssociation());
				return "Solo/Exam/Sub_" + examViewModel.getItemType().name();
			}
		} 
		catch (Exception e) 
		{
			LOGGER.error("exam :: error found in sub_QuestionContainer",e);			
		}
		
		response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "exam :: No view page resolved in sub_QuestionContainer");
		return null;
	}
	
	/**
	 * Get method for Question Container
	 * @param response
	 * @param model
	 * @param request
	 * @param session
	 * @return String this returns the path of a view
	 * @throws Exception
	 */
	@RequestMapping(value = "/QuestionContainer", method = RequestMethod.GET)
	public String QuestionContainer(HttpServletResponse response, Model model, HttpServletRequest request, HttpSession session) throws Exception {
		
		try
		{
			Candidate candidate = SessionHelper.getCandidate(request);
			long paperID = SessionHelper.getExamPaperSetting(request).getPaperID();
			if (candidate == null || paperID <=0) {
				return "Common/Exam/SessionOut";
			}
			
			String selectedLang=request.getParameter("selectedLang");

			long candidateExamID=SessionHelper.getExamPaperSetting(request).getCandidateExamID();
						
			// validate user authorized or not
			CandidateExam candidateExam = (CandidateExam)SessionHelper.getVariable(CESessionVeriable, request);
			if(candidateExam!=null && candidateExam.getIsExamCompleted()) 
			{
				return "redirect:../commonExam/alreadyAttempted";
			}
			ExamViewModel examViewModel = null;
			List<CandidateAnswer> candidateAnswers = null;
			Map<Long,List<CandidateAnswer>> subItemCandidateAnswers = null;
			String imgrelativePath = FileUploadHelper.getRelativeFolderPath(request, "UserPhotoUploadPath");
			model.addAttribute("imgPath", imgrelativePath);	
			model.addAttribute("claimCodeOptions", ClaimCode.values());
			String secID = request.getParameter("secID");
			if (request.getParameter("itemID") != null && !request.getParameter("itemID").isEmpty()) {
				String itemId = request.getParameter("itemID");
				examViewModel = candidateExamServiceImpl.loadItemByItemID(paperID, candidateExamID, Long.parseLong(itemId), selectedLang, false);
			} else {
				examViewModel = candidateExamServiceImpl.loadNotAttemptedItemByCandidateExamID(candidateExamID, paperID, request.getParameter("curitemID") == null ? null : Long.parseLong(request.getParameter("curitemID")),Long.parseLong(secID), selectedLang, SessionHelper.getExamPaperSetting(request).getPalletFwdOnly());
			}

			// check & get if item is already solved
			if (examViewModel != null) 
			{
				if(examViewModel.getCandidateItemAssociation() != null && examViewModel.getCandidateItemAssociation().getItemStatus() == ItemStatus.Answered ||  (examViewModel.getItemType()==ItemType.NFIB && examViewModel.getCandidateItemAssociation().getItemStatus() == ItemStatus.PartiallyAnswered))
				{
					candidateAnswers = candidateExamServiceImpl.getCandidateAnswersByItemIdandCandidateExamItemId(examViewModel.getCandidateItemAssociation().getFkItemID(), examViewModel.getCandidateItemAssociation().getCandidateExamItemID());
					if (candidateAnswers != null && candidateAnswers.size() != 0) {
						model.addAttribute("mode", "update");
					}
				}
				switch (examViewModel.getItemType()) 
				{
					case MCSC:
					case TRUEFALSE:
					case YN:
						candidateAnswers = getCandidateAnswerForMCSC(request, examViewModel, candidateAnswers);
						examViewModel.getCandidateItemAssociation().setCandidateAnswers(candidateAnswers);
						break;
					case MCMC:
						candidateAnswers = getCandidateAnswerForMCMC(request, examViewModel, candidateAnswers);
						examViewModel.getCandidateItemAssociation().setCandidateAnswers(candidateAnswers);
						break;
					case PI:
						candidateAnswers = getCandidateAnswerForPI(request, examViewModel, candidateAnswers);
						examViewModel.getCandidateItemAssociation().setCandidateAnswers(candidateAnswers);
						break;
					case SML:
						candidateAnswers = getCandidateAnswerForSML(request, examViewModel, candidateAnswers);
						examViewModel.getCandidateItemAssociation().setCandidateAnswers(candidateAnswers);
						break;
					case CMPS:
						subItemCandidateAnswers = candidateExamServiceImpl.getCandidateAnswersBySubItemIdandCandidateExamItemId(examViewModel.getCandidateItemAssociation().getFkItemID(),  examViewModel.getCandidateItemAssociation().getFkCandidateExamID());
						if (subItemCandidateAnswers != null && subItemCandidateAnswers.size() > 0) {
							model.addAttribute("mode", "update");
						}
						getCandidateAnswerForCMPS(request,examViewModel,subItemCandidateAnswers);
						break;
					case MM:
						subItemCandidateAnswers = candidateExamServiceImpl.getCandidateAnswersBySubItemIdandCandidateExamItemId(examViewModel.getCandidateItemAssociation().getFkItemID(),  examViewModel.getCandidateItemAssociation().getFkCandidateExamID());
						if (subItemCandidateAnswers != null && subItemCandidateAnswers.size() > 0) {
							model.addAttribute("mode", "update");
						}
						getCandidateAnswerForMM(request,examViewModel,subItemCandidateAnswers);
						break;
					case MP:
						subItemCandidateAnswers = candidateExamServiceImpl.getCandidateAnswersBySubItemIdandCandidateExamItemId(examViewModel.getCandidateItemAssociation().getFkItemID(),  examViewModel.getCandidateItemAssociation().getFkCandidateExamID());
						if (subItemCandidateAnswers != null && subItemCandidateAnswers.size() > 0) {
							model.addAttribute("mode", "update");
						}
						//mix all subItem options
						mixSubItemOptionsforMatchhePair(examViewModel);
						getCandidateAnswerForMP(request,examViewModel,subItemCandidateAnswers);
						break;
					case PRT:
						candidateAnswers = getCandidateAnswerForPRT(request, examViewModel);
						examViewModel.getCandidateItemAssociation().setCandidateAnswers(candidateAnswers);
						/*
						 * start By harshadd
						 */
						List<VenueUser> users = SessionHelper.getLogedInUsers(request);
						String itemBankGroupID=Long.toString(examViewModel.getPaperItemBankAssociation().getItemBankGroupID());
						String difficultyLevel=examViewModel.getItemBankItemAssociation().getDifficultyLevel().name();
						String key= createReqMarkingSchemeKey(request,difficultyLevel,itemBankGroupID, String.valueOf(examViewModel.getCandidateItemAssociation().getFkItemID()));
						model.addAttribute("marksPerItem", SessionHelper.getExamPaperSetting(request).getMarks(key));
						model.addAttribute("negMarksPerItem", SessionHelper.getExamPaperSetting(request).getNegativeMarks(key));
						model.addAttribute("csrfToken",URLEncoder.encode(AESHelperExtended.encryptAsRandom(users.get(0).getUserName(), EncryptionHelper.encryptDecryptKey), "UTF-8"));
						model.addAttribute("sessionId", session.getId());
						model.addAttribute("itemType", "PRT");
						/*
						 * end By harshadd
						 */
						break;
					case RIFORM:
						candidateAnswers = getCandidateAnswerForRIFORM(request, examViewModel, candidateAnswers);
						examViewModel.getCandidateItemAssociation().setCandidateAnswers(candidateAnswers);
						break;
					case SCS:
						candidateAnswers = getCandidateAnswerForSCS(request, examViewModel, candidateAnswers);
						examViewModel.getCandidateItemAssociation().setCandidateAnswers(candidateAnswers);
						break;
					case SQ:
					case MTC:
					case EC:
					case RWP :
					case FQFA :
						candidateAnswers = getCandidateAnswerForMTCSQ(request, examViewModel, candidateAnswers);
						examViewModel.getCandidateItemAssociation().setCandidateAnswers(candidateAnswers);
						break;
					case EW:
						candidateAnswers = getCandidateAnswerForEW(request, examViewModel, candidateAnswers);
						examViewModel.getCandidateItemAssociation().setCandidateAnswers(candidateAnswers);
						break;
					case WC:
						candidateAnswers = getCandidateAnswerForWC(request, examViewModel, candidateAnswers);
						examViewModel.getCandidateItemAssociation().setCandidateAnswers(candidateAnswers);
						break;
					case HS:
						candidateAnswers = getCandidateAnswerForHS(request, examViewModel, candidateAnswers);
						examViewModel.getCandidateItemAssociation().setCandidateAnswers(candidateAnswers);
						break;
					case CMPSMQT:
						if(request.getParameter("SubitemID") != null && !request.getParameter("SubitemID").isEmpty())
						{
							long SubitemId = Long.parseLong(request.getParameter("SubitemID"));
							examViewModel.getComprehensionMixQT().setNextSubQId(SubitemId); 
						}
						List<CandidateItemAssociation> subItemAssociations = candidateExamServiceImpl.getCandidateSubItemAssoListByParentItemId(examViewModel.getItemBankItemAssociation().getItemID().getItemID(), candidateExam.getCandidateExamID());
						model.addAttribute("subItemAssociations", subItemAssociations);
						break;
					case NFIB:
						candidateAnswers = getCandidateAnswerForNFIB(request, examViewModel, candidateAnswers);
						examViewModel.getCandidateItemAssociation().setCandidateAnswers(candidateAnswers);
						examViewModel.getNewFillInBlanksList().get(0).setItemText(loadNFIBItemText(examViewModel));
						break;
					default:
						if(examViewModel != null && examViewModel.getCandidateItemAssociation() != null && examViewModel.getCandidateItemAssociation().getFkItemID() > 0)
						{
							LOGGER.error(String.format("Some data is missing, For item id %s for ceid %s", examViewModel.getCandidateItemAssociation().getFkItemID(), candidateExamID));
						}
						else
						{
							LOGGER.error(String.format("Unknown item type, passed item type is %s", examViewModel.getItemType()));
						}
						model.addAttribute("loadParent", "1");
						response.sendError(HttpServletResponse.SC_FORBIDDEN, "Some data is missing or Unknown item type");
						return null;
				}
				model.addAttribute("candidateItemAssociation", examViewModel.getCandidateItemAssociation());
				if (examViewModel.getCandidateItemAssociation().getItemStatus() == ItemStatus.NoStatus) 
				{
					examViewModel.getCandidateItemAssociation().setItemStatus(ItemStatus.NotAnswered);
					candidateExamServiceImpl.updateItemStatusByCandidateExamID(examViewModel.getCandidateItemAssociation().getCandidateExamItemID(), ItemStatus.NotAnswered, false);
				}
				model.addAttribute("examViewModel", examViewModel);
				model.addAttribute("selectedLang", selectedLang);
				model.addAttribute("jsTime", session.getId());
				model.addAttribute("jsTime1", new Date().getTime());
				model.addAttribute("reportedItemClaimCode", candidateExamServiceImpl.getClaimCodeForReportedItem(candidateExamID, examViewModel.getCandidateItemAssociation().getFkItemID()));
				
				response.setCharacterEncoding("UTF-8");
				
				//Add item id in session 
				SessionHelper.addVariable(ItemSessionVeriable, examViewModel.getCandidateItemAssociation().getFkItemID(), session);
				
				if(examViewModel.getItemType() != ItemType.MM)
				{
					return "Solo/Exam/" + examViewModel.getItemType().name();
				}
				else
				{
					if(MultimediaType.AUDIO == examViewModel.getMultimedias().get(0).getMultimediaType())
					{
						return "Solo/Exam/MMAudio";
					}
					return "Solo/Exam/MMVideo";
				}
			}
			else if(examViewModel == null)
			{
				LOGGER.error("Exam model not found.");
			}
		}
		catch(Exception e)
		{
			LOGGER.error("exam :: error found in QuestionContainer",e);			
		}
		model.addAttribute("loadParent", "1");
		response.sendError(HttpServletResponse.SC_FORBIDDEN, "exam :: error found in QuestionContainer");
		return null;
	}

	/**
	 * Post method for Process Question
	 * @param model
	 * @param request
	 * @param response
	 * @param candidateItemAssociation
	 * @return String this returns the path of a view
	 * @throws Exception
	 */
	@RequestMapping(value = "/ProcessQuestion", method = RequestMethod.POST)
	public String ProcessQuestion(Model model, HttpServletRequest request, HttpServletResponse response , @ModelAttribute("candidateItemAssociation") CandidateItemAssociation candidateItemAssociation) throws Exception {
		try
		{
			Candidate candidate = SessionHelper.getCandidate(request);
			ExamPaperSetting paperSetting = SessionHelper.getExamPaperSetting(request);
			
			if (candidate == null || paperSetting ==null) {
				//return "redirect:../login/loginpage";
				return "Common/Exam/SessionOut";
			}
			long candidateExamID = paperSetting.getCandidateExamID();
			String itemId = request.getParameter("curitemID");
			String secID= request.getParameter("sectionID");
			/*
			 * start By harshadd
			 */
			String itemBankGroupID=request.getParameter("itemBankGroupID");
			String difficultyLevel=request.getParameter("difficultyLevel");
			String key= createReqMarkingSchemeKey(request,difficultyLevel,itemBankGroupID,itemId);
			/*
			 * end By harshadd
			 */
			
			// validate user authorized or not
			CandidateExam candidateExam = (CandidateExam)SessionHelper.getVariable(CESessionVeriable, request);
			if(candidateExam!=null && candidateExam.getIsExamCompleted()) {
				return "redirect:../commonExam/alreadyAttempted";
					
				}
			ItemType itemType = candidateItemAssociation.getItem().getItemtype();
			
			switch (itemType) 
			{
				case PRT:
					model.addAttribute("itemType", "PRT");
			}

			long sessionItemId=(long)SessionHelper.getVariable(ItemSessionVeriable, request);
			if(request.getParameter("Save") != null || request.getParameter("SaveLoadNextSub") != null || request.getParameter("Reset") != null || request.getParameter("Review") != null || (request.getParameter("saveEW")!=null && request.getParameter("saveEW").equals("1")))
			{
				switch (itemType) 
				{
				// when item has subitem
				case CMPS:
				case MP:
				case MM:
					if(! candidate.getCandidateID().equals(candidateExam.getFkCandidateID()) 
							|| candidateItemAssociation.getFkItemID()!=sessionItemId
							|| candidateItemAssociation.getCandidateSubItemAssociations().stream().filter(q -> q.getCandidateAnswers().stream().filter(a -> a.getFkcandidateID() !=  candidate.getCandidateID()).count() > 0).count()>0 
							|| candidateItemAssociation.getCandidateSubItemAssociations().stream().filter(q -> q.getCandidateAnswers().stream().filter(a -> a.getFkCandidateExamID() !=  candidateExam.getCandidateExamID()).count() > 0).count()>0) {
						response.sendError(HttpServletResponse.SC_FORBIDDEN, "Submitted answer is not authorized to logged in candidate or rendered question");
						return null;
					}
					if(!paperSetting.getAllowAnswerUpdate() && candidateExamServiceImpl.isAlreadyAnswered(candidateItemAssociation.getCandidateExamItemID()))
					{
						response.sendError(HttpServletResponse.SC_FORBIDDEN, "Answer change is not allowed");
						return null;
					}
					break;
				case CMPSMQT:
					if(! candidate.getCandidateID().equals(candidateExam.getFkCandidateID()) 
							|| candidateItemAssociation.getFkItemID()!=sessionItemId
							|| candidateItemAssociation.getCandidateSubItemAssociation().getCandidateAnswers().stream().filter(a -> a.getFkcandidateID() !=  candidate.getCandidateID()).count() > 0 
							|| candidateItemAssociation.getCandidateSubItemAssociation().getCandidateAnswers().stream().filter(a -> a.getFkCandidateExamID() !=  candidateExam.getCandidateExamID()).count() > 0) {
						response.sendError(HttpServletResponse.SC_FORBIDDEN, "Submitted answer is not authorized to logged in candidate or rendered question");
						return null;
					}
					if(!paperSetting.getAllowAnswerUpdate() && candidateExamServiceImpl.isAlreadyAnswered(candidateItemAssociation.getCandidateExamItemID()))
					{
						response.sendError(HttpServletResponse.SC_FORBIDDEN, "Answer change is not allowed");
						return null;
					}
					break;
				default:
					if (! candidate.getCandidateID().equals(candidateExam.getFkCandidateID())
							|| candidateItemAssociation.getFkItemID()!=sessionItemId
							|| candidateItemAssociation.getCandidateAnswers().stream().filter(a->a.getFkcandidateID() !=  candidate.getCandidateID()).count()>0 
							|| candidateItemAssociation.getCandidateAnswers().stream().filter(a->a.getFkCandidateExamID() !=  candidateExam.getCandidateExamID()).count()>0) {
						response.sendError(HttpServletResponse.SC_FORBIDDEN, "Submitted answer is not authorized to logged in candidate or rendered question");
						return null;
					}
					if(!paperSetting.getAllowAnswerUpdate() && candidateExamServiceImpl.isAlreadyAnswered(candidateItemAssociation.getCandidateExamItemID()))
					{
						response.sendError(HttpServletResponse.SC_FORBIDDEN, "Answer change is not allowed");
						return null;
					}
					break;
				}
			}
			
			
			if (request.getParameter("Save") != null || (request.getParameter("saveEW")!=null && request.getParameter("saveEW").equals("1"))) 
			{
				boolean saved = true;
				switch (itemType) 
				{
				// when item has subitem
				case SML:				
					long perctMarksObt=Long.parseLong(candidateItemAssociation.getCandidateAnswers().get(0).getMarksInPercentage());
					double marksObt=SessionHelper.getExamPaperSetting(request).getMarks(key)*((double)perctMarksObt/100);
					saved = candidateExamServiceImpl.saveCandidateAnswer(candidateItemAssociation,marksObt,SessionHelper.getExamPaperSetting(request).getNegativeMarks(key),ItemStatus.Answered);
					break;
				case RIFORM:
				case EW:
					if(request.getParameter("answerfilename")!=null && !request.getParameter("answerfilename").isEmpty()) {
						candidateItemAssociation.getCandidateAnswers().get(0).setAnswerFileName(request.getParameter("answerfilename"));	
					}										
					saved = candidateExamServiceImpl.saveCandidateAnswer(candidateItemAssociation,0.0,0.0,ItemStatus.Answered);
					break;
				case CMPSMQT:
					key= createReqMarkingSchemeKey(request,difficultyLevel,itemBankGroupID,String.valueOf(candidateItemAssociation.getCandidateSubItemAssociation().getFkItemID()));
					saved = candidateExamServiceImpl.saveCandidateAnswer(candidateItemAssociation,SessionHelper.getExamPaperSetting(request).getMarks(key),SessionHelper.getExamPaperSetting(request).getNegativeMarks(key),ItemStatus.Answered);
					break;
				default:
					saved = candidateExamServiceImpl.saveCandidateAnswer(candidateItemAssociation,SessionHelper.getExamPaperSetting(request).getMarks(key),SessionHelper.getExamPaperSetting(request).getNegativeMarks(key),ItemStatus.Answered);
					break;
				}
				
				if(!saved)
				{
					LOGGER.error("Exception Occured while TakeTest:: Candidate Answer not saved");
					model.addAttribute("loadParent", "1");		
					response.sendError(HttpServletResponse.SC_FORBIDDEN, "Exception Occured while TakeTest:: Candidate Answer not saved");
					return null;
				}
				return "redirect:QuestionContainer?curitemID=" + itemId + "&selectedLang=" + request.getParameter("selectedLang") + "&secID=" + secID;
			} 
			else if (request.getParameter("SaveLoadNextSub") != null) 
			{
				boolean saved = true;
				switch (itemType) 
				{
				// when item has subitem
				case SML:				
					long perctMarksObt=Long.parseLong(candidateItemAssociation.getCandidateAnswers().get(0).getMarksInPercentage());
					double marksObt=SessionHelper.getExamPaperSetting(request).getMarks(key)*((double)perctMarksObt/100);
					saved = candidateExamServiceImpl.saveCandidateAnswer(candidateItemAssociation,marksObt,SessionHelper.getExamPaperSetting(request).getNegativeMarks(key),ItemStatus.Answered);
					break;
				case RIFORM:
				case EW:
					saved = candidateExamServiceImpl.saveCandidateAnswer(candidateItemAssociation,0.0,0.0,ItemStatus.Answered);
					break;
				case CMPSMQT:
					key= createReqMarkingSchemeKey(request,difficultyLevel,itemBankGroupID,String.valueOf(candidateItemAssociation.getCandidateSubItemAssociation().getFkItemID()));
					saved = candidateExamServiceImpl.saveCandidateAnswer(candidateItemAssociation,SessionHelper.getExamPaperSetting(request).getMarks(key),SessionHelper.getExamPaperSetting(request).getNegativeMarks(key),ItemStatus.Answered);
					break;
				default:
					saved = candidateExamServiceImpl.saveCandidateAnswer(candidateItemAssociation,SessionHelper.getExamPaperSetting(request).getMarks(key),SessionHelper.getExamPaperSetting(request).getNegativeMarks(key),ItemStatus.Answered);
					break;
				}
				
				if(!saved)
				{
					LOGGER.error("Exception Occured while TakeTest:: Candidate Answer not saved");
					model.addAttribute("loadParent", "1");		
					response.sendError(HttpServletResponse.SC_FORBIDDEN, "Exception Occured while TakeTest:: Candidate Answer not saved");
					return null;
				}
				return "redirect:QuestionContainer?itemID=" + itemId + "&SubitemID=" + request.getParameter("cursubitemID") + "&selectedLang=" + request.getParameter("selectedLang") + "&secID=" + secID;
			}
			else if (request.getParameter("Reset") != null) 
			{
				boolean result=true;
				switch (itemType) 
				{
				case CMPSMQT:				
					result = candidateExamServiceImpl.deleteCandidateAnswerCMPSMQT(candidateItemAssociation);
					break;
				default:
					result = candidateExamServiceImpl.deleteCandidateAnswer(candidateItemAssociation, (itemType != ItemType.CMPS && itemType != ItemType.MM && itemType != ItemType.MP) ? 0l : candidateItemAssociation.getFkItemID());
					break;
				}
				
				if(!result)
				{
					LOGGER.error("Exception Occured while TakeTest:: Candidate Answer is not reset.");
					model.addAttribute("loadParent", "1");		
					response.sendError(HttpServletResponse.SC_FORBIDDEN, "Exception Occured while TakeTest:: Candidate Answer is not reset.");
					return null;
				}
				return "redirect:QuestionContainer?itemID=" + itemId + "&SubitemID=" + request.getParameter("cursubitemID")  + "&selectedLang=" + request.getParameter("selectedLang") + "&secID=" + secID;
			} 
			else if (request.getParameter("Skip") != null || (request.getParameter("hidExt") != null && request.getParameter("hidExt").toString().matches("Skip")) || request.getParameter("Next") != null) 
			{
				if( !(ItemType.CMPSMQT == itemType && (candidateItemAssociation.getItemStatus()==ItemStatus.PartiallyAnswered || candidateItemAssociation.getItemStatus()==ItemStatus.Answered)) && !((ItemType.PRT == itemType) && (request.getParameter("Next") != null))) { //condition added so that the practical question for which Next button was clicked should not be marked as skipped
					candidateExamServiceImpl.updateItemStatusByCandidateExamID(candidateItemAssociation.getCandidateExamItemID(), ItemStatus.Skipped, false);
				}
				return "redirect:QuestionContainer?curitemID=" + itemId + "&selectedLang=" + request.getParameter("selectedLang") + "&secID=" + secID;
			} 
			else if (request.getParameter("SkipLoadNextSub") != null)
			{
				return "redirect:QuestionContainer?itemID=" + itemId + "&SubitemID=" + request.getParameter("cursubitemID")  + "&selectedLang=" + request.getParameter("selectedLang") + "&secID=" + secID;
			}
			else if (request.getParameter("hidExt") != null && request.getParameter("hidExt").toString().matches("loadItem"))																													
			{
				return "redirect:QuestionContainer?itemID=" + itemId + "&selectedLang=" + request.getParameter("selectedLang") + "&secID=" + secID;
			}
			else if (request.getParameter("hidExt") != null && request.getParameter("hidExt").toString().matches("loadCMPSMQTSubItem"))																													
			{
				return "redirect:QuestionContainer?itemID=" + itemId + "&SubitemID=" + request.getParameter("cursubitemID")  + "&selectedLang=" + request.getParameter("selectedLang") + "&secID=" + secID;
			}
			else if(request.getParameter("hidExt") != null && request.getParameter("hidExt").toString().matches("loadSec"))
			{
				return "redirect:QuestionContainer?selectedLang=" + request.getParameter("selectedLang") + "&secID=" + secID;
			}
			else if (request.getParameter("hidExt") != null && request.getParameter("hidExt").toString().matches("loadNextItem"))																													
			{
				return "redirect:QuestionContainer?curitemID=" + itemId + "&selectedLang=" + request.getParameter("selectedLang") + "&secID=" + secID;
			}
			else if(request.getParameter("hidExt") != null && request.getParameter("hidExt").toString().split("\\|")[0].matches("autoSaveItem"))
			{
				//autosave mode for similution,PRT item type is not supported.
				boolean saved = true;
				if(itemType == ItemType.MCSC || itemType == ItemType.MCMC || itemType == ItemType.PI || itemType == ItemType.TRUEFALSE || itemType == ItemType.YN  || itemType == ItemType.NFIB){
					saved = candidateExamServiceImpl.saveCandidateAnswer(candidateItemAssociation,SessionHelper.getExamPaperSetting(request).getMarks(key),SessionHelper.getExamPaperSetting(request).getNegativeMarks(key),ItemStatus.Answered);
				}else if(itemType == ItemType.CMPS || itemType == ItemType.MM || itemType == ItemType.MP){
					saved = candidateExamServiceImpl.saveCandidateAnswer(candidateItemAssociation,SessionHelper.getExamPaperSetting(request).getMarks(key),SessionHelper.getExamPaperSetting(request).getNegativeMarks(key),ItemStatus.Answered);
				}

				if(!saved){
					LOGGER.error("error in saving answer in autosave mode for ceid="+candidateExamID+" and ceitmid="+candidateItemAssociation.getCandidateExamItemID());
				}

				return "redirect:/commonExam/hidFrameendTest?t=" + request.getParameter("hidExt").toString().split("\\|")[1];
			}
		}
		catch(Exception e)
		{
			LOGGER.error("Exception Occured while TakeTest: ", e);
			model.addAttribute("error", e);			
		}
		model.addAttribute("loadParent", "1");		
		response.sendError(HttpServletResponse.SC_FORBIDDEN, "Exception Occured while TakeTest: ");
		return null;
	}

	/**
	 * Method to fetch the Candidate Answer List for Multiple Choice Single Correct Questions
	 * @param request
	 * @param examViewModel
	 * @param candidateAnswers
	 * @return List<CandidateAnswer> this returns the CandidateAnswerList 
	 * @throws Exception
	 */
	private List<CandidateAnswer> getCandidateAnswerForMCSC(HttpServletRequest request, ExamViewModel examViewModel, List<CandidateAnswer> candidateAnswers) throws Exception {
		List<CandidateAnswer> answers = new ArrayList<CandidateAnswer>();
		try 
		{
			if (candidateAnswers == null || candidateAnswers.size() == 0) {
				candidateAnswers = new ArrayList<CandidateAnswer>();
				for (OptionSingleCorrect optionSingleCorrect : examViewModel.getMultipleChoiceSingleCorrect().getOptionList()) {
					CandidateAnswer candidateAnswer = new CandidateAnswer();
					candidateAnswer.setFkItemID(examViewModel.getCandidateItemAssociation().getFkItemID());
					candidateAnswer.setFkcandidateID(SessionHelper.getCandidate(request).getCandidateID());
					candidateAnswer.setCandidateExamItemID(examViewModel.getCandidateItemAssociation().getCandidateExamItemID());
					candidateAnswer.setFkCandidateExamID(SessionHelper.getExamPaperSetting(request).getCandidateExamID());
					candidateAnswer.setFkExamEventID(SessionHelper.getExamEvent(request).getExamEventID());
					answers.add(candidateAnswer);
				}
			} else {
				int outterCount = 0;
				int innerCount = 0;
				boolean Insertflag = false;
				for (OptionSingleCorrect optionSingleCorrect : examViewModel.getMultipleChoiceSingleCorrect().getOptionList()) {
					for (CandidateAnswer candidateAnswer : candidateAnswers) {
						if (candidateAnswer.getOptionID() == optionSingleCorrect.getOptionLanguage().getOption().getOptionID()) {
							answers.add(outterCount, candidateAnswer);
							Insertflag = true;
							break;
						}
						innerCount++;
					}
					if (!Insertflag) {
						CandidateAnswer candidateAnswer = new CandidateAnswer();
						candidateAnswer.setFkItemID(examViewModel.getCandidateItemAssociation().getFkItemID());
						candidateAnswer.setFkcandidateID(SessionHelper.getCandidate(request).getCandidateID());
						candidateAnswer.setCandidateExamItemID(examViewModel.getCandidateItemAssociation().getCandidateExamItemID());
						candidateAnswer.setFkCandidateExamID(SessionHelper.getExamPaperSetting(request).getCandidateExamID());
						candidateAnswer.setFkExamEventID(SessionHelper.getExamEvent(request).getExamEventID());
						answers.add(outterCount, candidateAnswer);
					}
					Insertflag = false;
					outterCount++;
				}
			}
			return answers;
		}
		catch(Exception e)
		{
			throw e;			
		}
	}

	/**
	 * Method to fetch the Candidate Answer List for SCS Questions
	 * @param request
	 * @param examViewModel
	 * @param candidateAnswers
	 * @return List<CandidateAnswer> this returns the CandidateAnswerList 
	 * @throws Exception
	 */
	private List<CandidateAnswer> getCandidateAnswerForSCS(HttpServletRequest request, ExamViewModel examViewModel, List<CandidateAnswer> candidateAnswers) throws Exception {
		List<CandidateAnswer> answers = new ArrayList<CandidateAnswer>();
		try 
		{

			if (candidateAnswers == null || candidateAnswers.size() == 0) {
				candidateAnswers = new ArrayList<CandidateAnswer>();
				for (OptionSuccess optionSuccess : examViewModel.getSuccessList().get(0).getOptionList()) {
					CandidateAnswer candidateAnswer = new CandidateAnswer();
					candidateAnswer.setFkItemID(examViewModel.getCandidateItemAssociation().getFkItemID());
					candidateAnswer.setFkcandidateID(SessionHelper.getCandidate(request).getCandidateID());
					candidateAnswer.setCandidateExamItemID(examViewModel.getCandidateItemAssociation().getCandidateExamItemID());
					candidateAnswer.setFkCandidateExamID(SessionHelper.getExamPaperSetting(request).getCandidateExamID());
					candidateAnswer.setFkExamEventID(SessionHelper.getExamEvent(request).getExamEventID());
					// candidateAnswer.setOptionID(optionSingleCorrect.getOptionLanguage().getOption().getOptionID());
					answers.add(candidateAnswer);
				}
			} else {
				int outterCount = 0;
				int innerCount = 0;
				boolean Insertflag = false;
				for (OptionSuccess optionSuccess : examViewModel.getSuccessList().get(0).getOptionList()) {
					for (CandidateAnswer candidateAnswer : candidateAnswers) {
						if (candidateAnswer.getOptionID() == optionSuccess.getOptionLanguage().getOption().getOptionID()) {
							answers.add(outterCount, candidateAnswer);
							Insertflag = true;
							break;
						}
						innerCount++;
					}
					if (!Insertflag) {
						CandidateAnswer candidateAnswer = new CandidateAnswer();
						candidateAnswer.setFkItemID(examViewModel.getCandidateItemAssociation().getFkItemID());
						candidateAnswer.setFkcandidateID(SessionHelper.getCandidate(request).getCandidateID());
						candidateAnswer.setCandidateExamItemID(examViewModel.getCandidateItemAssociation().getCandidateExamItemID());
						candidateAnswer.setFkCandidateExamID(SessionHelper.getExamPaperSetting(request).getCandidateExamID());
						candidateAnswer.setFkExamEventID(SessionHelper.getExamEvent(request).getExamEventID());
						// candidateAnswer.setOptionID(optionSingleCorrect.getOptionLanguage().getOption().getOptionID());
						answers.add(outterCount, candidateAnswer);
					}
					Insertflag = false;
					outterCount++;
				}
			}

			return answers;
		}
		catch(Exception e)
		{
			throw e;			
		}
	}

	/**
	 * Method to fetch the Candidate Answer List for Multiple Choice Multiple Correct Questions
	 * @param request
	 * @param examViewModel
	 * @param candidateAnswers
	 * @return List<CandidateAnswer> this returns the CandidateAnswerList 
	 * @throws Exception
	 */
	private List<CandidateAnswer> getCandidateAnswerForMCMC(HttpServletRequest request, ExamViewModel examViewModel, List<CandidateAnswer> candidateAnswers) throws Exception {
		List<CandidateAnswer> answers = new ArrayList<CandidateAnswer>();
		try
		{
			if (candidateAnswers == null || candidateAnswers.size() == 0) {
				candidateAnswers = new ArrayList<CandidateAnswer>();
				for (OptionMultipleCorrect optionMultipleCorrect : examViewModel.getMultipleChoiceMultipleCorrect().getOptionList()) {
					CandidateAnswer candidateAnswer = new CandidateAnswer();
					candidateAnswer.setFkItemID(examViewModel.getCandidateItemAssociation().getFkItemID());
					candidateAnswer.setFkcandidateID(SessionHelper.getCandidate(request).getCandidateID());
					candidateAnswer.setCandidateExamItemID(examViewModel.getCandidateItemAssociation().getCandidateExamItemID());
					candidateAnswer.setFkCandidateExamID(SessionHelper.getExamPaperSetting(request).getCandidateExamID());
					candidateAnswer.setFkExamEventID(SessionHelper.getExamEvent(request).getExamEventID());
					answers.add(candidateAnswer);
				}
			} else {
				int outterCount = 0;
				int innerCount = 0;
				boolean Insertflag = false;
				for (OptionMultipleCorrect optionMultipleCorrect : examViewModel.getMultipleChoiceMultipleCorrect().getOptionList()) {
					for (CandidateAnswer candidateAnswer : candidateAnswers) {
						if (candidateAnswer.getOptionID() == optionMultipleCorrect.getOptionLanguage().getOption().getOptionID()) {
							answers.add(outterCount, candidateAnswer);
							Insertflag = true;
							break;
						}
						innerCount++;
					}
					if (!Insertflag) {
						CandidateAnswer candidateAnswer = new CandidateAnswer();
						candidateAnswer.setFkItemID(examViewModel.getCandidateItemAssociation().getFkItemID());
						candidateAnswer.setFkcandidateID(SessionHelper.getCandidate(request).getCandidateID());
						candidateAnswer.setCandidateExamItemID(examViewModel.getCandidateItemAssociation().getCandidateExamItemID());
						candidateAnswer.setFkCandidateExamID(SessionHelper.getExamPaperSetting(request).getCandidateExamID());
						candidateAnswer.setFkExamEventID(SessionHelper.getExamEvent(request).getExamEventID());
						answers.add(outterCount, candidateAnswer);
					}
					Insertflag = false;
					outterCount++;
				}
			}
			return answers;
		}
		catch(Exception e)
		{
			throw e;
		}
	}

	/**
	 * Method to fetch the Candidate Answer List for Picture Identification Questions
	 * @param request
	 * @param examViewModel
	 * @param candidateAnswers
	 * @return List<CandidateAnswer> this returns the CandidateAnswerList 
	 * @throws Exception
	 */
	private List<CandidateAnswer> getCandidateAnswerForPI(HttpServletRequest request, ExamViewModel examViewModel, List<CandidateAnswer> candidateAnswers) throws Exception {
		List<CandidateAnswer> answers = new ArrayList<CandidateAnswer>();
		try
		{
			if (candidateAnswers == null || candidateAnswers.size() == 0) {
				candidateAnswers = new ArrayList<CandidateAnswer>();
				for (OptionPictureIdentification optionPictureIdentification : examViewModel.getPictureIdentifications().get(0).getOptionList()) {
					CandidateAnswer candidateAnswer = new CandidateAnswer();
					candidateAnswer.setFkItemID(examViewModel.getCandidateItemAssociation().getFkItemID());
					candidateAnswer.setFkcandidateID(SessionHelper.getCandidate(request).getCandidateID());
					candidateAnswer.setCandidateExamItemID(examViewModel.getCandidateItemAssociation().getCandidateExamItemID());
					candidateAnswer.setFkCandidateExamID(SessionHelper.getExamPaperSetting(request).getCandidateExamID());
					candidateAnswer.setFkExamEventID(SessionHelper.getExamEvent(request).getExamEventID());
					// candidateAnswer.setOptionID(optionSingleCorrect.getOptionLanguage().getOption().getOptionID());
					answers.add(candidateAnswer);
				}
			} else {
				int outterCount = 0;
				int innerCount = 0;
				boolean Insertflag = false;
				for (OptionPictureIdentification optionPictureIdentification : examViewModel.getPictureIdentifications().get(0).getOptionList()) {
					for (CandidateAnswer candidateAnswer : candidateAnswers) {
						if (candidateAnswer.getOptionID() == optionPictureIdentification.getOptionLanguage().getOption().getOptionID()) {
							answers.add(outterCount, candidateAnswer);
							Insertflag = true;
							break;
						}
						innerCount++;
					}
					if (!Insertflag) {
						CandidateAnswer candidateAnswer = new CandidateAnswer();
						candidateAnswer.setFkItemID(examViewModel.getCandidateItemAssociation().getFkItemID());
						candidateAnswer.setFkcandidateID(SessionHelper.getCandidate(request).getCandidateID());
						candidateAnswer.setCandidateExamItemID(examViewModel.getCandidateItemAssociation().getCandidateExamItemID());
						candidateAnswer.setFkCandidateExamID(SessionHelper.getExamPaperSetting(request).getCandidateExamID());
						candidateAnswer.setFkExamEventID(SessionHelper.getExamEvent(request).getExamEventID());
						// candidateAnswer.setOptionID(optionSingleCorrect.getOptionLanguage().getOption().getOptionID());
						answers.add(outterCount, candidateAnswer);
					}
					Insertflag = false;
					outterCount++;
				}
			}
			return answers;
		}
		catch(Exception e)
		{
			throw e;
		}
	}

	/*
	 * by harshadd
	 */
	/**
	 * Method to fetch the Candidate Answer List for SML Questions
	 * @param request
	 * @param examViewModel
	 * @param candidateAnswers
	 * @return List<CandidateAnswer> this returns the CandidateAnswerList 
	 * @throws Exception
	 */
	private List<CandidateAnswer> getCandidateAnswerForSML(HttpServletRequest request, ExamViewModel examViewModel, List<CandidateAnswer> candidateAnswers) throws Exception {
		List<CandidateAnswer> answers = new ArrayList<CandidateAnswer>();
		try
		{
			if (candidateAnswers == null || candidateAnswers.size() == 0) {
				//	for (OptionSingleCorrect optionSingleCorrect : examViewModel.getSimulations().get(0).getOptionList()) {
				CandidateAnswer candidateAnswer = new CandidateAnswer();
				candidateAnswer.setFkItemID(examViewModel.getCandidateItemAssociation().getFkItemID());
				candidateAnswer.setFkcandidateID(SessionHelper.getCandidate(request).getCandidateID());
				candidateAnswer.setCandidateExamItemID(examViewModel.getCandidateItemAssociation().getCandidateExamItemID());
				candidateAnswer.setFkCandidateExamID(SessionHelper.getExamPaperSetting(request).getCandidateExamID());
				candidateAnswer.setFkExamEventID(SessionHelper.getExamEvent(request).getExamEventID());
				// candidateAnswer.setOptionID(optionSingleCorrect.getOptionLanguage().getOption().getOptionID());
				answers.add(candidateAnswer);
				//}
			} else {
				for (CandidateAnswer candidateAnswer : candidateAnswers) {
					answers.add(candidateAnswer);
				}
			}
			return answers;
		}
		catch (Exception e)
		{
			throw e;
		}
	}

	//reena 18 apr 16
	/**
	 * Method to fetch the Candidate Answer List for RIFORM Questions
	 * @param request
	 * @param examViewModel
	 * @param candidateAnswers
	 * @return List<CandidateAnswer> this returns the CandidateAnswerList 
	 * @throws Exception
	 */
	private List<CandidateAnswer> getCandidateAnswerForRIFORM(HttpServletRequest request, ExamViewModel examViewModel, List<CandidateAnswer> candidateAnswers) throws Exception {
		List<CandidateAnswer> answers = new ArrayList<CandidateAnswer>();
		try
		{
			if (candidateAnswers == null || candidateAnswers.size() == 0) {
				//	for (OptionSingleCorrect optionSingleCorrect : examViewModel.getSimulations().get(0).getOptionList()) {
				CandidateAnswer candidateAnswer = new CandidateAnswer();
				candidateAnswer.setFkItemID(examViewModel.getCandidateItemAssociation().getFkItemID());
				candidateAnswer.setFkcandidateID(SessionHelper.getCandidate(request).getCandidateID());
				candidateAnswer.setCandidateExamItemID(examViewModel.getCandidateItemAssociation().getCandidateExamItemID());
				candidateAnswer.setFkCandidateExamID(SessionHelper.getExamPaperSetting(request).getCandidateExamID());
				candidateAnswer.setFkExamEventID(SessionHelper.getExamEvent(request).getExamEventID());
				// candidateAnswer.setOptionID(optionSingleCorrect.getOptionLanguage().getOption().getOptionID());
				answers.add(candidateAnswer);
				//}
			} else {
				for (CandidateAnswer candidateAnswer : candidateAnswers) {
					answers.add(candidateAnswer);
				}
			}
			return answers;
		}
		catch (Exception e)
		{
			throw e;
		}
	}
	
	/**
	 * Get method for Display Image
	 * @param model
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = { "/displayImage" }, method = RequestMethod.GET)
	public void demoImg(Model model, HttpServletRequest request, HttpServletResponse response) {

		try {
			String imgName = request.getParameter("disImg");
			if (imgName != null && !imgName.isEmpty()) {

				File sourceFile = new File(FileUploadHelper.getPhysicalFolderPathWithinWebApp(request, "FileUploadPath") + imgName);
				OutputStream os = AESHelper.decryptAsStream(sourceFile, EncryptionHelper.encryptDecryptKey);
				ByteArrayOutputStream baos = new ByteArrayOutputStream();
				baos = (ByteArrayOutputStream) os;

				byte[] imageBytes = baos.toByteArray();
				response.setContentType("image/jpeg");
				response.setContentLength(imageBytes.length);
				OutputStream outs = response.getOutputStream();
				outs.write(imageBytes);

			}

		} catch (Exception e) {
			LOGGER.error("Exception occured in demoImg: ", e);
		}

	}

	/**
	 * Get method for Media
	 * @param model
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = { "/getmedia" }, method = RequestMethod.GET)
	public void getmedia(Model model, HttpServletRequest request, HttpServletResponse response) {
		OutputStream os = null;
		ByteArrayOutputStream baos=null;
		try {
			String fnm = request.getParameter("f");
			String e = request.getParameter("e");			
			if (fnm != null && !fnm.isEmpty()) {
				File sourceFile = new File(FileUploadHelper.getPhysicalFolderPathWithinWebApp(request, "FileUploadPath") + fnm);				
				os = AESHelper.decryptAsStream(sourceFile, EncryptionHelper.encryptDecryptKey);
				baos = new ByteArrayOutputStream();
				baos = (ByteArrayOutputStream) os;

				byte[] imageBytes = baos.toByteArray();
				response.setContentType(MIMETypeHelper.getMimeTypeByFileExtension(FileTypeExtension.valueOf(e)));
				response.setContentLength(imageBytes.length);
				response.getOutputStream().write(imageBytes);
				response.getOutputStream().flush();
			}

		}catch (SocketException se)
		{

		} catch (Exception e) {
			//LOGGER.error("Exception occured in getmedia: ", e);
		}		
		finally{
			try
			{
				if(os!=null)
					os.close();
				if(baos!=null)
					baos.close();				
			}
			catch(Exception e)
			{
				LOGGER.error("Exception occured in closing resources: ", e);		
			}
		}

	}
	/*
	 * 
	 * end Image Decryption
	 */
	/**
	 * Get method to Decrypt and De-compress File
	 * @param model
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = { "/decruptDecompressfile" }, method = RequestMethod.GET)
	public void decruptDecompressfile(Model model, HttpServletRequest request, HttpServletResponse response) {
		try {
			String encfile = request.getParameter("encfile");
			if (encfile != null && !encfile.isEmpty()) {
				File sourceFile = new File(FileUploadHelper.getPhysicalFolderPathWithinWebApp(request, "FileUploadPath") + encfile);
				OutputStream os = AESHelper.decryptAsStream(sourceFile, EncryptionHelper.encryptDecryptKey);
				ByteArrayOutputStream baos = (ByteArrayOutputStream) os;
				byte[] fileBytes = baos.toByteArray();
				response.setContentType("application/x-shockwave-flash");
				response.setContentLength(fileBytes.length);
				OutputStream outs = response.getOutputStream();
				outs.write(fileBytes);
			}
		} catch (Exception e) {
			LOGGER.error("Exception occured in decruptDecompressfile: ", e);
		}
	}

	
	/**
	 * Method to fetch the Candidate Answer List for CMPS Questions
	 * @param request
	 * @param examViewModel
	 * @param subItemCandidateAnswers
	 * @throws Exception
	 */
	private void getCandidateAnswerForCMPS(HttpServletRequest request, ExamViewModel examViewModel, Map<Long,List<CandidateAnswer>> subItemCandidateAnswers) throws Exception {

		try
		{   
			List<CandidateAnswer> answers = null;
			List<CandidateAnswer> candidateAnswers = null;
			int index = 0;
			for (SubItem subItem :  examViewModel.getComprehensions().get(0).getSubItemList()) {
				answers = new ArrayList<CandidateAnswer>();
				candidateAnswers = null;
				candidateAnswers = subItemCandidateAnswers.get(subItem.getItemLanguage().getItem().getItemID());
				if (candidateAnswers == null || candidateAnswers.size() == 0) {
					candidateAnswers = new ArrayList<CandidateAnswer>();
					for (OptionSubItem optionSubItem : subItem.getOptionList()) {
						CandidateAnswer candidateAnswer = new CandidateAnswer();
						candidateAnswer.setFkItemID(subItem.getItemLanguage().getItem().getItemID());
						candidateAnswer.setFkParentItemID(examViewModel.getCandidateItemAssociation().getFkItemID());
						candidateAnswer.setFkcandidateID(SessionHelper.getCandidate(request).getCandidateID());
						candidateAnswer.setCandidateExamItemID(examViewModel.getCandidateItemAssociation().getCandidateSubItemAssociations().get(index).getCandidateExamItemID());
						candidateAnswer.setFkCandidateExamID(SessionHelper.getExamPaperSetting(request).getCandidateExamID());
						candidateAnswer.setFkExamEventID(SessionHelper.getExamEvent(request).getExamEventID());
						// candidateAnswer.setOptionID(optionSingleCorrect.getOptionLanguage().getOption().getOptionID());
						answers.add(candidateAnswer);
					}
				} else {
					int outterCount = 0;
					int innerCount = 0;
					boolean Insertflag = false;
					for (OptionSubItem optionSubItem : subItem.getOptionList()) {
						for (CandidateAnswer candidateAnswer : candidateAnswers) {
							if (candidateAnswer.getOptionID() == optionSubItem.getOptionLanguage().getOption().getOptionID()) {
								answers.add(outterCount, candidateAnswer);
								Insertflag = true;
								break;
							}
							innerCount++;
						}
						if (!Insertflag) {
							CandidateAnswer candidateAnswer = new CandidateAnswer();
							candidateAnswer.setFkItemID(subItem.getItemLanguage().getItem().getItemID());
							candidateAnswer.setFkParentItemID(examViewModel.getCandidateItemAssociation().getFkItemID());
							candidateAnswer.setFkcandidateID(SessionHelper.getCandidate(request).getCandidateID());
							candidateAnswer.setCandidateExamItemID(examViewModel.getCandidateItemAssociation().getCandidateSubItemAssociations().get(index).getCandidateExamItemID());
							candidateAnswer.setFkCandidateExamID(SessionHelper.getExamPaperSetting(request).getCandidateExamID());
							candidateAnswer.setFkExamEventID(SessionHelper.getExamEvent(request).getExamEventID());
							// candidateAnswer.setOptionID(optionSingleCorrect.getOptionLanguage().getOption().getOptionID());
							answers.add(outterCount, candidateAnswer);
						}
						Insertflag = false;
						outterCount++;
					}
				}
				examViewModel.getCandidateItemAssociation().getCandidateSubItemAssociations().get(index++).setCandidateAnswers(answers);
			}
		}
		catch(Exception e)
		{
			throw e;
		}
	}

	/**
	 * Method to fetch the Candidate Answer List for Multi-Media Questions
	 * @param request
	 * @param examViewModel
	 * @param subItemCandidateAnswers
	 * @throws Exception
	 */
	private void getCandidateAnswerForMM(HttpServletRequest request, ExamViewModel examViewModel, Map<Long,List<CandidateAnswer>> subItemCandidateAnswers) throws Exception {

		try
		{   
			List<CandidateAnswer> answers = null;
			List<CandidateAnswer> candidateAnswers = null;
			int index = 0;
			for (SubItem subItem :  examViewModel.getMultimedias().get(0).getSubItemList()) {
				answers = new ArrayList<CandidateAnswer>();
				candidateAnswers = null;
				candidateAnswers = subItemCandidateAnswers.get(subItem.getItemLanguage().getItem().getItemID());
				if (candidateAnswers == null || candidateAnswers.size() == 0) {
					candidateAnswers = new ArrayList<CandidateAnswer>();
					for (OptionSubItem optionSubItem : subItem.getOptionList()) {
						CandidateAnswer candidateAnswer = new CandidateAnswer();
						candidateAnswer.setFkItemID(subItem.getItemLanguage().getItem().getItemID());
						candidateAnswer.setFkParentItemID(examViewModel.getCandidateItemAssociation().getFkItemID());
						candidateAnswer.setFkcandidateID(SessionHelper.getCandidate(request).getCandidateID());
						candidateAnswer.setCandidateExamItemID(examViewModel.getCandidateItemAssociation().getCandidateSubItemAssociations().get(index).getCandidateExamItemID());
						candidateAnswer.setFkCandidateExamID(SessionHelper.getExamPaperSetting(request).getCandidateExamID());
						candidateAnswer.setFkExamEventID(SessionHelper.getExamEvent(request).getExamEventID());
						// candidateAnswer.setOptionID(optionSingleCorrect.getOptionLanguage().getOption().getOptionID());
						answers.add(candidateAnswer);
					}
				} else {
					int outterCount = 0;
					int innerCount = 0;
					boolean Insertflag = false;
					for (OptionSubItem optionSubItem : subItem.getOptionList()) {
						for (CandidateAnswer candidateAnswer : candidateAnswers) {
							if (candidateAnswer.getOptionID() == optionSubItem.getOptionLanguage().getOption().getOptionID()) {
								answers.add(outterCount, candidateAnswer);
								Insertflag = true;
								break;
							}
							innerCount++;
						}
						if (!Insertflag) {
							CandidateAnswer candidateAnswer = new CandidateAnswer();
							candidateAnswer.setFkItemID(subItem.getItemLanguage().getItem().getItemID());
							candidateAnswer.setFkParentItemID(examViewModel.getCandidateItemAssociation().getFkItemID());
							candidateAnswer.setFkcandidateID(SessionHelper.getCandidate(request).getCandidateID());
							candidateAnswer.setCandidateExamItemID(examViewModel.getCandidateItemAssociation().getCandidateSubItemAssociations().get(index).getCandidateExamItemID());
							candidateAnswer.setFkCandidateExamID(SessionHelper.getExamPaperSetting(request).getCandidateExamID());
							candidateAnswer.setFkExamEventID(SessionHelper.getExamEvent(request).getExamEventID());
							// candidateAnswer.setOptionID(optionSingleCorrect.getOptionLanguage().getOption().getOptionID());
							answers.add(outterCount, candidateAnswer);
						}
						Insertflag = false;
						outterCount++;
					}
				}
				examViewModel.getCandidateItemAssociation().getCandidateSubItemAssociations().get(index++).setCandidateAnswers(answers);
			}
		}
		catch(Exception e)
		{
			throw e;
		}
	}

	/**
	 * Method to fetch the Candidate Answer List for MP Questions
	 * @param request
	 * @param examViewModel
	 * @param subItemCandidateAnswers
	 * @throws Exception
	 */
	private void getCandidateAnswerForMP(HttpServletRequest request, ExamViewModel examViewModel, Map<Long,List<CandidateAnswer>> subItemCandidateAnswers) throws Exception {

		try
		{   

			List<CandidateAnswer> answers = null;
			List<CandidateAnswer> candidateAnswers = null;
			int index = 0;
			for (SubItem subItem :  examViewModel.getMatchingPairsList().get(0).getSubItemList()) {
				answers = new ArrayList<CandidateAnswer>();
				candidateAnswers = null;
				candidateAnswers = subItemCandidateAnswers.get(subItem.getItemLanguage().getItem().getItemID());
				if (candidateAnswers == null || candidateAnswers.size() == 0) {
					candidateAnswers = new ArrayList<CandidateAnswer>();

					//	for (OptionSubItem optionSubItem : subItem.getOptionList()) {
					CandidateAnswer candidateAnswer = new CandidateAnswer();
					candidateAnswer.setFkItemID(subItem.getItemLanguage().getItem().getItemID());
					candidateAnswer.setFkParentItemID(examViewModel.getCandidateItemAssociation().getFkItemID());
					candidateAnswer.setFkcandidateID(SessionHelper.getCandidate(request).getCandidateID());
					candidateAnswer.setCandidateExamItemID(examViewModel.getCandidateItemAssociation().getCandidateSubItemAssociations().get(index).getCandidateExamItemID());
					candidateAnswer.setFkCandidateExamID(SessionHelper.getExamPaperSetting(request).getCandidateExamID());
					candidateAnswer.setFkExamEventID(SessionHelper.getExamEvent(request).getExamEventID());
					// candidateAnswer.setOptionID(optionSingleCorrect.getOptionLanguage().getOption().getOptionID());
					answers.add(candidateAnswer);
					//	}

				} else {
					int outterCount = 0;
					int innerCount = 0;
					boolean Insertflag = false;
					for (OptionSubItem optionSubItem : subItem.getOptionList()) {
						for (CandidateAnswer candidateAnswer : candidateAnswers) {
							if (candidateAnswer.getOptionID() == optionSubItem.getOptionLanguage().getOption().getOptionID()) {
								//answers.add(outterCount, candidateAnswer);
								answers.add(candidateAnswer);
								Insertflag = true;
								break;
							}
							//innerCount++;
						}
						//if (!Insertflag) {
						//CandidateAnswer candidateAnswer = new CandidateAnswer();
						//candidateAnswer.setFkItemID(subItem.getItemLanguage().getItem().getItemID());
						//candidateAnswer.setFkParentItemID(examViewModel.getCandidateItemAssociation().getFkItemID());
						//candidateAnswer.setFkcandidateID(SessionHelper.getCandidate(request).getCandidateID());
						//candidateAnswer.setCandidateExamItemID(examViewModel.getCandidateItemAssociation().getCandidateSubItemAssociations().get(index).getCandidateExamItemID());
						//candidateAnswer.setFkCandidateExamID(SessionHelper.getExamPaperSetting(request).getCandidateExamID());
						//candidateAnswer.setFkExamEventID(SessionHelper.getExamEvent(request).getExamEventID());
						// candidateAnswer.setOptionID(optionSingleCorrect.getOptionLanguage().getOption().getOptionID());
						//answers.add(outterCount, candidateAnswer);
						//}
						Insertflag = false;
						//outterCount++;
					}
				}
				examViewModel.getCandidateItemAssociation().getCandidateSubItemAssociations().get(index++).setCandidateAnswers(answers);
			}
		}
		catch(Exception e)
		{
			throw e;
		}
	}

	/**
	 * Method for Mix Sub-Item Options for Match the Pair
	 * @param examViewModel
	 */
	private void mixSubItemOptionsforMatchhePair(ExamViewModel examViewModel) {
		List<OptionSubItem> mixOptionSubItems = null;
		for (MatchingPairs matchingPairs : examViewModel.getMatchingPairsList()) {
			mixOptionSubItems = new ArrayList<OptionSubItem>();
			//create list of all option
			for (SubItem subItem : matchingPairs.getSubItemList()) {
				mixOptionSubItems.addAll(subItem.getOptionList());
			}
			//shuffle the list
			Collections.shuffle(mixOptionSubItems);
			//set list of mix options
			for (SubItem subItem : matchingPairs.getSubItemList()) {
				subItem.setOptionList(mixOptionSubItems);
			}
			mixOptionSubItems = null;
		}
	}

	/**
	 * This private method will create Key which will be required 
	 * to get marks_per_item through MAP<key,value> which is present in Session
	 * @param request
	 * @param difficultyLevel
	 * @param itemBankID
	 * @return String this returns the key
	 * @throws OESException 
	 */
	public String createReqMarkingSchemeKey(HttpServletRequest request,String difficultyLevel,String itemBankGroupID,String itemID) throws OESException{
		MarkingScheme markingScheme=SessionHelper.getExamPaperSetting(request).getMarkingScheme();
		if(markingScheme==MarkingScheme.PaperWise){
			return Long.toString(SessionHelper.getExamPaperSetting(request).getPaperID());

		}else if(markingScheme==MarkingScheme.DifficultyLevelWise){
			return String.valueOf(DifficultyLevel.valueOf(difficultyLevel).ordinal());

		}else if(markingScheme==MarkingScheme.ItemBankGroupDifficultyLevelWise){
			return String.valueOf(itemBankGroupID+"|"+DifficultyLevel.valueOf(difficultyLevel).ordinal());

		}else if(markingScheme==MarkingScheme.ItemWise){
			return itemID;

		}
		return null;
	}

	/**
	 * Method to Generate and Validate Test
	 * @param response
	 * @param model
	 * @param request
	 * @param session
	 * @param locale
	 * @return String this returns the path of a view
	 * @throws Exception
	 */
	public String GenrateAndValidateTest(HttpServletResponse response, Model model, HttpServletRequest request, HttpSession session, Locale locale) throws Exception {
		try {
			//Code For dynamic logo render:13-july-2015:Yograjs
			model.addAttribute("clientid", AppInfoHelper.appInfo.getClientID());			
			model.addAttribute("isCopyRightEnabled", AppInfoHelper.appInfo.getIsCopyRightEnabled());			
			model.addAttribute("evurl", AppInfoHelper.appInfo.getEvidenceURL());
			model.addAttribute("wspoint", AppInfoHelper.appInfo.getWsPoint());
			model.addAttribute("isDarkModeOn", request.getParameter("isDarkModeOn"));
			model.addAttribute(SDT, new Date()); // This time used for server clock and evidence date time set
			Candidate candidate = SessionHelper.getCandidate(request);
			if (candidate == null) {
				return "Common/Exam/SessionOut";
			}
			long candidateExamID = Long.parseLong(request.getParameter("ceid"));
			long scheduleEnd = 0l;
			if(request.getParameter("se")!=null && !request.getParameter("se").isEmpty())
			{
				scheduleEnd = Long.parseLong(request.getParameter("se"));
			}
			long dcid=0l;			
			Boolean createCandidateAttemptDetails=null;
			if(request.getParameter("dcid")!=null && !request.getParameter("dcid").isEmpty())
			{
				dcid = Long.parseLong(request.getParameter("dcid"));
			}
			if(request.getParameter("b")!=null && !request.getParameter("b").isEmpty())
			{
				createCandidateAttemptDetails = Boolean.parseBoolean(request.getParameter("b"));	
			}			

			String selectedLang=request.getParameter("language");
			CandidateExam candidateExam = (CandidateExam)SessionHelper.getVariable(CESessionVeriable, request);
			if (candidateExam != null) {
				// validate user authorized or not
				if ( ! candidate.getCandidateID().equals(candidateExam.getFkCandidateID())) {
					response.sendError(HttpServletResponse.SC_FORBIDDEN, "Requested exam is not authorized to logged in candidate");
					return null;
				}
			if (candidateExam.getIsExamCompleted()) {
				int result = candidateExamServiceImpl.resetCandidateExamIfPracticePaper(candidateExamID);
				if(result == 0)
				{
					LOGGER.error("Exception Occured while TakeTest:: Error in resetting practice paper.");
					model.addAttribute("error", "Error in checking paper data #001");	
					response.sendError(HttpServletResponse.SC_FORBIDDEN, "Error in checking paper data #001");
					return null;
				}
				else if(result==2)
				{
					return "redirect:../commonExam/alreadyAttempted";
				}
				}
				IExamEventConfigurationService examEventConfigurationService= new ExamEventConfigurationServiceImpl();
				ExamPaperSetting examPaperSetting = examEventConfigurationService.getExamEventConfiguration(candidateExam.getFkExamEventID(), candidateExam.getFkPaperID());
				PaperServiceImpl paperServiceImpl = new PaperServiceImpl();
				Paper paper = paperServiceImpl.getpaperByPaperID(candidateExam.getFkPaperID());				
				boolean freePaperSettingApplies=true;
				if(dcid != 0l && candidateExamID != 0l)
				{
					SchedulePaperAssociationServicesImpl schedulePaperAssociationServicesImpl = new SchedulePaperAssociationServicesImpl();
					long scheduleId = schedulePaperAssociationServicesImpl.getTodaysScheduleIdByScheduleType(ScheduleType.Week,candidateExam.getFkExamEventID());
					//To check schedule is available or not if not then schedule is expired.
					if(scheduleId==0l)
					{
						schedulePaperAssociationServicesImpl=null;
						return "redirect:../commonExam/scheduleExpired";
					}
					ExamScheduleServiceImpl examScheduleServiceImpl = new ExamScheduleServiceImpl();					
					scheduleEnd = examScheduleServiceImpl.getScheduleMasterFromScheduleID(scheduleId).getScheduleEnd().getTime();
					examScheduleServiceImpl=null;
					SchedulePaperAssociation schedulePaperAssociation = new SchedulePaperAssociation();
					schedulePaperAssociation.setFkExamEventID(candidateExam.getFkExamEventID());
					schedulePaperAssociation.setFkPaperID(candidateExam.getFkPaperID());
					schedulePaperAssociation.setFkScheduleID(scheduleId);
					schedulePaperAssociation.setFkDisplayCategoryID(dcid);
					schedulePaperAssociation.setCreatedBy(SessionHelper.getLogedInUser(request).getUserName());
					schedulePaperAssociation.setDateCreated(new Date());
					schedulePaperAssociation.setScheduleExtension(0);
					schedulePaperAssociation.setAssessmentType(AssessmentType.Solo);
					schedulePaperAssociation.setFkCandidateID(candidate.getCandidateID());
					schedulePaperAssociation.setAttemptNo(candidateExam.getAttemptNo());
					schedulePaperAssociation.setFkCollectionID(SessionHelper.getCollectionID(request));

					freePaperSettingApplies = schedulePaperAssociationServicesImpl.saveSchedulePaperAssociation(schedulePaperAssociation, candidateExamID);
					BonusWeekServiceImpl bonusWeekServiceImpl =null;
					if(freePaperSettingApplies && createCandidateAttemptDetails!=null && createCandidateAttemptDetails.booleanValue() && paper.getPaperType() != PaperType.Combo)
					{
						bonusWeekServiceImpl = new BonusWeekServiceImpl();
						CandidateAttemptDetails candidateAttemptDetails = new CandidateAttemptDetails();
						candidateAttemptDetails.setFkCandidateID(candidate.getCandidateID());
						candidateAttemptDetails.setFkDisplayCategoryID(dcid);
						candidateAttemptDetails.setFkExamEventID(candidateExam.getFkExamEventID());
						candidateAttemptDetails.setFkScheduleID(scheduleId);
						candidateAttemptDetails.setNoofPapersAttempted(1);
						candidateAttemptDetails.setCreatedBy(SessionHelper.getLogedInUser(request).getUserName());
						candidateAttemptDetails.setDateCreated(new Date());

						freePaperSettingApplies = bonusWeekServiceImpl.createNewBonusWeek(candidateAttemptDetails);
					}
					else if(freePaperSettingApplies && createCandidateAttemptDetails!=null && !createCandidateAttemptDetails.booleanValue() && paper.getPaperType() != PaperType.Combo)
					{				
						bonusWeekServiceImpl = new BonusWeekServiceImpl();
						freePaperSettingApplies = bonusWeekServiceImpl.updatePprAttemptCount(candidate.getCandidateID(), candidateExam.getFkExamEventID(), scheduleId, dcid);					
					}	
					bonusWeekServiceImpl=null;
					schedulePaperAssociationServicesImpl=null;					
				}

				if(!freePaperSettingApplies)
				{
					LOGGER.error("Exception Occured either in schedule creation or saving/updating candidateAttemptDetails");
					model.addAttribute("error", "Error in creating schedule.");
					response.sendError(HttpServletResponse.SC_FORBIDDEN, "Error in creating schedule.");
					return null;
				}
				
				if(scheduleEnd <= 0)
				{
					model.addAttribute("error", "Paper schedule not found.");
					response.sendError(HttpServletResponse.SC_FORBIDDEN, "Paper schedule not found.");
					return null;
				}
					
				//check for schedule expiry
				if(!compareScheduleDateExpiry(scheduleEnd)){
					return "redirect:../commonExam/scheduleExpired";
				}
				
				List<Boolean> pullingRes = candidateExamServiceImpl.pullItemsForCandidateExam(SessionHelper.getCandidate(request).getCandidateID(), candidateExam.getFkExamEventID(), candidateExam.getFkPaperID(), candidateExam.getCandidateExamID(), selectedLang, examPaperSetting.getReplaceNotAttemptedQ());

				if (pullingRes.get(0)) 
				{
					candidateExam = candidateExamServiceImpl.getCandidateExamBycandidateExamID(candidateExam.getCandidateExamID());
					SessionHelper.addVariable(CESessionVeriable, candidateExam, session);
					
					if(pullingRes.get(1))
					{
						OESLogger.logExamActivity(SessionHelper.getLogedInUser(request), SessionHelper.getExamEvent(request).getExamEventID(), LogType.ItemReplaced, SessionHelper.getLoginType(request) ,candidateExam.getCandidateExamID() , 0,OESLogger.getHostAddress(request));
					}
					if(paper.getPaperType() == PaperType.Combo)
					{
						paper = paperServiceImpl.getpaperByPaperID(candidateExam.getFkPaperID());
					}
					paper.setSectionList(paperServiceImpl.getSectioncByPaperId(paper.getPaperID()));
					paperServiceImpl=null;
					long activeSec =0;
					long duration=0;
					for (Section sec : paper.getSectionList()) 
					{
						duration = duration + Long.parseLong(sec.getSectionDuration());
						if(sec.getIsTimeBound() && duration >= Long.parseLong(candidateExam.getElapsedTime()))
						{
							activeSec = sec.getSectionID();
							break;
						}
						else if(!sec.getIsTimeBound())
						{
							activeSec = sec.getSectionID();
							break;
						}
					}
					ExamEvent examEvent = new ExamEventServiceImpl().getExamEventByID(candidateExam.getFkExamEventID());					
					List<CandidateItemAssociation> candidateItemAssociations = candidateExamServiceImpl.getCandidateItemAssociationsByCandidateExamID(candidateExam.getCandidateExamID(),paper.getPaperID());
					InstructionTemplateViewModel instructions=candidateExamServiceImpl.getInstructionTemplatsByPaperIDandEventID(candidateExam.getFkPaperID(), candidateExam.getFkExamEventID());
					
					String updateElapsedTime = String.valueOf(AppInfoHelper.appInfo.getUpdateElapsedTimeinSec());
					if(updateElapsedTime==null)
					{
						updateElapsedTime = "60";
					}
					List<QuestionPaperPartialViewModel> questionPaperPartialViewModels = candidateExamServiceImpl.getAllItemByCandidateExamIDandCandidateID(candidateExam.getCandidateExamID(), SessionHelper.getCandidate(request).getCandidateID(), selectedLang,paper.getPaperID())
							.getQuestionPaperViewModels();					

					// Added By Yogeshg for Voice Recording
					String audioRecordingTimeInterval = MKCLUtility.loadMKCLPropertiesFile().getProperty("audioRecordingTimeInterval");
					if(audioRecordingTimeInterval==null)
					{
						audioRecordingTimeInterval = "120000";
					}
					
					String longAnswerAllowedFileTypes = MKCLUtility.loadMKCLPropertiesFile().getProperty("longAnswerAllowedFileTypes");
					String longAnswerMaxFileSize = MKCLUtility.loadMKCLPropertiesFile().getProperty("longAnswerMaxFileSize");
					String longAnswerMaxNoOfFilesAllowed = MKCLUtility.loadMKCLPropertiesFile().getProperty("longAnswerMaxNoOfFilesAllowed");
					
					String timeLeft = calculateElapsedTime(candidateExam, paper,scheduleEnd);
					model.addAttribute("candidate", SessionHelper.getLogedInUser(request));
					model.addAttribute("questionPaperPartialViewModels", questionPaperPartialViewModels);
					model.addAttribute("timeLeft", timeLeft);
					model.addAttribute("candidateExam", candidateExam);
					model.addAttribute("candidateItemAssociations", candidateItemAssociations);
					model.addAttribute("examEvent", examEvent);
					model.addAttribute("paper", paper);
					model.addAttribute("instructions", instructions);
					model.addAttribute("updateElapsedTime", updateElapsedTime);
					model.addAttribute("selectedLang", selectedLang);
					model.addAttribute("jsTime", session.getId());
					model.addAttribute("jsTime1", new Date().getTime());
					model.addAttribute("ec", candidateExamServiceImpl.getExamCenterVenue(candidateExam.getFkCandidateID(), candidateExam.getFkExamEventID()));
					model.addAttribute("examClientConfig", new ExamClientServiceImpl().getConfiguration(examEvent.getExamEventID()));
					model.addAttribute("uid", URLEncoder.encode(AESHelperExtended.encryptAsRandom(String.valueOf(candidateExam.getCandidateExamID()), EncryptionHelper.encryptDecryptKey), "UTF-8"));
					model.addAttribute("room", String.format("%s_%s", examEvent.getExamEventID(), paper.getPaperID()).hashCode());
					model.addAttribute("audioRecordingTimeInterval", audioRecordingTimeInterval);
					model.addAttribute("longAnswerAllowedFileTypes", longAnswerAllowedFileTypes);
					model.addAttribute("longAnswerMaxFileSize", longAnswerMaxFileSize);
					model.addAttribute("longAnswerMaxNoOfFilesAllowed", longAnswerMaxNoOfFilesAllowed);
					model.addAttribute("partnerId",MKCLUtility.loadMKCLPropertiesFile().getProperty("partnerId"));
					String imgrelativePath = FileUploadHelper.getRelativeFolderPath(request, "UserPhotoUploadPath");

					/*
					 * start By harshadd
					 */
					
					//examPaperSetting.setMarksPerItem(candidateExamServiceImpl.getPerItemMarksByPaperId(Long.parseLong(paperID)));
					examPaperSetting.setMarks(examEventConfigurationService.getMarksFromMarkingScheme(candidateExam.getFkPaperID(), examPaperSetting.getMarkingScheme()));
					examPaperSetting.setCandidateExamID(candidateExamID);
					examPaperSetting.setPaperID(candidateExam.getFkPaperID());
					examPaperSetting.setAttemptNo(candidateExam.getAttemptNo());	

					//set ExamCenterID
					//from ExamCenterSupervisorAssociation
					examPaperSetting.setExamCenterID(candidateExamServiceImpl.getExamCenterVenue(candidateExam.getFkCandidateID(), candidateExam.getFkExamEventID()).getExamVenueID());

					//if(examPaperSetting.getIsNegativeMarking())
					//{
					//examPaperSetting.setNegativeMarks(candidateExamServiceImpl.getNagetiveMarksPerItemByPaperIdAndEventID(Long.parseLong(examEventID), Long.parseLong(paperID),examPaperSetting.getMarksPerItem()));
					//}
					examPaperSetting.setIncludesSubItems(paper.getIncludesSubItems());
					SessionHelper.setExamPaperSetting(session, examPaperSetting);					
					/*
					 * end by harshadd
					 */

					model.addAttribute("activeSec", activeSec);
					model.addAttribute("imgPath", imgrelativePath);
					//Piyusha
					model.addAttribute("screenshotResolution", AppInfoHelper.appInfo.getScreenshotResolution());
					model.addAttribute("showMultiFaceNoFacePopup", AppInfoHelper.appInfo.getShowMultiFaceNoFacePopup());
					
					response.setCharacterEncoding("UTF-8");
					if(paper.getPaperType()==PaperType.DifficultyLevelWiseExam)
					{
						List<MSCITViewModel> difficultyLevelWiseCountList=new MSCITServiceImpl().getdifficultylevelwiseCount(candidateExamID, 0);
						model.addAttribute("difficultyLevelWiseCount",difficultyLevelWiseCountList);					

						return "Solo/MSCITExam/mscitTakeTest";

					}
					else
					{
						return "Solo/Exam/TakeTest";
					}


				} else {
					LOGGER.error("Exception Occured while TakeTest:: Error in Pulling Data");
					model.addAttribute("error", "Error in Pulling Data");
					response.sendError(HttpServletResponse.SC_FORBIDDEN, "Error in Pulling Data");
				}
			} else {
				LOGGER.error("Exception Occured while TakeTest:: Cadidate Exam Not Found");
				model.addAttribute("error", "Cadidate Exam Not Found");
				response.sendError(HttpServletResponse.SC_FORBIDDEN, "Cadidate Exam Not Found");
			}
		} catch (Exception e) {
			LOGGER.error("Exception Occured while TakeTest: ", e);
			model.addAttribute("error", e);	
			response.sendError(HttpServletResponse.SC_FORBIDDEN, e.getMessage());	
		}		
		return null;
	}

	/**
	 * Method to fetch Candidate Answer List for MTCSQ Questions
	 * @param request
	 * @param examViewModel
	 * @param candidateAnswers
	 * @return List<CandidateAnswer> this returns the CandidateAnswerList
	 * @throws Exception
	 */
	private List<CandidateAnswer> getCandidateAnswerForMTCSQ(HttpServletRequest request, ExamViewModel examViewModel, List<CandidateAnswer> candidateAnswers) throws Exception {
		List<CandidateAnswer> answers = new ArrayList<CandidateAnswer>();
		try 
		{
			if (candidateAnswers == null || candidateAnswers.size() == 0) {
				candidateAnswers = new ArrayList<CandidateAnswer>();
				CandidateAnswer candidateAnswer = new CandidateAnswer();
				candidateAnswer.setFkItemID(examViewModel.getCandidateItemAssociation().getFkItemID());
				candidateAnswer.setFkcandidateID(SessionHelper.getCandidate(request).getCandidateID());
				candidateAnswer.setCandidateExamItemID(examViewModel.getCandidateItemAssociation().getCandidateExamItemID());
				candidateAnswer.setFkCandidateExamID(SessionHelper.getExamPaperSetting(request).getCandidateExamID());
				candidateAnswer.setFkExamEventID(SessionHelper.getExamEvent(request).getExamEventID());				
				// candidateAnswer.setOptionID(optionSingleCorrect.getOptionLanguage().getOption().getOptionID());
				answers.add(candidateAnswer);

			}  
			else 
			{
				answers.add(candidateAnswers.get(0));

			}
			return answers;
		}
		catch(Exception e)
		{
			throw e;			
		}
	}
	
	/**
	 * Method to fetch Candidate Answer List for Essay Writing Questions
	 * @param request
	 * @param examViewModel
	 * @param candidateAnswers
	 * @return List<CandidateAnswer> this returns the CandidateAnswerList
	 * @throws Exception
	 */
	private List<CandidateAnswer> getCandidateAnswerForEW(HttpServletRequest request, ExamViewModel examViewModel, List<CandidateAnswer> candidateAnswers) throws Exception {
		List<CandidateAnswer> answers = new ArrayList<CandidateAnswer>();
		try 
		{
			if (candidateAnswers == null || candidateAnswers.size() == 0)
			{
				candidateAnswers = new ArrayList<CandidateAnswer>();
				CandidateAnswer candidateAnswer = new CandidateAnswer();
				candidateAnswer.setFkItemID(examViewModel.getCandidateItemAssociation().getFkItemID());
				candidateAnswer.setFkcandidateID(SessionHelper.getCandidate(request).getCandidateID());
				candidateAnswer.setCandidateExamItemID(examViewModel.getCandidateItemAssociation().getCandidateExamItemID());
				candidateAnswer.setFkCandidateExamID(SessionHelper.getExamPaperSetting(request).getCandidateExamID());
				candidateAnswer.setFkExamEventID(SessionHelper.getExamEvent(request).getExamEventID());				
				answers.add(candidateAnswer);
			}  
			else 
			{
				answers.add(candidateAnswers.get(0));

			}
			return answers;
		}
		catch(Exception e)
		{
			throw e;			
		}
	}
	
	/**
	 * Method to fetch Candidate Answer List for Hot Spot Questions
	 * @param request
	 * @param examViewModel
	 * @param candidateAnswers
	 * @return List<CandidateAnswer> this returns the CandidateAnswerList
	 * @throws Exception
	 */
	private List<CandidateAnswer> getCandidateAnswerForHS(HttpServletRequest request, ExamViewModel examViewModel, List<CandidateAnswer> candidateAnswers) throws Exception {
		List<CandidateAnswer> answers = new ArrayList<CandidateAnswer>();
		try
		{
			if (candidateAnswers == null || candidateAnswers.size() == 0) {
				candidateAnswers = new ArrayList<CandidateAnswer>();
				for (int i=0; i< examViewModel.getHotSpotList().get(0).getOptionList().size(); i++) {
					CandidateAnswer candidateAnswer = new CandidateAnswer();
					candidateAnswer.setFkItemID(examViewModel.getCandidateItemAssociation().getFkItemID());
					candidateAnswer.setFkcandidateID(SessionHelper.getCandidate(request).getCandidateID());
					candidateAnswer.setCandidateExamItemID(examViewModel.getCandidateItemAssociation().getCandidateExamItemID());
					candidateAnswer.setFkCandidateExamID(SessionHelper.getExamPaperSetting(request).getCandidateExamID());
					candidateAnswer.setFkExamEventID(SessionHelper.getExamEvent(request).getExamEventID());
					// candidateAnswer.setOptionID(optionSingleCorrect.getOptionLanguage().getOption().getOptionID());
					answers.add(candidateAnswer);
				}
			} 
			else 
			{
				for (int i=0; i< examViewModel.getHotSpotList().get(0).getOptionList().size(); i++) 
				{
					if (i<candidateAnswers.size() && candidateAnswers.get(i).getCandidateTopLeftCoordinate() + candidateAnswers.get(i).getCandidateTopRightCoordinate() > 0) 
					{
						answers.add(i, candidateAnswers.get(i));
					}
					else
					{
						CandidateAnswer candidateAnswer = new CandidateAnswer();
						candidateAnswer.setFkItemID(examViewModel.getCandidateItemAssociation().getFkItemID());
						candidateAnswer.setFkcandidateID(SessionHelper.getCandidate(request).getCandidateID());
						candidateAnswer.setCandidateExamItemID(examViewModel.getCandidateItemAssociation().getCandidateExamItemID());
						candidateAnswer.setFkCandidateExamID(SessionHelper.getExamPaperSetting(request).getCandidateExamID());
						candidateAnswer.setFkExamEventID(SessionHelper.getExamEvent(request).getExamEventID());
						// candidateAnswer.setOptionID(optionSingleCorrect.getOptionLanguage().getOption().getOptionID());
						answers.add(i, candidateAnswer);
					}
				}
			}
			return answers;
		}
		catch(Exception e)
		{
			throw e;
		}
	}
	
	/**
	 * Method to fetch Candidate Answer List for Word Count Questions
	 * @param request
	 * @param examViewModel
	 * @param candidateAnswers
	 * @return List<CandidateAnswer> this returns the CandidateAnswerList
	 * @throws Exception
	 */
	private List<CandidateAnswer> getCandidateAnswerForWC(HttpServletRequest request, ExamViewModel examViewModel, List<CandidateAnswer> candidateAnswers) throws Exception {
		List<CandidateAnswer> answers = new ArrayList<CandidateAnswer>();
		try 
		{
			if (candidateAnswers == null || candidateAnswers.size() == 0) {
				candidateAnswers = new ArrayList<CandidateAnswer>();
				CandidateAnswer candidateAnswer = new CandidateAnswer();
				candidateAnswer.setFkItemID(examViewModel.getCandidateItemAssociation().getFkItemID());
				candidateAnswer.setFkcandidateID(SessionHelper.getCandidate(request).getCandidateID());
				candidateAnswer.setCandidateExamItemID(examViewModel.getCandidateItemAssociation().getCandidateExamItemID());
				candidateAnswer.setFkCandidateExamID(SessionHelper.getExamPaperSetting(request).getCandidateExamID());
				candidateAnswer.setFkExamEventID(SessionHelper.getExamEvent(request).getExamEventID());				
				answers.add(candidateAnswer);

			}  
			else 
			{
				answers.add(candidateAnswers.get(0));

			}
			return answers;
		}
		catch(Exception e)
		{
			throw e;			
		}
	}
	
	/**
	 * Method to fetch Candidate Answer List for Practical Questions
	 * @param request
	 * @param examViewModel
	 * @param candidateAnswers
	 * @return List<CandidateAnswer> this returns the CandidateAnswerList
	 * @throws Exception
	 */
	private List<CandidateAnswer> getCandidateAnswerForPRT(HttpServletRequest request, ExamViewModel examViewModel) throws Exception {
		List<CandidateAnswer> answers = new ArrayList<CandidateAnswer>();
		try
		{
			CandidateAnswer candidateAnswer = new CandidateAnswer();
			candidateAnswer.setFkItemID(examViewModel.getCandidateItemAssociation().getFkItemID());
			candidateAnswer.setFkcandidateID(SessionHelper.getCandidate(request).getCandidateID());
			candidateAnswer.setCandidateExamItemID(examViewModel.getCandidateItemAssociation().getCandidateExamItemID());
			candidateAnswer.setFkCandidateExamID(SessionHelper.getExamPaperSetting(request).getCandidateExamID());
			candidateAnswer.setFkExamEventID(SessionHelper.getExamEvent(request).getExamEventID());
			// candidateAnswer.setOptionID(optionSingleCorrect.getOptionLanguage().getOption().getOptionID());
			answers.add(candidateAnswer);
			return answers;
		}
		catch(Exception e)
		{
			throw e;
		}
	}	
	
	/**
	 * Get method for Candidate Comprehension Sub-Questions Association List
	 * @param parentItemId
	 * @param ceid
	 * @param request
	 * @return ResponseEntity<List<CandidateItemAssociation>> this returns the CandidateItemAssociationList along with http response status
	 */
	@RequestMapping(value = { "/cmpsmqtsub/{parentItemId}/{ceid}" }, method = RequestMethod.GET)
	public ResponseEntity<List<CandidateItemAssociation>> cmpsmqtsub(@PathVariable long parentItemId, @PathVariable long ceid, HttpServletRequest request)
	{
		List<CandidateItemAssociation> itemAssociations = new ArrayList<>();
		try 
		{
			itemAssociations = candidateExamServiceImpl.getCandidateSubItemAssoListByParentItemId(parentItemId, ceid);
			return new ResponseEntity<>(itemAssociations,HttpStatus.OK);
		} 
		catch (Exception e) 
		{
			LOGGER.error("Exception Occured while fetching sub question:", e);
			itemAssociations.clear();
			return new ResponseEntity<>(itemAssociations,HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}
	
	private List<CandidateAnswer> getCandidateAnswerForNFIB(HttpServletRequest request, ExamViewModel examViewModel, List<CandidateAnswer> candidateAnswers) throws Exception {
		List<CandidateAnswer> answers = new ArrayList<CandidateAnswer>();
		try
		{
			if (candidateAnswers == null || candidateAnswers.size() == 0) {
				candidateAnswers = new ArrayList<CandidateAnswer>();
				CandidateAnswer candidateAnswer = new CandidateAnswer();
				candidateAnswer.setFkItemID(examViewModel.getCandidateItemAssociation().getFkItemID());
				candidateAnswer.setFkcandidateID(SessionHelper.getCandidate(request).getCandidateID());
				candidateAnswer.setCandidateExamItemID(examViewModel.getCandidateItemAssociation().getCandidateExamItemID());
				candidateAnswer.setFkCandidateExamID(SessionHelper.getExamPaperSetting(request).getCandidateExamID());
				candidateAnswer.setFkExamEventID(SessionHelper.getExamEvent(request).getExamEventID());				
				answers.add(candidateAnswer);

			}  
			else 
			{
				answers.add(candidateAnswers.get(0));
			}
			
			return answers;
			    
		}
		catch(Exception e)
		{
			throw e;
		}
	}
	
	private String loadNFIBItemText(ExamViewModel examViewModel) throws JsonMappingException, JsonProcessingException {
		List<FillInBlanksDetailsViewModel> list = null;
		StringBuilder sb = null;
		String itemText = examViewModel.getNewFillInBlanksList().get(0).getItemText();
		boolean isAns = examViewModel.getCandidateItemAssociation().getItemStatus() == ItemStatus.Answered || examViewModel.getCandidateItemAssociation().getItemStatus() == ItemStatus.PartiallyAnswered;
		
		if(isAns) {
			list = new ObjectMapper().readValue(examViewModel.getCandidateItemAssociation().getCandidateAnswers().get(0).getTypedText(),TypeFactory.defaultInstance().constructCollectionType(List.class,FillInBlanksDetailsViewModel.class));
			list.sort(Comparator.comparingInt(FillInBlanksDetailsViewModel::getBlankSequence));
		}
		
		for(int i=0; i < examViewModel.getNewFillInBlanksList().get(0).getNumberOfBlanks(); i++) {
			sb= new StringBuilder();
			if(isAns) {
				sb.append("<input type='text' name='newFillInBlanks.fillInBlanksDetailsViewModels["+i+"].blankText' value='"+list.get(i).getBlankText()+"' class='nfib-typedText' id='optionsAns"+(i+1)+"' autoComplete='off' autoCorrect='off' onpaste='return false;' onselectstart='return false' autoCapitalize='off' spellCheck='false' /> ");
			}else {
				sb.append("<input type='text' name='newFillInBlanks.fillInBlanksDetailsViewModels["+i+"].blankText' value='' class='nfib-typedText' id='optionsAns"+(i+1)+"' autoComplete='off' autoCorrect='off' onpaste='return false;' onselectstart='return false' autoCapitalize='off' spellCheck='false' /> ");
			}
			
			sb.append("<input name='newFillInBlanks.fillInBlanksDetailsViewModels["+i+"].blankSequence' type='hidden' value='"+(i+1)+"'>");
			itemText = itemText.replaceAll("\\["+(i+1)+"\\]", sb.toString());
		}
		return itemText;
	}
	
	@PostMapping("/saveReportedItem")
	@ResponseBody
    public boolean saveReportedItem(@RequestBody ReportItem reportedItem) {
		boolean result = false;
		try {			
			result = candidateExamServiceImpl.saveReportedItem(reportedItem);
		}
		catch(Exception e)
		{
			LOGGER.error("Exception occured in saveReportedItem: ", e);
		}        
        return result;		
    }
	
}
