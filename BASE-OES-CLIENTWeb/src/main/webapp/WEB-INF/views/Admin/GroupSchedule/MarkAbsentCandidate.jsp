<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page errorPage="../common/jsperror.jsp"%>

<html>
<head>
<title></title>
<spring:message code="project.resources" var="resourcespath" />
<style type="text/css">
.error {
	color: red;
}
</style>
</head>
<body>

	<fieldset class="well">
		<legend>
			<span><spring:message code="markAbsentCandidate.Title"></spring:message></span>
		</legend>
		<div class="holder">
			
			<form:form modelAttribute="absentViewModel" action="saveAbsentCandidates" method="POST" class="form-horizontal">

				<table class="table table-bordered table-condensed table-complex">
					<tbody>
						<tr>
							<th> <spring:message code="markAbsentCandidate.name"></spring:message> </th>
							<th><spring:message code="markAbsentCandidate.code"></spring:message></th>
							<th><spring:message code="markAbsentCandidate.mark"></spring:message></th>
						</tr>
						
						<c:forEach items="${absentViewModel.labSessionAbsentCanididates}" var="Obj" varStatus="loop">
							<tr>
								<td>${Obj.candidate.candidateFirstName} ${Obj.candidate.candidateLastName}</td>
								<td>${Obj.candidate.candidateCode}</td>
								<td>
									<%-- <form:checkbox path="labSessionAbsentCanididates[${loop.index }].fKCandidateID" value="${Obj.fKCandidateID}"/> --%>
									<input type="checkbox" name="labSessionAbsentCanididates[${loop.index}].fKCandidateID" id="labSessionAbsentCanididates[${loop.index}].fKCandidateID" value="${Obj.fKCandidateID}">
								</td>
								<td>
									<%-- <form:hidden path="labSessionAbsentCanididates[${loop.index}].fKlabSessionID" value="${Obj.fKlabSessionID}"/> --%>
									<input type="hidden" name="labSessionAbsentCanididates[${loop.index}].fkScheduleID" id="labSessionAbsentCanididates[${loop.index}].fkScheduleID" value="${Obj.fkScheduleID}"/>
								</td>
							</tr>
						</c:forEach>
						
					</tbody>
				</table>
				
				<input type="hidden" id="examEventID" name="examEventID" value="${examEventID}">
				<input type="hidden" id="collectionID" name="collectionID" value="${collectionID}">
				<input type="hidden" id="fkScheduleID" name="fkScheduleID" value="${fkScheduleID}">
				
				<button type="submit" id="btnSubmit" class="btn btn-blue"><spring:message code="markAbsentCandidate.save"></spring:message></button>				
				
			</form:form>
			
		</div><!-- End of holder div -->
	</fieldset>

</body>
</html>
