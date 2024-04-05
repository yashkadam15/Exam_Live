package mkcl.oesclient.solo.controllers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import mkcl.oesclient.commons.controllers.ExamLocaleThemeResolver;
import mkcl.oesclient.commons.utilities.FileUploadHelper;
import mkcl.oesclient.model.Candidate;
import mkcl.oesclient.model.CandidateAnswer;
import mkcl.oesclient.model.CandidateExam;
import mkcl.oesclient.model.CandidateItemAssociation;
import mkcl.oesclient.model.ItemStatus;
import mkcl.oesclient.solo.services.CandidateExamServiceImpl;
import mkcl.oesclient.solo.services.MSCITServiceImpl;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.oesclient.viewmodel.ExamViewModel;
import mkcl.oesserver.model.DifficultyLevel;
import mkcl.oesserver.model.ItemType;
import mkcl.oesserver.model.OptionMultipleCorrect;
import mkcl.oesserver.model.OptionSingleCorrect;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * 
 * @author reenak
 * 
 */
@Controller
@RequestMapping(value = "/MSCITExam")
public class MSCITExamController{
	private static final Logger LOGGER = LoggerFactory.getLogger(MSCITExamController.class);
	MSCITServiceImpl mscitServiceImpl=new MSCITServiceImpl();
	ExamController examControllerObj=new ExamController();
	
	@Autowired
	private ExamLocaleThemeResolver examLocaleThemeResolver;
	
	/**
	 * Post method for Take a Test
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
		String view=examControllerObj.GenrateAndValidateTest(response, model, request, session, locale);		
		
		return view;
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
		CandidateExamServiceImpl candidateExamServiceImpl = new CandidateExamServiceImpl();
		List<ExamViewModel> examViewModelList=null;
		try
		{
		Candidate candidate = SessionHelper.getCandidate(request);
		if (candidate == null) {
			return "Common/Exam/SessionOut";
		}
		
		String selectedLang=request.getParameter("selectedLang");
		
		long candidateExamID=SessionHelper.getExamPaperSetting(request).getCandidateExamID();
		// validate user authorized or not
		CandidateExam candidateExam = (CandidateExam)SessionHelper.getVariable(ExamController.CESessionVeriable, request);
		if(candidateExam!=null && candidateExam.getIsExamCompleted()) {
			return "redirect:../commonExam/alreadyAttempted";
			}
		
		
		List<CandidateAnswer> candidateAnswers = null;
		String imgrelativePath = FileUploadHelper.getRelativeFolderPath(request, "UserPhotoUploadPath");
		model.addAttribute("imgPath", imgrelativePath);	
		model.addAttribute("selectedLang", selectedLang);
	
		response.setCharacterEncoding("UTF-8");
		
		if(request.getParameter("start")!=null)
		{
			examViewModelList= mscitServiceImpl.loadObjectiveItemsWithOption(candidateExamID, DifficultyLevel.Low, selectedLang);
			
		}
		else if(!request.getParameter("qtype").equals(null) && !request.getParameter("level").equals(null))
		{
			// set data acc to Qtype and DiffLevel
			String questionType=request.getParameter("qtype");
			DifficultyLevel difficultyLevel= DifficultyLevel.values()[Integer.parseInt(request.getParameter("level"))];
			if(questionType.equals("OBJECTIVE"))
			{
				examViewModelList= mscitServiceImpl.loadObjectiveItemsWithOption(candidateExamID, difficultyLevel, selectedLang);
			} else if(questionType.equals("PRACTICAL"))
			{
				examViewModelList= mscitServiceImpl.loadPracticalItemsWithOption(candidateExamID, difficultyLevel, selectedLang);
			}
		}
		
		// set candidate answer data here in loop for each candidateItemAssociation,use existing services from Exam Controller for same.
		for (ExamViewModel eviewModel : examViewModelList) {
			if (eviewModel != null && eviewModel.getMultipleChoiceSingleCorrect() != null ) {
				List<CandidateAnswer> answers = getCandidateAnswerForMCSC(request, eviewModel, candidateAnswers);
				eviewModel.getCandidateItemAssociation().setCandidateAnswers(answers);
				
				if (eviewModel.getCandidateItemAssociation().getItemStatus() == ItemStatus.NoStatus) {
					eviewModel.getCandidateItemAssociation().setItemStatus(ItemStatus.NotAnswered);
					candidateExamServiceImpl.updateItemStatusByCandidateExamID(eviewModel.getCandidateItemAssociation().getCandidateExamItemID(), ItemStatus.NotAnswered, false);
				}				
				//candidateExamServiceImpl=null;
				
			} else if (eviewModel != null && eviewModel.getMultipleChoiceMultipleCorrect() != null ) {
				List<CandidateAnswer> answers = getCandidateAnswerForMCMC(request, eviewModel, candidateAnswers);
				eviewModel.getCandidateItemAssociation().setCandidateAnswers(answers);
				
				if (eviewModel.getCandidateItemAssociation().getItemStatus() == ItemStatus.NoStatus) {
					eviewModel.getCandidateItemAssociation().setItemStatus(ItemStatus.NotAnswered);
					candidateExamServiceImpl.updateItemStatusByCandidateExamID(eviewModel.getCandidateItemAssociation().getCandidateExamItemID(), ItemStatus.NotAnswered, false);
				}
				//candidateExamServiceImpl=null;
				
			}else if (eviewModel != null && eviewModel.getPractical() != null ) {
				List<CandidateAnswer> answers = getCandidateAnswerForPRT(request, eviewModel);
				eviewModel.getCandidateItemAssociation().setCandidateAnswers(answers);
				
				if (eviewModel.getCandidateItemAssociation().getItemStatus() == ItemStatus.NoStatus) {
					eviewModel.getCandidateItemAssociation().setItemStatus(ItemStatus.NotAnswered);
					candidateExamServiceImpl.updateItemStatusByCandidateExamID(eviewModel.getCandidateItemAssociation().getCandidateExamItemID(), ItemStatus.NotAnswered, false);
				}
				
				String itemBankGroupID=Long.toString(eviewModel.getPaperItemBankAssociation().getItemBankGroupID());
				String difficultyLevel=eviewModel.getItemBankItemAssociation().getDifficultyLevel().name();
				String key= examControllerObj.createReqMarkingSchemeKey(request,difficultyLevel,itemBankGroupID,String.valueOf(eviewModel.getCandidateItemAssociation().getFkItemID()));
				model.addAttribute("marksPerItem", SessionHelper.getExamPaperSetting(request).getMarks(key));
				model.addAttribute("negMarksPerItem", SessionHelper.getExamPaperSetting(request).getNegativeMarks(key));
				
				//candidateExamServiceImpl=null;				
			}
		}
		// set blank candidateItemAssociation in model attribute and then bind <form: hidden values in each form to this model
		model.addAttribute("examViewModelList",examViewModelList);
		model.addAttribute("candidateItemAssociation", new CandidateItemAssociation());
		model.addAttribute("sessionId", session.getId());
		
		return "Solo/MSCITExam/question";
		}
		catch(Exception e)
		{
			LOGGER.error("exam :: error found in MSCITExam - QuestionContainer",e);			
		}
		finally
		{
			candidateExamServiceImpl=null;
		}		
		model.addAttribute("loadParent", "1");
			response.sendError(HttpServletResponse.SC_FORBIDDEN, "exam :: error found in MSCITExam - QuestionContainer");return null;
	}

	/**
	 * Post method for Process Question
	 * @param model
	 * @param request
	 * @param candidateItemAssociation
	 * @param response
	 * @return String this returns the path of a view
	 * @throws IOException
	 */
	@RequestMapping(value = "/ProcessQuestion", method = RequestMethod.POST)
	public String ProcessQuestion(Model model, HttpServletRequest request, @ModelAttribute("candidateItemAssociation") CandidateItemAssociation candidateItemAssociation,HttpServletResponse response) throws IOException {
		try
		{
			long candidateExamID = SessionHelper.getExamPaperSetting(request).getCandidateExamID();			
			String secID= request.getParameter("sectionID");
			Candidate candidate = SessionHelper.getCandidate(request);
			/*
			 * start By harshadd
			 */
			String itemBankGroupID=request.getParameter("itemBankGroupID");
			String difficultyLevel=request.getParameter("difficultyLevel");
			
			String key=examControllerObj.createReqMarkingSchemeKey(request,difficultyLevel,itemBankGroupID,String.valueOf(candidateItemAssociation.getFkItemID()));
			/*
			 * end By harshadd
			 */
		
			if (candidate == null) {
				//return "redirect:../login/loginpage";
				return "Common/Exam/SessionOut";
			}
			CandidateExamServiceImpl candidateExamServiceImpl = new CandidateExamServiceImpl();
						
			// validate user authorized or not
			CandidateExam candidateExam = (CandidateExam)SessionHelper.getVariable(ExamController.CESessionVeriable, request);
			if(candidateExam!=null && candidateExam.getIsExamCompleted()) {
				return "redirect:../commonExam/alreadyAttempted";
			}
				
			
			ItemType itemType;
			if (request.getParameter("Save") != null) {
				itemType = candidateItemAssociation.getItem().getItemtype();
				int level= DifficultyLevel.valueOf(difficultyLevel).ordinal();
				boolean saved = true;	
				//if(!isExmCmpleted)
				if(!candidateExam.getIsExamCompleted())
				{ 	/**
				 	* by harshad
				 	*/					
					if(itemType == ItemType.MCSC || itemType == ItemType.MCMC || itemType == ItemType.PRT){
						saved = candidateExamServiceImpl.saveCandidateAnswer(candidateItemAssociation,SessionHelper.getExamPaperSetting(request).getMarks(key),SessionHelper.getExamPaperSetting(request).getNegativeMarks(key),ItemStatus.Answered);
					}
					if(!saved)
					{
						LOGGER.error("Exception Occured while MSCITExam TakeTest:: Candidate Answer not saved");
						model.addAttribute("loadParent", "1");		
							response.sendError(HttpServletResponse.SC_FORBIDDEN, "Exception Occured while MSCITExam TakeTest:: Candidate Answer not saved");return null;
					}
				}
				candidateExamServiceImpl=null;
				if(itemType == ItemType.PRT){
					return "redirect:QuestionContainer?selectedLang=" + request.getParameter("selectedLang") + "&secID=" + secID + "&qtype=" + request.getParameter("qtype")+ "&level=" + request.getParameter("level");
				}
				else
				{
					return "redirect:QuestionContainer?selectedLang=" + request.getParameter("selectedLang") + "&secID=" + secID + "&qtype=OBJECTIVE&level=" + level;
				}
			}  else if (request.getParameter("hidExt") != null && request.getParameter("hidExt").toString().matches("loadItem"))																													
			{
				candidateExamServiceImpl=null;
				return "redirect:QuestionContainer?selectedLang=" + request.getParameter("selectedLang") + "&secID=" + secID + "&qtype=" + request.getParameter("qtype")+ "&level=" + request.getParameter("level");
			
			} else if (request.getParameter("Next") != null || request.getParameter("hidExt") != null && request.getParameter("hidExt").toString().matches("loadPracticalItem")) {
			return "redirect:QuestionContainer?selectedLang=" + request.getParameter("selectedLang") + "&secID=" + secID + "&qtype=" + request.getParameter("qtype")+ "&level=" + request.getParameter("level");
			}
		}
		catch(Exception e)
		{
			LOGGER.error("Exception Occured while MSCITExam - TakeTest: ", e);
			model.addAttribute("error", e);			
		}
		model.addAttribute("loadParent", "1");		
			response.sendError(HttpServletResponse.SC_FORBIDDEN, "Exception Occured while MSCITExam - TakeTest: ");return null;
	}

	/**
	 * Method to fetch the Candidate Answer List for Multiple Choice Single Correct Questions 
	 * @param request
	 * @param examViewModel
	 * @param candidateAnswers
	 * @return List<CandidateAnswer> this returns the CandidateAnswerList
	 * @throws Exception
	 */
	public List<CandidateAnswer> getCandidateAnswerForMCSC(HttpServletRequest request, ExamViewModel examViewModel, List<CandidateAnswer> candidateAnswers) throws Exception {
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
					// candidateAnswer.setOptionID(optionSingleCorrect.getOptionLanguage().getOption().getOptionID());
					answers.add(candidateAnswer);
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
	public List<CandidateAnswer> getCandidateAnswerForMCMC(HttpServletRequest request, ExamViewModel examViewModel, List<CandidateAnswer> candidateAnswers) throws Exception {
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
					// candidateAnswer.setOptionID(optionSingleCorrect.getOptionLanguage().getOption().getOptionID());
					answers.add(candidateAnswer);
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
	 * Method to fetch the Candidate Answer List for Practical Questions
	 * @param request
	 * @param examViewModel
	 * @return List<CandidateAnswer> this returns the CandidateAnswerList
	 * @throws Exception
	 */
	public List<CandidateAnswer> getCandidateAnswerForPRT(HttpServletRequest request, ExamViewModel examViewModel) throws Exception {
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
	
}
