<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page errorPage="../common/jsperror.jsp"%>
<c:forEach var="wc" items="${examViewModel.wordCloudList}">
	<b> <spring:message code="questionByquestion.question"></spring:message>${itemNo}:&nbsp;</b>
	<p class="question-wrap">${wc.itemText }</p>
	
	<c:if test="${fn:length(wc.itemImage)!=0}">
		<img src="../exam/displayImage?disImg=${wc.itemImage}" class="resize" /><br />
	</c:if>
	
	<b><spring:message code="questionAnalysis.correctAns"></spring:message></b>${wc.correctAnswer }
	<br /><br />
	
	<b><spring:message code="questionAnalysis.selectedAnswer"></spring:message></b>${examViewModel.candidateAnswer.typedText}
	<br />
	
	<div class="wcDiv" data-text="${wc.wordClouds }" style="width: 700PX; background-color: #fff;" id="${wc.fkItemLanguageID }"></div>
	<input type="hidden" value="${examViewModel.candidateAnswer.typedText}" id="hdn${wc.fkItemLanguageID }"/>
	
</c:forEach>


