<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page errorPage="../common/jsperror.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib  uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<title><spring:message code="syncExamData.title" /></title>
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


.nav-tabs > li > a {
  padding-top: 8px;
  padding-bottom: 8px;
  line-height: 20px;
  border: 1px solid #ddd;
  -webkit-border-radius: 4px 4px 0 0;
  -moz-border-radius: 4px 4px 0 0;
  border-radius: 4px 4px 0 0;
  background-color: #eeeeee;
}
.disabled {
   pointer-events: none;
   cursor: default;
}
</style>
</head>
<body>
	<fieldset class="well">
		<div>
			<legend>
				<span><spring:message code="syncExamData.heading" /></span>
			</legend>
		</div>
		
		<div class="holder" id="tabs">
		
		<ul class="nav nav-tabs" id="myTab">
		  <li role="presentation" class="active"><a href="#"><b><spring:message code="syncExamData.FullDataSynchronization" /></b></a></li>
		  <li role="presentation"><a href="../syncData/examEventSingleCandidate" id="candidatelink"><spring:message code="syncExamData.SingleCandidateDataSynchronization" /></a></li>
		</ul>
		
		
		<div class="tab-content">
		 <div id="disable" class="tab-pane active">
			<form:form  class="form-horizontal" id="syncDataForm"  action="selectSyncEvent" method="get">
				<div class="control-group">
					<label class="control-label" for="inputEmail"><spring:message code="candidateTestReport.examEvent"></spring:message></label>
					<div class="controls">
						<select class="span4" id="examEventSelect" name="examEventSelect">
							<option value="-1" selected="selected"><spring:message code="candidateTestReport.selectExamEvent"></spring:message></option>
							<c:forEach items="${examEventList }" var="eObj">
								<c:choose>
									<c:when test="${eObj.examEventID==examEventId}">
										<option value="${eObj.examEventID}" selected="selected">${eObj.name}</option>
									</c:when>
									<c:otherwise>
										<option value="${eObj.examEventID}">${eObj.name}</option>
									</c:otherwise>	
								</c:choose>
							</c:forEach>
						</select>&nbsp;&nbsp;<button type="button" class="btn btn-success" id="btnSynchroniseData" name="btnSynchroniseData"><spring:message code="syncExamData.syncData" /></button>
					</div>
				</div>


			</form:form>
			
			<div id="statusdiv" style="border: 1px solid #297176;">
				<table class="table table-bordered-new2 table-striped">
					<thead>
						<tr>
							<th width="35%">
							<spring:message code="syncExamData.syncDataStatus" /></th><th>
							
							<div id="progressDiv"><spring:message code="syncExamData.inProgress" />&nbsp;<img alt="" src="<c:url value="../resources/images/gray-bar.gif"></c:url>"></div>
							<%-- <div id="completeDiv"><spring:message code="syncExamData.completed" /></div> --%>
							</th>
						</tr>
					</thead>
				</table>
						
					
				<div id="syncMessages" style="white-space:pre-line;padding-left: 10px;height:300px;overflow-y: scroll;">
				</div>
			</div>
			
			
			</div>
			</div>
			
			
			
			
			
			
			
			</div>
	</fieldset>
	
	
		
	<script type="text/javascript">
	 $(document).ready(function(){
		 $("#statusdiv").hide();
		 $("#completeDiv").hide();
		 checkPrevDownldPending();

		 $('#btnSynchroniseData').click(function(event) {
			 
			 
			 if ($('#examEventSelect').val() == '-1') {
					alert('<spring:message code="DisplayCategory.selectExamEvent"/>');
					return false;
			}
			 
			 $.ajax({
					
					url : '../syncData/readDownloadingStatusAjax',
					data : '',
					global: false,
					success : function(data) {
						if (parseInt(data.toString().indexOf("^^^")) >= 0 || data=='')
						{
							 $("#statusdiv").show();
							 $("#progressDiv").show();
							 $("#completeDiv").hide();			
							 $("#btnSynchroniseData").prop("disabled",true);
							 $("#candidatelink").addClass("disabled");
							 syncExamData();			
							 setTimeout(getDataDownloadingStatus, 2000);
							/*  callExamEventSyncProgressAjax(); */
						}
						else
						{
							alert('<spring:message code="syncExamData.wait" />');
							 $("#statusdiv").show();
							 $("#progressDiv").show();
							 $("#completeDiv").hide();			
							 $("#btnSynchroniseData").prop("disabled",true);
							 $("#candidatelink").addClass("disabled");
							getDataDownloadingStatus();
						}
					}			
				});
		 });
	}); 
	 
	 function getDataDownloadingStatus() {
			$.ajax({
				
				url : '../syncData/readDownloadingStatusAjax',
				data : '',
				global: false,
				success : function(data) {
					if (parseInt(data.toString().indexOf("^^^")) >= 0)
					{	
						$("#examEventSelect").prop("disabled",false);
						callExamEventAjax();
						$('#syncMessages').html('');
						$('#syncMessages').append('<br>');
						$('#syncMessages').append(data.toString().replace("^^^", " "));						
						$("#progressDiv").hide();
						
						if(data.toString().toLowerCase().indexOf("error")>=0 || data.toString().toLowerCase().indexOf("failed")>=0)
						{
							$("#completeDiv").text('<spring:message code="syncExamData.downloadingFailed" />');
						}
						else
						{
							$("#completeDiv").text('<spring:message code="syncExamData.downloadingCompleted" />');
						}
						$("#completeDiv").show();
						$("#btnSynchroniseData").prop("disabled",false);
						
						$("#candidatelink").removeClass("disabled");
						$('#syncMessages').scrollTop($('#syncMessages')[0].scrollHeight);						
					}
					else
					{
						$('#syncMessages').html('');
						$('#syncMessages').append('<br>');
						$('#syncMessages').append(data);
						setTimeout(getDataDownloadingStatus, 1000);
						$('#syncMessages').scrollTop($('#syncMessages')[0].scrollHeight);
					}
				}			
			});
			
		}
	 
	 
	 function checkPrevDownldPending() {
			$.ajax({
				
				url : '../syncData/readDownloadingStatusAjax',
				data : '',
				global: false,
				success : function(data) {
				
					if (data != '' && parseInt(data.toString().indexOf("^^^")) < 0)
					{
						//to check single user sync status
						if (parseInt(data.toString().indexOf("ENTERED USER NAME:"))>0)
						{
							window.location.href="../syncData/examEventSingleCandidate";
						}
						$("#statusdiv").show();
						$("#btnSynchroniseData").prop("disabled",true);
						$("#candidatelink").addClass("disabled");
						getDataDownloadingStatus();
					}
					else // start master data sync if no previous sync is in process.
					{
						$("#statusdiv").show();
						$("#btnSynchroniseData").prop("disabled",true);
						$("#candidatelink").addClass("disabled");
						$("#examEventSelect").prop("disabled",true);
						syncMasterData();
						setTimeout(getDataDownloadingStatus, 3000);
						/* callExamEventSyncProgressAjax();  */
					} 
				}			
			});
			
		}
	 
	 function syncExamData() {
		
			var eventId=$('#examEventSelect').val();
			$.ajax({
				global: false,
				url : '../syncData/syncExamDataAjax?examEventId='+eventId,
				data : '',
				success : function(data) {
				},
				error :function(data) {
					alert("error"+data);
				}
			});
		}
	 
	 function syncMasterData() {		
			$.ajax({
				global: false,
				url : '../syncData/syncMasterAjax'				
			});
		}
	 
	 function callExamEventAjax() {
			$.ajax({
				url : '../syncData/ListExamEvents.ajax',
				contentType : "application/json",
				dataType : "json",
				success : function(response) {
					displayEvents(response);					
				},
				error : function(error) {
					alert('<spring:message code="oldSyncExamData.enableLoadEventList" /> ' + error);
				}
			}); /* end of ajax */
		}
	 
		function displayEvents(response) {			
			$("#examEventSelect").find("option").remove();			
			
			$("#examEventSelect").append("<option value='-1' selected='selected'>-- Select Exam Event --</option>");		
			$.each(response, function(i, examEvent) {				
				$("#examEventSelect").append("<option value='" + examEvent.examEventID + "'>" + examEvent.name + "</option>");			
			});

		}
		
		
	</script>


</body>
</html>