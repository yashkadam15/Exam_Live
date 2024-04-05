/**
 * @ConsoleSynchronizeCandidateData synchronize Candidates
 * @author reenak
 * @createdOn 11 Aug 2014
 */

package mkcl.oesclient.sync.controllers;

import java.io.BufferedReader;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.URL;
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
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.ObjectWriter;

import mkcl.oesclient.commons.utilities.AppInfoHelper;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.model.Candidate;
import mkcl.oesclient.sync.model.BaseOESCandidateViewModel;
import mkcl.oesclient.sync.model.OESSyncConstants;
import mkcl.oesclient.sync.model.VersionStatus;
import mkcl.oesclient.sync.services.OESCandidateService;
import mkcl.os.apps.MKCLHttpClient;
import mkcl.os.security.AESHelper;


public class SynchronizeCandidateData {
    private long examEventID = 0, examVenueID = 0;
    private String venueCode=null;
    private static final Logger LOGGER = LoggerFactory.getLogger(SynchronizeCandidateData.class);
     
   /**
    * Method to get Candidate Details
    * @param eventId
    * @param venueId
    * @param venueCode
    * @param requestCouter
    * @param request
    * @return String this returns the candidate details as a JSON text
    */
    private String getCandidateDetails(long eventId, long venueId,String venueCode,int requestCouter,HttpServletRequest request) {

        String jsonText = "";
        // for Live
        String url = MKCLUtility.loadConnectionPropertiesFile().getProperty("ESBURL") + "/transformer/executeTransformerJsonSecure/BaseOESCandidate";       
        String transformerId = "DB1-DB277777777777770003";

        try {
        	//String appName = new File(sc.getRealPath("/")).getName();
        	String appName = AppInfoHelper.appInfo.getAppName();
            // Generating post request for HghghTTP Client
            HttpPost postRequest = new HttpPost(url);

            // Adding necessary parameters to request required for execution of
            // transformer
            Map<String, String> requestParameters = new HashMap<String, String>();
            requestParameters.put("transformerId", transformerId);
            requestParameters.put("appId", "abc");
           
            //requestParameters.put("venueID", "217");
            //requestParameters.put("eventID", "1");
            requestParameters.put("eventID", String.valueOf(eventId));
            requestParameters.put("venueID", String.valueOf(venueId));
            
            requestParameters.put("venuecode", venueCode);
            Format formatter = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
            String dt = formatter.format(new Date());
            requestParameters.put("activitytime", dt);
            requestParameters.put("appname", appName);
            requestParameters.put("requestCounter", String.valueOf(requestCouter));
            postRequest = MKCLHttpClient.addParametersToPost(postRequest, requestParameters);

            //System.out.println("Downloading Candidate data from server...");          


            // Sending request to ESB and fetching the response
            HttpResponse response = MKCLHttpClient.sendRequest(postRequest);

            //System.out.println(response.getStatusLine());

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
            jsonText = sb.toString();
            //System.out.println("------------------------------------------------");
            //System.out.println("JSON Response");
            //System.out.println("------------------------------------------------");
            //System.out.println(jsonText);

            if (jsonText.length() > 2) {

                jsonText = AESHelper.decryptAsdecompress(jsonText, "MKCLSecurity$#@!");
                //System.out.println(jsonText);
            }
        } catch (IllegalStateException e) {
            LOGGER.error("Exception Occured Console Candidate Synchronizer: " + e);

            OESSyncConstants.syncMsg+="\n \nError in downloading Candidate data!";           

        } catch (IOException e) {
            LOGGER.error("Exception Occured Console Candidate Synchronizer: " + e);

            OESSyncConstants.syncMsg+="\n \nError in downloading Candidate data!";
            
        } catch (Exception e) {
            LOGGER.error("Exception Occured Console Candidate Synchronizer: " + e);

            OESSyncConstants.syncMsg+="\n \nError in downloading candidate data!";
           
        }
        return jsonText;
    }

    /**
     * Method to check the Exam Event Version for Transformer Request
     * @param requestMap
     * @return Integer this returns the exam event version status
     * @throws Exception
     */
    public Integer eventVersionCheckTransformerRequest(Map<String, String> requestMap) throws Exception {
        
        String url = MKCLUtility.loadConnectionPropertiesFile().getProperty("ESBURL") + "/transformer/executeTransformerJsonSecure/BaseOESEventVersion";       
        String transformerId = "DB1-DB277777777777770004";
        int versionStatus = 0;
        // Generating post request for HTTP Client
        try {

        	OESSyncConstants.syncMsg+="\n Checking Exam Event version from server...";           
            HttpPost postRequest = new HttpPost(url);

            // Adding necessary parameters to request required for execution of
            // transformer

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

            // Sending request to ESB and fetching the response
            HttpResponse response = MKCLHttpClient.sendRequest(postRequest);
            //System.out.println(response.getStatusLine());

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
            //System.out.println("------------------------------------------------");
            //System.out.println("JSON Response");
            //System.out.println("------------------------------------------------");
            //System.out.println(jsonText);

            if (jsonText.length() > 2) {

                jsonText = AESHelper.decryptAsdecompress(jsonText, "MKCLSecurity$#@!");
                //System.out.println(jsonText);
            }

            versionStatus = parseEventVersionCheckData(jsonText);

            if (versionStatus==0) {
            	OESSyncConstants.syncMsg+="\n \nUpdate available for Exam Event. Please synchronize event data first!";
               
            } else {
            	OESSyncConstants.syncMsg+="\n Exam Event version verified successfully.";               
            }

        } catch (IllegalStateException e) {
            LOGGER.error("Error in checking Exam Event version: " + e);

            OESSyncConstants.syncMsg+="\n \nError in checking Exam Event version!";          

        } catch (IOException e) {
            LOGGER.error("Error in checking Exam Event version: " + e);

            OESSyncConstants.syncMsg+="\n \nError in checking Exam Event version!";
           
        } catch (Exception e) {
            LOGGER.error("Error in checking Exam Event version: " + e);

            OESSyncConstants.syncMsg+="\n \nError in checking Exam Event version!";
           
        }

        return versionStatus;

    }

    /**
     * Method to fetch the Exam Event Version Status
     * @param testJsonText
     * @return int this returns the exam event version status 
     */
    public int parseEventVersionCheckData(String testJsonText) {


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

        }//end try
        catch (Exception e) {
            LOGGER.error("Exception Occured Console Candidate Synchronizer- parseEventVersionCheckData : " + e);
        }
        return versStatus;
    }
   
    /**
     * Method to fetch the Candidate List
     * @param jsonText
     * @return BaseOESCandidateViewModel this returns the candidate list
     */
    public BaseOESCandidateViewModel parseCandidateList(String jsonText) {
        BaseOESCandidateViewModel oesCandidateViewModel = new BaseOESCandidateViewModel();

        ObjectMapper mapper = new ObjectMapper();
        ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
        Object returnObject = JSonObjectHelper.getReturnObject(jsonText);
        try 
        {
            if(returnObject!=null)
            {
                byte[] tempJson = ow.writeValueAsBytes(returnObject);
                JavaType javaType = mapper.getTypeFactory().constructType(BaseOESCandidateViewModel.class);
                oesCandidateViewModel = mapper.readValue(tempJson, javaType);
            }
            

        } catch (Exception e) {
            LOGGER.error("Exception Occured Console Candidate Synchronizer: " + e);
            OESSyncConstants.syncMsg+="\n \nError in downloading Candidate data!";
        }

        //System.out.println("Candidate Data downloaded successfully.");
        

        return oesCandidateViewModel;
    }
   
    /**
     * Method to fetch Candidate Images from SOLAR
     * @param imgPath
     * @param request
     */
    public void getCandidateImagesfromSOLAR(String imgPath,HttpServletRequest request) {
        String imageName = "";
        try {

            //URL url = new URL(properties.getOesServerURL() + "/resources/WebFiles/UserImages/" + imgPath);
            URL url = new URL(imgPath);

            String filename = url.getFile();
            imageName = filename.substring(filename.lastIndexOf("/") + 1);

            InputStream is = url.openStream();
            String sClientPhysicalPath = request.getSession().getServletContext().getRealPath("/");
            OutputStream os = new FileOutputStream(sClientPhysicalPath + "/resources/WebFiles/UserImages/" + imageName);

            byte[] b = new byte[2048];
            int length;

            while ((length = is.read(b)) != -1) {
                os.write(b, 0, length);
            }
            is.close();
            os.close();

        } catch (IOException e) {
            LOGGER.error("Exception Occured while Candidate Image Synchronization via Console : " + e);
        } catch (Exception e) {
            LOGGER.error("Exception Occured while Candidate Image Synchronization via Console : " + e);
        }

    }
   
    /**
     * Method to Synchronize Candidate Data
     * @param exameventid
     * @param request
     * @return boolean this returns true on success
     * @throws Exception
     */
    public boolean synchronizeCandidateData(String exameventid,HttpServletRequest request) throws Exception
    {
    	/*OESSyncConstants.syncMsg+="\n\n----------------------------------------------------------------------------------------";
    	OESSyncConstants.syncMsg+="\n      Candidate Data Synchronization ";
    	OESSyncConstants.syncMsg+="\n----------------------------------------------------------------------------------------";
       */
    	/*OESSyncConstants.currentTask = "<br>6/6 Candidate Data Synchronization ";
  		OESSyncConstants.progressBarPercentage = 0;
  		OESSyncConstants.candidateDownloadStatus = OESSyncConstants.currentTask+OESSyncConstants.progressBarPercentage+"%";
  		OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus+OESSyncConstants.eventVersionCheckStatus+OESSyncConstants.downloadEventDataStatus+OESSyncConstants.processEventDataStatus+OESSyncConstants.verifyingDataIntegrityStatus+OESSyncConstants.candidateDownloadStatus;
  */
    	boolean isCandidateSynced=false;
        try
        {
             examEventID=Long.parseLong(exameventid);
             examVenueID = AppInfoHelper.appInfo.getExamVenueId();
             venueCode = AppInfoHelper.appInfo.getExamVenueCode();
        }
        catch(Exception e)
        {
            LOGGER.error("Exception Occured Candidate Synchronizer: -synchronizeCandidateDataViaConsole" + e);
        }
       
        String jsonText = "";

        if (examEventID > 0 && examVenueID > 0) {
            try {
                boolean isSaved = false;   
                int requestCouter=0;
                boolean needOfNextrequest=true;
                    
                    //ExamEvent examEvent = new OESEventService().getExamVersion(examEventID);
                    // Commentd for Console
                    //int isVersionChange = 0;
                    //String version = null;
//                    if (examEvent != null) {
//                        version = String.valueOf(examEvent.getExamEventversion());                        
//                        Map<String, String> reqMap = new HashMap<String, String>();
//                        reqMap.put("exameventVersion", version);                       
//                        reqMap.put("eventID", String.valueOf(examEventID));
//                        isVersionChange = eventVersionCheckTransformerRequest(reqMap);
//                    }

                   // if (isVersionChange !=0 ) {
               /* OESSyncConstants.syncMsg+="\n Downloading and processing of data...\n"; */
                
              /*  OESSyncConstants.progressBarPercentage = 5;
          		OESSyncConstants.candidateDownloadStatus = OESSyncConstants.currentTask+OESSyncConstants.progressBarPercentage+"%";
          		OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus+OESSyncConstants.eventVersionCheckStatus+OESSyncConstants.downloadEventDataStatus+OESSyncConstants.processEventDataStatus+OESSyncConstants.verifyingDataIntegrityStatus+OESSyncConstants.candidateDownloadStatus;
          		
                */
                
                int totalCandidateCountToDownload = getCandidateCountByEvent(examEventID, examVenueID);
                
               OESSyncConstants.candidateDownLoadSavingproportion = OESSyncConstants.CANDIDATE_DATA_DOWNLOAD_PER/Double.valueOf(totalCandidateCountToDownload);
                
                BaseOESCandidateViewModel candidateViewModel=null;
                while(needOfNextrequest)
                {
                	OESSyncConstants.syncMsg+="<b>. </b>";
                     ++requestCouter;
                        jsonText="";
                          
                        jsonText = getCandidateDetails(examEventID, examVenueID,venueCode,requestCouter,request);

                        if (jsonText.length() > 2) 
                        {
                            candidateViewModel=null;
                             candidateViewModel= parseCandidateList(jsonText);
                             jsonText=null;
                            if (candidateViewModel != null && candidateViewModel.getCandidateList()!=null) 
                            {
                                needOfNextrequest=candidateViewModel.getIsNeedOfNextRequest();
                                
                                for(Candidate candidate : candidateViewModel.getCandidateList()) 
                                {
                                    if(candidate.getCandidatePhoto() != null && !candidate.getCandidatePhoto().isEmpty()) 
                                    {
                                        getCandidateImagesfromSOLAR(candidate.getCandidatePhoto(),request);
                                    }
                                }
                                isSaved = new OESCandidateService().saveOrUpdateCandidateDetails(candidateViewModel,examEventID);
                                
                                

                                if (isSaved && !needOfNextrequest) 
                                {
                                    isCandidateSynced=true;
                                   /* OESSyncConstants.syncMsg+=" ";
                                    OESSyncConstants.syncMsg+="\n Candidate(s) Synchronized successfully.";  */
                                    
                                    setCandidateProgress(candidateViewModel.getCandidateList().size());
                                } 
                                else if(isSaved) 
                                {
                                    isCandidateSynced=true;
                                    setCandidateProgress(candidateViewModel.getCandidateList().size());

                                } 
                                else 
                                {
                                    needOfNextrequest=false;
                                    isCandidateSynced=false;
                                    OESSyncConstants.syncMsg+="\n Error in processing downloaded data!";                                    
                                }
                            } 
                            else 
                            {
                                needOfNextrequest=false;
                                isCandidateSynced=true;
                                OESSyncConstants.syncMsg+="\n No Candidate data found for download!";                               
                            }
                        }
                        else 
                        {
                            needOfNextrequest=false;
                            isCandidateSynced=true;
                            OESSyncConstants.syncMsg+="\n No Candidate data found for download!";                           
                        }
                }
                    //} 
                
            } catch (Exception e) {
                LOGGER.error("Exception Occured Candidate Synchronizer: " , e);
            }
        }
          
           
        return isCandidateSynced;
    }
    
    /**
     * Method to fetch the Candidate Count by Exam Event
     * @param examEventID
     * @param examVenueID
     * @return int this returns the candidate count
     * @throws Exception
     */
    public int getCandidateCountByEvent(long examEventID,long examVenueID) throws Exception
    {
        final String uri = MKCLUtility.loadConnectionPropertiesFile().getProperty("OESSERVERURL") + "/OESApi/getCandidateCount?examEventID="+examEventID+"&examVenueID="+examVenueID;
        RestTemplate restTemplate = new RestTemplate();
        String result = restTemplate.getForObject(uri, String.class);
       return Integer.valueOf(result);
    }
    
    /**
     * Method to set the Candidate Progress
     * @param candCount
     */
    private void setCandidateProgress(int candCount) {
    	  // set progress percentage
    	
		OESSyncConstants.progressBarPercentage = OESSyncConstants.progressBarPercentage+ (int) (OESSyncConstants.candidateDownLoadSavingproportion* candCount);
		OESSyncConstants.candidateDownloadStatus = OESSyncConstants.currentTask+ OESSyncConstants.progressBarPercentage + "% <i class=\"icon-ok\"></i>";
		OESSyncConstants.syncMsg = OESSyncConstants.esbConnectionStatus
				+ OESSyncConstants.eventVersionCheckStatus
				+ OESSyncConstants.downloadEventDataStatus
				+ OESSyncConstants.processEventDataStatus
				+ OESSyncConstants.verifyingDataIntegrityStatus
				+ OESSyncConstants.candidateDownloadStatus;		
    }
}
