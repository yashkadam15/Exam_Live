<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page errorPage="../common/jsperror.jsp"%>

<c:set var="nfibList" value="${examViewModel.newFillInBlanksList}" />
<c:forEach var="nfib" items="${nfibList}">
	<b> <spring:message code="questionByquestion.question"></spring:message>
		${itemNo}:&nbsp;
	</b>
	<p class="question-wrap">${nfib.itemText }</p>

	<c:if test="${fn:length(nfib.itemImage)!=0}">
		<img src="../exam/displayImage?disImg=${nfib.itemImage}"
			class="resize" />
		<br />
	</c:if>

	<br />


	<c:set var="delimiter" value="\\$\\$\\$" />
	<c:set var="correctAnswers"
		value="${fn:split(nfib.correctAnswer, delimiter)}" />

	<table class="nfib-correctAnswer-table">
		<tr>
			<th rowspan="${loopStatus.index + 2}" class="nfib-correctAnswer-th" >
				<spring:message code="questionByquestion.correctAnswer"></spring:message>
			</th>
			<td>
				<table class="table table-bordered nfib-correctAnswer-sideTable" >
					<thead>
						<th><spring:message code="candidateTestReport.srNo" /></th>
						<th><spring:message code="questionAnalysis.answer" /></th>
					</thead>
					<tbody>
						<c:forEach var="answer" items="${correctAnswers}"
							varStatus="loopStatus">
							<tr>
								<th>${loopStatus.index + 1}</th>
								<td>${answer}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</td>
		</tr>
	</table>

	<table class="table table-bordered mt-30" >
		<tr>
			<th><center><i class="icon-user"></i></center></th>
			<td>${examViewModel.candidateAnswer.typedText }</td>
			<td class="nfib-answerStatus"><center>
					<c:if test="${itemstatus==1 || itemstatus==11}">
						<img src="${resourcespath}images/tick.png">&nbsp;
	                 				</c:if>
					<c:if test="${itemstatus==0 || itemstatus==10}">
						<img src="${resourcespath}images/wrong.png">&nbsp;
	                 				</c:if>
				</center></td>
		</tr>
	</table>
	
</c:forEach>
<p><b>Note: </b>The ||| acts as a separator for multiple answers</p>
