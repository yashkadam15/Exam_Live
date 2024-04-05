package mkcl.oesclient.commons.controllers;

import java.io.IOException;
import java.io.OutputStream;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import mkcl.baseoesclient.model.LoginType;
import mkcl.oesclient.commons.services.ExamClientServiceImpl;
import mkcl.oesclient.commons.services.ExamEventServiceImpl;
import mkcl.oesclient.commons.services.ExamVenueActivationServicesImpl;
import mkcl.oesclient.commons.services.OESAppInfoServicesImpl;
import mkcl.oesclient.commons.utilities.AppInfoHelper;
import mkcl.oesclient.model.OESAppInfo;
import mkcl.oesclient.model.VenueUser;
import mkcl.oesclient.solo.controllers.ExamController;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.oespcs.model.ExamClientExamEventConfiguration;
import mkcl.oespcs.model.ExamEvent;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;
import org.w3c.dom.Element;


/**
 * The Class ExamClientController.
 * 
 * 
 * 
 */
@Controller
@RequestMapping(value = "examClient")
public class ExamClientController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(ExamClientController.class);
	/**
	 * Keep alive.
	 * This controller Method will be called
	 * by Ajax JQuery SetInterval function
	 * after specified time
	 * 
	 * It is developed to keep server session alive
	 *
	 * @param model the model
	 * @param request the request
	 * @return String this returns the value from the session
	 */
	@RequestMapping(value = "/keepAlive", method = RequestMethod.GET)
	@ResponseBody
	public String keepAlive(Model model,HttpServletRequest request) {
		return String.valueOf(SessionHelper.getCandidate(request).getCandidateID());
	}
	
	/**
	 * Post method for Supervisor Password
	 * @param model
	 * @param request
	 * @return String this returns the superviser password
	 */
	@RequestMapping(value = "/getSupervisorPwd", method = RequestMethod.POST)
	@ResponseBody
	public String getSupervisorPwd(Model model,HttpServletRequest request) {
		OESAppInfoServicesImpl appInfoServicesImpl=new OESAppInfoServicesImpl();
		String venueCode=request.getParameter("venueCode");
		return appInfoServicesImpl.getSupervisorPassword(venueCode);		
	}
	
	/**
	 * Get method for Exam Client
	 * @param model
	 * @param request
	 * @param response
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "/get", method = RequestMethod.GET)
	public String get(Model model,HttpServletRequest request,HttpServletResponse response) {
		return "/examClient/examclient";
	}
	
	/**
	 * Get method for login
	 * @param model
	 * @param req
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String login(Model model,HttpServletRequest req) {
		ExamEvent examEvent=null;	
		
		//Code For dynamic logo render:13-july-2015:Yograjs
		model.addAttribute("clientid", AppInfoHelper.appInfo.getClientID());
		model.addAttribute("isCopyRightEnabled", AppInfoHelper.appInfo.getIsCopyRightEnabled());
		// code to get app version details
		model.addAttribute("webVersion", AppInfoHelper.appInfo.getWebVersion());
		examEvent=new ExamEventServiceImpl().getExamEventByID(Long.parseLong(req.getParameter("examEventID")));
		if(examEvent ==null)
		{
			model.addAttribute("noEvent", "Event is not sync.");
		}
		else
		{
		
			model.addAttribute("user", new VenueUser());
			model.addAttribute("examEventID", req.getParameter("examEventID"));
			model.addAttribute("loginType", LoginType.Solo);
			model.addAttribute("eventName", examEvent.getName());
		}
		model.addAttribute("todayDate", new Date());
		model.addAttribute("hideBack", "1");
		return"Solo/soloLogin/soloLoginpage";
	}
	
	/**
	 * Get method for Event Configuration  
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = { "/eventConfig" }, method = RequestMethod.GET)
	public void listGet(HttpServletRequest request, HttpServletResponse response) {
	
		try
		{
			DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
	
			// root elements
			Document doc = docBuilder.newDocument();
			Element rootElement = doc.createElement("Events");
			doc.appendChild(rootElement);
			ExamClientExamEventConfiguration configuration = new ExamClientServiceImpl().getConfiguration(Long.parseLong(request.getParameter("eventId")));
			if(configuration != null)
			{
				Element event = doc.createElement("event");
				rootElement.appendChild(event);
				
				Element eventId = doc.createElement("EventId");
				eventId.appendChild(doc.createTextNode(String.valueOf(configuration.getFkExamEventId())));
				event.appendChild(eventId);
				
				Element currentExamClientVersion = doc.createElement("currentExamClientVersion");
				currentExamClientVersion.appendChild(doc.createTextNode(configuration.getCurrentExamClientVersion()));
				event.appendChild(currentExamClientVersion);
				
				Element closeApplicationPasswordReq = doc.createElement("closeApplicationPasswordReq");
				closeApplicationPasswordReq.appendChild(doc.createTextNode(Boolean.toString(configuration.getCloseApplicationPasswordReq())));
				event.appendChild(closeApplicationPasswordReq);
				
				Element guidedAccessReq = doc.createElement("guidedAccessReq");
				guidedAccessReq.appendChild(doc.createTextNode(Boolean.toString(configuration.getGuidedAccessReq())));
				event.appendChild(guidedAccessReq);
				
				Element FTPuploadURL = doc.createElement("FTPuploadURL");
				FTPuploadURL.appendChild(doc.createTextNode(configuration.getFTPuploadURL()));
				event.appendChild(FTPuploadURL);
				
				Element FTPuserName = doc.createElement("FTPuserName");
				FTPuserName.appendChild(doc.createTextNode(configuration.getFTPuserName()));
				event.appendChild(FTPuserName);
				
				Element FTPpassword = doc.createElement("FTPpassword");
				FTPpassword.appendChild(doc.createTextNode(configuration.getFTPpassword()));
				event.appendChild(FTPpassword);				
		
				Element examClientLocalization = doc.createElement("examClientLocalization");
				examClientLocalization.appendChild(doc.createTextNode(configuration.getExamClientLocalization().name()));
				event.appendChild(examClientLocalization);
				
				Element evidenceConfiguration = doc.createElement("evidenceConfiguration");
				evidenceConfiguration.appendChild(doc.createTextNode("NoConfig"));
				event.appendChild(evidenceConfiguration);
				
				Element evidenceReq = doc.createElement("evidenceReq");
				evidenceReq.appendChild(doc.createTextNode(Boolean.toString(configuration.getEvidenceReq())));
				event.appendChild(evidenceReq);
				
				Element captureCameraImage = doc.createElement("captureCameraImage");
				captureCameraImage.appendChild(doc.createTextNode(Boolean.toString(configuration.getCaptureCameraImage())));
				event.appendChild(captureCameraImage);
				
				Element cameraCompulsory = doc.createElement("cameraCompulsory");
				cameraCompulsory.appendChild(doc.createTextNode(Boolean.toString(configuration.getCameraCompulsory())));
				event.appendChild(cameraCompulsory);
				
				Element captureScreenShot = doc.createElement("captureScreenShot");
				captureScreenShot.appendChild(doc.createTextNode(Boolean.toString(configuration.getCaptureScreenShot())));
				event.appendChild(captureScreenShot);
				
				Element screenShotCaptureInterval = doc.createElement("screenShotCaptureInterval");
				screenShotCaptureInterval.appendChild(doc.createTextNode(String.valueOf(configuration.getScreenShotCaptureInterval())));
				event.appendChild(screenShotCaptureInterval);
				
				Element cameraImageCaptureInterval = doc.createElement("cameraImageCaptureInterval");
				cameraImageCaptureInterval.appendChild(doc.createTextNode(String.valueOf(configuration.getCameraImageCaptureInterval())));
				event.appendChild(cameraImageCaptureInterval);
			}		
			
			OutputStream outs = response.getOutputStream();
			
			TransformerFactory transformerFactory = TransformerFactory.newInstance();			
			Transformer transformer = transformerFactory.newTransformer();
			DOMSource source = new DOMSource(doc);
			StreamResult result = new StreamResult(outs);
			
			transformer.transform(source, result);
			
			outs.close();
		}
		catch(Exception e)
		{
			LOGGER.error("",e);
		}
	}
	
	/**
	 * Get method for Evidence Server URL
	 * @param model
	 * @param request
	 * @return String this returns the evidence server URL
	 */
	@RequestMapping(value = "/getEvidenceServerURL", method = RequestMethod.GET)
	@ResponseBody
	public String getEvidenceServerURL(Model model,HttpServletRequest request) {
		ExamClientServiceImpl clientServiceImpl=new ExamClientServiceImpl();
		return clientServiceImpl.getEvidenceServerURL();		
	}
}
