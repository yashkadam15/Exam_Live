package mkcl.oesclient.commons.controllers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import mkcl.baseoesclient.model.LoginType;
import mkcl.oesclient.commons.services.OESPartnerServiceImpl;
import mkcl.oesclient.commons.utilities.GatewayConstants;
import mkcl.oesclient.group.services.GroupCandidateExamServiceImpl;
import mkcl.oesclient.group.services.IGroupCandidateExamService;
import mkcl.oesclient.model.CandidateExam;
import mkcl.oesclient.model.CandidateItemAssociation;
import mkcl.oesclient.solo.services.CandidateExamServiceImpl;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.oesclient.utilities.md5Helper;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller("commonExamController")
@RequestMapping(value = "/commonExam")
public class ExamController {
	private static final Logger LOGGER = LoggerFactory.getLogger(ExamController.class);
	
	@Autowired
	private ExamLocaleThemeResolver examLocaleThemeResolver;
	
	/**
	 * Get method for CMPSMQTSUB
	 * @param timeSpent
	 * @param request
	 * @return ResponseEntity<Boolean> this returns the response status
	 */
	@RequestMapping(value = { "/hidTops/{timeSpent}" }, method = RequestMethod.GET)
	public ResponseEntity<Boolean> updateElapsedtime(@PathVariable String timeSpent, HttpServletRequest request)
	{
		List<CandidateItemAssociation> itemAssociations = new ArrayList<>();
		try 
		{
			CandidateExam candidateExam = (CandidateExam)SessionHelper.getVariable(mkcl.oesclient.solo.controllers.ExamController.CESessionVeriable, request);
			
			if(candidateExam == null)
			{
				LOGGER.error("Error in time sync, session CE object is null");
				return new ResponseEntity<>(false,HttpStatus.INTERNAL_SERVER_ERROR);
			}
			return new ResponseEntity<>(mkcl.oesclient.solo.controllers.ExamController.candidateExamServiceImpl.setElapsedtimeByCandidateExamId(candidateExam.getCandidateExamID(), timeSpent),HttpStatus.OK);
		} 
		catch (Exception e) 
		{
			LOGGER.error("Error in time sync:", e);
			itemAssociations.clear();
			return new ResponseEntity<>(false,HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}
	
	/**
	 * Get method for Media Played Count
	 * @param mpc
	 * @param request
	 * @return ResponseEntity<Boolean> this returns the response status
	 */
	@RequestMapping(value = { "/hidMPC/{mpc}" }, method = RequestMethod.GET)
	public ResponseEntity<Boolean> updateMediaPlayedCount(@PathVariable int mpc, HttpServletRequest request)
	{
		List<CandidateItemAssociation> itemAssociations = new ArrayList<>();
		try 
		{
			CandidateExam candidateExam = (CandidateExam)SessionHelper.getVariable(mkcl.oesclient.solo.controllers.ExamController.CESessionVeriable, request);
			
			if(candidateExam == null)
			{
				LOGGER.error("Error in updateing Media Played Count, session CE object is null");
				return new ResponseEntity<>(false,HttpStatus.INTERNAL_SERVER_ERROR);
			}
			return new ResponseEntity<>(mkcl.oesclient.solo.controllers.ExamController.candidateExamServiceImpl.setMediaPlayedCountByCandidateExamItemId(candidateExam.getCandidateExamID(), mpc),HttpStatus.OK);
		} 
		catch (Exception e) 
		{
			LOGGER.error("Error in updateing Media Played Count:", e);
			itemAssociations.clear();
			return new ResponseEntity<>(false,HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}
	
	/**
	 * Get method for Hidden Operation
	 * @param model
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "/hiddenOperation", method = RequestMethod.GET)
	public String hiddenOperation(Model model, HttpServletRequest request) {
		try
		{
			if (!SessionHelper.getLoginStatus(request)) {
				return "Common/Exam/SessionOut";
			}
			
			else if(request.getParameter("mpc")!=null && request.getParameter("ceiid")!=null)
			{
				
			}
			else if(request.getParameter("supwd")!=null)
			{
				if(new CandidateExamServiceImpl().getAudioResetPwd(SessionHelper.getExamPaperSetting(request).getExamCenterID()).equals(md5Helper.getMd5(request.getParameter("supwd")))){
					model.addAttribute("data", 200);
				}else{
					model.addAttribute("data", 404);
				}
			}
		}
		catch(Exception e)
		{
			LOGGER.error("Exam :: error in time synchronization",e);
		}
		
		return "Common/Exam/HiddenFrame";
	}

	/**
	 * Get method for Frame End Test
	 * @param model
	 * @param request
	 * @param session
	 * @param response
	 * @return String this returns the path of a view
	 * @throws IOException
	 */
	@RequestMapping(value = "/hidFrameendTest", method = RequestMethod.GET)
	public String hidFrameendTest(Model model, HttpServletRequest request,HttpSession session,HttpServletResponse response) throws IOException {
		try {
			boolean result = false;
			if (!SessionHelper.getLoginStatus(request)) {
				return "Common/Exam/SessionOut";
			}
			String endTime =request.getParameter("t"); 
			LoginType loginType = SessionHelper.getLoginType(request);
			if (loginType == LoginType.Solo) {
				result = new CandidateExamServiceImpl().getMarksObtainedandUpdateExamScore(SessionHelper.getExamPaperSetting(request).getCandidateExamID(),endTime);
				//this model attribute is used in logging interceptor; don't remove
				model.addAttribute("ceid", SessionHelper.getExamPaperSetting(request).getCandidateExamID());
			} else if (loginType == LoginType.Group) {
				IGroupCandidateExamService groupService = new GroupCandidateExamServiceImpl();
				Map<Long, Long> candidateExamMap = groupService.getCandidateExamIDsFromCandidates(SessionHelper.getCandidates(request), SessionHelper.getExamEvent(request).getExamEventID(), SessionHelper.getExamPaperSetting(request).getPaperID());
				result = groupService.getMarksObtainedandUpdateExamScore(candidateExamMap.values());
			}
			if(result)
				model.addAttribute("data", 200);
			else
				model.addAttribute("data", 500);
			//reens :24 July 15 - Set to Default Locale after exam end
			examLocaleThemeResolver.setApplicationDefaultLocaleAndTheme(request, response);
			
		} catch (Exception e) {
			LOGGER.error("Exception occured in hidFrameendTest: ", e);
			model.addAttribute("error", e);
		//	response.sendError(HttpServletResponse.SC_FORBIDDEN, e.getMessage());return null;
			response.sendError(HttpServletResponse.SC_FORBIDDEN, "Error message here");
			return null;
			
			
		}
		finally
		{
			/**
			 * Commented By amoghs;
			 * To handle the simultaneous execution of Item saving/mark for review/reset actions along with END TEST due to time up.
			 * This Session will clear on the GET of Score Card Page. 
			 */
			//SessionHelper.removeExamSetting(session);
		}
		return "Common/Exam/HiddenFrame";
	}

	/**
	 * Get method for Session Out
	 * @param request
	 * @param model
	 * @param response
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "/sessionOut")
	public String sessionOut(HttpServletRequest request, Model model,HttpServletResponse response) {
		model.addAttribute("isSessionOut", true);
		//reena :24 July 15 - Set to Default Locale after exam end
		try {
			examLocaleThemeResolver.setApplicationDefaultLocaleAndTheme(request, response);
		} catch (Exception e) {
			LOGGER.error("error while setting default Locale in sessionOut() : "+e);
		}
		return "Common/Exam/SessionOut";
	}
	
	/**
	 * Get method for Schedule Expired
	 * @param model
	 * @param request
	 * @param session
	 * @param response
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "/scheduleExpired", method = RequestMethod.GET)
	public String scheduleExpired(Model model, HttpServletRequest request,HttpSession session,HttpServletResponse response) {
		if (!SessionHelper.getLoginStatus(request)) {
			return "Common/Exam/SessionOut";
		}
		//remove exam settings from Session
		LoginType loginType =SessionHelper.getLoginType(request);
		model.addAttribute("loginType", loginType);
		//reena :24 July 15 - Set to Default Locale after exam end
		try {
			examLocaleThemeResolver.setApplicationDefaultLocaleAndTheme(request, response);
		} catch (Exception e) {
			LOGGER.error("error while setting default Locale in sessionOut() : "+e);
		}		
		//SessionHelper.removeExamSetting(session);
		return "Common/Exam/scheduleExpired";
	}
	
	/**
	 * Get method for Exam Error
	 * @param model
	 * @param request
	 * @param session
	 * @param response
	 * @return String this returns the path of a view or null on error
	 * @throws IOException
	 */
	@RequestMapping(value = "/ExamError", method = RequestMethod.GET)
	public String ExamError(Model model, HttpServletRequest request,HttpSession session,HttpServletResponse response) throws IOException {
		if (!SessionHelper.getLoginStatus(request)) {
			return "Common/Exam/SessionOut";
		}
		//remove exam settings from Session
		//SessionHelper.removeExamSetting(session);
		//reena :24 July 15 - Set to Default Locale after exam end
				try {
					examLocaleThemeResolver.setApplicationDefaultLocaleAndTheme(request, response);
				} catch (Exception e) {
					LOGGER.error("error while setting default Locale in sessionOut() : "+e);
				}
				if(SessionHelper.getIsSessionThirdParty(request))
				{
					model.addAttribute("oesPartnerMaster", new OESPartnerServiceImpl().getOESPartnerMaster(Long.parseLong(SessionHelper.getPartnerObject(request).get(GatewayConstants.PARTNERID))));
				}		
		response.sendError(HttpServletResponse.SC_FORBIDDEN,"");return null;
	}
	
	/**
	 * Get method for Already Attempted
	 * @param model
	 * @param request
	 * @param session
	 * @param response
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "/alreadyAttempted", method = RequestMethod.GET)
	public String alreadyAttempted(Model model, HttpServletRequest request,HttpSession session,HttpServletResponse response) {
		if (!SessionHelper.getLoginStatus(request)) {
			return "Common/Exam/SessionOut";
		}
		//remove exam settings from Session
		//SessionHelper.removeExamSetting(session);
		//reena :24 July 15 - Set to Default Locale after exam end
				try {
					examLocaleThemeResolver.setApplicationDefaultLocaleAndTheme(request, response);
				} catch (Exception e) {
					LOGGER.error("error while setting default Locale in sessionOut() : "+e);
				}
				if(SessionHelper.getIsSessionThirdParty(request))
				{
					model.addAttribute("oesPartnerMaster", new OESPartnerServiceImpl().getOESPartnerMaster(Long.parseLong(SessionHelper.getPartnerObject(request).get(GatewayConstants.PARTNERID))));
				}
		return "Common/Exam/alreadyAttempted";
	}
}
