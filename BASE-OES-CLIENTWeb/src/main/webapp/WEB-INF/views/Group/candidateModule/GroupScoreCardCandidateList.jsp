<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page errorPage="../common/jsperror.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<title><spring:message code="GroupScoreCardCandidateList.title" /></title>

<style type="text/css">
</style>
</head>
<body>
	<fieldset class="well">
	<div>
			<legend>
				<span><spring:message code="GroupScoreCardCandidateList.viewScoreCard" />- 
				<c:if test="${groupMasterObj !=null }">${groupMasterObj.groupName}</c:if>
				</span>
			</legend>
		</div>
	
	<div class="holder">
		<c:set var="srNo" value="1" scope="page" />
			<table class="table table-striped table-bordered" id="demotable">
				<thead>
					<tr>
						<th><spring:message code="GroupScoreCardCandidateList.srNo" /></th>
						<th><spring:message code="GroupScoreCardCandidateList.name" /></th>
						<th><spring:message code="GroupScoreCardCandidateList.login" /></th>
						<th><spring:message code="GroupScoreCardCandidateList.userCode" /></th>									
						<th><spring:message code="GroupScoreCardCandidateList.analysis" /></th>
					</tr>
				</thead>
				<tfoot>
					<tr>
						<th><spring:message code="GroupScoreCardCandidateList.srNo" /></th>
						<th><spring:message code="GroupScoreCardCandidateList.name" /></th>
						<th><spring:message code="GroupScoreCardCandidateList.login" /></th>
						<th><spring:message code="GroupScoreCardCandidateList.userCode" /></th>										
						<th><spring:message code="GroupScoreCardCandidateList.analysis" /></th>
					</tr>
				</tfoot>
				<c:choose>
					<c:when test="${fn:length(listCandidates) != 0}">
						<tbody>
						<c:forEach var="candidateExam" items="${listCandidates}">
							<tr>
								<td>${srNo}	<c:set var="srNo" value="${srNo+1}" scope="page" /></td>
								<td>${candidateExam.candidate.candidateFirstName}&nbsp;${candidateExam.candidate.candidateLastName}</td>
								<td>${candidateExam.candidate.candidateUserName}</td>
								<td>${candidateExam.candidate.candidateCode}</td>												
								<td><a class="btn btn-blue" href="../endexam/showTestResult?examEventID=${examEventId}&paperID=${paperId}&candidateId=${candidateExam.candidate.candidateID}&loginType=${loginType}&ceid=${candidateExam.candidateExamID}"><spring:message code="GroupScoreCardCandidateList.scoreCard" /></a></td>
							</tr>
						</c:forEach>
					</tbody>
					</c:when>
					<c:otherwise>
						<tbody>
							<tr>
								<td colspan="5"><spring:message code="global.emptyList" /></td>
							</tr>
						</tbody>
					</c:otherwise>
				</c:choose>				
			</table>
		</div>		
	</fieldset>
</body>
</html>