package mkcl.oesclient.commons.validators;


import mkcl.oesclient.commons.utilities.BaseModelValidator;
import mkcl.oespcs.model.ExamEvent;

import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;

/**
 * @author MKCL Scaffolding
 *
 */
public class ExamEventValidator extends BaseModelValidator{
	

	public boolean supports(Class<?> cls) {		
		return ExamEvent.class.equals(cls);
	}
	

	public void validate(Object target, Errors errors) {
		super.validate(target, errors);
		ExamEvent examEvent=(ExamEvent) target;
		ValidationUtils.rejectIfEmptyOrWhitespace(errors,"examEventID","examEvent.examEventID");
		 if(0==examEvent.getExamEventID()){
			 errors.rejectValue("examEventID", "examEvent.examEventID");
		 }
		
		
	}
}
