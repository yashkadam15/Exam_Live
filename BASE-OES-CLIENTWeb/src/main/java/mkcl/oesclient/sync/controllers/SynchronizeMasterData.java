/**
 * @ConsoleSynchronizeMasterData synchronize Master Data via console
 * @author reenak
 * @createdOn 11 Aug 2014
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
import java.util.Iterator;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.joda.time.DateTimeZone;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.ObjectWriter;

import mkcl.oesclient.commons.utilities.AppInfoHelper;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.sync.model.BaseOESMastersViewModel;
import mkcl.oesclient.sync.model.OESSyncConstants;
import mkcl.oesclient.sync.services.OESMastersService;
import mkcl.os.apps.MKCLHttpClient;
import mkcl.os.security.AESHelper;

public class SynchronizeMasterData{
    private static final Logger LOGGER = LoggerFactory.getLogger(SynchronizeMasterData.class);    
    public static DateTimeFormatter dateHeaderFormat = DateTimeFormat.forPattern("EEE, dd MMM yyyy HH:mm:ss z").withZone(DateTimeZone.UTC).withLocale(Locale.ENGLISH);
	
    /**
     * Method to fetch Master Data
     * @param request
     * @return String this returns the data as JSON text
     */
    private String getMasterData(HttpServletRequest request) {
        String jsonText = "";
        try {
        	String appName = AppInfoHelper.appInfo.getAppName();
            String url = MKCLUtility.loadConnectionPropertiesFile().getProperty("ESBURL")+"/transformer/executeTransformerJsonSecure/BaseOESMasters";
            String transformerId = "DB1-DB277777777777770002";                                        

           Long examVenueID = AppInfoHelper.appInfo.getExamVenueId();
           String venueCode = AppInfoHelper.appInfo.getExamVenueCode();
                        // Generating post request for HTTP Client
            HttpPost postRequest = new HttpPost(url);

            // Adding necessary parameters to request required for execution of
            // transformer
            Map<String, String> requestParameters = new HashMap<String, String>();

            requestParameters.put("transformerId", transformerId);
            requestParameters.put("appId", "abc");
            requestParameters.put("venueID",examVenueID.toString());
             
            // added to get Venue details for master data download
            requestParameters.put("venuecode", venueCode);
            Format formatter = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
            String dt = formatter.format(new Date());
            requestParameters.put("activitytime", dt);
            requestParameters.put("appname", appName);

            postRequest = MKCLHttpClient.addParametersToPost(postRequest,
                    requestParameters);

           /* OESSyncConstants.syncMsg+="\n Downloading Master data from server <lable id='downloadmasterData'>0%</label>";*/
            OESSyncConstants.progressBarPercentage = 15;
			 OESSyncConstants.downloadMasterDataStatus = OESSyncConstants.currentTask + OESSyncConstants.progressBarPercentage+"%";
			 OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus+OESSyncConstants.downloadMasterDataStatus;
            // Sending request to ESB and fetching the response
            
            HttpResponse response = MKCLHttpClient.sendRequest(postRequest);
           // Reading the JSON response
            HttpEntity httpEntity = response.getEntity();
            InputStream inputStream = httpEntity.getContent();
            BufferedReader reader = new BufferedReader(new InputStreamReader(
                    inputStream));
            StringBuilder sb = new StringBuilder();
            String line = null;
            while ((line = reader.readLine()) != null) {
                sb.append(line + "\n");
            }
            inputStream.close();
            jsonText = sb.toString();


            if (jsonText.length() > 2) {
                jsonText = AESHelper.decryptAsdecompress(jsonText,
                        "MKCLSecurity$#@!");
                //System.out.println(jsonText);
            }

            //OESMastersViewModel oesMastersViewModel = parseMasters(jsonText);
        } catch (IllegalStateException e) {
            LOGGER.error("Exception Occured Console Master Synchronizer: " + e);

            OESSyncConstants.syncMsg+="\n Error in downloading Master data from server!";
           

        } catch (IOException e) {
            LOGGER.error("Exception Occured Console Master Synchronizer: " + e);

            OESSyncConstants.syncMsg+="\n Error in downloading Master data from server!";            
        } catch (Exception e) {
            LOGGER.error("Exception Occured Console Master Synchronizer: " + e);

            OESSyncConstants.syncMsg+= "\n Error in downloading Master data from server!";           

        }
        return jsonText;
    }

    /**
     * Method to fetch Masters 
     * @param jsonText
     * @return BaseOESMastersViewModel this returns the BaseOESMastersViewModel
     */
    public BaseOESMastersViewModel parseMasters(String jsonText) {


        ObjectMapper mapper = new ObjectMapper();
        ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();

        Object returnObject = getReturnObject(jsonText);
        BaseOESMastersViewModel oesMastersViewModel = null;

        try {

            byte[] tempJson = ow.writeValueAsBytes(returnObject);
            JavaType javaType = mapper.getTypeFactory().constructType(BaseOESMastersViewModel.class);
            oesMastersViewModel = mapper.readValue(tempJson, javaType);
            /*if(oesMastersViewModel!=null)
            	OESSyncConstants.syncMsg+="\n Master Data downloaded successfully.";    */     


        } catch (Exception e) {
               LOGGER.error("Exception Occured Console Master Data Synchronizer- parseMasters(): " + e); 
               OESSyncConstants.syncMsg+="\n Error in downloading Master data (Parsing)!";
            
        }


        return oesMastersViewModel;
    }

    // Method to extract return object from json
    /**
     * Method to fetch the Return Object from JSON
     * @param jsonText
     * @return Object this returns the return object from JSON
     */
    public static Object getReturnObject(String jsonText) {
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
             LOGGER.error("Exception Occured Console Master Data Synchronizer- getReturnObject(): " + e);
            e.printStackTrace();
        }
        return returObject;
    }

//    private int checkConnectionToESB(String sESBurl) throws IOException {
//        HttpURLConnection urlc = (HttpURLConnection) new URL(sESBurl).openConnection();
//        Map headerfields = urlc.getHeaderFields();
//        int iConnectStatus = headerfields.size();
//        return iConnectStatus;
//    }

    /**
     * Method to Synchronize Master Data
     * @param request
     * @return boolean this returns true on success
     */
    public boolean synchronizeMasterData(HttpServletRequest request)
    {
        String jsonText = "";
        boolean isMasterDataSynced=false;
        try {
        	/*OESSyncConstants.syncMsg+="\n----------------------------------------------------------------------------------------";
        	OESSyncConstants.syncMsg+="\n      Master Data synchronization ";
        	OESSyncConstants.syncMsg+="\n----------------------------------------------------------------------------------------";*/
            boolean isSaved = false;
            jsonText = getMasterData(request);
                if (jsonText.length() > 2) {
                	 OESSyncConstants.progressBarPercentage = 55;
        			 OESSyncConstants.downloadMasterDataStatus = OESSyncConstants.currentTask + OESSyncConstants.progressBarPercentage+"%";
        			 OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus+OESSyncConstants.downloadMasterDataStatus;
                   
        			 BaseOESMastersViewModel oesMastersViewModel = parseMasters(jsonText);
                    
        			 OESSyncConstants.progressBarPercentage = 100;
        			 OESSyncConstants.downloadMasterDataStatus = OESSyncConstants.currentTask + OESSyncConstants.progressBarPercentage+"% <i class=\"icon-ok\"></i>";
        			 OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus+OESSyncConstants.downloadMasterDataStatus;
       			 
                  
                    OESSyncConstants.currentTask="<br>3/3 Processing downloaded Master data ";
                    OESSyncConstants.progressBarPercentage = 0;
       			 	OESSyncConstants.processingMasterDataStatus = OESSyncConstants.currentTask + OESSyncConstants.progressBarPercentage+"%";
       			 	OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus+OESSyncConstants.downloadMasterDataStatus+OESSyncConstants.processingMasterDataStatus;
                    jsonText=null;
                    if (oesMastersViewModel != null) {                     
                    	isSaved = new OESMastersService().saveOrUpdateMaster(oesMastersViewModel);
                        if (isSaved) {   
                        	 OESSyncConstants.progressBarPercentage = 100;
                   			 OESSyncConstants.processingMasterDataStatus = OESSyncConstants.currentTask + OESSyncConstants.progressBarPercentage+"% <i class=\"icon-ok\"></i>";
                   			 OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus+OESSyncConstants.downloadMasterDataStatus+OESSyncConstants.processingMasterDataStatus;
                                
                            isMasterDataSynced=true;
                            /*OESSyncConstants.syncMsg+="\n Master(s) Synchronized successfully.";                            */
                        } else { 
                            isMasterDataSynced=false;
                            OESSyncConstants.syncMsg+="\n \nError in processing downloaded Master data!";
                            
                        }
                    } else {
                        isMasterDataSynced=false;
                        OESSyncConstants.syncMsg+="\n \nError in downloading Master data (Processing)!";
                        
                    }


                } else { 
                    isMasterDataSynced=false;
                    OESSyncConstants.syncMsg+="\n No data found for Master download!";                    

                }

//            } else {
//                isMasterDataSynced=false;
//                System.out.println("Error in establishing connection!");                
//            }

    }
        catch(Exception e)
        {
            isMasterDataSynced=false;
           LOGGER.error("Exception Occured Console Master Data Synchronizer: " + e); 
        }
        return isMasterDataSynced;
    }


}
