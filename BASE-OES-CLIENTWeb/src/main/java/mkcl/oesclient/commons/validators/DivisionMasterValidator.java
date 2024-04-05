package mkcl.oesclient.commons.validators;


import mkcl.oesclient.commons.utilities.BaseModelValidator;
import mkcl.oesclient.model.CollectionMaster;

import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;

/**
 * @author MKCL Scaffolding
 *
 */
public class DivisionMasterValidator extends BaseModelValidator{
	

	public boolean supports(Class<?> cls) {		
		return CollectionMaster.class.equals(cls);
	}
	

	public void validate(Object target, Errors errors) {
		super.validate(target, errors);
		
		ValidationUtils.rejectIfEmptyOrWhitespace(errors,"division","division.field");
		
		
	}
}
