package mkcl.oesclient.commons.controllers;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import mkcl.oesclient.commons.utilities.FileUploadHelper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.AntPathMatcher;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.HandlerMapping;

@Controller
@RequestMapping("FileUploader")
public class FileUploadController {
	private static final Logger LOGGER = LoggerFactory.getLogger(FileUploadController.class);
	
	/**
	 * Post method for Upload Evidences
	 * @param model
	 * @param request
	 * @param response
	 * @param file
	 */
	@RequestMapping(value = { "/uploadEvidences/**" }, method = RequestMethod.POST)
	public void uploadEvidences(Model model, HttpServletRequest request,HttpServletResponse response,MultipartFile file ) {
		boolean result=false;
		try 
		{			
			String pattern = (String) request.getAttribute(HandlerMapping.BEST_MATCHING_PATTERN_ATTRIBUTE);			
			String innerFolderPAth =  new AntPathMatcher().extractPathWithinPattern(pattern, request.getServletPath());			
			String evidenceUploadPath=FileUploadHelper.getPhysicalFolderPathWithinWebApp(request, "EvidenceUploadPath");	
			result = FileUploadHelper.uploadFileServiceWithFileName(evidenceUploadPath+File.separator+innerFolderPAth, file);
		} 		
		catch (Exception e) {
			LOGGER.error("Error occourd in uploadFile: " , e); 
		}
		finally{
		response.setContentType("text/html");
		PrintWriter out;
		try {
			out = response.getWriter();			
			out.println(String.format("fileName=%s,uploadStatus=%s", file.getOriginalFilename(), String.valueOf(result).toLowerCase()));
			out.flush();
			out.close();
		} catch (IOException e) {
			LOGGER.error("Error occourd in uploadFile: " , e); 
		}
		
		}
	}
	
	/**
	 * Post method for Upload File
	 * @param model
	 * @param request
	 * @param response
	 * @param file
	 */
	@RequestMapping(value = { "/uploadFile/**" }, method = RequestMethod.POST)
	public void uploadFile(Model model, HttpServletRequest request,HttpServletResponse response,MultipartFile file ) {
		boolean result=false;
		try 
		{			
			String pattern = (String) request.getAttribute(HandlerMapping.BEST_MATCHING_PATTERN_ATTRIBUTE);			
			String innerFolderPAth =  new AntPathMatcher().extractPathWithinPattern(pattern, request.getServletPath());			
			String evidenceUploadPath=FileUploadHelper.getPhysicalFolderPathWithinWebApp(request, "WebFilesPath");	
			result = FileUploadHelper.uploadFileServiceWithFileName(evidenceUploadPath+File.separator+innerFolderPAth, file);
		} 		
		catch (Exception e) {
			LOGGER.error("Error occourd in uploadFile: " , e); 
		}
		finally{
		response.setContentType("text/html");
		PrintWriter out;
		try {
			out = response.getWriter();			
			out.println(String.format("fileName=%s,uploadStatus=%s", file.getOriginalFilename(), String.valueOf(result).toLowerCase()));
			out.flush();
			out.close();
		} catch (IOException e) {
			LOGGER.error("Error occourd in uploadFile: " , e); 
		}
		
		}
	}
}