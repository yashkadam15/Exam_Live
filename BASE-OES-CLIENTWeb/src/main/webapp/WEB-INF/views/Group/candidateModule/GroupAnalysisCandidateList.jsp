<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page errorPage="../common/jsperror.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<title><spring:message code="GroupAnalysisCandidateList.title" /></title>

<style type="text/css">
</style>
</head>
<body>
	<fieldset class="well">
	<div>
			<legend>
				<span><spring:message code="GroupAnalysisCandidateList.heading" />- 
				<c:if test="${groupMasterObj !=null }">${groupMasterObj.groupName}</c:if>
				</span>
			</legend>
		</div>
	
	<div class="holder">
		<c:set var="srNo" value="1" scope="page" />
		<c:set var="displayNote" value="false" scope="page" />
			<table class="table table-striped table-bordered" id="demotable">
				<thead>
					<tr>
						<th><spring:message code="GroupAnalysisCandidateList.srNo" /></th>
						<th><spring:message code="GroupAnalysisCandidateList.name" /></th>
						<th><spring:message code="GroupAnalysisCandidateList.login" /></th>
						<th><spring:message code="GroupAnalysisCandidateList.userCode" /></th>									
						<th><spring:message code="GroupAnalysisCandidateList.analysis" /></th>
					</tr>
				</thead>
				<tfoot>
					<tr>
						<th><spring:message code="GroupAnalysisCandidateList.srNo" /></th>
						<th><spring:message code="GroupAnalysisCandidateList.name" /></th>
						<th><spring:message code="GroupAnalysisCandidateList.login" /></th>
						<th><spring:message code="GroupAnalysisCandidateList.userCode" /></th>										
						<th><spring:message code="GroupAnalysisCandidateList.analysis" /></th>
					</tr>
				</tfoot>
				<c:choose>
					<c:when test="${fn:length(mapCandidateAndPaperAttemptStatus) != 0}">
						<tbody>
						<c:forEach var="mapCandidatePaperAttempt" items="${mapCandidateAndPaperAttemptStatus}">
							<tr>
								<td>${srNo}	<c:set var="srNo" value="${srNo+1}" scope="page" /></td>
								<td>${mapCandidatePaperAttempt.key.candidateFirstName}&nbsp;${mapCandidatePaperAttempt.key.candidateLastName}</td>
								<td>${mapCandidatePaperAttempt.key.candidateUserName}</td>
								<td>${mapCandidatePaperAttempt.key.candidateCode}</td>														
								<td>
								<c:choose>
									<c:when test="${mapCandidatePaperAttempt.value=='true'}">
										<a class="btn btn-blue" href="../ResultAnalysis/viewtestscore?examEventId=${examEventId}&paperId=${paperId}&candidateId=${mapCandidatePaperAttempt.key.candidateID}&divisionId=${divisionId}&displayCategoryId=${displayCategoryId}&loginType=${loginType}"><spring:message code="GroupAnalysisCandidateList.analysis" /></a>	
									</c:when>
									<c:otherwise>
										<a class="btn btn-blue" href="#" disabled="true"><spring:message code="GroupAnalysisCandidateList.analysis" /></a>
										<c:set var="displayNote" value="true" scope="page" />
									</c:otherwise>
								</c:choose>
								</td>
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
			<c:if test="${displayNote=='true' }">
				<b><spring:message code="grpAnalysisCandList.note" /></b> <spring:message code="grpAnalysisCandList.disabledAnalysisBtn" />
			</c:if>		
		</div>		
	</fieldset>
</body>
</html>