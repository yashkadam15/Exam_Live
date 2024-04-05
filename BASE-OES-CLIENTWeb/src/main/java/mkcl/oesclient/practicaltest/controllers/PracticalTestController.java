package mkcl.oesclient.practicaltest.controllers;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mkcl.oes.commons.EncryptionHelper;
import mkcl.oesclient.practicaltest.services.PracticalTestService;
import mkcl.oesclient.viewmodel.PracticalTestViewmodel;
import mkcl.oesserver.model.ERATracPracticalAnswer;
import mkcl.oesserver.model.FunctionMaster;
import mkcl.oesserver.model.ParameterMaster;
import mkcl.oesserver.model.Practical;
import mkcl.oesserver.model.PracticalAnswer;
import mkcl.oesserver.model.PracticalAnswerParameter;
import mkcl.oesserver.model.PracticalPreTest;
import mkcl.oesserver.model.PracticalPreTestParameter;
import mkcl.os.security.AESHelper;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("practical")
public class PracticalTestController {
	private static final Logger LOGGER = LoggerFactory.getLogger(PracticalTestController.class);

	/**
	 * Post method to fetch Practical Question by ID
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = { "getPracticalQuestionbyID" }, method = RequestMethod.POST, consumes="text/xml")
	public void getPracticalQuestionbyIDpost(HttpServletRequest request, HttpServletResponse response) {
	
	
		try {	
			
			
			
			String fkItemID=request.getParameter("fkItemID");
			String fkLanguageID=request.getParameter("fkLanguageID");
			
			
			PracticalTestService practicalTestService= new PracticalTestService();
			Practical practical =practicalTestService.getPracticalQuestionbyID(Long.parseLong(fkItemID),fkLanguageID);
			if(practical!=null)
			{
			StringBuilder sb= new StringBuilder();
			sb.append("<PRACTICAL>");			
			sb.append("<QUESTIONTEXT>");
			sb.append("<LANGUAGEID>"+ practical.getItemLanguage().getFkLanguageID()+"</LANGUAGEID>");
			sb.append("<ITEMTEXT><![CDATA["+practical.getItemText()+"]]></ITEMTEXT>");	
			sb.append("<ITEMFILEPATH><![CDATA["+practical.getItemFilePath()+"]]></ITEMFILEPATH>");	
			sb.append("</QUESTIONTEXT>");
					
			sb.append("<PRACTICALCATEGORY>");	
			sb.append("<CATEGORYID>"+practical.getPracticalSubject().getPracticalCategory().getCategoryID()+"</CATEGORYID>");
			sb.append("<CATEGORYNAME><![CDATA["+practical.getPracticalSubject().getPracticalCategory().getCategoryName()+"]]></CATEGORYNAME>");
			sb.append("</PRACTICALCATEGORY>");		
			
			sb.append("</PRACTICAL>");		
			response.getWriter().write(sb.toString());	
			}
			
		} catch (Exception ex) {
			LOGGER.error("Exception occured in getPracticalQuestionbyID controller: " , ex);	
			
		}

	}
	
	/**
	 * Post method for Practical Pre-load Settings
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = { "getPracticalPreLoadSettings" }, method = RequestMethod.POST)
	public void getPracticalPreLoadSettings(HttpServletRequest request, HttpServletResponse response) {
	
	
		try {	
			
			
			String candId=request.getParameter("candId");
			String candidateExamId=request.getParameter("candidateExamId");
			String candidateExamItemId=request.getParameter("candidateExamItemId");
			
			PracticalTestService practicalTestService= new PracticalTestService();
			PracticalTestViewmodel practicalTestViewmodel= new PracticalTestViewmodel();
			
			practicalTestViewmodel=practicalTestService.getPracticalPreLoadSettings(Long.parseLong(candidateExamItemId),Long.parseLong(candId),Long.parseLong(candidateExamId));
			
			if(practicalTestViewmodel!=null)
			{
			StringBuilder sb= new StringBuilder();
			sb.append("<ROOT>");
				
			for (Map.Entry<Long, PracticalPreTest> entry : practicalTestViewmodel.getPracticalPreTestMap().entrySet())
			{
			sb.append("<PRACTICALPRETEST>");	
			sb.append("<FKITEMLANGUAGEID>"+entry.getValue().getFkItemLanguageID()+"</FKITEMLANGUAGEID>");
			sb.append("<FUNCTION_CODE>"+entry.getValue().getFunctionCode()+"</FUNCTION_CODE>");
			sb.append("<TEST_CODE>"+entry.getValue().getTestCode()+"</TEST_CODE>");
			sb.append("</PRACTICALPRETEST>");
			}			
						
			for (Map.Entry<Long, FunctionMaster> entry : practicalTestViewmodel.getFumctionMasterMap().entrySet())
			{
			sb.append("<FUNCTIONMASTER>");	
			sb.append("<Function_Name><![CDATA["+entry.getValue().getFunctionName()+"]]></Function_Name>");
			sb.append("<FUNCTION_CODE>"+entry.getValue().getFunctionCode()+"</FUNCTION_CODE>");
			sb.append("<SUBJECTID>"+entry.getValue().getSubjectID()+"</SUBJECTID>");
			sb.append("</FUNCTIONMASTER>");
			}			
						
			for (Map.Entry<Long, ParameterMaster> entry : practicalTestViewmodel.getParameterMasterMap().entrySet())
			{
			sb.append("<PARAMETER_MASTER>");	
			sb.append("<PARAMETER_CODE>"+entry.getValue().getParameterCode()+"</PARAMETER_CODE>");
			sb.append("<FUNCTION_CODE>"+entry.getValue().getFunctionCode()+"</FUNCTION_CODE>");
			sb.append("<PARAMETER_NAME><![CDATA["+entry.getValue().getParameterName()+"]]></PARAMETER_NAME>");
			sb.append("<PARAMETERTYPE><![CDATA["+entry.getValue().getParameterType()+"]]></PARAMETERTYPE>");
			sb.append("<SERIALNO>"+entry.getValue().getSerialNo()+"</SERIALNO>");
			sb.append("</PARAMETER_MASTER>");
			}			
					
			for (Map.Entry<Long, PracticalPreTestParameter> entry : practicalTestViewmodel.getPracticalPretestParameterMap().entrySet())
			{
			sb.append("<PRACTICALPRETESTPARAMETER>");	
			sb.append("<PRACTICALPRETESTPARAMETERID>"+entry.getValue().getPracticalPreTestParameterID()+"</PRACTICALPRETESTPARAMETERID>");
			sb.append("<FKITEMLANGUAGEID>"+entry.getValue().getFkItemLanguageID()+"</FKITEMLANGUAGEID>");
			sb.append("<FUNCTION_CODE>"+entry.getValue().getFunctionCode()+"</FUNCTION_CODE>");
			sb.append("<PARAMETER_CODE>"+entry.getValue().getParameterCode()+"</PARAMETER_CODE>");
			sb.append("<PARAMETER_VALUE><![CDATA["+entry.getValue().getParameterValue()+"]]></PARAMETER_VALUE>");
			sb.append("<TEST_CODE>"+entry.getValue().getTestCode()+"</TEST_CODE>");			
			sb.append("</PRACTICALPRETESTPARAMETER>");
			}	
			
			
			sb.append("</ROOT>");
			response.getWriter().write(sb.toString());	
			}
			
		} catch (Exception ex) {
			LOGGER.error("Exception occured in getPracticalPreLoadSettings controller: " , ex);	
			
		}

	}
	
	/**
	 * Post method to Check Practical Answer
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = { "checkPracticalAnswer" }, method = RequestMethod.POST)
	public void checkPracticalAnswer(HttpServletRequest request, HttpServletResponse response) {
	
	
		try {				
			
			String candidateExamId=request.getParameter("candidateExamId");
			String candidateExamItemId=request.getParameter("candidateExamItemId");
			
			PracticalTestService practicalTestService= new PracticalTestService();
			PracticalTestViewmodel practicalTestViewmodel= new PracticalTestViewmodel();
			
			practicalTestViewmodel=practicalTestService.checkPracticalAnswer(Long.parseLong(candidateExamItemId),Long.parseLong(candidateExamId));
			
			if(practicalTestViewmodel!=null)
			{
			StringBuilder sb= new StringBuilder();
			sb.append("<ROOT>");
					
			for (Map.Entry<Long, Practical> entry : practicalTestViewmodel.getPracticalMap().entrySet())
			{
			sb.append("<PRACTICAL>");	
			sb.append("<FKITEMLANGUAGEID>"+entry.getValue().getFkItemLanguageID()+"</FKITEMLANGUAGEID>");
			sb.append("<ITEMTEXT><![CDATA["+entry.getValue().getItemText()+"]]></ITEMTEXT>");
			sb.append("<FKPRACTICALSUBJECTID>"+entry.getValue().getFkPracticalSubjectID()+"</FKPRACTICALSUBJECTID>");
			sb.append("</PRACTICAL>");
			}			
						
			for (Map.Entry<Long, FunctionMaster> entry : practicalTestViewmodel.getFumctionMasterMap().entrySet())
			{
			sb.append("<FUNCTIONMASTER>");	
			sb.append("<Function_Name><![CDATA["+entry.getValue().getFunctionName()+"]]></Function_Name>");
			sb.append("<FUNCTION_CODE>"+entry.getValue().getFunctionCode()+"</FUNCTION_CODE>");
			sb.append("<SUBJECTID>"+entry.getValue().getSubjectID()+"</SUBJECTID>");
			sb.append("</FUNCTIONMASTER>");
			}			
					
			for (Map.Entry<Long, ParameterMaster> entry : practicalTestViewmodel.getParameterMasterMap().entrySet())
			{
			sb.append("<PARAMETER_MASTER>");	
			sb.append("<PARAMETER_CODE>"+entry.getValue().getParameterCode()+"</PARAMETER_CODE>");
			sb.append("<FUNCTION_CODE>"+entry.getValue().getFunctionCode()+"</FUNCTION_CODE>");
			sb.append("<PARAMETER_NAME><![CDATA["+entry.getValue().getParameterName()+"]]></PARAMETER_NAME>");
			sb.append("<PARAMETERTYPE><![CDATA["+entry.getValue().getParameterType()+"]]></PARAMETERTYPE>");
			sb.append("<SERIALNO>"+entry.getValue().getSerialNo()+"</SERIALNO>");
			sb.append("</PARAMETER_MASTER>");
			}			
					
			for (Map.Entry<Long, PracticalAnswer> entry : practicalTestViewmodel.getPracticalAnswerMap().entrySet())
			{
			sb.append("<PRACTICALANSWER>");			
			sb.append("<FKITEMLANGUAGEID>"+entry.getValue().getFkItemLanguageID()+"</FKITEMLANGUAGEID>");
			sb.append("<ANSWER_CODE>"+entry.getValue().getAnswerCode()+"</ANSWER_CODE>");
			sb.append("<Answer_Value><![CDATA["+entry.getValue().getAnswerValue()+"]]></Answer_Value>");
			sb.append("<FUNCTION_CODE>"+entry.getValue().getFunctionCode()+"</FUNCTION_CODE>");					
			sb.append("</PRACTICALANSWER>");
			}			
			
					
			for (Map.Entry<Long, PracticalAnswerParameter> entry : practicalTestViewmodel.getPracticalAnswerParameterMap().entrySet())
			{
			sb.append("<PRACTICALANSWERPARAMETER>");			
			sb.append("<PRACTICALANSWERPARAMETERID>"+entry.getValue().getPracticalAnswerParameterID()+"</PRACTICALANSWERPARAMETERID>");
			sb.append("<ANSWER_CODE>"+entry.getValue().getAnswerCode()+"</ANSWER_CODE>");
			sb.append("<PARAMETER_CODE>"+entry.getValue().getParameterCode()+"</PARAMETER_CODE>");
			sb.append("<PARAMETER_VALUE><![CDATA["+entry.getValue().getParameterValue()+"]]></PARAMETER_VALUE>");
			sb.append("<FUNCTION_CODE>"+entry.getValue().getFunctionCode()+"</FUNCTION_CODE>");
			sb.append("<FKITEMLANGUAGEID>"+entry.getValue().getFkItemLanguageID()+"</FKITEMLANGUAGEID>");					
			sb.append("</PRACTICALANSWERPARAMETER>");
			}			
				
			sb.append("</ROOT>");		
			
			response.getWriter().write(sb.toString());	
			}
		} catch (Exception ex) {
			LOGGER.error("Exception occured in checkPracticalAnswer controller: " , ex);	
			
		}

	}	
	
	/**
	 * Post method for Save Candidate Answer	
	 * @param request
	 * @param response
	 */
	@ResponseBody
	@RequestMapping(value = { "savecandidateAnswer" }, method = RequestMethod.POST)
	public boolean savecandidateAnswer(HttpServletRequest request, HttpServletResponse response) {
			
		try {	
			boolean status = false;			
			//System.out.println(AESHelper.decrypt(new String(request.getParameter("answerJSONText").toString(), StandardCharsets.UTF_8),EncryptionHelper.encryptDecryptKey));
			String candidateExamId=request.getParameter("candidateExamId");
			String candidateExamItemId=request.getParameter("candidateExamItemId");
			String candId=request.getParameter("candId");
			String fkExamEventID=request.getParameter("fkExamEventID");
			String itemID=request.getParameter("itemID");
			String isCorrect=request.getParameter("isCorrect");			
			String marksPerItem = request.getParameter("marksPerItem");
			String negativeMarksPerItem =request.getParameter("negativeMarksPerItem");
			String answerJSONText =request.getParameter("answerJSONText");
			
			PracticalTestService practicalTestService= new PracticalTestService();			
			
			status=practicalTestService.savecandidateAnswer(Long.parseLong(candidateExamItemId),Long.parseLong(candId),Long.parseLong(candidateExamId), Long.parseLong(itemID), Long.parseLong(fkExamEventID), Boolean.parseBoolean(isCorrect),marksPerItem,negativeMarksPerItem,answerJSONText);
			return status;
			
			
			
		} catch (Exception ex) {
			LOGGER.error("Exception occured in savecandidateAnswer controller: " , ex);	
			return false;
		}

	}
	
	/**
	 * Post method for ERATrac Practical Answer
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = { "getERATracPracticalAnswerJSON" }, method = RequestMethod.POST)
	public void getERATracPracticalAnswerJSON(HttpServletRequest request, HttpServletResponse response) {
		try 
		{	
			String fkItemID=request.getParameter("fkItemID");
			String fkLanguageID=request.getParameter("fkLanguageID");

			PracticalTestService practicalTestService= new PracticalTestService();
			ERATracPracticalAnswer eraTracPracticalAnswer =practicalTestService.getERATRACPracticalAnswer(Long.parseLong(fkItemID),fkLanguageID);
			if(eraTracPracticalAnswer!=null)
			{
				StringBuilder sb= new StringBuilder();
				sb.append("<ERATRACPRACTICALANSWER>");
				sb.append("<PRACTICALANSWER>");
				sb.append("<FKITEMLANGUAGEID>"+ eraTracPracticalAnswer.getFkItemLanguageID()+"</FKITEMLANGUAGEID>");
				sb.append("<ANSWERJSONTEXT><![CDATA["+eraTracPracticalAnswer.getAnswerJSONText()+"]]></ANSWERJSONTEXT>");	
				sb.append("</PRACTICALANSWER>");
				sb.append("</ERATRACPRACTICALANSWER>");		
				response.getWriter().write(sb.toString());	
			}
			
		} catch (Exception ex) {
			LOGGER.error("Exception occured in getERATracPracticalAnswerJSON controller: " , ex);	
			
		}

	}
	

}
