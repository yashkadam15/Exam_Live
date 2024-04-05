package mkcl.oesclient.group.controllers;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Queue;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import mkcl.baseoesclient.model.UserColor;
import mkcl.oes.commons.EncryptionHelper;
import mkcl.oes.commons.SmartTags;
import mkcl.oesclient.admin.services.ExamScheduleServiceImpl;
import mkcl.oesclient.commons.controllers.ExamLocaleThemeResolver;
import mkcl.oesclient.commons.services.ExamEventConfigurationServiceImpl;
import mkcl.oesclient.commons.services.ExamEventServiceImpl;
import mkcl.oesclient.commons.services.ExamVenueActivationServicesImpl;
import mkcl.oesclient.commons.services.IExamEventConfigurationService;
import mkcl.oesclient.commons.services.PaperServiceImpl;
import mkcl.oesclient.commons.utilities.AppInfoHelper;
import mkcl.oesclient.commons.utilities.FileUploadHelper;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.commons.utilities.OESException;
import mkcl.oesclient.commons.utilities.SmartTagHelper;
import mkcl.oesclient.group.services.GroupCandidateExamServiceImpl;
import mkcl.oesclient.group.services.IGroupCandidateExamService;
import mkcl.oesclient.model.Candidate;
import mkcl.oesclient.model.CandidateAnswer;
import mkcl.oesclient.model.CandidateExam;
import mkcl.oesclient.model.CandidateItemAssociation;
import mkcl.oesclient.model.ConfidenceLevel;
import mkcl.oesclient.model.ItemStatus;
import mkcl.oesclient.model.VenueUser;
import mkcl.oesclient.solo.services.CandidateExamServiceImpl;
import mkcl.oesclient.solo.services.SchedulePaperAssociationServicesImpl;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.oesclient.viewmodel.ExamPaperSetting;
import mkcl.oesclient.viewmodel.ExamViewModel;
import mkcl.oesclient.viewmodel.InstructionTemplateViewModel;
import mkcl.oespcs.model.AssessmentType;
import mkcl.oespcs.model.ExamEvent;
import mkcl.oespcs.model.Instructions;
import mkcl.oespcs.model.MarkingScheme;
import mkcl.oespcs.model.MediumOfPaper;
import mkcl.oespcs.model.Paper;
import mkcl.oespcs.model.SchedulePaperAssociation;
import mkcl.oespcs.model.ScheduleType;
import mkcl.oesserver.model.DifficultyLevel;
import mkcl.oesserver.model.ItemType;
import mkcl.oesserver.model.MultimediaType;
import mkcl.oesserver.model.OptionMultipleCorrect;
import mkcl.oesserver.model.OptionPictureIdentification;
import mkcl.oesserver.model.OptionSingleCorrect;
import mkcl.oesserver.model.OptionSubItem;
import mkcl.oesserver.model.SubItem;
import mkcl.os.security.AESHelper;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * 
 * @author amoghs
 * 
 */
@Controller("GroupExamController")
@RequestMapping(value = "/groupExam")
public class ExamController {
	private static final Logger LOGGER = LoggerFactory.getLogger(ExamController.class);
	String selectedLang = "defaultLang";
	
	@Autowired
	private ExamLocaleThemeResolver examLocaleThemeResolver;

	/**
	 * Get method for Take Test
	 * @param response
	 * @param model
	 * @param request
	 * @param session
	 * @param locale
	 * @return String this returns the path of a view
	 * @throws IOException
	 */
	@RequestMapping(value = "/TakeTest", method = RequestMethod.GET)
	public String TakeTest(HttpServletResponse response, Model model, HttpServletRequest request, HttpSession session,Locale locale) throws IOException {
		try {
			
			//Code For dynamic logo render:13-july-2015:Yograjs
			model.addAttribute("clientid", AppInfoHelper.appInfo.getClientID());
			model.addAttribute("isCopyRightEnabled", AppInfoHelper.appInfo.getIsCopyRightEnabled());
			List<Candidate> candidates = SessionHelper.getCandidates(request);
			if (candidates == null || candidates.size() == 0) {
				return "Common/Exam/SessionOut";
			}
			
			String examEventID = request.getParameter("examEventID");
			String paperID = request.getParameter("paperID");
			String scheduleEnd = request.getParameter("scheduleEnd");
			String selectedLang=request.getParameter("languageID");
			IGroupCandidateExamService groupCandidateService = new GroupCandidateExamServiceImpl();
			if (groupCandidateService.isExamCompleated(candidates, Long.valueOf(examEventID), Long.parseLong(paperID))) {
				groupCandidateService=null;
				return "redirect:../commonExam/alreadyAttempted";
			}
			
			List<CandidateExam> candidateExams = groupCandidateService.updateCadidateExamsForFirstTime(candidates, Long.valueOf(examEventID), Long.valueOf(paperID));

			if((scheduleEnd==null || scheduleEnd.isEmpty()) && candidateExams!=null && candidateExams.size()>0)
			{
				PaperServiceImpl paperServiceImpl=new PaperServiceImpl();
				long displayCategoryId=paperServiceImpl.getDisplayCategoryIdFromEventIdPaperId(Long.valueOf(examEventID), Long.valueOf(paperID));
				paperServiceImpl=null;
				
				SchedulePaperAssociationServicesImpl schedulePaperAssociationServicesImpl = new SchedulePaperAssociationServicesImpl();
				long scheduleId = schedulePaperAssociationServicesImpl.getTodaysScheduleIdByScheduleType(ScheduleType.Day,Long.valueOf(examEventID));
				//To check schedule is available or not if not then schedule is expired.
				if(scheduleId==0l)
				{
					schedulePaperAssociationServicesImpl=null;
					return "redirect:../commonExam/scheduleExpired";
				}
				ExamScheduleServiceImpl examScheduleServiceImpl = new ExamScheduleServiceImpl();					
				scheduleEnd = String.valueOf(examScheduleServiceImpl.getScheduleMasterFromScheduleID(scheduleId).getScheduleEnd().getTime());
				examScheduleServiceImpl=null;
				
				for (CandidateExam candidateExam : candidateExams) 
				{
					SchedulePaperAssociation schedulePaperAssociation = new SchedulePaperAssociation();
					schedulePaperAssociation.setFkExamEventID(candidateExam.getFkExamEventID());
					schedulePaperAssociation.setFkPaperID(candidateExam.getFkPaperID());
					schedulePaperAssociation.setFkScheduleID(scheduleId);
					schedulePaperAssociation.setFkDisplayCategoryID(displayCategoryId);
					schedulePaperAssociation.setCreatedBy("CandID-"+candidateExam.getFkCandidateID());
					schedulePaperAssociation.setDateCreated(new Date());
					schedulePaperAssociation.setScheduleExtension(0);
					schedulePaperAssociation.setAssessmentType(AssessmentType.Group);
					schedulePaperAssociation.setFkCandidateID(candidateExam.getFkCandidateID());
					schedulePaperAssociation.setAttemptNo(candidateExam.getAttemptNo());
					schedulePaperAssociation.setFkCollectionID(SessionHelper.getCollectionID(request));
					
					if(!new ExamScheduleServiceImpl().deleteSchedulePaperAssociationByCandidateExamId(candidateExam.getCandidateExamID()) || !schedulePaperAssociationServicesImpl.saveSchedulePaperAssociation(schedulePaperAssociation, candidateExam.getCandidateExamID()))
					{
						schedulePaperAssociationServicesImpl=null;
						LOGGER.error("Unable to create schedule.");
						return "redirect:../commonExam/scheduleExpired";
					}
				}
			
			}
			
			//delete candidateItem Association and candidateAnswer if present
			if (candidateExams != null && candidateExams.size() > 0 && groupCandidateService.resetCandidateItemAssociation(candidateExams)) {
				if (groupCandidateService.pullItemsForCandidateExam(Long.valueOf(examEventID), Long.valueOf(paperID), candidateExams)) {
					
					PaperServiceImpl paperServiceImpl = new PaperServiceImpl();
					
					//get Default section
					//first section will be default section
					long activeSec = paperServiceImpl.getSectioncByPaperId(Long.valueOf(paperID)).get(0).getSectionID();
					
					// get candidate-CandidateExam Map
					Map<Long, Long> candidateExamMap = groupCandidateService.getCandidateExamIDsFromCandidates(candidates, Long.valueOf(examEventID), Long.valueOf(paperID));
					if (candidateExamMap != null) {
						// Creating Candidate Queue
						Queue<Entry<Long, Long>> candidateQueue = new LinkedList<Entry<Long, Long>>();
						candidateQueue.addAll(candidateExamMap.entrySet());
						ExamEvent examEvent = new ExamEventServiceImpl().getExamEventByID(Long.parseLong(examEventID));
						Paper paper = paperServiceImpl.getpaperByPaperID(Long.parseLong(paperID));
						String updateElapsedTime = MKCLUtility.loadMKCLPropertiesFile().getProperty("updateElapsedTimeinSec");
						if (updateElapsedTime == null) {
							updateElapsedTime = "60";
						}
						
						//check for schedule expiry
						Date now=new Date();
						if(!compareScheduleDateExpiry(now,scheduleEnd)){
							groupCandidateService=null;
							return "redirect:../commonExam/scheduleExpired";
						}
						
						String timeLeft = caculateElapsedTime(candidateExams.get(0), paper,now,scheduleEnd);
						model.addAttribute("timeLeft", timeLeft);
						model.addAttribute("candidateExam", candidateExams.get(0));
						model.addAttribute("examEvent", examEvent);
						model.addAttribute("paper", paper);
						model.addAttribute("updateElapsedTime", updateElapsedTime);
						String imgrelativePath = FileUploadHelper.getRelativeFolderPath(request, "UserPhotoUploadPath");
						model.addAttribute("imgPath", imgrelativePath);
						model.addAttribute("candidateExamMap", candidateExamMap);
						model.addAttribute("loggedInUsers", SessionHelper.getLogedInUsers(request));
						model.addAttribute("userColors", UserColor.values());
						model.addAttribute("selectedLang", selectedLang);
						model.addAttribute("activeSec", activeSec);
						model.addAttribute("jsTime", session.getId());
						
						
						/*
						 * start By harshadd
						 */
						IExamEventConfigurationService examEventConfigurationService= new ExamEventConfigurationServiceImpl();
						ExamPaperSetting examPaperSetting = examEventConfigurationService.getExamEventConfiguration(Long.parseLong(examEventID), Long.parseLong(paperID));
						//examPaperSetting.setMarksPerItem(groupCandidateService.getPerItemMarksByPaperId(Long.parseLong(paperID)));
						examPaperSetting.setMarks(examEventConfigurationService.getMarksFromMarkingScheme(Long.parseLong(paperID), examPaperSetting.getMarkingScheme()));
						examPaperSetting.setPaperID(paper.getPaperID());
						examPaperSetting.setAttemptNo(1);
						//if(examPaperSetting.getIsNegativeMarking())
						//{
							//examPaperSetting.setNegativeMarks(groupCandidateService.getNagetiveMarksPerItemByPaperIdAndEventID(Long.parseLong(examEventID), Long.parseLong(paperID),examPaperSetting.getMarksPerItem()));
						//}
						SessionHelper.setExamPaperSetting(session, examPaperSetting);	
						SessionHelper.setCandidateQueue(session, candidateQueue);
						/*
						 * end by harshadd
						 */

						response.setCharacterEncoding("UTF-8");
						model.addAttribute("GroupEndTest", MKCLUtility.getMessagefromKey(locale, "Exam.GroupEndTest"));
						model.addAttribute("SelectOption", MKCLUtility.getMessagefromKey(locale, "Exam.SelectOption"));
						model.addAttribute("SelectConfLevel", MKCLUtility.getMessagefromKey(locale, "Exam.SelectConfLevel"));						
						groupCandidateService=null;
						return "Group/groupExam/TakeTest";
					} else {
						LOGGER.error("Exception Occured while GroupTakeTest:: Error in Creating Candidate Queue");
						model.addAttribute("error", "Error in Creating Candidate Queue");
					}
				} else {
					LOGGER.error("Exception Occured while GroupTakeTest:: Error in Pulling Data");
					model.addAttribute("error", "Error in Group Pulling Data");
				}
			} else {
				LOGGER.error("Exception Occured while Group TakeTest:: Cadidate Exam Not Found");
				model.addAttribute("error", "Cadidate Exam Not Found");
			}
		} catch (Exception e) {
			LOGGER.error("Exception Occured while Group TakeTest: ", e);
			model.addAttribute("error", e);
		}
			response.sendError(HttpServletResponse.SC_FORBIDDEN, "Exception Occured while Group TakeTest: ");return null;
	}

	/**
	 * Method to Calculate Elapsed Time
	 * @param candidateExam
	 * @param paper
	 * @param now
	 * @param scheduleEnd
	 * @return String this returns the time left
	 */
	private String caculateElapsedTime(CandidateExam candidateExam, Paper paper,Date now,String scheduleEnd) {
		
		long diffInMiliSec = new Date(Long.parseLong(scheduleEnd)).getTime()-now.getTime();
		long diffInMin=((diffInMiliSec/1000)/60);
		long paperDuration=(Long.parseLong(paper.getDuration()) / 60);
		
		long sec = 0;
		long min = 0;
		//long exam_time = (Long.parseLong(paper.getDuration()) / 60);
		long exam_time=(paperDuration < diffInMin ) ? paperDuration : diffInMin;
		long cand_time = Long.parseLong(candidateExam.getElapsedTime());
		if (cand_time == 0) {
			sec = 60;
			min = exam_time;
		} else {
			sec = cand_time % 60;
			if (sec == 0) {
				if (exam_time - (cand_time / 60) > 0) {
					min = (exam_time - (cand_time / 60));
					sec = 60;
				} else {
					min = 0;
					sec = 60;
				}
			} else if (exam_time - (cand_time / 60) > 0) {
				min = (exam_time - (cand_time / 60) - 1);
			} else {
				min = 0;
				sec = 60;
			}
		}

		String timeLeft = min + ":" + (60 - sec);
		return timeLeft;
	}

	/**
	 * Get method for Question Container
	 * @param response
	 * @param model
	 * @param request
	 * @param session
	 * @return String this returns the path of a view
	 * @throws IOException
	 */
	@RequestMapping(value = "/QuestionContainer", method = RequestMethod.GET)
	public String QuestionContainer(HttpServletResponse response, Model model, HttpServletRequest request, HttpSession session) throws IOException {
		try {
			List<Object> attempterItemExamineeArray=null;
			if (!SessionHelper.getLoginStatus(request)) {
				return "Common/Exam/SessionOut";
			}
			String examEventID = request.getParameter("examEventID");
			String paperID = request.getParameter("paperID");
			String selectedLang=request.getParameter("selectedLang");
			String secID = request.getParameter("secID");
			List<Candidate> candidates = SessionHelper.getCandidates(request);
			
			IGroupCandidateExamService groupService = new GroupCandidateExamServiceImpl();
			if (groupService.isExamCompleated(candidates, Long.valueOf(examEventID), Long.parseLong(paperID))) {
				groupService=null;
				return "redirect:../commonExam/alreadyAttempted";
			}
			
			//get Examinee Selected option List
			List<Long> optionIDsList=null;
			String examineeSelOpIDs=request.getParameter("examineeSelOpIDs");
			if(examineeSelOpIDs!=null && !examineeSelOpIDs.isEmpty()){
				optionIDsList=new ArrayList<Long>();
				for (String optionID : examineeSelOpIDs.trim().split("\\s*,\\s*")) {
					optionIDsList.add(Long.parseLong(optionID));
				}
			}
		
			ExamViewModel examViewModel = null;
			long candidateExamID;
			List<CandidateAnswer> candidateAnswers = null;
			String imgrelativePath = FileUploadHelper.getRelativeFolderPath(request, "UserPhotoUploadPath");
			model.addAttribute("imgPath", imgrelativePath);
			if (request.getParameter("examineeCandidateID") != null && !request.getParameter("examineeCandidateID").isEmpty() && request.getParameter("itemID") != null && !request.getParameter("itemID").isEmpty()) {
				attempterItemExamineeArray = getItemExaminee(SessionHelper.getCandidateQueue(request), Long.parseLong(request.getParameter("examineeCandidateID")), Long.parseLong(request.getParameter("itemID")),Long.parseLong(paperID),secID);
				examViewModel = ((ExamViewModel)attempterItemExamineeArray.get(3));
				candidateExamID = examViewModel.getCandidateItemAssociation().getFkCandidateExamID();
			} else {
				attempterItemExamineeArray = getItemExaminee(SessionHelper.getCandidateQueue(request), 0l, 0l,Long.parseLong(paperID),secID);
				examViewModel = ((ExamViewModel)attempterItemExamineeArray.get(3));
				candidateExamID = examViewModel.getCandidateItemAssociation().getFkCandidateExamID();
			}
			// check & get if item is already solved
			if (examViewModel != null && examViewModel.getCandidateItemAssociation() != null && (examViewModel.getCandidateItemAssociation().getItemStatus() == ItemStatus.MarkedForReview || examViewModel.getCandidateItemAssociation().getItemStatus() == ItemStatus.Answered)) {
				candidateAnswers = groupService.getCandidateAnswersByItemIdandCandidateExamItemId(examViewModel.getCandidateItemAssociation().getFkItemID(), examViewModel.getCandidateItemAssociation().getCandidateExamItemID());
				if (candidateAnswers != null && candidateAnswers.size() != 0) {
					model.addAttribute("mode", "update");
				}
			}
			
			model.addAttribute("activeSec", secID);			
			model.addAttribute("examineeCandidateID", attempterItemExamineeArray.get(2));
			model.addAttribute("attempterCandidateID", attempterItemExamineeArray.get(0));
			model.addAttribute("selectedLang", selectedLang);
			model.addAttribute("confidenceLevels", ConfidenceLevel.values());
			model.addAttribute("paperID", paperID);
			model.addAttribute("examEventID", examEventID);
			model.addAttribute("candidateExamID", candidateExamID);
			model.addAttribute("jsTime", session.getId());
			if(request.getParameter("examineeSelOpIDs")!=null && !request.getParameter("examineeSelOpIDs").isEmpty()){
				model.addAttribute("examineeSelOpIDs", request.getParameter("examineeSelOpIDs"));
			}
			if(request.getParameter("examineeSelConfLevel")!=null && !request.getParameter("examineeSelConfLevel").isEmpty()){
				model.addAttribute("examineeSelConfLevel", request.getParameter("examineeSelConfLevel"));
			}
			
			
			response.setCharacterEncoding("UTF-8");
			List<Long> candidateExams=null;
			if (Long.parseLong(attempterItemExamineeArray.get(2).toString())==Long.parseLong(attempterItemExamineeArray.get(0).toString()) ) {
				Queue<Entry<Long, Long>> candidateQueue= SessionHelper.getCandidateQueue(request);
				candidateExams=new ArrayList<Long>();
				for (Entry<Long, Long> entry : candidateQueue) {
					candidateExams.add(entry.getValue());
				}
			}
			
			if (examViewModel != null && examViewModel.getMultipleChoiceSingleCorrects() != null && examViewModel.getMultipleChoiceSingleCorrects().size() > 0 && examViewModel.getMultipleChoiceSingleCorrects().get(0).getItemLanguage().getItem().getItemtype() == ItemType.MCSC) {
				List<CandidateAnswer> answers = getCandidateAnswerForMCSC(request, examViewModel, candidateAnswers,Long.parseLong(attempterItemExamineeArray.get(0).toString()),optionIDsList);
				examViewModel.getCandidateItemAssociation().setCandidateAnswers(answers);
				model.addAttribute("candidateItemAssociation", examViewModel.getCandidateItemAssociation());
				model.addAttribute("examViewModel", examViewModel);
				if (examViewModel.getCandidateItemAssociation().getItemStatus() == ItemStatus.NoStatus && candidateExams !=null && candidateExams.size() > 0) {
					groupService.updateItemStatusByCandidateExamID(candidateExams, ItemStatus.NotAnswered, examViewModel.getCandidateItemAssociation().getFkItemID());
				}
				groupService=null;
				return "Group/groupExam/MCSC";
			} else if (examViewModel != null && examViewModel.getMultipleChoiceMultipleCorrects() != null && examViewModel.getMultipleChoiceMultipleCorrects().size() > 0 && examViewModel.getMultipleChoiceMultipleCorrects().get(0).getItemLanguage().getItem().getItemtype() == ItemType.MCMC) {
				List<CandidateAnswer> answers = getCandidateAnswerForMCMC(request, examViewModel, candidateAnswers,Long.parseLong(attempterItemExamineeArray.get(0).toString()),optionIDsList);
				examViewModel.getCandidateItemAssociation().setCandidateAnswers(answers);
				model.addAttribute("candidateItemAssociation", examViewModel.getCandidateItemAssociation());
				model.addAttribute("examViewModel", examViewModel);
				if (examViewModel.getCandidateItemAssociation().getItemStatus() == ItemStatus.NoStatus && candidateExams !=null && candidateExams.size() > 0) {
					groupService.updateItemStatusByCandidateExamID(candidateExams, ItemStatus.NotAnswered, examViewModel.getCandidateItemAssociation().getFkItemID());
				}
				groupService=null;
				return "Group/groupExam/MCMC";
			} else if (examViewModel != null && examViewModel.getPictureIdentifications() != null && examViewModel.getPictureIdentifications().size() > 0 && examViewModel.getPictureIdentifications().get(0).getItemLanguage().getItem().getItemtype() == ItemType.PI) {
				List<CandidateAnswer> answers = getCandidateAnswerForPI(request, examViewModel, candidateAnswers,Long.parseLong(attempterItemExamineeArray.get(0).toString()),optionIDsList);
				examViewModel.getCandidateItemAssociation().setCandidateAnswers(answers);
				model.addAttribute("candidateItemAssociation", examViewModel.getCandidateItemAssociation());
				model.addAttribute("examViewModel", examViewModel);
				if (examViewModel.getCandidateItemAssociation().getItemStatus() == ItemStatus.NoStatus && candidateExams !=null && candidateExams.size() > 0) {
					groupService.updateItemStatusByCandidateExamID(candidateExams, ItemStatus.NotAnswered, examViewModel.getCandidateItemAssociation().getFkItemID());
				}
				model.addAttribute("candidateItemAssociation", examViewModel.getCandidateItemAssociation());
				groupService=null;
				return "Group/groupExam/PI";
			}
			/*Reena : 12 Sept 2016 :Enable COMPREHENSION Item Type in Group Exam*/
			else if (examViewModel != null && examViewModel.getComprehensions() != null && examViewModel.getComprehensions().size() > 0 && examViewModel.getComprehensions().get(0).getItemLanguage().getItem().getItemtype() == ItemType.CMPS) {
				
				Map<Long,List<CandidateAnswer>> subItemCandidateAnswers = new CandidateExamServiceImpl().getCandidateAnswersBySubItemIdandCandidateExamItemId(examViewModel.getCandidateItemAssociation().getFkItemID(),  examViewModel.getCandidateItemAssociation().getFkCandidateExamID());
				if (subItemCandidateAnswers != null && subItemCandidateAnswers.size() > 0) {
					model.addAttribute("mode", "update");
				}
				getCandidateAnswerForCMPS(request,examViewModel,subItemCandidateAnswers,Long.parseLong(attempterItemExamineeArray.get(0).toString()),optionIDsList);
				model.addAttribute("candidateItemAssociation", examViewModel.getCandidateItemAssociation());
				model.addAttribute("examViewModel", examViewModel);
				if (examViewModel.getCandidateItemAssociation().getItemStatus() == ItemStatus.NoStatus) {
					examViewModel.getCandidateItemAssociation().setItemStatus(ItemStatus.NotAnswered);
					groupService.updateItemStatusByCandidateExamID(candidateExamID, ItemStatus.NotAnswered, examViewModel.getCandidateItemAssociation().getFkItemID());
				}
				groupService=null;
				return "Group/groupExam/CMPS";
			}
			/*Reena : 12 Sept 2016 :Enable MULTIMEDIA Item Type in Group Exam*/
			else if (examViewModel != null && examViewModel.getMultimedias() != null && examViewModel.getMultimedias().size() > 0 && examViewModel.getMultimedias().get(0).getItemLanguage().getItem().getItemtype() == ItemType.MM) 
			{	
				if(examViewModel.getMultimedias().get(0).getSubItemType() == ItemType.NOOPT)
				{
					Queue<Entry<Long, Long>> candidateQueue= SessionHelper.getCandidateQueue(request);
					List<CandidateItemAssociation> candidateItemAssociations = new ArrayList<CandidateItemAssociation>();
					CandidateItemAssociation candidateItemAssociation = null;	
					candidateAnswers = null;
					candidateAnswers = new ArrayList<CandidateAnswer>();				

					for (Entry<Long, Long> entry : candidateQueue) 
					{
						if(entry.getValue().longValue() == candidateExamID)
						{
							candidateItemAssociation = examViewModel.getCandidateItemAssociation();
							examViewModel.setCandidateItemAssociation(null);
						}	
						else
						{
							candidateItemAssociation = groupService.loadItemByItemID(Long.parseLong(paperID), entry.getValue().longValue(), examViewModel.getItemBankItemAssociation().getFkItemID()).getCandidateItemAssociation();						
						}
						
						for (int i = 0; i < candidateItemAssociation.getCandidateSubItemAssociations().size(); i++) {
							CandidateAnswer candidateAnswer = new CandidateAnswer();
							candidateAnswer.setFkItemID(candidateItemAssociation.getCandidateSubItemAssociations().get(i).getFkItemID());
							candidateAnswer.setFkParentItemID(candidateItemAssociation.getFkItemID());
							candidateAnswer.setFkcandidateID(candidateItemAssociation.getFkCandidateID());
							candidateAnswer.setCandidateExamItemID(candidateItemAssociation.getCandidateSubItemAssociations().get(i).getCandidateExamItemID());
							candidateAnswer.setFkCandidateExamID(candidateItemAssociation.getFkCandidateExamID());
							candidateAnswer.setFkExamEventID(Long.valueOf(examEventID));					
							candidateAnswers.add(candidateAnswer);
							candidateItemAssociation.getCandidateSubItemAssociations().get(i).setCandidateAnswers(candidateAnswers);
							candidateAnswers = null;
							candidateAnswers = new ArrayList<CandidateAnswer>();
							candidateAnswer=null;
						}						
						candidateItemAssociations.add(candidateItemAssociation);
						candidateItemAssociation=null;	
					}				

					examViewModel.setCandidateItemAssociationList(candidateItemAssociations);
					model.addAttribute("examViewModel", examViewModel);
					model.addAttribute("mode", "off");
					if(MultimediaType.AUDIO == examViewModel.getMultimedias().get(0).getMultimediaType()){
						return "Group/groupExam/chatWindow";
					} else {
						return "Group/groupExam/chatWindow";
					}
				}
				else
				{
					Map<Long,List<CandidateAnswer>> subItemCandidateAnswers = new CandidateExamServiceImpl().getCandidateAnswersBySubItemIdandCandidateExamItemId(examViewModel.getCandidateItemAssociation().getFkItemID(),  examViewModel.getCandidateItemAssociation().getFkCandidateExamID());
					if (subItemCandidateAnswers != null && subItemCandidateAnswers.size() > 0) {
						model.addAttribute("mode", "update");
					}
					getCandidateAnswerForMM(request,examViewModel,subItemCandidateAnswers,Long.parseLong(attempterItemExamineeArray.get(0).toString()),optionIDsList);
					if (examViewModel.getCandidateItemAssociation().getItemStatus() == ItemStatus.NoStatus) {
						examViewModel.getCandidateItemAssociation().setItemStatus(ItemStatus.NotAnswered);
						groupService.updateItemStatusByCandidateExamID(candidateExamID, ItemStatus.NotAnswered, examViewModel.getCandidateItemAssociation().getFkItemID());
					}
					groupService=null;
					model.addAttribute("candidateItemAssociation", examViewModel.getCandidateItemAssociation());
					model.addAttribute("examViewModel", examViewModel);
					if(MultimediaType.AUDIO == examViewModel.getMultimedias().get(0).getMultimediaType()){
						return "Group/groupExam/MMAudio";
					} else {
						return "Group/groupExam/MMVideo";
					}
				}
			} 
		} catch (Exception e) {
			LOGGER.error("Error in QuestionContainer :",e);
		}
		model.addAttribute("loadParent", "1");
			response.sendError(HttpServletResponse.SC_FORBIDDEN,"Error in QuestionContainer :");return null;
	}

	/**
	 * Post method to Process Question
	 * @param model
	 * @param request
	 * @param candidateItemAssociation
	 * @param examViewModel
	 * @param response
	 * @return String this returns the path of a view
	 * @throws IOException
	 */
	@RequestMapping(value = "/ProcessQuestion", method = RequestMethod.POST)
	public String ProcessQuestion(Model model, HttpServletRequest request, @ModelAttribute("candidateItemAssociation") CandidateItemAssociation candidateItemAssociation,@ModelAttribute("examViewModel") ExamViewModel examViewModel,HttpServletResponse response) throws IOException {
		String candidateExamID = request.getParameter("candidateExamID");
		String paperID = request.getParameter("paperID");
		String examEventID = request.getParameter("examEventID");
		try {
			String examineeCandidateID = request.getParameter("examineeCandidateID");
			String attempterCandidateID = request.getParameter("attempterCandidateID");
			String itemId = request.getParameter("curitemID");
			String selectedLang = request.getParameter("selectedLang");
			String secID= request.getParameter("sectionID");
			/*
			 * start By harshadd
			 */
			String itemBankGroupID=request.getParameter("itemBankGroupID");
			String difficultyLevel=request.getParameter("difficultyLevel");
			String key=null;
			MarkingScheme markingScheme=SessionHelper.getExamPaperSetting(request).getMarkingScheme();
			if(markingScheme==MarkingScheme.PaperWise || markingScheme==MarkingScheme.NoMarking){
				key=paperID;
			}else if(markingScheme==MarkingScheme.DifficultyLevelWise){
				key=String.valueOf(DifficultyLevel.valueOf(difficultyLevel).ordinal());
			}else if(markingScheme==MarkingScheme.ItemBankGroupDifficultyLevelWise){
				key=String.valueOf(itemBankGroupID+"|"+DifficultyLevel.valueOf(difficultyLevel).ordinal());
			}
			/*
			 * end By harshadd
			 */
			if (!SessionHelper.getLoginStatus(request)) {
				return "Common/Exam/SessionOut";
			}
			List<Candidate> candidates = SessionHelper.getCandidates(request);
			IGroupCandidateExamService groupService = new GroupCandidateExamServiceImpl();
			if (groupService.isExamCompleated(candidates, Long.valueOf(examEventID), Long.parseLong(paperID))) {
				groupService=null;
				return "redirect:../commonExam/alreadyAttempted";
			}
			ItemType itemType=null;
			boolean saved = false;
			String mode = request.getParameter("mode");
			if(request.getParameter("itype") != null && !request.getParameter("itype").isEmpty() && ItemType.valueOf(request.getParameter("itype")) == ItemType.NOOPT)
			{
				skipPeerAsseor(SessionHelper.getCandidateQueue(request), Long.parseLong(examineeCandidateID));
			}
			
			if (mode.matches("off")) {
				if(request.getParameter("itype") != null && !request.getParameter("itype").isEmpty() && ItemType.valueOf(request.getParameter("itype")) == ItemType.NOOPT)
				{
					for (CandidateItemAssociation itemAssociation : examViewModel.getCandidateItemAssociationList()) 
					{
						saved = groupService.saveCandidateAnswer(itemAssociation,Long.parseLong(paperID), Long.parseLong(examEventID),SessionHelper.getExamPaperSetting(request).getMarks(key),SessionHelper.getExamPaperSetting(request).getNegativeMarks(key),ItemStatus.Answered);
						if (!saved){
							LOGGER.error("Exception Occured while TakeTest:: Candidate Answer not saved for NOOPT question type");
							model.addAttribute("paperID", paperID);
							model.addAttribute("examEventID", examEventID);
							model.addAttribute("candidateExamID", candidateExamID);
							groupService=null;
							model.addAttribute("loadParent", "1");
								response.sendError(HttpServletResponse.SC_FORBIDDEN, "Exception Occured while TakeTest:: Candidate Answer not saved for NOOPT question type");return null;
						}
					}
					itemType = ItemType.valueOf(request.getParameter("itype"));
				}
				else
				{
					saved = groupService.saveCandidateAnswer(candidateItemAssociation,Long.parseLong(paperID), Long.parseLong(examEventID),SessionHelper.getExamPaperSetting(request).getMarks(key),SessionHelper.getExamPaperSetting(request).getNegativeMarks(key),ItemStatus.Answered);
					itemType = candidateItemAssociation.getItem().getItemtype();
				}
			}			
			if (!saved){
				LOGGER.error("Exception Occured while TakeTest:: Candidate Answer not saved");
				model.addAttribute("paperID", paperID);
				model.addAttribute("examEventID", examEventID);
				model.addAttribute("candidateExamID", candidateExamID);
				groupService=null;
				model.addAttribute("loadParent", "1");
					response.sendError(HttpServletResponse.SC_FORBIDDEN, "Exception Occured while TakeTest:: Candidate Answer not saved");return null;
			}
			
			String examineeSelOpIDs="";
			String examineeSelConfLevel="";
			if(itemType != ItemType.NOOPT && attempterCandidateID.equals(examineeCandidateID))
			{
				if(itemType != ItemType.CMPS && itemType != ItemType.MM)
				{
					for (CandidateAnswer candidateAnswer : candidateItemAssociation.getCandidateAnswers()) {
						if (candidateAnswer.getOptionID() != null && candidateAnswer.getOptionID() != 0) {
							examineeSelOpIDs=examineeSelOpIDs+candidateAnswer.getOptionID()+",";
						}
					}
				}
				else
				{
					for (CandidateItemAssociation subItemAssociation : candidateItemAssociation.getCandidateSubItemAssociations()) {
						for (CandidateAnswer candidateAnswer : subItemAssociation.getCandidateAnswers()) {
							if (candidateAnswer.getOptionID() != null && candidateAnswer.getOptionID() != 0) {
								examineeSelOpIDs=examineeSelOpIDs+candidateAnswer.getOptionID()+",";
							}
						}
					}
				}
				examineeSelOpIDs = examineeSelOpIDs.substring(0, examineeSelOpIDs.lastIndexOf(","));
				//confidence level is Optional field
				if(candidateItemAssociation.getConfidenceLevel()!=null){
					examineeSelConfLevel=candidateItemAssociation.getConfidenceLevel().toString();
				}
				
			}
			else
			{
				examineeSelOpIDs = request.getParameter("examineeSelOpIDs");
				examineeSelConfLevel = request.getParameter("examineeSelConfLevel");
			}
			groupService=null;
			return "redirect:QuestionContainer?examEventID=" + examEventID + "&paperID=" + paperID + "&itemID=" + itemId + "&selectedLang=" + selectedLang + "&examineeCandidateID=" + examineeCandidateID + "&examineeSelOpIDs=" + examineeSelOpIDs+"&examineeSelConfLevel="+examineeSelConfLevel+"&secID=" + secID;
		} catch (Exception e) {
			model.addAttribute("paperID", paperID);
			model.addAttribute("examEventID", examEventID);
			model.addAttribute("candidateExamID", candidateExamID);
			LOGGER.error("Exception Occured while TakeTest:ProcessQuestion ::",e);
			model.addAttribute("loadParent", "1");
				response.sendError(HttpServletResponse.SC_FORBIDDEN, e.getMessage());return null;
		}
		
	}

	/**
	 * Method to fetch Candidate Answer for MCSC
	 * @param request
	 * @param examViewModel
	 * @param candidateAnswers
	 * @param candidateID
	 * @param optionIDsList
	 * @return List<CandidateAnswer> this returns the CandidateAnswerList
	 * @throws Exception
	 */
	private List<CandidateAnswer> getCandidateAnswerForMCSC(HttpServletRequest request, ExamViewModel examViewModel, List<CandidateAnswer> candidateAnswers,long candidateID,List<Long> optionIDsList) throws Exception {
		List<CandidateAnswer> answers = new ArrayList<CandidateAnswer>();
		if (candidateAnswers == null || candidateAnswers.size() == 0) {
			candidateAnswers = new ArrayList<CandidateAnswer>();
			for (OptionSingleCorrect optionSingleCorrect : examViewModel.getMultipleChoiceSingleCorrects().get(0).getOptionList()) {
				CandidateAnswer candidateAnswer = new CandidateAnswer();
				candidateAnswer.setFkItemID(examViewModel.getCandidateItemAssociation().getFkItemID());
				candidateAnswer.setFkcandidateID(candidateID);
				candidateAnswer.setCandidateExamItemID(examViewModel.getCandidateItemAssociation().getCandidateExamItemID());
				candidateAnswer.setFkCandidateExamID(examViewModel.getCandidateItemAssociation().getFkCandidateExamID());
				candidateAnswer.setFkExamEventID(SessionHelper.getExamEvent(request).getExamEventID());
				//set Examinee Answer
				if(optionIDsList!=null && optionIDsList.size() > 0 && optionIDsList.contains(optionSingleCorrect.getOptionLanguage().getOption().getOptionID())){
					candidateAnswer.setOptionID(optionSingleCorrect.getOptionLanguage().getOption().getOptionID());
				}
				// candidateAnswer.setOptionID(optionSingleCorrect.getOptionLanguage().getOption().getOptionID());
				answers.add(candidateAnswer);
			}
		} else {
			int outterCount = 0;
			int innerCount = 0;
			boolean Insertflag = false;
			for (OptionSingleCorrect optionSingleCorrect : examViewModel.getMultipleChoiceSingleCorrects().get(0).getOptionList()) {
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
					candidateAnswer.setFkcandidateID(candidateID);
					candidateAnswer.setCandidateExamItemID(examViewModel.getCandidateItemAssociation().getCandidateExamItemID());
					candidateAnswer.setFkCandidateExamID(examViewModel.getCandidateItemAssociation().getFkCandidateExamID());
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
	
	/**
	 * Method to fetch Candidate Answer for MCMC
	 * @param request
	 * @param examViewModel
	 * @param candidateAnswers
	 * @param candidateID
	 * @param optionIDsList
	 * @return List<CandidateAnswer> this returns the CandidateAnswerList
	 * @throws Exception
	 */

	private List<CandidateAnswer> getCandidateAnswerForMCMC(HttpServletRequest request, ExamViewModel examViewModel, List<CandidateAnswer> candidateAnswers,long candidateID,List<Long> optionIDsList) throws Exception {
		List<CandidateAnswer> answers = new ArrayList<CandidateAnswer>();
		if (candidateAnswers == null || candidateAnswers.size() == 0) {
			candidateAnswers = new ArrayList<CandidateAnswer>();
			for (OptionMultipleCorrect optionMultipleCorrect : examViewModel.getMultipleChoiceMultipleCorrects().get(0).getOptionList()) {
				CandidateAnswer candidateAnswer = new CandidateAnswer();
				candidateAnswer.setFkItemID(examViewModel.getCandidateItemAssociation().getFkItemID());
				candidateAnswer.setFkcandidateID(candidateID);
				candidateAnswer.setCandidateExamItemID(examViewModel.getCandidateItemAssociation().getCandidateExamItemID());
				candidateAnswer.setFkCandidateExamID(examViewModel.getCandidateItemAssociation().getFkCandidateExamID());
				candidateAnswer.setFkExamEventID(SessionHelper.getExamEvent(request).getExamEventID());
				//set Examinee Answer
				if(optionIDsList!=null && optionIDsList.size() > 0 && optionIDsList.contains(optionMultipleCorrect.getOptionLanguage().getOption().getOptionID())){
					candidateAnswer.setOptionID(optionMultipleCorrect.getOptionLanguage().getOption().getOptionID());
				}
				// candidateAnswer.setOptionID(optionSingleCorrect.getOptionLanguage().getOption().getOptionID());
				answers.add(candidateAnswer);
			}
		} else {
			int outterCount = 0;
			int innerCount = 0;
			boolean Insertflag = false;
			for (OptionMultipleCorrect optionMultipleCorrect : examViewModel.getMultipleChoiceMultipleCorrects().get(0).getOptionList()) {
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
					candidateAnswer.setFkcandidateID(candidateID);
					candidateAnswer.setCandidateExamItemID(examViewModel.getCandidateItemAssociation().getCandidateExamItemID());
					candidateAnswer.setFkCandidateExamID(examViewModel.getCandidateItemAssociation().getFkCandidateExamID());
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

	
	/**
	 * Method to fetch Candidate Answer for Picture Identification
	 * @param request
	 * @param examViewModel
	 * @param candidateAnswers
	 * @param candidateID
	 * @param optionIDsList
	 * @return List<CandidateAnswer> this returns the CandidateAnswerList
	 * @throws Exception
	 */

	private List<CandidateAnswer> getCandidateAnswerForPI(HttpServletRequest request, ExamViewModel examViewModel, List<CandidateAnswer> candidateAnswers,long candidateID,List<Long> optionIDsList) throws Exception {
		List<CandidateAnswer> answers = new ArrayList<CandidateAnswer>();
		if (candidateAnswers == null || candidateAnswers.size() == 0) {
			candidateAnswers = new ArrayList<CandidateAnswer>();
			for (OptionPictureIdentification optionPictureIdentification : examViewModel.getPictureIdentifications().get(0).getOptionList()) {
				CandidateAnswer candidateAnswer = new CandidateAnswer();
				candidateAnswer.setFkItemID(examViewModel.getCandidateItemAssociation().getFkItemID());
				candidateAnswer.setFkcandidateID(candidateID);
				candidateAnswer.setCandidateExamItemID(examViewModel.getCandidateItemAssociation().getCandidateExamItemID());
				candidateAnswer.setFkCandidateExamID(examViewModel.getCandidateItemAssociation().getFkCandidateExamID());
				candidateAnswer.setFkExamEventID(SessionHelper.getExamEvent(request).getExamEventID());
				//set Examinee Answer
				if(optionIDsList!=null && optionIDsList.size() > 0 && optionIDsList.contains(optionPictureIdentification.getOptionLanguage().getOption().getOptionID())){
					candidateAnswer.setOptionID(optionPictureIdentification.getOptionLanguage().getOption().getOptionID());
				}
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
					candidateAnswer.setFkcandidateID(candidateID);
					candidateAnswer.setCandidateExamItemID(examViewModel.getCandidateItemAssociation().getCandidateExamItemID());
					candidateAnswer.setFkCandidateExamID(examViewModel.getCandidateItemAssociation().getFkCandidateExamID());
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
	
		
	/**
	 * Method to fetch Candidate Answer for CMPS (Comprehension)
	 * @param request
	 * @param examViewModel
	 * @param subItemCandidateAnswers
	 * @param candidateID
	 * @param optionIDsList
	 * @return List<CandidateAnswer> this returns the CandidateAnswerList
	 * @throws Exception
	 */
	/*Reena : 12 Sept 2016 :Enable COMPREHENSION Item Type in Group Exam*/
	private void getCandidateAnswerForCMPS(HttpServletRequest request, ExamViewModel examViewModel, Map<Long,List<CandidateAnswer>> subItemCandidateAnswers,long candidateID,List<Long> optionIDsList) throws Exception {
		
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
						candidateAnswer.setFkcandidateID(candidateID);
						candidateAnswer.setCandidateExamItemID(examViewModel.getCandidateItemAssociation().getCandidateSubItemAssociations().get(index).getCandidateExamItemID());
						candidateAnswer.setFkCandidateExamID(examViewModel.getCandidateItemAssociation().getFkCandidateExamID());
						candidateAnswer.setFkExamEventID(SessionHelper.getExamEvent(request).getExamEventID());
						// candidateAnswer.setOptionID(optionSingleCorrect.getOptionLanguage().getOption().getOptionID());
						//set Examinee Answer
						if(optionIDsList!=null && optionIDsList.size() > 0 && optionIDsList.contains(optionSubItem.getOptionLanguage().getOption().getOptionID())){
							candidateAnswer.setOptionID(optionSubItem.getOptionLanguage().getOption().getOptionID());
						}
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
							candidateAnswer.setFkcandidateID(candidateID);
							candidateAnswer.setCandidateExamItemID(examViewModel.getCandidateItemAssociation().getCandidateSubItemAssociations().get(index).getCandidateExamItemID());
							candidateAnswer.setFkCandidateExamID(examViewModel.getCandidateItemAssociation().getFkCandidateExamID());
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
	 * Method to fetch Candidate Answer for Multimedia
	 * @param request
	 * @param examViewModel
	 * @param subItemCandidateAnswers
	 * @param candidateID
	 * @param optionIDsList
	 * @return List<CandidateAnswer> this returns the CandidateAnswerList
	 * @throws Exception
	 */
	/*Reena : 12 Sept 2016 :Enable MULTIMEDIA Item Type in Group Exam*/
	private void getCandidateAnswerForMM(HttpServletRequest request, ExamViewModel examViewModel, Map<Long,List<CandidateAnswer>> subItemCandidateAnswers,long candidateID,List<Long> optionIDsList) throws Exception {
		
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
						candidateAnswer.setFkcandidateID(candidateID);
						candidateAnswer.setCandidateExamItemID(examViewModel.getCandidateItemAssociation().getCandidateSubItemAssociations().get(index).getCandidateExamItemID());
						candidateAnswer.setFkCandidateExamID(examViewModel.getCandidateItemAssociation().getFkCandidateExamID());
						candidateAnswer.setFkExamEventID(SessionHelper.getExamEvent(request).getExamEventID());
						// candidateAnswer.setOptionID(optionSingleCorrect.getOptionLanguage().getOption().getOptionID());
						//set Examinee Answer
						if(optionIDsList!=null && optionIDsList.size() > 0 && optionIDsList.contains(optionSubItem.getOptionLanguage().getOption().getOptionID())){
							candidateAnswer.setOptionID(optionSubItem.getOptionLanguage().getOption().getOptionID());
						}
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
							candidateAnswer.setFkcandidateID(candidateID);
							candidateAnswer.setCandidateExamItemID(examViewModel.getCandidateItemAssociation().getCandidateSubItemAssociations().get(index).getCandidateExamItemID());
							candidateAnswer.setFkCandidateExamID(examViewModel.getCandidateItemAssociation().getFkCandidateExamID());
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
	/*
	 * * by sonam
	 */

	/**
	 * Get method for Group Information
	 * @param model
	 * @param request
	 * @param paperID
	 * @param examEventID
	 * @param scheduleEnd
	 * @param response
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "/groupInfo", method = RequestMethod.GET)
	public String getGroupinformation(Model model, HttpServletRequest request, long paperID, long examEventID,String scheduleEnd,HttpServletResponse response) {

		//Code For dynamic logo render:13-july-2015:Yograjs
		model.addAttribute("clientid", AppInfoHelper.appInfo.getClientID());
		model.addAttribute("isCopyRightEnabled", AppInfoHelper.appInfo.getIsCopyRightEnabled());
		List<VenueUser> venueUserList = SessionHelper.getLogedInUsers(request);
		ExamEvent examEvent = SessionHelper.getExamEvent(request);

		if (!SessionHelper.getLoginStatus(request)) {
			return "Common/Exam/SessionOut";
		}
		GroupCandidateExamServiceImpl groupCandidateExamServiceImpl = new GroupCandidateExamServiceImpl();
		if (groupCandidateExamServiceImpl.isExamCompleated(SessionHelper.getCandidates(request), examEventID, paperID)) {
			groupCandidateExamServiceImpl=null;
			return "redirect:../commonExam/alreadyAttempted";
		}
		//check for schedule expiry
		if(scheduleEnd!=null && !scheduleEnd.isEmpty())
		{
			Date now=new Date();
			if(!compareScheduleDateExpiry(now,scheduleEnd)){
				groupCandidateExamServiceImpl=null;
				return "redirect:../commonExam/scheduleExpired";
			}
		}
		Paper paper = new PaperServiceImpl().getpaperByPaperID(paperID);
		model.addAttribute("paper", paper);

		model.addAttribute("userColors", UserColor.values());
		model.addAttribute("paperID", paperID);
		model.addAttribute("examEventID", examEventID);
		model.addAttribute("scheduleEnd", scheduleEnd);
		model.addAttribute("examEvent",examEvent);
		model.addAttribute("usersList", venueUserList);
		String imgrelativePath = FileUploadHelper.getRelativeFolderPath(request, "UserPhotoUploadPath");
		model.addAttribute("imgPath", imgrelativePath);
		groupCandidateExamServiceImpl=null;
		
		/* Added by Reena : 24 July 2015		 
		 This call will set Exam Locale as per Medium of Paper.
		 */
		try {
			examLocaleThemeResolver.setExamLocaleAndTheme(request, response);
		} catch (Exception e) {
			LOGGER.error("error occured while setting Default Loacle in groupInfo() : "+e);
		}	
		
		return "Group/groupExam/groupInfo";
	}

	/**
	 * Post method for Instructions
	 * @param model
	 * @param request
	 * @param paperID
	 * @param examEventID
	 * @param scheduleEnd
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "/instruction", method = RequestMethod.POST)
	public String getInstructions(Model model, HttpServletRequest request, long paperID, long examEventID,String scheduleEnd) {

		try {
			//Code For dynamic logo render:13-july-2015:Yograjs
			model.addAttribute("clientid", AppInfoHelper.appInfo.getClientID());
			model.addAttribute("isCopyRightEnabled", AppInfoHelper.appInfo.getIsCopyRightEnabled());
			List<VenueUser> venueUserList = SessionHelper.getLogedInUsers(request);
			ExamEvent examEvent = SessionHelper.getExamEvent(request);
			model.addAttribute("userColors", UserColor.values());
			
			if (!SessionHelper.getLoginStatus(request)) {
				return "Common/Exam/SessionOut";
			}
			GroupCandidateExamServiceImpl groupCandidateExamServiceImpl = new GroupCandidateExamServiceImpl();
			if (groupCandidateExamServiceImpl.isExamCompleated(SessionHelper.getCandidates(request), examEventID, paperID)) {
				groupCandidateExamServiceImpl=null;
				return "redirect:../commonExam/alreadyAttempted";
			}
			//check for schedule expiry
			if(scheduleEnd!=null && !scheduleEnd.isEmpty())
			{
				Date now=new Date();
				if(!compareScheduleDateExpiry(now,scheduleEnd)){
					groupCandidateExamServiceImpl=null;
					return "redirect:../commonExam/scheduleExpired";
				}
			}
			//old Service
			//Instructions instructions = groupCandidateExamServiceImpl.getInstructionByPaperID(paperID);
			InstructionTemplateViewModel instructions=new CandidateExamServiceImpl().getInstructionTemplatsByPaperIDandEventID(paperID, examEventID);
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
			
			List<MediumOfPaper> mediumOfPapersList = groupCandidateExamServiceImpl.getLanguageListByPaperID(paperID);
			Paper paper = new PaperServiceImpl().getpaperByPaperID(paperID);
			model.addAttribute("paper", paper);

			model.addAttribute("mediumOfPapersList", mediumOfPapersList);
			model.addAttribute("instructions", instructions);
			model.addAttribute("examEventID", examEventID);
			model.addAttribute("paperID", paperID);
			model.addAttribute("scheduleEnd", scheduleEnd);
			model.addAttribute("usersList", venueUserList);
			model.addAttribute("examEvent",examEvent);
			String imgrelativePath = FileUploadHelper.getRelativeFolderPath(request, "UserPhotoUploadPath");
			model.addAttribute("imgPath", imgrelativePath);
			groupCandidateExamServiceImpl=null;
		} catch (Exception e) {
			LOGGER.error("Exception occured in getInstructions: ", e);
		}
		return "Group/groupExam/instructions";
	}

	/**
	 * Post method for Proceed to Test
	 * @param model
	 * @param request
	 * @param session
	 * @param instructions
	 * @param errors
	 * @param locale
	 * @param scheduleEnd
	 * @param response
	 * @return String this returns the path of a view
	 * @throws IOException
	 */
	@RequestMapping(value = "/proceed", method = RequestMethod.POST)
	public String proceedToTest(Model model, HttpServletRequest request, HttpSession session, @ModelAttribute("instructions") Instructions instructions, BindingResult errors, Locale locale,String scheduleEnd,HttpServletResponse response) throws IOException {
		String languageID = request.getParameter("language");
		long examEventID = Long.parseLong(request.getParameter("examEventID"));
		long paperID = Long.parseLong(request.getParameter("paperID"));
		try {
			List<Candidate> candidates = SessionHelper.getCandidates(request);
			if (candidates != null && candidates.size() > 0) {
				List<CandidateExam> candidateExams = new ArrayList<CandidateExam>();
				CandidateExam candidateExam = null;
				for (Candidate candidate : candidates) {
					candidateExam = new CandidateExam();
					candidateExam.setFkCandidateID(candidate.getCandidateID());
					candidateExam.setFkPaperID(paperID);
					candidateExam.setFkExamEventID(examEventID);
					candidateExam.setCandidatePaperLanguage(languageID);
					candidateExams.add(candidateExam);
					candidateExam = null;
				}
				if (new GroupCandidateExamServiceImpl().updateLanguageInCandidateExam(candidateExams)) {
					return "redirect:TakeTest?examEventID=" + examEventID + "&paperID=" + paperID+"&scheduleEnd="+scheduleEnd+"&languageID="+languageID;
				}
			}
		} catch (Exception e) {
			LOGGER.error("Exception occured in proceedToTest: ", e);
			model.addAttribute("error", e);
		}
			response.sendError(HttpServletResponse.SC_FORBIDDEN, "Exception occured in proceedToTest: ");return null;
	}

	/*
	 * 
	 * Image Decryption :Yograj
	 */

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

	/*
	 * 
	 * end Image Decryption
	 */
	/**
	 * Method to fetch Item Examinee
	 * @param candidateQueue
	 * @param currentExaminee
	 * @param itemID
	 * @param paperID
	 * @param secID
	 * @return List<Object> this returns the Attempter Item Examinee List
	 * @throws Exception
	 */
	private List<Object> getItemExaminee(Queue<Entry<Long, Long>> candidateQueue, Long currentExaminee, Long itemID,long paperID,String secID) throws Exception {
		try {
			List<Object> attempterItemExamineeArray = null;
			long attempter = 0l;
			ExamViewModel examViewModel=null;
			boolean isNewItem = false;
			boolean isExamineeFixed = false;
			Entry<Long, Long> topElement=null;
			if (candidateQueue != null && candidateQueue.size() > 0) {
				if(!isExamineeFixed)
				{
					// To rotate examinee
					// get Queue head & remove head
					topElement = candidateQueue.poll();
					// set suggester
					attempter = topElement.getKey();
					
					if (currentExaminee == null || currentExaminee.longValue() == 0l) {
						// check if current Examinee is set Or not
						currentExaminee = topElement.getKey();
						// set suggester
						attempter = currentExaminee;
						// fetch new Item
						isNewItem = true;
					} else if (currentExaminee.longValue() == topElement.getKey().longValue()) {
						// get next Examinee
						// add earlier examinee
						candidateQueue.add(topElement);
						// get Next Examinee
						topElement = candidateQueue.poll();
						currentExaminee = topElement.getKey();
						// set suggester
						attempter = currentExaminee;
						// fetch new Item
						isNewItem = true;
					}
					// add popped element in Queue Again
					candidateQueue.add(topElement);
				}
				else
				{
					// to keep examinee fixed
					if (currentExaminee == null || currentExaminee.longValue() == 0l) {
						// get Queue head & remove head
						topElement = candidateQueue.poll();
						// check if current Examinee is set Or not
						currentExaminee = topElement.getKey();
						// set suggester
						attempter = currentExaminee;
						// fetch new Item
						isNewItem = true;
						// add popped element in Queue Again
						candidateQueue.add(topElement);
					}
					else if (currentExaminee.longValue() == candidateQueue.peek().getKey().longValue()) 
					{
						topElement = candidateQueue.poll();
						currentExaminee = topElement.getKey();
						attempter = currentExaminee;
						isNewItem = true;
						candidateQueue.add(topElement);
					}
					else
					{
						topElement = candidateQueue.poll();
						attempter = topElement.getKey();
						candidateQueue.add(topElement);	
						isNewItem = false;
					}
				}
				// fetch new item if new Examinee Added
				IGroupCandidateExamService groupService=new GroupCandidateExamServiceImpl();
				if (itemID == null || itemID.longValue() == 0l) {
					// fetch new Item
					examViewModel = groupService.loadNotAttemptedItemByCandidateExamID(topElement.getValue().longValue(), paperID, null,Long.parseLong(secID));
					//set Examinee Candidate
					groupService.setExamineeCandidate(examViewModel.getCandidateItemAssociation().getCandidateExamItemID());
				} else if (isNewItem == true) {
					// fetch new Item
					examViewModel = groupService.loadNotAttemptedItemByCandidateExamID(topElement.getValue().longValue(), paperID, null,Long.parseLong(secID));
					//set Examinee Candidate
					groupService.setExamineeCandidate(examViewModel.getCandidateItemAssociation().getCandidateExamItemID());
				} else {
					examViewModel = groupService.loadItemByItemID(paperID, topElement.getValue().longValue(), itemID);
				}
				// fill triplet array
				// 0: suggester 1: item 3: Examinee
				attempterItemExamineeArray = new ArrayList<Object>();
				attempterItemExamineeArray.add(attempter);// 0
				attempterItemExamineeArray.add(itemID);// 1
				attempterItemExamineeArray.add(currentExaminee);// 2
				attempterItemExamineeArray.add(examViewModel);// 3
			}
			return attempterItemExamineeArray;
		} catch (Exception e) {
			throw e;
		}
	}
	
	/**
	 * Method to Skip Peer Assessor
	 * @param candidateQueue
	 * @param currentExaminee
	 * @throws Exception
	 */
	private void skipPeerAsseor(Queue<Entry<Long, Long>> candidateQueue, Long currentExaminee) throws Exception {
		
		while (currentExaminee.longValue() != candidateQueue.peek().getKey().longValue()) 
		{			
			candidateQueue.add(candidateQueue.poll());
		}
		
	}

	/**
	 * Method to Compare Schedule Date Expiry
	 * @param now
	 * @param scheduleEndDate
	 * @return boolean this returns true if the date is expired
	 */
	private boolean compareScheduleDateExpiry(Date now,String scheduleEndDate){
		if(scheduleEndDate!=null && !scheduleEndDate.isEmpty() && Long.parseLong(scheduleEndDate)!=0l){
			if(now.compareTo(new Date(Long.parseLong(scheduleEndDate)))==-1){
				return true;
			}
		}
		return false;
	}
	

	/**
	 * End by Harshad
	 */
}
