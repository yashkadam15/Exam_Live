package mkcl.oesclient.visualArtInclination.controllers;

import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import mkcl.oes.commons.FileUploadHelper;
import mkcl.oesclient.commons.services.ExamVenueActivationServicesImpl;
import mkcl.oesclient.commons.utilities.AppInfoHelper;
import mkcl.oesclient.viewmodel.VisualArtInclinationCertViewModel;
import mkcl.oesclient.visualArtInclination.services.VisualArtInclinationServiceImpl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("ArtInclinationTestReport")
public class ArtInclinationReportController {
private static final Logger LOGGER = LoggerFactory.getLogger(ArtInclinationReportController.class);	
	
	/**
	 * Get method for Candidate
	 * @param model
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value={"/getCandidate"},method = RequestMethod.GET)
	public String getCandidate(Model model,HttpServletRequest request) 
	{
		return "ArtInclinationTest/getCandidate";
	}
	
	/**
	 * Get method for Art Inclination Test Report
	 * @param model
	 * @param request
	 * @param candidateUserName
	 * @param examEventId
	 * @param paperId
	 * @param attemptNo
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value={"/artInclinationTestReport"},method = RequestMethod.GET)
	public String getCareerInclinationTestReport(Model model,HttpServletRequest request,String candidateUserName,String examEventId,
			String paperId,String attemptNo,Locale locale) 
	{
		List<VisualArtInclinationCertViewModel> list=null;
		try
		{			
			model.addAttribute("candidateUserName", candidateUserName);
			model.addAttribute("examEventId", examEventId);
			model.addAttribute("paperId", paperId);
			model.addAttribute("attemptNo", attemptNo);
			
			
			list =new VisualArtInclinationServiceImpl().getArtInclinationCertDetails(Long.parseLong(examEventId), candidateUserName, Long.parseLong(paperId), Integer.parseInt(attemptNo));
			
			String imgrelativePath = FileUploadHelper.getRelativeFolderPath(request, "UserPhotoUploadPath");
			model.addAttribute("imgPath", imgrelativePath);

			model.addAttribute("artInclinationDetails",list);
			
			model.addAttribute("clientid", AppInfoHelper.appInfo.getClientID());
		}
		catch(Exception e)
		{
			LOGGER.error("Error in getCareerInclinationTestReport :: ",e);
		}
		return "ArtInclinationTest/artInclinationTestReport";
	}
	
	/**
	 * Get method for Art Inclination Test Print
	 * @param model
	 * @param request
	 * @param candidateUserName
	 * @param examEventId
	 * @param paperId
	 * @param attemptNo
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value={"/artInclinationTestPrint"},method = RequestMethod.GET)
	public String getCareerInclinationTestPrint(Model model,HttpServletRequest request,String candidateUserName,String examEventId,
			String paperId,String attemptNo,Locale locale) 
	{
		List<VisualArtInclinationCertViewModel> list=null;
		try
		{			
			
			list =new VisualArtInclinationServiceImpl().getArtInclinationCertDetails(Long.parseLong(examEventId), candidateUserName, Long.parseLong(paperId), Integer.parseInt(attemptNo));
			
			String imgrelativePath = FileUploadHelper.getRelativeFolderPath(request, "UserPhotoUploadPath");
			model.addAttribute("imgPath", imgrelativePath);

			model.addAttribute("artInclinationDetails",list);
			
			model.addAttribute("clientid", AppInfoHelper.appInfo.getClientID());
		}
		catch(Exception e)
		{
			LOGGER.error("Error in getCareerInclinationTestReport :: ",e);
		}
		return "ArtInclinationTest/artInclinationTestPrint";
	}
	
	
}
