package mkcl.oesclient.careerInclination.controllers;


import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import mkcl.careerinclination.model.CI_PersonalityTypeDetails;
import mkcl.oes.commons.FileUploadHelper;
import mkcl.oesclient.careerInclination.services.CareerInclinationServiceImpl;
import mkcl.oesclient.commons.services.ExamVenueActivationServicesImpl;
import mkcl.oesclient.commons.utilities.AppInfoHelper;
import mkcl.oesclient.model.CandidateExam;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("CareerInclinationTestReport")
public class CareerInclinationReportController{
	
	private static final Logger LOGGER = LoggerFactory.getLogger(CareerInclinationReportController.class);	
	
	/**
	 * Get method for Candidate
	 * @param model
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value={"/getCandidate"},method = RequestMethod.GET)
	public String getCandidate(Model model,HttpServletRequest request) 
	{
		return "CareerInclinationTest/getCandidate";
	}
	
	/**
	 * Get method for Career Inclination Test Report
	 * @param model
	 * @param request
	 * @param candidateUserName
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value={"/careerInclinationTestReport"},method = RequestMethod.GET)
	public String getCareerInclinationTestReport(Model model,HttpServletRequest request,String candidateUserName,Locale locale) 
	{
		CandidateExam canExam=null;
		String personalityType=null;
		CI_PersonalityTypeDetails personalityTypeDetails=null;
		CareerInclinationServiceImpl careerInclinationServiceImpl=null;
		long eventID=98;
		try
		{			
			String userName=request.getParameter("candidateUserName");
			if (userName !=null && ! userName.isEmpty()) {
				careerInclinationServiceImpl=new CareerInclinationServiceImpl();
				canExam=careerInclinationServiceImpl.getCandidateExam(eventID,candidateUserName);
				model.addAttribute("canExam", canExam);
			}
			
			if(canExam!=null)
			{
				personalityType=careerInclinationServiceImpl.getPersonalityType(eventID,canExam.getCandidate().getCandidateID());
				personalityTypeDetails=careerInclinationServiceImpl.getPersonalityTypeDetails(personalityType);
			}
			
			String imgrelativePath = FileUploadHelper.getRelativeFolderPath(request, "UserPhotoUploadPath");
			model.addAttribute("imgPath", imgrelativePath);

			model.addAttribute("personalityTypeDetails",personalityTypeDetails);
			
			model.addAttribute("clientid", AppInfoHelper.appInfo.getClientID());
		}
		catch(Exception e)
		{
			LOGGER.error("Error in getCareerInclinationTestReport :: ",e);
		}
		return "CareerInclinationTest/careerInclinationTestReport";
	}
	
	/**
	 * Get method for Career Inclination Test Report Print
	 * @param model
	 * @param request
	 * @param candidateUserName
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value={"/careerInclinationTestPrint"},method = RequestMethod.GET)
	public String getCareerInclinationTestPrint(Model model,HttpServletRequest request,String candidateUserName,Locale locale) 
	{
		CandidateExam canExam=null;
		String personalityType=null;
		CI_PersonalityTypeDetails personalityTypeDetails=null;
		CareerInclinationServiceImpl careerInclinationServiceImpl=null;
		long eventID=98;
		try
		{			
			String userName=request.getParameter("candidateUserName");
			if (userName !=null && ! userName.isEmpty()) {
				careerInclinationServiceImpl=new CareerInclinationServiceImpl();
				canExam=careerInclinationServiceImpl.getCandidateExam(eventID,candidateUserName);
				model.addAttribute("canExam", canExam);
			}
			
			if(canExam!=null)
			{
				personalityType=careerInclinationServiceImpl.getPersonalityType(eventID,canExam.getCandidate().getCandidateID());
				personalityTypeDetails=careerInclinationServiceImpl.getPersonalityTypeDetails(personalityType);
			}
			
			String imgrelativePath = FileUploadHelper.getRelativeFolderPath(request, "UserPhotoUploadPath");
			model.addAttribute("imgPath", imgrelativePath);

			model.addAttribute("personalityTypeDetails",personalityTypeDetails);
			
			model.addAttribute("clientid", AppInfoHelper.appInfo.getClientID());
		}
		catch(Exception e)
		{
			LOGGER.error("Error in getCareerInclinationTestReport :: ",e);
		}
		return "CareerInclinationTest/careerInclinationTestPrint";
	}
	
}
