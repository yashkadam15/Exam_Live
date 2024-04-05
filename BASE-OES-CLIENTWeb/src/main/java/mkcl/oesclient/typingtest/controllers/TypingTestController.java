package mkcl.oesclient.typingtest.controllers;
/**
 * Author Reena
 */

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mkcl.oes.commons.SmartTags;
import mkcl.oesclient.admin.services.ExamScheduleServiceImpl;
import mkcl.oesclient.commons.services.ExamEventServiceImpl;
import mkcl.oesclient.commons.services.PaperServiceImpl;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.commons.utilities.SmartTagHelper;
import mkcl.oesclient.model.CandidateAttemptDetails;
import mkcl.oesclient.model.CandidateExam;
import mkcl.oesclient.solo.controllers.ExamController;
import mkcl.oesclient.solo.services.BonusWeekServiceImpl;
import mkcl.oesclient.solo.services.CandidateExamServiceImpl;
import mkcl.oesclient.solo.services.SchedulePaperAssociationServicesImpl;
import mkcl.oesclient.typingtest.services.TypingTestService;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.oesclient.viewmodel.InstructionTemplateViewModel;
import mkcl.oesclient.viewmodel.TypingTestViewModel;
import mkcl.oespcs.model.AssessmentType;
import mkcl.oespcs.model.ExamEventPaperDetails;
import mkcl.oespcs.model.ExamType;
import mkcl.oespcs.model.MediumOfPaper;
import mkcl.oespcs.model.Paper;
import mkcl.oespcs.model.PaperType;
import mkcl.oespcs.model.SchedulePaperAssociation;
import mkcl.oespcs.model.ScheduleType;

import org.apache.commons.lang.StringEscapeUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("typingtest")
public class TypingTestController {
	private static final Logger LOGGER = LoggerFactory.getLogger(TypingTestController.class);
	
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

	/**
	 * Post method for Exam Instructions
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = { "/getExamInstructions" }, method = RequestMethod.POST)
	public void getExamInstructions(HttpServletRequest request, HttpServletResponse response) {
	
		InstructionTemplateViewModel instructions=new InstructionTemplateViewModel();
		List<MediumOfPaper> mList= new ArrayList<MediumOfPaper>();
		try {	
			
			String candidateExamID=request.getParameter("ceid");			
			TypingTestService testService=new TypingTestService();
			//instructions=testService.getInstructionByCandidateExamID(Long.parseLong(candidateExamID));
			instructions=testService.getTypingInstructionTemplatsByExamID(Long.parseLong(candidateExamID));
			if(instructions!=null)
			{
				//to-do call common replace
				Map<String, String> tagValueMap=new HashMap<String, String>();
				tagValueMap.put(SmartTags.TOTAL_MARKS, instructions.getPaperMarks());
				tagValueMap.put(SmartTags.TOTAL_QUESTION, instructions.getTotalItems());
				tagValueMap.put(SmartTags.TOTAL_DURATION, instructions.getDuration());
				if(instructions.getIntructionText()!=null && !instructions.getIntructionText().isEmpty())
				{
					instructions.setIntructionText(SmartTagHelper.replaceTagWithValue(tagValueMap,instructions.getIntructionText()));
				}
				if(instructions.getImportantInstructions()!=null && !instructions.getImportantInstructions().isEmpty())
				{
					instructions.setImportantInstructions(SmartTagHelper.replaceTagWithValue(tagValueMap,instructions.getImportantInstructions()));
				}
			}
			
			CandidateExamServiceImpl candidateExamServiceImpl= new CandidateExamServiceImpl();
			CandidateExam candidateExam=candidateExamServiceImpl.getCandidateExamBycandidateExamID(Long.parseLong(candidateExamID));
			if(candidateExam!=null)
			{
			 mList= candidateExamServiceImpl.getLanguageListByPaperID(candidateExam.getFkPaperID());
			}			
			
			StringBuilder sb= new StringBuilder();
			sb.append("<instrcutionset>");
			if(instructions!=null)
			{
			sb.append("<instrcution>");
			sb.append("<imp_instr>"+StringEscapeUtils.escapeHtml(instructions.getIntructionText())+"</imp_instr>");
			sb.append("<other_imp_instr>"+StringEscapeUtils.escapeHtml(instructions.getImportantInstructions())+"</other_imp_instr>");
			sb.append("<discl_text>"+StringEscapeUtils.escapeHtml(instructions.getDisclaimerText())+"</discl_text>");
			sb.append("</instrcution>");			
			}
			if(mList!=null && mList.size()!=0)
			{
			sb.append("<languageList>");
			for (MediumOfPaper mediumOfPaper : mList) {
				sb.append("<language>");
				sb.append("<id>"+mediumOfPaper.getLanguage().getId()+"</id>");
				sb.append("<name><![CDATA["+mediumOfPaper.getLanguage().getLanguageName()+"]]></name>");
				sb.append("</language>");				
			}				
			sb.append("</languageList>");
			}
			sb.append("</instrcutionset>");		
			response.getWriter().write(sb.toString());	
			
		} catch (Exception ex) {
			LOGGER.error("Exception occured in getExamInstructions: " , ex);	
			
		}

	}
	
	/**
	 * Post method to get Exam Font Details
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = { "getExamFontDetails" }, method = RequestMethod.POST)
	public void getExamFontDetails(HttpServletRequest request, HttpServletResponse response) {
		
		try {
			String candidateExamID=request.getParameter("ceid");
			TypingTestService testService=new TypingTestService();			
			String fontName=testService.getFontNameByCanExamID(Long.parseLong(candidateExamID));					
			response.getWriter().write(fontName);				
			
		} catch (Exception ex) {
			LOGGER.error("Exception occured in getExamFontDetails: " , ex);
		
		}

	}
	
	/**
	 * Post method to fetch the Typing Test Text
	 * @param request
	 * @param response
	 * @return String this returns either the typing test text or an error message returned 
	 */
	@RequestMapping(value = { "getTypingTestText" }, method = RequestMethod.POST,produces = "text/xml;charset=UTF-8")
	@ResponseBody
	public String getTypingTestText(HttpServletRequest request, HttpServletResponse response) {
		//GlobalVar.examId, GlobalVar.candId, GlobalVar.langId, GlobalVar.examStatus
		StringBuilder sb=new StringBuilder();
		String candidateID=null;
		try {
			if(request.getParameter("cid")==null)
			{
				//return "Common/Exam/SessionOut";
				sb=writeMessageCode(1);//SessionOut
				return sb.toString();
			}
			else
			{
				 candidateID=request.getParameter("cid");
			}
			
			String canUserName=request.getParameter("cun");
			
			long candidateExamID = Long.parseLong(request.getParameter("ceid"));
			long scheduleEnd = Long.parseLong(request.getParameter("se"));
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
			
			String selectedLang=request.getParameter("langId");
			
			
			TypingTestService testService=new TypingTestService();
			
			TypingTestViewModel testViewModel=testService.getTypingTestViewModelByCeID(candidateExamID);
			
			if(testViewModel!=null)
			{
				CandidateExam candidateExam = testViewModel.getCandidateExam();
				
				CandidateExamServiceImpl candidateExamServiceImpl = new CandidateExamServiceImpl();
				// added following first two conditions added by Yograj on 10-June-2016 for unlimited attempts for practice paper
				ExamEventPaperDetails examEventPaperDetails=new ExamEventServiceImpl().getExamEventPaperDetails(candidateExam.getFkExamEventID(),candidateExam.getFkPaperID());
								
				// validate user authorized or not
				CandidateExam sessionCandidateExam = (CandidateExam)SessionHelper.getVariable(ExamController.CESessionVeriable, request);
				if(examEventPaperDetails!=null && examEventPaperDetails.getExamType()==ExamType.Main && sessionCandidateExam!=null && sessionCandidateExam.getIsExamCompleted()) {
					//return "redirect:../commonExam/alreadyAttempted";
					sb=writeMessageCode(2);//alreadyAttempted
					return sb.toString();
					
				}
				
				
				if (candidateExam != null) {
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
						candidateExamServiceImpl=null;
						//return "redirect:../commonExam/scheduleExpired";
						sb=writeMessageCode(3);//scheduleExpired
						return sb.toString();
					}
					ExamScheduleServiceImpl examScheduleServiceImpl = new ExamScheduleServiceImpl();					
					scheduleEnd = examScheduleServiceImpl.getScheduleMasterFromScheduleID(scheduleId).getScheduleEnd().getTime();
					examScheduleServiceImpl=null;
					SchedulePaperAssociation schedulePaperAssociation = new SchedulePaperAssociation();
					schedulePaperAssociation.setFkExamEventID(candidateExam.getFkExamEventID());
					schedulePaperAssociation.setFkPaperID(candidateExam.getFkPaperID());
					schedulePaperAssociation.setFkScheduleID(scheduleId);
					schedulePaperAssociation.setFkDisplayCategoryID(dcid);
					schedulePaperAssociation.setCreatedBy(canUserName);
					schedulePaperAssociation.setDateCreated(new Date());
					schedulePaperAssociation.setScheduleExtension(0);
					schedulePaperAssociation.setAssessmentType(AssessmentType.Solo);
					schedulePaperAssociation.setFkCandidateID(Long.parseLong(candidateID));
					schedulePaperAssociation.setAttemptNo(candidateExam.getAttemptNo());
					schedulePaperAssociation.setFkCollectionID(testViewModel.getCollectionAssociation().getFkCollectionID());
					
					freePaperSettingApplies = schedulePaperAssociationServicesImpl.saveSchedulePaperAssociation(schedulePaperAssociation, candidateExamID);
					BonusWeekServiceImpl bonusWeekServiceImpl =null;
					/*added condition !SessionHelper.getIsLocalPartner() to skip saving for Local ERA partner 13-Apr-2017*/
					if(!SessionHelper.getIsLocalCandidate() && freePaperSettingApplies && createCandidateAttemptDetails!=null && createCandidateAttemptDetails.booleanValue() && paper.getPaperType() != PaperType.Combo)
					{
						bonusWeekServiceImpl = new BonusWeekServiceImpl();
						CandidateAttemptDetails candidateAttemptDetails = new CandidateAttemptDetails();
						candidateAttemptDetails.setFkCandidateID(Long.parseLong(candidateID));
						candidateAttemptDetails.setFkDisplayCategoryID(dcid);
						candidateAttemptDetails.setFkExamEventID(candidateExam.getFkExamEventID());
						candidateAttemptDetails.setFkScheduleID(scheduleId);
						candidateAttemptDetails.setNoofPapersAttempted(1);
						candidateAttemptDetails.setCreatedBy(canUserName);
						candidateAttemptDetails.setDateCreated(new Date());
						
						freePaperSettingApplies = bonusWeekServiceImpl.createNewBonusWeek(candidateAttemptDetails);
					}
					else if(!SessionHelper.getIsLocalCandidate() && freePaperSettingApplies && createCandidateAttemptDetails!=null && !createCandidateAttemptDetails.booleanValue() && paper.getPaperType() != PaperType.Combo)
					{				
						bonusWeekServiceImpl = new BonusWeekServiceImpl();
						freePaperSettingApplies = bonusWeekServiceImpl.updatePprAttemptCount(Long.parseLong(candidateID), candidateExam.getFkExamEventID(), scheduleId, dcid);					
					}						
					bonusWeekServiceImpl=null;
					schedulePaperAssociationServicesImpl=null;					
				}
				
				if(!freePaperSettingApplies)
				{
					LOGGER.error("Exception Occured either in schedule creation or saving/updating candidateAttemptDetails");
					sb=writeMessageCode(4);//Exception Occured either in schedule creation or saving/updating candidateAttemptDetails
					return sb.toString();
				}
				
				//check for schedule expiry
				if(!compareScheduleDateExpiry(scheduleEnd)){
					//return "redirect:../commonExam/scheduleExpired";     
					sb=writeMessageCode(3);//scheduleExpired
					return sb.toString();
				}
				// added by Yograj on 10-June-2016 for unlimited attempts for practice paper
				long attemptNo=candidateExam.getAttemptNo();
				if(candidateExam.getIsExamCompleted())
				{
					attemptNo=attemptNo+1;
				}
				// end added by Yograj on 10-June-2016 for unlimited attempts for practice paper
				candidateExam = testService.updateCadidateExamLang(candidateExamID,selectedLang,attemptNo);
				
				
				if (testService.pullItemsForCandidateExam(Long.parseLong(candidateID), candidateExam.getFkExamEventID(), candidateExam.getFkPaperID(), candidateExam.getCandidateExamID()))
				{
					TypingTestViewModel typingViewModel=testService.getParagraphText(candidateExamID,Long.parseLong(candidateID), candidateExam.getFkPaperID(), candidateExam.getCandidatePaperLanguage());
					//<MyString><![CDATA[<test>Hello World</test>]]></MyString>
					sb.append("<typingViewModel>");
					sb.append("<messagecode>"+0+"</messagecode>");
					// ISSUE ID : 66549
					//Modified on 07 Apr 2015 : URI length increases upto limit and Apache Server considering it BAD Request[400] after that in Typing Test application
					typingViewModel.setParagraphText(StringEscapeUtils.unescapeHtml(typingViewModel.getParagraphText()));
					sb.append("<paragraphText ><![CDATA["+typingViewModel.getParagraphText()+"]]></paragraphText>");
					sb.append("<itemID>"+typingViewModel.getCandidateItemAssociation().getFkItemID()+"</itemID>");
					sb.append("<candidateExamItemID>"+typingViewModel.getCandidateItemAssociation().getCandidateExamItemID()+"</candidateExamItemID>");
					sb.append("</typingViewModel>");
				}
			}
			}//End of if testViewModel not null
			//response.getWriter().write(sb.toString());
		} 
		catch (Exception ex) {
			LOGGER.error("Exception occured in getTypingTestText: " , ex);
		}
		return sb.toString();
	}
	

	/**
	 * Method to write Message Code
	 * @param i
	 * @return StringBuilder this returns the message code as formatted text
	 */
	private StringBuilder writeMessageCode(int i) {
		StringBuilder sb=new StringBuilder();
		sb.append("<typingViewModel>");
		sb.append("<messagecode>"+i+"</messagecode>");
		sb.append("</typingViewModel>");
		return sb;
	}

	/**
	 * Post method to Save Candidate Attempt
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = { "saveCandidateAttempt" }, method = RequestMethod.POST)
	public void saveCandidateAttemptDetails(HttpServletRequest request, HttpServletResponse response) {
		try {
			//GlobalVar.candId, GlobalVar.examId, totalDeleteCnt, accuracy, wrong_word_count, eText.Text, totalKeyStrokes, eText.Text.Length, totalIncorrectChar, netWPM, totalSec,examStatus
		/*	long candidateExamItemID,long candId, long canExamId,long itemID,long fkExamEventID,
			Integer totalDeleteCnt, Double accuracy, Integer wrong_word_count,String typedText, Integer totalKeyStrokes,
			Integer totalCharsTyped,Integer totalIncorrectChar, Double netWPM, Integer totalSec*/
			
			// ISSUE ID : 66549
			//Modified on 07 Apr 2015 : URI length increases upto limit and Apache Server considering it BAD Request[400] after that in Typing Test application
			
			String candidateID=request.getParameter("cid");
			String eventID=request.getParameter("eid");
			String candidateExamID=request.getParameter("ceid");
			String totalDeleteCnt=request.getParameter("totalDeleteCnt");
			String accuracy=request.getParameter("accuracy");
			String wrong_word_count=request.getParameter("wrong_word_count");
			/*String typedText=request.getParameter("eText");*/
			String totalKeyStrokes=request.getParameter("totalKeyStrokes");
			String totalCharsTyped=request.getParameter("eTextLength");
			String totalIncorrectChar=request.getParameter("totalIncorrectChar");
			String netWPM=request.getParameter("netWPM");
			
			//Start ::22 may 2017 : replace all decimal occurences with "." only for making valid Double number
			netWPM=netWPM.replaceAll("[^0-9\\.]",".").replaceAll("\\.+", ".");
			//end
			
			String totalSec=request.getParameter("totalSec");
			String itemID=request.getParameter("itemID");
			String candidateExamItemID=request.getParameter("candidateExamItemID");
			String examStatus=request.getParameter("examStatus");
			
			
			BufferedReader br = new BufferedReader(new InputStreamReader(
					(request.getInputStream())));
	 
			String streamStr;
			String typedText="";

			while ((streamStr = br.readLine()) != null) {
				typedText+=streamStr;
			}
			
			
			TypingTestService testService=new TypingTestService();
			
			//System.out.println("candidateExamItemID..."+candidateExamItemID+"totalDeleteCnt..."+totalDeleteCnt+"  Accuracy..."+accuracy+"  wron_word_count..."+wrong_word_count+"  typedText..."+typedText+"  totalKeyStrokes..."+totalKeyStrokes+"  totalCharsTyped..."+totalCharsTyped+" totalIncorrectChar..."+totalIncorrectChar+" netWPM..."+netWPM+" totalSec..."+totalSec);
			
			boolean saveFlag=testService.SaveOrDeleteCanAnswer(Long.parseLong(candidateExamItemID), Long.parseLong(candidateID), Long.parseLong(candidateExamID),Long.parseLong(itemID), Long.parseLong(eventID), 
			Integer.decode(totalDeleteCnt), Double.valueOf(accuracy), Integer.decode(wrong_word_count), typedText, 
			Integer.decode(totalKeyStrokes), Integer.decode(totalCharsTyped),Integer.decode(totalIncorrectChar), Double.valueOf(netWPM),Integer.decode(totalSec),Boolean.parseBoolean(examStatus));
			//System.out.println("Saving Flag..."+saveFlag);
		} catch (Exception ex) {
			LOGGER.error("Exception occured in saveCandidateAttemptDetails: " , ex);
		}

	}
	
	/**
	 * Post method to Update Exam Status
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = { "updateExamStatus" }, method = RequestMethod.POST)
	public void updateExamStatus(HttpServletRequest request, HttpServletResponse response) {
		try {
			
			String canUserName=request.getParameter("cun");
			String candidateExamID=request.getParameter("ceid");
			String netWPM=request.getParameter("netWPM");
			//Start ::22 may 2017 : replace all decimal occurences with "." only for making valid Double number
			netWPM=netWPM.replaceAll("[^0-9\\.]",".").replaceAll("\\.+", ".");
			//end
			String totSec=request.getParameter("totalSec");
			
			TypingTestService testService=new TypingTestService();
			testService.changeExamStatus(Long.parseLong(candidateExamID), netWPM, totSec, canUserName);
			
			
		} catch (Exception ex) {
			LOGGER.error("Exception occured in updateExamStatus: " , ex);
		}

	}
	
	/**
	 * Post method to fetch Result Data
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = { "/getResultData" }, method = RequestMethod.POST)
	public void getResultData(HttpServletRequest request, HttpServletResponse response) {
		List<String>resultDetails=null;
		try
		{
			String candidateExamID=request.getParameter("ceid");
			
			
			
			TypingTestService testService=new TypingTestService();
			resultDetails=testService.getResultDataByCanExamID(Long.parseLong(candidateExamID));
			StringBuilder sb= new StringBuilder();
			
			sb.append("<result>");
			sb.append("<net_speed>"+resultDetails.get(0)+"</net_speed>");
			sb.append("<accuracy>"+resultDetails.get(1)+"</accuracy>");
			sb.append("<wrong_words_count>"+resultDetails.get(2)+"</wrong_words_count>");
			sb.append("<TotCharsTyped>"+resultDetails.get(3)+"</TotCharsTyped>");
			
			double gross_speed=(Integer.decode(resultDetails.get(3))/5)/(Integer.decode(resultDetails.get(4))/60);
			
			sb.append("<gross_speed>"+gross_speed+"</gross_speed>");
			sb.append("</result>");
			response.getWriter().write(sb.toString());	
		}
		catch(Exception e)
		{
			LOGGER.error("Exception in getResultData...",e);
		}
	}
	
	/**
	 * Method to compare the Schedule Date Expiry
	 * @param scheduleEndDate
	 * @return boolean this returns true if the date is expired
	 */
	private boolean compareScheduleDateExpiry(long scheduleEndDate){
		if(scheduleEndDate!=0l){
			Date now=new Date();
			if(now.compareTo(new Date(scheduleEndDate))==-1){
				return true;
			}
		}
		return false;
	}


}

