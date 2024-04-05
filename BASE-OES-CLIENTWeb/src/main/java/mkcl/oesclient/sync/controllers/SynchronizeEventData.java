/**
 * @ConsoleSynchronizeEventData synchronize Exam Event Data
 * @author reenak
 * @createdOn 11 Aug 2014
 */

package mkcl.oesclient.sync.controllers;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.Format;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

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
import mkcl.oesclient.model.EventSyncType;
import mkcl.oesclient.sync.model.OESExamEventViewModel;
import mkcl.oesclient.sync.model.OESSyncConstants;
import mkcl.oesclient.sync.model.VersionStatus;
import mkcl.oesclient.sync.services.ItemRepositoryServices;
import mkcl.oesclient.sync.services.OESEventService;
import mkcl.oespcs.model.ExamEvent;
import mkcl.os.apps.MKCLHttpClient;
import mkcl.os.security.AESHelper;


public class SynchronizeEventData  {
     /**
     * Global variables declaration and initialization
     */    
    private long examEventID = 0;
    private long serverEventVersion = 0;
    private long serverItemRepositoryVersion = 0;
    private long clientEventVersion = 0;
    private long clientItemRepositoryVersion = 0;
    private boolean isFullZipFileDownloaded = false;
    private boolean dataavailable = false;
    private int zipCallCount = 0;
    private boolean isExamEventDatadownloaded = false;
    private List<String> listzipFileNames = new ArrayList<String>();
    // Logger
    private static final Logger LOGGER = LoggerFactory.getLogger(SynchronizeEventData.class);

    // Esb Url
    //private String sESBurl = properties.getEsbURL();
    // Client Application physical Path
    private final String sClientPhysicalPath ;
    // Zipped Images  zipParentfolder path from Client Application
    private final String sZippedImagesPath;
    // Images zipParentfolder path from Client Application
    private final String sExtractImagesPath ;
    // Oes Exam Event Service Object
    
    private final String appName;
    OESEventService oESEventServiceObj = new OESEventService();
    ItemRepositoryServices itemRepositoryServicesObj = new ItemRepositoryServices();
    

	/**
     * Constructor Call: Creates new form SynchronizeEventData
     */
    public SynchronizeEventData() {        
    	sClientPhysicalPath="";
    	sZippedImagesPath = "";
    	sExtractImagesPath = "";
    	appName="";
    	
    }
  
    /**
     * Method to Synchronize Exam Event Data
     * @param request
     */
    public SynchronizeEventData(HttpServletRequest request) 
    {        
    	sClientPhysicalPath=request.getSession().getServletContext().getRealPath("/");
    	sZippedImagesPath = sClientPhysicalPath + "/resources/WebFiles/zippedimages/";
    	sExtractImagesPath = sClientPhysicalPath + "/resources/WebFiles/images/";
    	appName = AppInfoHelper.appInfo.getAppName();
    }

//===================== GET EVENT DATA FROM ESB AND SAVE TO CLIENT DATABASE MODE WISE ==============================================
    /**
     * Method for Exam Event Transformer Request 
     * This method is used to fetch Event data from OES-SERVER via ESB transformer in json format.
     * @param Map<String, String> requestParameters
     * @return OESExamEventViewModel this returns the OESExamEventViewModel
     * @throws Exception
     */
    private OESExamEventViewModel eventTransformerRequest(Map<String, String> requestParameters) throws Exception {

        try {
			String url = MKCLUtility.loadConnectionPropertiesFile().getProperty("ESBURL")+ "/transformer/executeTransformerJsonSecure/BaseOESCachedEvent";
			String transformerId = "DB1-DB277777777777770005";
			// Generating post request for HTTP Client
			HttpPost postRequest = new HttpPost(url);
			// Adding necessary parameters( Mode wise) to request required for execution of transformer
			Map<String, String> requestParams = new HashMap<String, String>();
			requestParams.put("transformerId", transformerId);
			requestParams.put("appId", "abc");
			requestParams.put("eventID", requestParameters.get("eventID").toString());
			// added to get request ststus of Venue for Event Data synchronization.
			setVenueRequestStatusforDataDowload(requestParams);
			OESExamEventViewModel ve = null;
			OESExamEventViewModel vePaperData = GetPartialEventData(postRequest, requestParams, EventSyncType.PaperData);
			OESExamEventViewModel veItemData = null;
			OESExamEventViewModel veEventData = null;
			if (vePaperData != null) {
				veItemData = GetPartialEventData(postRequest, requestParams,EventSyncType.ItemData);
				OESSyncConstants.progressBarPercentage = OESSyncConstants.EVENT_DATA_PARTIAL_DOWNLOAD_PER/2;
				OESSyncConstants.downloadEventDataStatus = OESSyncConstants.currentTask+OESSyncConstants.progressBarPercentage+"%";
				OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus+OESSyncConstants.eventVersionCheckStatus+OESSyncConstants.downloadEventDataStatus;
				
			}
			if (vePaperData != null && veItemData != null) {
				veEventData = GetPartialEventData(postRequest, requestParams,
						EventSyncType.EventData);
				
			}
			if (vePaperData != null && veItemData != null
					&& veEventData != null) {
				ve = new OESExamEventViewModel();
				ve = fillDataToObjects(vePaperData, ve);
				ve = fillDataToObjects(veItemData, ve);
				ve = fillDataToObjects(veEventData, ve);
			}
			return ve;
		} catch (Exception e) {
			throw e;
		}
    }

    /**
     * Method for Exam Event Version Check Transformer Request
     * This method is used to fetch Exam Event Version from OES-SERVER via ESB Transformer in JSON format.
     * @param requestParameters 
     * @return int this returns the exam event version status in terms of: 
     * 0-Mismatch(Change in Version,Auto Download), 
     * 1-Match(No Change,Ask User To Download), 
     * 2-Mismatch,but Event Not Active and Published(No Download)
     * @throws Exception
     */
    private int eventVersionCheckTransformerRequest(Map<String, String> requestParameters) throws Exception {

        String url = MKCLUtility.loadConnectionPropertiesFile().getProperty("ESBURL") + "/transformer/executeTransformerJsonSecure/BaseOESEventVersion";
        String transformerId = "DB1-DB277777777777770004";
        int eventversionChange = -1;

        // Generating post request for HTTP Client
        HttpPost postRequest = new HttpPost(url);

        // Adding necessary parameters to request required for execution of transformer
        Map<String, String> requestParams = new HashMap<String, String>();
        requestParams.put("transformerId", transformerId);
        requestParams.put("appId", "abc");

        if (requestParameters.get("exameventVersion") == null) {
            requestParams.put("exameventVersion", requestParameters.get("exameventVersion"));
        } else {
            requestParams.put("exameventVersion", requestParameters.get("exameventVersion").toString());
        }
        requestParams.put("eventID", requestParameters.get("eventID").toString());
        postRequest = MKCLHttpClient.addParametersToPost(postRequest,
                requestParams);

        // Sending request to ESB and fetching the response
        HttpResponse response = MKCLHttpClient.sendRequest(postRequest);
        OESSyncConstants.progressBarPercentage = 65;
		OESSyncConstants.eventVersionCheckStatus = OESSyncConstants.currentTask+OESSyncConstants.progressBarPercentage+"%";
		OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus+OESSyncConstants.eventVersionCheckStatus;
		
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
//        System.out.println("------------------------------------------------");
//        System.out.println("JSON Response");
//        System.out.println("------------------------------------------------");
        //System.out.println(jsonText);
        if (jsonText.length() > 2) {

            jsonText = AESHelper.decryptAsdecompress(jsonText, "MKCLSecurity$#@!");
            //System.out.println(jsonText);
        }
        eventversionChange = parseEventVersionCheckData(jsonText);
        jsonText = null;
        sb = null;
        inputStream = null;
        postRequest = null;
        response = null;
        reader = null;
        return eventversionChange;

    }

    /**
     * Method to fetch the Exam Event Data
     * This method is used to parse Exam Event Data in JSON format from ESB into the respective objects.
     * @param JsonText- text returned from ESB Transformer
     * @return OESExamEventViewModel this returns the OESExamEventViewModel
     */
    private OESExamEventViewModel parseExamEventData(String testJsonText) throws Exception{

        ObjectMapper mapper = new ObjectMapper();
        OESExamEventViewModel viewModelExamEvent = new OESExamEventViewModel();
        ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
        Object returnObject = JSonObjectHelper.getReturnObject(testJsonText);
        try {
            byte[] tempJson = ow.writeValueAsBytes(returnObject);
            JavaType javaType = mapper.getTypeFactory().constructType(OESExamEventViewModel.class);
            viewModelExamEvent = mapper.readValue(tempJson, javaType);

        }//end try
        catch (Exception e) {
            LOGGER.error("Exception Occured in ConsoleSynchronizeEventData - parseEventData(String testJsonText) : " + e);
            throw e;
        }
        return viewModelExamEvent;
    }

    /**
     * Method to fetch the Exam Event Version Check JSON Data
     * This method is used to parse Exam Event Version Check JSON data into respective objects
     * @param testJsonText 
     * @return int this returns the event version status as 0/1/2
     */
    private int parseEventVersionCheckData(String testJsonText) {

        ObjectMapper mapper = new ObjectMapper();
        int eventVersionChange = -1;
        VersionStatus versionStatus = null;
        ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
        Object returnObject = JSonObjectHelper.getReturnObject(testJsonText);
        try {
            byte[] tempJson = ow.writeValueAsBytes(returnObject);
            JavaType javaType = mapper.getTypeFactory().constructType(VersionStatus.class);
            versionStatus = mapper.readValue(tempJson, javaType);
            if (versionStatus != null) {
                eventVersionChange = versionStatus.getVersionStatus();
                serverEventVersion = versionStatus.getEventVersion();
                serverItemRepositoryVersion = versionStatus.getItemRepositoryVesrion();
            }
        }//end try
        catch (Exception e) {
            LOGGER.error("Exception Occured in ConsoleSynchronizeEventData - parseEventVersionCheckData(String testJsonText) : " + e);
        }
        return eventVersionChange;
    }
   
    /**
     * Method to Check Exam Event Version
     * This method is used to Get Exam Event Version Status from Server
     * @param eventID
     * @return int this returns the exam event version status in terms of:
     * 0-Mismatch(Change in Version,Auto Download), 
     * 1-Match(No Change,Ask User To Download),
     * 2-Mismatch,but Event Not Active and Published(No Download)
     * @throws Exception
     */
    public int checkExamEventVersion(long eventID) {
        ExamEvent event = new ExamEvent();
        Map<String, String> requestEventVersionParameters = new HashMap<String, String>();
        int checkEventVersion = -1;

        try {
            event = new OESEventService().getExamVersion(eventID);
            String exameventID = String.valueOf(event.getExamEventID());
            clientEventVersion = event.getExamEventversion();
            clientItemRepositoryVersion = event.getItemRepositoryVersion();
            requestEventVersionParameters.put("eventID", exameventID);
            requestEventVersionParameters.put("exameventVersion", String.valueOf(clientEventVersion));

            //Display message before and during Checking event version
           // OESSyncConstants.syncMsg+="\n Checking Exam Event version from server...";            
           
            OESSyncConstants.progressBarPercentage = 25;
    		OESSyncConstants.eventVersionCheckStatus = OESSyncConstants.currentTask+OESSyncConstants.progressBarPercentage+"%";
    		OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus+OESSyncConstants.eventVersionCheckStatus;
            //Call to transformer to check event version
            checkEventVersion = eventVersionCheckTransformerRequest(requestEventVersionParameters);
            if (checkEventVersion == -1) {
                dataavailable = false;
            } else {
                dataavailable = true;
            }
        } catch (Exception e) {

            LOGGER.error("Exception Occured in ConsoleSynchronizeEventData- checkExamEventVersion(long eventID): " + e);
            dataavailable = false;
            //return savesuccess;
        }
        return checkEventVersion;

    }

    /**
     * Method to Download the Exam Event Data
     * This method is used to Download Exam Event Data (Cached Data) from Server to Client through ESB 
     * and inserts paper and item data to TEMP work tables
     * @param OESExamEventViewModel object
     * @return boolean this returns true if data gets download successfully and inserted in work tables.
     * @throws Exception
     */
    private boolean downloadExamEventDataAndInsertIntoWorkTables(OESExamEventViewModel viewModelExamEvent) {
      isExamEventDatadownloaded = false;
        try {
            if (viewModelExamEvent != null && viewModelExamEvent.getExamEvent() != null) {
                //DELETE WORK TABLES DATA FIRST TO INSERT NEW DATA
                if (itemRepositoryServicesObj.deleteWorkTablesData()) {
                    if (viewModelExamEvent.getPaperList().size() > 0) {
                        // INSERT PAPER DATA INTO PAPER RELATED WORK TABLES
                        if (oESEventServiceObj.insertPaperDataIntoWorkTables(viewModelExamEvent)) {
                            // INSERT ITEM DATA TO ITEM RELATED WORK TABLES ITEM TYPE WISE
                            if (viewModelExamEvent.getItemBankItemAssociationList().size() > 0) {
                                isExamEventDatadownloaded=itemRepositoryServicesObj.insertItemRepositoryDataIntoWorkTable(viewModelExamEvent);
                                //set true if data get successfully inserted to work tables
                                dataavailable = true;
                            }// end of if(itembankitemAssociationList)
                        }//end of if save paper data to work tables
                    }// end of if paperlist>0
                } //end of   if (deleteWorkTablesData=true)
            } // end of if exam Event not null
        } catch (Exception e) {

            LOGGER.error("Exception Occured in ConsoleSynchronizeEventData- downloadEventdata(String exameventID): " + e);
            isExamEventDatadownloaded = false;
        }
        return isExamEventDatadownloaded;

    }

    /**
     * Method to Save Exam Event Data
     * This method is used to save the data download to database of client. 
     * Paper and Item data is stored in their actual tables by inner join with work tables 
     * and event and other associations get stored in database directly from OESExamEventViewModel Object.
     * @param OESExamEventViewModel object
     * @return boolean this returns true if data gets successfully saved in the database.
     * @throws Exception
     */
    private boolean saveExamEventData(OESExamEventViewModel viewModelExamEvent) {

        boolean isExamEventDataSaved = false;

        try {
            if (isExamEventDatadownloaded) {
               
                // SAVE ITEM REPOSITORY DATA TO CLIENT DB
                if(itemRepositoryServicesObj.saveItemRepositoryData(viewModelExamEvent))
                {
                // SAVE PAPER DATA TO CLIENT DB
                if (oESEventServiceObj.savePaperFullData()) {
                    // SAVE EXAM EVENT DATA IF ALL DEPENDENT DATA SAVED SUCCESSFULLY                                
                    isExamEventDataSaved = new OESEventService().saveEventFullData(viewModelExamEvent);                    

                }// END OF IF(SAVE PAPER)

            }//end of if(saveExamEventSuccess)
            }

            // set dataavailable=true if data saved successfully
            dataavailable = true;
        } catch (Exception e) {
            LOGGER.error("Exception Occured in ConsoleSynchronizeEventData- saveExamEventData(): " + e);
            isExamEventDataSaved = false;
        }
        return isExamEventDataSaved;

    }

    /**
     * Method to Verify Exam Event Data Integrity
     * This method is used to delete Item's all Data if Image involved in that Item not found
     * on Client Physical Path after Download
     * @param String itemIdsForSoftDelete
     * @return boolean this returns true if the data is verified successfully
     * @throws Exception
     */
    private boolean verifyExamEventDataIntegrity(String itemIdsForSoftDelete) {

        boolean isItemDataVerfied = false;
        try {
            String clientFilePath = sClientPhysicalPath + "/resources/WebFiles/images/";
            /*SOFT DELETE ITEMS: SET DELETED=1 FOR GIVEN ITEM IDS IN ITEMSFORSOFTDELETE LIST*/
            if (itemIdsForSoftDelete != null && !(itemIdsForSoftDelete.isEmpty())) {
                new ItemRepositoryServices().softDeleteItems(itemIdsForSoftDelete);
//                isItemDataVerfied = new ItemRepositoryServices().softDeleteItems(itemIdsForSoftDelete);
//                if (isItemDataVerfied) {
//                    isItemDataVerfied = false;
//                }
            }
            
            OESSyncConstants.progressBarPercentage = 50;
     		OESSyncConstants.verifyingDataIntegrityStatus = OESSyncConstants.currentTask+OESSyncConstants.progressBarPercentage+"%";
     		OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus+OESSyncConstants.eventVersionCheckStatus+OESSyncConstants.downloadEventDataStatus+OESSyncConstants.processEventDataStatus+OESSyncConstants.verifyingDataIntegrityStatus;
     		
            /*DELETE ITEMS WITH INCOMPLETE IAMGES AND FILES*/
            isItemDataVerfied = new ItemRepositoryServices().getIncompleteItemsAndDelete(examEventID, itemIdsForSoftDelete, clientFilePath);
            
        }//end of try block
        catch (Exception ex) {
            LOGGER.error("Exception Occured in ConsoleSynchronizeEventData-verifyAndDeleteIncompleteItems() : " + ex);
            isItemDataVerfied = false;
        }
        return isItemDataVerfied;

    }

    /**
     * Method to check if All Images Extracted from Zip Files 
     * This method is used to save images extracted from zip files on client physical path and delete
     * zip file after extraction is complete.
     * @return boolean this returns true if all images get saved on client physical path.
     */
    private boolean isAllImagesExtractedfromZipFiles() {

        boolean isImageExtracted = true;
        
        double imageExtractionproportion = 0;
        int counter=0;
        try {
        	imageExtractionproportion = OESSyncConstants.EVENT_IMAGE_EXTRACTION_PER/Double.valueOf(listzipFileNames.size());
        	for (String zipName : listzipFileNames) {

                isImageExtracted = false;
                boolean b = extractFilesFromZip(sZippedImagesPath + zipName, sExtractImagesPath);
                if (b) {
                    File zipFile = new File(sZippedImagesPath + zipName);
                    zipFile.delete();
                }
                isImageExtracted = true;
                OESSyncConstants.progressBarPercentage = (int) (imageExtractionproportion* ++counter);
     			 OESSyncConstants.processEventDataStatus = OESSyncConstants.currentTask+OESSyncConstants.progressBarPercentage+"%";
        		OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus+OESSyncConstants.eventVersionCheckStatus+OESSyncConstants.downloadEventDataStatus+OESSyncConstants.processEventDataStatus;
        		
            }
            listzipFileNames = null;
        } catch (Exception e) {
            LOGGER.error("Exception Occured in ConsoleSynchronizeEventData-getAllImages(String zipName) : " + e);
            isImageExtracted = false;
        }

        return isImageExtracted;
        //return false;
    }

    /**
     * Method to Extract Files From Zip
     * This method is used to extract images from zip File and store on client physical path.
     * @param zipName
     * @return boolean this returns true if all Images get fully extracted and stored on client
     */
    private boolean extractFilesFromZip(String zipFile, String outputFolder) {

        boolean isSuccess = true;
        ZipInputStream zis = null;
        FileOutputStream fos = null;
        byte[] buffer = new byte[1024];

        try {
            //create output directory is not exists
            File folder = new File(outputFolder);
            if (!folder.exists()) {
                folder.mkdir();
            }
            folder = null;
//--------------------Single Call to Extract Zip (import net.lingala.zip4j)--Take more time then existing one
//            ZipFile zf = new ZipFile(zipFile);//
//            zf.extractAll(outputFolder);
//-----------------------------------------------------------------------
            //get the zip file content
            zis = null;
            zis = new ZipInputStream(new FileInputStream(zipFile));

            //get the zipped file list entry

            ZipEntry ze = null;
            ze = zis.getNextEntry();

            File newFile = null;
            while (ze != null) {

                String fileName = ze.getName();
                newFile = new File(outputFolder + "/" + fileName);

                //create all non exists folders
                //else you will hit FileNotFoundException for compressed zipParentfolder

                // new File(newFile.getParent()).mkdirs();

                // Extract Images From Zip and write on Images Folder On Client
                fos = new FileOutputStream(newFile);

                int len;
                while ((len = zis.read(buffer)) > 0) {
                    fos.write(buffer, 0, len);
                }

                newFile = null;


                if (fos != null) {
                    try {
                        fos.flush();
                        fos.close();
                        fos = null;
                    } catch (IOException ex) {
                        LOGGER.error("Exception Occured in ConsoleSynchronizeEventData - extractFilesFromZip(String zipFile, String outputFolder) : " + ex);
                    }
                }
                ze = zis.getNextEntry();
            }

            zis.closeEntry();
            zis.close();

        } //-----used for import net.lingala.zip4j ZipFile exception handling-----
        //        catch (ZipException e) {
        //            LOGGER.error("Exception Occured in SynchronizeEventData - extractFilesFromZip(String zipFile, String outputFolder) : " + e);
        //            isZipDownloadSuccess = false;
        //   }
        //-----end of used for import net.lingala.zip4j ZipFile exception handling-----
        catch (IOException e) {
            LOGGER.error("Exception Occured in ConsoleSynchronizeEventData - extractFilesFromZip(String zipFile, String outputFolder) : " + e);
            isSuccess = false;
        } finally {

            if (zis != null) {
                try {
                    zis.closeEntry();
                    zis.close();
                    zis = null;
                } catch (IOException ex) {
                    LOGGER.error("Exception Occured in ConsoleSynchronizeEventData - extractFilesFromZip(String zipFile, String outputFolder) : " + ex);
                }
            }
        }
        return isSuccess;
    }

    /**
     * Method to get Images Zip Stream if Zip File Exists
     * This method is used to check whether Images Zip folders exists on Oes-Server of respective Event, 
     * this method checks for all zip folders and break the loop when file not found on server and try 2 
     * times for download if problem occurs during the proces On retry if file exists on client side, 
     * then respective file download will be resumed from where it is interrupted.
     * @param zipName
     * @return int this return the download status codes : 
     * 1- successful download 
     * 2- download resume with retry 
     * 3- file not found 
     * 4- zip file of full length already exists on client 
     * 0- other exceptions
     * @throws FileNotFoundException,IOException,Exception
     */
    private int getImagesZipStreamIfZipFileExists(String zipName) {

        URL url = null;
        BufferedInputStream bufferedIS = null;
        OutputStream fileOS = null;
        File zipParentfolder = null;
        File zipFileName = null;

        byte[] byteData = null;
        int available = -1;

        long zipFilebytes = 0;
        int returnCode = 0;
        long prevDownloadedBytes = 0;

        try {

            //Check ImagesZip From Server
            url = new URL(MKCLUtility.loadConnectionPropertiesFile().getProperty("OESSERVERURL") + "/resources/WebFiles/zippedimages/" + zipName);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            // return input stream if File found on server,else throws File Not found exception           

            // Check if Zip Parent Folder(zippedImages) Exists,else create it
            zipParentfolder = new File(sZippedImagesPath);
            if (!zipParentfolder.exists()) {
                zipParentfolder.mkdir();
            }

            // Check if requested ZipFile exists in zippedImages Folder
            zipFileName = new File(zipParentfolder.getAbsoluteFile() + "/" + zipName);
            if (zipFileName.exists()) {
                prevDownloadedBytes = zipFileName.length();
                //Resume Download: Set Accept Ranges to get content next to prevDownloadedBytes
                connection.setRequestProperty("Range", "bytes=" + zipFileName.length() + "-");
            }

            connection.connect();
            zipFilebytes = connection.getContentLength();

            // connection.getInputStream will throw File not found exception
            // which helps to identify end of counter for  Version wise Zip files
            // Also, return response code 416 in case when full zip get downloaded sucessfully
            // and we try to read next to file Range.
            try {
                bufferedIS = new BufferedInputStream(connection.getInputStream());
            } catch (FileNotFoundException fe) {
                LOGGER.error("INFO- Zip FileNotFound in SynchronizeEventData : " + fe);

                // isZipDownloadSuccess = true;
                returnCode = 3;
                return returnCode;
            } catch (IOException ioe) {
                //isZipDownloadSuccess = false;

                if (connection.getResponseCode() == 416) {
                    returnCode = 4;
                    //isZipDownloadSuccess = true;
                }
                LOGGER.error("INFO-Response Code 416 for Zip File : " + zipName);
                return returnCode;
            }
            fileOS = (prevDownloadedBytes == 0) ? new FileOutputStream(zipParentfolder.getAbsoluteFile() + "/" + zipName) : new FileOutputStream(zipFileName, true);
            byteData = new byte[2048];

            while ((available = bufferedIS.read(byteData)) != -1) {

                fileOS.write(byteData, 0, available);
                OESSyncConstants.downloadedBytes+=available;
                OESSyncConstants.progressBarPercentage = OESSyncConstants.EVENT_ZIP_DOWNLOAD_PER+(int) (OESSyncConstants.zipDownloadSavingProporion* OESSyncConstants.downloadedBytes);
     			OESSyncConstants.downloadEventDataStatus = OESSyncConstants.currentTask+OESSyncConstants.progressBarPercentage+"%";
     			OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus+OESSyncConstants.eventVersionCheckStatus+OESSyncConstants.downloadEventDataStatus;
              
                // prevDownloadedBytes += available;
            }

            bufferedIS.close();
            fileOS.close();
            connection = null;
            //Comapare Content Length of Both Zips(Came from Server and Created on Client)
            if ((prevDownloadedBytes + zipFilebytes) == new File(zipParentfolder.getAbsoluteFile() + File.separator + zipName).length()) {
                returnCode = 1;

            } else {
                returnCode = 2;
                if (zipCallCount < 2) {
                    zipCallCount++;
                    LOGGER.error("INFO- 2nd attempt for ZipFile : " + zipName);
                    returnCode = getImagesZipStreamIfZipFileExists(zipName);
                    // return false to stop futher event downloading of Event data
                }

            }
            //}
            // } // enf od if inputStream is not null
        } catch (FileNotFoundException fe) {
            LOGGER.error("Exception Occured in ConsoleSynchronizeEventData - getImagesZipStreamIfZipFileExists(String zipName): " + fe);

            returnCode = 0;
            bufferedIS = null;
        } catch (IOException ioe) {
            LOGGER.error("Exception Occured in ConsoleSynchronizeEventData - getImagesZipStreamIfZipFileExists(String zipName) : " + ioe);
            returnCode = 0;
            bufferedIS = null;
        } catch (Exception e) {
            LOGGER.error("Exception Occured in ConsoleSynchronizeEventData - getImagesZipStreamIfZipFileExists(String zipName) : " + e);
            returnCode = 0;
            bufferedIS = null;
        }

        return returnCode;
    }

    /**
     * Method for Zip Files Download from Server 
     * This method is used to download ImagesZip folders from OES-Server of respective Event and try 2 times 
     * to resume download if problem occurs during the process
     */
    public void zipFilesDownloadFromServer() {
        String sZipFileName = "";
        String sExamEvent = "";
        int zipDownloadedStatusCode = 0;        
        sExamEvent = String.valueOf(examEventID);
        int versionWiseZipCount = 1;
        long estimatedZIpLengthToDownload = 0;
        try {
        	
        	estimatedZIpLengthToDownload = getAllZipFileSizeDownloadFromServer();
        	OESSyncConstants.zipDownloadSavingProporion = OESSyncConstants.EVENT_ZIP_DOWNLOAD_PER/Double.valueOf(estimatedZIpLengthToDownload);
        	
            //incremental call to get all Zip files of Event of given event version
            if (clientEventVersion == 0) {
                clientEventVersion = 1;
            }
            isFullZipFileDownloaded = true;
            // Loop to Get Zip Files of All Versions which Client Missing
            for (long version = clientEventVersion; (version <= serverEventVersion && isFullZipFileDownloaded); version++) {

                versionWiseZipCount = 1;
                sZipFileName = sExamEvent + "_" + version + "_" + versionWiseZipCount + ".zip";
                // version wise multiple zip download
                do {
                    zipCallCount = 1;
                    try {
                        //check whether given zip of specified version exists on Oes-Server or not, and
                        // if Exists then write to zippedimages folder
                        
                        zipDownloadedStatusCode = getImagesZipStreamIfZipFileExists(sZipFileName);                        

                        //zipDownloadedStatusCode==1 : sucessfull download
                        //zipDownloadedStatusCode==2 : content length mismatch
                        //zipDownloadedStatusCode==3 : File not found
                        //zipDownloadedStatusCode==4 : for 416 Response Code
                        //zipDownloadedStatusCode==0 : other exceptions
                        if (zipDownloadedStatusCode == 1) {
                            isFullZipFileDownloaded = true;
                        } else if (zipDownloadedStatusCode == 2) {
                            isFullZipFileDownloaded = false;
                            break;
                        } else if (zipDownloadedStatusCode == 3) {
                            isFullZipFileDownloaded = true;
                            break;
                        } else if (zipDownloadedStatusCode == 4) {
                            isFullZipFileDownloaded = true;
                        } else {
                            isFullZipFileDownloaded = false;
                            break;
                        }
                        // Get All Zips Names in List which are downloaded except code 3.
                        if (isFullZipFileDownloaded && zipDownloadedStatusCode != 3) {
                            // add zip file name to list
                            listzipFileNames.add(sZipFileName);
                            versionWiseZipCount++;
                            sZipFileName = sExamEvent + "_" + version + "_" + versionWiseZipCount + ".zip";
                        }

                    } catch (Exception ioe) {
                        LOGGER.error("Exception Occured in ConsoleSynchronizeEventData - zipFilesDownloadFromServer(String zipName)- getting ZipFile  " + sZipFileName + " : " + ioe);
                        isFullZipFileDownloaded = false;
                        break;
                    }

                } while (isFullZipFileDownloaded);

            } // end of for loop

        }// end of outer try
        catch (Exception ioe) {
            LOGGER.error("Exception Occured in ConsoleSynchronizeEventData - zipFilesDownloadFromServer(String zipName): " + sZipFileName + " : " + ioe);
            isFullZipFileDownloaded = false;
        }
    }   
                                              

    
    /**
     * Method for Event Data Synchronization (starts from here) 
     * Exam Version Check request sent to get ExamEvent Version of selected event from OES-SERVER. 
     * if event version status=0, then auto download starts, 
     * else if event version status=1, only same version data get download,
     * else if event version status=2, then no download All Event download activity starts and ends here
     */    
    public boolean synchronizeExamEventData(String exameventId , int completeProcessCount) 
    {
    	/*OESSyncConstants.syncMsg+="\n\n----------------------------------------------------------------------------------------";
    	OESSyncConstants.syncMsg+="\n    Exam Event Data Synchronization ";
    	OESSyncConstants.syncMsg+="\n----------------------------------------------------------------------------------------";*/
    	
    	
        boolean isEventDataSynced=false;
        try
        {
        examEventID=Long.parseLong(exameventId);
        if (examEventID > 0) {
            Map<String, String> requestEventParameters = new HashMap<String, String>();
           
                       
                requestEventParameters.put("eventID", String.valueOf(examEventID));     
                
                    int isEventVersionChange = -1;                                          

                        // Call to check Event Version function
                    OESSyncConstants.currentTask = "<br>2/"+completeProcessCount+" Checking Exam Event version from server ";
            		
                        isEventVersionChange = checkExamEventVersion(examEventID);
                       if (dataavailable) {
                            dataavailable = false;
                           // OESSyncConstants.syncMsg+="\n Exam Event version verified successfully.";                           
                            OESSyncConstants.progressBarPercentage = 100;
                    		OESSyncConstants.eventVersionCheckStatus = OESSyncConstants.currentTask+OESSyncConstants.progressBarPercentage+"% <i class=\"icon-ok\"></i>";
                    		OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus+OESSyncConstants.eventVersionCheckStatus;
                            // full download or version mismatch download
                            
                            if (isEventVersionChange == 0) {
                                isEventDataSynced=getExamEventData(completeProcessCount);
                                
                            } 
                            // same version but itemRepository mismamtch download
                            else if (isEventVersionChange == 1) {

                                if (clientItemRepositoryVersion < serverItemRepositoryVersion) {
                                    
                                   isEventDataSynced= getExamEventData(completeProcessCount);
                                  
                                } else {
                                    isEventDataSynced=true;
                                  /*  OESSyncConstants.eventVersionCheckStatus+="<br> Exam Event Data is already updated.";*/
                                    OESSyncConstants.eventVersionCheckStatus+="<table><tr><td>3/"+completeProcessCount+" Downloading Exam Event data</td></tr><tr><td>4/"+completeProcessCount+" Processing downloaded Exam Event data</td></tr><tr><td>5/"+completeProcessCount+" Verifying data integrity</td></tr><tr><td>Exam Event Data is already updated.</td></tr></table>";
                                    OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus+OESSyncConstants.eventVersionCheckStatus;
                                }

                            } // Event is not Active and Published this moment,So No Download
                            else if (isEventVersionChange == 2) {
                                 isEventDataSynced=true;
                                 OESSyncConstants.syncMsg+="\n \nNo Exam Event data available for download.Please try later!";
                                
                            } // Error
                            else {
                                 isEventDataSynced=false;
                                 OESSyncConstants.syncMsg+="\n \nError in downloading Exam Event data!";                                
                            }

                        } //end of if data vailable after event version check
                        else {
                             isEventDataSynced=false;
                             OESSyncConstants.syncMsg+="\n \nError in verifying Exam Event version.Please try later!";
                            
                        }

            }
            else
            {
            isEventDataSynced=false;
            }
                
            } 
	        catch (OutOfMemoryError e) {
	            isEventDataSynced=false;
	            LOGGER.error("Exception Occured ConsoleSynchronizeEventData - synchronizeExamEventDataViaConsole() : " + e);
	            OESSyncConstants.syncMsg+="\n \nOut of memory Error occured in Exam Event synchronization!";  
	        } 
        	catch (Exception e) {
                isEventDataSynced=false;
                LOGGER.error("Exception Occured ConsoleSynchronizeEventData - synchronizeExamEventDataViaConsole() : " + e);
                OESSyncConstants.syncMsg+="\n \nError occured in Exam Event synchronization!";  
            }
       
        return isEventDataSynced;

    }
    
    /**
     * Method to request the exam event transformer and all saving
     * @return boolean this returns true on success
     * @throws Exception 
     */
    private boolean getExamEventData(int completeProcessCount) throws Exception
    {
    	//OESSyncConstants.syncMsg+="\n Downloading Exam Event data...."; 
    	OESSyncConstants.currentTask = "<br>3/"+completeProcessCount+" Downloading Exam Event data ";
		OESSyncConstants.progressBarPercentage = 0;
		OESSyncConstants.downloadEventDataStatus = OESSyncConstants.currentTask+OESSyncConstants.progressBarPercentage+"%";
		OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus+OESSyncConstants.eventVersionCheckStatus+OESSyncConstants.downloadEventDataStatus;
    	
    	boolean isEventDataSaved = false;
         boolean isEventDataDownloaded = false;
         OESExamEventViewModel viewModelExamEvent=new OESExamEventViewModel();
         Map<String, String> requestEventParameters = new HashMap<String, String>();
        try
        {
        
        requestEventParameters.put("eventID", String.valueOf(examEventID));
                                
        viewModelExamEvent = eventTransformerRequest(requestEventParameters);
                                
                                if (viewModelExamEvent != null) {
                                	OESSyncConstants.progressBarPercentage = OESSyncConstants.EVENT_DATA_PARTIAL_DOWNLOAD_PER;
                        			OESSyncConstants.downloadEventDataStatus = OESSyncConstants.currentTask+OESSyncConstants.progressBarPercentage+"%";
                        			OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus+OESSyncConstants.eventVersionCheckStatus+OESSyncConstants.downloadEventDataStatus;
                                    
                                    isEventDataDownloaded = downloadExamEventDataAndInsertIntoWorkTables(viewModelExamEvent);
                        			 if (isEventDataDownloaded) {
                                    	zipFilesDownloadFromServer();
                                    }
                                } // end of if (viewModelExamEvent != null)

                                if (isFullZipFileDownloaded) {
                                	
                                	OESSyncConstants.progressBarPercentage = OESSyncConstants.SUCCESSFULL_COMPLETION_PER;
                          			OESSyncConstants.downloadEventDataStatus = OESSyncConstants.currentTask+OESSyncConstants.progressBarPercentage+"% <i class=\"icon-ok\"></i>";
                          			OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus+OESSyncConstants.eventVersionCheckStatus+OESSyncConstants.downloadEventDataStatus;
                                    dataavailable = false;                                   
                                    
                                 /*   OESSyncConstants.syncMsg+="\n Exam Event Data downloaded successfully.";
                                    
                                    OESSyncConstants.syncMsg+="\n Processing downloaded Exam Event data...";                                    
*/
                                    //extract Images from Zip and save on Clinet Physical Path
                                    
                                    OESSyncConstants.currentTask = "<br>4/"+completeProcessCount+" Processing downloaded Exam Event data ";
                            		OESSyncConstants.progressBarPercentage = 0;
                            		OESSyncConstants.processEventDataStatus = OESSyncConstants.currentTask+OESSyncConstants.progressBarPercentage+"%";
                            		OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus+OESSyncConstants.eventVersionCheckStatus+OESSyncConstants.downloadEventDataStatus+OESSyncConstants.processEventDataStatus;
                            		
                                    if (isAllImagesExtractedfromZipFiles()) {
                                    	// after image extraction progreess bar should proceed upto 25% completion.
                                        isEventDataSaved = saveExamEventData(viewModelExamEvent);
 
                                        if (isEventDataSaved) {
                                            OESSyncConstants.progressBarPercentage = OESSyncConstants.SUCCESSFULL_COMPLETION_PER;
                                 			OESSyncConstants.processEventDataStatus = OESSyncConstants.currentTask+OESSyncConstants.progressBarPercentage+"% <i class=\"icon-ok\"></i>";
                                 			OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus+OESSyncConstants.eventVersionCheckStatus+OESSyncConstants.downloadEventDataStatus+OESSyncConstants.processEventDataStatus;
                                         
                                        	/*OESSyncConstants.syncMsg+="\n Exam Event data synchronized successfully.";
                                            OESSyncConstants.syncMsg+="\n Verifying data integrity...";
                                           */ 
                                            // DELETE ITEMS HAVING INCOMPLTE IMAGES AND SOFT DELETE ITEMS HAVING DELETED FLAG=1
                                 			OESSyncConstants.currentTask = "<br>5/"+completeProcessCount+" Verifying data integrity ";
                                     		OESSyncConstants.progressBarPercentage = 0;
                                     		OESSyncConstants.verifyingDataIntegrityStatus = OESSyncConstants.currentTask+OESSyncConstants.progressBarPercentage+"%";
                                     		OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus+OESSyncConstants.eventVersionCheckStatus+OESSyncConstants.downloadEventDataStatus+OESSyncConstants.processEventDataStatus+OESSyncConstants.verifyingDataIntegrityStatus;
                                     		
                                            if (verifyExamEventDataIntegrity(viewModelExamEvent.getItemsForDelete())) {
                                            	//OESSyncConstants.syncMsg+="\n Data integrity verification completed successfully.";
                                            	OESSyncConstants.progressBarPercentage = OESSyncConstants.SUCCESSFULL_COMPLETION_PER;
                                         		OESSyncConstants.verifyingDataIntegrityStatus = OESSyncConstants.currentTask+OESSyncConstants.progressBarPercentage+"% <i class=\"icon-ok\"></i>";
                                         		OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus+OESSyncConstants.eventVersionCheckStatus+OESSyncConstants.downloadEventDataStatus+OESSyncConstants.processEventDataStatus+OESSyncConstants.verifyingDataIntegrityStatus;
                                         		
                                                
                                            } else {
                                            	OESSyncConstants.syncMsg+="\n Data integrity verification completed with some errors. ";
                                           }
                                        } // end of if (isEventDataSaved)
                                        else {

                                            if (dataavailable) {
                                                dataavailable = false;
                                               
                                                OESSyncConstants.syncMsg+="\n \nError in processing downloaded Exam Event data!";
                                               

                                            } else {
                                            	OESSyncConstants.syncMsg+="\n \nNo Exam Event data found for synchronization!";
                                               
                                            }
                                             isEventDataSaved=false;
                                            
                                        } // end of else block (deleteItemSucess)

                                        //} // end of if(isEventDataSaved)
                                    } //end of if(isAllImagesExtractedfromZipFiles(zipName))
                                    else {
                                        dataavailable = false;
                                        OESSyncConstants.syncMsg+="\n  \nError in processing downloaded Exam Event data!";                                       
                                    }//end of else (isAllImagesExtractedfromZipFiles(zipName))

                                } //end of if(isFullZipFile && isEventDataSavedStatus )
                                else {
                                    if (dataavailable) {
                                        dataavailable = false;
                                        OESSyncConstants.syncMsg+="\n \nError in downloading Exam Event data!";
                                        
                                    } else {
                                    	OESSyncConstants.syncMsg+="\n \nNo Exam Event data found for synchronization!";
                                        
                                    }
                                     isEventDataSaved=false;
                                } // end of else block of if(isFullZipFile && isEventDataSavedStatus )

    }
        catch(Exception e)
        {
            isEventDataSaved=false;
            throw e;
        }
        return isEventDataSaved;
    }
    
    /**
     * Method to set details of Exam Venue requested for Exam Event data download
     * @param Map<String, String>
     * @return Map<String, String> this returns the map of request params
     */
    private Map<String, String> setVenueRequestStatusforDataDowload(Map<String, String> requestParams)
    {
        try
        {
            Format formatter = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		    String sDate = formatter.format(new Date());
		    
		    requestParams.put("venueId", String.valueOf(AppInfoHelper.appInfo.getExamVenueId()));
		    requestParams.put("venueCode", AppInfoHelper.appInfo.getExamVenueCode());
		    requestParams.put("activityTime", sDate);
		    requestParams.put("oesAppName", appName);  
         }        
        catch(Exception e)
        {
             LOGGER.error("Exception Occured Event Data Synchronizer - setVenueRequestforDataDowloadStatus :" + e);
        }
        return requestParams;
    }

    /**
     * Method to fetch the Partial Exam Event Data
     * @param postRequest
     * @param requestParams
     * @param eventSyncType
     * @return OESExamEventViewModel this returns the OESExamEventViewModel
     * @throws Exception
     * @throws IOException
     * @throws IllegalStateException
     */
    public OESExamEventViewModel GetPartialEventData(HttpPost postRequest, Map<String, String> requestParams,EventSyncType eventSyncType) throws Exception, IOException, IllegalStateException 
    {
    	
        try {
			requestParams.put("eventSyncType",
					String.valueOf(eventSyncType.ordinal()));
			postRequest = MKCLHttpClient.addParametersToPost(postRequest,
					requestParams);
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
			String jsonText = sb.toString();
			//        System.out.println("------------------------------------------------");
			//        System.out.println("JSON Response");
			//        System.out.println("------------------------------------------------");
			//System.out.println(jsonText);
			if (jsonText.length() > 2) {
				jsonText = AESHelper.decryptAsdecompress(jsonText,
						"MKCLSecurity$#@!");

			}
			OESExamEventViewModel ve = parseExamEventData(jsonText);
			jsonText = null;
			sb = null;
			inputStream = null;
			postRequest = null;
			response = null;
			reader = null;
			return ve;
		} catch (Exception e) {
			throw e;
		}
    }
    
    /**
     * Method to fill Data to OBjects 
     * @param sub
     * @param main
     * @return OESExamEventViewModel this returns the OESExamEventViewModel
     */
    public OESExamEventViewModel fillDataToObjects(OESExamEventViewModel sub,OESExamEventViewModel main)
    {
        if(sub.getExamEvent()!=null)
        {
            main.setExamEvent(sub.getExamEvent());
        }

        if(sub.getExamVenueExamEventAssociation()!=null)
        {
            main.setExamVenueExamEventAssociation(sub.getExamVenueExamEventAssociation());
        }

        if(sub.getExamEventScheduleTypeAssociationList()!=null )
        {
            main.setExamEventScheduleTypeAssociationList(sub.getExamEventScheduleTypeAssociationList());
        }

        if(sub.getPaperList()!=null )
        {
            main.setPaperList(sub.getPaperList());
        }

        if(sub.getPaperItemBankAssociationList()!=null )
        {
            main.setPaperItemBankAssociationList(sub.getPaperItemBankAssociationList());
        }

        if(sub.getPaperItemTypeAssociations()!=null )
        {
            main.setPaperItemTypeAssociations(sub.getPaperItemTypeAssociations());
        }

        if(sub.getMediumOfPaperList()!=null )
        {
            main.setMediumOfPaperList(sub.getMediumOfPaperList());
        }

        if(sub.getPaperMarksList()!=null )
        {
            main.setPaperMarksList(sub.getPaperMarksList());
        }

        if(sub.getPaperWiseSchemesList()!=null )
        {
            main.setPaperWiseSchemesList(sub.getPaperWiseSchemesList());
        }

        if(sub.getPaperDisplayCategoryAssociationList()!=null )
        {
            main.setPaperDisplayCategoryAssociationList(sub.getPaperDisplayCategoryAssociationList());
        }

        if(sub.getExaminingBodyItemAssociationList()!=null )
        {
            main.setExaminingBodyItemAssociationList(sub.getExaminingBodyItemAssociationList());
        }

        if(sub.getStandardItemAssociationList()!=null )
        {
            main.setStandardItemAssociationList(sub.getStandardItemAssociationList());
        }

        if(sub.getSectorItemAssociationList()!=null )
        {
            main.setSectorItemAssociationList(sub.getSectorItemAssociationList());
        }

        if(sub.getSkillItemAssociations()!=null )
        {
            main.setSkillItemAssociations(sub.getSkillItemAssociations());
        }

        if(sub.getItemBankItemAssociationList()!=null )
        {
            main.setItemBankItemAssociationList(sub.getItemBankItemAssociationList());
        }

        if(sub.getItemsForDelete()!=null )
        {
            main.setItemsForDelete(sub.getItemsForDelete());
        }

        if(sub.getSingleCorrectList()!=null )
        {
            main.setSingleCorrectList(sub.getSingleCorrectList());
        }

        if(sub.getMultipleCorrectList()!=null )
        {
            main.setMultipleCorrectList(sub.getMultipleCorrectList());
        }

        if(sub.getPictureIdentificationList()!=null )
        {
            main.setPictureIdentificationList(sub.getPictureIdentificationList());
        }

        if(sub.getComprehensionList()!=null )
        {
            main.setComprehensionList(sub.getComprehensionList());
        }

        if(sub.getTwoStageReasoningList()!=null )
        {
            main.setTwoStageReasoningList(sub.getTwoStageReasoningList());
        }

        if(sub.getMatchingPairList()!=null )
        {
            main.setMatchingPairList(sub.getMatchingPairList());
        }

        if(sub.getTypingList()!=null )
        {
            main.setTypingList(sub.getTypingList());
        }

        if(sub.getDifficultyLevelMarkingSchemeList()!=null )
        {
            main.setDifficultyLevelMarkingSchemeList(sub.getDifficultyLevelMarkingSchemeList());
        }

        if(sub.getItemBankGroupDifficultyLevelSchemeList()!=null )
        {
            main.setItemBankGroupDifficultyLevelSchemeList(sub.getItemBankGroupDifficultyLevelSchemeList());
        }

        if(sub.getSectionList()!=null )
        {
            main.setSectionList(sub.getSectionList());
        }

        if(sub.getSimulationItemList()!=null )
        {
            main.setSimulationItemList(sub.getSimulationItemList());
        }

        if(sub.getItemBankList()!=null )
        {
            main.setItemBankList(sub.getItemBankList());
        }

        if(sub.getExamEventIdenticalPaperItemsList()!=null )
        {
            main.setExamEventIdenticalPaperItemsList(sub.getExamEventIdenticalPaperItemsList());
        }

        if(sub.getMultimediaList()!=null )
        {
            main.setMultimediaList(sub.getMultimediaList());
        }

        if(sub.getPracticalList()!=null )
        {
            main.setPracticalList(sub.getPracticalList());
        }

        if(sub.getFunctionMasterList()!=null )
        {
            main.setFunctionMasterList(sub.getFunctionMasterList());
        }

        if(sub.getParameterMasterList()!=null )
        {
            main.setParameterMasterList(sub.getParameterMasterList());
        }

        if(sub.getPracticalSubjectList()!=null )
        {
            main.setPracticalSubjectList(sub.getPracticalSubjectList());
        }

        if(sub.getPracticalCategoryList()!=null )
        {
            main.setPracticalCategoryList(sub.getPracticalCategoryList());
        }

        if(sub.getOesTemplateList()!=null )
        {
            main.setOesTemplateList(sub.getOesTemplateList());
        }

        if(sub.getOesTemplateImageList()!=null )
        {
            main.setOesTemplateImageList(sub.getOesTemplateImageList());
        }

        if(sub.getRiFormList()!=null )
        {
            main.setRiFormList(sub.getRiFormList());
        }

        if(sub.getFillInBlanksList()!=null )
        {
            main.setFillInBlanksList(sub.getFillInBlanksList());
        }

        if(sub.getMatchTheColumnsList()!=null )
        {
            main.setMatchTheColumnsList(sub.getMatchTheColumnsList());
        }

        if(sub.getChapterList()!=null )
        {
            main.setChapterList(sub.getChapterList());
        }

        if(sub.getChapterPaperAssociationList()!=null )
        {
            main.setChapterPaperAssociationList(sub.getChapterPaperAssociationList());
        }

        if(sub.getAbilityItemAssociationList()!=null )
        {
            main.setAbilityItemAssociationList(sub.getAbilityItemAssociationList());
        }

        if(sub.getActivityTypeItemAssociationList()!=null )
        {
            main.setActivityTypeItemAssociationList(sub.getActivityTypeItemAssociationList());
        }

        if(sub.getStandardSubjectAssociation()!=null)
        {
            main.setStandardSubjectAssociation(sub.getStandardSubjectAssociation());
        }

        if(sub.getSuccessList()!=null )
        {
            main.setSuccessList(sub.getSuccessList());
        }
        
        if(sub.getErrorCorrectionList()!=null )
        {
            main.setErrorCorrectionList(sub.getErrorCorrectionList());
        }
        
        if(sub.getEssayWritingList()!=null )
        {
            main.setEssayWritingList(sub.getEssayWritingList());
        }
        
        if(sub.getWordCloudList()!=null )
        {
            main.setWordCloudList(sub.getWordCloudList());
        }
        if(sub.getHotSpotList()!=null )
        {
            main.setHotSpotList(sub.getHotSpotList());
        }
        if(sub.getComprehensionMixQT()!=null)
        {
        	main.setComprehensionMixQT(sub.getComprehensionMixQT());
        }
        if(sub.getItemWiseSchemeList()!=null)
        {
        	main.setItemWiseSchemeList(sub.getItemWiseSchemeList());
        }
        if(sub.getNewFillInBlanksList()!=null)
        {
        	main.setNewFillInBlanksList(sub.getNewFillInBlanksList());
        }
        return main;
    }
    
    /**
     * Method to get all zip file size download from server
     * @return long this returns the estimated zip file size to download
     */
    public long getAllZipFileSizeDownloadFromServer() {
        String sZipFileName = "";
        String sExamEvent = "";
        int zipDownloadedStatusCode = 0;        
        sExamEvent = String.valueOf(examEventID);
        int versionWiseZipCount = 1;
        long esimatedZipLengthToDownload=0;
        long currentZipSize = 0;
        try {

            //incremental call to get all Zip files of Event of given event version
            if (clientEventVersion == 0) {
                clientEventVersion = 1;
            }
            isFullZipFileDownloaded = true;
            // Loop to Get Zip Files of All Versions which Client Missing
            for (long version = clientEventVersion; (version <= serverEventVersion && isFullZipFileDownloaded); version++) {

                versionWiseZipCount = 1;
                sZipFileName = sExamEvent + "_" + version + "_" + versionWiseZipCount + ".zip";
                // version wise multiple zip download
              
                  
                    try {
                        //check whether given zip of specified version exists on Oes-Server or not, and
                        // if Exists then write to zippedimages folder
                    	currentZipSize = getActualLengththOfZip(sZipFileName); 
                    	if(currentZipSize > 0) {
                    		versionWiseZipCount++;
                            sZipFileName = sExamEvent + "_" + version + "_" + versionWiseZipCount + ".zip";
                            esimatedZipLengthToDownload+=currentZipSize;
                    	}
                    	
                    	 

                       /* //zipDownloadedStatusCode==1 : sucessfull download
                        //zipDownloadedStatusCode==2 : content length mismatch
                        //zipDownloadedStatusCode==3 : File not found
                        //zipDownloadedStatusCode==4 : for 416 Response Code
                        //zipDownloadedStatusCode==0 : other exceptions
                        if (zipDownloadedStatusCode == 1) {
                            isFullZipFileDownloaded = true;
                        } else if (zipDownloadedStatusCode == 2) {
                            isFullZipFileDownloaded = false;
                            break;
                        } else if (zipDownloadedStatusCode == 3) {
                            isFullZipFileDownloaded = true;
                            break;
                        } else if (zipDownloadedStatusCode == 4) {
                            isFullZipFileDownloaded = true;
                        } else {
                            isFullZipFileDownloaded = false;
                            break;
                        }
                        // Get All Zips Names in List which are downloaded except code 3.
                        if (isFullZipFileDownloaded && zipDownloadedStatusCode != 3) {
                            // add zip file name to list
                            listzipFileNames.add(sZipFileName);
                            versionWiseZipCount++;
                            sZipFileName = sExamEvent + "_" + version + "_" + versionWiseZipCount + ".zip";
                        }*/

                    } catch (Exception ioe) {
                        LOGGER.error("Exception Occured in getAllZipFileSizeDownloadFromServer - zipFilesDownloadFromServer(String zipName)- getting ZipFile  " + sZipFileName + " : " + ioe);
                        isFullZipFileDownloaded = false;
                        break;
                    }

              

            } // end of for loop

        }// end of outer try
        catch (Exception ioe) {
            LOGGER.error("Exception Occured in ConsoleSynchronizeEventData - zipFilesDownloadFromServer(String zipName): " + sZipFileName + " : " + ioe);
            isFullZipFileDownloaded = false;
        }
        
        return esimatedZipLengthToDownload;
    }  

    /**
     * Method to fetch the actual length of zip
     * @param zipName
     * @return long this returns the zip file size in bytes
     */
    private long getActualLengththOfZip(String zipName) {

        URL url = null;
        long zipFilebytes = 0;
       
        try {

            //Check ImagesZip From Server
            url = new URL(MKCLUtility.loadConnectionPropertiesFile().getProperty("OESSERVERURL") + "/resources/WebFiles/zippedimages/" + zipName);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
           /* // return input stream if File found on server,else throws File Not found exception           

            // Check if Zip Parent Folder(zippedImages) Exists,else create it
            zipParentfolder = new File(sZippedImagesPath);
            if (!zipParentfolder.exists()) {
                zipParentfolder.mkdir();
            }

            // Check if requested ZipFile exists in zippedImages Folder
            zipFileName = new File(zipParentfolder.getAbsoluteFile() + "/" + zipName);
            if (zipFileName.exists()) {
                prevDownloadedBytes = zipFileName.length();
                //Resume Download: Set Accept Ranges to get content next to prevDownloadedBytes
                connection.setRequestProperty("Range", "bytes=" + zipFileName.length() + "-");
            }
           */ 
            connection.connect();
            zipFilebytes = connection.getContentLength();
        

            /*// connection.getInputStream will throw File not found exception
            // which helps to identify end of counter for  Version wise Zip files
            // Also, return response code 416 in case when full zip get downloaded sucessfully
            // and we try to read next to file Range.
            try {
                bufferedIS = new BufferedInputStream(connection.getInputStream());
            } catch (FileNotFoundException fe) {
                LOGGER.error("INFO- Zip FileNotFound in SynchronizeEventData : " + fe);

                // isZipDownloadSuccess = true;
                returnCode = 3;
                return returnCode;
            } catch (IOException ioe) {
                //isZipDownloadSuccess = false;

                if (connection.getResponseCode() == 416) {
                    returnCode = 4;
                    //isZipDownloadSuccess = true;
                }
                LOGGER.error("INFO-Response Code 416 for Zip File : " + zipName);
                return returnCode;
            }
            fileOS = (prevDownloadedBytes == 0) ? new FileOutputStream(zipParentfolder.getAbsoluteFile() + "/" + zipName) : new FileOutputStream(zipFileName, true);
            byteData = new byte[2048];

            while ((available = bufferedIS.read(byteData)) != -1) {

                fileOS.write(byteData, 0, available);
                // prevDownloadedBytes += available;
            }*/

           /* bufferedIS.close();
            fileOS.close();
            connection = null;
            //Comapare Content Length of Both Zips(Came from Server and Created on Client)
            if ((prevDownloadedBytes + zipFilebytes) == new File(zipParentfolder.getAbsoluteFile() + File.separator + zipName).length()) {
                returnCode = 1;

            } else {
                returnCode = 2;
                if (zipCallCount < 2) {
                    zipCallCount++;
                    LOGGER.error("INFO- 2nd attempt for ZipFile : " + zipName);
                    returnCode = getImagesZipStreamIfZipFileExists(zipName);
                    // return false to stop futher event downloading of Event data
                }

            }*/
            //}
            // } // enf od if inputStream is not null
        } catch (FileNotFoundException fe) {
            LOGGER.error("Exception Occured in ConsoleSynchronizeEventData - getImagesZipStreamIfZipFileExists(String zipName): " + fe);

            zipFilebytes = 0;
        } catch (IOException ioe) {
            LOGGER.error("Exception Occured in ConsoleSynchronizeEventData - getImagesZipStreamIfZipFileExists(String zipName) : " + ioe);
            zipFilebytes = 0;
        } catch (Exception e) {
            LOGGER.error("Exception Occured in ConsoleSynchronizeEventData - getImagesZipStreamIfZipFileExists(String zipName) : " + e);
            zipFilebytes = 0;
        }

        return zipFilebytes;
    }
    
    /**
     * Method to fetch the Candidate Count by Exam Event
     * @param examEventID
     * @param examVenueID
     * @return int this returns the candidate count
     */
    public int getCandidateCountByEvent(String examEventID,String examVenueID)
    {
        final String uri = MKCLUtility.loadConnectionPropertiesFile().getProperty("OESSERVERURL") + "/OESApi/getCandidateCount?examEventID="+examEventID+"&examVenueID="+examVenueID;
        RestTemplate restTemplate = new RestTemplate();
        String result = restTemplate.getForObject(uri, String.class);
       return Integer.valueOf(result);
    }
    
    /**
     * Method to reset Sync Message Constants
     */
    public static void resetSyncMsg() {
		OESSyncConstants.syncMsg = "";
    	OESSyncConstants.syncStatus=false;
    	OESSyncConstants.errorLevel=1;
		OESSyncConstants.progressBarPercentage = 0;
    	OESSyncConstants.currentTask = ""; 
    	OESSyncConstants.esbConnectionStatus = "";
    	OESSyncConstants.downloadMasterDataStatus = "";
    	OESSyncConstants.processingMasterDataStatus = "";
    	OESSyncConstants.eventVersionCheckStatus = "";
    	OESSyncConstants.downloadEventDataStatus = "";
    	OESSyncConstants.verifyingDataIntegrityStatus = "";
    	OESSyncConstants.candidateDownloadStatus = "";
    	OESSyncConstants.processEventDataStatus = "";
    	   	
	   	
    }
    
    
}
