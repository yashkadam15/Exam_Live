<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page errorPage="../common/jsperror.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<title><spring:message code="bulkEndExam.title" /></title>
<spring:message code="project.resources" var="resourcespath" />

<link rel="stylesheet" type="text/css" href="<c:url value='/resources/style/dataTable.css'></c:url>" />
</head>
<body>
<c:choose>
			<c:when test="${isAdmin==1 }">
			<fieldset class="well">
		<div>
			<legend>
				<span><spring:message code="bulkEndExam.title" /></span>
			</legend>
		</div>

		<div class="holder">
			<span><strong><spring:message code="bulkEndExam.subtitle" /></strong></span>			
			<form:form class="form-horizontal" action="bulkEndExamGet" method="POST"
				onsubmit="return validate(this);">
				<%-- <input type="hidden" id="isAdmin" name="isAdmin" value="${isAdmin}">  --%>

				<div class="control-group" >
					<label class="control-label"><spring:message
							code="candidateTestReport.examEvent"></spring:message></label>
					<div class="controls">
						<select class="span4" id="examEventSelect" name="SELEXAMEVENTID">
							<option value="-1" selected="selected"><spring:message
									code="candidateTestReport.selectExamEvent"></spring:message></option>
							<c:forEach items="${expiredExamEventList}" var="eObj">
								<c:choose>
									<c:when test="${eObj.examEventID == examEventID}">
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
					<label class="control-label"><spring:message
							code="scoreCard.Paper"></spring:message></label>
					<div class="controls">
						<input type="hidden" id="paperID" name="SELPAPERID"
							value="${paperID}"> <select class="span4"
							id="paperSelect">
						</select>
					</div>
				</div>

				<div class="controls">
					<button type="submit" class="btn btn-blue">
						<spring:message code="EventSelection.Proceed" />
					</button>
				</div>

			</form:form>
		</div>
	</fieldset>


	<fieldset class="well">
		<div class="holder">
			<c:choose>
				<c:when
					test="${incompleteExamsList!=null && fn:length(incompleteExamsList) != 0}">

					<form:form class="form-horizontal" action="bulkEndExamPost" method="post"
						onsubmit="return validateBulkEndExamForm(this);">
						<div id="endExamDiv">
							<table class="table table-striped table-bordered" id="tblIncompleteExamList">
								<thead>
									<tr>
										<th><spring:message
												code="bulkEndExam.candname" /></th>
										<th><spring:message
												code="bulkEndExam.candusername" /></th>
										<th><spring:message
												code="bulkEndExam.attemptno" /></th>
										<th><spring:message
												code="bulkEndExam.attemptdate" /></th>
										<th><spring:message
												code="bulkEndExam.elaspedtime" /></th>
										<th>
										<input type="checkbox" name="selectAllCandiateId" id="selectAllCandiateId" class="selectAllCandiateId">
										<spring:message
												code="bulkEndExam.selectAction" /></th>
									</tr>
								</thead>
								<tfoot>
									<tr>
										<th><spring:message
												code="bulkEndExam.candname" /></th>
										<th><spring:message
												code="bulkEndExam.candusername" /></th>
										<th><spring:message
												code="bulkEndExam.attemptno" /></th>
										<th><spring:message
												code="bulkEndExam.attemptdate" /></th>
										<th><spring:message
												code="bulkEndExam.elaspedtime" /></th>
										<th><spring:message
												code="bulkEndExam.selectAction" /></th>
									</tr>
								</tfoot>
								<tbody>
									<c:forEach var="ceObj" items="${incompleteExamsList}">
										<tr>
											<td>${ceObj.candidate.candidateFirstName}&nbsp;${ceObj.candidate.candidateLastName}</td>
											<td>${ceObj.candidate.candidateUserName}</td>
											<td>${ceObj.attemptNo}</td>
											<td><fmt:formatDate value="${ceObj.attemptDate}" pattern="yyyy-MM-dd hh:mm:ss a" /></td>
											<td>${ceObj.elapsedTime}</td>
											<td><input type="checkbox"  name="candidateExamID" id="candidateExamID" class="candidateCheckItem"
												value="${ceObj.candidateExamID}"></td>
										</tr>
									</c:forEach>
								</tbody>


							</table>

							<div class="controls offset1">
								<input type="hidden" id="hdnCandidateExamIDs" name="hdnCandidateExamIDs" />
								<button type="submit" class="btn btn-blue offset1"><spring:message code="bulkEndExam.save" /></button>
							</div>
						</div>
					</form:form>

				</c:when>
				<c:otherwise>	
					
					<c:if test="${fn:length(expiredExamEventList)!=0 && mode == 0}">
					<div>
							<legend><spring:message code="bulkEndExam.noexamfound"/></legend>
						</div>
					</c:if>
				</c:otherwise>
			</c:choose>
		</div>
	</fieldset>
			</c:when>
			<c:otherwise>
			<fieldset class="well">
		<div>
			<legend>
				<span><spring:message code="bulkEndExam.notauthorized" /></span>
			</legend>
		</div>
		</fieldset>
			</c:otherwise>
			
			</c:choose>
	

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
			}); // end of examEventSelect change event

			$('#selectAllCandiateId').click(function(event) {   
				var checked_status = this.checked;
				$("input[name='candidateExamID']").each(function()
					{
						this.checked = checked_status;
					});
			});

		}); /* End of document ready */
	
			$(".candidateCheckItem").change(function(){
				if($(this).prop("checked") == false) {
					$("#selectAllCandiateId").prop("checked", false);
				}
				if($(".candidateCheckItem:checked").length == $(".candidateCheckItem").length) {
					$("#selectAllCandiateId").prop("checked", true);
				}
			});
		
		// call to get paper list
		function callPaperAjax(dat, selectedId) {

			$
					.ajax({
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

			$("#paperSelect").append(
					"<option value='-1'> <spring:message code="scheduleExam.selectPaper"/> </option>");

			$.each(response, function(i, item) {				
				
				if (selectedId && selectedId == item.paperID) {
					
					$("#paperSelect").append(
							"<option value='" + item.paperID + "' selected='selected'>"
									+ item.name + "</option>");
				} else {
					
					$("#paperSelect").append(
							"<option value='" + item.paperID + "'>" + item.name
									+ "</option>");
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
			return true;
		}
		/*end Validate method for Form Get method */

		/*start Validate method for Form Post method */
		function validateBulkEndExamForm() {

			var hdnCandidateExamID = "";

			var count = 0;
			// get all checked item bank id's
			$('input[name="candidateExamID"]:checked').each(function() {
				var vals = $(this).val();
				
				if (!(typeof vals === 'undefined')) {
					if (vals != '' && vals != 'NULL') {
						hdnCandidateExamID = hdnCandidateExamID + vals + ',';
						count = count + 1;
						
					}
				}
			});

			if (count == 0) {
				alert('<spring:message code="bulkEndExam.checkboxalertMessage" />');
				return false;
			}
			$('#hdnCandidateExamIDs').val(hdnCandidateExamID);
			return true;
		}
		/*end Validate method for Form Post method */
	</script>

	<script type="text/javascript" src="<c:url value='/resources/js/gridDataTable.js'></c:url>"></script>
	<script type="text/javascript">
		$(document)
				.ready(
						function() {
							$('#tblIncompleteExamList')
									.dataTable(
											{
												"sDom" : "<'row-fluid'<'span4'><'span8'>r>t<'row-fluid'<'span4'><'span8'>>",
												"iDisplayLength" : -1,
												"aoColumns" : [ null,null,null,null,null,{"bSortable" : false}]																								
												
											});
						});
	
	</script>	
</body>
</html>