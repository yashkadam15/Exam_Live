<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page errorPage="../common/jsperror.jsp"%>
<spring:theme code="playertheme" var="playertheme"/>
<link rel="stylesheet" href="<c:url value='${playertheme}'></c:url>" type="text/css"/>
<script type="text/javascript" src="<c:url value='/resources/js/jquery-1.12.0.min.js'></c:url>"></script> 
<script src="<c:url value='/resources/js/jquery.jplayer.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/oesplayer.js'></c:url>"></script>
<c:if test="${examViewModel.riform!=null}">
	<br>
	<b> <spring:message code="questionByquestion.question" />
		${itemNo}:&nbsp;
	</b>
	<p class="question-wrap">${examViewModel.riform.itemText }</p>	
	<%-- <p>Media Type: ${examViewModel.riform.multimediaType } </p> --%>
	
	<!-- Code to show media Player -->
	<c:if test="${fn:length(examViewModel.riform.itemFilePath)!=0  && fn:toLowerCase(examViewModel.riform.multimediaType)== 'audio' || fn:toLowerCase(examViewModel.riform.multimediaType)=='video'}">		
	 <div id="MMplayer_1" data-mediamode="open" data-mediatype="${fn:toLowerCase(examViewModel.riform.multimediaType)}" data-mediaurl="../exam/getmedia?f=${examViewModel.riform.itemFilePath}&e=${examViewModel.riform.fileTypeExtension}" data-mediaext="${examViewModel.riform.fileTypeExtension}"
	   data-medialoadonready="true" ></div><br>
	</c:if>	
		
	<c:if test="${fn:toLowerCase(examViewModel.riform.multimediaType) =='image' }">
	<p>	<img src="../exam/displayImage?disImg=${examViewModel.riform.itemFilePath}"
				class="resize" /></p>
	</c:if>	
	
	<c:if test="${fn:toLowerCase(examViewModel.riform.multimediaType) =='none' }">
		<p><spring:message code="RIFORM_QuestionAnalysis.none"/></p>
	</c:if>	
	
		
		<table  class="table table-bordered">
		<tr><th><spring:message code="RIFORM_QuestionAnalysis.AnswerDuration"/></th>
		<th><spring:message code="RIFORM_QuestionAnalysis.RecordedAnswerDuration"/></th>
		<th><spring:message code="RIFORM_QuestionAnalysis.Answeringmode"/></th>
		<th><spring:message code="RIFORM_QuestionAnalysis.RecordedAnswerFilename"/></th></tr>
		<tr><td>${examViewModel.riform.answerDuration} <spring:message code="minute.label"/></td>
		<td>
		<c:if test="${ examViewModel.candidateItemAssociation.timeTakenInSeconds!=0}">
		<c:choose>
		<c:when test="${examViewModel.candidateItemAssociation.timeTakenInSeconds >= 60 }">
		 <c:set value="${fn:substringBefore((examViewModel.candidateItemAssociation.timeTakenInSeconds div 60), '.')}" var="min"/>
         <c:set value="${examViewModel.candidateItemAssociation.timeTakenInSeconds mod 60}" var="sec"/>		
		${min} <spring:message code="minute.label"/> ${sec} <spring:message code="RIFORM_QuestionAnalysis.sec"/>
		</c:when>
		<c:otherwise>
		 ${examViewModel.candidateItemAssociation.timeTakenInSeconds} <spring:message code="RIFORM_QuestionAnalysis.sec"/>
		</c:otherwise>
		</c:choose>
		</c:if>	
		</td>
		<td>${examViewModel.riform.answeringMode}</td>
		<td>${examViewModel.candidateAnswer.optionFilePath}

		</td></tr>
		
		</table>
</c:if>