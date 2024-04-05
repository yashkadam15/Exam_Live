<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page errorPage="../common/jsperror.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib  uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<title><spring:message code="candidateloginReport.title" /></title>
<spring:message code="project.resources" var="resourcespath" />

<link rel="stylesheet" href="<c:url value='/resources/style/template.css?v=04042023A'></c:url>" type="text/css" />
<link rel="stylesheet" href="<c:url value='/resources/style/selectFix.css'></c:url>" type="text/css" />
<!--[if lte IE 9]>
<style>
.side-menu li a:hover, .side-menu li a:hover a:focus {background-color: #000}
</style>
<![endif]-->
<!--[if IE 7]>
<style>
.profile {max-width:180px}
.profile .display-info .btn-orange {margin-top: -10px; padding-top: 0; padding-bottom: 5px;}
legend {margin-left: -7px}
.quick-nav .btn-grey {border:1px solid #ccc}
</style>
<![endif]-->
<script src="<c:url value='/resources/js/jquery-1.12.0.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/bootstrap.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/selectFix.js'></c:url>"></script>
<link rel="stylesheet" type="text/css" href="<c:url value='/resources/style/dataTable.css'></c:url>" />
<style type="text/css">
.imageSize{
height: 40px;
width: 40px;
}
.imageSizeRes{
height: 32px;
width: 32px;
}
#search {  
 position: relative;
margin-top: 0px;
padding-left: 12px;
float: none;
margin-bottom: 0px;
margin-right: 5px;
}

body{
	background: #fff;
}
</style>
</head>
<body>
	
		<fieldset class="well">
			<div>
				<h3>
					<div class="text-center"><spring:message code="candidateloginReport.title" /></div>
				</h3>
			</div>
			
			<div class="holder">			
			<span style="margin-bottom: 5px;"><h4><spring:message code="EventSelection.ExamEventName"/>: ${examEventName}</h4></span>
			<c:choose>
				<c:when test="${fn:length(listOfCandidate) != 0}">
					<!--Integrated data table  -->
			<c:set var="srNo" value="0" scope="page" />
			
			<table class="table table-striped table-bordered" id="demotable">
				<thead>
					<tr>
						<th><spring:message code="candidateTestReport.srNo" /></th>
						<th><spring:message code="candidateTestReport.candidatename" /></th>
						<th><spring:message code="candidateTestReport.candidatecode" /></th>
						<th><spring:message code="candidateTestReport.loginID" /></th>
						<%-- <th><spring:message code="candidateTestReport.Password" /></th> --%>
						<th><spring:message code="candidateTestReport.candidatephoto"/></th>
					</tr>
				</thead>
				<tfoot>
					<tr>
						<th><spring:message code="candidateTestReport.srNo" /></th>
						<th><spring:message code="candidateTestReport.candidatename" /></th>
						<th><spring:message code="candidateTestReport.candidatecode" /></th>
						<th><spring:message code="candidateTestReport.loginID" /></th>
						<%-- <th><spring:message code="candidateTestReport.Password" /></th> --%>
						<th><spring:message code="candidateTestReport.candidatephoto"/></th>
					</tr>
				</tfoot>
				<c:if test="${fn:length(listOfCandidate) != 0}">
					<tbody>
						<c:forEach var="CandidateTestReportViewModel" items="${listOfCandidate}">
							<tr>
								<td>${srNo}	<c:set var="srNo" value="${srNo+1}" scope="page" /></td>
								<td>${CandidateTestReportViewModel.candidate.candidateFirstName}&nbsp;${CandidateTestReportViewModel.candidate.candidateLastName}</td>
								<td>${CandidateTestReportViewModel.candidate.candidateCode}</td>
								<td>${CandidateTestReportViewModel.candidate.candidateUserName}</td>							
								<%-- <td>${CandidateTestReportViewModel.candidate.candidatePassword}</td> --%>
						        <td>
						        <c:choose>
									<c:when test="${CandidateTestReportViewModel.candidate.candidatePhoto!= null and fn:length(CandidateTestReportViewModel.candidate.candidatePhoto) > 0}">
										<div class="dp"><img  class="imageSize" src="<c:url value="${imgPath}${CandidateTestReportViewModel.candidate.candidatePhoto}"></c:url>" onerror="this.src='${imgPath}<spring:message code="instruction.defaultPhoto"/>';"></div>
									</c:when>
									<c:otherwise>
										<div class="dp"><img class="imageSize" src="${imgPath}<spring:message code="instruction.defaultPhoto"/>" alt="default"></div>
									</c:otherwise>
								</c:choose>
                          		</td> 
							</tr>
						</c:forEach>
					</tbody>
				</c:if>
				</table>
				</c:when>
				<c:otherwise>
					<div class="alert">
					  <strong><spring:message code="candidateLogin.candidateDataNotFound"/></strong> 
					</div>
					<div></div>
				</c:otherwise>
			</c:choose>
			
		</div>
	</fieldset>
</body>
</html>