/**
 * @author reenak
 * Upload post Login activity and Exam Log data to Central Server via ESB
 */

package mkcl.oesclient.commons.controllers;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.ObjectWriter;

import mkcl.oesclient.commons.services.OESLogServices;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.viewmodel.ViewModelOESLog;
import mkcl.os.apps.MKCLHttpClient;
import mkcl.os.security.AESHelper;

public class UploadOESLogDataController {

	private static final Logger LOGGER = LoggerFactory.getLogger(UploadOESLogDataController.class);
	private static final String ESBURL = "/transformer/executeTransformerJsonSecure/baseOESUploadLog";
	private static final String TRANSFORMERID = "DB1-DB277777777777770010";
	private static final String APPLICATIONID = "abc";
	private static final String AESDECRYPTKEY = "MKCLSecurity$#@!";
	private static final int CONNECTIONSUCCESS = 1;
	OESLogServices oesLogServices = new OESLogServices();
	
	// method to upload Oes Log data to Central server
	/**
	 * Method to Upload OES Log Data
	 * @param examVenueId
	 * @param examEventId
	 * @return boolean this returns true on success
	 */
	public boolean uploadOESLogData( long examVenueId,Long examEventId) {
		
		int uploadDataStatus=0;
		boolean updateStatus=false;
		try {			
			String decryptedJsonResonse = "";
			ViewModelOESLog viewModelOESLog = null;			
			
			// check for data to be upload
			viewModelOESLog = oesLogServices.getOesExamLogData(examVenueId, examEventId);
			if (viewModelOESLog!=null) {
			
					//Parse View Model Obj to Json format
					String oesLogDataJsonStr = parseOesLogDataInJson(viewModelOESLog);
					if(!oesLogDataJsonStr.isEmpty())
					{
					// Requesting ESB to transfer data
					decryptedJsonResonse = requestESB(oesLogDataJsonStr,examVenueId,examEventId);
					
						uploadDataStatus=parseReturnOESLogStatus(decryptedJsonResonse);
						// update log status in client db if successful upload
						if(uploadDataStatus==1)
						{
							updateStatus=oesLogServices.updateUploadStatusOfLogData(examEventId);
						}
						else
						{
							LOGGER.info("Oes Log details not uploaded to central Server...Upload return status ::",updateStatus);
							updateStatus=false;
						}
						
					}
				
			}
		} catch (Exception e) {
			LOGGER.error("Exception Occured in uploadOESLogData: " , e);
			updateStatus=false;
		}
		
		return updateStatus;

	}

	// Transfer via ESB
	/**
	 * Method to Request ESB
	 * @param oesLogJsonStr
	 * @param examEventId
	 * @param examVenueId
	 * @return String this returns the response as JSON text
	 */
	private String requestESB(String oesLogJsonStr,Long examEventId,Long examVenueId) {
		String jsonResonse = "";
		try {
			
			//compress and encrypt JSON Strings
			String oesLogJsonCopmpressed=AESHelper.encryptAsCompress(oesLogJsonStr, AESDECRYPTKEY);
			
			HttpPost postRequest = new HttpPost(MKCLUtility.loadConnectionPropertiesFile().getProperty("ESBURL") + ESBURL);
			// Add request parameters required to send for data upload
			Map<String, String> requestParameters = new HashMap<String, String>();
			// transformer ID
			requestParameters.put("transformerId", TRANSFORMERID);
			requestParameters.put("appId", APPLICATIONID);
			requestParameters.put("oesLogDataJson", oesLogJsonCopmpressed);
			requestParameters.put("examVenueId", examVenueId.toString());
			requestParameters.put("examEventId", examEventId.toString());
			
			// send request to esb
			postRequest = MKCLHttpClient.addParametersToPost(postRequest, requestParameters);
			HttpResponse response = MKCLHttpClient.sendRequest(postRequest);
			// get response from esb			
			// Reading the JSON response
			HttpEntity httpEntity = response.getEntity();
			InputStream inputStream = httpEntity.getContent();
			BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));
			StringBuilder sb = new StringBuilder();
			String line = null;
			while ((line = reader.readLine()) != null) {
				sb.append(line + "\n");
			}
			inputStream.close();
			String jsonText = sb.toString();
			// decrypt and decompress json response
			if (jsonText.length() > 2) {
				jsonText = AESHelper.decryptAsdecompress(jsonText, AESDECRYPTKEY);
				jsonResonse = jsonText;
			}
		} catch (Exception e) {
			LOGGER.error("Exception Occured while calling ESB-requestESB: " , e);
		}
		return jsonResonse;
	}

	// method to check connection to esb from application
	/**
	 * Method to check Connection to ESB
	 * @return int this returns the connection status
	 */
	private int checkConnectionToESB() {
		int iConnectStatus = 0;
		int status = 0;
		try {
			
			HttpURLConnection urlc = (HttpURLConnection) new URL(MKCLUtility.loadConnectionPropertiesFile().getProperty("ESBURL")).openConnection();
			Map headerfields = urlc.getHeaderFields();
			iConnectStatus = headerfields.size();
		} catch (Exception e) {
			LOGGER.error("Exception Occured while Checking ESB Connection-checkConnectionToESB: " , e);
		}
		if (iConnectStatus != 0) {
			status = CONNECTIONSUCCESS;			
			LOGGER.info("Connection is Available");
			
		}else{			
			LOGGER.info("Connection is Not Available");
			
		}
		return status;
	}
	
	// parse Log data into Json format to send to esb
	/**
	 * Method to parse OES Log data in JSON format to send to ESB
	 * @param viewModelOESLog
	 * @return String this returns the OES log data
	 */
	private String parseOesLogDataInJson(ViewModelOESLog viewModelOESLog) {
		String oesLogDataInJson = "";
		try {
			ObjectMapper mapper = new ObjectMapper();
			if (viewModelOESLog != null && viewModelOESLog.getOesExamLogList().size()>0 && viewModelOESLog.getOesLogList().size() > 0) {
				oesLogDataInJson = mapper.writeValueAsString(viewModelOESLog);
			}
		} catch (Exception e) {
			LOGGER.error("Exception Occured while Parsing setOesLogDataInJson-: " , e);
		}
		return oesLogDataInJson;
	}
	
	// method to get return object status and parse it to respective object
	/**
	 * Method to fetch the Return Object Status and parse it to the Respective Object
	 * @param jsonText
	 * @return int this returns the return OES log status
	 */
	private int parseReturnOESLogStatus(String jsonText) {
		int returnedOesLogStatus=0;
		ViewModelOESLog viewModelOESLog=null;
		ObjectMapper mapper = new ObjectMapper();
		try {
			if (jsonText != null && jsonText != "") {
				Object returnObject = getReturnObject(jsonText);
				if (returnObject == null) {
					return 0;
				}
				ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
				byte[] tempJson = ow.writeValueAsBytes(returnObject);
	            JavaType javaType = mapper.getTypeFactory().constructType(ViewModelOESLog.class);
	            viewModelOESLog = mapper.readValue(tempJson, javaType);
	            if (viewModelOESLog != null) {
	            	returnedOesLogStatus = viewModelOESLog.getUploadStatus();	               
	            }
			}
		} catch (Exception e) {			
			LOGGER.error("Exception occured in parseReturnOESLogStatus : ", e);
		}

		return returnedOesLogStatus;
	}

	// Method to extract return object from json
	/**
	 * Method to fetch Return Object from JSON
	 * @param jsonText
	 * @return Object this returns the return object
	 */
	@SuppressWarnings("rawtypes")
	private static Object getReturnObject(String jsonText) {
		ObjectMapper mapper = new ObjectMapper();
		Object returObject = null;
		try {

			HashMap payload = mapper.readValue(jsonText, HashMap.class);
			Iterator it = payload.entrySet().iterator();
			while (it.hasNext()) {
				Map.Entry pairs = (Map.Entry) it.next();
				if (pairs.getKey().toString().equals("returnObject")) {
					return pairs.getValue();
				}
			}
		} catch (Exception e) {			
			LOGGER.error("Exception occured while  getReturnObjectt : " , e);
		}
		return returObject;
	}
	
	
	
}
