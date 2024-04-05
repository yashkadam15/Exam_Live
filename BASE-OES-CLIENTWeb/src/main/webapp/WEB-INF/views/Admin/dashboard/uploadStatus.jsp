<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib  uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<title><spring:message code="admindashboard.uploadStatus" /></title>
</head>
<body>
	<fieldset class="well">
		<legend>
			<span><img src="<c:url value="../resources/images/dashboard.png"></c:url>" alt=""> 
			<spring:message code="admindashboard.uploadStatus" /></span>
		</legend>
		<div class="holder">
		
		
			
		<c:if test="${fn:length(examStatusViewModelList) != 0}">

		<c:set var="examId" value="0"/>
		<c:set var="noupload" value="0"/>
		<c:forEach var="candExam" items="${examStatusViewModelList}">
		<c:choose>
		<c:when test="${candExam.examEventID==examId }">
		<tr>
		<td>
		${candExam.paperName}
		</td>
		<td style="text-align: center;">
		
			<h3 class="dashboard-header">${candExam.totalCandidates}</h3>
		</td>
		<td style="text-align: center;">
			<c:if test="${candExam.uploadFlag!=2}">
				
				<h3 class="dashboard-header">${candExam.uploadedExamCount}</h3>
			</c:if>
		
			<c:if test="${candExam.uploadFlag==2}">
					<c:set var="noupload" value="1"/>
				<h3 class="dashboard-header">*</h3>
			</c:if>
		</td>
		<td style="text-align: center;">
			<c:if test="${candExam.uploadFlag!=2}">
				<h3 style="color: #297dbc;line-height: 10px;">${candExam.notUploadedExamCount}</h3>
			</c:if>
		
			<c:if test="${candExam.uploadFlag==2}">
				<c:set var="noupload" value="1"/>
				<h3 class="dashboard-header">*</h3>
			</c:if>
		</td>
		<td>
		<c:choose>
					<c:when test="${candExam.notUploadedExamCount == 0}">
					<a href="#" class="btn btn-blue" disabled="disabled">Upload</a>
					</c:when>
					<c:otherwise>
					<a data-paperid="${candExam.paperID}" data-eventid="${candExam.examEventID}" class="btn btn-blue uploadBtn">Upload</a>
					</c:otherwise>
					</c:choose>
		</td>
		
		</tr>
		
		</c:when>
		<c:otherwise>
		<c:if test="${examId!=0}">
		</table>
		</c:if>
			
			<table class="table table-striped table-bordered" id="demotable">
			<tr>
			<!-- Changes from inline to external CSS by Apoorv -->
					<th colspan="5" class="dark-blue">
						${candExam.examEventName}
					</th>
					</tr>
			<tr>
					
					<th  style="text-align: center;" width="50%">
						<spring:message code="admindashboard.Paper" />
					</th>
					<th style="text-align: center;">
						<spring:message code="admindashboard.AllocatedCandidates" />
					</th>
					<th style="text-align: center;">
						<spring:message code="admindashboard.Uploaded" />
					</th>
					<th style="text-align: center;">
						<spring:message code="admindashboard.NotUploaded" />
					</th>
					<th style="text-align: center;">
						<b>Upload</b>
					</th>
		
					
				</tr>
	
					<tr>
					<td>
						${candExam.paperName}
					</td>
					<td style="text-align: center;">
					<!-- Changes from inline to external CSS by Apoorv -->
					<h3 class="dashboard-header">${candExam.totalCandidates}</h3>
					</td>			
						<td style="text-align: center;">
						<c:if test="${candExam.uploadFlag!=2}">
							<h3 class="dashboard-header">${candExam.uploadedExamCount}</h3>
						</c:if>
						
						<c:if test="${candExam.uploadFlag==2}">
							<c:set var="noupload" value="1"/>
							<h3 class="dashboard-header">*</h3>
						</c:if>
					</td>
					<td style="text-align: center;">
						<c:if test="${candExam.uploadFlag!=2}">
							<h3 style="color: #297dbc;line-height: 10px;">${candExam.notUploadedExamCount}</h3>
						</c:if>
						
						<c:if test="${candExam.uploadFlag==2}">
							<c:set var="noupload" value="1"/>
							<h3 class="dashboard-header">*</h3>
						</c:if>
					</td>
					
					<td>
					<c:choose>
					<c:when test="${candExam.notUploadedExamCount == 0}">
					<a href="#" class="btn btn-blue" disabled="disabled"><spring:message code="global.upload"/></a></td>
					</c:when>
					<c:otherwise>
					<a data-paperid="${candExam.paperID}" data-eventid="${candExam.examEventID}" class="btn btn-blue uploadBtn"><spring:message code="global.upload"/></a></td>
					</c:otherwise>
					</c:choose>
				</td>
					
				
				</tr>
		</c:otherwise>
		</c:choose>
		
		
		
		<c:set var="examId" value="${candExam.examEventID}"/>
		
		</c:forEach>
		</table>
		 <div class="text-center">
		 <a data-paperid="-1" data-eventid="-1" class="btn btn-blue uploadBtn"><spring:message code="admindashboard.uploadData"/></a>
			</div>	
				<br/>
			<c:if test="${noupload==1}">
					 <div class="alert alert-info">
				     	<h3 style="color: green; line-height: 10px;float: left;">&nbsp;*&nbsp;</h3>-&nbsp; <spring:message code="admindashboard.StarIndicate" />
				    </div>
			</c:if>
		</c:if>
		</div>


		<!-- upload Data -->
		
		<%@include file="dataUpload.jsp"%>
		
		<script type="text/javascript">
			$(document).ready(function() {
				/*  added by YograjS Date 16 Aug 2014 */
				$("#btnok").click(function() {
					location.href="../dashboard/uploadStatus";
				});
			});
		</script>
	</fieldset>
</body>
</html>