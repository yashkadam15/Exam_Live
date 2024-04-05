/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package mkcl.oesclient.sync.controllers;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.text.Format;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.ObjectWriter;

import mkcl.oesclient.commons.services.ExamEventServiceImpl;
import mkcl.oesclient.commons.utilities.AppInfoHelper;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.sync.model.BaseOESSingleCandidateViewModel;
import mkcl.oesclient.sync.model.OESSyncConstants;
import mkcl.oesclient.sync.model.VersionStatus;
import mkcl.oesclient.sync.services.OESSingleCandidateService;
import mkcl.oespcs.model.ExamEvent;
import mkcl.os.apps.MKCLHttpClient;
import mkcl.os.security.AESHelper;

/**
 *
 * @author yograjs
 */
public class SynchronizeSingleCandidateData 
{
    private static final Logger LOGGER = LoggerFactory.getLogger(SynchronizeSingleCandidateData.class);


/**
 * Method to Synchronize Single Candidate Data 
 * @param exameventId
 * @param userName
 * @param request
 * @return boolean this returns true on success
 */
public boolean synchronizeSingleCandidateData(String exameventId,String userName,HttpServletRequest request) 
    {
        boolean isCandidateSynced=false;
            try 
            {
            	/*OESSyncConstants.syncMsg+="\n     Candidate Data Synchronization ";
            	OESSyncConstants.syncMsg+="\n----------------------------------------------------------------------------------------";
               */ 
            	boolean isSaved =false;
                String jsonText = "";
                
                if(!exameventId.isEmpty() && Long.parseLong(exameventId)>0 && userName.trim().length()>0)
                {
                        //download data code
                    ServerConnectionCheckHelper serverConnectionCheckHelper=new ServerConnectionCheckHelper();
                    OESSyncConstants.currentTask = "1/4 Establishing connection with server ";
            		OESSyncConstants.progressBarPercentage = 5;
            		OESSyncConstants.esbConnectionStatus = OESSyncConstants.currentTask+OESSyncConstants.progressBarPercentage+"%";
            		OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus;
            		
                    int iConnectStatus = serverConnectionCheckHelper.checkConnectionToESB();

                    if (iConnectStatus == 0) 
                    {     
                    	OESSyncConstants.progressBarPercentage = OESSyncConstants.SUCCESSFULL_COMPLETION_PER;
                		OESSyncConstants.esbConnectionStatus = OESSyncConstants.currentTask+OESSyncConstants.progressBarPercentage+"% <i class=\"icon-ok\"></i>";
                		OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus;
                    	//OESSyncConstants.syncMsg+="\n Connection established Successfully.";
                            ExamEvent examEvent=new ExamEventServiceImpl().getExamEventByID(Long.parseLong(exameventId));
                            
                            int isVersionChange = 0;
                            String version = null;
                            if (examEvent != null) {
                            version = String.valueOf(examEvent.getExamEventversion());
                            //version=String.valueOf(examEvent.getExamEventversion());
                            Map<String, String> reqMap = new HashMap<String, String>();
                            reqMap.put("exameventVersion", version);
                            //reqMap.put("exameventVersion",String.valueOf(7) );
                            reqMap.put("eventID", exameventId);
                            OESSyncConstants.currentTask = "<br>2/4 Checking Exam Event version from server ";
                            isVersionChange = eventVersionCheckTransformerRequest(reqMap);
                            
                            OESSyncConstants.progressBarPercentage = OESSyncConstants.SUCCESSFULL_COMPLETION_PER;
                     		OESSyncConstants.eventVersionCheckStatus = OESSyncConstants.currentTask+OESSyncConstants.progressBarPercentage+"% <i class=\"icon-ok\"></i>";
                     		OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus+OESSyncConstants.eventVersionCheckStatus;
                        }

                        BaseOESSingleCandidateViewModel candidateViewModel=null;

                        if (isVersionChange !=0 ) 
                        {
                        	
                           // System.out.println("Downloading candidate data from server.");

                        	String appName = AppInfoHelper.appInfo.getAppName();
                        	OESSyncConstants.currentTask = "<br>3/4 DOwnLoading Data from server ";
                            jsonText = getCandidateDetails(examEvent.getExamEventID(), AppInfoHelper.appInfo.getExamVenueId(),AppInfoHelper.appInfo.getExamVenueCode(),userName,appName);

                            if (jsonText.length() > 2) 
                            {
                                candidateViewModel=null;
                                candidateViewModel = parseCandidateList(jsonText);

                                if (candidateViewModel != null && candidateViewModel.getCandidate() != null) 
                                {
                                	  OESSyncConstants.progressBarPercentage = OESSyncConstants.SUCCESSFULL_COMPLETION_PER;
                              		OESSyncConstants.downloadEventDataStatus = OESSyncConstants.currentTask+OESSyncConstants.progressBarPercentage+"% <i class=\"icon-ok\"></i>";
                              		OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus+OESSyncConstants.eventVersionCheckStatus+OESSyncConstants.downloadEventDataStatus;
                                      
                                	
                                	/*OESSyncConstants.syncMsg+="\n Data downloaded successfully.";*/
                                	/*OESSyncConstants.syncMsg+="\n Processing downloaded data...";*/
                              		 OESSyncConstants.currentTask = "<br>4/4 Processing downloaded Exam Event data ";
                                     if (candidateViewModel.getCandidate().getCandidatePhoto() != null && !candidateViewModel.getCandidate().getCandidatePhoto().isEmpty()) 
                                     {
                                         new SynchronizeCandidateData().getCandidateImagesfromSOLAR(candidateViewModel.getCandidate().getCandidatePhoto(),request);
                                     }
                                     
                                     isSaved = new OESSingleCandidateService().saveOrUpdateCandidateDetails(candidateViewModel,examEvent.getExamEventID());
                                     if (isSaved)
                                     {
                                            isCandidateSynced=true;
                                          /*  OESSyncConstants.syncMsg+="\n Candidate synchronized successfully.";*/
                                            OESSyncConstants.progressBarPercentage =OESSyncConstants.SUCCESSFULL_COMPLETION_PER;
                                			OESSyncConstants.processEventDataStatus = OESSyncConstants.currentTask+OESSyncConstants.progressBarPercentage+"% <i class=\"icon-ok\"></i>";
                                			OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus+OESSyncConstants.eventVersionCheckStatus+OESSyncConstants.downloadEventDataStatus+OESSyncConstants.processEventDataStatus;
                                        
                                     }
                                     else
                                     {
                                            
                                    	 OESSyncConstants.syncMsg+="\n Error in the processing downloaded data.";
                                     }
                                }
                                else 
                                {
                                    
                                	OESSyncConstants.syncMsg+="\n No data found for download.";
                                                            }
                                }
                                else
                                {
                                    
                                	OESSyncConstants.syncMsg+="\n No data found for download.";
                                }
                        }

                    }
                    else
                    {
                    	OESSyncConstants.syncMsg+="\n Error in establishing connection";
                       
                    }
                }
                else
                {
                        return isCandidateSynced;
                }

            }
            catch(Exception e)
            {
                 LOGGER.error("Exception Occured Single Candidate Synchronizer: " + e);
            }

            return isCandidateSynced;
    }

/**
 * Method to fetch Candidate Details
 * @param eventId
 * @param venueId
 * @param venueCode
 * @param userName
 * @param appName
 * @return String this returns candidate details as JSON text
 */
private String getCandidateDetails(long eventId, long venueId,String venueCode,String userName,String appName) 
	{
		
            String jsonText = "";
            String url = MKCLUtility.loadConnectionPropertiesFile().getProperty("ESBURL") + "/transformer/executeTransformerJsonSecure/BaseOESSingleCandidate";       
            String transformerId = "DB1-DB2777777777777700019";
            try {
                HttpPost postRequest = new HttpPost(url);
                Map<String, String> requestParameters = new HashMap<String, String>();
                requestParameters.put("transformerId", transformerId);
                requestParameters.put("appId", "abc");

                requestParameters.put("eventID", String.valueOf(eventId));
                requestParameters.put("venueID", String.valueOf(venueId));

                requestParameters.put("venuecode", venueCode);
                Format formatter = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
                String dt = formatter.format(new Date());
                requestParameters.put("activitytime", dt);

                requestParameters.put("appname", appName);
                requestParameters.put("userName", userName);

                postRequest = MKCLHttpClient.addParametersToPost(postRequest, requestParameters);
                OESSyncConstants.progressBarPercentage = 25;
        		OESSyncConstants.downloadEventDataStatus = OESSyncConstants.currentTask+OESSyncConstants.progressBarPercentage+"%";
        		OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus+OESSyncConstants.eventVersionCheckStatus+OESSyncConstants.downloadEventDataStatus;
                
                OESSyncConstants.syncMsg+="\n Downloading data from server...";

                HttpResponse response = MKCLHttpClient.sendRequest(postRequest);

                HttpEntity httpEntity = response.getEntity();
                InputStream inputStream = httpEntity.getContent();
                BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));
                StringBuilder sb = new StringBuilder();
                String line = null;
                while ((line = reader.readLine()) != null) {
                    sb.append(line + "\n");
                }
                inputStream.close();
                jsonText = sb.toString();


                if (jsonText.length() > 2) {

                    jsonText = AESHelper.decryptAsdecompress(jsonText, "MKCLSecurity$#@!");
                }
            } catch (IllegalStateException e) {
                LOGGER.error("Exception Occured Candidate Synchronizer: " + e);
                OESSyncConstants.syncMsg+="\n Error in downloading data";

            } catch (IOException e) {
                LOGGER.error("Exception Occured Candidate Synchronizer: " + e);
                OESSyncConstants.syncMsg+="\n Error in downloading data";
            } catch (Exception e) {
                LOGGER.error("Exception Occured Candidate Synchronizer: " + e);
                OESSyncConstants.syncMsg+="\n Error in downloading data";

            }
            return jsonText;
    }

	/**
	 * Method for Exam Event Version Check Transformer Request
	 * @param requestMap
	 * @return Integer this returns the exam event version status
	 * @throws Exception
	 */
	public Integer eventVersionCheckTransformerRequest(Map<String, String> requestMap) throws Exception {
        
		
        String url = MKCLUtility.loadConnectionPropertiesFile().getProperty("ESBURL") + "/transformer/executeTransformerJsonSecure/BaseOESEventVersion";       
        String transformerId = "DB1-DB277777777777770004";
        int versionStatus = 0;
        try {

        	/*OESSyncConstants.syncMsg+="\n Checking Exam Event version from server...";*/
                HttpPost postRequest = new HttpPost(url);
                Map<String, String> requestParams = new HashMap<String, String>();
                requestParams.put("transformerId", transformerId);
                requestParams.put("appId", "abc");
                if (requestMap.get("exameventVersion") == null) {
                    requestParams.put("exameventVersion", requestMap.get("exameventVersion"));
                } else {
                    requestParams.put("exameventVersion", requestMap.get("exameventVersion").toString());
                }
                requestParams.put("eventID", requestMap.get("eventID").toString());
                postRequest = MKCLHttpClient.addParametersToPost(postRequest,
                        requestParams);

                OESSyncConstants.progressBarPercentage = 25;
        		OESSyncConstants.eventVersionCheckStatus = OESSyncConstants.currentTask+OESSyncConstants.progressBarPercentage+"%";
        		OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus+OESSyncConstants.eventVersionCheckStatus;
     
                
                HttpResponse response = MKCLHttpClient.sendRequest(postRequest);
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

                if (jsonText.length() > 2) {
                    jsonText = AESHelper.decryptAsdecompress(jsonText, "MKCLSecurity$#@!");
                }
                versionStatus = parseEventVersionCheckData(jsonText);

                if (versionStatus==0) {
                	OESSyncConstants.syncMsg+="\n Update available for Exam Event. Please synchronize event data first...";
                } else {
                	OESSyncConstants.syncMsg+="\n Exam Event version verified successfully.";
                }

            } 
            catch (IllegalStateException e) 
            {
                LOGGER.error("Error in checking Exam Event version: " + e);
                OESSyncConstants.syncMsg+="\n Error in checking Exam Event version!";
            } 
            catch (IOException e) 
            {
                LOGGER.error("Error in checking Exam Event version: " + e);
                OESSyncConstants.syncMsg+="\n Error in checking Exam Event version!";

            } 
            catch (Exception e) {
                LOGGER.error("Error in checking Exam Event version: " + e);
                OESSyncConstants.syncMsg+="\n Error in checking Exam Event version!";

            }
        return versionStatus;

    }

	/**
	 * Method to parse Exam Event Version Check Data
	 * @param testJsonText
	 * @return int this returns the exam event version status
	 * @throws Exception
	 */
	public int parseEventVersionCheckData(String testJsonText) throws Exception {

	    ObjectMapper mapper = new ObjectMapper();
	    int  versStatus= 0;
	    VersionStatus versionStatus=null;
	    ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
	    Object returnObject = JSonObjectHelper.getReturnObject(testJsonText);
	    try {
	
	        byte[] tempJson = ow.writeValueAsBytes(returnObject);
	
	        JavaType javaType = mapper.getTypeFactory().constructType(VersionStatus.class);
	        versionStatus = mapper.readValue(tempJson, javaType);
	        if(versionStatus!=null)
	        {
	            versStatus=versionStatus.getVersionStatus();
	        }
	    }
	    catch (Exception e) {
	        LOGGER.error("Error in Exam event version check: " + e);
	        OESSyncConstants.syncMsg+="\n Error in Exam event version check!";
	    }
	    return versStatus;
	}
	
	/**
	 * Method to parse Candidate List
	 * @param jsonText
	 * @return BaseOESSingleCandidateViewModel this returns the BaseOESSingleCandidateViewModel
	 * @throws Exception
	 */
	public BaseOESSingleCandidateViewModel parseCandidateList(String jsonText) throws Exception {
	    BaseOESSingleCandidateViewModel baseOESSingleCandidateViewModel = new BaseOESSingleCandidateViewModel();
	
	    ObjectMapper mapper = new ObjectMapper();
	    ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
	    Object returnObject = JSonObjectHelper.getReturnObject(jsonText);
	    try {
	        byte[] tempJson = ow.writeValueAsBytes(returnObject);
	        JavaType javaType = mapper.getTypeFactory().constructType(BaseOESSingleCandidateViewModel.class);
	        
	        OESSyncConstants.progressBarPercentage = 55;
			OESSyncConstants.downloadEventDataStatus = OESSyncConstants.currentTask+OESSyncConstants.progressBarPercentage+"%";
			OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus+OESSyncConstants.eventVersionCheckStatus+OESSyncConstants.downloadEventDataStatus;
	        
	        
	        baseOESSingleCandidateViewModel = mapper.readValue(tempJson, javaType);
	
	    } catch (Exception e) {
	        LOGGER.error("Exception Occured Candidate Synchronizer: " + e);
	        OESSyncConstants.syncMsg+="\n Error in downloading data!";
	    }
    

    return baseOESSingleCandidateViewModel;
}
   
}
