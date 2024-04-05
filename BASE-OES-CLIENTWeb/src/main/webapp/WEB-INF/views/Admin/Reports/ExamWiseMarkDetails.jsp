<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib  uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<title><spring:message code="examWiseMarkDetials.title" /></title>
<spring:message code="project.resources" var="resourcespath" />
<link rel="stylesheet" type="text/css" href="<c:url value='/resources/style/dataTable.css'></c:url>" />
	
<style type="text/css">

.panel-primary {
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
}
</style>	
</head>
<body>
	<fieldset class="well">
		<div>
			<legend>
				<span><spring:message code="examWiseMarkDetials.title" /></span>
			</legend>
		</div>
		
		<div class="holder">
			<form:form  class="form-horizontal"  action="ExamWiseMarkDetails" method="post" onsubmit="return validate();">
						
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

				<div  id="paper">
					<label class="control-label" for="paperName" id="paper-lbl"><spring:message code="scoreCard.Paper" /></label>
					<div class="controls">
						<input type="hidden" id="paperId" name="paperId" value="${paperId}" >
						<select class="span4" id="paperSelect" name="paperSelect">
						</select>
					</div>
				</div>
				
				<br>				
				<div>
					<div class="controls">
						<button type="submit" class="btn btn-blue" ><spring:message code="examWiseMarkDetials.ViewReport" /></button>
					</div>
				</div>
				
			</form:form>
			</div>
	</fieldset>
	
		<fieldset class="well">
			<div class="holder">			
			
			<c:if test="${fn:length(listExamWiseMarkDetails) != 0}">
			
			<div class="panel panel-primary">
       	 		<div class="panel-heading">
	          		<h4 class="panel-title" style="text-align: center">
						<spring:message code="examWiseMarkDetials.title" />
					</h4>
          		</div>       		
		     	<table class="table table-bordered table-complex ">
		     		<tr>
						<td colspan="2"><b><spring:message code="examWiseMarkDetials.ExamCenter" /></b>&nbsp; [${objExamWiseMarkDetails.venueCode}]&nbsp;${objExamWiseMarkDetails.venueName}</td>
					</tr>
					<tr>
						<td><b><spring:message code="auth.EventName" /></b>&nbsp; ${objExamWiseMarkDetails.eventName}</td>
						<td><b><spring:message code="auth.PaperName" /></b>&nbsp; ${objExamWiseMarkDetails.paperName}</td>
						<td><b><spring:message code="examWiseMarkDetials.MaximumMarks" /></b>&nbsp; ${objExamWiseMarkDetails.paperTotalMarks}</td>
					</tr>
				</table>	
			
			
			<!--candidate list data table  -->
			<c:set var="srNo" value="${pagination.start+1}" scope="page" />
			<table class="table table-striped table-bordered" id="tblCandidateList">
				<thead>
					<tr>
						<th><spring:message code="candidateTestReport.srNo" /></th>
						<th><spring:message code="candidateTestReport.userCode" /></th>
						<th><spring:message code="candidateTestReport.login" /></th>
						<th><spring:message code="candidateTestReport.name" /></th>
						<th><spring:message code="viewtestscore.Marks" /></th>
						<th><spring:message code="scoreCard.ExamStatus" /></th>
						<th><spring:message code="topicwise.Result" /></th>		
						<th><spring:message code="scoreCard.AttemptDate" /></th>					
					</tr>
				</thead>
				<tfoot>
					<tr>
						<th><spring:message code="candidateTestReport.srNo" /></th>
						<th><spring:message code="candidateTestReport.userCode" /></th>
						<th><spring:message code="candidateTestReport.login" /></th>
						<th><spring:message code="candidateTestReport.name" /></th>
						<th><spring:message code="viewtestscore.Marks" /></th>
						<th><spring:message code="scoreCard.ExamStatus" /></th>
						<th><spring:message code="topicwise.Result" /></th>		
						<th><spring:message code="scoreCard.AttemptDate" /></th>					
					</tr>
				</tfoot>
				<c:if test="${fn:length(listExamWiseMarkDetails) != 0}">
					<tbody>
						<c:forEach var="CandidateExam" items="${listExamWiseMarkDetails}">
							<tr>
								<td>${srNo}	<c:set var="srNo" value="${srNo+1}" scope="page" /></td>
								<td>${CandidateExam.candidate.candidateCode}</td>
								<td>${CandidateExam.candidate.candidateUserName}</td>
								<td>${CandidateExam.candidate.candidateFirstName}&nbsp;${CandidateExam.candidate.candidateLastName}</td>
								<td>${CandidateExam.marksObtained} </td>								
								<td>
									<c:choose>
										<c:when test="${CandidateExam.isExamCompleted==true}">
											<spring:message code="scoreCard.Completed" />
										</c:when>
										<c:when test="${CandidateExam.isExamCompleted==false}">
											<spring:message code="scoreCard.InComplete" />
										</c:when>
									</c:choose>
								</td>
								<td>
								 
								  <fmt:parseNumber var="totalObtainedMarks" type="number" value="${CandidateExam.marksObtained}" />
									<c:choose>
										<c:when test="${CandidateExam.isExamCompleted==true}">
											<c:choose>
												<c:when	test="${objExamWiseMarkDetails.passingMarks==null}">
													<font color="green"><spring:message	code="viewtestscore.NA" /></font>
												</c:when>
												
												<c:when	test="${totalObtainedMarks >= objExamWiseMarkDetails.passingMarks}">
													<font color="green"><spring:message	code="viewtestscore.Pass" /></font>
												</c:when>
												<c:when	test="${totalObtainedMarks < objExamWiseMarkDetails.passingMarks}">
													<font color="red"><spring:message code="viewtestscore.Fail" /></font>
												</c:when>
											</c:choose>
										</c:when>
										<c:when test="${CandidateExam.isExamCompleted==false}">
											<font color="green"><spring:message	code="viewtestscore.NA" /></font>
										</c:when>
									</c:choose>
								</td>
								<td><fmt:formatDate pattern="dd-MM-yyyy HH:mm:ss"   value="${CandidateExam.attemptDate }" /></td>
							</tr>
						</c:forEach>
					</tbody>

				</c:if>
			</table>
			<c:if test="${fn:length(listExamWiseMarkDetails) != 0}">
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
								test="${disablePrev==true || (fn:length(listExamWiseMarkDetails)<=pagination.recordsPerPage && pagination.start==0)}">
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
						<input type="hidden" id="paperId" name="paperId" value="${paperId}">
						
						<input type="hidden" id="searchText" name="searchText"
							value="${searchText}" />
					</form:form>
					<form:form action="next" method="POST" modelAttribute="pagination"
						id="next_selector_for_the_form">
						<form:hidden path="end" />
						<form:hidden path="start" />
						<form:hidden path="recordsPerPage" />
						
						<input type="hidden" id="examEventId" name="examEventId" value="${examEventId}">
						<input type="hidden" id="paperId" name="paperId" value="${paperId}">
						
						<input type="hidden" id="searchText" name="searchText"
							value="${searchText}" />
					</form:form>
				</div>
			</c:if>
			<br><br>
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
			$('#paperSelect').change(function(event) {
				examEventID = $('#examEventSelect').val();
				paperId=$('#paperSelect').val();
				var dat = JSON.stringify({
					"examEventID" : examEventID,
					"fkPaperID":paperId
				});
								
			}); // end of paper change event
							
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
					alert("opps.....");
				}
			}); /* end of ajax */
		}
	 
		function displayPapers(response, selectedId) {			
			$("#paperSelect").find("option").remove();
			
			/* if(response.length>1){
				$("#paperSelect").append("<option value='-1'>--<spring:message code="select.selectPaper"/> --</option>");
			} */
			$("#paperSelect").append("<option value='-1'>--<spring:message code="select.selectPaper"/> --</option>");		
			$.each(response, function(i, paper) {
				if (selectedId && selectedId == paper.paperID) {
					$("#paperSelect").append("<option value='" + paper.paperID + "' selected='selected'>"
									+ paper.name + "</option>");
				} else {
					$("#paperSelect").append("<option value='" + paper.paperID + "'>"
									+ paper.name + "</option>");
				}
			});

		} /* end of displayCollection */
			
		
		function validate() {
			
			if($('#examEventSelect').val()==-1 || $('#examEventSelect').val()=='')
			{
				alert('<spring:message code="DisplayCategory.selectExamEvent" />');
				$("#examEventSelect").focus();
				return false;
			} 
			 if($('#paperSelect').val()==-1 || $('#paperSelect').val()=='')
			{
				alert('<spring:message code="scheduleExam.selectPaper" />');
				$("#paperSelect").focus();
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
							

							$('#tblCandidateList')
									.dataTable(
											{
												"sDom" : "<'row-fluid'r>t<'row-fluid'>",
												"iDisplayLength" : -1,
												"aoColumns" : [ null, null,
														null,null,null,null,null,null]
											});

							$("#go").remove();
							$("#search").css("align","left");
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
												var searchText = $('#search')
														.val();
												window.location.href = 'searchSector?searchText='
														+ searchText;
											});

						});
		
		//$('div.row-fluid').remove();
	</script>
	
</body>
</html>