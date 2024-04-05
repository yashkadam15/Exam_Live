package mkcl.oesclient.commons.controllers;

import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicHeader;
import org.apache.http.protocol.HTTP;
import org.apache.http.util.EntityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.ObjectWriter;

import mkcl.baseoesclient.model.EraResultTransferLog;
import mkcl.baseoesclient.model.LoginType;
import mkcl.baseoesclient.model.ResultPayload;
import mkcl.oesclient.commons.services.ExamEventServiceImpl;
import mkcl.oesclient.commons.services.ExamVenueActivationServicesImpl;
import mkcl.oesclient.commons.services.GatewayServicesImpl;
import mkcl.oesclient.commons.services.IExamEventService;
import mkcl.oesclient.commons.services.IGatewayServices;
import mkcl.oesclient.commons.services.ILoginService;
import mkcl.oesclient.commons.services.IOESPartnerService;
import mkcl.oesclient.commons.services.LoginServiceImpl;
import mkcl.oesclient.commons.services.OESPartnerServiceImpl;
import mkcl.oesclient.commons.services.PaperServiceImpl;
import mkcl.oesclient.commons.utilities.AppInfoHelper;
import mkcl.oesclient.commons.utilities.CustomGenericException;
import mkcl.oesclient.commons.utilities.FileUploadHelper;
import mkcl.oesclient.commons.utilities.GatewayConstants;
import mkcl.oesclient.model.Candidate;
import mkcl.oesclient.model.CandidateCollectionAssociation;
import mkcl.oesclient.model.CandidateExam;
import mkcl.oesclient.model.VenueUser;
import mkcl.oesclient.solo.services.BonusWeekServiceImpl;
import mkcl.oesclient.solo.services.CandidateExamServiceImpl;
import mkcl.oesclient.solo.services.CandidateServiceImpl;
import mkcl.oesclient.solo.services.IBonusWeekService;
import mkcl.oesclient.solo.services.ISchedulePaperAssociationServices;
import mkcl.oesclient.solo.services.SchedulePaperAssociationServicesImpl;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.oesclient.viewmodel.ExamDisplayCategoryPaperViewModel;
import mkcl.oesclient.viewmodel.LocalCandidateViewModel;
import mkcl.oespcs.model.AssessmentType;
import mkcl.oespcs.model.ExamEvent;
import mkcl.oespcs.model.ExamEventPaperDetails;
import mkcl.oespcs.model.ExamType;
import mkcl.oespcs.model.LocalSchedular;
import mkcl.oespcs.model.OESPartnerMaster;
import mkcl.oespcs.model.Paper;
import mkcl.oespcs.model.PaperType;
import mkcl.oespcs.model.ScheduleLocation;
import mkcl.oespcs.model.ScheduleType;

@Controller
@RequestMapping("gateway")
public class GatewayController {

	private static final Logger LOGGER = LoggerFactory.getLogger(GatewayController.class);
	
	public static CandidateExamServiceImpl candidateExamServiceImpl = new CandidateExamServiceImpl();

	/**
	 * Post method for Gateway Login
	 * @param model
	 * @param locale
	 * @param session
	 * @param response
	 * @param request
	 * @param epid
	 * @param code
	 * @param partnerID
	 * @param pcID
	 * @param sec_Marks
	 * @param candInfo
	 * @param itemID
	 * @param redirectAttributes
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/exam" }, method = RequestMethod.POST)
	public String gatewayLogin(Model model, Locale locale, HttpSession session,HttpServletResponse response, HttpServletRequest request, @RequestParam(GatewayConstants.EXEVPID) long epid, @RequestParam(GatewayConstants.CCODE) String code, @RequestParam(GatewayConstants.PARTNERID) long partnerID, @RequestParam(value=GatewayConstants.PCID, required = false) Long pcID, @RequestParam(value=GatewayConstants.SECMARKS, required = false) String sec_Marks, @RequestParam(value=GatewayConstants.CANDINFO, required = false) String candInfo, @RequestParam(value=GatewayConstants.ITEMID, required = false) Long itemID, RedirectAttributes redirectAttributes) {
		String[] errormsg = new String[1];
		try {
			// For klic test epid=0 and pcid and sm parameters required
			// For partner Id=1 and epid!=0 , ci required for locally candidate creation
			// For success paper type , itemId parameter required
			// For each exam epid, pid, ccode, itemId parameters are compulsory(epid and itemId can be zero in some cases)
			// ERA will send ci parameter in every case but only used when pid=1 and epid!=0			
			
			printRequestParameters(request);
			
			//epid=normal/typing paper
			//pcid=klic
			if (epid==0 && (pcID==null || pcID==0)) {
				errormsg[0] = "Encountered some difficulties with respect to configurations. Please conatct your Learning Facilitator.";
				LOGGER.error("Exception occured in gatewayLogin: " + errormsg[0]);
			}else{
				//Code For dynamic logo render:13-july-2015:Yograjs
				model.addAttribute("clientid", AppInfoHelper.appInfo.getClientID());
				model.addAttribute("isCopyRightEnabled", AppInfoHelper.appInfo.getIsCopyRightEnabled());
				IGatewayServices gatewarService = new GatewayServicesImpl();
				
				// Candidate
				CandidateServiceImpl candidateService = new CandidateServiceImpl();
				Candidate candidate = null;

				ExamEventPaperDetails examEventPaperDetails=null;
				IExamEventService examEventService = new ExamEventServiceImpl();
				
				// Code to check get candidate exam details when epid=0
				// Preconditions
				long paperId=0;
				ExamDisplayCategoryPaperViewModel examDisplayCategoryPaperViewModel=null;
				if (epid==0l) { // for klic exam

					// get paper if using PCID
					paperId=gatewarService.getPaperIdUsingProgramCourceId(pcID);

					// get candidate exam details using paper id and candidate id
					examDisplayCategoryPaperViewModel=gatewarService.getCandSchedDetailsForERAPgrmCrse(code, paperId);
					if (examDisplayCategoryPaperViewModel !=null) {
						examEventPaperDetails=examEventService.getExamEventPaperDetails(examDisplayCategoryPaperViewModel.getCandidateExam().getFkExamEventID(), paperId);
						
						//added by reena,required attributes from Exam event Paper Details for checking of Practice Paper.
						examDisplayCategoryPaperViewModel.setExamEventPaperDetails(examEventPaperDetails);
						candidate=examDisplayCategoryPaperViewModel.getCandidateExam().getCandidate();
					}					
				}else{				
					examEventPaperDetails = examEventService.getExamEventPaperDetailsFromID(epid);
					if (examEventPaperDetails !=null) {
						// Set IsLocalCandidate in session when partner is ERA and epid!=0
						if (partnerID==1 && epid !=0l) {
							SessionHelper.setIsLocalCandidate(session);
							// System.out.println(SessionHelper.getIsLocalPartner());
						}
						candidate=candidateService.getCandidate(code, examEventPaperDetails.getExamEventID());
						
						// For ERA Local Data generation
						// Generate Candidate and Exam local data for ERA
						// partnerID==1 && epid !=0l required, not support for PCID
						if (partnerID==1 && epid !=0l) {							
							boolean generateCandidate=true;
							
							// parse JSON
							LocalCandidateViewModel objCandidate=null;
							objCandidate=parseCandidateInfoJSON(candInfo);
							
							long candidateId=0l;
							// Generate Candidate
							if (candidate==null){								
								if (objCandidate !=null) {
									// Download candidate image
									if(objCandidate.getCandidatePhoto()!=null && !objCandidate.getCandidatePhoto().isEmpty()){
										objCandidate.setCandidatePhoto(downloadCandidateImage(objCandidate.getCandidatePhoto(), request));
									}
									generateCandidate=gatewarService.addCandidateDataToLocalCandidate(objCandidate, examEventPaperDetails.getExamEventID());
									if (generateCandidate==false) {
										errormsg[0] = "Issue in generating candidate data to Local";
										LOGGER.error("Issue in generating candidate data to Local for Candidate code:"+code+":" + errormsg[0]);
									}else{
										candidateId=objCandidate.getCandidateID();
										candidate=candidateService.getCandidate(code, examEventPaperDetails.getExamEventID());
									}
								}else{
									generateCandidate=false;
								}
								
							}else{
								candidateId=candidate.getCandidateID();
								// Each time update candidate data
								if (objCandidate !=null) {
									// Download candidate image
									if(objCandidate.getCandidatePhoto()!=null && !objCandidate.getCandidatePhoto().isEmpty()){
										objCandidate.setCandidatePhoto(downloadCandidateImage(objCandidate.getCandidatePhoto(), request));
									}
									gatewarService.updateCandidate(objCandidate);
								}
							}
							
							// Allocate paper to candidate
							if(generateCandidate){
								// Exam Event
								ExamEvent examEvent = examEventService.getExamEventByID(examEventPaperDetails.getExamEventID());
								if (examEvent.getStartDate()!=null && examEvent.getEndDate()!=null) {
									boolean schdlCreationStatus=gatewarService.createOrUpdateScheduleForEvent(examEventPaperDetails.getExamEventID());
									if (schdlCreationStatus) {
										boolean status=gatewarService.allocatePaperToCandidate(examEventPaperDetails.getExamEventID(), examEventPaperDetails.getFkPaperID(), candidateId, examEventPaperDetails.getNoOfAttempts(), examEventPaperDetails.getExamType());
										if (! status) {
											errormsg[0] = "Unable to allocate paper to candidate";
											LOGGER.error("Exception occured in allocate Paper To Local Candidate");
										}
									}else{
										errormsg[0] = "Unable to create schedule for paper";
										LOGGER.error("Exception occured in creating schedule");
									}
								}else{
									errormsg[0] = "Please synchronize exam event data";
									LOGGER.error("Please synchronize exam event data: " + examEventPaperDetails.getExamEventID());
								}
								
							}
						}
					}
				}
				
					if (examEventPaperDetails != null) {
						if (candidate !=null) {
						// compare paper delivery through
						// 0 : OES
						// 1 : ERA
						// 2 : OS
						if (partnerID != 0) {
							if (examEventPaperDetails.getPaperDeliveredThrough() == partnerID) {					

								// other optional parameters
								Object object = getOptinalRequestParameters(request, errormsg);
								if (object != null) {
									// create user session
									createLoginSession(candidate, examEventPaperDetails.getExamEventID(), examEventPaperDetails.getFkPaperID(), object, errormsg,LoginType.Solo,request, response);
									ExamEvent examEvent = SessionHelper.getExamEvent(request); //added by reena for enabling new setting IsExamClientRequired for particular event
									if (examEvent.getStartDate()!=null && examEvent.getEndDate()!=null) {
										String redirecturl=null;

										PaperServiceImpl paperServiceImpl =new PaperServiceImpl();
										Paper paperObj=paperServiceImpl.getpaperByPaperID(examEventPaperDetails.getFkPaperID());
										if (epid==0) {
											// Support not available for typing type papers and DifficultyLevelWiseExam(MSCIT) papers in Klic Exam events
											redirecturl=getExamPaperAllocatedToUserERAPprCrse(request, examDisplayCategoryPaperViewModel,paperId, object, errormsg);
										}else{
											// do not do substring here,as done in below elseif(.....DifficultyLevelWiseExam)block,this url is created as expected.
											if (paperObj.getPaperType().equals(PaperType.Typing)) {
												redirecturl = getExamTypingPaperAllocatedToUser(request, examEventPaperDetails, object, errormsg);
												redirectAttributes.addFlashAttribute("turl", redirecturl);
												redirectAttributes.addFlashAttribute("opnTyp", "1");
												redirectAttributes.addFlashAttribute("errorMsg", errormsg[0]);

												return "redirect:/gateway/GatewayTypingAuth";
											}else if (paperObj.getPaperType().equals(PaperType.DifficultyLevelWiseExam)) //added by reena for MSCIT Exam
											{											
												redirecturl = getExamPaperAllocatedToUser(request, examEventPaperDetails, object, errormsg);
												// only http requests come here,not "typ" or "prt"
												// did substring in order to remove "redirect:" keyword  from redirecturl and to make it valid URL like "../exam/authen"
												if (redirecturl !=null) {
													redirecturl=redirecturl.substring(9);
													redirectAttributes.addFlashAttribute("turl", ".."+redirecturl);
													redirectAttributes.addFlashAttribute("opnTyp", "1");
													redirectAttributes.addFlashAttribute("errorMsg", errormsg[0]);
													return "redirect:/gateway/GatewayTypingAuth";
												}
											}else if (paperObj.getPaperType().equals(PaperType.Success)) {
												if (itemID != null && itemID !=0) {
													redirecturl = getExamURLforSuccess(request, examEventPaperDetails, itemID, object, errormsg);
												}else{
													LOGGER.error("Item Id not available for success paper");
													errormsg[0] = "Sorry, this is an invalid request for paper";
												}											
											}else{
												//get Paper allocated to candidate
												redirecturl = getExamPaperAllocatedToUser(request, examEventPaperDetails, object, errormsg);
											}
										}

										if (redirecturl != null) {
											if(examEvent.getIsExamClientRequired()==true)
											{
												// only http requests come here,not "typ" or "prt"
												// did substring in order to remove "redirect:" keyword  from redirecturl and to make it valid URL like "../exam/authen"
												if (redirecturl !=null) {
													redirecturl=redirecturl.substring(9);
													redirectAttributes.addFlashAttribute("turl", ".."+redirecturl);
													redirectAttributes.addFlashAttribute("opnTyp", "1");
													redirectAttributes.addFlashAttribute("errorMsg", errormsg[0]);
													return "redirect:/gateway/GatewayTypingAuth";
												}
											}
											else
											{
												// do not do substring here,as done in if block,this url is created as expected.
												return redirecturl;
											}
											
										}
									}else{
										errormsg[0] = "Please synchronize exam event data";
										LOGGER.error("Please synchronize exam event data: " + examEventPaperDetails.getExamEventID());
									}	
								}
								// TODO: check if object is null
								else
								{
									//what to through to user
								}
							} else {
								errormsg[0] = "We have identified a configuration mismatch for Paper "+examEventPaperDetails.getFkPaperID()+". Please conatct your Learning Facilitator.";
								LOGGER.error("Exception occured in gatewayLogin: " + errormsg[0]);
							}
						} else {
							errormsg[0] = "Sorry, this is an invalid request.  Please conatct your Learning Facilitator.";
							LOGGER.error("Exception occured in gatewayLogin: " + errormsg[0]);
						}
					} else {
						errormsg[0] = "Candidate not found. Please conatct your Learning Facilitator.";
						LOGGER.error("Exception occured in gatewayLogin: " + errormsg[0]);
					}
				}else{
					errormsg[0] = "This Paper is either attempted or currently not configured. Please conatct your Learning Facilitator.";
					LOGGER.error("Exception occured in gatewayLogin: " + errormsg[0]);
					
				}
				gatewarService=null;
			}
			
		} catch (Exception e) {
			LOGGER.error("Exception occured in gatewayLogin: ", e);
			errormsg[0]="Exception occured in gatway login.";

		}
		throw new CustomGenericException("OES GATEWAY ERROR", errormsg[0]);
	}
	
	/**
	 * Method for Print Request Parameters
	 * @param request
	 */
	private void printRequestParameters(HttpServletRequest request){
		// Code to log display parameters
		/*LOGGER.error("====================Info Gateway Exam: " + GatewayConstants.EXEVPID+":"+epid+","+ GatewayConstants.CCODE+":"+code+","+GatewayConstants.PARTNERID+":"+partnerID+","+GatewayConstants.PCID+":"+pcID+","+GatewayConstants.SECMARKS+":"+sec_Marks+"===========================");*/
		try {
			String parametersDetails="====================Info Gateway Exam: ";
			Map<String, String> paramertsMap=new HashMap<String, String>();
			if (request.getParameterMap() != null && !request.getParameterMap().isEmpty()) {
				Iterator it = request.getParameterMap().entrySet().iterator();
				while (it.hasNext()) {
					Entry<String, String[]> entry = (Entry<String, String[]>) it.next();
					paramertsMap.put(entry.getKey(), entry.getValue()[0].toString());
				}
			}
			LOGGER.error(parametersDetails+paramertsMap);
		} catch (Exception e) {
			LOGGER.error("Unable to print request parameters");
		}
	}

	/**
	 * Method to parse Candidate Info JSON
	 * @param candidateInfo
	 * @return LocalCandidateViewModel this returns the LocalCandidateViewModel
	 */
	private LocalCandidateViewModel parseCandidateInfoJSON(String candidateInfo){
		LocalCandidateViewModel localCandidateViewModel=null;
		try {
			// Create candidate using JSON From ERA			
			ObjectMapper mapper = new ObjectMapper(); 
			TypeReference<LocalCandidateViewModel> typeRef = new TypeReference<LocalCandidateViewModel>(){};

			localCandidateViewModel = mapper.readValue(candidateInfo, typeRef);
			if (localCandidateViewModel !=null && localCandidateViewModel.getCandidateGender()!=null && ! localCandidateViewModel.getCandidateGender().isEmpty()) {
				if (localCandidateViewModel.getCandidateGender().equalsIgnoreCase("Male") || localCandidateViewModel.getCandidateGender().equalsIgnoreCase("M")) {
					localCandidateViewModel.setCandidateGender("M");
				}else if (localCandidateViewModel.getCandidateGender().equalsIgnoreCase("Female") || localCandidateViewModel.getCandidateGender().equalsIgnoreCase("F")) {
					localCandidateViewModel.setCandidateGender("F");
				}else if(localCandidateViewModel.getCandidateGender().equalsIgnoreCase("Transgender") || localCandidateViewModel.getCandidateGender().equalsIgnoreCase("T")){
					localCandidateViewModel.setCandidateGender("T");
				}else{
					localCandidateViewModel.setCandidateGender("M");
				}
			}
		} catch (Exception e) {
			LOGGER.error("Error in parsing JSON: ", e);
			return null;
		}
		return localCandidateViewModel;
	}
	
	/**
	 * Get method for Gateway Typing Authorization
	 * @param model
	 * @param request
	 * @param session
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/GatewayTypingAuth" }, method = RequestMethod.GET)
	public String GatewayTypingAuth(Model model, HttpServletRequest request, HttpSession session) {	
		String url=null;
		String opnTyp=null;
		String errorMsg=null;

		//Code For dynamic logo render:13-july-2015:Yograjs
		model.addAttribute("clientid", AppInfoHelper.appInfo.getClientID());
		model.addAttribute("isCopyRightEnabled", AppInfoHelper.appInfo.getIsCopyRightEnabled());
		String temp=request.getParameter("abc");
		// System.out.println("Here"+temp);

		
		Map<String, ?> inputFlashMap = RequestContextUtils.getInputFlashMap(request);
		if (inputFlashMap != null) {
			url=(String) inputFlashMap.get("turl");
			opnTyp=(String) inputFlashMap.get("opnTyp");
			errorMsg=(String) inputFlashMap.get("errorMsg");
		}

		getOESPartner(model, request);

		// Get App Info
		model.addAttribute("webVersion", AppInfoHelper.appInfo.getWebVersion());

		model.addAttribute("turl", url);
		model.addAttribute("opnTyp", opnTyp);
		model.addAttribute("errorMsg", errorMsg);

		return "Solo/candidateModule/GatewayTypingAuth";

	}

	/**
	 * Get method for Gateway Logout (Back to Partner)
	 * @param model
	 * @param request
	 * @param session
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/backtopartner" }, method = RequestMethod.GET)
	public String gatewayLogout(Model model, HttpServletRequest request, HttpSession session) {
		String returnUrl = null;
		String[] errormsg = new String[1];
		//Code For dynamic logo render:13-july-2015:Yograjs
		model.addAttribute("clientid", AppInfoHelper.appInfo.getClientID());
		model.addAttribute("isCopyRightEnabled", AppInfoHelper.appInfo.getIsCopyRightEnabled());
		try {		
			if (SessionHelper.getPartnerObject(request) != null) {
				returnUrl = SessionHelper.getPartnerObject(request).get(GatewayConstants.RETURNURL);
				Map<String, String> holderObjectMap = new HashMap<String, String>();
				holderObjectMap.putAll(SessionHelper.getPartnerObject(request));

				LOGGER.error("=====================Info Back To ERA: " + holderObjectMap+"=======================");

				model.addAttribute("sesObject", holderObjectMap);
			} else {
				errormsg[0] = "Unable to find partner Object in session";
				LOGGER.error("Exception occured in gatewayLogout: " + errormsg[0]);
			}
			// redirect to return application
			if (returnUrl != null && !returnUrl.isEmpty()) {
				model.addAttribute("returnUrl", returnUrl);
				return "Common/login/closegateway";
			} else {
				errormsg[0] = "Unable to find partner's return url to redirect";
				LOGGER.error("Exception occured in gatewayLogout: " + errormsg[0]);
			}
		} catch (Exception e) {
			errormsg[0] ="Exception occured in gateway Logout"; //e.getMessage();
			LOGGER.error("Exception occured in gatewayLogout: " + errormsg[0]);
		} finally {
			// close session
			SessionHelper.removeSession(session);
		}
		throw new CustomGenericException("OES GATEWAY ERROR", errormsg[0]);
	}

	/**
	 * Method to Create Login Session 
	 * @param candidate
	 * @param examEventID
	 * @param paperID
	 * @param object
	 * @param errormsg
	 * @param loginType
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	private void createLoginSession(Candidate candidate, long examEventID, long paperID, Object object, String[] errormsg, LoginType loginType, HttpServletRequest request, HttpServletResponse response) throws Exception {

		if (candidate != null) {
			// Venue User
			ILoginService loginService = new LoginServiceImpl();
			VenueUser dbUser = loginService.getCandidateByUsernameEventID(candidate.getCandidateUserName(), examEventID);

			if (dbUser != null) {				
				// candidateID
				dbUser.setObject(candidate.getCandidateID());
				List<VenueUser> venueUserList = new ArrayList<VenueUser>();
				venueUserList.add(dbUser);

				// Exam Event
				IExamEventService examEventService = new ExamEventServiceImpl();
				ExamEvent examEvent = examEventService.getExamEventByID(examEventID);

				// Candidate Collection Association
				CandidateServiceImpl candidateService = new CandidateServiceImpl();
				CandidateCollectionAssociation candidateCollectionAssociation = candidateService.getCandidateCollectionAssociationByEventAndCandidateID(examEvent.getExamEventID(), candidate.getCandidateID());

				// add optional data in session
				Object extraParameters = object;

				// create User Session
				SessionHelper.SetSession(examEvent, loginType, venueUserList, null, candidateCollectionAssociation.getFkCollectionID(), extraParameters, request, response);

				// update Login details
				loginService.updateLastLoginDeatilsByUserId(dbUser.getUserID(),OESLogger.getHostAddress(request),loginType);

			} else {
				errormsg[0] = "Unable to find user login details for this exam";
				LOGGER.error("Exception occured in createLoginSession: " + errormsg[0]);
			}
		} else {
			errormsg[0] = "Unable to find candidate details for this exam";
			LOGGER.error("Exception occured in createLoginSession: " + errormsg[0]);
		}
	}

	/**
	 * Method to fetch the Exam Paper Allocated to User
	 * @param req
	 * @param examEventPaperDetails
	 * @param object
	 * @param errormsg
	 * @return String this returns the path of a view
	 */
	private String getExamPaperAllocatedToUser(HttpServletRequest req, ExamEventPaperDetails examEventPaperDetails , Object object, String[] errormsg) {

		ExamEvent examEvent = SessionHelper.getExamEvent(req);
		Candidate candidate = SessionHelper.getCandidate(req);
		long collectionID = SessionHelper.getCollectionID(req);
		String redirecturl = null;
		long paperID = examEventPaperDetails.getFkPaperID();
		ExamDisplayCategoryPaperViewModel viewModel = null;
		if(examEvent != null && candidate != null && collectionID != 0l){
			// candidate paper details
			IGatewayServices gatewarService = new GatewayServicesImpl();

			//10 June 2016 :added by Reena for Practice Paper : Practice Paper can be scheduled CENTRAL only
			//ExamDisplayCategoryPaperViewModel viewModel and collectionID will have no values in this case,hence passed null and 0l
			if(examEventPaperDetails.getExamType()==ExamType.Practice)
			{
					gatewarService=null;
					redirecturl= ValidatePracticePaper(req,null,examEventPaperDetails,object, errormsg, examEvent, paperID,candidate.getCandidateID(),collectionID,0l);
			
			}else if(SessionHelper.getIsLocalCandidate()){
				viewModel = gatewarService.getScheduledPaperForLocalCandidate(examEvent.getExamEventID(), paperID, candidate.getCandidateID(), collectionID);

				if (viewModel != null) {

					//check that paper is already completed
					if (viewModel.getCandidateExam().getIsExamCompleted()==null || viewModel.getCandidateExam().getIsExamCompleted()== false) {

						//check for paper is not expired
						if (viewModel.getExpiryDate() != null) {

							// redirect to exam instruction page
							redirecturl = "redirect:/gateway/Authentication?ceid=" + viewModel.getCandidateExam().getCandidateExamID() + "&se=" + viewModel.getExpiryDate().getTime();
						} else {

							errormsg[0] = "Schedule for the selected Paper has been expired.";
							// Schedule for the selected Paper has been expired.
							LOGGER.error("Exception occured in getExamPaperAllocatedToUser: " + errormsg[0]);
						}
					} else {
						
						// redirect to exam result page
						redirecturl = "redirect:/endexam/showTestResult?ceid=" + viewModel.getCandidateExam().getCandidateExamID() + "&examEventID=" + examEvent.getExamEventID() + "&paperID=" + paperID + "&attemptNo="+ viewModel.getCandidateExam().getAttemptNo();
					}

				} else {
					errormsg[0] = "Schedule not found for the selected Paper.";
					// Schedule not found for the selected Paper.
					LOGGER.error("Exception occured in getExamPaperAllocatedToUser: " + errormsg[0]);
				}
			}
			else // MAIN PAPER Block,kept as it is
			{	
				//ExamEvent LocalScheduler     - 1 (Candidate)
				//ExamEventPD ScheduleLoaction - 1 (Local)
				//Both condition jointly decides that Paper is Scheduled by Candidate
				//otherwise Scheduled by Admin
				
				if(examEvent.getLocalSchedular() == LocalSchedular.Candidate && examEventPaperDetails.getScheduleLocation() == ScheduleLocation.Local){
					viewModel = gatewarService.getCandidateScheduledPaperFromPaperID(examEvent.getExamEventID(), paperID, candidate.getCandidateID(), collectionID);

					if (viewModel != null) {

						//Exam status :New/Incomplete - redirect to Exam Instruction Page if Paper Schedule not expired.
						if (viewModel.getCandidateExam().getIsExamCompleted()==null || viewModel.getCandidateExam().getIsExamCompleted()== false) {

							// In this case Candidate has already scheduled the test,i.e, Exam status :Incomplete and Not expired
							if (viewModel.getExpiryDate() != null) {

								redirecturl = "redirect:/gateway/Authentication?ceid=" + viewModel.getCandidateExam().getCandidateExamID() + "&se=" + viewModel.getExpiryDate().getTime();
							} 
							// In this case Candidate has not scheduled the test,i.e, Exam status :New and Not expired and Attempt==1
							else if(viewModel.getExpiryDate() == null && viewModel.getCandidateExam().getIsExamCompleted()==null && viewModel.getCandidateExam().getAttemptNo()==1)
							{
								if (viewModel.getCandidateExam() != null) {
									ISchedulePaperAssociationServices schedulePaperAssociationServices = new SchedulePaperAssociationServicesImpl();
									IBonusWeekService bonusWeekService = new BonusWeekServiceImpl();
									long currentScheduleID = schedulePaperAssociationServices.getTodaysScheduleIdByScheduleType(ScheduleType.Week, examEvent.getExamEventID());
									Map<Long, Long> displayCategoryWiseAttemptsMap = bonusWeekService.getCandidateDisplayCategoryAttemptDetails(candidate.getCandidateID(), examEvent.getExamEventID(), currentScheduleID);

									// check bonus week remaining for display category
									if(displayCategoryWiseAttemptsMap!=null && displayCategoryWiseAttemptsMap.containsValue(viewModel.getDisplayCategoryLanguage().getFkDisplayCategoryID()))
									{

										redirecturl = "redirect:/gateway/Authentication?ceid=" + viewModel.getCandidateExam().getCandidateExamID() + "&dcid=" + viewModel.getDisplayCategoryLanguage().getFkDisplayCategoryID()+"&b=false";

									}
									else
									{
										redirecturl = "redirect:/gateway/Authentication?ceid=" + viewModel.getCandidateExam().getCandidateExamID() + "&dcid=" + viewModel.getDisplayCategoryLanguage().getFkDisplayCategoryID()+"&b=true";	
									}
								}
							}
							// In this case Candidate has come for re-attempt,i.e, Exam status :re-attempt and Not expired
							else if(viewModel.getExpiryDate() == null && viewModel.getCandidateExam().getIsExamCompleted()==null )
							{
								redirecturl = "redirect:/gateway/Authentication?ceid=" + viewModel.getCandidateExam().getCandidateExamID() + "&dcid=" + viewModel.getDisplayCategoryLanguage().getFkDisplayCategoryID();
							}
							// Expired Paper
							else {

								errormsg[0] = "Schedule for the selected Paper has been expired.";
								// Schedule for the selected Paper has been expired.
								LOGGER.error("Exception occured in getExamPaperAllocatedToUser: " + errormsg[0]);
							}


						}
						//Exam status :Complete -redirect to exam result page
						else {

							redirecturl = "redirect:/endexam/showTestResult?ceid=" + viewModel.getCandidateExam().getCandidateExamID() + "&examEventID=" + examEvent.getExamEventID() + "&paperID=" + paperID + "&attemptNo="+ viewModel.getCandidateExam().getAttemptNo();
						}

					} else {
						errormsg[0] = "Schedule not found for the selected Paper.";
						LOGGER.error("Exception occured in getExamPaperAllocatedToUser: " + errormsg[0]);
					}

				} 
				////Scheduled by Admin(Centrally or Locally)
				else {
					viewModel = gatewarService.getScheduledPaperFromPaperID(examEvent.getExamEventID(), paperID, candidate.getCandidateID(), collectionID);

					if (viewModel != null) {

						//check that paper is already completed
						if (viewModel.getCandidateExam().getIsExamCompleted()==null || viewModel.getCandidateExam().getIsExamCompleted()== false) {

							//check for paper is not expired
							if (viewModel.getExpiryDate() != null) {

								// redirect to exam instruction page
								redirecturl = "redirect:/gateway/Authentication?ceid=" + viewModel.getCandidateExam().getCandidateExamID() + "&se=" + viewModel.getExpiryDate().getTime();
							} else {

								errormsg[0] = "Schedule for the selected Paper has been expired.";
								// Schedule for the selected Paper has been expired.
								LOGGER.error("Exception occured in getExamPaperAllocatedToUser: " + errormsg[0]);
							}
						} else {
							
							// redirect to exam result page
							redirecturl = "redirect:/endexam/showTestResult?ceid=" + viewModel.getCandidateExam().getCandidateExamID() + "&examEventID=" + examEvent.getExamEventID() + "&paperID=" + paperID + "&attemptNo="+ viewModel.getCandidateExam().getAttemptNo();
						}

					} else {
						errormsg[0] = "Schedule not found for the selected Paper.";
						// Schedule not found for the selected Paper.
						LOGGER.error("Exception occured in getExamPaperAllocatedToUser: " + errormsg[0]);
					}
				}
				gatewarService=null;
			}
		
		} else {
			errormsg[0] = "Unable to start Paper, error in session creation.";
			// Unable to start Paper, error in session creation.
			LOGGER.error("Exception occured in getExamPaperAllocatedToUser: " + errormsg[0]);
		}
		return redirecturl;
	}
	
	/**
	 * Method to fetch Exam URL for SUCCESS
	 * @param req
	 * @param examEventPaperDetails
	 * @param itemID
	 * @param object
	 * @param errormsg
	 * @return String this returns the path of a view
	 */
	private String getExamURLforSuccess(HttpServletRequest req, ExamEventPaperDetails examEventPaperDetails , long itemID, Object object, String[] errormsg) {

		ExamEvent examEvent = SessionHelper.getExamEvent(req);
		Candidate candidate = SessionHelper.getCandidate(req);
		long collectionID = SessionHelper.getCollectionID(req);
		String redirecturl = null;
		long paperID = examEventPaperDetails.getFkPaperID();
		ExamDisplayCategoryPaperViewModel viewModel = null;
		if(examEvent != null && candidate != null && collectionID != 0l){
			// candidate paper details
			IGatewayServices gatewarService = new GatewayServicesImpl();

			viewModel = gatewarService.getScheduledPaperForLocalCandidate(examEvent.getExamEventID(), paperID, candidate.getCandidateID(), collectionID);

			if (viewModel != null) {

				//check that paper is already completed
				if (viewModel.getCandidateExam().getIsExamCompleted()==null || viewModel.getCandidateExam().getIsExamCompleted()== false) {

					//check for paper is not expired
					if (viewModel.getExpiryDate() != null) {

						// redirect to exam instruction page
						redirecturl = "redirect:/ComponentExam/TakeTest?ceid=" + viewModel.getCandidateExam().getCandidateExamID() + "&se=" + viewModel.getExpiryDate().getTime()+ "&itemID="+itemID;
					} else {

						errormsg[0] = "Schedule for the selected Paper has been expired.";
						// Schedule for the selected Paper has been expired.
						LOGGER.error("Exception occured in getExamPaperAllocatedToUser: " + errormsg[0]);
					}
				} else {
					
					// redirect to exam result page
					redirecturl = "redirect:/endexam/showTestResult?ceid=" + viewModel.getCandidateExam().getCandidateExamID() + "&examEventID=" + examEvent.getExamEventID() + "&paperID=" + paperID + "&attemptNo="+ viewModel.getCandidateExam().getAttemptNo();
				}

			} else {
				errormsg[0] = "Schedule not found for the selected Paper.";
				// Schedule not found for the selected Paper.
				LOGGER.error("Exception occured in getExamPaperAllocatedToUser: " + errormsg[0]);
			}
		} else {
			errormsg[0] = "Unable to start Paper, error in session creation.";
			// Unable to start Paper, error in session creation.
			LOGGER.error("Exception occured in getExamPaperAllocatedToUser: " + errormsg[0]);
		}
		return redirecturl;
	}

	/**
	 * Method to fetch the Exam Typing Paper Allocated to User
	 * @param req
	 * @param examEventPaperDetails
	 * @param object
	 * @param errormsg
	 * @return String this returns the path of a view
	 */
	private String getExamTypingPaperAllocatedToUser(HttpServletRequest req, ExamEventPaperDetails examEventPaperDetails , Object object, String[] errormsg) {

		ExamEvent examEvent = SessionHelper.getExamEvent(req);
		Candidate candidate = SessionHelper.getCandidate(req);
		//un-commented by Reena to use for practice paper
		long collectionID = SessionHelper.getCollectionID(req);
		String redirecturl = null;
		long paperID = examEventPaperDetails.getFkPaperID();
		ExamDisplayCategoryPaperViewModel viewModel = null;
		if(examEvent != null && candidate != null){
			// candidate paper details
			IGatewayServices gatewarService = new GatewayServicesImpl();
			// check for paper availble for candidate
			CandidateExamServiceImpl candidateExamServiceImplObj=new CandidateExamServiceImpl();
			boolean isPaperForcandidate=candidateExamServiceImplObj.getPaperAssToCandidate(examEvent.getExamEventID(), paperID, candidate.getCandidateID());
			//isPaperForcandidate=false;
			if (isPaperForcandidate) {	
				// Code to get client Id
				ExamVenueActivationServicesImpl examVenueActivationServicesImpl=new ExamVenueActivationServicesImpl();
				long clientId=examVenueActivationServicesImpl.getExamVenueClientID();
				
				//10 June 2016 :added by Reena for Practice Paper : Practice Paper can be scheduled CENTRAL only
				//viewModel will have no value in this case,hence passed null
				if(examEventPaperDetails.getExamType()==ExamType.Practice)
				{
						gatewarService=null;
						redirecturl= ValidatePracticePaper( req, null,examEventPaperDetails,object, errormsg, examEvent, paperID,candidate.getCandidateID(),collectionID,clientId);

				}else if(SessionHelper.getIsLocalCandidate()){
					viewModel = gatewarService.getScheduledPaperForLocalCandidate(examEvent.getExamEventID(), paperID, candidate.getCandidateID(), collectionID);

					if (viewModel != null) {

						//check that paper is already completed
						if (viewModel.getCandidateExam().getIsExamCompleted()==null || viewModel.getCandidateExam().getIsExamCompleted()== false) {

							//check for paper is not expired
							if (viewModel.getExpiryDate() != null) {

								// redirect to exam instruction page
								//redirecturl = "redirect:/exam/Authentication?ceid=" + viewModel.getCandidateExam().getCandidateExamID() + "&se=" + viewModel.getExpiryDate().getTime();
								redirecturl = "typ:url?ceid=" + viewModel.getCandidateExam().getCandidateExamID() + "&se=" + viewModel.getExpiryDate().getTime() +"&clientid=" + clientId+"&sessionId="+req.getSession().getId();
							} else {

								errormsg[0] = "Schedule for the selected Paper has been expired.";
								// Schedule for the selected Paper has been expired.
								LOGGER.error("Exception occured in getExamPaperAllocatedToUser: " + errormsg[0]);
							}
						} else {
							// redirect to exam result page
							errormsg[0] = "You have already attempted this Paper.";
							LOGGER.error("Exception occured in getExamTypingPaperAllocatedToUser: " + errormsg[0]);
							//redirecturl = "redirect:/endexam/showTestResult?ceid=" + viewModel.getCandidateExam().getCandidateExamID() + "&examEventID=" + examEvent.getExamEventID() + "&paperID=" + paperID + "&attemptNo="+ viewModel.getCandidateExam().getAttemptNo();
						}
					}
				}else // MAIN PAPER Block,kept as it is
				{
					// get candidate exam details
					// if current date exist within schedule date then expiry date get selected 
					// other wise expiry date will be null
					// Get schedule id selected for current date schedule
					if(examEvent.getLocalSchedular() == LocalSchedular.Candidate && examEventPaperDetails.getScheduleLocation() == ScheduleLocation.Local){
						viewModel = gatewarService.getCandidateScheduledDetailsForTypingPpr(examEvent.getExamEventID(), paperID, candidate.getCandidateID());
						if (viewModel != null) {						

							if (viewModel.getCandidateExam().getFkSchedulePaperAssociationID()>0) {
								// if current date exist in paper scheduled date
								if (viewModel.getExpiryDate()!=null) {
									redirecturl = "typ:url?ceid=" + viewModel.getCandidateExam().getCandidateExamID() + "&se=" + viewModel.getExpiryDate().getTime() +"&clientid=" + clientId;
								}else{
									// if current date not belong to paper scheduled date
									gatewarService.updatePprSchedule(viewModel.getCandidateExam().getFkSchedulePaperAssociationID(), viewModel.getScheduleMaster().getScheduleID());
									Date scheduleEndDate=gatewarService.getScheduleEndDate(viewModel.getScheduleMaster().getScheduleID());
									if (scheduleEndDate !=null) {
										redirecturl = "typ:url?ceid=" + viewModel.getCandidateExam().getCandidateExamID() + "&se=" +scheduleEndDate.getTime() +"&clientid=" + clientId;
									}
								}
							}else{
								// for new schedule
								redirecturl = "typ:url?ceid=" + viewModel.getCandidateExam().getCandidateExamID() + "&dcid=" + viewModel.getDisplayCategoryLanguage().getFkDisplayCategoryID() +"&clientid=" + clientId;
							}
						} else {
							errormsg[0] = "You have already completed all the allowed attempts for this Paper.";
							LOGGER.error("Exception occured in getExamTypingPaperAllocatedToUser: " + errormsg[0]);
						}
					}
					else
					{
						viewModel = gatewarService.getScheduledPaperFromPaperID(examEvent.getExamEventID(), paperID, candidate.getCandidateID(), collectionID);

						if (viewModel != null) {

							//check that paper is already completed
							if (viewModel.getCandidateExam().getIsExamCompleted()==null || viewModel.getCandidateExam().getIsExamCompleted()== false) {

								//check for paper is not expired
								if (viewModel.getExpiryDate() != null) {

									// redirect to exam instruction page
									//redirecturl = "redirect:/exam/Authentication?ceid=" + viewModel.getCandidateExam().getCandidateExamID() + "&se=" + viewModel.getExpiryDate().getTime();
									redirecturl = "typ:url?ceid=" + viewModel.getCandidateExam().getCandidateExamID() + "&se=" + viewModel.getExpiryDate().getTime() +"&clientid=" + clientId;
								} else {

									errormsg[0] = "Schedule for the selected Paper has been expired.";
									// Schedule for the selected Paper has been expired.
									LOGGER.error("Exception occured in getExamPaperAllocatedToUser: " + errormsg[0]);
								}
							} else {
								// redirect to exam result page
								errormsg[0] = "You have already attempted this Paper.";
								LOGGER.error("Exception occured in getExamTypingPaperAllocatedToUser: " + errormsg[0]);
								//redirecturl = "redirect:/endexam/showTestResult?ceid=" + viewModel.getCandidateExam().getCandidateExamID() + "&examEventID=" + examEvent.getExamEventID() + "&paperID=" + paperID + "&attemptNo="+ viewModel.getCandidateExam().getAttemptNo();
							}

						} else {
							errormsg[0] = "Schedule not found for the selected Paper.";
							// Schedule not found for the selected Paper.
							LOGGER.error("Exception occured in getExamPaperAllocatedToUser: " + errormsg[0]);
						}
					}
					
					gatewarService=null;
					
				}

				
			}else{
				errormsg[0] = "This Paper "+paperID+" is currently not allocated to you. Please conatct your Learning Facilitator.";
				LOGGER.error("Exception occured in getExamTypingPaperAllocatedToUser: " + errormsg[0]);
			}

		} else {
			errormsg[0] = "Unable to start Paper, error in session creation.";
			LOGGER.error("Exception occured in getExamTypingPaperAllocatedToUser: " + errormsg[0]);
		}
		return redirecturl;
	}


// KLIC Paper
	/**
	 * Method to fetch the Exam Paper Allocated to User ERA Paper Coursse
	 * @param req
	 * @param viewModel
	 * @param paperID
	 * @param object
	 * @param errormsg
	 * @return String this returns the path of a view
	 */
	private String getExamPaperAllocatedToUserERAPprCrse(HttpServletRequest req, ExamDisplayCategoryPaperViewModel viewModel ,long paperID, Object object, String[] errormsg) {

		ExamEvent examEvent = SessionHelper.getExamEvent(req);
		Candidate candidate = SessionHelper.getCandidate(req);
		long collectionID = SessionHelper.getCollectionID(req);
		String redirecturl = null;		
		if(examEvent != null && candidate != null && collectionID != 0l){
			// candidate paper details					

			if (viewModel != null) {
				
				//10 June 2016 :added by Reena for Practice Paper : Practice Paper can be scheduled CENTRAL only
				//ExamEventPaperDetails examEventPaperDetails and collectionID will have no values in this case,hence passed null and 0l
				if(viewModel.getExamEventPaperDetails().getExamType()==ExamType.Practice)
				{
					redirecturl=ValidatePracticePaper(req, viewModel,null,object, errormsg, examEvent, paperID,candidate.getCandidateID(),collectionID,0l);
				}
				else // MAIN PAPER Block,kept as it is
				{
					//check that paper is already completed
					if (viewModel.getCandidateExam().getIsExamCompleted()==null || viewModel.getCandidateExam().getIsExamCompleted()== false) {

						//check for paper is not expired
						if (viewModel.getExpiryDate() != null) {

							// redirect to exam instruction page
							redirecturl = "redirect:/gateway/Authentication?ceid=" + viewModel.getCandidateExam().getCandidateExamID() + "&se=" + viewModel.getExpiryDate().getTime();
						} else {

							errormsg[0] = "Schedule for the selected Paper has been expired.";
							// Schedule for the selected Paper has been expired.
							LOGGER.error("Exception occured in getExamPaperAllocatedToUser: " + errormsg[0]);
						}
					} else {
						// redirect to exam result page
						redirecturl = "redirect:/endexam/showTestResult?ceid=" + viewModel.getCandidateExam().getCandidateExamID() + "&examEventID=" + examEvent.getExamEventID() + "&paperID=" + paperID + "&attemptNo="+ viewModel.getCandidateExam().getAttemptNo();
					}
				}		

			} else {
				errormsg[0] = "Schedule not found for the selected Paper.";
				// Schedule not found for the selected Paper.
				LOGGER.error("Exception occured in getExamPaperAllocatedToUser: " + errormsg[0]);
			}

		} else {
			errormsg[0] = "Unable to start Paper, error in session creation.";
			// Unable to start Paper, error in session creation.
			LOGGER.error("Exception occured in getExamPaperAllocatedToUser: " + errormsg[0]);
		}
		return redirecturl;
	}

	/**
	 * Exception handler to show runtime custom error messages
	 * 
	 * @param e
	 * @return String this returns an error page
	 */
	@ExceptionHandler(CustomGenericException.class)
	//@ResponseBody
	public String errorHandler(CustomGenericException e) {
		//return "<b>" + e.getErrorCode() + " : " + e.getErrorMessage() + "</b>";
		return "redirect:errorMsg?msg="+e.getErrorMessage();
	}

	/**
	 * Get method for Show Error Messages
	 * @param model
	 * @param locale
	 * @param session
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/errorMsg" }, method = RequestMethod.GET)
	public String showErrorMessages(Model model, Locale locale, HttpSession session, HttpServletRequest request) {
		String errMsg=request.getParameter("msg");

		getOESPartner(model, request);

		// Get App Info
		model.addAttribute("webVersion", AppInfoHelper.appInfo.getWebVersion());

		//Code For dynamic logo render:13-july-2015:Yograjs
		model.addAttribute("clientid", AppInfoHelper.appInfo.getClientID());
		model.addAttribute("isCopyRightEnabled", AppInfoHelper.appInfo.getIsCopyRightEnabled());
		model.addAttribute("errorMsg", errMsg);
		return "Common/Error/GenericError";
	}

	/**
	 * Method to fetch Optional Request Parameters
	 * @param request
	 * @param errormsg
	 * @return Object this returns a map of optionl parameters
	 */
	private Object getOptinalRequestParameters(HttpServletRequest request, String[] errormsg) {
		Map<String, String> optionalParamertsMap = null;
		try {
			optionalParamertsMap = new LinkedHashMap<String, String>();
			// PartnerID
			optionalParamertsMap.put(GatewayConstants.PARTNERID, request.getParameter(GatewayConstants.PARTNERID));

			if (request.getParameterMap() != null && !request.getParameterMap().isEmpty()) {
				Iterator it = request.getParameterMap().entrySet().iterator();
				while (it.hasNext()) {
					Entry<String, String[]> entry = (Entry<String, String[]>) it.next();

					// skip values
					if (GatewayConstants.PARTNERID.equals(entry.getKey()))
						continue;
					/*if (GatewayConstants.EXEVPID.equals(entry.getKey()))
						continue;*/
					if (GatewayConstants.CCODE.equals(entry.getKey()))
						continue;

					// add other parameters
					optionalParamertsMap.put(entry.getKey(), entry.getValue()[0].toString());
				}
			}
		} catch (Exception e) {
			errormsg[0] = "Unable to add extra parameters in session";
			LOGGER.error("Exception occured in getOptinalRequestParameters: " + errormsg[0]);
			optionalParamertsMap = null;
		}
		return optionalParamertsMap;
	}

	/**
	 * Method to fetch OES Partner Data	 *
	 * @param model
	 * @param request
	 */
	private void getOESPartner(Model model,HttpServletRequest request){
		try{
			if (SessionHelper.getPartnerObject(request) != null) {
				String partnerID = SessionHelper.getPartnerObject(request).get(GatewayConstants.PARTNERID);
				IOESPartnerService partnerService=new OESPartnerServiceImpl();
				OESPartnerMaster oesPartnerMaster = partnerService.getOESPartnerMaster(Long.parseLong(partnerID));
				model.addAttribute("oesPartnerMaster", oesPartnerMaster);
			}
		} catch (Exception e) {
			LOGGER.error("Exception occured in getOESPartner: ", e);
		}
	}

/*
 * added on 6-Aug-2015
 * Last Modified : 08 Dec 2016 : removing hard coded partner id=1,utilising dynamic value of partner id from third party session
 */
	/**
	 * Method to send the Candidate Marks to ERA	 * 
	 * @param candidateExam
	 * @param request
	 * @return ResponseEntity<Boolean> this returns the response status
	 */
	@ResponseBody
	@RequestMapping(value = { "/sendCandMarksToEra" }, method=RequestMethod.POST,headers = {"Content-type=application/json"})
	public ResponseEntity<Boolean> sendCandMarksToEra(@RequestBody CandidateExam candidateExam ,HttpServletRequest request) {
		ResultPayload payloadReq=null;
		EraResultTransferLog eraResultTransferLogsReq=null;
		List<EraResultTransferLog> listResultReq=null;

		ResultPayload payloadRes=null;

		GatewayServicesImpl gatewayServicesImpl=null;
		String result=null;
		String url=null;
		HttpPost postRequest=null;
		HttpClient httpClient=null;
		HttpResponse response=null;
		boolean saveFlag=false;
		Map partnerObject=null;
		try
		{
			partnerObject=SessionHelper.getPartnerObject(request);

			if ((partnerObject != null) && 
					(partnerObject.get(GatewayConstants.PCID)==null || partnerObject.get(GatewayConstants.PCID).equals("0")) && 
					(partnerObject.get(GatewayConstants.RETURNURL)!=null) && 
					(!partnerObject.get(GatewayConstants.RETURNURL).toString().isEmpty()))
			{
				//20 jan 2017 : ".json" added by ERA team to send back response to us
				url = SessionHelper.getPartnerObject(request).get(GatewayConstants.RETURNURL)+".json";

				//url="http://10.2.1.124:8080/LMS-Web/resultTransfer";

				gatewayServicesImpl=new GatewayServicesImpl();
				//08 dec 2016 : passing partnerid && getting candidate exam attributes from candidateExamID(this id comes only when send marks request come from typing app)
				if(candidateExam.getCandidateExamID()!=0l)
				{
					candidateExam=new CandidateExamServiceImpl().getCandidateExamBycandidateExamID(candidateExam.getCandidateExamID());

				}
				//added for OES as component requirement 01-May-2017(For Success send Item wise marks instead of Exam Marks)
				if(partnerObject.get(GatewayConstants.ITEMID)!=null && Long.parseLong(partnerObject.get(GatewayConstants.ITEMID).toString())>0)
				{
					//Itemwisemarks
					candidateExam=new CandidateExamServiceImpl().getCandidateExamBycandidateExamID(SessionHelper.getExamPaperSetting(request).getCandidateExamID());
					eraResultTransferLogsReq=gatewayServicesImpl.getCanToSentToEraForItemMarks(Long.parseLong(SessionHelper.getPartnerObject(request).get(GatewayConstants.PARTNERID)),candidateExam.getFkCandidateID(),candidateExam.getFkExamEventID(),candidateExam.getFkPaperID(),(int)candidateExam.getAttemptNo(),Long.parseLong(partnerObject.get(GatewayConstants.ITEMID).toString()));
				}
				else
				{
					/*examwise marks*/
					eraResultTransferLogsReq=gatewayServicesImpl.getCanToSentToEra(Long.parseLong(SessionHelper.getPartnerObject(request).get(GatewayConstants.PARTNERID)),candidateExam.getFkCandidateID(),candidateExam.getFkExamEventID(),candidateExam.getFkPaperID(),(int)candidateExam.getAttemptNo());
				}
				
				if(eraResultTransferLogsReq!=null)
				{
					payloadReq=new ResultPayload();
					listResultReq=new ArrayList<EraResultTransferLog>();
					listResultReq.add(eraResultTransferLogsReq);
					payloadReq.setResultList(listResultReq);
				}

				//Convert eraResultTransferLog to json string
				result=parseObjectToJsonString(payloadReq);
				postRequest= createPostRequest(postRequest,url,result);
				httpClient = new DefaultHttpClient();
				response = httpClient.execute(postRequest);

				LOGGER.info("Server Response...",response.getStatusLine());

				if(response.getStatusLine().getStatusCode()==200)
				{
					HttpEntity entity = response.getEntity();
					if (entity != null) {
						String responseBody = EntityUtils.toString(entity);
						String jsonString = responseBody.toString();
						ObjectMapper objectMapper = new ObjectMapper();
						JavaType javaType=objectMapper.getTypeFactory().constructType(ResultPayload.class);
						payloadRes=objectMapper.readValue(jsonString,javaType);

						if(payloadRes!=null && payloadRes.getResultList()!=null && payloadRes.getResultList().size()!=0)
						{
							saveFlag=gatewayServicesImpl.saveEraResultTransferLog(payloadRes.getResultList().get(0));
						}

					}
				}
			}

		}
		catch(Exception e)
		{
			LOGGER.error("Exception occured in sendCandMarksToEra: ", e);
			return new ResponseEntity<Boolean>(false,HttpStatus.INTERNAL_SERVER_ERROR);
		}
		return new ResponseEntity<Boolean>(saveFlag,saveFlag ? HttpStatus.OK : HttpStatus.INTERNAL_SERVER_ERROR);
	}

	/**
	 * Post method to Request Bulk Marks to ERA
	 * @param request
	 * @param response
	 * @param session
	 * @param candidateExamID
	 */
	@RequestMapping(value = { "/reqBulkMarksToEra" }, method=RequestMethod.POST,produces = "application/json;charset=UTF-8")
	public void reqBulkMarksToEra(HttpServletRequest request,HttpServletResponse response, HttpSession session, String candidateExamID) {
		List<EraResultTransferLog> eraResultTransferLogs=null;
		List<EraResultTransferLog> eraResultTransferLogsWithItems=null;
		GatewayServicesImpl gatewayServicesImpl=null;
		String result=null;
		ResultPayload payload=null;
		ResultPayload payloadRes=null;
		ObjectMapper mapper=null;
		boolean saveFlag=false;
		try
		{
			gatewayServicesImpl=new GatewayServicesImpl();
			
			//Bulk transfer functionality only available for ERA local candidate(As per discussion with Gurpreet Mam(24.04.2017))
			SessionHelper.setIsLocalCandidate(session);

			//Request with List of eraResultTransferLogs
			if(request.getContentLength()!=0)
			{
				mapper = new ObjectMapper();
				payloadRes=mapper.readValue(request.getInputStream(), ResultPayload.class);
				if(payloadRes!=null && payloadRes.getResultList()!=null && payloadRes.getResultList().size()!=0)
				{
					saveFlag=gatewayServicesImpl.saveEraResultTransferLogs(payloadRes.getResultList());
				}

			}
			else // blank request
			{
				//get paperwise marks
				eraResultTransferLogs=gatewayServicesImpl.getCanListToSentToEra();
				//added for OES as component requirement 01-May-2017(For Success send Item wise marks instead of Exam Marks)
				//get itemwise marks
				eraResultTransferLogsWithItems=gatewayServicesImpl.getCanListToSentToEraWithListItemMarks();
				eraResultTransferLogs.addAll(eraResultTransferLogsWithItems);
				
				if(eraResultTransferLogs!=null && eraResultTransferLogs.size()!=0)
				{
					payload=new ResultPayload();
					payload.setResultList(eraResultTransferLogs);
				}
				result=parseObjectToJsonString(payload);
				response.getWriter().write(result);
			}
		}
		catch(Exception e)
		{
			LOGGER.error("Exception in reqBulkMarksToEra...",e);
		}
	}

	/**
	 * Method to Create Post Request
	 * @param postRequest
	 * @param url
	 * @param result
	 * @return HttpPost this returns the post request
	 */
	public HttpPost createPostRequest(HttpPost postRequest, String url,String result) {
		try
		{
			postRequest = new HttpPost(url);
			StringEntity input = new StringEntity(result);
			input.setContentType("application/json;charset=UTF-8");
			input.setContentEncoding(new BasicHeader(HTTP.CONTENT_TYPE,"application/json;charset=UTF-8"));
			postRequest.setHeader("Accept", "application/json");
			postRequest.setEntity(input);
		}
		catch(Exception e)
		{
			LOGGER.error("Exception in createPostRequest...",e);
		}
		return postRequest;
	}

	/**
	 * Method to parse Object to JSON String
	 * @param resultPayload
	 * @return String this returns the JSON string
	 */
	private String parseObjectToJsonString(ResultPayload resultPayload) {
		String jsonString=null;
		try
		{
			if(resultPayload!=null)
			{
				ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
				jsonString = ow.writeValueAsString(resultPayload);
			}
		}
		catch(Exception e)
		{
			LOGGER.error("Exception in parseObjectToJsonString...",e);
		}
		return jsonString;
	}

	/*
	 * End by sapanag 
	 */
	
	/*
	 * Added By Reena
	 * Method is used to validate Practice Paper in all types of gateway Exams : Typing,Klic,Normal
	 * Practice Paper can be scheduled CENTRAL only
	 */
	/**
	 * Method used to validate Practice Paper in all types of gateway Exams : Typing,Klic,Normal
	 * Practice Paper can be scheduled CENTRAL only
	 * @param req
	 * @param viewModel
	 * @param examEventPaperDetails
	 * @param object
	 * @param errormsg
	 * @param examEvent
	 * @param paperID
	 * @param candidateID
	 * @param collectionID
	 * @param clientId
	 * @return String this returns the path of a view
	 */
	private String ValidatePracticePaper( HttpServletRequest req,ExamDisplayCategoryPaperViewModel viewModel,ExamEventPaperDetails examEventPaperDetails, Object object, String[] errormsg,ExamEvent examEvent,long paperID,long candidateID,long collectionID,long clientId)
	{
		IGatewayServices gatewayService = new GatewayServicesImpl();
		
		String redirecturl =null;
		try
		{
			 if(examEventPaperDetails!=null)
				{
					viewModel = gatewayService.getScheduledDetailsForPracticePaper(examEvent.getExamEventID(), paperID, candidateID, collectionID);
					
					if (viewModel !=null) {
						viewModel.setExamEventPaperDetails(examEventPaperDetails);
					}
				}
			 if(viewModel!=null)
			 {
				 //if exam is new or incomplete,got to Take Test.If exam is completed,check for next attempt ,if available, go to Take Test
				if (viewModel.getCandidateExam().getIsExamCompleted()==null || viewModel.getCandidateExam().getIsExamCompleted()== false ||(viewModel.getCandidateExam().getIsExamCompleted()==true && viewModel.getExamEventPaperDetails().getNoOfAttempts()==-1 ? true :viewModel.getCandidateExam().getAttemptNo() <viewModel.getExamEventPaperDetails().getNoOfAttempts())) {
					
					//check for paper is not expired
					if (viewModel.getExpiryDate() != null) {
						
						if(clientId!=0l) // Typing Paper
						{
							if (SessionHelper.getIsLocalCandidate()) {
								redirecturl = "typ:url?ceid=" + viewModel.getCandidateExam().getCandidateExamID() + "&se=" + viewModel.getExpiryDate().getTime() +"&clientid=" + clientId+"&sessionId="+req.getSession().getId();
							}else{
								redirecturl = "typ:url?ceid=" + viewModel.getCandidateExam().getCandidateExamID() + "&se=" + viewModel.getExpiryDate().getTime() +"&clientid=" + clientId;
							}
							
						}
						else //Klic, Normal Test
						{
							// redirect to exam instruction page
							redirecturl = "redirect:/gateway/Authentication?ceid=" + viewModel.getCandidateExam().getCandidateExamID() + "&se=" + viewModel.getExpiryDate().getTime();
						
						}
						} else {
	
						errormsg[0] = "Schedule for the selected Paper has been expired.";
						// Schedule for the selected Paper has been expired.
						LOGGER.error("Exception occured in getExamPaperAllocatedToUser: " + errormsg[0]);
					}
				} 
				else {
					if(clientId!=0l) // Typing Paper
					{
						errormsg[0] = "You have already completed all the allowed attempts for this Paper.";
						LOGGER.error("Exception occured in getExamTypingPaperAllocatedToUser: " + errormsg[0]);
					}
					else //Klic, Normal Test
					{
						// redirect to exam result page
						redirecturl = "redirect:/endexam/showTestResult?ceid=" + viewModel.getCandidateExam().getCandidateExamID() + "&examEventID=" + examEvent.getExamEventID() + "&paperID=" + paperID + "&attemptNo="+ viewModel.getCandidateExam().getAttemptNo();
					
					}
					}
			 }
			else{
					errormsg[0] = "Schedule not found for the selected Paper.";
					// Schedule not found for the selected Paper.
					LOGGER.error("Exception occured in getExamPaperAllocatedToUser: " + errormsg[0]);
			}
			
		}
		catch(Exception e)
		{
			errormsg[0] = "Error occured while validating Practice Paper.";
			// Schedule not found for the selected Paper.
			LOGGER.error("Error occured while validating Practice Paper in ValidatePracticePaper : " + errormsg[0]);
		}
	
		return redirecturl;	
}
	/**
	 * Post method to Group Exam
	 * @param model
	 * @param locale
	 * @param session
	 * @param response
	 * @param request
	 * @param epid
	 * @param code
	 * @param partnerID
	 * @param pcID
	 * @param sec_Marks
	 * @param redirectAttributes
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/groupExam" }, method = RequestMethod.POST)
	public String groupExam(Model model, Locale locale, HttpSession session, HttpServletResponse response,HttpServletRequest request, @RequestParam(GatewayConstants.EXEVPID) long epid, @RequestParam(GatewayConstants.CCODE) String code, @RequestParam(GatewayConstants.PARTNERID) long partnerID, @RequestParam(value=GatewayConstants.PCID, required = false) Long pcID, @RequestParam(value=GatewayConstants.SECMARKS, required = false) String sec_Marks, RedirectAttributes redirectAttributes) {
		String[] errormsg = new String[1];
		try 
		{
			if (epid==0 && (pcID==null || pcID==0)) {
				errormsg[0] = "Encountered some difficulties with respect to configurations. Please conatct your Learning Facilitator.";
				LOGGER.error("Exception occured in gatewayLogin: " + errormsg[0]);
			}
			else{
				IGatewayServices gatewarService = new GatewayServicesImpl();
				
				// Candidate
				CandidateServiceImpl candidateService = new CandidateServiceImpl();
				Candidate candidate = null;

				ExamEventPaperDetails examEventPaperDetails=null;
				IExamEventService examEventService = new ExamEventServiceImpl();
				
				// Code to check get candidate exam details when epid=0
				// Preconditions
				long paperId=0;
				ExamDisplayCategoryPaperViewModel examDisplayCategoryPaperViewModel=null;
				if (epid==0l) { // for klic exam

					// get paper if using PCID
					paperId=gatewarService.getPaperIdUsingProgramCourceId(pcID);

					// get candidate exam details using paper id and candidate id
					examDisplayCategoryPaperViewModel=gatewarService.getCandSchedDetailsForERAPgrmCrse(code, paperId);
					if (examDisplayCategoryPaperViewModel !=null) {
						examEventPaperDetails=examEventService.getExamEventPaperDetails(examDisplayCategoryPaperViewModel.getCandidateExam().getFkExamEventID(), paperId);
						
						//added by reena,required attributes from Exam event Paper Details for checking of Practice Paper.
						examDisplayCategoryPaperViewModel.setExamEventPaperDetails(examEventPaperDetails);
						candidate=examDisplayCategoryPaperViewModel.getCandidateExam().getCandidate();
					}					
				}else{
					examEventPaperDetails = examEventService.getExamEventPaperDetailsFromID(epid);
					candidate=candidateService.getCandidate(code, examEventPaperDetails.getExamEventID());
				}
				
					if (examEventPaperDetails != null) 
					{
						ExamEvent examEvent=examEventService.getExamEventByID(examEventPaperDetails.getExamEventID());
						if(!(examEvent!=null && examEvent.getLocalSchedular()==LocalSchedular.Candidate && examEventPaperDetails.getScheduleLocation()==ScheduleLocation.Local && examEvent.getIsGroupEnabled() && (examEventPaperDetails.getAssessmentType()==AssessmentType.Both || examEventPaperDetails.getAssessmentType()==AssessmentType.Group)))
						{
							errormsg[0] = "We have identified a exam event configuration mismatch for Paper "+examEventPaperDetails.getFkPaperID()+".";
							LOGGER.error("Exception occured in gatewayLogin: " + errormsg[0]);
							throw new CustomGenericException("OES GATEWAY ERROR", errormsg[0]);
						}
						
							if (candidate !=null) {
							// compare paper delivery through
							// 0 : OES
							// 1 : ERA
							if (partnerID != 0) {
								if (examEventPaperDetails.getPaperDeliveredThrough() == partnerID) {					
	
									// other optional parameters
									Object object = getOptinalRequestParameters(request, errormsg);
									if (object != null) {
										// create user session
										createLoginSession(candidate, examEventPaperDetails.getExamEventID(), examEventPaperDetails.getFkPaperID(), object, errormsg,LoginType.Group,request, response);
										return "redirect:../groupLogin/gatewayGrouplogin?pid=" + examEventPaperDetails.getFkPaperID();
									}
									else
									{
										//what to through to user
									}
								} else {
									errormsg[0] = "We have identified a configuration mismatch for Paper "+examEventPaperDetails.getFkPaperID()+". Please conatct your Learning Facilitator.";
									LOGGER.error("Exception occured in gatewayLogin: " + errormsg[0]);
								}
							} else {
								errormsg[0] = "Sorry, this is an invalid request.  Please conatct your Learning Facilitator.";
								LOGGER.error("Exception occured in gatewayLogin: " + errormsg[0]);
							}
						} 
						else 
						{
							errormsg[0] = "Candidate not found. Please conatct your Learning Facilitator.";
							LOGGER.error("Exception occured in gatewayLogin: " + errormsg[0]);
						}
					/*}
					else 
					{
						errormsg[0] = "We have identified a schedule configuration mismatch for Paper "+examEventPaperDetails.getFkPaperID()+". Please conatct your Learning Facilitator.";
						LOGGER.error("Exception occured in gatewayLogin: " + errormsg[0]);
					}*/
				}
				else
				{
					errormsg[0] = "This Paper is either attempted or currently not configured. Please conatct your Learning Facilitator.";
					LOGGER.error("Exception occured in gatewayLogin: " + errormsg[0]);
				}
				gatewarService=null;
			}
		} 
		catch (Exception e) {
			LOGGER.error("Exception occured in gatewayLogin: ", e);
			errormsg[0]="Exception occured in gatway login.";

		}
		throw new CustomGenericException("OES GATEWAY ERROR", errormsg[0]);
	}
	
	/**
	 * Method to Download Candidate Image
	 * @param imgPath
	 * @param request
	 * @return String this returns the image name 
	 */
	public String downloadCandidateImage(String imgPath,HttpServletRequest request) {
        String imageName = "";
        try {

            //URL url = new URL(properties.getOesServerURL() + "/resources/WebFiles/UserImages/" + imgPath);
            URL url = new URL(imgPath);

            String filename = url.getFile();
            imageName = filename.substring(filename.lastIndexOf("/") + 1);

            InputStream is = url.openStream();
            String sClientPhysicalPath = FileUploadHelper.getPhysicalFolderPathWithinWebApp(request, "UserPhotoUploadPath");
            OutputStream os = new FileOutputStream(sClientPhysicalPath + imageName);

            byte[] b = new byte[2048];
            int length;

            while ((length = is.read(b)) != -1) {
                os.write(b, 0, length);
            }
            is.close();
            os.close();
            return imageName;
        }  catch (Exception e) {
            return null;
        }

    }
	
	/**
	 * Post method for Candidate Marks
	 * @param payload
	 * @param request
	 * @param response
	 * @return ResponseEntity<Object> this returns the response status
	 */
	@ResponseBody
	@RequestMapping(value = { "/getCandidateMarks" }, method=RequestMethod.POST,headers = {"Content-type=application/json"})
	public ResponseEntity<Object> getCandidateMarks(@RequestBody ResultPayload payload,HttpServletRequest request,HttpServletResponse response) 
	{
		
		List<EraResultTransferLog> resultTransferLogList=new ArrayList<EraResultTransferLog>();

		ResultPayload resultPayload=null;
		GatewayServicesImpl gatewayServicesImpl=null;
		try
		{
			if(payload!=null && payload.getResultList()!=null && payload.getResultList().size()>0)
			{
				gatewayServicesImpl=new GatewayServicesImpl();
				
				for (EraResultTransferLog candidateMarks : payload.getResultList()) 
				{
					if(candidateMarks.getEpid()!=null && candidateMarks.getLc()!=null && candidateMarks.getAn()!=null && !candidateMarks.getEpid().trim().isEmpty() && !candidateMarks.getLc().trim().isEmpty() && !candidateMarks.getAn().trim().isEmpty()) 
					{
						List<EraResultTransferLog> eraResultTransferLogList=gatewayServicesImpl.getResultTransferByUsername(candidateMarks.getLc(),Long.parseLong(candidateMarks.getEpid()) );
						if(eraResultTransferLogList.size()>0)
						{
							resultTransferLogList.addAll(eraResultTransferLogList);
						}
						else
						{
							resultTransferLogList.add(candidateMarks);
						}
					}
				}
				resultPayload=new ResultPayload();
				resultPayload.setResultList(resultTransferLogList);
				/*resultJson=parseObjectToJsonString(resultPayload);
				PrintWriter out = response.getWriter();
		        response.setContentType("application/json");
		        response.setCharacterEncoding("UTF-8");
		        out.print(resultJson);
		        out.flush();   */
			}

		}
		catch(Exception e)
		{
			LOGGER.error("Exception occured in getCandidateMarks: ", e);
			return new ResponseEntity<Object>(null,HttpStatus.INTERNAL_SERVER_ERROR);
		}
		return new ResponseEntity<Object>(resultPayload,resultPayload!=null && resultPayload.getResultList().size()>0 ? HttpStatus.OK : HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	/**
	 * Get method for Authentication
	 * @param model
	 * @param locale
	 * @param session
	 * @param request
	 * @param response
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/Authentication" }, method = RequestMethod.GET)
	public String Authentication(Model model, Locale locale, HttpSession session, HttpServletRequest request, HttpServletResponse response) {
		long candidateExamId=0l;
		
		IGatewayServices gatewayService = new GatewayServicesImpl();
		
		try 
		{
			
			model.addAttribute("clientid", AppInfoHelper.appInfo.getClientID());
			
			if(request.getParameter("ceid")!=null && !request.getParameter("ceid").isEmpty())
			{
				candidateExamId = Long.parseLong(request.getParameter("ceid"));		
				model.addAttribute("ceid", request.getParameter("ceid"));		
			}
			if(request.getParameter("dcid")!=null && !request.getParameter("dcid").isEmpty() && request.getParameter("dcid") != "0")
			{
				model.addAttribute("dcid", request.getParameter("dcid"));	
			}
			if(request.getParameter("se")!=null && !request.getParameter("se").isEmpty())
			{
				model.addAttribute("se", request.getParameter("se"));	
			}

			if(request.getParameter("b")!=null && !request.getParameter("b").isEmpty()) {
				model.addAttribute("b", request.getParameter("b"));	
			}
			
			String redirectUrl = null;
			
			boolean hasSupervisorPwd = gatewayService.getSupervisorPwd(candidateExamId);
			if(hasSupervisorPwd == true) {
				redirectUrl = "../exam/AuthenticationGet";
			}
			else {
				redirectUrl = "../exam/instruction";
			}
			
			model.addAttribute("redirectUrl", redirectUrl);	
			
			return "Solo/Exam/GatewayAuthentication";			
		} 
		catch (Exception e) {
			LOGGER.error("Exception occured in Authentication: ", e);

		}
		throw new CustomGenericException("OES GATEWAY AUTHENTICATION ERROR","");
	}
	
	
}
