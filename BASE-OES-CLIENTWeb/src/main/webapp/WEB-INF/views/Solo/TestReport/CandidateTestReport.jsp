<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page errorPage="../common/jsperror.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib  uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<title><spring:message code="candidateTestReport.title" /></title>
<spring:message code="project.resources" var="resourcespath" />
<style type="text/css">
</style>
</head>
<body>
	<fieldset class="well">
		<div>
			<legend>
				<span><spring:message code="candidateTestReport.heading" /></span>
			</legend>
		</div>
		
		<div class="holder">
			<form:form  class="form-horizontal"  action="CandidateTestReportlist" method="post" onsubmit="return validate(this);">
			<input type="hidden" id="isAdmin" name="isAdmin" value="${isAdmin}"> 
			
				<div class="control-group">
					<label class="control-label" for="inputEmail"><spring:message code="candidateTestReport.examEvent"></spring:message></label>
					<div class="controls">
						<select class="span4" id="examEventSelect" name="examEventSelect">
							<option value="-1" selected="selected"><spring:message code="candidateTestReport.selectExamEvent"></spring:message></option>
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
						</select>
					</div>
				</div>

				<div class="control-group" id="collection">
					<label class="control-label" for="collectionName" id="collection-lbl"><%-- <spring:message code="candidateTestReport.collection" /> --%></label>
					<div class="controls">
						<input type="hidden" id="collectionId" name="collectionId" value="${collectionId}" >
						<select class="span4" id="collectionSelect" name="collectionSelect">
						</select>
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label" for="inputEmail"><spring:message code="candidateTestReport.subject" /></label>
					<div class="controls">
						<select class="span4" id="displayCategorySelect" name="displayCategorySelect">
						</select>
					</div>
				</div>

				<div class="control-group offset1">
					<div class="controls">
						<button type="submit" class="btn btn-blue" ><spring:message code="candidateTestReport.getReport" /></button>
					</div>
				</div>
				
			</form:form>
			</div>
	</fieldset>
	
	
		<fieldset class="well">
			<div class="holder">			
			
			<c:if test="${fn:length(listCandidateTestReportViewModels) != 0}">
			<!--Integrated data table  -->
			<c:set var="srNo" value="${pagination.start+1}" scope="page" />
			<table class="table table-striped table-bordered" id="demotable">
				<thead>
					<tr>
						<th><spring:message code="candidateTestReport.srNo" /></th>
						<th><spring:message code="candidateTestReport.name" /></th>
						<th><spring:message code="candidateTestReport.login" /></th>
						<th><spring:message code="candidateTestReport.userCode" /></th>
						<th><spring:message code="candidateTestReport.noOfTestScheduled" /></th>
						<th><spring:message code="candidateTestReport.noOfTestGiven" /></th>
						<th><spring:message code="candidateTestReport.analysis" /></th>
					</tr>
				</thead>
				<tfoot>
					<tr>
						<th><spring:message code="candidateTestReport.srNo" /></th>
						<th><spring:message code="candidateTestReport.name" /></th>
						<th><spring:message code="candidateTestReport.login" /></th>
						<th><spring:message code="candidateTestReport.userCode" /></th>
						<th><spring:message code="candidateTestReport.noOfTestScheduled" /></th>
						<th><spring:message code="candidateTestReport.noOfTestGiven" /></th>
						<th><spring:message code="candidateTestReport.analysis" /></th>
					</tr>
				</tfoot>
				<c:if test="${fn:length(listCandidateTestReportViewModels) != 0}">
					<tbody>
						<c:forEach var="CandidateTestReportViewModel" items="${listCandidateTestReportViewModels}">
							<tr>
								<td>${srNo}	<c:set var="srNo" value="${srNo+1}" scope="page" /></td>
								<td>${CandidateTestReportViewModel.candidate.candidateFirstName}&nbsp;${CandidateTestReportViewModel.candidate.candidateLastName}</td>
								<td>${CandidateTestReportViewModel.candidate.candidateUserName}</td>
								<td>${CandidateTestReportViewModel.candidate.candidateCode}</td>
								<td>${CandidateTestReportViewModel.scheduledTestCount}</td>
								<td>${CandidateTestReportViewModel.attemptedTestCount}</td>
								
								<td>
									<c:choose>
									<c:when test="${CandidateTestReportViewModel.attemptedTestCount>0 }">
										<a class="btn btn-blue" href="AttemptedPaperTestReport?examEventId=${examEventId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&candidateId=${CandidateTestReportViewModel.candidate.candidateID}"><spring:message code="candidateTestReport.View" /></a>
										
									</c:when>
									<c:otherwise>
										<a class="btn btn-blue" href="#" disabled="true"><spring:message code="candidateTestReport.View" /></a>
									</c:otherwise>
								</c:choose>		
								</td>
							</tr>
						</c:forEach>
					</tbody>

				</c:if>
			</table>
			<c:if test="${fn:length(listCandidateTestReportViewModels) != 0}">
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
				<div class="dataTables_paginate paging_bootstrap pagination" align="right">
					<ul>
						<c:choose>
							<c:when
								test="${disablePrev==true || (fn:length(listCandidateTestReportViewModels)<=pagination.recordsPerPage && pagination.start==0)}">
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
						
						<input type="hidden" id="examEventId" name="examEventId" value="${examEventId}">
						<input type="hidden" id="collectionId" name="collectionId" value="${collectionId}">
						<input type="hidden" id="displayCategoryId" name="displayCategoryId" value="${displayCategoryId}">
						
						<input type="hidden" id="searchText" name="searchText"
							value="${searchText}" />
					</form:form>
					<form:form action="next" method="POST" modelAttribute="pagination"
						id="next_selector_for_the_form">
						<form:hidden path="end" />
						<form:hidden path="start" />
						<form:hidden path="recordsPerPage" />
						
						<input type="hidden" id="examEventId" name="examEventId" value="${examEventId}">
						<input type="hidden" id="collectionId" name="collectionId" value="${collectionId}">
						<input type="hidden" id="displayCategoryId" name="displayCategoryId" value="${displayCategoryId}">
						
						<input type="hidden" id="searchText" name="searchText"
							value="${searchText}" />
					</form:form>
				</div>
			</c:if>
		</c:if>
			</div>
		</fieldset>
	<script type="text/javascript">
	 $(document).ready(function(){
		
			/* populate division and weeks on load  */
		 	examEventID = $('#examEventSelect').val();
			collectionID = $('#collectionId').val();
			displayCategoryID=$('#displayCategoryId').val();
			
			if($('#examEventSelect').val()!=-1)
				{
					var dat = JSON.stringify({ "examEventID" : examEventID }); 
					if (examEventID!=-1) {
						callExamEventAjax(dat,collectionID);	
					}
						

					var dat1 = JSON.stringify({"fkExamEventID" : examEventID , "fkCollectionID" : collectionID }); 
					if (examEventID!=-1 && collectionID !=-1) {
						callCollectionAjax(dat1,displayCategoryID);	
					}
			}else{
				 $("#collection").hide();
			}

			/* examEvent change event */
			$('#examEventSelect').change(function(event) {
				examEventID = $('#examEventSelect').val();
				if (examEventID==-1) {
					$("#collection").hide();
				}
				var dat = JSON.stringify({
					"examEventID" : examEventID
				});
				if (examEventID !=-1) {
					callExamEventAjax(dat,undefined);
				}
				
			}); // end of examEventSelect change event

			$('#collectionSelect').change(function(event) {
				examEventID = $('#examEventSelect').val();
				collectionID = $('#collectionSelect').val();
				var dat = JSON.stringify({
					"fkExamEventID" : examEventID,
					"fkCollectionID" : collectionID
				});
				if (examEventID !=-1 && collectionID!=-1) {
					callCollectionAjax(dat,undefined);
				}
			}); // end of examEventSelect change event

		}); /* End of document ready */

		// Used to get collection list
		function callExamEventAjax(dat,selectedId) {
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
					alert("opps.....");
				}
			}); /* end of ajax */
		}
		
		// Used to get display category list
		function callCollectionAjax(dat,selectedId) {
			$.ajax({
				url : "DisplayCategoryLanguageAccEventDivision.ajax",
				type : "POST",
				data : dat,
				contentType : "application/json",
				dataType : "json",
				success : function(response) {
					displayDisplayCategory(response, selectedId);
				},
				error : function() {
					alert("opps.....");
				}
			}); /* end of ajax */
		}
		function displayCollection(response, selectedId) {
			var isDisplayCategoryAdded=0;
			$("#collectionSelect").find("option").remove();

			  // code to display select all and All option as per user role
			 if ($("#isAdmin").val()==1) {
				 if (selectedId==0) {
					 $("#collectionSelect").append("<option value='0' selected='selected'>--<spring:message code="candidateTestReport.all" /> --</option>");
				}else{
					$("#collectionSelect").append("<option value='0'>--<spring:message code="candidateTestReport.all" /> --</option>");
				}
				 
			}else{
				$("#collectionSelect").append("<option value='-1'>--<spring:message code="candidateTestReport.selectDivision" />--</option>");
			}
			  
			 // If Collection type is None, disable collection ddl and call collection ajax
			 if(response !='NULL' && response[0].collectionType=='None'){
				 $("#collectionSelect").append("<option value='" + response[0].collectionID + "' selected='selected'>"
									+ response[0].collectionName + "</option>");
				// $("#collectionSelect").prop("disabled",true);
				 $("#collection").hide();
				 
				 // call for collection ajax
				 examEventID = $('#examEventSelect').val();
				 collectionID = $('#collectionSelect').val();
				 var dat = JSON.stringify({"fkExamEventID" : examEventID,"fkCollectionID" : collectionID});
				 
				 if (examEventID !=-1 && collectionID !=-1) {					 
					 callCollectionAjax(dat,displayCategoryID);
				}				 
				 isDisplayCategoryAdded=1;
			 }else{
				 if(response !='NULL'){
					if (response[0].collectionType=='Division') {
						$("#collection-lbl").html('<spring:message code="groupLoginPage.Division" />');
					}
					if (response[0].collectionType=='Batch') {
						$("#collection-lbl").html('<spring:message code="groupLoginPage.Batch" />');
					}
					 
				 }
				 // If collection type is division or batch
				  $("#collection").show();
				// $("#collectionSelect").prop("disabled",false);
				 $.each(response, function(i, collectionMaster) {
						if (selectedId && selectedId == collectionMaster.collectionID) {
							$("#collectionSelect").append("<option value='" + collectionMaster.collectionID + "' selected='selected'>"
											+ collectionMaster.collectionName + "</option>");
						} else {
							$("#collectionSelect").append("<option value='" + collectionMaster.collectionID + "'>"
											+ collectionMaster.collectionName + "</option>");
						}
				});
			 }
			
			/* code to fetch subject if user is admin */
			// If displycategory already added(In case collection type is None) then avoid to re-add
			 if ($("#isAdmin").val()==1 && isDisplayCategoryAdded==0) {				
				 var dat1 = JSON.stringify({"fkExamEventID" : examEventID , "fkCollectionID" : collectionID }); 
				if (examEventID!=-1 && collectionID !=-1) {
					callCollectionAjax(dat1,displayCategoryID);
				}	
			 }
		} /* end of displayCollection */

		function displayDisplayCategory(response, selectedId) {
			
			$("#displayCategorySelect").find("option").remove();
			 
			// code to display select all and All option as per user role
			 if ($("#isAdmin").val()==1) {
				 if (selectedId==0) {
					 $("#displayCategorySelect").append("<option value='0' selected='selected'>--<spring:message code="candidateTestReport.all" /> --</option>");
				}else{
					$("#displayCategorySelect").append("<option value='0'>--<spring:message code="candidateTestReport.all" /> --</option>");
				}
			}else{
				$("#displayCategorySelect").append("<option value='-1'>--<spring:message code="candidateTestReport.selectSubject" /> --</option>");
			}

			$.each(response, function(i, item) {
				if (selectedId && selectedId == item.fkDisplayCategoryID) {
					$("#displayCategorySelect").append(
							"<option value='" + item.fkDisplayCategoryID + "' selected='selected'>"
									+ item.displayCategoryName + "</option>");
				} else {
					$("#displayCategorySelect").append(
							"<option value='" + item.fkDisplayCategoryID + "'>"
									+ item.displayCategoryName + "</option>");
				}
			});
		} /* end of displayCollection */
		
		function validate(form) {
			var e = form.elements;
			if(e['examEventSelect'].value==-1)
			{
				alert('<spring:message code="candidateTestReport.selectEvent" />');
				$("#examEventSelect").focus();
				return false;
			} 
			 if(e['collectionSelect'].value==-1)
			{
				alert('<spring:message code="candidateTestReport.selectDivision" />');
				$("#collectionSelect").focus();
				return false;
			} 
			 if(e['displayCategorySelect'].value==-1)
				{
					alert('<spring:message code="candidateTestReport.selectSubject" />');
					$("#displayCategorySelect").focus();
					return false;
				} 
			 
			 $("#collectionId").val($("#collectionSelect").val());
			 
			return true;
		}
		
	</script>
	
	<script type="text/javascript" src="<c:url value='/resources/js/gridDataTable.js'></c:url>"></script>
	<script type="text/javascript">
		$(document).ready(function(){
			
			$("#prev_anchor_tag").click(function() {
				$("#prev_selector_for_the_form").submit();
				return false;
			});

			$("#next_anchor_tag").click(function() {
				$("#next_selector_for_the_form").submit();
				return false;
			});
			
							
		});					
					
	</script>
</body>
</html>