<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page errorPage="../common/jsperror.jsp"%>

   <!-- Practical -->
		
		<!-- Show marks obtained -->
				<%-- 	<c:if test="${examViewModel.candidateItemAssociation.isCorrect== true}">
						<legend style="color: green;">
							<span><spring:message code="questionByquestion.correct"></spring:message></span>
							<span class="pull-right"><spring:message code="questionByquestion.marksObtainedForItem" /> : ${examViewModel.candidateItemAssociation.marksObtained}</span>
						</legend>
					</c:if>
					<c:if test="${examViewModel.candidateItemAssociation.isCorrect== false}">
						<legend style="color: red;">
							<span><spring:message code="questionByquestion.incorrect"></spring:message></span>
							<span class="pull-right"><spring:message code="questionByquestion.marksObtainedForItem" />  : ${examViewModel.candidateItemAssociation.marksObtained}</span>
						</legend>
					</c:if>
					<c:if test="${examViewModel.candidateItemAssociation.isCorrect == null}">
						<legend style="color: grey;">
							<span><spring:message	code="questionByquestion.notattempted"></spring:message></span>
						</legend>
					</c:if>		 --%>
					 <!-- end of Show marks obtained -->	
		
				
				<c:if test="${examViewModel.practical!=null}">				
				<b><spring:message code="questionByquestion.question"></spring:message>&nbsp;${itemNo}:&nbsp; 
				[${examViewModel.practical.practicalSubject.practicalCategory.categoryName } - ${examViewModel.practical.practicalSubject.subjectName}]
				</b>
				<p class="question-wrap"></p> 
				<p class="question-wrap">${examViewModel.practical.itemText}</p>								 
				<%-- <table class="table table-bordered" style="background-color: white">
				<tr>				
				<th>Subject Name</th>
				<th>Category Name</th>
				</tr>
				<tr>
				<td>${examViewModel.practical.practicalSubject.practicalCategory.categoryName}</td>
				<td>${examViewModel.practical.practicalSubject.subjectName}</td>				
				</tr>
				</table> --%>
				</c:if>
				
				<!-- End of practical -->
				
				