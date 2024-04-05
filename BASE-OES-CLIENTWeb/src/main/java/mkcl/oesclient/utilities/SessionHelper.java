package mkcl.oesclient.utilities;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Queue;
import java.util.concurrent.ConcurrentHashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import mkcl.baseoesclient.model.LoginType;
import mkcl.oesclient.commons.utilities.OESException;
import mkcl.oesclient.commons.utilities.SessionObject;
import mkcl.oesclient.model.Candidate;
import mkcl.oesclient.model.CandidateAcademics;
import mkcl.oesclient.model.GroupMaster;
import mkcl.oesclient.model.VenueUser;
import mkcl.oesclient.security.CSRFResponseBuilder;
import mkcl.oesclient.viewmodel.ExamPaperSetting;
import mkcl.oespcs.model.ExamEvent;

import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang.SerializationUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;

public final class SessionHelper {
	private static final Logger LOGGER = LoggerFactory.getLogger(SessionHelper.class);
	private static final String USERSTRING = "user";
	private static final String EXAMPAPERSETTING = "exampapersetting";
	private static final String LOGINSTATUS="loginStatus";
	private static final String CANDIDATEQUEUE="candidatequeue";
	private static final String EVENTGROUPENABLE="eventgroupenable";
	private static final String SITEMESHMODULENAME="module";
	private static final String ISLOCALCANDIDATE="isLocalCandidate";
	private static final String USERAGENT = "userAgent";
	private static final Map<String,String> loginMap=new ConcurrentHashMap<String, String>();

	private SessionHelper() {
		
	}
	/**
	 * This method is used for group, solo and eSchool login.
	 * While Solo login academics and groupMaster is NULL.
	 * While Group login academics is NULL
	 * While eSchool login examEvent,collectionID,groupMaster is NULL
	 * @throws Exception 
	 *
	 */
	public static HttpSession SetSession(ExamEvent examEvent,LoginType loginType,List<VenueUser> venueUser,GroupMaster groupMaster,long collectionID, CandidateAcademics academics ,HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		HttpSession session = request.getSession(false);
		if(session != null)
		{
			session.invalidate();
		}		
		session = request.getSession(true);
		
		SessionObject sessionObject = new SessionObject(examEvent, loginType,venueUser,groupMaster,collectionID,academics);
		session.setAttribute(USERSTRING, sessionObject);
		session.setAttribute(LOGINSTATUS, "1");
		if(request.getHeader("User-Agent") != null)
			session.setAttribute(USERAGENT, DigestUtils.md5Hex(request.getHeader("User-Agent")));
		if(sessionObject != null && sessionObject.getLoginType() != null && sessionObject.getLoginType().equals(LoginType.Solo) && venueUser != null && venueUser.get(0) != null)
			session.setAttribute("Login", venueUser.get(0).getUserName());	
		if( loginType != null && loginType.equals(LoginType.Admin))
			session.setMaxInactiveInterval(300);
		
		CSRFResponseBuilder.createCSRFCookie(request, response);
		
		for (VenueUser vu : venueUser) 
		{
			setLoginMap(vu.getUserName(), session.getId(),request);
		}
		
		return session;
	}
	
	/**
	 * <b> This method should only used for OES partners login session. eg. ERA through gateway. This will set isThirdPartySession value to true. </b>
	 * While Solo login academics and groupMaster is NULL.
	 * While Group login academics is NULL
	 * While eSchool login examEvent,collectionID,groupMaster is NULL
	 * @throws Exception 
	 *
	 */
	public static HttpSession SetSession(ExamEvent examEvent,LoginType loginType,List<VenueUser> venueUser,GroupMaster groupMaster,long collectionID,Object object,HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		HttpSession session = request.getSession(false);
		if(session != null)
		{
			session.invalidate();
		}
		session = request.getSession(true);
		
		SessionObject sessionObject = new SessionObject(examEvent, loginType,venueUser,groupMaster,collectionID,object);
		session.setAttribute(USERSTRING, sessionObject);
		session.setAttribute(LOGINSTATUS, "1");	
		if(request.getHeader("User-Agent") != null)
			session.setAttribute(USERAGENT, DigestUtils.md5Hex(request.getHeader("User-Agent")));
		if(sessionObject != null && sessionObject.getLoginType() != null && sessionObject.getLoginType().equals(LoginType.Solo) && venueUser != null && venueUser.get(0) != null)
			session.setAttribute("Login", venueUser.get(0).getUserName());
		
		CSRFResponseBuilder.createCSRFCookie(request, response);
		
		for (VenueUser vu : venueUser) 
		{
			setLoginMap(vu.getUserName(), session.getId(),request);
		}
		
		return session;
	}
	
	public static void SetSiteMeshModule(HttpSession session, String moduleName)
	{
		session.setAttribute(SITEMESHMODULENAME, moduleName);			
	}
	
	public static String getSiteMeshModule(HttpSession session)
	{
		return (String) session.getAttribute(SITEMESHMODULENAME);			
	}
	
	public static String getUserAgentFromSession(HttpSession session)
	{
		return (String) session.getAttribute(USERAGENT);			
	}
	
	public static void setIsLocalCandidate(HttpSession session)
	{
		session.setAttribute(ISLOCALCANDIDATE,true);			
	}
	
	public static boolean getIsLocalCandidate()
	{
		try {
			return RequestContextHolder.currentRequestAttributes()
					.getAttribute(ISLOCALCANDIDATE,
							RequestAttributes.SCOPE_SESSION) == null ? false
					: true;
		} catch (IllegalStateException e) {
			return false;
		}		
	}
	
	public static void removeSession(HttpSession session)
	{		
		session.removeAttribute(USERSTRING);
		session.removeAttribute(EXAMPAPERSETTING);
		session.removeAttribute(LOGINSTATUS);
		session.removeAttribute(CANDIDATEQUEUE);
		session.removeAttribute(EVENTGROUPENABLE);
		session.removeAttribute(ISLOCALCANDIDATE);
		session.removeAttribute("Login");
		session.removeAttribute(mkcl.oesclient.solo.controllers.ExamController.CESessionVeriable);
		session.invalidate();
		//session.removeAttribute(SITEMESHMODULENAME);
	}
	
	public static void removeExamSetting(HttpSession session)
	{				
		session.removeAttribute(EXAMPAPERSETTING);
		session.removeAttribute(CANDIDATEQUEUE);
		session.setMaxInactiveInterval(900);
	}
	
	public static boolean setExamPaperSetting(HttpSession session,ExamPaperSetting examPaperSetting) throws OESException
	{
		try {
			if (examPaperSetting != null) {
				session.setAttribute(EXAMPAPERSETTING, examPaperSetting);
				session.setMaxInactiveInterval(3600);
				return true;
			} 
		} catch (Exception e) {
			//LOGGER.error("Exception Occured while ExamPaperSetting: " ,e);		
			throw new OESException("Exception Occured while Exam Paper Setting",e);
		}
		return false;
	}
	
	public static ExamPaperSetting getExamPaperSetting(HttpServletRequest request) throws OESException
	{
		HttpSession session = null;		
		try {
			session = request.getSession(false);
			if (session != null && session.getAttribute(EXAMPAPERSETTING) != null) {
				ExamPaperSetting examPaperSetting = (ExamPaperSetting) session.getAttribute(EXAMPAPERSETTING);
				if(examPaperSetting!=null)
				{
					return examPaperSetting;
				}else{
					throw new OESException("Exam paper setting session not found.");
				}
			}

		} catch (Exception e) {
			//LOGGER.error("Exception Occured while ExamPaperSetting: " ,e);		
			throw new OESException("Exception Occured while Exam Paper Setting",e);
		}
		return null;
	}
	
	public static long getCollectionID(HttpServletRequest request) {
		HttpSession session = null;		
		try {
			session = request.getSession(false);
			if (session != null && session.getAttribute(USERSTRING) != null) {
				SessionObject sessionObject = (SessionObject) session.getAttribute(USERSTRING);
				return sessionObject.getCollectionID();				
			}

		} catch (Exception e) {
			LOGGER.error("Exception Occured while fetching LoginStatus: " ,e);			
		}
		return 0;
	}
	
	public static boolean getLoginStatus(HttpServletRequest request) {
		HttpSession session = null;		
		try {
			session = request.getSession(false);
			if (session != null && session.getAttribute(LOGINSTATUS) != null) {
				String status = (String) session.getAttribute(LOGINSTATUS);
				if(status.equals("1"))
				{
					return true;
				}
			}

		} catch (Exception e) {
			LOGGER.error("Exception Occured while fetching LoginStatus: " ,e);			
		}
		return false;
	}
	
	public static Candidate getCandidate(HttpServletRequest request) {
		HttpSession session = null;
		Candidate candidate=null;
		try {
			session = request.getSession(false);
			if (session != null && session.getAttribute(USERSTRING) != null) {
				SessionObject sessionObject = (SessionObject) session.getAttribute(USERSTRING);
				if(sessionObject.getLoginType().equals(LoginType.Solo) &&  getLogedInUser(request) != null)
				{
					VenueUser user =  getLogedInUser(request);
					candidate = new Candidate();
					
					candidate.setCandidateID(user.getUserID());
					//user.setFkExamVenueID(rs.getLong("CCA.FKEXAMVENUEID"));					
					candidate.setCandidateUserName(user.getUserName());
					candidate.setCandidatePassword(user.getPassword());
					candidate.setCandidateFirstName(user.getFirstName());
					candidate.setCandidateMiddleName(user.getMiddleName());
					candidate.setCandidateLastName(user.getLastName());
					candidate.setCandidateCode(user.getMkclIdentificationNumber());
					candidate.setCandidateEmail(user.getEmail());
					candidate.setCandidatePhoto(user.getUserPhoto());
					candidate.setCandidateMobile(user.getMobileNumber());
					candidate.setLastSuccessfullLogin(user.getLastSuccessfullLogin());
					candidate.setIsDeleted(user.getIsDeleted());
					//candidate user.setObject(rs.getObject("CCA.FKCOLLECTIONID"));
				}
			}

		} catch (Exception e) {
			LOGGER.error("Exception Occured while fetching getCandidate: " ,e);		
			candidate=null;
		}
		return candidate;
	}
	
	public static List<Candidate> getCandidates(HttpServletRequest request) {
		HttpSession session = null;
		List<Candidate> candidates=null;
		try {
			session = request.getSession(false);
			if (session != null && session.getAttribute(USERSTRING) != null) {
				SessionObject sessionObject = (SessionObject) session.getAttribute(USERSTRING);
				if(sessionObject.getLoginType().equals(LoginType.Group))
				{
					candidates = new ArrayList<Candidate>();
					Candidate candidate=null;
					for (VenueUser venueUser : getLogedInUsers(request)) {
						candidate = new Candidate();
						candidate.setCandidateID(Long.parseLong(venueUser.getObject().toString()));
						candidates.add(candidate);
						candidate=null;
					}
					return candidates;
				}
			}

		} catch (Exception e) {
			LOGGER.error("Exception Occured while fetching getCandidates: " ,e);			
		}
		return null;
	}
	
	public static LoginType getLoginType(HttpServletRequest request) {
		HttpSession session = null;
		LoginType loginType = null;
		try {
			session = request.getSession(false);
			if (session != null && session.getAttribute(USERSTRING) != null) {
				SessionObject sessionObject = (SessionObject) session.getAttribute(USERSTRING);
				loginType = sessionObject.getLoginType();
			}

		} catch (Exception e) {
			LOGGER.error("Exception Occured while fetching Users: " ,e);			
		}
		return loginType;
	}
	
	public static List<VenueUser> getLogedInUsers(HttpServletRequest request) {
		HttpSession session = null;
		List<VenueUser> user = null;
		try {
			session = request.getSession(false);
			if (session != null && session.getAttribute(USERSTRING) != null) {
				SessionObject sessionObject = (SessionObject) session.getAttribute(USERSTRING);
				user = sessionObject.getVenueUser();
			}

		} catch (Exception e) {
			LOGGER.error("Exception Occured while fetching Users: " ,e);			
		}
		return user;
	}
	
	public static VenueUser getLogedInUser(HttpServletRequest request) {
		HttpSession session = null;
		VenueUser user = null;
		try {
			session = request.getSession(false);
			if (session != null && session.getAttribute(USERSTRING) != null) {
				SessionObject sessionObject = (SessionObject) session.getAttribute(USERSTRING);
				if(!sessionObject.getLoginType().equals(LoginType.Group))
				{
				user = sessionObject.getVenueUser().get(0);
				}
			}

		} catch (Exception e) {
			LOGGER.error("Exception Occured while fetching Users: " ,e);			
		}
		return user;
	}

	public static ExamEvent getExamEvent(HttpServletRequest request) {
		HttpSession session = null;
		ExamEvent examEvent = null;
		try {
			session = request.getSession(false);
			if (session != null && session.getAttribute(USERSTRING) != null) {
				SessionObject sessionObject = (SessionObject) session.getAttribute(USERSTRING);
				examEvent = sessionObject.getExamEvent();				
			}
		} catch (Exception e) {
			LOGGER.error("Exception Occured while fetching ExamEvent: ", e);
		}
		return examEvent;
	}
	
	public static GroupMaster getGroupMaster(HttpServletRequest request) {
		HttpSession session = null;
		GroupMaster groupMaster = null;
		try {
			session = request.getSession(false);
			if (session != null && session.getAttribute(USERSTRING) != null) {
				SessionObject sessionObject = (SessionObject) session.getAttribute(USERSTRING);
				groupMaster = sessionObject.getGroupMaster();		
			}
		} catch (Exception e) {
			LOGGER.error("Exception Occured while fetching group: ", e);
		}
		return groupMaster;
	}
	
	
	/**
	 * harshadd start
	 */
	
	public static boolean setCandidateQueue(HttpSession session,Queue<Entry<Long, Long>> candidateQueue)
	{
		try {
			if (candidateQueue != null) {
				session.setAttribute(CANDIDATEQUEUE, candidateQueue);
				return true;
			} 			
			
		} catch (Exception e) {
			LOGGER.error("Exception Occured while Creating session for Candidate Queue: " ,e);	
		}
		return false;
	}
	
	public static Queue<Entry<Long, Long>> getCandidateQueue(HttpServletRequest request)
	{
		HttpSession session = null;		
		try {
			session = request.getSession(false);
			if (session != null && session.getAttribute(CANDIDATEQUEUE) != null) {
				Queue<Entry<Long, Long>> candidateQueue = (Queue<Entry<Long, Long>>) session.getAttribute(CANDIDATEQUEUE);
				if(candidateQueue!=null)
				{
					return candidateQueue;
				}
			}

		} catch (Exception e) {
			LOGGER.error("Exception Occured while geting Candidate Queue from Session: " ,e);			
		}
		return null;
	}
	
	public static boolean setExamEventIsGroupEnabled(HttpSession session,boolean isGroupEnabled)
	{
		try {
				session.setAttribute(EVENTGROUPENABLE, isGroupEnabled);
				return true;
		} catch (Exception e) {
			LOGGER.error("Exception Occured while Creating session for setExamEventIsGroupEnabled: " ,e);	
		}
		return false;
	}
	
	public static boolean getExamEventIsGroupEnabled(HttpServletRequest request)
	{
		HttpSession session = null;		
		try {
			session = request.getSession(false);
			if (session != null && session.getAttribute(EVENTGROUPENABLE) != null) {
				boolean isGroupEnabled = (Boolean) session.getAttribute(EVENTGROUPENABLE);
				return isGroupEnabled;
			}

		} catch (Exception e) {
			LOGGER.error("Exception Occured while geting getExamEventIsGroupEnabled: " ,e);			
		}
		return false;
	}
	
	public static Map<String,String> getPartnerObject(HttpServletRequest request) {
		HttpSession session = null;
		Map<String,String> objectMap = null;
		try {
			session = request.getSession(false);
			if (session != null && session.getAttribute(USERSTRING) != null) {
				SessionObject sessionObject = (SessionObject) session.getAttribute(USERSTRING);
				objectMap = (Map<String, String>) sessionObject.getObject();		
			}
		} catch (Exception e) {
			LOGGER.error("Exception Occured while fetching getPartnerObject: ", e);
			objectMap = null;
		}
		return objectMap;
	}
	
	public static boolean getIsSessionThirdParty(HttpServletRequest request) {
		boolean status = false;
		HttpSession session = null;
		try {
			session = request.getSession(false);
			if (session != null && session.getAttribute(USERSTRING) != null) {
				SessionObject sessionObject = (SessionObject) session.getAttribute(USERSTRING);
				status = sessionObject.getIsThirdPartySession();		
			}
		} catch (Exception e) {
			LOGGER.error("Exception Occured while fetching getIsSessionThirdParty: ", e);
		}
		return status;
	}
	
	private static void setLoginMap(String key,String val, HttpServletRequest request) throws Exception {
		try
		{
			Object redisDataCache = request.getAttribute("redisDataCache");
			if(redisDataCache!=null)
			{
				Method setMethod = redisDataCache.getClass().getDeclaredMethod("set", String.class, byte[].class);
				Method expireMethod = redisDataCache.getClass().getDeclaredMethod("expire", String.class, int.class);
				
				//put userName-SessionId pair in redis DB
				//recommended to use hashcode of user name to reduce data transfer size
				setMethod.invoke(redisDataCache, String.valueOf(key.hashCode()), SerializationUtils.serialize(val));

				//set time-to-live for the key in redis DB
				expireMethod.invoke(redisDataCache, String.valueOf(key.hashCode()), 14400);
			}
			else
			{
				loginMap.put(String.valueOf(key.hashCode()), val);
			}
		} 
		catch (Exception e) 
		{
			throw e;
		}
	}
	
	public static String getLoginMapValue(String key, HttpServletRequest request) throws Exception{
		String val="";
		try
		{
			Object redisDataCache = request.getAttribute("redisDataCache");
			if(redisDataCache!=null)
			{
				Method getMethod = redisDataCache.getClass().getDeclaredMethod("get", String.class);
				
				//get SessionID by userName from redis DB
				byte[] bytArr = (byte[]) getMethod.invoke(redisDataCache, String.valueOf(key.hashCode()));

				//Deserialize and type cast to get session ID in string type
				val = (String) SerializationUtils.deserialize(bytArr);
			}
			else
			{
				val = loginMap.get(String.valueOf(key.hashCode()));
			}
		} 
		catch (Exception e) 
		{
			throw e;
		}
		return val;
	}
	
	 public static String removeLoginFromMap(String key, HttpServletRequest request) throws Exception{
		String val="";
		try
		{
			Object redisDataCache = request.getAttribute("redisDataCache");
			if(redisDataCache!=null)
			{
				 //Need to remove add code remove the candidate from redisDB.
			}
			else
			{
				val = loginMap.remove(String.valueOf(key.hashCode()));
			}
		} 
		catch (Exception e) 
		{
			throw e;
		}
		return val;
	}     
	
	
	public static CandidateAcademics getCandidateAcademics(HttpServletRequest request)
	{
		HttpSession session = null;
		CandidateAcademics academics=null;
		try {
			session = request.getSession(false);
			if (session != null && session.getAttribute(USERSTRING) != null) {
				SessionObject sessionObject = (SessionObject) session.getAttribute(USERSTRING);
				if(sessionObject.getLoginType().equals(LoginType.Solo))
				{
					academics = sessionObject.getCandidateAcademics();
				}
			}

		} catch (Exception e) {
			LOGGER.error("Exception Occured while fetching getCandidateAcademics: " ,e);			
		}
		return academics;
	}
	
	public static void addVariable(String name, Object value, HttpSession session)
	{
		session.setAttribute(name, value);
	}
	
	public static Object getVariable(String name, HttpServletRequest request)
	{
		HttpSession session = request.getSession(false);
		if(session != null)
			return session.getAttribute(name);
		else
			return null;
	}
	
	public static void removeVariable(String name, HttpServletRequest request)
	{
		HttpSession session = request.getSession(false);
		if(session != null)
			session.removeAttribute(name);
	}
}
