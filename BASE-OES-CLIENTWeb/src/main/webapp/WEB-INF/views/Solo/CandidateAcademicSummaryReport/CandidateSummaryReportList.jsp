<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%-- <%@ page errorPage="../common/jsperror.jsp"%> --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<title><spring:message
		code="candidateAcademicSummaryReport.heading" /></title>
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
			<form:form class="form-horizontal" id="csr" action="CandidateAcademicSummaryReport"
				method="post">
				
				<input type="hidden" id="candidateID" name="candidateID"
					value="${candidateID}">
				
				<input type="hidden" id="userRole" name="userRole"
					value="${userRole}">
				<div class="control-group" style="background:none;">
					<label class="control-label" for="inputEmail"><spring:message
							code="candidateTestReport.examEvent"></spring:message></label>
					<div class="controls inline">
						<select class="span4" id="examEventSelect" name="examEventSelect">
							<option value="-1" selected="selected">
								<spring:message code="candidateTestReport.selectExamEvent"></spring:message>
							</option>
							<c:forEach items="${activeExamEventList }" var="eObj">
								<c:choose>
									<c:when test="${eObj.examEventID==examEventId}">
										<option value="${eObj.examEventID}" selected="selected">${eObj.name}</option>
									</c:when>
									<c:otherwise>
										<option value="${eObj.examEventID}">${eObj.name}</option>
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</select>&nbsp;
						<a href="#" id="advanceSearch"><spring:message
						code="candidateAcademicSummaryReport.advanceSearch" /></a>
					</div>
				</div>

				<div class="control-group" id="collection" style="background:none;">
					<label class="control-label" for="collectionName"
						id="collection-lbl"> </label>
					<div class="controls">
						<input type="hidden" id="collectionId" name="collectionId"
							value="${collectionId}"> <select class="span4"
							id="collectionSelect" name="collectionSelect">
						</select>
					</div>
				</div>
				<div id="candidateSearch" style="display: none;" >
					<div class="control-group" style="background:none;">
						<label class="control-label" for="inputEmail"><spring:message
								code="candidateAcademicSummaryReport.candName" /></label>
						<div class="controls">
							<input type="text" class="span4" id="candidateName"
								name="candidateName" value="${fn:escapeXml(candidateName)}">

						</div>
					</div>

					<div class="control-group" style="background:none;">
						<label class="control-label" for="inputEmail"><spring:message
								code="candidateAcademicSummaryReport.candUserName" /></label>
						<div class="controls">
							<input type="text" class="span4" id="loginId" name="loginId"
								value="${fn:escapeXml(loginId)}">
						</div>
					</div>
					<br /> 
					<div class="control-group" style="background:none;">
						<div class="controls">
							<button type="submit" class="btn btn-blue" name="searchCand"
								id="searchCand" onclick="this.form.target='_self';return true;">
								<spring:message code="candidateAcademicSummaryReport.searchCand" />
							</button>
						</div>
					</div>
				</div>
				<br /> 
				<div id="hideonCandSearch" style="display: block;">
					<div class="control-group">
						<div class="controls">
							<button type="button" class="btn btn-blue" name="generateReport"
								id="generateReport">
								<spring:message
									code="candidateAcademicSummaryReport.generateReport" />
							</button>
							<%-- 	<a class="btn btn-blue btn-small" href="#" id="generateReport"
																class="btn btn-blue">Generate Report</a></td>
																
									<input type="hidden" id="collectionId"
																value="${CandidateSummaryReport.collectionMaster.collectionID}" />
															<input type="hidden" id="candidateId" value="${CandidateSummaryReport.candidate.candidateID}" />
							 --%>
						</div>
					</div>
				</div>
			</form:form>
		</div>
	</fieldset>


	<fieldset class="well">
		<div class="holder">

			<c:if test="${fn:length(listCandidateAcademicSummaryReport) != 0}">
				<!--Integrated data table  -->
				<c:set var="srNo" value="${pagination.start+1}" scope="page" />
				<table class="table table-striped table-bordered" id="demotable">
					<thead>
						<tr>
							<th><spring:message
									code="candidateAcademicSummaryReport.srNo" /></th>
							<th><spring:message
									code="candidateAcademicSummaryReport.candName" /></th>
							<th><spring:message
									code="candidateAcademicSummaryReport.candUserName" /></th>
							<th><spring:message
									code="candidateAcademicSummaryReport.selectAction" /></th>
						</tr>
					</thead>
					<tfoot>
						<tr>
							<th><spring:message
									code="candidateAcademicSummaryReport.srNo" /></th>
							<th><spring:message
									code="candidateAcademicSummaryReport.candName" /></th>
							<th><spring:message
									code="candidateAcademicSummaryReport.candUserName" /></th>
							<th><spring:message
									code="candidateAcademicSummaryReport.selectAction" /></th>
						</tr>
					</tfoot>
					<c:if test="${fn:length(listCandidateAcademicSummaryReport) != 0}">
						<tbody>
							<c:forEach var="CandidateSummaryReport"
								items="${listCandidateAcademicSummaryReport}">
								<tr>
									<td>${srNo} <c:set var="srNo" value="${srNo+1}"
											scope="page" /></td>
									<td>${CandidateSummaryReport.candidate.candidateFirstName}&nbsp;${CandidateSummaryReport.candidate.candidateLastName}</td>
									<td>${CandidateSummaryReport.candidate.candidateUserName}</td>

									<td><a class="btn btn-blue" href="#" onclick="return sendPostRequest( '${examEventId}','${CandidateSummaryReport.collectionMaster.collectionID}', '${CandidateSummaryReport.candidate.candidateID}' )"><spring:message
												code="candidateAcademicSummaryReport.generateReport" /></a>
									
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

							<input type="hidden" id="examEventId" name="examEventId"
								value="${examEventId}">
							<input type="hidden" id="collectionId" name="collectionId"
								value="${collectionId}">
								<input type="hidden" id="candidateName" name="candidateName"
								value="${candidateName}">
								<input type="hidden" id="loginId" name="loginId"
								value="${loginId}">
							
							<input type="hidden" id="searchText" name="searchText"
								value="${searchText}" />
						</form:form>
						<form:form action="next" method="POST" modelAttribute="pagination"
							id="next_selector_for_the_form">
							<form:hidden path="end" />
							<form:hidden path="start" />
							<form:hidden path="recordsPerPage" />

							<input type="hidden" id="examEventId" name="examEventId"
								value="${examEventId}">
							<input type="hidden" id="collectionId" name="collectionId"
								value="${collectionId}">
							<input type="hidden" id="candidateName" name="candidateName"
								value="${candidateName}">
								<input type="hidden" id="loginId" name="loginId"
								value="${loginId}">
							<input type="hidden" id="searchText" name="searchText"
								value="${searchText}" />
						</form:form>
					</div>
				</c:if>
			</c:if>
		</div>
		<a style="display: none;" id="lnk" href="#" download>click me</a>
	</fieldset>
	<script type="text/javascript">
		$(document).ready(function() {
			var collection="";
			 if($('#candidateName').val()!="" || $('#loginId').val()!="")
				{
				$("#candidateSearch").css("display", "block");
				$("#hideonCandSearch").css("display", "none");

			} else {
				$("#candidateSearch").css("display", "none");
				$("#hideonCandSearch").css("display", "block");
			} 
				
			
			/*If search for specific candidate is enabled than show search area */
			
			$('#advanceSearch').click(function(){
			
					 $('#candidateSearch, #hideonCandSearch').toggle();
				
			});
			/* populate division and weeks on load  */
			examEventID = $('#examEventSelect').val();
			collectionID = $('#collectionId').val();

			if ($('#examEventSelect').val() != -1) {
				var dat = JSON.stringify({
					"examEventID" : examEventID
				});
				callExamEventAjax(dat, collectionID);

			} else {
				$("#collection").hide();
			}

			/* examEvent change event */
			$('#examEventSelect').change(function(event) {
				examEventID = $('#examEventSelect').val();
				//alert(examEventID);
				if (examEventID == -1) {
					$("#collection").hide();
				}
				var dat = JSON.stringify({
					"examEventID" : examEventID
				});
				
				callExamEventAjax(dat, undefined);
			}); // end of examEventSelect change event

		}); /* End of document ready */

		// Used to get collection list
		function callExamEventAjax(dat, selectedId) {
	//alert("calling..."+selectedId);
			$.ajax({
				url : "collectionMasterAccEventRole.ajax",
				type : "POST",
				data : dat,
				contentType : "application/json",
				dataType : "json",
				success : function(response) {
					
					displayCollection(response, selectedId);
				},
				error : function() {
					alert('<spring:message code="candidateAcademicSummaryReport.errorMsg"/>');
					//alert("oops...something went wrong!");
				}
			}); /* end of ajax */
		}

		function displayCollection(response, selectedId) {
			//alert("calling again..."+selectedId);
			
			$("#collectionSelect").find("option").remove();

			 
			// code to display select all and All option as per user role

			if ($("#userRole").val() == 1) {
				if (selectedId == 0) {
					$("#collectionSelect")
							.append(
									"<option value='0' selected='selected'><spring:message code="candidateAcademicSummaryReport.allOption" /></option>");
				} else {
					$("#collectionSelect").append(
							"<option value='0'><spring:message code="candidateAcademicSummaryReport.allOption" /></option>");
				}

			} else {
				$("#collectionSelect").append(
						"<option value='-1'>--Select "+ response[0].collectionType +" --</option>");
			}

			// If Collection type is None, hide collection ddl and set collection Id of that collection.
			collection=response[0].collectionType;
			//alert(collection);
			if (response != 'NULL' && response[0].collectionType == 'None') {
				$("#collectionSelect").append(
						"<option value='" + response[0].collectionID + "' selected='selected'>"
								+ response[0].collectionName + "</option>");				
				
				$("#collection").hide();
				
			} else {
				if (response != 'NULL') {
					//$("#collection-lbl").html(response[0].collectionType);
					if(response[0].collectionType=='Division')
					  {
						 $("#collection-lbl").html("<spring:message code="DisplayCategory.divisions" />");
						 collectionType=  "<spring:message code="DisplayCategory.divisions" />";
					  }else if(response[0].collectionType=='Batch')
						  {
						  $("#collection-lbl").html("<spring:message code="DisplayCategory.batch" />");
						  collectionType="<spring:message code="DisplayCategory.batch" />";
						  }  
				}
				// If collection type is division or batch
				$("#collection").show();
				// $("#collectionSelect").prop("disabled",false);
				$.each(response, function(i, collectionMaster) {
					if (selectedId
							&& selectedId == collectionMaster.collectionID) {
						$("#collectionSelect").append(
								"<option value='" + collectionMaster.collectionID + "' selected='selected'>"
										+ collectionMaster.collectionName
										+ "</option>");
					} else {
						$("#collectionSelect").append(
								"<option value='" + collectionMaster.collectionID + "'>"
										+ collectionMaster.collectionName
										+ "</option>");
					}
				});
			}

		} /* end of displayCollection */

		function validate(form) {
			var e = form.elements;
			if (e['examEventSelect'].value == -1) {
				//alert('Select Exam Event');
				alert('<spring:message code="candidateAcademicSummaryReport.selectEventMsg" />');
				$("#examEventSelect").focus();
				return false;
			}
			if (e['collectionSelect'].value == -1) {
				alert('<spring:message code="candidateAcademicSummaryReport.selectMsg" />'+ collection);
				//alert("Select " + collection);
				$("#collectionSelect").focus();
				return false;
			}
			
			$("#collectionId").val($("#collectionSelect").val());

			return true;
		}
	</script>

	<script type="text/javascript" src="<c:url value='/resources/js/gridDataTable.js'></c:url>"></script>
	<script type="text/javascript">
	
	function sendPostRequest(exameventID, collectionID,candidateID){
		
		if(validate(document.getElementById('csr')))
		{
			$('#lnk').attr('href', "");
			var dat = JSON.stringify({
				
						"examEventID" 	:exameventID,
						"collectionID" 	: collectionID,
						"candidateID"	: candidateID
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
								
								alert("PDF generation failed");
							}

						},
						error : function() {
							
							alert("Error while generating PDF.");
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
			$("#generateReport").click(function(e) {
				e.preventDefault();	
				sendPostRequest($('#examEventSelect').val(),$("#collectionId").val(),$("#candidateId").val());

			});
			

	}); // document.ready
	</script>
</body>
</html>