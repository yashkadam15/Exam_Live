package mkcl.oesclient.solo.controllers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import mkcl.baseoesclient.model.LoginType;
import mkcl.oes.commons.EncryptionHelper;
import mkcl.oesclient.commons.controllers.ExamLocaleThemeResolver;
import mkcl.oesclient.commons.services.ExamEventConfigurationServiceImpl;
import mkcl.oesclient.commons.services.OESLogServices;
import mkcl.oesclient.commons.services.OESPartnerServiceImpl;
import mkcl.oesclient.commons.services.PaperServiceImpl;
import mkcl.oesclient.commons.utilities.GatewayConstants;
import mkcl.oesclient.commons.utilities.OESException;
import mkcl.oesclient.commons.utilities.SmartTagHelper;
import mkcl.oesclient.model.Candidate;
import mkcl.oesclient.model.CandidateExam;
import mkcl.oesclient.model.CandidateReport;
import mkcl.oesclient.model.VenueUser;
import mkcl.oesclient.solo.services.CandidateExamServiceImpl;
import mkcl.oesclient.solo.services.CandidateServiceImpl;
import mkcl.oesclient.solo.services.ICandidateExamService;
import mkcl.oesclient.solo.services.ResultAnalysisServicesImpl;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.oesclient.utilities.md5Helper;
import mkcl.oesclient.viewmodel.ExamDisplayCategoryPaperViewModel;
import mkcl.oesclient.viewmodel.ExamPaperSetting;
import mkcl.oesclient.viewmodel.ResultAnalysisViewModel;
import mkcl.oesclient.viewmodel.ViewModelOESLogForCandidate;
import mkcl.oespcs.model.Paper;
import mkcl.oespcs.model.PaperType;
import mkcl.oespcs.model.ShowResultType;
import mkcl.oespcs.model.TemplateType;
import mkcl.os.security.AESHelper;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping(value = "/endexam")
public class EndExamController {
	private static final Logger LOGGER = LoggerFactory.getLogger(EndExamController.class);
	@Autowired
	private ExamLocaleThemeResolver examLocaleThemeResolver;
	
	/**
	 * Get method for End Test
	 * @param model
	 * @param request
	 * @param session
	 * @param response
	 * @return String this returns the path of a view
	 * @throws IOException
	 */
	@RequestMapping(value = "/FrmendTestGet", method = RequestMethod.GET)
	public String endTestGet(Model model, HttpServletRequest request,HttpSession session,HttpServletResponse response) throws IOException {
		try {
			
			Candidate candidate = SessionHelper.getCandidate(request);
			if (candidate == null) {
				//return "redirect:../login/loginpage";
				return "Common/Exam/SessionOut";
			}
			ExamPaperSetting examPaperSetting = SessionHelper.getExamPaperSetting(request);
			if(examPaperSetting != null)
			{
				if(examPaperSetting.getCandidatePwdtoEnd() || examPaperSetting.getSupervisorPwdEndExam()) 
				{
					if(SessionHelper.getVariable("SPWDverifyStatus", request) == null || !Boolean.parseBoolean(SessionHelper.getVariable("SPWDverifyStatus", request).toString()))
					{
						response.sendError(HttpServletResponse.SC_FORBIDDEN, "The request is not authenticated.");
						return null;
					}
				}
			}
			else
			{
				throw new Exception("examPaperSetting can not be null.");
			}
			
			new CandidateExamServiceImpl().getMarksObtainedandUpdateExamScore(examPaperSetting.getCandidateExamID());
			SessionHelper.removeVariable(ExamController.CESessionVeriable, request);
			//this model attribute is used in logging interceptor; don't remove
			
			model.addAttribute("ceid", SessionHelper.getExamPaperSetting(request).getCandidateExamID());
			return "redirect:showTestResult?examEventID="+SessionHelper.getExamEvent(request).getExamEventID()+"&paperID="
						+SessionHelper.getExamPaperSetting(request).getPaperID()+"&attemptNo="+SessionHelper.getExamPaperSetting(request).getAttemptNo();
		} catch (Exception e) {
			LOGGER.error("Error occured in FrmendTestGet: " , e);
			model.addAttribute("message", "error");
			model.addAttribute("messageText", e);
			/*response.sendError(HttpServletResponse.SC_FORBIDDEN, e.getMessage());return null;*/
			response.sendError(HttpServletResponse.SC_FORBIDDEN, e.getMessage());
			return null;
		}	finally{
			//remove exam settings from Session
			//SessionHelper.removeExamSetting(session);
		}	
	}

	/**
	 * Post method for End Test
	 * @param model
	 * @param request
	 * @param session
	 * @param response
	 * @return String this returns the path of a view
	 * @throws IOException
	 */
	@RequestMapping(value = "/FrmendTest", method = RequestMethod.POST)
	public String endTest(Model model, HttpServletRequest request,HttpSession session,HttpServletResponse response) throws IOException {
		try {
			Candidate candidate = SessionHelper.getCandidate(request);
			if (candidate == null) {
				//return "redirect:../login/loginpage";
				return "Common/Exam/SessionOut";
			}	
			new CandidateExamServiceImpl().getMarksObtainedandUpdateExamScore(SessionHelper.getExamPaperSetting(request).getCandidateExamID());
			SessionHelper.removeVariable(ExamController.CESessionVeriable, request);
			//this model attribute is used in logging interceptor; don't remove
			model.addAttribute("ceid", SessionHelper.getExamPaperSetting(request).getCandidateExamID());
			return "redirect:showTestResult?examEventID="+SessionHelper.getExamEvent(request).getExamEventID()+"&paperID="
						+SessionHelper.getExamPaperSetting(request).getPaperID()+"&attemptNo="+SessionHelper.getExamPaperSetting(request).getAttemptNo();
		} catch (Exception e) {
			LOGGER.error("Error occured in FrmendTest: " , e);
			model.addAttribute("message", "error");
			model.addAttribute("messageText", e);
			response.sendError(HttpServletResponse.SC_FORBIDDEN, e.getMessage());return null;
		}finally{
			//remove exam settings from Session
			//SessionHelper.removeExamSetting(session);
		}
		
	}
	
	/**
	 * Get method for Verify
	 * @param model
	 * @param session
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "/verify", method = RequestMethod.GET)
	public String verify(Model model, HttpSession session) 
	{
		Random random = new Random();
		int rnum = random.nextInt(100);
		model.addAttribute("soloRnum", rnum);
		return "Solo/Exam/verify";
	}
	
	/**
	 * Post method for Verify
	 * @param model
	 * @param spsw
	 * @param cpsw
	 * @param soloRnum
	 * @param request
	 * @param response
	 * @return String this returns the path of a view
	 * @throws IOException
	 */
	@RequestMapping(value = "/verify", method = RequestMethod.POST)
	public String verify(Model model,String spsw,String cpsw,String soloRnum,HttpServletRequest request,HttpServletResponse response, HttpSession session) throws IOException {
		try {
			ExamPaperSetting examPaperSetting = SessionHelper.getExamPaperSetting(request);
			if(examPaperSetting != null){
				//compare candidate password
				boolean verifyCandidatePsw = true;
				if(examPaperSetting.getCandidatePwdtoEnd()==true){
					VenueUser venueUser = SessionHelper.getLogedInUser(request);
					md5Helper md5 = new md5Helper();
					String saltMd5 = md5.getsaltMD5(venueUser.getPassword(),soloRnum);
					if(cpsw.equals(saltMd5)){
						verifyCandidatePsw = true ;
					}else {
						verifyCandidatePsw = false ;
						model.addAttribute("cpswerror","1");
					}
				}
				//compare supervisor password
				boolean verifySupervisorPsw = true;
				if(examPaperSetting.getSupervisorPwdEndExam()==true){
					ICandidateExamService examService = new CandidateExamServiceImpl();
					String saltMD5 = new md5Helper().getsaltMD5(examService.getSupervisorPwd(examPaperSetting.getExamCenterID()), soloRnum);
					if(saltMD5.equals(spsw)){
						verifySupervisorPsw = true ;
					}else{
						verifySupervisorPsw = false ;
						model.addAttribute("spswerror", "1");
					}
				}
				if(verifyCandidatePsw && verifySupervisorPsw){
					
					SessionHelper.addVariable("SPWDverifyStatus", true, session);
					model.addAttribute("verifyStatus", "1");
				}else{
					SessionHelper.addVariable("SPWDverifyStatus", false, session);
					model.addAttribute("verifyStatus", "0");
				}
			}else{
				LOGGER.error("Error occured in verify: examPaperSetting is null");
			}
		} catch (Exception e) {
			LOGGER.error("Error occured in verify: " , e);
			model.addAttribute("message", "error");
			model.addAttribute("messageText", e);
			response.sendError(HttpServletResponse.SC_FORBIDDEN, e.getMessage());return null;
		}
		Random random = new Random();
		int rnum = random.nextInt(100);
		model.addAttribute("soloRnum", rnum);
		return "Solo/Exam/verify";
	}

	/**
	 * Get method to Show Test Result
	 * @param model
	 * @param request
	 * @param session
	 * @param response
	 * @return String this returns the path of a view
	 * @throws IOException
	 * @throws OESException 
	 */
	@RequestMapping(value = "/showTestResult", method = RequestMethod.GET)
	public String showTestResult(Model model, HttpServletRequest request,HttpSession session,HttpServletResponse response) throws IOException, OESException {
		try {		
			/**
			 * edit By amoghs;
			 * To handle the simultaneous execution of Item saving/mark for review/reset actions along with END TEST due to time up.
			 *  
			 */
			//SessionHelper.removeExamSetting(session);
			/**
			 * end edit
			 */
			/* Added by Reena : 24 July 2015
			 * This call should always be on the top of each function as locale further 
			 accessed will not behave as required 
			 This call will set back Locale to application Default if Candidate comes from Exam Interface
			 */						
			examLocaleThemeResolver.setApplicationDefaultLocaleAndTheme(request, response);	
			
			String examEventID = request.getParameter("examEventID");
			String paperID = request.getParameter("paperID");
			String attemptNo = request.getParameter("attemptNo");
			long candExamID =0; 
			if(request.getParameter("candidateExamID")!=null && !request.getParameter("candidateExamID").isEmpty())
			{
				candExamID=Long.parseLong(request.getParameter("candidateExamID"));
			}
			if(request.getParameter("ceid")!=null && !request.getParameter("ceid").isEmpty())
			{
				candExamID=Long.parseLong(request.getParameter("ceid"));
			}
			
		    Boolean isTimeUp=Boolean.parseBoolean(request.getParameter("isTimeUp"));
		    if(isTimeUp==true)
		    	new CandidateExamServiceImpl().getMarksObtainedandUpdateExamScore(candExamID);	
		    
			CandidateExamServiceImpl candidateExamServiceImpl = new CandidateExamServiceImpl();
			SessionHelper.removeVariable(ExamController.CESessionVeriable, request);
			CandidateExam candidateExam =  candidateExamServiceImpl.getCandidateExamBycandidateExamID(candExamID);
			if(candidateExam != null && candidateExam.getFkCandidateID() != SessionHelper.getCandidate(request).getCandidateID())
			{
				response.sendError(HttpServletResponse.SC_FORBIDDEN, "You are not authorized to view this result.");
				return null;
			}
			
			if (!candidateExam.getIsExamCompleted()) {
				candidateExamServiceImpl=null;
				model.addAttribute("error","You have not completed the exam.");
				response.sendError(HttpServletResponse.SC_FORBIDDEN, "You have not completed the exam.");return null;
			}
			
			if(SessionHelper.getLogedInUser(request) != null && SessionHelper.getLogedInUser(request).getObject() != null && SessionHelper.getIsSessionThirdParty(request))
			{
				Map<String, String> optionalParamertsMap = SessionHelper.getPartnerObject(request);
                if(optionalParamertsMap.containsKey(GatewayConstants.EXEVPID) && optionalParamertsMap.get(GatewayConstants.EXEVPID) != null  && Integer.parseInt(optionalParamertsMap.get(GatewayConstants.EXEVPID)) == 0 && optionalParamertsMap.containsKey(GatewayConstants.PCID) && optionalParamertsMap.get(GatewayConstants.PCID) != null && Integer.parseInt(optionalParamertsMap.get(GatewayConstants.PCID)) > 0 && optionalParamertsMap.containsKey(GatewayConstants.SECMARKS))
				{
					StringBuilder sb = new StringBuilder();
					sb.append("redirect:../endexam/showTestResultForKlick?examEventID=").append(examEventID).append("&paperID=").append(paperID).append("&attemptNo=").append(attemptNo).append("&ceid=").append(candExamID).append("&sm=").append(optionalParamertsMap.get(GatewayConstants.SECMARKS));
					return sb.toString();
				}
			}
			
			ExamPaperSetting examPaperSetting = new ExamEventConfigurationServiceImpl().getExamEventConfiguration(Long.parseLong(examEventID), Long.parseLong(paperID));
			model.addAttribute("showResultType", examPaperSetting.getShowResultType());
			if (examPaperSetting !=null) {
				model.addAttribute("showAnalysis", examPaperSetting.getShowAnalysis());
			}
			
			if(SessionHelper.getIsSessionThirdParty(request))
			{
				model.addAttribute("oesPartnerMaster", new OESPartnerServiceImpl().getOESPartnerMaster(Long.parseLong(SessionHelper.getPartnerObject(request).get(GatewayConstants.PARTNERID))));
			}
			if (examPaperSetting !=null && examPaperSetting.getShowResultType() == ShowResultType.No) {
				//get result text
				
				
				/*String resultText = examPaperSetting.getResultText();
				String totalMarks=new PaperServiceImpl().getPaperTotalMarks(Long.parseLong(paperID));
				CandidateExam candidateExam=candidateExamServiceImpl.getCandidateExamBycandidateExamID(candExamID);
				String marksObtained=(candidateExam != null && candidateExam.getMarksObtained() != null && !candidateExam.getMarksObtained().isEmpty()) ? candidateExam.getMarksObtained() : null;
				Double perc=0.0;
				if (totalMarks !=null && ! totalMarks.isEmpty() && marksObtained !=null && ! marksObtained.isEmpty()) {
					perc = (Double.parseDouble(marksObtained)/Double.parseDouble(totalMarks))*100;
				}
				
				resultText = replaceTagWithValue("[[score]]",marksObtained, resultText);
				resultText = replaceTagWithValue("[[tot_mark]]",totalMarks, resultText);
				resultText = replaceTagWithValue("[[percent]]",perc.toString(), resultText);*/
				
				String resultText=SmartTagHelper.getListOfReplacedTemplateText(String.valueOf(candExamID),TemplateType.Result,request).get(0);
				
				model.addAttribute("resultText",resultText);
				model.addAttribute("examEventId", examEventID);
				model.addAttribute("paperId", paperID);
				model.addAttribute("attemptNo", attemptNo);
				model.addAttribute("candidateId", SessionHelper.getCandidate(request).getCandidateID());
			} else {
				CandidateServiceImpl candidateServiceImpl=new CandidateServiceImpl();
				Candidate candidate=candidateServiceImpl.getCandidateByCandidateID(SessionHelper.getCandidate(request).getCandidateID());
				PaperServiceImpl paperServicesObj = new PaperServiceImpl();
				PaperType paperType = paperServicesObj.getpaperByPaperID(Long.parseLong(paperID)).getPaperType();
				if (paperType.equals(PaperType.careerInclination)) {
					return "redirect:../CareerInclinationTestReport/careerInclinationTestReport?candidateUserName="+candidate.getCandidateUserName();
				}else if (paperType.equals(PaperType.VisualArtInclination)){
					return "redirect:../ArtInclinationTestReport/artInclinationTestReport?candidateUserName="+candidate.getCandidateUserName()+"&examEventId="+examEventID+"&paperId="+paperID+"&attemptNo="+attemptNo;
				}else if (paperType.equals(PaperType.ShortVisualArtInclination)){
					return "redirect:../ShortArtInclinationTestReport/shortArtInclinationTestReport?candidateUserName="+candidate.getCandidateUserName()+"&examEventId="+examEventID+"&paperId="+paperID+"&attemptNo="+attemptNo;
				}else if(paperType.equals(PaperType.DiabetesDiagnostic)){
					return "redirect:../DiabetesDiagnosticTestReport/diabetesDiagnosticTestReport?candidateUserName="+candidate.getCandidateUserName()+"&examEventId="+examEventID+"&paperId="+paperID+"&attemptNo="+attemptNo;
				}
				
				
				// show Score Card
				showScoreCard(model, examEventID, paperID,attemptNo, request);
			}
			
			//-- Start : Added by Reena on 27June2014 : Show Exam Log to Candidate,if enable log and display to candidate is true
			if(SessionHelper.getLoginType(request)== LoginType.Solo)
			{			
			if(SessionHelper.getExamEvent(request).getEnableLog()==true && SessionHelper.getExamEvent(request).getDisplayToCandidate()==true)
			{
				OESLogServices oesLogServices = new OESLogServices();
				//24 Nov 2014 :Modified Exam Log to include Section in Candidate Exam Log
				List<ViewModelOESLogForCandidate> oesLogForCandidate=oesLogServices.getCandidatePostLoginActivityLog(Long.parseLong(examEventID),Long.parseLong(paperID),SessionHelper.getCandidate(request).getCandidateID(),Long.parseLong(attemptNo), SessionHelper.getLogedInUser(request).getUserName());
				model.addAttribute("OesLogForCandidate",oesLogForCandidate);
			}
			}
			
			candidateExamServiceImpl=null;
			//-- End on Exam Log Block
		} catch (Exception e) {
			LOGGER.error("Exception occured in showTestResult: " , e);
			model.addAttribute("error", e);
			response.sendError(HttpServletResponse.SC_FORBIDDEN, e.getMessage());return null;
		}
		CandidateExamServiceImpl CandidateExamServiceImpl=new CandidateExamServiceImpl();
		List<CandidateReport> questionReport=CandidateExamServiceImpl.getQuestionReport(SessionHelper.getExamPaperSetting(request).getCandidateExamID(),SessionHelper.getExamPaperSetting(request).getPaperID()) ;
		List<CandidateReport> decryptedQuestionReport=new ArrayList<CandidateReport>();
		ListIterator<CandidateReport> iterator = questionReport.listIterator();
		String dkey=EncryptionHelper.encryptDecryptKey;
		   while (iterator.hasNext()) {
	            CandidateReport report = iterator.next();
	            String decryptedItemText;
	            try {
	                decryptedItemText = AESHelper.decrypt(report.getItemText(), dkey);
	            } catch (Exception e) {
	                decryptedItemText = "Decryption Error";
	                e.printStackTrace(); 
	            }
	            CandidateReport decryptedReport = new CandidateReport(decryptedItemText, report.getAnswerStatus());
	           
	            decryptedQuestionReport.add(decryptedReport);
	        }
		
        model.addAttribute("questReport",decryptedQuestionReport);
		model.addAttribute("ceid", SessionHelper.getExamPaperSetting(request).getCandidateExamID());
		return "Solo/Exam/viewtestscore";
	}

	
	//added by priyankag on 25 jan 2016	
	/**
	 * Get method to Show Test Result for Klick
	 * @param model
	 * @param request
	 * @param session
	 * @param response
	 * @param sectionMarks
	 * @return String this returns the path of a view
	 * @throws IOException
	 */
	@RequestMapping(value = "/showTestResultForKlick", method = RequestMethod.GET)
	public String showTestResultForKlick(Model model, HttpServletRequest request,HttpSession session,HttpServletResponse response,@RequestParam("sm") String sectionMarks) throws IOException {
		try {				
								
			examLocaleThemeResolver.setApplicationDefaultLocaleAndTheme(request, response);	
			
			String examEventID = request.getParameter("examEventID");
			String paperID = request.getParameter("paperID");
			String attemptNo = request.getParameter("attemptNo");
			String candidateId =  request.getParameter("candidateId");
			long candExamID =0;
			if(request.getParameter("candidateExamID")!=null && !request.getParameter("candidateExamID").isEmpty())
			{
				candExamID=Long.parseLong(request.getParameter("candidateExamID"));
			}
			if(request.getParameter("ceid")!=null && !request.getParameter("ceid").isEmpty())
			{
				candExamID=Long.parseLong(request.getParameter("ceid"));
			}
			
			model.addAttribute("candExamID", candExamID);
			model.addAttribute("paperId", paperID);
			
			/*CandidateExamServiceImpl candidateExamServiceImpl = new CandidateExamServiceImpl();
			if (!candidateExamServiceImpl.isExamCompleated(candExamID)) {
				candidateExamServiceImpl=null;
				model.addAttribute("error","You have not completed the exam.");
				return "Solo/Exam/viewtestscore";
			}
*/			
			/*ExamPaperSetting examPaperSetting = new ExamEventConfigurationServiceImpl().getExamEventConfiguration(Long.parseLong(examEventID), Long.parseLong(paperID));
			model.addAttribute("showResultType", examPaperSetting.getShowResultType());
			if (examPaperSetting !=null) {
				model.addAttribute("showAnalysis", examPaperSetting.getShowAnalysis());
			}*/
			/*if (examPaperSetting !=null && examPaperSetting.getShowResultType() == ShowResultType.No) {
				//get result text	
				String resultText=SmartTagHelper.getListOfReplacedTemplateText(String.valueOf(candExamID),TemplateType.Result,request).get(0);
				
				model.addAttribute("resultText",resultText);
				model.addAttribute("examEventId", examEventID);				
				model.addAttribute("attemptNo", attemptNo);
				
				if(SessionHelper.getLoginType(request) == LoginType.Solo)
				{
					Candidate candidate = SessionHelper.getCandidate(request);
					candidateId = String.valueOf(candidate.getCandidateID());
				}
				model.addAttribute("candidateId", candidateId);
			}*/
			
			//else {
				/*if(SessionHelper.getLoginType(request) == LoginType.Solo)
				{
					Candidate candidate = SessionHelper.getCandidate(request);
					candidateId = String.valueOf(candidate.getCandidateID());
				}
				
				CandidateServiceImpl candidateServiceImpl=new CandidateServiceImpl();
				Candidate candidate=candidateServiceImpl.getCandidateByCandidateID(Long.parseLong(candidateId));
				PaperServiceImpl paperServicesObj = new PaperServiceImpl();
				PaperType paperType = paperServicesObj.getpaperByPaperID(Long.parseLong(paperID)).getPaperType();
				if (paperType.equals(PaperType.careerInclination)) {
					return "redirect:../CareerInclinationTestReport/careerInclinationTestReport?candidateUserName="+candidate.getCandidateUserName();
				}*/
			
				Map<String,String> sectionNameMarkMap= new LinkedHashMap<String, String>();
				if(sectionMarks!=null && !sectionMarks.isEmpty())
				{
				String[] arrOfSectionName=sectionMarks.split("\\|");
				for (String sectionNameAndMarks : arrOfSectionName) {
					if(sectionNameAndMarks!=null)
					{
					String[] arrOfSection =sectionNameAndMarks.split(":");
					String[] markArr=arrOfSection[1].split("\\/");
					sectionNameMarkMap.put(arrOfSection[0], markArr[0]);
					}
				}
				}
				// show Score Card
			//	showScoreCard(model, examEventID, paperID,attemptNo, request);
				
				ResultAnalysisServicesImpl resultAnalysisServicesImplObj = new ResultAnalysisServicesImpl();
				ResultAnalysisViewModel resultAnalysisViewModelObj=resultAnalysisServicesImplObj.getScoreCardDetailsForKlick(Long.valueOf(candExamID));
				model.addAttribute("resultAnalysisViewModelObj", resultAnalysisViewModelObj);
				
				sectionNameMarkMap.put("Final Online Examination",String.valueOf(resultAnalysisViewModelObj.getTotalObtainedMarks().intValue()));
				model.addAttribute("sectionNameMarkMap", sectionNameMarkMap);
				model.addAttribute("sectionMarks", sectionMarks);
				
				Paper paper = new PaperServiceImpl().getpaperByPaperID(Long.parseLong(paperID));
				model.addAttribute("paper", paper);
				
			//}
			
			/*//-- Start : Added by Reena on 27June2014 : Show Exam Log to Candidate,if enable log and display to candidate is true
			if(SessionHelper.getLoginType(request)== LoginType.Solo)
			{			
			if(SessionHelper.getExamEvent(request).getEnableLog()==true && SessionHelper.getExamEvent(request).getDisplayToCandidate()==true)
			{
				OESLogServices oesLogServices = new OESLogServices();
				//24 Nov 2014 :Modified Exam Log to include Section in Candidate Exam Log
				List<ViewModelOESLogForCandidate> oesLogForCandidate=oesLogServices.getCandidatePostLoginActivityLog(Long.parseLong(examEventID),Long.parseLong(paperID),SessionHelper.getCandidate(request).getCandidateID(),Long.parseLong(attemptNo), SessionHelper.getLogedInUser(request).getUserName());
				model.addAttribute("OesLogForCandidate",oesLogForCandidate);
			}
			}*/
			//-- End on Exam Log Block
		} catch (Exception e) {
			LOGGER.error("Exception occured in showTestResult: " , e);
			model.addAttribute("error", e);
			response.sendError(HttpServletResponse.SC_FORBIDDEN, e.getMessage());return null;
		}
		return "Solo/Exam/viewtestscoreForKlick";
	}
	
	/**
	 * Get method for Print Score Card
	 * @param model
	 * @param request
	 * @param session
	 * @param response
	 * @param sectionMarks
	 * @return String this returns the path of a view
	 * @throws IOException
	 */
	@RequestMapping(value = "/printScoreCard", method = RequestMethod.GET)
	public String printScoreCard(Model model, HttpServletRequest request,HttpSession session,HttpServletResponse response,@RequestParam("sm") String sectionMarks) throws IOException {
		try {				
								
			examLocaleThemeResolver.setApplicationDefaultLocaleAndTheme(request, response);			
			String paperID = request.getParameter("paperID");
		
			long candExamID =0;
			if(request.getParameter("candidateExamID")!=null && !request.getParameter("candidateExamID").isEmpty())
			{
				candExamID=Long.parseLong(request.getParameter("candidateExamID"));
			}
			if(request.getParameter("ceid")!=null && !request.getParameter("ceid").isEmpty())
			{
				candExamID=Long.parseLong(request.getParameter("ceid"));
			}
					
				Map<String,String> sectionNameMarkMap= new LinkedHashMap<String, String>();
				if(sectionMarks!=null && !sectionMarks.isEmpty())
				{
				String[] arrOfSectionName=sectionMarks.split("\\|");
				for (String sectionNameAndMarks : arrOfSectionName) {
					if(sectionNameAndMarks!=null)
					{
					String[] arrOfSection =sectionNameAndMarks.split(":");
					String[] markArr=arrOfSection[1].split("\\/");
					sectionNameMarkMap.put(arrOfSection[0], markArr[0]);
					}
				}
				}
				
				ResultAnalysisServicesImpl resultAnalysisServicesImplObj = new ResultAnalysisServicesImpl();
				ResultAnalysisViewModel resultAnalysisViewModelObj=resultAnalysisServicesImplObj.getScoreCardDetailsForKlick(Long.valueOf(candExamID));
				model.addAttribute("resultAnalysisViewModelObj", resultAnalysisViewModelObj);
				
				sectionNameMarkMap.put("Final Online Examination",String.valueOf(resultAnalysisViewModelObj.getTotalObtainedMarks()));
				model.addAttribute("sectionNameMarkMap", sectionNameMarkMap);
				
				Paper paper = new PaperServiceImpl().getpaperByPaperID(Long.parseLong(paperID));
				model.addAttribute("paper", paper);
				
				
				
			
		} catch (Exception e) {
			LOGGER.error("Exception occured in showTestResult: " , e);
			model.addAttribute("error", e);
			response.sendError(HttpServletResponse.SC_FORBIDDEN, e.getMessage());return null;
		}
		return "Solo/Exam/printScoreCard";
	}
//end by priyanka
	
	/**
	 * Method to fetch Digit Array	
	 * @param number
	 * @return List<Long> this returns a digit list
	 */
	public List<Long> getDigitArray(Long number) {
		List<Long> listDigit = new ArrayList<Long>();
		while (number > 0) {
			listDigit.add(number % 10);
			number = number / 10;
		}
		Collections.reverse(listDigit);
		return listDigit;
	}

	/**
	 * Method to Show Score Card
	 * @param model
	 * @param examEventID
	 * @param paperID
	 * @param attemptno
	 * @param request
	 * @throws Exception
	 */
	private void showScoreCard(Model model, String examEventID, String paperID,String attemptno, HttpServletRequest request) throws Exception 
	{
		try
		{
			Paper paper = new PaperServiceImpl().getpaperByPaperID(Long.parseLong(paperID));
			model.addAttribute("paper", paper);
			long examEventId = 0;
			long paperId = 0;
			long candidateID = 0;
			long attemptNo=0;
	
			if (examEventID != null && examEventID != "") {
				examEventId = Long.valueOf(examEventID);
			}
			if (paperID != null && paperID != "") {
				paperId = Long.valueOf(paperID);
			}
			if (attemptno != null && attemptno != "") {
				attemptNo = Long.valueOf(attemptno);
			}
	
			 //User user=SessionHelper.getLogedInUser(request); 
	
			if(SessionHelper.getLoginType(request)== LoginType.Group)
			{
				candidateID = Long.parseLong(request.getParameter("candidateId"));
				//TODO : To handle request coming from jsp /BASE-OES-CLIENTWeb/src/main/webapp/WEB-INF/views/Group/candidateModule/GroupScoreCardCandidateList.jsp
				attemptNo=1;
			}
			else
			{
				Candidate candidate = SessionHelper.getCandidate(request);
				candidateID = candidate.getCandidateID();
			}
			
			
	
			ResultAnalysisServicesImpl resultAnalysisServicesImplObj = new ResultAnalysisServicesImpl();
			ExamDisplayCategoryPaperViewModel examDisplayCategoryPaperViewModelObj = new ExamDisplayCategoryPaperViewModel();
			examDisplayCategoryPaperViewModelObj = resultAnalysisServicesImplObj.getPaperDetails(paperId, examEventId, candidateID,attemptNo,0);
	
			ResultAnalysisViewModel resultAnalysisViewModelObj = new ResultAnalysisViewModel();
			resultAnalysisViewModelObj = resultAnalysisServicesImplObj.getBriefResultDetails(examEventId, paperId, candidateID,attemptNo);
	
			List<Long> listRankDigits = getDigitArray(resultAnalysisViewModelObj.getRank());
			List<Long> listRankOutOfDigits = getDigitArray(resultAnalysisViewModelObj.getRankOutOf());
	
			// code to display preceding zero in rank on view page
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
	
			model.addAttribute("examEventId", examEventId);
			model.addAttribute("paperId", paperId);
			model.addAttribute("attemptNo", attemptNo);
	
			model.addAttribute("examDisplayCategoryPaperViewModelObj", examDisplayCategoryPaperViewModelObj);
			model.addAttribute("candidateId", candidateID);
			model.addAttribute("resultAnalysisViewModelObj", resultAnalysisViewModelObj);
			model.addAttribute("listRankDigits", listRankDigits);
			model.addAttribute("listRankDigitsWithZero", listRankDigitsWithZero);
			model.addAttribute("listRankOutOfDigits", listRankOutOfDigits);	
						
		}
		catch (Exception e)
		{
			throw e;
		}
	}
	/*ADDED BY YOGRAJ FOR SECTION ETMT 2014*/
	/*private void showScoreCard(Model model, String examEventID, String paperID,String attemptno, HttpServletRequest request) throws Exception 
	{
		try
		{
			Paper paper = new PaperServiceImpl().getpaperByPaperID(Long.parseLong(paperID));
			model.addAttribute("paper", paper);
			long examEventId = 0;
			long paperId = 0;
			long candidateID = 0;
			long attemptNo=0;
	
			if (examEventID != null && examEventID != "") {
				examEventId = Long.valueOf(examEventID);
			}
			if (paperID != null && paperID != "") {
				paperId = Long.valueOf(paperID);
			}
			if (attemptno != null && attemptno != "") {
				attemptNo = Long.valueOf(attemptno);
			}
	
			 User user=SessionHelper.getLogedInUser(request); 
	
			if(SessionHelper.getLoginType(request)== LoginType.Group)
			{
				candidateID = Long.parseLong(request.getParameter("candidateId"));
				//TODO : To handle request coming from jsp /BASE-OES-CLIENTWeb/src/main/webapp/WEB-INF/views/Group/candidateModule/GroupScoreCardCandidateList.jsp
				attemptNo=1;
			}
			else
			{
				Candidate candidate = SessionHelper.getCandidate(request);
				candidateID = candidate.getCandidateID();
			}
			
			
	
			ResultAnalysisServicesImpl resultAnalysisServicesImplObj = new ResultAnalysisServicesImpl();
			ExamDisplayCategoryPaperViewModel examDisplayCategoryPaperViewModelObj = new ExamDisplayCategoryPaperViewModel();
			examDisplayCategoryPaperViewModelObj = resultAnalysisServicesImplObj.getPaperDetails(paperId, examEventId, candidateID,attemptNo,0);
	
			ResultAnalysisViewModel resultAnalysisViewModelObj = new ResultAnalysisViewModel();
			long candExamID =0;

			if(request.getParameter("candidateExamID")!=null && !request.getParameter("candidateExamID").isEmpty())
			{
				candExamID=Long.parseLong(request.getParameter("candidateExamID"));
			}
			if(request.getParameter("ceid")!=null && !request.getParameter("ceid").isEmpty())
			{
				candExamID=Long.parseLong(request.getParameter("ceid"));
			}
			resultAnalysisViewModelObj = resultAnalysisServicesImplObj.getBriefResultDetails(examEventId, paperId, candidateID,attemptNo,candExamID);
	
				
			// set total marks for Incorrect to -0.0
			// if no incorrect question found
			if (resultAnalysisViewModelObj.getTotalMarksObtainedForInCorrect() == 0.0) {
				resultAnalysisViewModelObj.setTotalMarksObtainedForInCorrect(-0.0);
			}
	
			model.addAttribute("examEventId", examEventId);
			model.addAttribute("paperId", paperId);
	
			model.addAttribute("examDisplayCategoryPaperViewModelObj", examDisplayCategoryPaperViewModelObj);
			model.addAttribute("candidateId", candidateID);
			model.addAttribute("resultAnalysisViewModelObj", resultAnalysisViewModelObj);

		}
		catch (Exception e)
		{
			throw e;
		}
	}*/
	/**
	 * Method to Replace Tag with Value
	 * @param tag
	 * @param value
	 * @param line
	 * @return String this returns the path of a view
	 */
	private String replaceTagWithValue(String tag,String value,String line){
		if(tag != null && !tag.isEmpty() && value != null && !value.isEmpty()){
			line=line.replace(tag, value);
		}
		return line;
	}
}
