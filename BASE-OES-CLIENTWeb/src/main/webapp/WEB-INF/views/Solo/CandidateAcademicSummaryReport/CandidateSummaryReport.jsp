<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%-- <%@ page errorPage="../common/jsperror.jsp"%> --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<title><spring:message code="candidateAcademicSummaryReport.heading" /></title>
<spring:message code="project.resources" var="resourcespath" />
<style type="text/css">
</style>
</head>
<body>
	<fieldset class="well">
		<div>
			<legend>
				<span><spring:message
						code="candidateAcademicSummaryReport.heading" /></span>
			</legend>
		</div>

		<div class="holder">
			<form:form class="form-horizontal" id="csr"
				action="CandidateAcademicSummaryReport" method="post">
				<%-- <input type="hidden" name="examEventId" value="${sessionScope.user.examEvent.examEventID}">	
				 --%>
				 
				 <input type="hidden" name="collectionId" value="${sessionScope.user.collectionID}"> 
				<input type="hidden" name="candidateId" value="${sessionScope.user.venueUser[0].object}"> 
				<input type="hidden" id="userRole" name="userRole" value="${userRole}">
				<div class="control-group" style="background:none;">
					<label class="control-label" for="displayCategoryName"
						id="displayCategory-lbl"> <spring:message code="candidateAcademicSummaryReport.selectdisplayCategory" /></label>
					
					<div class="controls">
					
						<select class="span4" id="displayCategorySelect" name="displayCategorySelect">
							
							<option value="0"><spring:message code="candidateAcademicSummaryReport.allOption" /></option>
							<c:forEach items="${displayCategoryList }" var="eObj">									
									<c:choose>
									<c:when test="${eObj.fkDisplayCategoryID==displayCategoryId}">
										<option value="${eObj.fkDisplayCategoryID}" selected="selected">${eObj.displayCategoryName}</option>
									</c:when>
									<c:otherwise>
										<option value="${eObj.fkDisplayCategoryID}">${eObj.displayCategoryName}</option>
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</select>
					</div>
				</div>
				<div class="control-group" style="background:none;">
					<div class="controls">
						<button type="submit" class="btn btn-blue" name="showReport"
							id="showReport">
							<spring:message code="candidateAcademicSummaryReport.show" />
						</button>
					</div>
					
				</div>
			</form:form>
		</div>
	</fieldset>


	<fieldset class="well">
		<div class="holder">

			<c:if test="${fn:length(listCandidateAcademicSummaryReport) != 0}">
			<div class="control-group pull-right">
					<div class="controls">
			<a class="btn btn-blue" href="#" onclick="return sendPostRequest( '${sessionScope.user.examEvent.examEventID}','${sessionScope.user.collectionID}', '${sessionScope.user.venueUser[0].object}' )"><spring:message code="candidateAcademicSummaryReport.generateReport" /></a>
					</div>
					</div>			
				<!--Integrated data table  -->
				<c:set var="srNo" value="${pagination.start+1}" scope="page" />
				<table class="table table-striped table-bordered" id="demotable">
					<thead>
						<tr>
							<th><spring:message
									code="candidateAcademicSummaryReport.srNo" /></th>
							<th><spring:message
									code="candidateAcademicSummaryReport.dispCategory" /></th>
							<th><spring:message
									code="candidateAcademicSummaryReport.paper" /></th>
							<th><spring:message
									code="bulkEndExam.attemptno" /></th>
							<th><spring:message
									code="candidateAcademicSummaryReport.totalMarks" /></th>
							<th><spring:message
									code="candidateAcademicSummaryReport.markObtain" /></th>
									<th><spring:message
									code="candidateAcademicSummaryReport.TotalTime" /></th>
							<th><spring:message
									code="candidateAcademicSummaryReport.timeTaken" /></th>
							<th><spring:message
									code="candidateAcademicSummaryReport.dateAppeared" /></th>
						</tr>
					</thead>
					<tfoot>
						<tr>
							<th><spring:message
									code="candidateAcademicSummaryReport.srNo" /></th>
							<th><spring:message
									code="candidateAcademicSummaryReport.dispCategory" /></th>
							<th><spring:message
									code="candidateAcademicSummaryReport.paper" /></th>
									<th><spring:message
									code="bulkEndExam.attemptno" /></th>
							<th><spring:message
									code="candidateAcademicSummaryReport.totalMarks" /></th>
							<th><spring:message
									code="candidateAcademicSummaryReport.markObtain" /></th>
									<th><spring:message
									code="candidateAcademicSummaryReport.TotalTime" /></th>
							<th><spring:message
									code="candidateAcademicSummaryReport.timeTaken" /></th>
							<th><spring:message
									code="candidateAcademicSummaryReport.dateAppeared" /></th>
						</tr>
					</tfoot>
					<c:if test="${fn:length(listCandidateAcademicSummaryReport) != 0}">
						<tbody>
							<c:forEach var="obj" items="${listCandidateAcademicSummaryReport}">
								<tr>
									<td>${srNo} <c:set var="srNo" value="${srNo+1}"
											scope="page" /></td>
									<td>${obj.displayCategoryLanguage.displayCategoryName }</td>
									<td>${obj.paper.name }<!-- [Attempt #${obj.candidateExam.attemptNo }] --></td>
									<td>${obj.attemptNo}</td>
									<td>${obj.paperMarks.totalMarks }</td>
									<td>${obj.candidateExam.marksObtained }</td>
									<td>${obj.paper.duration }</td>
									<td>${obj.candidateExam.elapsedTime }</td>
									<td><fmt:formatDate type="date"
											value="${obj.candidateExam.attemptDate }"/></td>


								</tr>
							</c:forEach>
						</tbody>

					</c:if>
				</table>
				<c:if test="${fn:length(listCandidateAcademicSummaryReport) != 0}">
					<!--Display count of records  -->
					<div class="span5">
						<spring:message code="global.pagination.showing"></spring:message>
						${pagination.start+1} - ${pagination.end}
						<spring:message code="global.pagination.of"></spring:message>
						<c:choose>
							<c:when test="${disableNext==true}">
							${pagination.end}
						</c:when>
							<c:otherwise>
								<spring:message code="list.Many" />
							</c:otherwise>
						</c:choose>
					</div>

					<!--Display pagination buttons  -->
					<div class="dataTables_paginate paging_bootstrap pagination"
						align="right">
						<ul>
							<c:choose>
								<c:when
									test="${disablePrev==true || (fn:length(listCandidateAcademicSummaryReport)<=pagination.recordsPerPage && pagination.start==0)}">
									<li class="prev"><a href="#" id="prev_anchor_tag"
										style="display: none;">← <spring:message
												code="global.previous"></spring:message>
									</a></li>
								</c:when>
								<c:otherwise>
									<li class="prev"><a href="#" id="prev_anchor_tag">← <spring:message
												code="global.previous"></spring:message>
									</a></li>
								</c:otherwise>
							</c:choose>
							<c:choose>
								<c:when test="${disableNext==true}">
									<li class="next"><a href="#" id="next_anchor_tag"
										style="display: none;"><spring:message code="global.next"></spring:message>
											→ </a></li>
								</c:when>
								<c:otherwise>
									<li class="next"><a href="#" id="next_anchor_tag"><spring:message
												code="global.next"></spring:message> → </a></li>
								</c:otherwise>
							</c:choose>
						</ul>
						<!--Form For previous,next buttons  -->
						<form:form action="prev" method="POST" modelAttribute="pagination"
							id="prev_selector_for_the_form" name="prev_selector_for_the_form">
							<form:hidden path="end" />
							<form:hidden path="start" />
							<form:hidden path="recordsPerPage" />

							<%-- <input type="hidden" id="examEventId" name="examEventId"
								value="${examEventId}"> --%>	
							<input type="hidden" name="examEventId" value="${sessionScope.user.examEvent.examEventID}"> 						
							<input type="hidden" id="displayCategoryId"
								name="displayCategoryId" value="${displayCategoryId}">
								
							<input type="hidden" name="collectionId" value="${sessionScope.user.collectionID}">
							<input type="hidden" name="candidateId" value="${sessionScope.user.venueUser[0].object}"> 
							<input type="hidden" id="searchText" name="searchText"
								value="${searchText}" />
						</form:form>
						<form:form action="next" method="POST" modelAttribute="pagination"
							id="next_selector_for_the_form">
							<form:hidden path="end" />
							<form:hidden path="start" />
							<form:hidden path="recordsPerPage" />

							<%-- <input type="hidden" id="examEventId" name="examEventId"
								value="${examEventId}">	 --%>
								<input type="hidden" name="examEventId" value="${sessionScope.user.examEvent.examEventID}">						
							 <input type="hidden" id="displayCategoryId"
								name="displayCategoryId" value="${displayCategoryId}">
							<input type="hidden" name="collectionId" value="${sessionScope.user.collectionID}">
							<input type="hidden" name="candidateId" value="${sessionScope.user.venueUser[0].object}"> 
							
							<input type="hidden" id="searchText" name="searchText"
								value="${searchText}" />
						</form:form>
					</div>
				</c:if>
			</c:if>
		</div>
		<a style="display: none;" id="lnk" href="#" download>click me</a>
	</fieldset>


	<script type="text/javascript" src="<c:url value='/resources/js/gridDataTable.js'></c:url>"></script>
	<script type="text/javascript">
	
	function validate(form) {
		var e = form.elements;
					
		if (e['displayCategorySelect'].value == -1) {
			alert('<spring:message code="candidateAcademicSummaryReport.selectDisplayCategoryMsg" />');
			$("#displayCategorySelect").focus();
			return false;
			
		}	
		return true;
	}
	
	function sendPostRequest(exameventID, collectionID,candidateID){
	
		if(validate(document.getElementById('csr')))
		{
			$('#lnk').attr('href', "");
			var dat = JSON.stringify({
				
						"examEventID" 	: exameventID,
						"collectionID" 	: collectionID,
						"candidateID"	: candidateID,
					});
		
			
					$.ajax({
						url : "../candidateReport/CasReportFromHtml",
						type : "POST",
						data : dat,
						contentType : "application/json",

						success : function(response) {
							if (response) {
								$('#lnk').attr('href', "../" + response);
					            $('#lnk')[0].click();
							
							} else {
								
								alert('<spring:message code="candidateSummaryReport.pdfGenerationFailed" />');
							}

						},
						error : function() {
							
							alert('<spring:message code="candidateAttempt.errorGeneratingPDF" />');
						}
					});
		}
		
		
	}
	
		$(document).ready(function() {

			$("#prev_anchor_tag").click(function() {
				$("#prev_selector_for_the_form").submit();
				return false;
			});

			$("#next_anchor_tag").click(function() {
				$("#next_selector_for_the_form").submit();
				return false;
			});
			
			
			
			// generate  pdf from html
			/* $("#showReport").click(function(e) {
			
				e.preventDefault();	
				sendPostRequest(${sessionScope.user.examEvent.examEventID},${sessionScope.user.collectionID},${sessionScope.user.venueUser[0].object});

			}) */;

		});
	</script>
</body>
</html>