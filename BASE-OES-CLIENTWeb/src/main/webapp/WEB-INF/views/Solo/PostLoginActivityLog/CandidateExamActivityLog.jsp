<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="/enumTld" prefix="enumHelper"%>
<c:if test="${isAdmin==1 }">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title><spring:message code="examlog.title"/></title>
</head>
<body>
</c:if>
<fieldset class="well">
<c:choose>
<c:when test="${fn:length(OesLogForCandidate) != 0}">
<c:if test="${isAdmin==1 }">
<legend>
			<span><spring:message code="examlog.title"/></span>
			<span class="pull-right"><a href="examActivityLogSearch?username=${username}" class="btn btn-blue">Back</a></span>
		</legend>
<div class="holder"></c:if>
	<table>
		<tr>
			<td><Strong><spring:message code="examlog.candidate" /></Strong></td>
			<td>&nbsp;&nbsp; ${OesLogForCandidate[0].candidateName}</td>
		</tr>
		<tr>
			<td><Strong><spring:message code="examlog.examevent" /></Strong></td>
			<td>&nbsp;&nbsp; ${OesLogForCandidate[0].examEventName}</td>
		</tr>
		<tr>
			<td><Strong><spring:message code="examlog.paper" /></Strong></td>
			<td>&nbsp;&nbsp; ${OesLogForCandidate[0].paperName}</td>
		</tr>
		 <tr>
			<td><Strong><spring:message code="examlog.loginat" /></Strong></td> 
			
			<td>&nbsp;&nbsp;
			<fmt:formatDate value="${OesLogForCandidate[0].candOesLog.logDateTimeStamp}" pattern="yyyy-MM-dd hh:mm:ss a" />
				</td>
		</tr> 
		<tr>
			<td><Strong><spring:message code="examlog.loginIP" /></Strong></td>
			<td>&nbsp;&nbsp;
			${OesLogForCandidate[0].candOesLog.userIPAddress}
				</td>
		</tr>

	</table>
	<c:set var="srNo" value="1" scope="page" />
	<table class="table table-striped table-bordered" >
		<thead>
			<tr>
			<th><spring:message code="examlog.srNo" /></th>
				<th><spring:message code="examlog.examactivity" /></th>
				<th><spring:message code="examlog.visitedat" /></th>
				<th><spring:message code="examlog.examIP" /></th>
			</tr>
		</thead>
		<tfoot>
			<tr>
			<th><spring:message code="examlog.srNo" /></th>
				<th><spring:message code="examlog.examactivity" /></th>
				<th><spring:message code="examlog.visitedat" /></th>
				<th><spring:message code="examlog.examIP" /></th>
			</tr>
		</tfoot>
		<c:if test="${fn:length(OesLogForCandidate)>0}">
			<tbody>
				<c:forEach var="candExamLogObj"
					items="${OesLogForCandidate}">
					<tr>
					<td>${srNo}	<c:set var="srNo" value="${srNo+1}" scope="page" /></td>
						<td><c:choose>
								<c:when test="${candExamLogObj.logType=='ItemRendering'}">															
									<c:choose>
										<c:when test="${candExamLogObj.isSectionRequired==true}">
										${candExamLogObj.sectionName} - <spring:message code="examlog.item" />${candExamLogObj.itemSequenceNo}
										</c:when>
										<c:otherwise>
										<spring:message code="examlog.item" /> ${candExamLogObj.itemSequenceNo}
										</c:otherwise>								
									</c:choose>
								</c:when>
								<%-- <c:when test="${candExamLogObj.logType=='InstructionRendering'}">
										<spring:message code="examlog.instructions" />
								</c:when>
								<c:when test="${candExamLogObj.logType=='TestStart'}">
									<spring:message code="examlog.teststart" />
								</c:when>
								<c:when test="${candExamLogObj.logType=='TestEnd'}">
									<spring:message code="examlog.testend" />
								</c:when>
								<c:otherwise>
									${candExamLogObj.logType }
								</c:otherwise> --%>
								
								<c:otherwise>
									${enumHelper:enumLogTypeTag(candExamLogObj.logType)}
								</c:otherwise>
							</c:choose></td>
						<td>
						<fmt:formatDate value="${candExamLogObj.logDateTimeStamp }" pattern="yyyy-MM-dd hh:mm:ss a" />
						</td>
			
			<td>
			${candExamLogObj.userIPAddress}
				</td>
					</tr>
				</c:forEach>
			</tbody>

		</c:if>
		

	</table>
	<c:if test="${isAdmin==1 }">
</div></c:if>
	</c:when>
<c:otherwise>
<legend><span><spring:message code="global.42.warning"/></span></legend></c:otherwise>
</c:choose>
</fieldset>
<c:if test="${isAdmin==1 }">
</body>
</html>
</c:if>
