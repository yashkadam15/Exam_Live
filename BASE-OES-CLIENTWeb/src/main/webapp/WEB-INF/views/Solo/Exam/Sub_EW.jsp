<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<form:hidden path="candidateSubItemAssociation.candidateExamItemID"/>
<form:hidden path="candidateSubItemAssociation.fkCandidateExamID" /> 
<form:hidden path="candidateSubItemAssociation.fkCandidateID" /> 
<form:hidden path="candidateSubItemAssociation.fkItemID"/> 
<form:hidden path="candidateSubItemAssociation.fkParentItemID" /> 
<form:hidden path="candidateSubItemAssociation.item.Itemtype" id="subitype"/>
<input type="hidden" id="cursubitemID" name="cursubitemID" value="${candidateItemAssociation.candidateSubItemAssociation.fkItemID}"/>
<input type="hidden" id="cbreviewValue" value="${candidateItemAssociation.candidateSubItemAssociation.isMarkedForReview}"/>
<input type="hidden" id="ceiid" value="${candidateItemAssociation.candidateSubItemAssociation.candidateExamItemID }"/>
<c:choose>
	<c:when test="${mode != null}">
		<input type="hidden" id="mode" name="mode" value="${mode }"/>
	</c:when>
	<c:otherwise>
		<input type="hidden" id="mode" name="mode" value="off"/>
	</c:otherwise>
</c:choose>	

<div class="questiondiv subQDiv scrollbar-outer">
   <div id="${examViewModel.essayWriting.itemLanguage.fkLanguageID}" class="qdiv">
	   	 <p class="question-wrap">${examViewModel.essayWriting.itemText }</p>
	   	 <c:if test="${examViewModel.essayWriting.itemImage != null && examViewModel.essayWriting.itemImage != ''  && fn:length(examViewModel.essayWriting.itemImage) > 0}">
	   	 	<img src="<c:url value="/exam/displayImage?disImg=${examViewModel.essayWriting.itemImage}"></c:url>"/>
	   	 </c:if>
	   	 <br/>
	   	 <br/>	
	   	 <div id="longtextanswer">
	   	  	<form:textarea path="candidateSubItemAssociation.candidateAnswers[0].typedText" autoComplete="off" autoCorrect="off" autoCapitalize="off" spellCheck="false" onselectstart="return false" class="form-control answerdata markdown" id="optionsAns"></form:textarea>
	   	 </div> 
	   	<form:hidden path="candidateSubItemAssociation.candidateAnswers[0].candidateExamItemID" value="${candidateItemAssociation.candidateSubItemAssociation.candidateExamItemID }" id="candidateExamItemID"/>
		<form:hidden path="candidateSubItemAssociation.candidateAnswers[0].fkcandidateID" />
		<form:hidden path="candidateSubItemAssociation.candidateAnswers[0].fkItemID" value="${candidateItemAssociation.candidateSubItemAssociation.fkItemID }"/>
		<form:hidden path="candidateSubItemAssociation.candidateAnswers[0].candidateAnswerID" />
		<form:hidden path="candidateSubItemAssociation.candidateAnswers[0].fkParentItemID" value="${candidateItemAssociation.candidateSubItemAssociation.fkParentItemID }"/>
		<form:hidden path="candidateSubItemAssociation.candidateAnswers[0].fkCandidateExamID" />
		<form:hidden path="candidateSubItemAssociation.candidateAnswers[0].fkExamEventID" />           	       	  
   </div>
</div> 
