package mkcl.oesclient.admin.controllers;
//Modified by Reena for setting based client 03-dec2013
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import mkcl.baseoesclient.model.AdminDisplayCategoryCollectionAssociation;
import mkcl.oesclient.admin.services.AdminDisplayCategoryCollectionAssociationServImpl;
import mkcl.oesclient.admin.services.CollectionMasterServicesImpl;
import mkcl.oesclient.admin.services.ExamScheduleServiceImpl;
import mkcl.oesclient.admin.services.UserServicesImpl;
import mkcl.oesclient.commons.services.DisplayCategoryLanguageServImpl;
import mkcl.oesclient.commons.services.ExamEventServiceImpl;
import mkcl.oesclient.commons.utilities.Constants;
import mkcl.oesclient.commons.utilities.FileUploadHelper;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.commons.utilities.MessageConstants;
import mkcl.oesclient.commons.utilities.Pagination;
import mkcl.oesclient.commons.validators.UserValidator;
import mkcl.oesclient.model.CandidateExam;
import mkcl.oesclient.model.CollectionMaster;
import mkcl.oesclient.model.VenueUser;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.oesclient.viewmodel.ViewModelAdminDisplayCategoryUser;
import mkcl.oespcs.model.DisplayCategoryLanguage;
import mkcl.oespcs.model.ExamEvent;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

@Controller
@RequestMapping("DisplayCategoryAdmin")
public class DisplayCategoryAdminController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(DisplayCategoryAdminController.class);
	private CollectionMasterServicesImpl collectionMasterServImpl = new CollectionMasterServicesImpl();
	private DisplayCategoryLanguageServImpl displayCategoryLangServiceImpl = new DisplayCategoryLanguageServImpl();
	private UserServicesImpl userServImpl = new UserServicesImpl();
	private AdminDisplayCategoryCollectionAssociationServImpl adminDisplayCategoryAssServImpl = new AdminDisplayCategoryCollectionAssociationServImpl();
	private ExamEventServiceImpl examEventServeImpl = new ExamEventServiceImpl();
	private ExamScheduleServiceImpl examScheduleServerImplObj = new ExamScheduleServiceImpl();
	private UserValidator userValidator = new UserValidator();
	private static final String ERRORPAGE = Constants.ERRORPAGE;
	private static final String EXCEPTIONSTRING = Constants.EXCEPTIONSTRING;
	private static final String SUBADMINUPDATEUSER = "Admin/DisplayCategoryAdmin/updateUser";
	private static final String SUBADMINADDUSER = "Admin/DisplayCategoryAdmin/addUser";
	private static final String USER="user";
	private static final String USERPHOTOUPLOADPATH = "UserPhotoUploadPath";
	private static final String RELATIVEFOLDERPATH = "relativeFolderPath";
	
	/**
	 * Get method to Create Display Category Admin
	 * @param model
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/createDisplayCategoryAdmin" }, method = RequestMethod.GET)
	public String createSubAdmin(Model model) {
		try {
	
			VenueUser user = new VenueUser();
			model.addAttribute(USER, user);
		} catch (Exception ex) {
			LOGGER.error("Exception occured in createSubAdmin: " , ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		return "Admin/DisplayCategoryAdmin/addUser";
	}

	/**
	 * Post method to Save Display Category Admin
	 * @param model
	 * @param user
	 * @param request
	 * @param errors
	 * @param locale
	 * @param fileData
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/add" }, method = RequestMethod.POST)
	public String saveDisplayCategoryAdmin(Model model,
			@ModelAttribute(value = USER) VenueUser user,
			HttpServletRequest request, BindingResult errors, Locale locale,
			@RequestParam("file") MultipartFile fileData) {
		long userID = 0;
		try {
			if (user != null) {
				userValidator.validate(user, errors);
				if (errors.hasErrors()) {
					model.addAttribute(USER, user);
					return SUBADMINADDUSER;
				}
				/** Check if user already exist **/
				VenueUser dbUser = userServImpl.getUserOneByUserName(user
						.getUserName());

				if (dbUser != null) {
					MKCLUtility.addMessage(MessageConstants.USER_ALREADY_EXIST,
							model, locale);
					model.addAttribute(USER, user);
					return SUBADMINADDUSER;
				}
				
				if (!fileData.isEmpty()) {
					String serverFolderPath = FileUploadHelper
							.getPhysicalFolderPathWithinWebApp(request,
									USERPHOTOUPLOADPATH);
					user.setUserPhoto(FileUploadHelper.uploadFileService(
							serverFolderPath, fileData));
				}
				VenueUser loggedUser = SessionHelper.getLogedInUser(request);
				user.setFkExamVenueID(loggedUser.getFkExamVenueID());
				user.setCreatedBy(loggedUser.getUserName());
				user.setDateCreated(new Date());
				VenueUser savedUser = userServImpl.saveUser(user);
				userID = savedUser.getUserID();
			}
		} catch (Exception ex) {
			LOGGER.error("Exception occured in saveDisplayCategoryAdmin: ", ex);
			model.addAttribute(USER, user);
			MKCLUtility.addMessage(MessageConstants.FAILED_TO_ADD, model,
					locale);
			return SUBADMINADDUSER;
		}

		return "redirect:addUserWithSubDiv?userID=" + userID;

	}

	/**
	 * Get method for Users List
	 * @param model
	 * @param request
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/userslist" }, method = RequestMethod.GET)
	public String listGet(Model model, HttpServletRequest request, Locale locale) {
		LoggerFactory.getLogger(DisplayCategoryAdminController.class).debug(
				"Method Started");

		try {

			/** Add message into model. */
			String messageId = request.getParameter("messageid");
			if (messageId != null && !(messageId.equals(""))) {
				MKCLUtility.addMessage(Integer.parseInt(messageId), model,
						locale);
			}

			/** 2 Get searchText. */
			String searchText = request.getParameter("searchText");
			Pagination pagination = new Pagination();
			pagination.setListName("UserList");

			/** 3 Get Object list. */
			if (searchText != null && !(searchText.equals(""))) {
				pagination.setPropertyName("firstName");
				userServImpl.pagination(null, pagination, searchText, model);
			} else {
				userServImpl.pagination(null, pagination, searchText, model);
			}
			return "Admin/DisplayCategoryAdmin/usersList";
		} catch (Exception ex) {
			LOGGER.error("Exception occured in -listGet: " , ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
	}

	/**
	 * Post method for User List Pagination - Next
	 * @param model
	 * @param pagination
	 * @param searchText
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/next" }, method = RequestMethod.POST)
	public String nextGet(Model model,
			@ModelAttribute("pagination") Pagination pagination,
			String searchText, HttpServletRequest request) {
		pagination.setListName("UserList");
		try {
			if (searchText != null && !(searchText.equals(""))) {
				pagination.setPropertyName("firstName");
				userServImpl
						.paginationNext(null, pagination, searchText, model);
			} else {
				userServImpl
						.paginationNext(null, pagination, searchText, model);
			}
		}  catch (Exception ex) {
			LOGGER.error("Exception occured in -nextGet: ", ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		return "Admin/DisplayCategoryAdmin/usersList";
	}

	/**
	 * Post method for Users List Pagination - Previous
	 * @param model
	 * @param pagination
	 * @param searchText
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/prev" }, method = RequestMethod.POST)
	public String prevGet(Model model,
			@ModelAttribute("pagination") Pagination pagination,
			String searchText, HttpServletRequest request) {
		pagination.setListName("UserList");
		try {
			if (searchText != null && !(searchText.equals(""))) {
				pagination.setPropertyName("firstName");
				userServImpl
						.paginationPrev(null, pagination, searchText, model);
			} else {
				userServImpl
						.paginationPrev(null, pagination, searchText, model);
			}
		}  catch (Exception ex) {
			LOGGER.error("Exception occured in -prevGet: " , ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		return "Admin/DisplayCategoryAdmin/usersList";
	}

	/**
	 * Get method to Update User
	 * @param model
	 * @param userID
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/update" }, method = RequestMethod.GET)
	public String updateGet(Model model, long userID, HttpServletRequest request) {
		try {

			VenueUser user = userServImpl.getUserOneByUserID(userID);
			String relativeFolderPath = FileUploadHelper.getRelativeFolderPath(
					request, USERPHOTOUPLOADPATH);
			relativeFolderPath = relativeFolderPath + user.getUserPhoto();

			model.addAttribute(RELATIVEFOLDERPATH, relativeFolderPath);
			model.addAttribute(USER, user);

		} catch (Exception ex) {
			LOGGER.error("Exception occured in updateGet: " , ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}

		return "Admin/DisplayCategoryAdmin/updateUser";
	}

	/**
	 * Post method to Update User
	 * @param model
	 * @param user
	 * @param request
	 * @param errors
	 * @param locale
	 * @param fileData
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/update" }, method = RequestMethod.POST)
	public String updatePost(Model model,
			@ModelAttribute(value = USER) VenueUser user,
			HttpServletRequest request, BindingResult errors, Locale locale,
			@RequestParam("file") MultipartFile fileData) {

		try {
			if (user != null) {

				userValidator.validateForUpdate(user, errors);
				if (errors.hasErrors()) {
					
					String relativeFolderPath = FileUploadHelper
							.getRelativeFolderPath(request,
									USERPHOTOUPLOADPATH);
					relativeFolderPath = relativeFolderPath
							+ user.getUserPhoto();

					model.addAttribute(RELATIVEFOLDERPATH, relativeFolderPath);
					model.addAttribute(USER, user);
					return SUBADMINUPDATEUSER;
				}
				/** Check if user already exist **/
				VenueUser dbUser = userServImpl
						.getUserOneByUserNameExceptByCurrentUserId(
								user.getUserID(), user.getUserName());

				if (dbUser != null) {
					MKCLUtility.addMessage(MessageConstants.USER_ALREADY_EXIST,
							model, locale);
					String relativeFolderPath = FileUploadHelper
							.getRelativeFolderPath(request,
									USERPHOTOUPLOADPATH);
					relativeFolderPath = relativeFolderPath
							+ user.getUserPhoto();

					model.addAttribute(RELATIVEFOLDERPATH, relativeFolderPath);
					model.addAttribute(USER, user);
					return SUBADMINUPDATEUSER;
				}
				if (!fileData.isEmpty() && user.getUserPhoto() != null
						&& !user.getUserPhoto().isEmpty()) {
					String serverFolderPath = FileUploadHelper
							.getPhysicalFolderPathWithinWebApp(request,
									USERPHOTOUPLOADPATH);
					FileUploadHelper.overrideAndUploadFile(serverFolderPath,
							fileData, user.getUserPhoto());

				} else if (!fileData.isEmpty()) {
					String serverFolderPath = FileUploadHelper
							.getPhysicalFolderPathWithinWebApp(request,
									USERPHOTOUPLOADPATH);
					user.setUserPhoto(FileUploadHelper.uploadFileService(
							serverFolderPath, fileData));
				}
				VenueUser loggedUser = SessionHelper.getLogedInUser(request);
				user.setFkExamVenueID(loggedUser.getFkExamVenueID());
				user.setModifiedBy(loggedUser.getUserName());
				user.setDateModified(new Date());
				userServImpl.updateUser(user);

			}
		} catch (Exception ex) {
			LOGGER.error("Exception occured in updatePost: " , ex);
			model.addAttribute(USER, user);
			MKCLUtility.addMessage(MessageConstants.FAILED_TO_UPDATE, model,
					locale);
			return SUBADMINUPDATEUSER;
		}
		return "redirect:userslist?messageid=2";
	}

	/**
	 * Get method for Cancel
	 * @param model
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/cancel" }, method = RequestMethod.GET)
	public String cancelGet(Model model) {
		try {
			return "redirect:userslist";
		} catch (Exception ex) {
			LOGGER.error("Exception occured in cancelGet: " , ex);
			model.addAttribute(EXCEPTIONSTRING, ex);
			return ERRORPAGE;
		}
	}

	/**
	 * Get method to Add User with Sub-division
	 * @param model
	 * @param userID
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/addUserWithSubDiv" }, method = RequestMethod.GET)
	public String addUserWithSubDiv(Model model, long userID,
			HttpServletRequest request) {
		try {

			VenueUser user = userServImpl.getUserOneByUserID(userID);

			List<ExamEvent> listExamEvent = examEventServeImpl
					.getExamEventList();

			model.addAttribute(USER, user);
			model.addAttribute("listExamEvent", listExamEvent);
			return "Admin/DisplayCategoryAdmin/addDisplayCategoryAdmin";
		} catch (Exception ex) {
			LOGGER.error("Exception occured in addUserWithSubDiv: " , ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}

	}

	/**
	 * Get method for Proceed for Sub-division
	 * @param request
	 * @param model
	 * @param uid
	 * @param eventID
	 * @param messageid
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/proceed" }, method = RequestMethod.GET)
	public String showTableSubDiv(HttpServletRequest request, Model model,
			Long uid, Long eventID, Integer messageid, Locale locale) {

		try {
			List<CollectionMaster> listCollectionMaster = null;
			Long userID = 0l;
			/*Long eventID = 0l;*/
			if (request.getParameter("userID") != null){	
				userID = Long.parseLong(request.getParameter("userID"));
			}
			else{
				userID = uid;
			}
			VenueUser user = userServImpl.getUserOneByUserID(userID);
			if(request.getParameter("eventID") != null){
			listCollectionMaster = collectionMasterServImpl.getListCollectionMasterAssociatedWithCandidates(Long.parseLong(request.getParameter("eventID")));
			}
			List<DisplayCategoryLanguage> listDisplayCategoryLang = new ArrayList<DisplayCategoryLanguage>();

			if (request.getParameter("eventID") != null){
				eventID = Long.parseLong(request.getParameter("eventID"));
			}
/*			else {
				eventID = eveid;
			}*/
			ExamEvent examEvent = examEventServeImpl.getExamEventByID(eventID);
			String examEventCollectionType = examEvent.getCollectionType().toString();
			String languageID = examEvent.getDefaultLanguageID();
			String examEventcode = examEvent.getExamEventCode();
			listDisplayCategoryLang = displayCategoryLangServiceImpl
					.getDisplayCategoryLanguageByClientIDDisplayCategoryIDNaturalLanguageID(languageID,eventID);

			ViewModelAdminDisplayCategoryUser viewModel = new ViewModelAdminDisplayCategoryUser();
			List<AdminDisplayCategoryCollectionAssociation> listAdminDispalyCategoryAssociation = null;
			listAdminDispalyCategoryAssociation = adminDisplayCategoryAssServImpl
					.getListDisplayCategoryAdminByUserIDExamEventID(userID, eventID);
			if (listAdminDispalyCategoryAssociation == null
					|| listAdminDispalyCategoryAssociation.size() == 0) {
				listAdminDispalyCategoryAssociation = new ArrayList<AdminDisplayCategoryCollectionAssociation>();
			}
			viewModel.setListAdminSubDivAssociation(listAdminDispalyCategoryAssociation);
			viewModel.setUser(user);
			List<ExamEvent> listExamEvent = examScheduleServerImplObj
					.getActiveExamEventList(SessionHelper.getLogedInUser(request));

			/** Combined list subject & division **/
			if ((messageid != null) && (messageid == 1 || messageid == 2)) {
				MKCLUtility.addMessage(messageid, model, locale);
			}
			model.addAttribute("examEventCollectionType", examEventCollectionType);
			model.addAttribute("viewModel", viewModel);
			model.addAttribute("listDisplayCategoryLang", listDisplayCategoryLang);
			model.addAttribute(USER, user);
			model.addAttribute("listCollectionMaster", listCollectionMaster);
			model.addAttribute("eventid", examEvent.getExamEventID());
			model.addAttribute("listExamEvent", listExamEvent);
			model.addAttribute("examEventcode", examEventcode);
			return "Admin/DisplayCategoryAdmin/addDisplayCategoryAdmin";
		} catch (Exception ex) {
			LOGGER.error("Exception occured in showTableSubDiv: " , ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
	}

	/**
	 * Post method to Save or Update the Display Category Admin
	 * @param viewModelSubDivAss
	 * @param model
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/saveUpdateDisplayCategoryAdmin" }, method = RequestMethod.POST)
	public String saveDisplayCategoryAdmin(
			@ModelAttribute(value = "viewModel") ViewModelAdminDisplayCategoryUser viewModelSubDivAss,
			Model model, HttpServletRequest request) {
		int msgID = 0;
		long userid = 0;
		long exameventid = 0;
		try {
			exameventid = Long.parseLong(request.getParameter("exameventid"));
			userid = Long.parseLong(request.getParameter("userid"));
			List<AdminDisplayCategoryCollectionAssociation> list = viewModelSubDivAss
					.getListAdminSubDivAssociation();
			List<AdminDisplayCategoryCollectionAssociation> listExistingSubAdmins = adminDisplayCategoryAssServImpl
					.getListDisplayCategoryAdminByUserIDExamEventID(userid, exameventid);
			if (listExistingSubAdmins == null
					|| listExistingSubAdmins.size() == 0) {
				msgID = 1;
				for (AdminDisplayCategoryCollectionAssociation adminSubjectDivisionAssociation : list) {
					if (adminSubjectDivisionAssociation.getFkDisplayCategoryID() != null
							&& adminSubjectDivisionAssociation.getFkDisplayCategoryID() > 0) {

						adminDisplayCategoryAssServImpl
								.saveAdminDisplayCategoryAssociation(adminSubjectDivisionAssociation);
					}
				}
			} else {
				msgID = 2;
				adminDisplayCategoryAssServImpl
						.deleteAdminSubjectDisplayCategoryAssociationByUserIDExamEventID(
								userid, exameventid);
				for (AdminDisplayCategoryCollectionAssociation adminSubjectDivisionAssociation : list) {
					if (adminSubjectDivisionAssociation.getFkDisplayCategoryID() != null
							&& adminSubjectDivisionAssociation.getFkDisplayCategoryID() > 0) {

						adminDisplayCategoryAssServImpl
								.saveAdminDisplayCategoryAssociation(adminSubjectDivisionAssociation);
					}
				}
			}

		} catch (Exception ex) {
			LOGGER.error("Exception occured in saveDisplayCategoryAdmin: ", ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		return "redirect:proceed?uid=" + userid + "&eveid=" + exameventid +"&eventID="+exameventid
				+ "&messageid=" + msgID;
	}

	/**
	 * Get method to Change Permission
	 * @param model
	 * @param userID
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/changePermission" }, method = RequestMethod.GET)
	public String changePermission(Model model, long userID,
			HttpServletRequest request) {
		try {

			VenueUser user = userServImpl.getUserOneByUserID(userID);
			String relativeFolderPath = FileUploadHelper.getRelativeFolderPath(
					request, USERPHOTOUPLOADPATH);
			relativeFolderPath = relativeFolderPath + user.getUserPhoto();
			List<ExamEvent> listExamEvent = examScheduleServerImplObj
					.getActiveExamEventList(SessionHelper.getLogedInUser(request));
			model.addAttribute(RELATIVEFOLDERPATH, relativeFolderPath);
			model.addAttribute(USER, user);
			model.addAttribute("listExamEvent", listExamEvent);

		} catch (Exception ex) {
			LOGGER.error("Exception occured in changePermission: " , ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		return "Admin/DisplayCategoryAdmin/addDisplayCategoryAdmin";

	}

}
