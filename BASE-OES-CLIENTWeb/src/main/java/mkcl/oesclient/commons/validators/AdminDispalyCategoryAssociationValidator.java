package mkcl.oesclient.commons.validators;
//Modified by Reena for setting based client 03-dec2013
import mkcl.baseoesclient.model.AdminDisplayCategoryCollectionAssociation;
import mkcl.oesclient.commons.utilities.BaseModelValidator;
import mkcl.oesclient.model.VenueUser;
import mkcl.oesclient.viewmodel.ViewModelAdminDisplayCategoryUser;

import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;

public class AdminDispalyCategoryAssociationValidator extends
		BaseModelValidator {

	public boolean supports(Class<?> cls) {
		return AdminDisplayCategoryCollectionAssociation.class.equals(cls);
	}

	public void validate(Object target, Errors errors) {

		super.validate(target, errors);
		ViewModelAdminDisplayCategoryUser adminSubDivAssocaitionViewModel = (ViewModelAdminDisplayCategoryUser) target;
		VenueUser user = adminSubDivAssocaitionViewModel.getUser();
		String name = user.getFirstName();
		String userName = user.getUserName();
		
		/******* For Name **********/
		
		boolean space = false;
		for (int i = 0; i < name.length(); i++) {
			if ((Character.isWhitespace(name.charAt(i)))) {
				space = true;
			} else {
				space = false;
			}
		}
		if (user.getFirstName().trim().length() == 0 || space) {
			errors.rejectValue("user.uname", "user.unameError");

		} else {
			ValidationUtils.rejectIfEmpty(errors, "user.uname",
					"user.unameError");
		}
		
		if (user.getEmail().trim().length() == 0 || space) {
			errors.rejectValue("user.email", "user.emailError");

		} else {
			ValidationUtils.rejectIfEmpty(errors, "user.email",
					"user.emailError");
		}
		
		/******* For User Name **********/
		
		space = false;
		
		for (int i = 0; i < userName.length(); i++) {

			if ((Character.isWhitespace(userName.charAt(i)))) {
				space = true;
			} else {
				space = false;
			}
		}

		if (user.getUserName().trim().length() == 0 || space) {
			errors.rejectValue("user.userName", "user.userNameError");

		} else {
			ValidationUtils.rejectIfEmpty(errors, "user.userName",
					"user.userNameError");
		}
	
	}
}
