<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib  uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<title><spring:message code="exameventcertificate.header"/></title>
<spring:message code="project.resources" var="resourcespath" />
<link rel="stylesheet" type="text/css" href="<c:url value='/resources/style/dataTable.css'></c:url>" />
<style type="text/css">

/* .panel-primary {
border-color: #4e9ea3;
}
.table {
margin-bottom: 12px;
}
.panel {
padding-bottom:0.6px;
padding-top:5px;
padding-left:10px;
padding-right:10px;
margin-bottom: 20px;
background-color: white;
border: 1px solid #DDD;
border-radius: 10px;
border-color: #4e9ea3;
-webkit-box-shadow: 0 1px 1px rgba(0, 0, 0, 0.05);
box-shadow: 0 1px 1px rgba(0, 0, 0, 0.05);
}
.panel-title {
margin-top: 0;
margin-bottom: 0;
font-size: 17.5px;
font-weight: 500;
}
.panel-primary .panel-heading {
color: white;
background-color: #4e9ea3;
border-color: #4e9ea3;
}
.panel-heading {
padding: 10px 15px;
margin: -15px -11px 15px;
background-color: whiteSmoke;
border-bottom: 1px solid #DDD;
border-top-right-radius: 12px;
border-top-left-radius: 12px;
} */
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
			<span> <spring:message code="exameventcertificate.header"/></span>
			</legend>
		</div>
		
		<div class="holder">
			<form:form  class="form-horizontal"  action="candidateList" method="post" onsubmit="return validate();">
						
				<div class="control-group">
					<label class="control-label"><spring:message code="candidateTestReport.examEvent"></spring:message></label>
					<div class="controls">
						<select class="span4" id="examEventSelect" name="examEventSelect">
							<%-- <c:if test="${activeExamEventList !=null && fn:length(activeExamEventList)>1}">
								<option value="-1" selected="selected"><spring:message code="candidateTestReport.selectExamEvent"></spring:message></option>	
							</c:if> --%>
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

               <div class="control-group" style="background:none; ">
				<div    id="paper">
					<label class="control-label" for="paperName" id="paper-lbl"><spring:message code="scoreCard.Paper"/> </label>
					<div class="controls" >
						<input type="hidden" id="paperId" name="paperId" value="${paperId}" >
						<input type="hidden" id="showResultType" name="showResultType" value="${showResultType}" >
						<input type="hidden" id="certificateTemplateID" name="certificateTemplateID" value="${certificateTemplateID}" >
						<input type="hidden" id="failCertificateTemplateID" name="failCertificateTemplateID" value="${failCertificateTemplateID}">
						<input type="hidden" id="isPassingConcept" name="isPassingConcept" value="${isPassingConcept}">
						<input type="hidden" id="paperType" name="paperType" value="${paperType}">
						<%-- <input type="hidden" id="isFailedCertificateIdExist" name="isFailedCertificateIdExist" value="${paperId}" > --%>
						<select class="span4" id="paperSelect" name="paperSelect">
						</select>
					</div>
				</div>
				</div>
				
			<%-- 	<div class="control-group" id="attemptDate">
					<label class="control-label" for="attemptDate" id="attemptDate-lbl"><spring:message code="certificate.Date"/></label>
					<div class="controls">
						<input type="hidden" id="paperAttemptDate" name="paperAttemptDate" value="${paperAttemptDate}" >
						<select class="span4" id="paperAttemptDateSelect" name="paperAttemptDateSelect">
						</select>
					</div>
				</div>				
				 --%>

				<div>
					<div class="controls">
						<button type="submit" class="btn btn-blue" ><spring:message code="EventSelection.Proceed"/></button>
					</div>
				</div>
				
			</form:form>
			</div>
	</fieldset>
	
	<fieldset class="well">
			<div class="holder">			
			<form:form  class="form-horizontal"  action="printCertificate" method="post" onsubmit="return validateCandidateSelection();">
			
					
			<c:if test="${fn:length(listCandidateExam) != 0}">
			

			<!--Integrated data table  -->
			<c:set var="srNo" value="${pagination.start+1}" scope="page" />
			<table class="table table-striped table-bordered" id="tblpassCandidateList">
				<thead>
					<tr>
						<th><spring:message code="candidateTestReport.srNo" /></th>
						<th><spring:message code="candidateTestReport.name" /></th>
						<th><spring:message code="candidateTestReport.login" /></th>
						<th><spring:message code="candidateTestReport.userCode" /></th>
						<th><spring:message code="certificate.examcompletelabel"/></th>
						<th><spring:message code="presentreport.status"/></th>
						<th><spring:message code="admindashboard.Uploaded"/></th>						
						<th><spring:message code="select.labelalertMsg"/> <input type="checkbox" id="selectAllpass" name="selectAllpass"></th>
					</tr>
				</thead>
				<tfoot>
					<tr>
						<th><spring:message code="candidateTestReport.srNo" /></th>
						<th><spring:message code="candidateTestReport.name" /></th>
						<th><spring:message code="candidateTestReport.login" /></th>
						<th><spring:message code="candidateTestReport.userCode" /></th>
						<th><spring:message code="certificate.examcompletelabel"/></th>
						<th><spring:message code="presentreport.status"/></th>
						<th><spring:message code="admindashboard.Uploaded"/></th>						
						<th><spring:message code="select.labelalertMsg"/></th>
					</tr>
				</tfoot>
				
					<tbody>
						<c:forEach var="CandidateExam" items="${listCandidateExam}">
						
					<%-- 	<c:if test="${(CandidateExam.marksObtained >= objPassingMarks) || objPassingMarks==0.0}"> --%>
							<tr>
							<%-- 	<c:set var="status" value="fail" scope="page" /> --%>
								<td>${srNo}	<c:set var="srNo" value="${srNo+1}" scope="page" /></td>
								<td>${CandidateExam.candidate.candidateFirstName}&nbsp;${CandidateExam.candidate.candidateLastName}</td>
								<td>${CandidateExam.candidate.candidateUserName}</td>
								<td>${CandidateExam.candidate.candidateCode}  </td>
								<td>
									<c:choose>
										<c:when test="${CandidateExam.isExamCompleted==false && CandidateExam.attemptDate==null}">
										 <spring:message code="certificate.notAttempted"/>
										</c:when>
										<c:when test="${CandidateExam.isExamCompleted==false && CandidateExam.attemptDate!=null}">
											<spring:message code="scoreCard.InComplete"/>
										</c:when>
										<c:when test="${CandidateExam.isExamCompleted==true && CandidateExam.endDate != null}">
											<fmt:formatDate type="both" dateStyle="medium" timeStyle="medium" value="${CandidateExam.endDate}" />										
										</c:when>
									</c:choose>								
									
								</td>
								<td>
							
							    <!-- check show result is true or not  -->
								<c:choose>
								<c:when test="${ objPassingMarks!=0.0 &&  not empty objPassingMarks  && showResultType =='Yes' && isPassingConcept==true}">								
								<c:choose>
								<c:when test="${(CandidateExam.marksObtained >= objPassingMarks) }">
								<spring:message code="viewtestscore.Pass"/>
								</c:when>
								<c:otherwise>
								<c:if test="${  failCertificateTemplateID!=null && failCertificateTemplateID!=0 && objPassingMarks!=0.0 && isPassingConcept==true}"> 
								<spring:message code="viewtestscore.Fail"/>
								</c:if>
								</c:otherwise>
								</c:choose>
								</c:when>
								<c:otherwise>
								<c:choose>
								<c:when test="${showResultType =='Yes' && empty objPassingMarks}">
								<spring:message code="viewtestscore.NA"/>
								</c:when>
								<c:otherwise>
								</c:otherwise>
								</c:choose>								
								</c:otherwise>
								</c:choose>
								
								</td>
								<td>
								<c:choose>
									<c:when test="${CandidateExam.uploadFlag==1}">
										<spring:message code="Exam.Yes" />
									</c:when>
									<c:when test="${CandidateExam.uploadFlag==0}">
										<spring:message code="Exam.No" />
									</c:when>
								</c:choose>
								</td>
								
								<td>
								<c:choose>
								<c:when test="${(CandidateExam.marksObtained >= objPassingMarks) || objPassingMarks==0.0 || empty objPassingMarks}">
								<c:choose>
										<c:when test="${CandidateExam.isExamCompleted!=null && CandidateExam.isExamCompleted==true && CandidateExam.uploadFlag!=null && CandidateExam.uploadFlag==1}">
										<input type="checkbox" class="eligibilitychk-pass" id="${CandidateExam.candidateExamID}" value="${CandidateExam.candidateExamID }">
										</c:when>
										<c:when test="${CandidateExam.isExamCompleted!=null && CandidateExam.isExamCompleted==true && CandidateExam.uploadFlag!=null && CandidateExam.uploadFlag==1}">
											<input type="checkbox" id="${CandidateExam.candidateExamID }" value="${CandidateExam.candidateExamID }" disabled="disabled">
										</c:when>
									</c:choose>	
								</c:when>
								<c:otherwise>
								<c:if test="${  failCertificateTemplateID!=null && failCertificateTemplateID!=0 && objPassingMarks!=0.0 && isPassingConcept==true}"> 
								<c:choose>
										<c:when test="${CandidateExam.isExamCompleted!=null && CandidateExam.isExamCompleted==true && CandidateExam.uploadFlag!=null && CandidateExam.uploadFlag==1}">
										<input type="checkbox" class="eligibilitychk-fail" id="${CandidateExam.candidateExamID}" value="${CandidateExam.candidateExamID }">
										</c:when>
										<c:when test="${CandidateExam.isExamCompleted!=null && CandidateExam.isExamCompleted==true && CandidateExam.uploadFlag!=null && CandidateExam.uploadFlag==1}">
											<input type="checkbox" id="${CandidateExam.candidateExamID }" value="${CandidateExam.candidateExamID }" disabled="disabled">
										</c:when>
								</c:choose>	
								</c:if>
								</c:otherwise>
								</c:choose>					
									
								</td>
							</tr>
							<%-- </c:if> --%>
						</c:forEach>
					</tbody>

				
			</table>
                 <input type="hidden" id="pID" name="pID" value="${paperId}">			
        
			</c:if>
			
			
			 
			<c:if test="${fn:length(listCandidateExam) != 0}">
			<div class="offset1">
					<div class="controls">
						<input type="hidden" id="hdncandExamIdList" name="hdncandExamIdList"> 
						<input type="hidden" id="paperType" name="paperType" value="${paperType}">
						<button type="submit" id="btnGetCertificate" class="btn btn-blue" onclick="this.form.target='_blank';return true;"><spring:message code="examEventCertificate.getCertificate"></spring:message></button>
					</div>
			</div>
			</c:if>
			</form:form>
			
			<c:if test="${fn:length(listCandidateExam) != 0}">
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
				<div class="dataTables_paginate paging_bootstrap pagination">
					<ul>
						<c:choose>
							<c:when
								test="${disablePrev==true || (fn:length(listCandidateExam)<=pagination.recordsPerPage && pagination.start==0)}">
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
						<input type="hidden" id="searchText" name="searchText"
							value="${searchText}" />
						<input type="hidden" id="paperId" name="paperId" value="${paperId}" >
						<input type="hidden" id="examEventId" name="examEventId" value="${examEventId}" >
						<input type="hidden" id="certificateTemplateID" name="certificateTemplateID" value="${certificateTemplateID}" >
						<input type="hidden" id="failCertificateTemplateID" name="failCertificateTemplateID" value="${failCertificateTemplateID}">
						<input type="hidden" id="isPassingConcept" name="isPassingConcept" value="${isPassingConcept}">	
						<input type="hidden" id="showResultType" name="showResultType" value="${showResultType}" >
					</form:form>
					<form:form action="next" method="POST" modelAttribute="pagination"
						id="next_selector_for_the_form">
						<form:hidden path="end" />
						<form:hidden path="start" />
						<form:hidden path="recordsPerPage" />
						<input type="hidden" id="searchText" name="searchText"	value="${searchText}" />
						<input type="hidden" id="paperId" name="paperId" value="${paperId}" >
						<input type="hidden" id="examEventId" name="examEventId" value="${examEventId}" >
						<input type="hidden" id="certificateTemplateID" name="certificateTemplateID" value="${certificateTemplateID}" >
						<input type="hidden" id="failCertificateTemplateID" name="failCertificateTemplateID" value="${failCertificateTemplateID}">
						<input type="hidden" id="isPassingConcept" name="isPassingConcept" value="${isPassingConcept}">
						<input type="hidden" id="showResultType" name="showResultType" value="${showResultType}" >
					</form:form>
				</div>	
				</c:if>		
		
	</div>
			
			
			
			
		</fieldset>
	
	<script type="text/javascript">
	 $(document).ready(function(){
		 
		 examEventID = $('#examEventSelect').val();
		 paperId = $('#paperId').val();
		 attemptDate=$('#paperAttemptDate').val();
		 
		 if($('#examEventSelect').val()!=-1)
		{
			var dat = JSON.stringify({ "examEventID" : examEventID }); 
			if (examEventID!=-1) {
				callExamEventAjax(dat,paperId);	
			}
			
			var dat1 = JSON.stringify({"examEventID" : examEventID , "fkPaperID" : paperId }); 
			if (examEventID!=-1 && paperId !=-1) {
				//callPaperAjax(dat1,attemptDate);	
			}
		}
		 
		 
		 /* examEvent change event */
			$('#examEventSelect').change(function(event) {
				examEventID = $('#examEventSelect').val();
				
				var dat = JSON.stringify({
					"examEventID" : examEventID
				});
				if (examEventID !=-1) {
					callExamEventAjax(dat,undefined);
				}
				
			}); // end of examEventSelect change event
		 
			
			/* paper change event */
		/* 	$('#paperSelect').change(function(event) {
				examEventID = $('#examEventSelect').val();
				paperId=$('#paperSelect').val();
				var dat = JSON.stringify({
					"examEventID" : examEventID,
					"fkPaperID":paperId
				});
				if (examEventID !=-1 && paperId!=-1) {
					callPaperAjax(dat,undefined);
				}
				
			}); // end of paper change event */
			
			$('#selectAllpass').change(function(event) {
				if ($('#selectAllpass').prop("checked")==true) {
					$('#tblpassCandidateList input[class=eligibilitychk-pass]').each(function() {
						$(this).prop("checked", true);				    
					});
					$('#tblpassCandidateList input[class=eligibilitychk-fail]').each(function() {
						$(this).prop("checked", true);				    
					});
				}else{
					$('#tblpassCandidateList input[class=eligibilitychk-pass]').each(function() {
						$(this).prop("checked", false);				    
					});
					$('#tblpassCandidateList input[class=eligibilitychk-fail]').each(function() {
						$(this).prop("checked", false);				    
					});
				}
				
			}); 		
			
			
			
			
	 }); /* End of document ready */
	 
	 
	// Used to get paper list
		function callExamEventAjax(dat,selectedId) {
			$.ajax({
				url : "listPaperAssociatedToEvent.ajax",
				type : "POST",
				data : dat,
				contentType : "application/json",
				dataType : "json",
				success : function(response) {
					displayPapers(response, selectedId);
				},
				error : function() {
					console.log("error in callExamEventAjax");
				}
			}); /* end of ajax */
		}
	 
		function displayPapers(response, selectedId) {			
			$("#paperSelect").find("option").remove();
			
			/* if(response.length>1){
				$("#paperSelect").append("<option value='-1'><spring:message code="select.selectPaper"/></option>");
			} */
			$("#paperSelect").append("<option value='-1'>--<spring:message code="select.selectPaper"/> --</option>");		
			$.each(response, function(i, eventPaperDetails) {
				if (selectedId && selectedId == eventPaperDetails.paper.paperID) {
					$("#paperSelect").append("<option value='" + eventPaperDetails.paper.paperID + "' selected='selected'>"
									+ eventPaperDetails.paper.name + "</option>");
				} else {
					$("#paperSelect").append("<option value='" + eventPaperDetails.paper.paperID + "'>"
									+ eventPaperDetails.paper.name + "</option>");
				}
							
			});
				
			

		} /* end of displayCollection */
		
		function callPaperAjax(dat,selectedId) {
			$.ajax({
				url : "listPaperAttemptDates.ajax",
				type : "POST",
				data : dat,
				contentType : "application/json",
				dataType : "json",
				success : function(response) {
					displayPaperAttemptDates(response, selectedId);
				},
				error : function() {
					console.log("Error in callPaperAjax");
				}
			}); /* end of ajax */
		}
		
		function displayPaperAttemptDates(response, selectedId) {			
			$("#paperAttemptDateSelect").find("option").remove();
			
			/* if(response.length>1){
				$("#paperAttemptDateSelect").append("<option value='-1'>--<spring:message code="select.selectPaper"/> --</option>");
			} */
			$("#paperAttemptDateSelect").append("<option value='-1'>--"+"<spring:message code="certificate.selectDate" />"+" --</option>");		
			$.each(response, function(i, attemptDate) {
				if (selectedId && selectedId == attemptDate) {
					$("#paperAttemptDateSelect").append("<option value='" + attemptDate + "' selected='selected'>"
									+ attemptDate + "</option>");
				} else {
					$("#paperAttemptDateSelect").append("<option value='" + attemptDate + "'>"
									+ attemptDate + "</option>");
				}
			});

		} /* end of display paper attempt dates */
		
		
		function validate() {
			
			if($('#examEventSelect').val()==-1 || $('#examEventSelect').val()=='')
			{
				alert('<spring:message code="examevent.selectalertMessage"/>');
				$("#examEventSelect").focus();
				return false;
			} 
			 if($('#paperSelect').val()==-1 || $('#paperSelect').val()=='')
			{
				alert('<spring:message code="scheduleExam.selectPaper"/>');
				$("#paperSelect").focus();
				return false;
			}
			 
			if($('#paperAttemptDateSelect').val()==-1 || $('#paperAttemptDateSelect').val()=='')
			{
					alert('<spring:message code="certificate.selectDate"/>');
					$("#paperAttemptDateSelect").focus();
					return false;
			}
			return true;
		}
		
		function validateCandidateSelection() {
			
			var listCandidateExamId="";
			var count=0;
			var failedCount=0;
			//passed candidate exam id 
			$('#tblpassCandidateList input[class=eligibilitychk-pass]:checked').each(function() {
			    if (count==0) {
			    	listCandidateExamId=$(this).val();
				}else{
					listCandidateExamId=listCandidateExamId+","+$(this).val();
				}
			    count++;
			});
			
			if(count !=0)
			{
			listCandidateExamId=listCandidateExamId+"-P|";
			}
			
			//failed candidate exam id 
			$('#tblpassCandidateList input[class=eligibilitychk-fail]:checked').each(function() {
			    if (count==0) {
			    	listCandidateExamId=$(this).val();
				}else if(failedCount==0)
					{
						listCandidateExamId=listCandidateExamId+$(this).val();
					}
				else
					{
					    listCandidateExamId=listCandidateExamId+","+$(this).val();
					}
			    count++;
			    failedCount++;
			});
			
			if(failedCount!=0)
			{
			listCandidateExamId=listCandidateExamId+"-F";
			}
			//alert(listCandidateExamId);
			if (count==0) {
				
				alert("<spring:message code="certificate.alertSelectOnePaper"/>");
				return false;
			}			
			$('#hdncandExamIdList').val(listCandidateExamId);
			return true;
		}
	</script>
	
	<script type="text/javascript" src="<c:url value='/resources/js/gridDataTable.js'></c:url>"></script>
	<script type="text/javascript">
		$(document)
				.ready(
						function() {				
							

							$('#tblpassCandidateList')
									.dataTable(
											{
												"sDom" : "<'row-fluid'<'span4'><'span12'f>r>t<'row-fluid'<'span4'><'span8'>>",
												"iDisplayLength" : -1,
												"aoColumns" : [ null,null,null,null,null,null,null, {
															"bSortable" : false
														} ],
												"oTableTools" : {
													"sSwfPath" : "../resources/media/csv_xls_pdf.swf",
													"aButtons" : [
															"copy",
															"print",
															{
																"sExtends" : "collection",
																"sButtonText" : 'Save <span class="caret" />',
																"aButtons" : [
																		{
																			'sExtends' : 'csv',
																			'mColumns' : [
																					0,
																					1,
																					2,
																					3,
																					4,
																					5,
																					6,
																					7
																					 ]
																		},
																		{
																			'sExtends' : 'xls',
																			'mColumns' : [
																					0,
																					1,
																					2,
																					3,
																					4,
																					5,
																					6,
																					7
																					 ]
																		},
																		{
																			'sExtends' : 'pdf',
																			'mColumns' : [
																					0,
																					1,
																					2,
																					3,
																					4,
																					5,
																					6,
																					7
																					 ]
																		} ]
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

							$('#go')
									.click(
											function() {
												var searchText = $('#search').val().trim();
												var paperId = $('#paperId').val();
												var examEventId = $('#examEventId').val();
												var certificateTemplateID = $('#certificateTemplateID').val();
												var failCertificateTemplateID = $('#failCertificateTemplateID').val();
												var isPassingConcept = $('#isPassingConcept').val();
												var showResultType = $('#showResultType').val();
												
												window.location.href = 'searchCandidate?searchText='+ searchText+'&paperId='+paperId+'&examEventId='+examEventId+
														'&certificateTemplateID='+certificateTemplateID+'&failCertificateTemplateID='+failCertificateTemplateID+
														'&isPassingConcept='+isPassingConcept+'&showResultType='+showResultType;												
												
											});

						});
	</script>
	
</body>
</html>