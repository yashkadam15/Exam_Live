package mkcl.oesclient.commons.validators;

import mkcl.oesclient.commons.utilities.BaseModelValidator;
import mkcl.oesclient.model.CandidateCollectionAssociation;

import org.springframework.validation.Errors;

/**
 * @author MKCL Scaffolding
 * 
 */
public class CandidateCollectionAssociationValidator  extends BaseModelValidator{


	/*
	 * (non-Javadoc)
	 * @see mkcl.os.model.BaseModelValidator#supports(java.lang.Class)
	 */
	public boolean supports(Class<?> cls) {		
		return CandidateCollectionAssociation.class.equals(cls);
	}
	
	/* (non-Javadoc)
	 * @see mkcl.os.model.BaseModelValidator#validate(java.lang.Object, org.springframework.validation.Errors)
	 */
	public void validate(Object target, Errors errors) {
		super.validate(target, errors);
		CandidateCollectionAssociation candidateCollectionAssociation = (CandidateCollectionAssociation) target;

		if(candidateCollectionAssociation.getFkExamEventID()==0){
			errors.rejectValue("fkExamEventID", "candidateDivAss.selExamevent");
		}
		
		if(candidateCollectionAssociation.getFkCollectionID()==0)
		{
			errors.rejectValue("fkCollectionID", "candidateDivAss.selDivision");
		}
		
		
	}

}
