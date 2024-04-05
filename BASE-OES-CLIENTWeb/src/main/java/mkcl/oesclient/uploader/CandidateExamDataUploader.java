package mkcl.oesclient.uploader;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Semaphore;
import java.util.stream.Collectors;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;

import mkcl.oesclient.admin.services.CandidateUploadDataParser;
import mkcl.oesclient.commons.services.ExamEventServiceImpl;
import mkcl.oesclient.commons.services.ExamVenueActivationServicesImpl;
import mkcl.oesclient.commons.services.OESLogServices;
import mkcl.oesclient.commons.utilities.AppInfoHelper;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.model.CandidateExam;
import mkcl.oesclient.uploader.service.CandidateExamDataUploaderService;
import mkcl.oesclient.viewmodel.CandidateExamItemAnswerViewModel;
import mkcl.oesclient.viewmodel.CandidateExamLogViewModel;
import mkcl.oespcs.model.ExamVenue;
import mkcl.os.apps.MKCLHttpClient;
import mkcl.os.security.AESHelper;

public class CandidateExamDataUploader
{
	static final Semaphore available = new Semaphore(1, true);
	private static final Logger LOGGER = LoggerFactory.getLogger(CandidateExamDataUploader.class);
	static CandidateExamDataUploaderService uServices = new CandidateExamDataUploaderService();
	private static final String ESBURL = "/transformer/executeTransformerJsonSecure/baseOESUploadCandidate";
	private static final String TRANSFORMERID = "DB1-DB277777777777770006";
	private static final String APPLICATIONID = "abc";
	private static final String AESDECRYPTKEY = "MKCLSecurity$#@!";
	// net connection is not Available
	private  static final int ESB_CONNECTION_FAILED = 0;
	// net conection is availble
	private static final int ESB_CONNECTION_SUCCESS = 1;
	// success
	private static final int UPLOAD_SUCCESS = 2;
	// error occure
	private static final int UPLOAD_FAILED = 3;
	// no data to upload
	private static final int NO_DATA_to_UPLOAD = 4;
	// server is not responding
	private static final int SERVER_NOT_RESPONDING = 5;
	
	private static final int UPLOAD_ALREDY_IN_PROGRESS = 6;
	private static final int AUTO_UPLOAD_DISABLED = 7;
	
	public static int uploadPaperWiseData(long paperID, long examEventID)
	{		
		boolean aquired =false;
		try 
		{
			aquired = available.tryAcquire();
			if(aquired)
			{
				LOGGER.info("Paperewise Data Upload Started");
				int status = checkConnectionToESB();
				if (status == ESB_CONNECTION_SUCCESS) 
				{
					return startUploadData(paperID, examEventID);			
				}
				else
				{
					return status;
				}
			}
			else
			{
				return UPLOAD_ALREDY_IN_PROGRESS;
			}
		} 
		catch (Exception e) 
		{
			throw e;
		}
		finally
		{
			if(aquired)
				available.release();
		}
	}
	
	@Scheduled(initialDelay=300000, fixedDelay=1800000)
	void uploadDataScheduler()
	{
		if(Boolean.parseBoolean(MKCLUtility.loadMKCLPropertiesFile().getProperty("AutoUpload")))
		{	
			LOGGER.info("Auto upload started.");
			uploadAllData();	
			LOGGER.info("Auto upload finished.");
		}
	}		
	
	public static int uploadAllData() 
	{		
		boolean aquired =false;
		try 
		{
			aquired = available.tryAcquire();
			if(aquired)
			{
				LOGGER.info("All Data Upload Started");
				int status = checkConnectionToESB();
				if (status == ESB_CONNECTION_SUCCESS) 
				{
					return startUploadData();	
				}
				else
				{
					return status;
				}
			}
			else
			{
				return UPLOAD_ALREDY_IN_PROGRESS;
			}
		} 
		catch (Exception e) 
		{
			throw e;
		}
		finally
		{
			if(aquired)
				available.release();
		}
	}

	private static int startUploadData() 
	{
		long batchSize = 0;
		try 
		{
			String jsonResonse = "";
			CandidateExamItemAnswerViewModel candidateExamItemAnswerViewModel = null;
			List<CandidateExam> uploadedCandidateExamData = null;
			Boolean successStatus = false;
			CandidateUploadDataParser parser = new CandidateUploadDataParser();;
			batchSize = Long.parseLong(MKCLUtility.loadMKCLPropertiesFile().getProperty("uploadBatchSize").trim());
			LOGGER.info("uploadbatch size :: "+batchSize);
			
			OESLogServices oesLogServicesObj=new OESLogServices();
			List<CandidateExamLogViewModel> oesExamLogList = null;			
			//generate unique key and save data in tempTable(key, ceid) then we can join that table and find log
			String key = "All"+new Timestamp(System.currentTimeMillis()).getTime();
			boolean examLogSaved=false;
			
			//Upload IncompleteExam Data
			if(uServices.setNotUploadStatus() && uServices.checkForDataToBeUploadforInCompleteExams())
			{
				LOGGER.info("inside uServices.checkForDataToBeUploadforInCompleteExams()");
					
				// get candidate upload Data
				candidateExamItemAnswerViewModel = uServices.getInCompleteCandidateExamData();
				if (candidateExamItemAnswerViewModel != null) 
				{
					// get viewModel Compressed JSON String
					String compressedJsonStr = uServices.getCandidateExamItemAnswerViewModelJsonStrCompressed(candidateExamItemAnswerViewModel, AESDECRYPTKEY);
					
					jsonResonse = requestESB(compressedJsonStr);
					if (jsonResonse != null && !jsonResonse.isEmpty()) 
					{
						// check response status
						successStatus = (Boolean) parser.getIsSuccessfullStatus(jsonResonse);
						if (successStatus) 
						{
							if(new ExamEventServiceImpl().isExamLogEnabled(candidateExamItemAnswerViewModel.getExamEventIds().stream().collect(Collectors.joining(",")))  && AppInfoHelper.appInfo.getExamLogUploadOnMangoDBIsEnabled()) 
							{
								oesExamLogList=null;
								LOGGER.info("OESExamLog data upload started...");
								oesLogServicesObj.insertLogInWorkTable(candidateExamItemAnswerViewModel.getCandidateExamsIncompleteData(), key);
								oesExamLogList=oesLogServicesObj.getCandidateExamLogByKey(key, candidateExamItemAnswerViewModel.getExamEventIds().stream().collect(Collectors.joining(",")));
								examLogSaved=false;
								if(oesExamLogList!=null && oesExamLogList.size()>0) {
									//If exist then delete
									 oesLogServicesObj.deletePreviousExamLogFromMongoDB(candidateExamItemAnswerViewModel.getCandidateExamsIncompleteData());
									 
									// Requesting save candidateExamLog in MongoDB
									examLogSaved = oesLogServicesObj.saveExamLogInMongoDB(oesExamLogList);
									
									//Update uploaded examLog
									if(examLogSaved)
										oesLogServicesObj.updateUploadedOESExamLogDataStatus(uploadedCandidateExamData);
								}
								//Delete log by key
								oesLogServicesObj.deleteWorkExamLogByKey(key);
							}
							if((oesExamLogList!=null && oesExamLogList.size()>0) ? examLogSaved:true)
							{
								LOGGER.info("Data uploaded Successfully of In-complete Exams");
							} else {
								LOGGER.error("In MongoDB OESEXAMLOG Data Upload Failed for key : "+key+" of In-completeExam Exam");
							}
						}
						else
						{
							LOGGER.error("Data Upload Not Completed As response does not contain successfull status");
						}
					} 
					else 
					{
						LOGGER.error("Data Upload Not Completed As HttpClient connection could not be eastablished ");
					}
				} 
				else 
				{
					LOGGER.error("Data Upload Not Completed As upload view model is null ");
				}
			}
			
			jsonResonse = "";
			candidateExamItemAnswerViewModel = null;
			successStatus = false;
			
			//Upload CompleteExam Data
			//upload Until no data for upload found
			int i=0;
			while(uServices.setNotUploadStatus() && uServices.checkForDataToBeUploadForCompleteExams())
			{
				i++;
				// get candidate upload Data
				candidateExamItemAnswerViewModel = uServices.getCandidateExamData(batchSize);
				if (candidateExamItemAnswerViewModel != null) 
				{
					// get viewModel Compressed JSON String
					String compressedJsonStr = uServices.getCandidateExamItemAnswerViewModelJsonStrCompressed(candidateExamItemAnswerViewModel, AESDECRYPTKEY);
						
					// Requesting ESB
					jsonResonse = requestESB(compressedJsonStr);
					if (jsonResonse != null && !jsonResonse.isEmpty()) 
					{
						successStatus = (Boolean) parser.getIsSuccessfullStatus(jsonResonse);
						if (successStatus) 
						{
							// get candidate exam data of successful upload
							uploadedCandidateExamData = parser.parseCandidateExamList(jsonResonse);
							if (uploadedCandidateExamData != null && uploadedCandidateExamData.size() > 0) 
							{
								if(new ExamEventServiceImpl().isExamLogEnabled(candidateExamItemAnswerViewModel.getExamEventIds().stream().collect(Collectors.joining(","))) && AppInfoHelper.appInfo.getExamLogUploadOnMangoDBIsEnabled()) 
								{
									oesExamLogList=null;
									LOGGER.info("OESExamLog data upload started...");
									oesLogServicesObj.insertLogInWorkTable(uploadedCandidateExamData, key);
									oesExamLogList=oesLogServicesObj.getCandidateExamLogByKey(key, candidateExamItemAnswerViewModel.getExamEventIds().stream().collect(Collectors.joining(",")));
									examLogSaved=false;
									if(oesExamLogList!=null && oesExamLogList.size()>0) {
										//If exist then delete
										 oesLogServicesObj.deletePreviousExamLogFromMongoDB(uploadedCandidateExamData);
										 
										// Requesting save candidateExamLog in MongoDB
										examLogSaved = oesLogServicesObj.saveExamLogInMongoDB(oesExamLogList);
										
										//Update uploaded examLog
										if(examLogSaved)
											oesLogServicesObj.updateUploadedOESExamLogDataStatus(uploadedCandidateExamData);
									}
									//Delete log by key
									oesLogServicesObj.deleteWorkExamLogByKey(key);
								}
								if((oesExamLogList!=null && oesExamLogList.size()>0) ? examLogSaved:true)
								{
									if(!uServices.updateUploadedDataStatus(uploadedCandidateExamData))
										return UPLOAD_FAILED;
								} else {
									LOGGER.error("In MongoDB OESEXAMLOG Data Upload Failed for key : "+key+" of Completed Exam");
									return UPLOAD_FAILED;
								}
							} 
						}
						else
						{
							LOGGER.error("Data Upload Not Completed As response does not contain successfull status.");
							return UPLOAD_FAILED;
						}
					}	
					else 
					{
						LOGGER.error("Data Upload Not Completed As json response is empty or null.");
						return UPLOAD_FAILED;
					}
				} 
				else 
				{
					LOGGER.error("Data Upload Not Completed As upload view model is null ");
					return UPLOAD_FAILED;
				}
				//reset all variables
				jsonResonse = "";
				candidateExamItemAnswerViewModel = null;
				uploadedCandidateExamData = null;
				successStatus = false;
			}
			if(i==0)
				return NO_DATA_to_UPLOAD;
		} 
		catch (Exception e) 
		{
			LOGGER.error("Exception Occured while Sending request to ESB-startUploadData: ", e);
			return UPLOAD_FAILED;
		}
		finally
		{
			LOGGER.info("All Data Upload finished");
		}
		return UPLOAD_SUCCESS;
	}

	private static String requestESB(String compressedJsonStr) throws Exception 
	{
		String jsonResonse = "";
		String appName = null;
		try {

			HttpPost postRequest = new HttpPost(MKCLUtility.loadConnectionPropertiesFile().getProperty("ESBURL") + ESBURL);
			// Adding necessary parameters to request required for execution
			// of transformer
			Map<String, String> requestParameters = new HashMap<String, String>();
			// transformer ID
			requestParameters.put("transformerId", TRANSFORMERID);
			requestParameters.put("appId", APPLICATIONID);
			requestParameters.put("candidateData", compressedJsonStr);
			
			//app name
			//appName = contextRealPath.substring(0, contextRealPath.lastIndexOf("/")).substring(contextRealPath.substring(0, contextRealPath.lastIndexOf("/")).lastIndexOf("/")+1,contextRealPath.substring(0, contextRealPath.lastIndexOf("/")).length());
			appName = AppInfoHelper.appInfo.getAppName();
			requestParameters.put("oesAppName", "OES");
            
			//exam venue details
			setVenueRequestStatusforDataDowload(requestParameters);
			
			
			// send
			postRequest = MKCLHttpClient.addParametersToPost(postRequest, requestParameters);
			HttpResponse response = MKCLHttpClient.sendRequest(postRequest);
		
			// Reading the JSON response
			BufferedReader reader = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));
			StringBuilder sb = new StringBuilder();
			String line = null;
			while ((line = reader.readLine()) != null) {
				sb.append(line + "\n");
			}
			reader.close();
			reader = null;
			String jsonText = sb.toString();
			if (jsonText.length() > 2) {
				jsonText = AESHelper.decryptAsdecompress(jsonText, AESDECRYPTKEY);
				jsonResonse = jsonText;
			}
		} 
		catch (Exception e) 
		{			
			LOGGER.error("Exception Occured while calling ESB-requestESB: ", e);
			throw e;
		}
		return jsonResonse;
	}

	private static int checkConnectionToESB() {
		BufferedReader br=null;
		try 
		{
			LOGGER.info("Checking Connection Availability");
			LOGGER.info("esb url ::"+MKCLUtility.loadConnectionPropertiesFile().getProperty("ESBURL"));
			HttpURLConnection urlc = (HttpURLConnection) new URL(MKCLUtility.loadConnectionPropertiesFile().getProperty("ESBURL")).openConnection();
			urlc.connect();
			int code = urlc.getResponseCode();

			// if 3XX redirect happened
			if (code == HttpURLConnection.HTTP_MOVED_TEMP || code == HttpURLConnection.HTTP_MOVED_PERM || code == HttpURLConnection.HTTP_SEE_OTHER) 
			{
				// get redirect url from "location" header field
				String newUrlLoc = urlc.getHeaderField("Location");
				if (newUrlLoc != null && !newUrlLoc.isEmpty()) 
				{
					// create connection to new URL
					urlc = (HttpURLConnection) new URL(newUrlLoc).openConnection();
					urlc.connect();
					code = urlc.getResponseCode();
				} 
				else 
				{
					LOGGER.error("Exception Occured while Checking ESB Connection-checkConnectionToESB: 3XX occured and new Redirect URL is null ");
				}

			}

			if (code == HttpURLConnection.HTTP_OK) 
			{
				br = new BufferedReader(new InputStreamReader(urlc.getInputStream()));
				StringBuilder sb = new StringBuilder();
				String line;
				while ((line = br.readLine()) != null) 
				{
					sb.append(line);
				}
				br.close();
				br=null;
				if (sb.toString().contains("true")) 
				{
					LOGGER.info("Connection is Available");
					return ESB_CONNECTION_SUCCESS;
				}
				else
				{
					LOGGER.error("Connection is Not Available as ESB response does not contain true value in it.");
					return ESB_CONNECTION_FAILED;
				}
			} 
			else 
			{
				LOGGER.error("Connection response is not returned HTTP_OK: Response code received : " + code);
				return SERVER_NOT_RESPONDING;				
			}
		} 
		catch (Exception ce) 
		{
			LOGGER.error("Exception Occured while Checking ESB Connection-checkConnectionToESB: ", ce);
			return SERVER_NOT_RESPONDING;			
		} 		
		finally
		{
			try
			{
				if(br!=null)
				{
					br.close();
				}
			}
			catch(Exception ex)
			{
				
			}
		}		
	}

	private static void setVenueRequestStatusforDataDowload(Map<String, String> requestParams) {
		try {
			ExamVenue examVenue = null;
			examVenue = new ExamVenueActivationServicesImpl().getExamVenue();
			if (examVenue != null) {
				requestParams.put("venueId", String.valueOf(examVenue.getExamVenueID()));
				requestParams.put("venueCode", examVenue.getExamVenueCode());
				requestParams.put("activityTime",new SimpleDateFormat("dd-MM-yyyy HH:mm:ss").format(new Date()));
			}
		} catch (Exception e) {
			LOGGER.error("Exception Occured in setVenueRequestStatusforDataDowload :" , e);
		}
	}
	
	private static int startUploadData(long paperID,long examEventID) {
		long batchSize = 0;
		try 
		{
			String jsonResonse = "";
			CandidateExamItemAnswerViewModel candidateExamItemAnswerViewModel = null;
			List<CandidateExam> uploadedCandidateExamData = null;
			Boolean successStatus = false;
			CandidateUploadDataParser parser = new CandidateUploadDataParser();			
			batchSize = Long.parseLong(MKCLUtility.loadMKCLPropertiesFile().getProperty("uploadBatchSize").trim());
			
			List<CandidateExamLogViewModel> oesExamLogList = null;
			OESLogServices oesLogServicesObj=new OESLogServices();
			boolean examLogSaved=false;
			String key = examEventID+"_"+paperID+"_"+new Timestamp(System.currentTimeMillis()).getTime();
			
			//update NONE Param :papers to not upload
			if(!uServices.setNotUploadStatus(paperID,examEventID))
				return UPLOAD_FAILED;
			
			boolean logEnabled = new ExamEventServiceImpl().isExamLogEnabled(String.valueOf(examEventID));
			
			//Upload CompleteExam Data
			//upload Until no data for upload found
			int i=0;
			while(uServices.checkForDataToBeUploadForCompleteExams(paperID,examEventID))
			{
				i++;
				//update NONE Param :papers to not upload
				uServices.setNotUploadStatus(paperID,examEventID);
					
				// get candidate upload Data
				candidateExamItemAnswerViewModel = uServices.getCandidateExamDataPaperWise(paperID,examEventID,batchSize);
				if (candidateExamItemAnswerViewModel != null) 
				{
					// get viewModel Compressed JSON String
					String compressedJsonStr = uServices.getCandidateExamItemAnswerViewModelJsonStrCompressed(candidateExamItemAnswerViewModel, AESDECRYPTKEY);
					
					// Requesting ESB
					jsonResonse = requestESB(compressedJsonStr);
					if (jsonResonse != null && !jsonResonse.isEmpty()) 
					{
						// check response status
						successStatus = (Boolean) parser.getIsSuccessfullStatus(jsonResonse);
						
						if (successStatus) 
						{
							// get candidate exam data of successful upload
							uploadedCandidateExamData = parser.parseCandidateExamList(jsonResonse);
							if (uploadedCandidateExamData != null && uploadedCandidateExamData.size() > 0) 
							{
					 			if(logEnabled && AppInfoHelper.appInfo.getExamLogUploadOnMangoDBIsEnabled())
								{
									oesExamLogList=null;
									LOGGER.info("OESExamLog data upload started...");
									oesLogServicesObj.insertLogInWorkTable(uploadedCandidateExamData, key);
									oesExamLogList=oesLogServicesObj.getCandidateExamLogByKey(key, String.valueOf(examEventID));
									examLogSaved=false;
									if(oesExamLogList!=null && oesExamLogList.size()>0) {
										//If exist then delete
										 oesLogServicesObj.deletePreviousExamLogFromMongoDB(uploadedCandidateExamData);
										 
										//Requesting to save candidateExamLog in MongoDB
										examLogSaved = oesLogServicesObj.saveExamLogInMongoDB(oesExamLogList);
										
										//Update uploaded examLog
										if(examLogSaved)
											oesLogServicesObj.updateUploadedOESExamLogDataStatus(uploadedCandidateExamData);
									}

									//Delete log by key
									oesLogServicesObj.deleteWorkExamLogByKey(key);
								}
								if((oesExamLogList!=null && oesExamLogList.size()>0) ? examLogSaved : true)
								{
									if(!uServices.updateUploadedDataStatus(uploadedCandidateExamData))
										return UPLOAD_FAILED;
								} else {
									LOGGER.error("In MongoDB OESEXAMLOG Data Upload Failed for key : "+key+" of ExamEventId "+examEventID);
									return UPLOAD_FAILED;
								}
							} 
						}
						else
						{
							LOGGER.error("PAPERWISE Data Upload Not Completed As response does not contain successfull status");
							return UPLOAD_FAILED;
						}
					} 
					else 
					{
						LOGGER.error("PAPERWISE Data Upload Not Completed As json response is null");
						return UPLOAD_FAILED;
					}
				} 
				else 
				{
					LOGGER.error("PAPERWISE Data Upload Not Completed As upload view model is null ");
					return UPLOAD_FAILED;
				}
				//reset all variables
				jsonResonse = "";
				candidateExamItemAnswerViewModel = null;
				uploadedCandidateExamData = null;
				successStatus = false;
			}
			if(i==0)
				return NO_DATA_to_UPLOAD;
		} 
		catch (Exception e) 
		{
			LOGGER.error("Exception Occured while Sending request to ESB-startUploadData: ", e);
			return UPLOAD_FAILED;
		}
		finally
		{
			LOGGER.info("Paperewise Data Upload finished");
		}
		return UPLOAD_SUCCESS;
	}
}
