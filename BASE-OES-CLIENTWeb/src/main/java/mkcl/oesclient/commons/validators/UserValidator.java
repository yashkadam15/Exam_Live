package mkcl.oesclient.commons.validators;

import mkcl.oesclient.commons.utilities.BaseModelValidator;
import mkcl.oesclient.model.VenueUser;

import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;


public class UserValidator extends BaseModelValidator{

	private static final String USERNAME = "userName";
	private static final String USERNAMEERRORMSG = "user.userNameError";
	private static final String FIRSTNAME = "firstName";
	private static final String FIRSTNAMEERRORMSG = "user.firstNameError";
	private static final String LASTNAME = "lastName";
	private static final String LASTNAMEERRORMSG = "user.lastNameError";
	
	public boolean supports(Class<?> cls) {
		return VenueUser.class.equals(cls);
	}
	
	public void validate(Object target, Errors errors) {
		super.validate(target, errors);
		VenueUser user = (VenueUser) target;
		
		String fname = user.getFirstName();
		String lname = user.getLastName();
		String userName = user.getUserName();
		String password = user.getPassword();
		
		/******* For FirstName **********/
		
		boolean space = false;

		for (int i = 0; i < fname.length(); i++) {

			if ((Character.isWhitespace(fname.charAt(i)))) {
				space = true;
			} else {
				space = false;
			}
		}

		if (user.getFirstName().trim().length() == 0 || space) {
			errors.rejectValue(FIRSTNAME, FIRSTNAMEERRORMSG);

		} else {
			ValidationUtils.rejectIfEmpty(errors, FIRSTNAME,
					FIRSTNAMEERRORMSG);
		}
		
		/***** For Last Name *******/
		
		space = false;

		for (int i = 0; i < lname.length(); i++) {

			if ((Character.isWhitespace(lname.charAt(i)))) {
				space = true;
			} else {
				space = false;
			}
		}

		if (user.getLastName().trim().length() == 0 || space) {
			errors.rejectValue(LASTNAME, LASTNAMEERRORMSG);

		} else {
			ValidationUtils.rejectIfEmpty(errors, LASTNAME,
					LASTNAMEERRORMSG);
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
			errors.rejectValue(USERNAME, USERNAMEERRORMSG);

		} else {
			ValidationUtils.rejectIfEmpty(errors, USERNAME,
					USERNAMEERRORMSG);
		}
		
		
		/******* For Password **********/
		
		space = false;
		
		for (int i = 0; i < password.length(); i++) {

			if ((Character.isWhitespace(password.charAt(i)))) {
				space = true;
			} else {
				space = false;
			}
		}

		if (user.getPassword().trim().length() == 0 || space) {
			errors.rejectValue("password", "user.passwordError");

		} else {
			ValidationUtils.rejectIfEmpty(errors, "password",
					"user.passwordError");
		}
		
	}
	
	
	
	public void validateForUpdate(Object target, Errors errors){
				
		super.validate(target, errors);
		VenueUser user = (VenueUser) target;
		
		String fname = user.getFirstName();
		String lname = user.getLastName();
		String userName = user.getUserName();
		
		/******* For FirstName **********/
		
		boolean space = false;

		for (int i = 0; i < fname.length(); i++) {

			if ((Character.isWhitespace(fname.charAt(i)))) {
				space = true;
			} else {
				space = false;
			}
		}

		if (user.getFirstName().trim().length() == 0 || space) {
			errors.rejectValue(FIRSTNAME, FIRSTNAMEERRORMSG);

		} else {
			ValidationUtils.rejectIfEmpty(errors, FIRSTNAME,
					FIRSTNAMEERRORMSG);
		}
		
		/***** For Last Name *******/
		
		space = false;

		for (int i = 0; i < lname.length(); i++) {

			if ((Character.isWhitespace(lname.charAt(i)))) {
				space = true;
			} else {
				space = false;
			}
		}

		if (user.getLastName().trim().length() == 0 || space) {
			errors.rejectValue(LASTNAME, LASTNAMEERRORMSG);

		} else {
			ValidationUtils.rejectIfEmpty(errors, LASTNAME,
					LASTNAMEERRORMSG);
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
			errors.rejectValue(USERNAME, USERNAMEERRORMSG);

		} else {
			ValidationUtils.rejectIfEmpty(errors, USERNAME,
					USERNAMEERRORMSG);
		}
	}
	
}
