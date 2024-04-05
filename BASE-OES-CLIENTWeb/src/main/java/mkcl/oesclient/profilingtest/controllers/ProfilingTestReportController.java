package mkcl.oesclient.profilingtest.controllers;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.commons.utilities.MessageConstants;
import mkcl.oesclient.profilingtest.services.profilingtestServiceImpl;
import mkcl.profilingtestviewmodel.AttemptDateViewModel;
import mkcl.profilingtestviewmodel.profilingtestModel;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;


@Controller
@RequestMapping("profilingTestReport")
public class ProfilingTestReportController{


	private static final Logger LOGGER = LoggerFactory.getLogger(ProfilingTestReportController.class);	
	
	/**
	 * Get method for Candidate
	 * @param model
	 * @param request
	 * @param candidateUserName
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value={"/getCandidate"},method = RequestMethod.GET)
	public String getCandidate(Model model,HttpServletRequest request,String candidateUserName) 
	{
		try
		{
			
		}
		catch(Exception e)
		{
			LOGGER.error("Error in getCandidate :: ",e);
		}
		return "ProfilingTestReport/getCandidate";
	}
	
	/**
	 * Get method for Candidate Profiling Test Report
	 * @param model
	 * @param request
	 * @param candidateUserName
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value={"/candidateProfilingTestReport"},method = RequestMethod.GET)
	public String getCandidateProfilingTestReport(Model model,HttpServletRequest request,String candidateUserName,Locale locale) 
	{
		long exameventid=0;
		try
		{
			List<Long> paperids=new ArrayList<Long>();
			String userName=request.getParameter("candidateUserName");
			//added condition for MFS IGNOU Requirement   15-Nov-2019
			exameventid=Long.parseLong(request.getParameter("eventid"));

						
			profilingtestServiceImpl profilingtestServiceImplObj=new profilingtestServiceImpl();
			List<profilingtestModel> profilingtestModelList= profilingtestServiceImplObj.getProfilingtestReportByCandidateCode(candidateUserName, exameventid);
			AttemptDateViewModel attemptDateViewModel= profilingtestServiceImplObj.getMinMaxAttemptDate(userName, exameventid);
			if(profilingtestModelList!=null && profilingtestModelList.size()>0)
			{
				Map<String, Map<String,String>> mapList= new LinkedHashMap<String, Map<String,String>>();
				Map<String,String> innermap=null;
				for (profilingtestModel profilingtestModel : profilingtestModelList) {
					if(!paperids.contains(profilingtestModel.getPaperID()))
					{
						paperids.add(profilingtestModel.getPaperID());
						innermap= new LinkedHashMap<String, String>();
						for (profilingtestModel innerpm : profilingtestModelList) {
							if(innerpm.getPaperID()==profilingtestModel.getPaperID())
							{
								innermap.put(innerpm.getInterpretationText(), innerpm.getItemBankName());
							}
						}
						mapList.put(profilingtestModel.getPaperName(), innermap);
					}
				}
				model.addAttribute("paperIBMap",mapList);
				model.addAttribute("profilingModelList", profilingtestModelList);
				model.addAttribute("attemptDateViewModel", attemptDateViewModel);
			}
			else if (profilingtestModelList==null) 
			{
				MKCLUtility.addMessage(1044, model, locale);
				
			}
			else if(profilingtestModelList.size()==0){
				MKCLUtility.addMessage(MessageConstants.WARNING_NO_RECORD_FOUND, model, locale);
				
			}
		}
		catch(Exception e)
		{
			LOGGER.error("Error in candidateProfilingTestReport :: ",e);
		}
		
		//added condition for MFS IGNOU Requirement   13-Nov-2019
		if(exameventid==1025)
		{
			//For MFS IGNOU Candidates
			return "Solo/ProfilingTestReport/candidateProfilingTestReportMFS";
		}
		else
		{
			//For Regular Candidates
			return "Solo/ProfilingTestReport/candidateProfilingTestReport";
		}
	}
	

}
