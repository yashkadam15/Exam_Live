<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<title><spring:message code="ddtDashboard.Dashboard" /></title>
<link rel="stylesheet" type="text/css" href="<c:url value='/resources/style/dataTable.css'></c:url>" />
<script type="text/javascript" src="<c:url value='/resources/js/gridDataTable.js'></c:url>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/moment.min.js'></c:url>"></script>
<style type="text/css">
#search {  
 position: relative;
margin-top: 0px;
padding-left: 12px;
float: none;
margin-bottom: 0px;
margin-right: 5px;
}
#go{
display: none;
}
</style>
</head>
<body>
	<fieldset class="well">
		<legend>
			<span><img src="<c:url value="../resources/images/dashboard.png"></c:url>" alt=""> 
			<spring:message code="ddtDashboard.Dashboard" /></span>
		</legend>
		<div class="holder">
			<div class="form-horizontal">
				<c:choose>
					<c:when test="${exameventList!=null && fn:length(exameventList)==1}">
						<h4 style="line-height: 20px;">
							<spring:message code="ddtDashboard.ExamEvent" />: ${exameventList[0].name}
							<input type="hidden" value="${exameventList[0].examEventID}" id="selEvent"> 
						</h4>
					</c:when>
					<c:otherwise>
						<div class="control-group">
							<label class="control-label"><spring:message code="ddtDashboard.SelectExamEvent" /></label>
							<div class="controls">
								<select id="selEvent" name="selEvent" style="width:50%">
									<option value="0"><spring:message code="ddtDashboard.Select" /></option>
									<c:forEach var="event" items="${exameventList}">
										<option value="${event.examEventID}">${event.name}</option>
									</c:forEach>
								</select>&nbsp;&nbsp;<button type="submit" class="btn btn-blue" id="eventProceed"><spring:message code="ddtDashboard.Proceed" /></button>
							</div>
						</div>
					</c:otherwise>
				</c:choose>
				
			</div>
			
				<c:set var="examId" value="0" />
				<c:set var="noupload" value="0"/>
				<c:set var="totAllocated" value="0"/>
				<c:set var="totNotAppeared" value="0"/>
				<c:set var="totIncomplete" value="0"/>
				<c:set var="totNotUploaded" value="0"/>
				<c:set var="totUploaded" value="0"/>
				<table class="table table-striped table-bordered" id="tblStatusTable">
					<thead class="thead-light">
						<tr>
							<th rowspan="2" style="text-align: center;" width="50%">
								<spring:message code="admindashboard.Paper" />
							</th>
							<th rowspan="2" style="text-align: center;">
								<spring:message	code="admindashboard.AllocatedCandidates" />
							</th>
							<th rowspan="2" style="text-align: center;">
								<spring:message	code="admindashboard.notAppeared" />
							</th>
							<th rowspan="2" style="text-align: center;">
								<spring:message	code="admindashboard.IncompleteExams" />
							</th>
							<th colspan="2" style="text-align: center;" width="25%">
								<spring:message	code="admindashboard.CompletedExams" />
							</th>
	
						</tr>
						<tr>
							<th style="text-align: center;">
								<spring:message	code="admindashboard.NotUploaded" />
							</th>
							<th style="text-align: center;">
								<spring:message	code="admindashboard.Uploaded" />
							</th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${fn:length(examStatusList) != 0 && exameventList!=null && fn:length(exameventList)==1}">
							<c:forEach var="candExam" items="${examStatusList}">
								<tr>
									<c:set var="totAllocated" value="${totAllocated + candExam.totalCandidates}"/>
									<c:set var="totNotAppeared" value="${totNotAppeared + candExam.notAppearedCandidates}"/>
									<c:set var="totIncomplete" value="${totIncomplete + candExam.incompleteExamCount}"/>
									
									<td>${candExam.paperName}</td>
									<td style="text-align: center;">
										
											<h3 style="color: #007251; line-height: 10px;">${candExam.totalCandidates}</h3>
									</td>
									<td style="text-align: center;">
											<h3 style="color: red; line-height: 10px;">${candExam.notAppearedCandidates}</h3>
									</td>
									<td style="text-align: center;">
											<h3 style="color: red; line-height: 10px;">${candExam.incompleteExamCount}</h3>
									</td>
									<td style="text-align: center;">
										<c:if test="${candExam.uploadFlag!=2}">
											<c:set var="totNotUploaded" value="${totNotUploaded + candExam.notUploadedExamCount}"/>
											<c:set var="totUploaded" value="${totUploaded + candExam.uploadedExamCount}"/>
											<h3 style="color: #297dbc; line-height: 10px;">${candExam.notUploadedExamCount}</h3>
										</c:if>
										<c:if test="${candExam.uploadFlag==2}">
											<c:set var="noupload" value="1"/>
											<h3 style="color: green; line-height: 10px;">*</h3>
										</c:if>
									</td>
									<td style="text-align: center;">
										<c:if test="${candExam.uploadFlag!=2}">
											<h3 style="color: #007251; line-height: 10px;">${candExam.uploadedExamCount}</h3>
										</c:if>
										<c:if test="${candExam.uploadFlag==2}">
											<c:set var="noupload" value="1"/>
											<h3 style="color: green; line-height: 10px;">*</h3>
										</c:if>
									</td>
								</tr>
							</c:forEach>
						<tr>
							<td><spring:message code="ddtDashboard.Total" /></td>
							<td style="text-align: center;">
								<h3	style="color: #007251; line-height: 10px;">${totAllocated}</h3>
							</td>
							<td style="text-align: center;">
								<h3	style="color: #007251; line-height: 10px;">${totNotAppeared}</h3>
							</td>
							<td style="text-align: center;">
								<h3	style="color: #007251; line-height: 10px;">${totIncomplete}</h3>
							</td>
							<td style="text-align: center;">
								<h3	style="color: #007251; line-height: 10px;">${totNotUploaded}</h3>
							</td>
							<td style="text-align: center;">
								<h3	style="color: #007251; line-height: 10px;">${totUploaded}</h3>
							</td>
						</tr>
					</c:if>
				</tbody>
			</table>
			<div class="form-horizontal">
				<div class="control-group" id="paperDiv">
					<label class="control-label"><spring:message code="ddtDashboard.SelectPaper" /></label>
					<div class="controls">
						<select class="span4" id="paperSel" name="paperSel" style="width:50%">							
							<option value="0" selected="selected"><spring:message code="ddtDashboard.Select" /></option>							
							<c:forEach items="${paperList}" var="pObj">
								<option value="${pObj.paperID}">${pObj.name}</option>
							</c:forEach>
						</select>&nbsp;&nbsp;<button type="submit" class="btn btn-blue" id="paperProceed"><spring:message code="ddtDashboard.ShowCandidates" /></button>
					</div>
				</div>
			</div>
			<br>
			<fieldset class="well">
				<div class="holder">
					<table class="table table-bordered" id="tblCandidateexams">
		            	<thead class="thead-light">
						      <tr>
						      	<th  width="5%"><spring:message code="ddtDashboard.SrNo" /></th>
						      	<th  width="25%"><spring:message code="ddtDashboard.CandidateName" /></th>
						        <th  width="25%"><spring:message code="ddtDashboard.Username" /></th>
						        <th  width="15%"><spring:message code="ddtDashboard.AttemptDate" /></th>
						        <th  width="15%"><spring:message code="ddtDashboard.Analysis" /></th>
						        <th  width="15%"><spring:message code="ddtDashboard.Report" /></th>
						      </tr>
						</thead>
						<tbody>
						
						</tbody>
					</table>
				</div>
			</fieldset>
	</div>

		<!-- upload Data -->
		<%-- <%@include file="dataUpload.jsp"%> --%>

		<script type="text/javascript">
			$(document).ready(function() {
				$("#tblCandidateexams").hide();
				
				
				if(${fn:length(exameventList)>1})
				{
					$("#tblStatusTable").hide();
					$("#paperDiv").hide();
				}
				 $('#eventProceed').click(function(e){
					 e.preventDefault();
					 var examEventID=$("#selEvent").val();
					 if(examEventID==0)
					 {
						 alert('<spring:message code="ddtDashboard.PleaseselecttheExamEvent" />');
						 return false;
					 }
					 var dat = JSON.stringify({ "examEventID" : examEventID});
					 $.ajax({
							url : "getExamStats.ajax",
							type : "POST",
							data : dat,
							contentType : "application/json",
							dataType : "json",
							success : function(response) {
								displayStatusTable(response);
								getPapers(dat);
							},
							error : function() {
								console.log("error in getExamStats.");
							}
						}); 
				 });
				
				 $('#paperProceed').click(function(e){
					 e.preventDefault();
					 var examEventID=$("#selEvent").val();
					 var paperID=$("#paperSel").val();
					 if(paperID==0)
					 {
						 alert('<spring:message code="ddtDashboard.Pleaseselectthepaper" />');
						 return false;
					 }
					 var dat = JSON.stringify({ "fkExamEventID" : examEventID,"fkPaperID":paperID});
					 $.ajax({
							url : "getDDTExamCandidates.ajax",
							type : "POST",
							data : dat,
							contentType : "application/json",
							dataType : "json",
							success : function(response) {
								$("#tblCandidateexams").dataTable().fnDestroy();
								displayTable(response);
								drawdatatable();
							},
							error : function() {
								console.log("error in getDDTExamCandidates");
							}
						}); 
				 });
				
			});
			function displayTable(response)
			{
				$("#tblCandidateexams tbody").html("");
				var newRowContent='';
				if(response)
				{
					$.each(response, function(i, item) 
					{
						newRowContent=newRowContent+"<tr>";
						newRowContent=newRowContent+"<td>"+(i+1)+"</td>";
						newRowContent=newRowContent+"<td>"+item.candidate.candidateFirstName+"</td>";
						newRowContent=newRowContent+"<td>"+item.candidate.candidateUserName+"</td>";
						newRowContent=newRowContent+"<td>"+moment(new Date(item.attemptDate)).format('DD-MMM-YYYY')+"</td>";
						newRowContent=newRowContent+'<td><a href="../ResultAnalysis/viewtestscore?examEventId='+item.fkExamEventID+'&paperId='+item.fkPaperID+'&candidateId='+item.fkCandidateID+'&collectionId='+item.schedulePaperAssociation.fkCollectionID+'&displayCategoryId='+item.schedulePaperAssociation.fkDisplayCategoryID+'&attemptNo='+item.attemptNo+'&ddt=1" class="btn btn-blue" target="_blank">Select</a></td>';
						newRowContent=newRowContent+'<td><a href="../DiabetesDiagnosticTestReport/diabetesDiagnosticTestReport?candidateUserName='+item.candidate.candidateUserName+'&examEventId='+item.fkExamEventID+'&paperId='+item.fkPaperID+'&attemptNo='+item.attemptNo+'" class="btn btn-blue" target="_blank">Select</a></td>';
						newRowContent=newRowContent+"</tr>";
					});
					$("#tblCandidateexams tbody").html(newRowContent);
					$("#tblCandidateexams").show();
				}
				else
				{
					$("#tblCandidateexams").hide();
				}
			}
			
			function displayStatusTable(response)
			{
				$("#tblStatusTable tbody").html("");
				var newRowContent1='';
				var totalCandidaes=0;
				var notAppearedCandidates=0;
				var incompleteExamCount=0;
				var notUploadedExamCount=0;
				var uploadedExamCount=0;
				
				if(response)
				{
					$.each(response, function(i, candExam) 
					{
						newRowContent1=newRowContent1+'<tr>';
						newRowContent1=newRowContent1+'<td>'+candExam.paperName+'</td>';
						newRowContent1=newRowContent1+'<td><h3 style="color: #007251; line-height: 10px;">'+candExam.totalCandidates+'</h3></td>';
						newRowContent1=newRowContent1+'<td><h3 style="color: red; line-height: 10px;">'+candExam.notAppearedCandidates+'</h3></td>';
						newRowContent1=newRowContent1+'<td><h3 style="color: red; line-height: 10px;">'+candExam.incompleteExamCount+'</h3></td>';
						totalCandidaes=totalCandidaes+candExam.totalCandidates;
						notAppearedCandidates=notAppearedCandidates+candExam.notAppearedCandidates;
						incompleteExamCount=incompleteExamCount+candExam.incompleteExamCount;
						if(candExam.uploadFlag!=2)
						{
							notUploadedExamCount=notUploadedExamCount+candExam.notUploadedExamCount;
							newRowContent1=newRowContent1+'<td><h3 style="color: #297dbc; line-height: 10px;">'+candExam.notUploadedExamCount+'</h3></td>';
						}
						else
						{
							newRowContent1=newRowContent1+'<td><h3 style="color: green; line-height: 10px;">*</h3></td>';
						}
						if(candExam.uploadFlag!=2)
						{
							uploadedExamCount=uploadedExamCount+candExam.uploadedExamCount;
							newRowContent1=newRowContent1+'<td><h3 style="color: #007251; line-height: 10px;">'+candExam.uploadedExamCount+'</h3></td>';
						}
						else
						{
							newRowContent1=newRowContent1+'<td><h3 style="color: green; line-height: 10px;">*</h3></td>';
						}
						
						newRowContent1=newRowContent1+"</tr>";
					});
					//alert(newRowContent);
					newRowContent1=newRowContent1+'<tr>';
					newRowContent1=newRowContent1+'<td><spring:message code="ddtDashboard.Total" /></td>';
					newRowContent1=newRowContent1+'<td><h3 style="color: #007251; line-height: 10px;">'+totalCandidaes+'</h3></td>';
					newRowContent1=newRowContent1+'<td><h3 style="color: red; line-height: 10px;">'+notAppearedCandidates+'</h3></td>';
					newRowContent1=newRowContent1+'<td><h3 style="color: red; line-height: 10px;">'+incompleteExamCount+'</h3></td>';
					newRowContent1=newRowContent1+'<td><h3 style="color: #297dbc; line-height: 10px;">'+notUploadedExamCount+'</h3></td>';
					newRowContent1=newRowContent1+'<td><h3 style="color: #007251; line-height: 10px;">'+uploadedExamCount+'</h3></td>';
					newRowContent1=newRowContent1+"</tr>";
					$("#tblStatusTable tbody").html(newRowContent1);
					$("#tblStatusTable").show();
				}
				else
				{
					$("#tblStatusTable").hide();
				}
			}
			
			function getPapers(dat){
				 $.ajax({
						url : "getDDTPapers.ajax",
						type : "POST",
						data : dat,
						contentType : "application/json",
						dataType : "json",
						success : function(response) {
							fillPaperDropdown(response);
						},
						error : function() {
							console.log("error in getPapers.");
						}
					});
			}

			function fillPaperDropdown(response)
			{
				$("#paperDiv").show();
				$("#paperSel").find("option").remove();
 				$("#paperSel").append('<option value="0" selected="selected"><spring:message code="ddtDashboard.Select" /></option>');
 				$.each(response, function(i, item){
 					$("#paperSel").append("<option value='" + item.paperID + "'>"+ item.name + "</option>");
 					
 				});
 				
			}
			function drawdatatable()
			{
				$('#tblCandidateexams').dataTable({
					"order": [],
					 "sDom" : "<'row-fluid'<'span4'><'span8'f>r>t<'row-fluid'<'span4'><'span8'>>",
					 "aoColumns" : [null, null,null,null,{"bSortable" : false},{"bSortable" : false} ],
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
			}
		</script>
	</fieldset>
</body>
</html>