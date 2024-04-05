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
				alt=""> 
				<spring:message code="admindashboard.examStatus"/>
				<c:choose>
								<c:when test="${flag=='0'}">
								<spring:message code="admindashboard.AllocatedCandidates"/>
								</c:when>
								<c:when test="${flag=='1'}">
								<spring:message code="admindashboard.notAppeared"/>
								</c:when>
								<c:when test="${flag=='2'}">
								<spring:message code="scoreCard.InComplete"/>
								</c:when>
								<c:when test="${flag=='3'}">
								<spring:message code="admindashboard.NotUploaded"/>
								</c:when>
								<c:when test="${flag=='4'}">
								<spring:message code="admindashboard.Uploaded"/>
								</c:when>
								</c:choose>
				
				
				</span>
			<%-- <span><spring:message code="subjectAdmin.name" /></span> --%>
		</legend>
		<div class="holder">
			<c:if test="${candidateViewModelList!=null && fn:length(candidateViewModelList) != 0}">
				<br>
				<div class="row-fluid">
					<div class="span3">
						<label id="papertime-lbl" for="" class=" required">
						<b><spring:message code="incompleteexams.ExamEvent" /> </b> </label>
					</div>
					<p>${candidateViewModelList[0].eventName}</p>
				</div>
				<div class="row-fluid">
					<div class="span3">
						<label id="papertime-lbl" for="" class=" required">
						<b><spring:message code="incompleteexams.Paper" /> </b> </label>
					</div>
					<p>${candidateViewModelList[0].papername}</p>
				</div>
				

				<div style="padding-bottom: 1cm;"><a href="./adminDashBoard" class="btn btn-blue pull-right"><spring:message code="presentreport.back"/></a></div>
				<table class="table table-striped table-bordered" id="demotable">
					<tr>
						<th><spring:message code="incompleteexams.CandidateCode" /></th>
						<th><spring:message code="incompleteexams.CandidateName" /></th>
						<th><spring:message code="incompleteexams.Username" /></th>
						<%-- <th><spring:message code="incompleteexams.Password" /></th> --%>
						<c:if test="${flag=='3' || flag=='4'}">
						<th><spring:message code="incompleteexams.ExamStartTime" /></th>
						<th><spring:message code="admindashboard.endtime"/></th>
						</c:if>
						
						<c:if test="${flag=='2'}">
						<th><spring:message code="incompleteexams.ExamStartTime" /></th>
						
						</c:if>
					</tr>
					<c:forEach var="obj"
						items="${candidateViewModelList}">
						<tr>
							<td>${obj.candidateCode}</td>
							<td>${obj.candidateName}</td>
							<td>${obj.userName}</td>
							<%-- <td>${obj.password}</td> --%>
							<c:if test="${flag=='3' || flag=='4'}">
							<td>
							<fmt:formatDate value="${obj.examStartTime}" pattern="dd-MMM-yyyy HH:mm:ss" />
							</td>
							<td>
							<fmt:formatDate value="${obj.examEndTime}" pattern="dd-MMM-yyyy HH:mm:ss" />
							</td>
							</c:if>
							
							<c:if test="${flag=='2'}">
							<td>
							<fmt:formatDate value="${obj.examStartTime}" pattern="dd-MMM-yyyy HH:mm:ss" />
							</td>
							
							</c:if>
							
						</tr>


					</c:forEach>

				</table>
			</c:if>
			<c:if test="${candidateViewModelList==null || fn:length(candidateViewModelList) == 0}">
			<h4><spring:message code="incompleteexams.Recordsnotfound" /></h4>
			</c:if>
		</div>
	</fieldset>
</body>
</html>

