<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<c:if test="${examViewModel.comprehensionMixQT!=null}">
	<br>
	<b> <spring:message code="questionByquestion.mainQuestion" />
		${itemNo}:&nbsp;
	</b> 
	 <p class="question-wrap">${examViewModel.comprehensionMixQT.itemText }</p>
	 <c:if test="${fn:length(examViewModel.comprehensionMixQT.itemFilePath)!=0}">
		<img src="../exam/displayImage?disImg=${examViewModel.comprehensionMixQT.itemFilePath}" class="resize" /><br>							
	</c:if> 
	<!-- <hr class="lineColor" /> -->
	<c:set var="lineCnt" value="0" />
	
	<!--Start if sub Item type MCSC, YN, TF -->
	 <c:if test="${fn:length(examViewModel.comprehensionMixQT.listMultipleChoiceSingleCorrect)!=0 && examViewModel.comprehensionMixQT.listMultipleChoiceSingleCorrect!=null}">
		 <c:forEach var="subitemObj" items="${examViewModel.comprehensionMixQT.listMultipleChoiceSingleCorrect}" varStatus="i1">
		 	<c:set var="lineCnt" value="${lineCnt+1}" />
		 	<c:if test="${examViewModel.comprehensionMixQT.noOfSubItems!=lineCnt-1}">
				<hr class="lineColor" />
			</c:if>
			<%@include file="CMPSMQT_SubQuestionAnalysis.jsp"%>
		</c:forEach> 
	</c:if>
	<!-- End sub Item type MCSC, YN, TF -->
	
	
	<!--Start if sub Item type MCMC -->
	<c:if test="${fn:length(examViewModel.comprehensionMixQT.listMultipleChoiceMultipleCorrect)!=0 && examViewModel.comprehensionMixQT.listMultipleChoiceMultipleCorrect!=null}">
		<c:forEach var="subitemObj" items="${examViewModel.comprehensionMixQT.listMultipleChoiceMultipleCorrect}" varStatus="i1">
			<c:set var="lineCnt" value="${lineCnt+1}" />
			<c:if test="${examViewModel.comprehensionMixQT.noOfSubItems!=lineCnt-1}">
				<hr class="lineColor" />
			</c:if>
			<%@include file="CMPSMQT_SubQuestionAnalysis.jsp"%>
		</c:forEach>
	</c:if>
	<!-- End sub Item type MCMC -->
	
	
	<!--Start if sub Item type EW -->
	<c:if test="${fn:length(examViewModel.comprehensionMixQT.listEssayWriting)!=0 && examViewModel.comprehensionMixQT.listEssayWriting!=null}">
		<c:forEach var="subitemObj" items="${examViewModel.comprehensionMixQT.listEssayWriting}" varStatus="i1">
			<c:set var="lineCnt" value="${lineCnt+1}" />
			<c:if test="${examViewModel.comprehensionMixQT.noOfSubItems!=lineCnt-1}">
				<hr class="lineColor" />
			</c:if>
			<b> <spring:message code="questionByquestion.question"></spring:message> ${lineCnt}:&nbsp;
			</b>
			<p class="question-wrap">${subitemObj.itemText }</p>
			<c:if test="${fn:length(subitemObj.itemImage)!=0}">
				<img src="../exam/displayImage?disImg=${subitemObj.itemImage}" class="resize" />
			</c:if>

			<!-- Candidate Answer -->
			<c:forEach var="candidateAnsObj" items="${examViewModel.candidateAnswerList}">
				<c:if test="${candidateAnsObj.fkItemID==subitemObj.itemLanguage.fkItemID}">
					<b><spring:message code="attemptReport.candidateAnswer" /></b>
					<br />	                 				
      				${candidateAnsObj.typedText }
				</c:if>
			</c:forEach>
				
		</c:forEach>
	</c:if> 
	<!-- End sub Item type EW -->
	
		
</c:if>