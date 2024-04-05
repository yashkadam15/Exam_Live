package mkcl.oesclient.solo.controllers;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import mkcl.oes.commons.EncryptionHelper;
import mkcl.oes.commons.FileUploadHelper;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.commons.utilities.MessageConstants;
import mkcl.oesclient.model.Candidate;
import mkcl.oesclient.model.CandidateExam;
import mkcl.oesclient.pdfgenerator.PDFComponent;
import mkcl.oesclient.pdfviewmodel.AnswerKeyViewModel;
import mkcl.oesclient.pdfviewmodel.CandidateAttemptPDFViewModel;
import mkcl.oesclient.solo.services.CandidateAttemptReportServiceImpl;
import mkcl.oesclient.solo.services.CandidateServiceImpl;
import mkcl.oesclient.utilities.HTMLToPDFHelper;
import mkcl.oespcs.viewmodel.CandidateAttemptPDF;
import mkcl.oesserver.model.ItemType;
import mkcl.os.security.AESHelper;

@Controller
@RequestMapping("candidateAttempt")
public class CandidateAttemptReportController {

	private static final Logger LOGGER = LoggerFactory.getLogger(CandidateAttemptReportController.class);	
	
	
	/**
	 * Get method for Attempt Details
	 * @param model
	 * @param request
	 * @param candidateUserName
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value={"/attemptDetails"},method = RequestMethod.GET)
	public String getAttemptDetails(Model model,HttpServletRequest request,String candidateUserName) 
	{
		try
		{
			model.addAttribute("candidateUserName", candidateUserName);
		}
		catch(Exception e)
		{
			LOGGER.error("Error in getAttemptDetails...",e);
		}
		return "CandidateAttemptReport/candidateAttempt";
	}
	
	/**
	 * Post method for Attempt Details
	 * @param model
	 * @param request
	 * @param locale
	 * @param candidateUserName
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value={"/attemptDetails"},method = RequestMethod.POST)
	public String postAttemptDetails(Model model,HttpServletRequest request,Locale locale,String candidateUserName)
	{
		List<CandidateExam> exams=null;
		try
		{
			CandidateAttemptReportServiceImpl serviceImpl=new CandidateAttemptReportServiceImpl();
			if(candidateUserName!=null && !candidateUserName.isEmpty())
			{
				model.addAttribute("candidateUserName", candidateUserName);
				exams=serviceImpl.getPaperListByCandidateCode(candidateUserName);
				if(exams!=null && exams.size()>0)
				{
					model.addAttribute("candidateExamList",exams);
				}
				else
				{
					MKCLUtility.addMessage(MessageConstants.WARNING_NO_RECORD_FOUND, model, locale);
				}
			}
		}
		catch(Exception e)
		{
			LOGGER.error("Error in getAttemptDetails...",e);
		}
		return "CandidateAttemptReport/candidateAttempt";
	}
	
	/**
	 * Method for Export Attempt Detail to PDF
	 * @param request
	 * @param locale
	 * @param response
	 * @param candidateID
	 * @param eventID
	 * @param paperID
	 * @param attemptNo
	 */
	@RequestMapping({"exportAttemptDetailToPdf"})
	public void exportCadidateAttemptReportToPDF(HttpServletRequest request,Locale locale,HttpServletResponse response,String candidateID, String eventID,String paperID,String attemptNo)
	{
		CandidateExam exam=null;
		CandidateAttemptPDFViewModel viewModel=null;
		List<CandidateAttemptPDF> attemptPDFViewModel=null;
		boolean status=false;
		try
		{
			CandidateAttemptReportServiceImpl serviceImpl=new CandidateAttemptReportServiceImpl();
			attemptPDFViewModel=serviceImpl.getCandidateAttemptPDFList(Long.parseLong(candidateID), Long.parseLong(paperID), Long.parseLong(eventID), Long.parseLong(attemptNo));
			exam=serviceImpl.getCandVenuePaperDetails(Long.parseLong(candidateID), Long.parseLong(eventID), Long.parseLong(paperID), Long.parseLong(attemptNo));
			PDFComponent<CandidateAttemptPDFViewModel> pdfGen = new PDFComponent<CandidateAttemptPDFViewModel>(request, response);
			
			if(attemptPDFViewModel!=null && attemptPDFViewModel.size()>0)
			{
				viewModel=new CandidateAttemptPDFViewModel();
				viewModel.setAttemptPDFs(attemptPDFViewModel);
				viewModel.setLocale("messages_"+locale.getLanguage() +".properties"); 
				
				viewModel.setEventName(exam.getExamEvent().getName());
				viewModel.setCandidateCode(exam.getCandidate().getCandidateCode());
				viewModel.setVenueCode(exam.getExamVenue().getExamVenueCode());
				viewModel.setVenueName(exam.getExamVenue().getExamVenueName());
				viewModel.setPaperID(exam.getPaper().getPaperID());
				viewModel.setPaperName(exam.getPaper().getName());
				viewModel.setFirstName(exam.getCandidate().getCandidateFirstName());
				viewModel.setMiddleName(exam.getCandidate().getCandidateMiddleName());
				viewModel.setLastName(exam.getCandidate().getCandidateLastName());
				viewModel.setAttemptedDate(new SimpleDateFormat("dd MMM yyyy HH:mm:ss").format(exam.getAttemptDate()));
				viewModel.setExamStatus(exam.getIsExamCompleted());
				viewModel.setAttemptNo(exam.getAttemptNo());
				
				viewModel.setTotQuestions(exam.getPaper().getTotalItem());
				
				int atmptQues=serviceImpl.getAttemptedQuesCnt(Long.parseLong(candidateID), Long.parseLong(eventID), Long.parseLong(paperID), Long.parseLong(attemptNo));
				viewModel.setAttemptedQuestions(atmptQues);
				viewModel.setRemainingQuestios(Long.parseLong(viewModel.getTotQuestions())-viewModel.getAttemptedQuestions());
				
				viewModel.setMarksObtained(exam.getMarksObtained());
			
				pdfGen.setInputsToXML(viewModel);
				pdfGen.setStyleSheetXSLName("candidateAttemptReport.xsl");
				pdfGen.setPdfFileName(exam.getCandidate().getCandidateCode()+"_"+paperID+"_AttemptDetails");
				status = pdfGen.startPDFGeneratorEngine();
			}
			//code to display message 
			if (!status) {
				pdfGen.writeErrorResponseContent();
			}
		}
		catch(Exception e)
		{
			LOGGER.error("Error in exportAttemptDetailsToPdf",e);
		}
	}	

	/**
	 * Method to Display Attempt Details in HTML
	 * @param request
	 * @param locale
	 * @param response
	 * @param candidateID
	 * @param eventID
	 * @param paperID
	 * @param attemptNo
	 * @param model
	 * @return String this returns the path of a view
	 */
	@RequestMapping({"getAttemptedDetailsInHTML"})
	public String getAttemptDetailsInHtml(HttpServletRequest request,Locale locale,HttpServletResponse response,String candidateID, String eventID,String paperID,String attemptNo,Model model)
	{
		CandidateExam exam=null;
		CandidateAttemptPDFViewModel viewModel=null;
		List<CandidateAttemptPDF> attemptPDFViewModel=null;
		Map<Long, String> mtcItemIdAndCellDataMap = null;
		try
		{
			CandidateAttemptReportServiceImpl serviceImpl=new CandidateAttemptReportServiceImpl();
			
			//This request excluded from security filter for Result Engine hence cookie is checked for security reason Yograj 23-Aug-2019
			Cookie[] cookies = request.getCookies();
			boolean isRequestValid=true;
			/*if (cookies != null) {
			 for (Cookie cookie : cookies) {
			   if (cookie.getName().equals("ResultEngine") && cookie.getValue().equals(AESHelper.decrypt("ResultEngine", EncryptionHelper.encryptDecryptKey))) {
				   isRequestValid=true;
			    }
			  }
			}*/
			if(!isRequestValid)
			{
				LOGGER.error("Access denied..! Cookie Validation Failed in getAttemptedDetailsInHTML");
				return "redirect:../login/logout";
			}
			//End
			
			attemptPDFViewModel=serviceImpl.getCandidateAttemptPDFList(Long.parseLong(candidateID), Long.parseLong(paperID), Long.parseLong(eventID), Long.parseLong(attemptNo));
			exam=serviceImpl.getCandVenuePaperDetails(Long.parseLong(candidateID), Long.parseLong(eventID), Long.parseLong(paperID), Long.parseLong(attemptNo));
			
			if(attemptPDFViewModel!=null && attemptPDFViewModel.size()>0)
			{
				viewModel=new CandidateAttemptPDFViewModel();
				viewModel.setAttemptPDFs(attemptPDFViewModel);
				viewModel.setLocale("messages_"+locale.getLanguage() +".properties"); 
				
				viewModel.setEventName(exam.getExamEvent().getName());
				viewModel.setCandidateCode(exam.getCandidate().getCandidateCode());
				viewModel.setVenueCode(exam.getExamVenue().getExamVenueCode());
				viewModel.setVenueName(exam.getExamVenue().getExamVenueName());
				viewModel.setPaperID(exam.getPaper().getPaperID());
				viewModel.setPaperName(exam.getPaper().getName());
				viewModel.setFirstName(exam.getCandidate().getCandidateFirstName());
				viewModel.setMiddleName(exam.getCandidate().getCandidateMiddleName());
				viewModel.setLastName(exam.getCandidate().getCandidateLastName());
			//	if(exam.getAttemptDate()!=null)
				viewModel.setAttemptedDate(new SimpleDateFormat("dd MMM yyyy HH:mm:ss").format(exam.getAttemptDate()));
				
				viewModel.setExamStatus(exam.getIsExamCompleted());
				viewModel.setAttemptNo(exam.getAttemptNo());
				
				viewModel.setTotQuestions(exam.getPaper().getTotalItem());
				
				int atmptQues=serviceImpl.getAttemptedQuesCnt(Long.parseLong(candidateID), Long.parseLong(eventID), Long.parseLong(paperID), Long.parseLong(attemptNo));
				viewModel.setAttemptedQuestions(atmptQues);
				viewModel.setRemainingQuestios(Long.parseLong(viewModel.getTotQuestions())-viewModel.getAttemptedQuestions());
				
				viewModel.setMarksObtained(exam.getMarksObtained());
				viewModel.setCandidatePaperLanguage(exam.getCandidatePaperLanguage());
				
				 mtcItemIdAndCellDataMap = new HashMap<Long, String>(); 
				for(CandidateAttemptPDF candAttmptVm : attemptPDFViewModel) {
					if(candAttmptVm.getItemType().equals(ItemType.MTC.toString()) || candAttmptVm.getItemType().equals(ItemType.SQ.toString())) {
						mtcItemIdAndCellDataMap.put(candAttmptVm.getItemID(), candAttmptVm.getCellData());
					}
				}
				model.addAttribute("mtcItemIdAndCellDataMap", mtcItemIdAndCellDataMap);
				model.addAttribute("candidateAttemptDetails", viewModel);
			}
			//code to display message 
	
		}
		catch(Exception e)
		{
			try {
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			} catch (IOException e1) {
				LOGGER.error("Exception while setting status to response", e);
			} 
			
			LOGGER.error("Exception while getAttemptDetailsInHtml", e);
		}
		
		return "CandidateAttemptReport/candidateAttemptDetailsHTML";
	}
	
	/**
	 * Post method for Export Attempt Detail to PDF 
	 * @param model
	 * @param request
	 * @param response
	 * @param locale
	 * @param viewModel
	 * @return String this returns the path of a view
	 */
	@ResponseBody
	@RequestMapping(value = { "/exportAttemptDetailToPdf_wkhtml" }, method = RequestMethod.POST)
	public String generateAttemptDetailsPdfFormUsingwkhtml(Model model, HttpServletRequest request, HttpServletResponse response, Locale locale, @RequestBody AnswerKeyViewModel viewModel) {
		Candidate candidateObj = null;
		String generatedPdfFileName = null;
		try {			
			CandidateServiceImpl candidateServiceImpl=new CandidateServiceImpl();
			
			HTMLToPDFHelper htmlToPdfHelper = new HTMLToPDFHelper();
			List<String> listCmd=new ArrayList<String>();
			listCmd.add("--footer-center");
			listCmd.add("[page]/[topage]");
			listCmd.add(htmlToPdfHelper.makeFullURL(request, "/candidateAttempt/getAttemptedDetailsInHTML?candidateID="+viewModel.getCandidateID()+"&eventID="+viewModel.getExamEventID()+"&paperID="+viewModel.getPaperID()+"&attemptNo="+viewModel.getAttemptNo()));
			listCmd.add("--cookie");
			listCmd.add("JSESSIONID");
			listCmd.add(request.getSession(false).getId());
			
			candidateObj = candidateServiceImpl.getCandidateByCandidateID(viewModel.getCandidateID());
			generatedPdfFileName = new HTMLToPDFHelper().generateHTMLToPDF(listCmd, candidateObj.getCandidateCode() +"_"+viewModel.getPaperID()+"_AttemptDetails.pdf");
		 
		} catch (Exception e) {
			LOGGER.error("Exception in generateAttemptDetailsPdfFormUsingwkhtml...", e);		
		}
		return generatedPdfFileName;
	}
	
	/**
	 * Get method to Display Image
	 * @param model
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = { "/displayImage" }, method = RequestMethod.GET)
	public void demoImg(Model model, HttpServletRequest request, HttpServletResponse response) {

		try {
			String imgName = request.getParameter("disImg");
			if (imgName != null && !imgName.isEmpty()) {

				File sourceFile = new File(FileUploadHelper.getPhysicalFolderPathWithinWebApp(request, "FileUploadPath") + imgName);
				if(sourceFile.exists())
				{
					OutputStream os = AESHelper.decryptAsStream(sourceFile, EncryptionHelper.encryptDecryptKey);
					ByteArrayOutputStream baos = new ByteArrayOutputStream();
					baos = (ByteArrayOutputStream) os;
	
					byte[] imageBytes = baos.toByteArray();
					response.setContentType("image/jpeg");
					response.setContentLength(imageBytes.length);
					OutputStream outs = response.getOutputStream();
					outs.write(imageBytes);
				}
				else 
				{
					 LOGGER.error("File not Exists:"+sourceFile.getName());
				}
			}

		} catch (Exception e) {
			LOGGER.error("Exception in displayImage",e) ;
		}

	}
}
