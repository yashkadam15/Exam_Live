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
</style>
</head>
<body>
	<fieldset class="well">
		<div>
			<legend>
				<span><spring:message code="candidateloginReport.title" /></span>
			</legend>
		</div>
		
		<div class="holder">
			<form:form  class="form-horizontal"  action="candidateloginReportList" method="post" onsubmit="return validate(this);">
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
					<label class="control-label" for="collectionName" id="collection-lbl"><spring:message code="candidateTestReport.collection" /></label>
					<div class="controls">
					<input type="hidden" id="collectionId" name="collectionId" value="${collectionID}">
						<select class="span4" id="collectionTypeSelect" name="collectionTypeSelect">
						
						</select>
					</div>
				</div>
				
				<%-- <div class="control-group">
					<label class="control-label" for="inputEmail"><spring:message code="candidateTestReport.selectSubject" /></label>
					<div class="controls">
						<select class="span4" id="subjectSelect" name="subjectSelect">
						</select>
					</div>
				</div> --%>

			
					<div class="controls">
						<button type="submit" class="btn btn-blue" ><spring:message code="candidateTestReport.getReport" /></button>
							<input type="button" class="btn btn-blue" id="genpdfbutton" name="genpdfbutton" value='<spring:message code="GroupReport.generatePDF" />'/>
					</div>
				
				
				
			</form:form>
			<form:form id="generatepdf" target="blank"  action="../loginReport/downloadCandidateLoginReport" >
			<input type="hidden" id="examId" name="examEventId" value="">
						<input type="hidden" id="collectionID" name="collectionID" value="">
			<input type="hidden" id="collectionName" name="collectionName" value="">
			<input type="hidden" id="exameventName" name="exameventName" value="">
			</form:form>
				
			</div>
	</fieldset>
	
	
		<fieldset class="well">
			<div class="holder">
			<a style="display: none;" id="lnk" href="#" download>click me</a>
			
			<c:if test="${fn:length(listCandidateTestReportViewModels) != 0}">
			<!--Integrated data table  -->
			<c:set var="srNo" value="${pagination.start+1}" scope="page" />
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
				<c:if test="${fn:length(listCandidateTestReportViewModels) != 0}">
					<tbody>
						<c:forEach var="CandidateTestReportViewModel" items="${listCandidateTestReportViewModels}">
							<tr>
								<td>${srNo}	<c:set var="srNo" value="${srNo+1}" scope="page" /></td>
								<td>${CandidateTestReportViewModel.candidate.candidateFirstName}&nbsp;${CandidateTestReportViewModel.candidate.candidateLastName}</td>
								<td>${CandidateTestReportViewModel.candidate.candidateCode}</td>
								<td>${CandidateTestReportViewModel.candidate.candidateUserName}</td>							
								<%-- <td>${CandidateTestReportViewModel.candidate.candidatePassword}</td> --%>
						         <td>
						         <c:choose>
						         	<c:when test="${CandidateTestReportViewModel.candidate.candidatePhoto!= null and fn:length(CandidateTestReportViewModel.candidate.candidatePhoto) > 0 and fn:startsWith(CandidateTestReportViewModel.candidate.candidatePhoto, 'http')}">
										<div class="dp"><img  class="imageSize" src="<c:url value="${CandidateTestReportViewModel.candidate.candidatePhoto}"></c:url>" onerror="this.src='${imgPath}<spring:message code="instruction.defaultPhoto"/>';"></div>
									</c:when>
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
						<input type="hidden" id="collectionID" name="collectionID" value="${collectionID}">
						
						
						<input type="hidden" id="searchText" name="searchText"
							value="${searchText}" />
					</form:form>
					<form:form action="next" method="POST" modelAttribute="pagination"
						id="next_selector_for_the_form">
						<form:hidden path="end" />
						<form:hidden path="start" />
						<form:hidden path="recordsPerPage" />
						
						<input type="hidden" id="examEventId" name="examEventId" value="${examEventId}">
						<input type="hidden" id="collectionID" name="collectionID" value="${collectionID}">
						
						
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
		 $("#collection").hide();
			/* populate division and weeks on load  */
		 	examEventID = $('#examEventSelect').val();
			collectionID = $('#collectionId').val();
		
		
			
			if($('#examEventSelect').val()!=-1)
				{
				
					var dat = JSON.stringify({ "examEventID" : examEventID }); 
					$("#collectionTypeSelect option").remove();
					callExamEventAjax(dat,collectionID);		

				}
			else{
				$("#collection").hide();				
			}

			/* examEvent change event */
			$('#examEventSelect').change(function(event) {
				
				$("#collection").hide();	
				examEventID = $('#examEventSelect').val();
				collectionID = $("#collectionId").val();
			
				var dat = JSON.stringify({
					"examEventID" : examEventID
				});
				$("#collectionTypeSelect option").remove();
				callExamEventAjax(dat,collectionID);
			}); // end of examEventSelect change event

			/* $('#collectionTypeSelect').change(function(event) {
				examEventID = $('#examEventSelect').val();
				collectionID = $('#collectionTypeSelect').val();
				var dat = JSON.stringify({
					"fkExamEventID" : examEventID,
					"fkcollectionID" : collectionID
				});
				callDivisionAjax(dat,undefined);
			}); // end of examEventSelect change event */

		}); /* End of document ready */

		var collectionType="";
		
		function callExamEventAjax(dat,selectedId) {
			$.ajax({
				url : "collectionAccEventRole.ajax",
				type : "POST",
				data : dat,
				contentType : "application/json",
				dataType : "json",
				success : function(response) {
					displayCollection(response, selectedId);
				},
				error : function() {
					/* alert("opps....."); */
				}
			}); /* end of ajax */
		}
		
		function displayCollection(response, selectedId) {
			// collectionType = response[0].collectionType;
			 
			 if(response[0].collectionType=='Division')
			  {
				 $("#collection-lbl").html("<spring:message code="groupLoginPage.Division" />");
				 collectionType=  "<spring:message code="groupLoginPage.Division" />";
			  }else if(response[0].collectionType=='Batch')
				  {
				  $("#collection-lbl").html("<spring:message code="groupLoginPage.Batch" />");
				  collectionType="<spring:message code="groupLoginPage.Batch" />";
				  }  
			 
			 
			$("#collectionTypeSelect").find("option").remove();

			  // code to display select all and All option as per user role
			 if ($("#isAdmin").val()==1) {
				 if (selectedId==0) {
					 $("#collectionTypeSelect").append("<option value='0' selected='selected' ><spring:message code="candidateAcademicSummaryReport.allOption"/></option>");
				}else{
					$("#collectionTypeSelect").append("<option value='0'><spring:message code="candidateAcademicSummaryReport.allOption"/></option>");
				}
				 
			}else{
				$("#collectionTypeSelect").append("<option value='-1'>--<spring:message code="scheduleExam.cselect"/> "+collectionType+" --</option>");
			}

			 // If Collection type is None, disable collection ddl and call collection ajax
			 if(response !='NULL' && response[0].collectionType=='None'){
				 $("#collectionTypeSelect").append("<option value='" + response[0].collectionID + "' selected='selected'>"
									+ response[0].collectionName + "</option>");
				// $("#collectionSelect").prop("disabled",true);
				 $("#collection").hide();

			 }else{
				 if(response !='NULL'){
					 $("#collection-lbl").html(collectionType);
				 }
				 // If collection type is division or batch
				  $("#collection").show();
			 
			$.each(response, function(i, item) {
				if (selectedId && selectedId == item.collectionID) {
					
					$("#collectionTypeSelect").append(
							"<option value='" + item.collectionID + "' selected='selected' readonly='readonly'>"
									+ item.collectionName + "</option>");
					
				} else {
					$("#collectionTypeSelect").append(
							"<option value='" + item.collectionID + "'>"
									+ item.collectionName + "</option>");
				}
			});
			 }
		} /* end of displayCollection */


		
		function validate(form) {
			var e = form.elements;
			if(e['examEventSelect'].value==-1)
			{
				alert('<spring:message code="examevent.selectalertMessage" />');
				$("#examEventSelect").focus();
				return false;
			} 
			 if(e['collectionTypeSelect'].value==-1)
			{
				 alert('<spring:message code="select.labelalertMsg" /> '+collectionType);
				$("#collectionTypeSelect").focus();
				return false;
			} 
			
			 
			return true;
		}
		
	</script>

	<script type="text/javascript" src="<c:url value='/resources/js/gridDataTable.js'></c:url>"></script>
	<script type="text/javascript">
	$(document)
	.ready(
			function() {
				$('#demotable').dataTable({
					
					 "sDom" : "<'row-fluid'<'span4'><'span8'f>r>t<'row-fluid'<'span4'><'span8'>>",
					"aaSorting" : [ [ 0, "asc" ] ],
					"iDisplayLength" : -1,
					

					"oTableTools" : {
						"sSwfPath" : "../resources/media/csv_xls_pdf.swf",
						"aButtons" : [
							
								{
									"sExtends" : "collection",
									"sButtonText" : 'Export To PDF <span class="caret" />',
									"aButtons" : [
											"pdf" ]
								} ]
					} 
					
				});
			
			$("#prev_anchor_tag").click(function() {
				$("#prev_selector_for_the_form").submit();
				return false;
			});

			$("#next_anchor_tag").click(function() {
				$("#next_selector_for_the_form").submit();
				return false;
			});
			
			$('#go').click(function() {
						var searchText = $('#search').val();
						var eventID = $('#examEventSelect').val();
						var collectId=$('#collectionTypeSelect').val();
						window.location.href = 'searchCandiate?searchText='	+ searchText+'&examEventSelect='+eventID+'&collectionTypeSelect='+collectId;
					});
			
			$('#genpdfbutton').click(function(){
				 if($("#examEventSelect").val()==-1){
					alert('<spring:message code="examevent.selectalertMessage" />');
					return false;
				}
				if($("#collectionTypeSelect").val()==null || $("#collectionTypeSelect").val()== -1)
				{
						alert('<spring:message code="select.labelalertMsg" /> '+collectionType);
						$("#collectionTypeSelect").focus();
						return false;
				} 
				$("#exameventName").val($('#examEventSelect option:selected').text());
				$("#collectionName").val($('#collectionTypeSelect option:selected').text());
				$("#examId").val($("#examEventSelect").val());
				$("#collectionID").val($("#collectionTypeSelect").val());	
	
				/*$('#generatepdf').submit(); */
				
				var eventID = $('#examEventSelect').val();
				var collectionId=$('#collectionTypeSelect').val();
				var eventName=$("#exameventName").val();
				var collectionName=$("#collectionName").val();
				
				var dat = JSON.stringify({ "examEventID" : examEventID, "collectionId":collectionId, "eventName":eventName, "collectionName":collectionName }); 
				// console.log(dat);
				$.ajax({
					url : "downloadCandidateLoginReport",
					type : "POST",
					data : dat,
					contentType : "application/json",
					/* dataType : "json", */
					success : function(response) {
						if(response)
						{
				            $('#lnk').attr('href', "../" + response);
				            $('#lnk')[0].click();
						}
						else
						{
							alert('<spring:message code="candidateAttempt.noDataFound"/>');
						}
					},
					error : function() {
						alert('<spring:message code="candidateAttempt.errorGeneratingPDF"/>');
					}
				}); /* end of ajax */	
				
				
			});
			
			
							
		});					
					
	</script>
</body>
</html>