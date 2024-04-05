package mkcl.oesclient.admin.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @author MKCL Scaffolding
 * 
 */
@Controller
@RequestMapping("DivisionMaster")
public class CollectionMasterController {/*
	private static final Logger LOGGER = LoggerFactory.getLogger(DivisionMasterController.class);
	private static DivisionMasterServicesImpl divisionmasterObjService = new DivisionMasterServicesImpl();
	private static final String DIVISIONMASTER = "divisionmasterObj";
	private static final String DIVISIONMASTERADDVIEW = "Admin/DivisionMaster/DivisionMasteradd";
	private static final String EARLIERDIVISIONNAME = "earlierDivisionName";
	private DivisionMasterValidator divisionMasterValidator = new DivisionMasterValidator();

	/* 
	 * @param model
	 * @param request
	 * @return
	 *//*

	@RequestMapping(value = { "/DivisionMasterlist", "cancel" }, method = RequestMethod.GET)
	public String listGet(
			Model model,
			HttpServletRequest request,
			Locale locale,
			@RequestParam(value = "messageid", required = false) String messageid) {

		try {
			if (messageid != null && !messageid.isEmpty()) {
				MKCLUtility.addMessage(Integer.parseInt(messageid), model,
						locale);
			}

			// 2 Get searchText.
			String searchText = request.getParameter("searchText");
			Pagination pagination = new Pagination();
			pagination.setListName("DivisionMasterList");

			// 3 Get Object list.
			if (searchText != null && !(searchText.equals(""))) {
				pagination.setPropertyName("division");
				divisionmasterObjService.pagination(null, pagination,
						searchText, model);
			} else {
				divisionmasterObjService.pagination(null, pagination,
						searchText, model);
			}


		} catch (Exception ex) {
			LOGGER.error("Exception occured in listGet: " , ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;

		}
		return "Admin/DivisionMaster/DivisionMasterlist";
	}

	/*
	 * @param model
	 * @return
	 *//*
	@RequestMapping(value = { "/DivisionMasteradd" }, method = RequestMethod.GET)
	public String addGet(Model model) {
		try {
			DivisionMaster divisionmasterObj = new DivisionMaster();
			model.addAttribute(DIVISIONMASTER, divisionmasterObj);
		} catch (Exception ex) {
			LOGGER.error("Exception occured in addGet: " , ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;

		}
		return DIVISIONMASTERADDVIEW;
	}

	/*
	 * @param model
	 * @param divisionmasterObj
	 * @return
	 * @throws ParseException
	 *//*
	@RequestMapping(value = { "/add" }, method = RequestMethod.POST)
	public String addPost(
			Model model,
			@ModelAttribute(value = DIVISIONMASTER) DivisionMaster divisionmasterObj,
			HttpServletRequest request, BindingResult errors, Locale locale) {

		boolean status = false;
		try {
			if (divisionmasterObj != null) {

				divisionMasterValidator.validate(divisionmasterObj, errors);
				if (errors.hasErrors()) {
					model.addAttribute(DIVISIONMASTER, divisionmasterObj);
					return DIVISIONMASTERADDVIEW;
				}

				status = divisionmasterObjService
						.checkIfObjectAlreadyExist(divisionmasterObj);

				if (status) {
					model.addAttribute(DIVISIONMASTER, divisionmasterObj);
					MKCLUtility.addMessage(Integer.parseInt("70"), model,
							locale);
					return DIVISIONMASTERADDVIEW;
				}

				divisionmasterObjService.addDivisionMaster(divisionmasterObj);

			}
		} catch (Exception ex) {
			LOGGER.error("Exception occured in addPost: " , ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;

		}
		return "redirect:DivisionMasterlist?messageid="
		+ MessageConstants.SUCCESSFULLY_ADDED_RECORD;
	}

	/*
	 * @param model
	 * @param id
	 * @return
	 *//*
	@RequestMapping(value = { "/update" }, method = RequestMethod.GET)
	public String updateGet(Model model, long divisionID) {
		try {
			DivisionMaster divisionmasterObj = divisionmasterObjService
					.getDivisionMasterOne(divisionID);
			model.addAttribute(DIVISIONMASTER, divisionmasterObj);
			model.addAttribute(EARLIERDIVISIONNAME,
					divisionmasterObj.getDivision());
		} catch (Exception ex) {
			LOGGER.error("Exception occured in updateGet: " , ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;

		}

		return "Admin/DivisionMaster/DivisionMasterupdate";
	}

	/*
	 * @param model
	 * @param divisionmasterObj
	 * @param request
	 * @return
	 * @throws ParseException
	 *//*
	@RequestMapping(value = { "/update" }, method = RequestMethod.POST)
	public String updatePost(
			Model model,
			@ModelAttribute(value = DIVISIONMASTER) DivisionMaster divisionmasterObj,
			@RequestParam(EARLIERDIVISIONNAME) String earlierDivisionName,
			HttpServletRequest request, BindingResult errors, Locale locale)
					throws ParseException {
		boolean status = false;
		if (divisionmasterObj != null) {
			try {

				divisionMasterValidator.validate(divisionmasterObj, errors);
				if (errors.hasErrors()) {
					model.addAttribute(DIVISIONMASTER, divisionmasterObj);
					model.addAttribute(EARLIERDIVISIONNAME,
							earlierDivisionName);
					return "Admin/DivisionMaster/DivisionMasterupdate";
				}

				if (!earlierDivisionName.trim().equalsIgnoreCase(
						divisionmasterObj.getDivision().trim())) {
					status = divisionmasterObjService
							.checkIfObjectAlreadyExist(divisionmasterObj);
				}
				if (status) {
					model.addAttribute(DIVISIONMASTER, divisionmasterObj);
					model.addAttribute(EARLIERDIVISIONNAME,
							earlierDivisionName);
					MKCLUtility.addMessage(Integer.parseInt("70"), model,
							locale);
					return "Admin/DivisionMaster/DivisionMasterupdate";
				}

				divisionmasterObjService
				.updateDivisionMaster(divisionmasterObj);

			} catch (Exception ex) {
				LOGGER.error("Exception occured in updatePost: " , ex);
				model.addAttribute(Constants.EXCEPTIONSTRING, ex);
				return Constants.ERRORPAGE;

			}
		}
		return "redirect:DivisionMasterlist?messageid="
		+ MessageConstants.SUCCESSFULLY_UPDATED_RECORD;

	}

	/*
	 * @param model
	 * @param id
	 * @return
	 *//*
	@RequestMapping(value = { "/delete" }, method = RequestMethod.GET)
	public String deleteGet(Model model, long divisionID) {
		try {
			DivisionMaster divisionmasterObj;
			divisionmasterObj = divisionmasterObjService
					.getDivisionMasterOne(divisionID);
			model.addAttribute(DIVISIONMASTER, divisionmasterObj);

		} catch (Exception ex) {
			LOGGER.error("Exception occured in deleteGet: " , ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;

		}
		return "Admin/DivisionMaster/DivisionMasterdelete";
	}

	/*
	 * @param model
	 * @param divisionmasterObj
	 * @return
	 * @throws ParseException
	 *//*
	@RequestMapping(value = { "/delete" }, method = RequestMethod.POST)
	public String deletePost(
			Model model,
			@ModelAttribute(value = DIVISIONMASTER) DivisionMaster divisionmasterObj,
			Locale locale) {
		try {
			boolean status = false;
			if (divisionmasterObj != null) {
				try {
					status = divisionmasterObjService
							.deleteDivisionMaster(divisionmasterObj
									.getDivisionID());

					if (!status) {
						model.addAttribute(DIVISIONMASTER, divisionmasterObj);
						MKCLUtility.addMessage(Integer.parseInt("71"), model,
								locale);
						return "Admin/DivisionMaster/DivisionMasterdelete";
					}

				} catch (Exception e) {
					LOGGER.error("Exception occured in deletePost: " , e);
					model.addAttribute(DIVISIONMASTER, divisionmasterObj);
					return "Admin/DivisionMaster/DivisionMasterdelete";
				}
			}

		} catch (Exception ex) {
			LOGGER.error("Exception occured in deletePost: " , ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;

		}
		return "redirect:DivisionMasterlist?messageid="
		+ MessageConstants.SUCCESSFULLY_DELETED_RECORD;
	}

	/*
	 * @param model
	 * @return
	 *//*
	@RequestMapping(value = { "/searchDivisionMaster" }, method = RequestMethod.GET)
	public String searchDivisionMasterPost(String searchText) {
		return "redirect:DivisionMasterlist?searchText=" + searchText;
	}

	/*
	 * @param model
	 * @return
	 *//*
	@RequestMapping(value = { "/prev" }, method = RequestMethod.GET)
	public String prevGet(Model model) {
		return "redirect:DivisionMasterlist";

	}

	/*
	 * @param model
	 * @return
	 *//*
	@RequestMapping(value = { "/next" }, method = RequestMethod.GET)
	public String nextGet(Model model) {
		return "redirect:DivisionMasterlist";
	}

	/*
	 * @param model
	 * @param request
	 * @param session
	 * @return
	 *//*
	@RequestMapping(value = { "/prev" }, method = RequestMethod.POST)
	public String prevPost(Model model,
			@ModelAttribute("pagination") Pagination pagination,
			String searchText) {
		try {
			pagination.setListName("DivisionMasterList");
			if (searchText != null && !(searchText.equals(""))) {
				pagination.setPropertyName("division");
				divisionmasterObjService.paginationPrev(null, pagination,
						searchText, model);
			} else {
				divisionmasterObjService.paginationPrev(null, pagination,
						searchText, model);
			}

		} catch (Exception e) {
			LOGGER.error("Exception occured in prevPost: " , e);
			model.addAttribute(Constants.EXCEPTIONSTRING, e.getMessage());
			return Constants.ERRORPAGE;
		}
		return "Admin/DivisionMaster/DivisionMasterlist";

	}

	/*
	 * @param model
	 * @param request
	 * @param session
	 * @return
	 *//*
	@RequestMapping(value = { "/next" }, method = RequestMethod.POST)
	public String nextPost(Model model,
			@ModelAttribute("pagination") Pagination pagination,
			String searchText) {
		try {
			pagination.setListName("DivisionMasterList");
			if (searchText != null && !(searchText.equals(""))) {
				pagination.setPropertyName("division");
				divisionmasterObjService.paginationNext(null, pagination,
						searchText, model);
			} else {
				divisionmasterObjService.paginationNext(null, pagination,
						searchText, model);
			}

		} catch (Exception ex) {
			LOGGER.error("Exception occured in nextPost: " , ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex.getMessage());
			return Constants.ERRORPAGE;
		}
		return "Admin/DivisionMaster/DivisionMasterlist";
	}*/

}
