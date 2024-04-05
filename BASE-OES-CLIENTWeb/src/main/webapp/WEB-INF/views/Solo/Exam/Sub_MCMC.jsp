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
	<div id="${examViewModel.multipleChoiceMultipleCorrect.itemLanguage.fkLanguageID}" class="qdiv">
	  	 <p class="question-wrap">${examViewModel.multipleChoiceMultipleCorrect.itemText }</p>
	  	  <c:if test="${examViewModel.multipleChoiceMultipleCorrect.itemImage != null && examViewModel.multipleChoiceMultipleCorrect.itemImage != ''  && fn:length(examViewModel.multipleChoiceMultipleCorrect.itemImage) > 0}">
	  	 	<img src="<c:url value="/exam/displayImage?disImg=${examViewModel.multipleChoiceMultipleCorrect.itemImage}"></c:url>"/>
	  	  </c:if>
	  	 <br/>
	  	 <br/>		              	
	  	 <c:forEach items="${examViewModel.multipleChoiceMultipleCorrect.optionList}" var="option" varStatus="j">  		              	 	      	
	        <div class="controls">		                   
	        <form:hidden path="candidateSubItemAssociation.candidateAnswers[${j.index }].candidateExamItemID" value="${candidateItemAssociation.candidateSubItemAssociation.candidateExamItemID }" id="candidateExamItemID"/>		                    
	        <form:hidden path="candidateSubItemAssociation.candidateAnswers[${j.index }].fkcandidateID"/>
	        <form:hidden path="candidateSubItemAssociation.candidateAnswers[${j.index }].fkItemID" value="${candidateItemAssociation.candidateSubItemAssociation.fkItemID }"/>
	        <form:hidden path="candidateSubItemAssociation.candidateAnswers[${j.index }].candidateAnswerID"/>
	        <form:hidden path="candidateSubItemAssociation.candidateAnswers[${j.index }].fkParentItemID" value="${candidateItemAssociation.candidateSubItemAssociation.fkParentItemID }"/>
	        <form:hidden path="candidateSubItemAssociation.candidateAnswers[${j.index }].fkCandidateExamID"/>
	        <form:hidden path="candidateSubItemAssociation.candidateAnswers[${j.index }].fkExamEventID"/>
	        <label class="checkbox">
	        <form:checkbox path="candidateSubItemAssociation.candidateAnswers[${j.index }].optionID" id="optionsAns${option.optionLanguage.option.optionSequenceNo }" class="${option.optionLanguage.option.optionSequenceNo }" value="${option.optionLanguage.option.optionID }"/>
	       		<c:if test="${option.optionText != null && option.optionText != ''  && fn:length(option.optionText) > 0}">
	       			<div class="question-wrap">${option.optionText }</div>		                   		
	       		</c:if>	
	       		 <c:if test="${option.optionImage != null && option.optionImage != ''  && fn:length(option.optionImage) > 0}">
	       		 	<c:if test="${option.optionText != null && option.optionText != ''  && fn:length(option.optionText) > 0}">
	       		 	<br/>
	       		 	</c:if>
	  	 			<img src="<c:url value="/exam/displayImage?disImg=${option.optionImage}"></c:url>"/>
	  	 		</c:if>	                   		
	        </label>
	        </div>
	  	 </c:forEach>
   </div> 
</div> 
		  
	                     