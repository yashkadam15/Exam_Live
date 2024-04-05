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
.form-horizontal .control-group:nth-child(2n) {
    background-color: transparent;
}
.form-horizontal .control-group {
    background-color: transparent;
}
/* .nav-tabs > li > a {
  padding-top: 8px;
  padding-bottom: 8px;
  line-height: 20px;
  border: 1px solid #ddd;
  -webkit-border-radius: 4px 4px 0 0;
  -moz-border-radius: 4px 4px 0 0;
  border-radius: 4px 4px 0 0;
  background-color: #eeeeee;
} */
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
		  <li id="litab2"><a href="../syncData/selectSyncEvent" id="fulldatalink"><spring:message code="syncExamData.FullDataSynchronization" /></a></li>
		  <li id="litab3" class="active"><a href="#"><b><spring:message code="syncExamData.SingleCandidateDataSynchronization" /></b></a></li>
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
						</select>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label"><spring:message code="syncExamData.UserName" /></label>
					<div class="controls">
						<input type="text" name="userName" id="userName" required/>
					</div>
				</div>

<br>
			
					<div class="controls">
						<button type="button" class="btn btn-success" id="btnSynchroniseData" name="btnSynchroniseData"><spring:message code="syncExamData.DownloadCandidate" /></button>
							
					</div>
			</form:form>
			<div id="statusdiv" style="border: 1px solid #297176;">
				<table class="table table-bordered-new2 table-striped">
					<thead>
						<tr>
							<th width="35%">
							<spring:message code="syncExamData.syncDataStatus" /></th><th>
							
							<div id="progressDiv"><spring:message code="syncExamData.inProgress" />&nbsp;<img alt="" src="<c:url value="../resources/images/gray-bar.gif"></c:url>"></div>
							<div id="completeDiv"><spring:message code="syncExamData.completed" /></div>
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
	 $(document).ready(function()
	{
		$("#statusdiv").hide();
		$("#completeDiv").hide();
		checkPrevDownldPending();
		
		
		 $('#btnSynchroniseData').click(function(event) 
		 {
			 var msg='<spring:message code="oldCandidateSync.followingErrors" />\n';
			 var flag=false;
			 
			 if ($('#examEventSelect').val() == '-1') 
			 {
					msg+='-<spring:message code="DisplayCategory.selectExamEvent"/>';
					flag=true;
			 }
			 if ($('#userName').val() == '') 
			 {
				 
					msg+='\n-<spring:message code="syncExamData.EnterUserName"/>';
					flag=true;
			 }
			if(flag)
			{
				 alert(msg);
				 return false;
			}
			 
			
			 $.ajax({
					
					url : '../syncData/readDownloadingStatusAjax',
					data : '',
					success : function(data) {
						if (parseInt(data.toString().indexOf("^^^")) >= 0 || data=='')
						{
							 $("#statusdiv").show();
							 $("#progressDiv").show();
							 $("#completeDiv").hide();			
							 $("#btnSynchroniseData").prop("disabled",true);
							 $("#fulldatalink").addClass('disabled');
							 syncSingleCandidateData();	
							 setTimeout(getDataDownloadingStatus, 2000);
							 
						}
						else
						{
							alert('<spring:message code="syncExamData.wait" />');
							 $("#statusdiv").show();
							 $("#progressDiv").show();
							 $("#completeDiv").hide();	
							 $("#fulldatalink").addClass('disabled');
							 $("#btnSynchroniseData").prop("disabled",true);
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
				success : function(data) {
					if (parseInt(data.toString().indexOf("^^^")) >= 0)
					{				
						$('#syncMessages').html('');
						$('#syncMessages').append('<br>');
						$('#syncMessages').append(data.toString().replace("^^^", " "));						
						$("#progressDiv").hide();
						$("#completeDiv").show();
						$("#btnSynchroniseData").prop("disabled",false);
						$("#fulldatalink").removeClass('disabled');
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
				success : function(data) {
					if (data != '' && parseInt(data.toString().indexOf("^^^")) < 0)
					{
						if (parseInt(data.toString().indexOf("ENTERED USER NAME:"))<0)
						{
							window.location.href="../syncData/selectSyncEvent";
						}
						$("#statusdiv").show();
						$("#btnSynchroniseData").prop("disabled",true);
						$("#fulldatalink").addClass('disabled');
						getDataDownloadingStatus();
					}

				}			
			});
			
		}
	 function syncSingleCandidateData() {
			
			var eventId=$('#examEventSelect').val();
			var userName=$('#userName').val();
			$.ajax({
				url : '../syncData/syncSingleCandidateAjax?examEventId='+eventId+'&userName='+userName,
				data : '',
				success : function(data) {
				},
				error :function(data) {
					alert("error"+data);
				}
			});
		}
	 
	 
	 
	
	 

	</script>


</body>
</html>