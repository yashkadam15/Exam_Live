<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<title>Future Vedh - Career Profiling Test Report</title>
<link rel="stylesheet" type="text/css" href="<c:url value='/resources/style/report.css'></c:url>" />
<script src="<c:url value='/resources/js/jquery-1.12.0.min.js'></c:url>"></script>
<spring:message code="project.resources" var="resourcespath" />
<style type="text/css">
body {padding: 25px;}
.error {
	color: red;
}

a:hover {
	text-decoration: none;
}
</style>
<style type="text/css" media="print">
body {margin: 0; padding: 0;}
.table {margin-bottom: 10px;}
.table tr td {padding-top: 5px; padding-bottom: 5px;}
.print {display: none;}


.table th,
.table td {
  padding: 8px;
  /* line-height: 20px; */
  text-align: left;
  vertical-align: top;
  border-top: 1px solid #a9a9a9;
}

.table-bordered {
  border: 1px solid #a9a9a9;
  border-collapse: separate;
  *border-collapse: collapse;
  border-left: 0;
  -webkit-border-radius: 2px;
  -moz-border-radius: 2px;
  border-radius: 2px;
}
.table-bordered th,
.table-bordered td {
  border-left: 1px solid #a9a9a9;
}
</style>
<script type="text/javascript">

$(document).ready(function(){
	$("#printbtn").click(function(e){
		$(this).hide();
		window.print();
	});
	
	
});

</script>
</head>
<body style="background-color: white;">
<c:if test="${fn:length(paperIBMap)==0}">

	<p><spring:message code="candidateProfilingTestReport.recordNotFound"/></p>

</c:if>
<c:if test="${fn:length(paperIBMap)>0}">
<table style="padding:25px;border:2px black solid">




<tr>
<td style="padding:20px;">
<table cellpadding="0" cellspacing="0" border="0" width="100%">
	<tr>
		<%-- <td style="padding-bottom: 10px; text-align: left;width: 15%;"><img src="<c:url value="../resources/images/MKCL_Logo_FV.png"></c:url>" alt=""></td>
		<td>
		
		<td style="padding-bottom: 10px; text-align: left;width: 70%;">
			<center>
			<img style="height: 80px; width: 700px;" src="<c:url value="../resources/images/FutureVedhBanner.JPG"></c:url>" alt=""></td>
			</center>
		<td>
		
		</td>
		<td style="padding-bottom: 10px; text-align: right;width: 15%;"><img src="<c:url value="../resources/images/logo_ifph_new.png"></c:url>" alt=""></td> --%>
		<td><img src="<c:url value="../resources/images/JainFVBanner.jpg"></c:url>" alt=""></td>
	</tr>
</table>

	<div class="holder">

			<div style="margin-top: 5px;margin-bottom: 10px;">
				<center>
					<span style="font-size: 22pt"><spring:message code="ddtDashboard.Report"/></span>
				</center>
			</div>
			<table class="table table-striped table-bordered"  style="font-size: 12px;border-collapse: unset;">
				<tr>
					<td><b><spring:message code="takeTest.name"/></b> &nbsp;${profilingModelList[0].candidateName}</td>
					<td><b><spring:message code="artInclinationTest.candidateCode"/></b> &nbsp;${profilingModelList[0].candidateCode}
					</td>
				</tr>
				<tr>
					<td><b><spring:message code="diabetesDiagnosticTestEnResult.centerCode"/></b> &nbsp;${profilingModelList[0].examVenueCode}
					</td>
					<td><b><spring:message code="diabetesDiagnosticTestEnResult.centerName"/></b> &nbsp;${profilingModelList[0].examVenueName}
					</td>
				</tr>
			</table>

			<table class="table table-striped table-bordered" style="font-size: 12px;border-collapse: unset;">
				<tbody>
					<tr>
						<th width="9%"><spring:message code="templateCandidateSummaryReport.srNo"/></th>
						<th><spring:message code="candidateProfilingTestReport.testName"/></th>
						<th width="30%"><spring:message code="candidateProfilingTestReport.interpretation"/></th>
					</tr>
					<c:forEach items="${paperIBMap}" var="obj" varStatus="i">
						<c:if test="${i.index<5}">
							<tr>
								<td style="text-align: center;">${i.index+1 }</td>
								<td>${obj.key}</td>
								<td>
									<c:forEach items="${obj.value}" var="innerobj">
										${innerobj.key }
									</c:forEach></td>
							</tr>
						</c:if>
					</c:forEach>
				</tbody>
			</table>

			<table class="table table-striped table-bordered"  style="font-size: 12px;border-collapse: unset;">
				<tbody>
					<tr>
						<th width="9%"><spring:message code="templateCandidateSummaryReport.srNo"/></th>
						<th width="15%"><spring:message code="candidateProfilingTestReport.testName"/></th>
						<th  width="14%"><spring:message code="candidateProfilingTestReport.interpretation"/></th>
						<th><spring:message code="candidateProfilingTestReport.areas"/></th>
					</tr>
					<c:forEach items="${paperIBMap}" var="obj" varStatus="i">
						<c:if test="${i.index==5}">
							<tr>
								<td  style="text-align: center;" rowspan="${fn:length(obj.value)+1}">${i.index+1 }</td>
								<td rowspan="${fn:length(obj.value)+1}">${obj.key}</td>
									<c:forEach items="${obj.value}" var="innerobj">
									<tr>
										<td>${innerobj.key }</td>
										<td>${innerobj.value}</td>
									</tr>
									</c:forEach>
							</tr>
						</c:if>
					</c:forEach>
				</tbody>
			</table>

			<table class="table table-striped table-bordered"  style="font-size: 12px;border-collapse: unset;">
				<tbody>
					<tr>
						<th width="9%"><spring:message code="templateCandidateSummaryReport.srNo"/></th>
						<th width="15%"><spring:message code="candidateProfilingTestReport.testName"/></th>
						<th><spring:message code="candidateProfilingTestReport.traits"/></th>
						<th width="14%"><spring:message code="candidateProfilingTestReport.interpretation"/></th>
					</tr>
					<c:forEach items="${paperIBMap}" var="obj" varStatus="i">
						<c:if test="${i.index==6}">
							<tr>
								<td  style="text-align: center;" rowspan="${fn:length(obj.value)+1}">${i.index+1 }</td>
								<td rowspan="${fn:length(obj.value)+1}">${obj.key}</td>
									<c:forEach items="${obj.value}" var="innerobj">
									<tr>
										<td>${innerobj.value}</td>
										<td>${innerobj.key }</td>
									</tr>
									</c:forEach>
							</tr>
						</c:if>
					</c:forEach>
				</tbody>
			</table>

			<p style="font-size: 9.5px;line-height: 1;margin-top: -5px;"><spring:message code="candidateProfilingTestReport.testWereConducted"/> <fmt:formatDate value="${attemptDateViewModel.minAttemptDate}" pattern="dd-MMM-yyyy HH:mm:ss" /> <spring:message code="candidateProfilingTestReport.and"/> <fmt:formatDate value="${attemptDateViewModel.maxAttemptDate}" pattern="dd-MMM-yyyy HH:mm:ss" timeStyle="medium"/> <%--  <fmt:formatDate type="both" dateStyle="medium" timeStyle="medium" value="${attemptDateViewModel.maxAttemptDate}" /> --%>
			</p>
			<br>
			<div>
				<p style="font-size: 12px"><b><spring:message code="candidateProfilingTestReport.coursesOptionsSuggested"/></b></p>
			</div>
			<div>
				<p style="font-size: 13px">${profilingModelList[0].courseName}</p>
			</div>
			<br>
			<div>
			<hr style="margin: 1px 0; border-width: 2px 0;">
			<span style="font-size: 10px"><b><spring:message code="candidateProfilingTestReport.disclaimer"/></b></span>
			<p style="font-size: 9.5px;line-height: 1;"><spring:message code="candidateProfilingTestReport.resultGeneratedBythisMachine"/> 
			</p>
			 <br>
			<span style="font-size: 10px"><b><spring:message code="grpAnalysisCandList.note"/></b></span>
			<p style="font-size: 9.5px;line-height: 1;"><spring:message code="candidateProfilingTestReport.jainGroup"/></p>
			 <br>

			 <p style="text-align: center;font-weight: bold;"><spring:message code="candidateProfilingTestReport.visitus"/> <span style="color: blue;"><spring:message code="candidateProfilingTestReport.jgi"/></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  <spring:message code="candidateProfilingTestReport.email"/> <span style="color: blue;"><spring:message code="candidateProfilingTestReport.jgicd"/></span>
			</p>
			</div>

		
	</div>
	</td>
</tr>

</table>
<div class="print">
<br>
<center><button id="printbtn"><spring:message code="candidateProfilingTestReport.print"/></button></center>
<br>
</div>
</c:if>

</body>
</html>
