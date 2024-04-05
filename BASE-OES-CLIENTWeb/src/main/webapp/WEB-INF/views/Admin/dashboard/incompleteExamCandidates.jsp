<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<title><spring:message code="incompleteexams.title" /></title>
</head>
<body>
	<fieldset class="well">
		<legend>
			<span><img
				src="<c:url value="../resources/images/dashboard.png"></c:url>"
				alt=""> <spring:message code="incompleteexams.title" /></span>
			<%-- <span><spring:message code="subjectAdmin.name" /></span> --%>
		</legend>
		<div class="holder">
			<c:if test="${incompleteExamCandidateViewModelList!=null && fn:length(incompleteExamCandidateViewModelList) != 0}">
				<br>
				<div class="row-fluid">
					<div class="span3">
						<label id="papertime-lbl" for="" class=" required">
						<b><spring:message code="incompleteexams.ExamEvent" /> </b> </label>
					</div>
					<p>${incompleteExamCandidateViewModelList[0].eventName}</p>
				</div>
				<div class="row-fluid">
					<div class="span3">
						<label id="papertime-lbl" for="" class=" required">
						<b><spring:message code="incompleteexams.Paper" /> </b> </label>
					</div>
					<p>${incompleteExamCandidateViewModelList[0].papername}</p>
				</div>
				
				
				<br>
				
				<table class="table table-striped table-bordered" id="demotable">
					<tr>
						<th><spring:message code="incompleteexams.CandidateCode" /></th>
						<th><spring:message code="incompleteexams.CandidateName" /></th>
						<th><spring:message code="incompleteexams.Username" /></th>
						<%-- <th><spring:message code="incompleteexams.Password" /></th> --%>
						<th><spring:message code="incompleteexams.ExamStartTime" /></th>

					</tr>
					<c:forEach var="obj"
						items="${incompleteExamCandidateViewModelList}">
						<tr>
							<td>${obj.candidateCode}</td>
							<td>${obj.candidateName}</td>
							<td>${obj.userName}</td>
							<%-- <td>${obj.password}</td> --%>
							<td>
							<fmt:formatDate value="${obj.examStartTime}" pattern="dd-MMM-yyyy HH:mm:ss" />
							</td>
						</tr>


					</c:forEach>

				</table>
			</c:if>
			<c:if test="${incompleteExamCandidateViewModelList==null || fn:length(incompleteExamCandidateViewModelList) == 0}">
			<h4><spring:message code="incompleteexams.Recordsnotfound" /></h4>
			</c:if>
		</div>
	</fieldset>
</body>
</html>

