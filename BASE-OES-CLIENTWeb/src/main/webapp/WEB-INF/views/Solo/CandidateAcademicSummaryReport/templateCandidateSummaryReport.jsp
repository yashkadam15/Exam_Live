<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%> 
<html>
<head>
<title>Academic Summary Report</title>
<spring:message code="project.resources" var="resourcespath" />
<style type="text/css">

#tblCsr{
	page-break-before : always;
}

.titles{
	background-color: #CCCCCC;
}


table, tr,th, td {
    border: 0.5px solid #707070;
    border-collapse: collapse;
    padding: 5px;
}

table {
   margin-top: 20px;
}


.normaltext
{
	margin: 5px;
	font-family:APARAJ,ARAB;  /* Helvetica Neue, Helvetica, Arial, sans-serif; */
	font-size: 14px;  
	line-height: 20px;
	display:block;		
}



</style>
</head>
<body class="normaltext">
	<div>
		
<%-- 		<form:form  class="form-horizontal" action="saveQuestionTitle"
			method="post" id="frmQuestionPpTitle" modelAttribute="candidateSummaryRptData">
			 --%>
			
			
			<c:forEach items="${candidateSummaryRptData}" var="csr" varStatus="i">
			 
				<table id="tblCsr" width="100%" style="font-size: 14px;padding:5px" cellpadding="0" cellspacing="0">
				<tr class="titles">
					<td colspan="9">
						<p align="center">${csr.eventName}<br/>${csr.candidate.candidateFirstName}  ${csr.candidate.candidateLastName} (${csr.candidate.candidateUserName})</p>
					</td>
					
				</tr>
				<tr style="background-color:#EEEEEE; text-align: center">
					<td style="width:5%"><spring:message code="templateCandidateSummaryReport.srNo"/></th>
					<td style="width:15%"><spring:message code="templateCandidateSummaryReport.subject"/> </th>
					<td style="width:27%"><spring:message code="templateCandidateSummaryReport.paper"/></th>
					<td style="width:8%"><spring:message code="templateCandidateSummaryReport.attemptNo"/></th>
					<td style="width:8%"><spring:message code="templateCandidateSummaryReport.totalMarks"/></th>
					<td style="width:10%"><spring:message code="templateCandidateSummaryReport.marksObtained"/></th>
					<td style="width:7%"><spring:message code="templateCandidateSummaryReport.time"/></th>
					<td style="width:10%"><spring:message code="templateCandidateSummaryReport.timaTaken"/></th>
					<td style="width:10%"><spring:message code="templateCandidateSummaryReport.appearedDate"/></th>
				</tr>
				<c:forEach items="${csr.candidateWiseExamList}" var="examlist" varStatus="j" >
					<tr>
						<td><div>${j.index +1}</div></td>
						<td><div>${examlist.displayCategoryLanguage.displayCategoryName}</div></td>
						<td><div>${examlist.paper.name}</div></td>
						<td><div>${examlist.attemptNo}</div></td>
						<td><div>${examlist.paperMarks.totalMarks}</div></td>
						<td><div>${examlist.candidateExam.marksObtained}</div></td>
						<td><div>${examlist.paper.duration}</div></td>
						<td><div>${examlist.candidateExam.elapsedTime}</div></td>
						<td><div><fmt:formatDate pattern="dd/MM/yyyy" value="${examlist.candidateExam.attemptDate}" /></div></td>
					</tr>
				</c:forEach>
				
				
				</table>
				 <div id="divNotAttempted" style="width: 100%;text-align: center;">
					<spring:message code="templateCandidateSummaryReport.notAttemptedByCandidate"/>
				</div>
			 
			</c:forEach>
			
			
			
	<%-- 		</form:form> --%>
	</div>
</body>
</html>

