package mkcl.oesclient.visualArtInclination.controllers;

import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import mkcl.oes.commons.FileUploadHelper;
import mkcl.oesclient.commons.services.ExamVenueActivationServicesImpl;
import mkcl.oesclient.commons.utilities.AppInfoHelper;
import mkcl.oesclient.viewmodel.ShortVisualArtInclinationCertViewModel;
import mkcl.oesclient.visualArtInclination.services.ShortVisualArtInclinationServiceImpl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("ShortArtInclinationTestReport")
public class ShortArtInclinationReportController {
private static final Logger LOGGER = LoggerFactory.getLogger(ShortArtInclinationReportController.class);	
	
	/**
	 * Get method for Candidate
	 * @param model
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value={"/getCandidate"},method = RequestMethod.GET)
	public String getCandidate(Model model,HttpServletRequest request) 
	{
		return "ShortArtInclinationTest/getCandidate";
	}
	
	/**
	 * Get method for Short Art Inclination Test Report
	 * @param model
	 * @param request
	 * @param candidateUserName
	 * @param examEventId
	 * @param paperId
	 * @param attemptNo
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value={"/shortArtInclinationTestReport"},method = RequestMethod.GET)
	public String getShortArtInclinationTestReport(Model model,HttpServletRequest request,String candidateUserName,String examEventId,
			String paperId,String attemptNo,Locale locale) 
	{
		List<ShortVisualArtInclinationCertViewModel> list=null;
		try
		{			
			model.addAttribute("candidateUserName", candidateUserName);
			model.addAttribute("examEventId", examEventId);
			model.addAttribute("paperId", paperId);
			model.addAttribute("attemptNo", attemptNo);
			
			
			list =new ShortVisualArtInclinationServiceImpl().getShortArtInclinationCertDetails(Long.parseLong(examEventId), candidateUserName, Long.parseLong(paperId), Integer.parseInt(attemptNo));
			
			String imgrelativePath = FileUploadHelper.getRelativeFolderPath(request, "UserPhotoUploadPath");
			model.addAttribute("imgPath", imgrelativePath);

			model.addAttribute("artInclinationDetails",list);
			
			model.addAttribute("clientid", AppInfoHelper.appInfo.getClientID());
		}
		catch(Exception e)
		{
			LOGGER.error("Error in shortArtInclinationTestReport :: ",e);
		}
		return "ShortArtInclinationTest/shortArtInclinationTestReport";
	}
	
	/**
	 * Get method for Short Art Inclination Test Report Print
	 * @param model
	 * @param request
	 * @param candidateUserName
	 * @param examEventId
	 * @param paperId
	 * @param attemptNo
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value={"/shortArtInclinationTestReportPrint"},method = RequestMethod.GET)
	public String getCareerInclinationTestPrint(Model model,HttpServletRequest request,String candidateUserName,String examEventId,
			String paperId,String attemptNo,Locale locale) 
	{
		List<ShortVisualArtInclinationCertViewModel> list=null;
		try
		{			
			
			list =new ShortVisualArtInclinationServiceImpl().getShortArtInclinationCertDetails(Long.parseLong(examEventId), candidateUserName, Long.parseLong(paperId), Integer.parseInt(attemptNo));
			
			String imgrelativePath = FileUploadHelper.getRelativeFolderPath(request, "UserPhotoUploadPath");
			model.addAttribute("imgPath", imgrelativePath);

			model.addAttribute("artInclinationDetails",list);
			
			model.addAttribute("clientid", AppInfoHelper.appInfo.getClientID());
		}
		catch(Exception e)
		{
			LOGGER.error("Error in shortArtInclinationTestReportPrint :: ",e);
		}
		return "ShortArtInclinationTest/shortArtInclinationTestPrint";
	}
	
	
}
