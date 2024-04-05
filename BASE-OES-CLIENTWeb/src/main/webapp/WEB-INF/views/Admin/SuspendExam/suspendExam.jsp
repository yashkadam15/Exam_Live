<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page errorPage="../common/jsperror.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
 <spring:message code="project.resources" var="resourcespath" />

<link rel="stylesheet" type="text/css" href="<c:url value='/resources/style/dataTable.css'></c:url>" />
<title><spring:message code="suspendExam.SuspendExam"/></title>
</head>
<body>
	<fieldset class="well">
		<div>
			<legend>
				<span><spring:message code="suspendExam.SuspendExam"/></span>
			</legend>
		</div>

		<div class="holder">
						
			<form:form class="form-horizontal" action="eventList" method="POST" onsubmit="return validate(this);">

        	<div class="control-group" id="eventDiv">
					<label class="control-label"><spring:message code="suspendExam.EventName"/></label>
					<div class="controls">
						<select class="span4" id="examEventSelect" name="SELEXAMEVENTID">
							<option value="-1" selected="selected"><spring:message
									code="candidateTestReport.selectExamEvent"></spring:message></option>
							<c:forEach items="${onGoingExamEventList}" var="eObj">
								<c:choose>
									<c:when test="${eObj.examEventID==examEventID}">
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

				 <div class="control-group" id="paperDiv" >
					<label class="control-label"><spring:message code="suspendExam.PaperName"/></label>
					<div class="controls">
						  <input type="hidden" id="paperID" name="SELPAPERID" value="${paperID}"> 
						<select class="span4" id="paperSelect" name="SELECTPAPERID">
							<!-- Options -->
						</select>
					</div>
				</div>


			<div class="control-group " >
				<div class="control-label" >
					<label  id="lbl"><spring:message code="resetExamStatus.CandidateUsername/LoginId"/>&nbsp;:&nbsp;</label></div>
				<div class="controls">
					 <input type="text" id="username" class="span4" value="${fn:escapeXml(username)}" name="username" />
				</div>
			</div>
 	
		<div class="controls">
			<!-- Submit Form -->
			<button type="submit" class="btn btn-blue"> <spring:message code="EventSelection.Proceed"/></button>
		</div>
</form:form>

<c:choose>

	<c:when test="${CandidateDetails!=null and fn:length(CandidateDetails)!=0}">
		<table class="table table-striped table-bordered table-condensed" id="demotable" style="font-size:10pt;">
			<thead>					 
					<tr><td colspan="7" style="background-color: #f4f4f4;"><span class="pull-left">
					<b><spring:message code="DisplayCategory.uName"/>:</b> ${CandidateDetails[0].candidate.candidateFirstName}  ${CandidateDetails[0].candidate.candidateLastName}
					</span>
					 <span class="pull-right">
					 <b><spring:message code="candidateTestReport.candidatecode"/>:</b>${CandidateDetails[0].candidate.candidateCode}
					 </span>
					</td>
					</tr>						
					<tr>
						<th><spring:message code="resetExamStatus.ExamEventName"/></th>
						<th><spring:message code="examlog.paper"/></th>	
						<th style="width:10%;"><spring:message code="suspendExam.status"/></th>					
						<th style="width:16%;"><spring:message code="scoreCard.AttemptDate"/></th>
						<th style="width:10%;"><spring:message code="Release.Timespent"/></th>
						<th style="width:10%;"><spring:message code="suspendExam.ExamStatus"/></th>
						<th style="width:10%;"><spring:message code="suspendExam.Action"/></th>
					</tr>
			 </thead>
	 
		<c:forEach var="viewModel" items="${CandidateDetails}" varStatus="i">	
				<tbody>
					<tr>
						<td>${viewModel.examEvent.name}</td>
						<td>${viewModel.paper.name}</td>
						<td><c:choose>
						<c:when test="${isCandidateOnline==null}" >
						<spring:message code="suspendExam.offline"/>
						</c:when>
						<c:otherwise>
						 <spring:message code="suspendExam.online"/>
						</c:otherwise>
						</c:choose>
						 </td>
						<td> <fmt:formatDate value="${viewModel.candidateExam.attemptDate}" pattern="dd-MM-yyyy HH:mm:ss" /></td>
						<td ><input type="text" value="${fn:escapeXml(viewModel.candidateExam.elapsedTime)}" class="input-mini allnum"  style="margin-bottom:0px;"  disabled="disabled"></td>					
						<td><c:choose>
						<c:when test="${viewModel.candidateExam.isExamCompleted==false}" >
						<spring:message code="suspendExam.incomplete"/>   
						</c:when>
						<c:otherwise>
						<spring:message code="suspendExam.Completed"/> 
						</c:otherwise>
						</c:choose></td>
						<td >
							<button type="submit"  data-toggle="modal" data-target="#myModal" class="btn btn-blue " onclick="suspendCandidate(${viewModel.candidateExam.candidateExamID});"><spring:message code="suspendExam.Suspend"/></button>					
						 </td> 
					</tr>				
				</tbody>
		</c:forEach>
	</table>			
	</c:when>
	<c:when test="${examEventID != null}">
			<div>
					<legend><spring:message code="candidateAttempt.noDataFound"/></legend>
	        </div>
	</c:when>
	</c:choose>
<!-- Model -->					
<div class="modal fade" id="myModal" role="dialog">  
    <div class="modal-dialog">  
      
      <!-- Modal content-->  
      <div class="modal-content">  
        <div class="modal-content">
		      <div class="modal-header">  
		          <button type="button" class="close" data-dismiss="modal">×</button>  
		          <h4 class="modal-title"><spring:message code="suspendExam.Confirm"/></h4>  
		        </div>  
		        <div class="modal-body">  
		          <p><spring:message code="suspendExam.msg"/>&nbsp;&nbsp;<b>${username}</b></p>  
		     </div>  
		  <div class="modal-footer">  
	       
	       <form:form action="suspendCandidateExam" method="POST" id="suspendForm">
			    <input type="hidden" name="ceid" id="ceid" value="" >
			    <input type="hidden" name="cuName" id="cuName" value="">
			 	 <button type="button" class="btn btn-default" data-dismiss="modal"><spring:message code="global.cancel"/></button>
			    <button type="submit" id="btnConfirm"  class="btn btn-default btn-blue"><spring:message code="suspendExam.Confirm"/></button>
			</form:form>  
        </div>  
		 </div>   
      </div>  
    </div>  
  </div>
  </div>
</fieldset>

<script type="text/javascript">
		$(document).ready(function() {

			examEventID = $('#examEventSelect').val();
			paperid = $('#paperID').val();

			if ($('#examEventSelect').val() != -1) {
				var dat = JSON.stringify({
					"examEventID" : examEventID
				});
				callPaperAjax(dat, paperid);

			}

			/* examEvent change event */
			$('#examEventSelect').change(function(event) {

				examEventID = $('#examEventSelect').val();
				var dat = JSON.stringify({
					"examEventID" : examEventID
				});

				callPaperAjax(dat, undefined);
			}); // end of examEventSelect change event

			/* examEvent change event */	
			$('#paperSelect').change(function(event) {	
				paperid = $('#paperSelect').val();	
				$('#paperID').val(paperid);	
				
			}); 

		});  
	
	
		// call to get paper list
		function callPaperAjax(dat, selectedId) {

			$.ajax({
						url : "paper.ajax",
						type : "POST",
						data : dat,
						contentType : "application/json",
						dataType : "json",
						success : function(response) {
							displayPapers(response, selectedId);
						},
						error : function() {
							alert('<spring:message code="bulkEndExam.errorMsg"/>');							
						}
					}); /* end of ajax */
		}
		// Display Papers
		function displayPapers(response, selectedId) {			
			$("#paperSelect").find("option").remove();

			$("#paperSelect").append( "<option value='-1'> <spring:message code="scheduleExam.selectPaper"/> </option>");

			$.each(response, function(i, item) {				
				if (selectedId && selectedId == item.paperID) {
					$("#paperSelect").append( "<option value='" + item.paperID + "' selected='selected'>" + item.name + "</option>");
				} else {
					$("#paperSelect").append( "<option value='" + item.paperID + "'>" + item.name + "</option>");
				}
			});

		} /* end of display Exam Venue */

		/*start Validate method for Form Get method */
		function validate(form) {
			var e = form.elements;

			if (e['examEventSelect'].value == -1) {
				alert('<spring:message code="examevent.selectalertMessage" />');
				$("#examEventSelect").focus();
				return false;
			}

			else if (e['paperSelect'].value == -1) {
				alert('<spring:message code="scheduleExam.selectPaper" />');
				$("#paperSelect").focus();
				return false;
			}

			else if($.trim($('#username').val())=='')
			{
				alert('<spring:message code="scoreCard.PleaseenterthecandidateLoginID"/>');
				return false;
			}
			return true;
		}/*end Validate method for Form Post method */ 

	function suspendCandidate(ceid,cuName)
	{
		 $('#ceid').val(ceid); 
	}
		    
	</script>			
</body>
</html>