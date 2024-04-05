<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib  uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<title><spring:message code="certificate.eligibilitycertslabel"/></title>
<spring:message code="project.resources" var="resourcespath" />
<link rel="stylesheet" type="text/css" href="<c:url value='/resources/style/dataTable.css'></c:url>" />
</head>
<body>
	<fieldset class="well">
		<div>
			<legend>
				<span><spring:message code="certificate.eligibilitycertslabel"/></span>
			</legend>
		</div>
		
		<div class="holder">
			<form:form  class="form-horizontal"  action="EligibilityCerticateCandidatelistNoTyping" method="post" onsubmit="return validate();">
						
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
					<label class="control-label" for="paperName" id="paper-lbl"><spring:message code="scoreCard.Paper"/></label>
					<div class="controls">
						<input type="hidden" id="paperId" name="paperId" value="${paperId}" >
						<select class="span4" id="paperSelect" name="paperSelect">
						</select>
					</div>
				</div>
				
				<div class="control-group" id="attemptDate">
					<label class="control-label" for="attemptDate" id="attemptDate-lbl"><spring:message code="certificate.Date"/></label>
					<div class="controls">
						<input type="hidden" id="paperAttemptDate" name="paperAttemptDate" value="${paperAttemptDate}" >
						<select class="span4" id="paperAttemptDateSelect" name="paperAttemptDateSelect">
						</select>
					</div>
				</div>				
				

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
			<form:form  class="form-horizontal"  action="PrintCertificateNoTyping" method="post" onsubmit="return validateCandidateSelection();">
			<c:if test="${fn:length(listCandidateExam) != 0}">
			<!--Integrated data table  -->
			<c:set var="srNo" value="1" scope="page" />
			<table class="table table-striped table-bordered" id="tblCandidateList">
				<thead>
					<tr>
						<th><spring:message code="candidateTestReport.srNo" /></th>
						<th><spring:message code="candidateTestReport.name" /></th>
						<th><spring:message code="candidateTestReport.login" /></th>
						<th><spring:message code="candidateTestReport.userCode" /></th>
						<th><spring:message code="certificate.examcompletelabel"/></th>
						<th><spring:message code="admindashboard.Uploaded"/></th>
						
						<th><spring:message code="select.labelalertMsg"/> <input type="checkbox" id="selectAll" name="selectAll"></th>
					</tr>
				</thead>
				<tfoot>
					<tr>
						<th><spring:message code="candidateTestReport.srNo" /></th>
						<th><spring:message code="candidateTestReport.name" /></th>
						<th><spring:message code="candidateTestReport.login" /></th>
						<th><spring:message code="candidateTestReport.userCode" /></th>
						<th><spring:message code="certificate.examcompletelabel"/></th>
						<th><spring:message code="admindashboard.Uploaded"/></th>
						
						<th><spring:message code="select.labelalertMsg"/></th>
					</tr>
				</tfoot>
				<c:if test="${fn:length(listCandidateExam) != 0}">
					<tbody>
						<c:forEach var="CandidateExam" items="${listCandidateExam}">
							<tr>
							<%-- 	<c:set var="status" value="fail" scope="page" /> --%>
								<td>${srNo}	<c:set var="srNo" value="${srNo+1}" scope="page" /></td>
								<td>${CandidateExam.candidate.candidateFirstName}&nbsp;${CandidateExam.candidate.candidateLastName}</td>
								<td>${CandidateExam.candidate.candidateUserName}</td>
								<td>${CandidateExam.candidate.candidateCode}</td>
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
										<c:when test="${CandidateExam.isExamCompleted!=null && CandidateExam.isExamCompleted==true && CandidateExam.uploadFlag!=null && CandidateExam.uploadFlag==1}">
											<input type="checkbox" class="eligibilitychk" id="${CandidateExam.candidateExamID }" value="${CandidateExam.candidateExamID }">
										</c:when>
										<c:when test="${CandidateExam.isExamCompleted!=null && CandidateExam.isExamCompleted==true && CandidateExam.uploadFlag!=null && CandidateExam.uploadFlag==1}">
											<input type="checkbox" id="${CandidateExam.candidateExamID }" value="${CandidateExam.candidateExamID }" disabled="disabled">
										</c:when>
									</c:choose>	
								</td>
							</tr>
						</c:forEach>
					</tbody>

				</c:if>
			</table>
<input type="hidden" id="pID" name="pID" value="${paperId}">
				<div class="offset1">
					<div class="controls">
						<input type="hidden" id="hdnExamIdList" name="hdnExamIdList"> 
						<button type="submit" id="btnGetCertificate" class="btn btn-blue" onclick="this.form.target='_blank';return true;"><spring:message code="examEventCertificate.getCertificate" /></button>
					</div>
				</div>

			</c:if>
			</form:form>
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
				callPaperAjax(dat1,attemptDate);	
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
				if (examEventID !=-1 && paperId!=-1) {
					callPaperAjax(dat,undefined);
				}
				
			}); // end of paper change event
			
			$('#selectAll').change(function(event) {
				if ($('#selectAll').prop("checked")==true) {
					$('#tblCandidateList input[class=eligibilitychk]').each(function() {
						$(this).prop("checked", true);				    
					});
				}else{
					$('#tblCandidateList input[class=eligibilitychk]').each(function() {
						$(this).prop("checked", false);				    
					});
				}
				
			}); 			
	 }); /* End of document ready */
	 
	 
	// Used to get paper list
		function callExamEventAjax(dat,selectedId) {
			$.ajax({
				url : "listPaperAssociatedToEventNoTyping.ajax",
				type : "POST",
				data : dat,
				contentType : "application/json",
				dataType : "json",
				success : function(response) {
					displayPapers(response, selectedId);
				},
				error : function() {
					alert('<spring:message code="eligibilityCertsListNoTyping.errorInCallExamEventAjax"/>');
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
					alert('<spring:message code="eligibilityCertsListNoTyping.errorInCallPaperAjax"/>');
				}
			}); /* end of ajax */
		}
		
		function displayPaperAttemptDates(response, selectedId) {			
			$("#paperAttemptDateSelect").find("option").remove();
			
			/* if(response.length>1){
				$("#paperAttemptDateSelect").append("<option value='-1'>--<spring:message code="select.selectPaper"/> --</option>");
			} */
			$("#paperAttemptDateSelect").append("<option value='-1'>--Select Date --</option>");		
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
			
			$('#tblCandidateList input[class=eligibilitychk]:checked').each(function() {
			    if (count==0) {
			    	listCandidateExamId=$(this).val();
				}else{
					listCandidateExamId=listCandidateExamId+"|"+$(this).val();
				}
			    count++;
			});
			if (count==0) {
				alert("<spring:message code="certificate.alertSelectOnePaper"/>");
				return false;
			}			
			$('#hdnExamIdList').val(listCandidateExamId);
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
												"sDom" : "<'row-fluid'<'span4'><'span8'>r>t<'row-fluid'<'span4'><'span8'>>",
												"iDisplayLength" : -1,
												"aoColumns" : [ null, null,
														null,null,null,null,{
															"bSortable" : false
														}]
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
	</script>
	
</body>
</html>