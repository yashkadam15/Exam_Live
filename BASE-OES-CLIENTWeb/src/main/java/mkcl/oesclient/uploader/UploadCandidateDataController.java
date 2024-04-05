package mkcl.oesclient.uploader;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("upload")
public class UploadCandidateDataController 
{
	private static final Logger LOGGER = LoggerFactory.getLogger(UploadCandidateDataController.class);
		
	@RequestMapping(value = { "/AjaxPerformUpload" }, method = RequestMethod.GET)
	@ResponseBody
	public ResponseEntity<?> performUpload(Model model, HttpServletRequest request,@RequestParam long paperID,@RequestParam long examEventID) 
	{
		try
		{
			int result;
			if(paperID > 0 && examEventID > 0)
				result = CandidateExamDataUploader.uploadPaperWiseData(paperID, examEventID);
			else
				result = CandidateExamDataUploader.uploadAllData();
			return new ResponseEntity<Integer>(result, HttpStatus.OK);			
		}
		catch(Exception e)
		{
			LOGGER.error("",e);
			return new ResponseEntity<Error>(new Error("Some exception is occured"),HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}
}
