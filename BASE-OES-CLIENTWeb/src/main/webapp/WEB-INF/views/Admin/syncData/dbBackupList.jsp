<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page errorPage="../common/jsperror.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib  uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<title><spring:message code="databasebackup.DatabaseBackup"/></title>
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

</style>
</head>
<body>
	<fieldset class="well">
		<div>
			<legend>
				<span><spring:message code="databasebackup.DatabaseBackup"/></span>
			</legend>
		</div>
		
		<div class="holder">
		<form:form  class="form-horizontal" id="syncDataForm"  action="createBackupFile" method="get">
		<div align="center"><button type="button" class="btn btn-blue" id="backupbtn"><spring:message code="databasebackup.ClickheretoTakeDatabaseBackup"/></button></div>
		<input type="hidden" id="isinprocess" name="isinprocess" value="${isInprocess}"/>
		</form:form>
		<!-- <div id="syncMessages"  style="white-space:pre-line;max-height:300px;overflow-y: scroll;"></div> -->

			<div id="statusdiv" style="border: 1px solid #297176;">
				<table class="table table-bordered-new2 table-striped">
					<thead>
						<tr>
							<th width="30%">
							<spring:message code="databasebackup.DatabaseBackupStatus"/>
							</th>
							<th>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<div id="incompletediv" class="pull-left">
								<spring:message code="databasebackup.Inprogress"/>&nbsp;<img alt="" src="<c:url value="../resources/images/gray-bar.gif"></c:url>">
							</div>
							<div id="completediv"  class="pull-left">
								<spring:message code="databasebackup.Completed"/>
							</div>
							</th>
						</tr>
					</thead>
				</table>
						
					
				<div class="modal-body" id="syncMessages" style="white-space:pre-line;height:250px;overflow-y: scroll;">
				</div>
			</div>
			<br>
			<table class="table table-bordered-new2 table-striped" id="filelisttbl">
							<thead>
							<tr>
							<th colspan="4" style="text-align: center;">
							<spring:message code="databasebackup.BackupHistory"/>
							</th>
							</tr>
								<tr>
									<th width="10%"><spring:message code="databasebackup.SrNo"/></th>
									<th><spring:message code="databasebackup.BackupFileName"/></th>
									<th width="25%"><spring:message code="databasebackup.DatabaseBackupDate"/></th>
									<th width="15%"><spring:message code="databasebackup.Download"/></th>
								</tr>
							</thead>
							<tbody>
							<c:if test="${fn:length(fileNames)!=0 }">
							<c:set var="srcnt" value="0"></c:set>
								<c:forEach var="fileName" items="${fileNames}" varStatus="i">
									<c:set var="srcnt" value="${srcnt+1}"></c:set>
										<tr>
											<td>${srcnt}</td>
											<td>${fileName.key}</td>
											<td>${fileName.value}</td>
											<td><a href="../syncDataSMC/downloadSqlFile?filename=${fileName.key}" class="dwnldFile">Download</a></td>
										</tr>
								</c:forEach>
								</c:if>
								<c:if test="${fn:length(fileNames)==0 }">
								<tr>
											<td colspan="3">
											<spring:message code="databasebackup.RecordsnotFound"/>
											</td>
										</tr>
								</c:if>
							</tbody>
						</table>
				
		</div>
	</fieldset>
	
	<script type="text/javascript">
	 function getBackupStatus() {
		
			$.ajax({
				url : '../syncDataSMC/readDBBackupStatusAjax',
				data : '',
				global: false,
				success : function(data) {
					if (data.toString().indexOf("^^^") >= 0)
					{
						$('#syncMessages').html('');
						$('#syncMessages').append('<br>');
						$('#syncMessages').append(data.toString().replace("^^^", " "));
						$("#backupbtn").prop("disabled",false);
						$("#incompletediv").hide();
						$("#completediv").show();
						
						createFileList();
	
					}
					else
					{
						$('#syncMessages').html('');
						$('#syncMessages').append('<br>');
						$('#syncMessages').append(data);
						setTimeout(getBackupStatus, 1000);
					}
					
				}			
			});
			
		}

		function createBkp() {
		
			$.ajax({
				url : '../syncDataSMC/createBackupFile',
				data : ''
			});
		}	
	

		function createFileList() {
			var i=0;
			$.ajax({
				url : '../syncDataSMC/dbBackupListAjax',
				data : '',
				global: false,
				success : function(data) 
				{
					if(data.length==0)
						{
							alert("<spring:message code="databasebackup.RecordsnotFound"/>");
						}
						else
						{
							$("#filelisttbl").find("tbody").remove();
							$.each(data, function(key, value) {
							$("#filelisttbl").append(
							"<tr><td>"+(i=i+1)+"</td><td>"+key+"</td><td>"+value+"</td><td><a href='../syncDataSMC/downloadSqlFile?filename="+key+"' class='dwnldFile'>Download</a></td></tr>");
						});

					}
				},
				error :function(data) {
					alert("error"+data);
					
				}
			});
		}
	$(document).ready(function()
	{
		$("#statusdiv").hide();
		
		$("#backupbtn").click(function() 
				{
					$("#backupbtn").prop("disabled",true);
					$("#statusdiv").show();
					
					$("#incompletediv").show();
					$("#completediv").hide();
					
					$.ajax({
						url : '../syncDataSMC/readDBBackupStatusAjax',
						data : '',
						global: false,
						success : function(data) {
							if (data.toString().indexOf("^^^") >= 0 || data=='')
							{
								createBkp();
					 			setTimeout(getBackupStatus, 2000);
							}
							else
							{
								alert('<spring:message code="databasebackup.DatabaseBackupisalreadyinprocess"/>');
								setTimeout(getBackupStatus, 2000);
							}

						}

					});
					
			
				});	
		var isinprocess=$("#isinprocess").val();
		if(isinprocess=='1')
		{
			$("#backupbtn").prop("disabled",true);
			$("#statusdiv").show();
			
			$("#incompletediv").show();
			$("#completediv").hide();
			
			getBackupStatus();
			
		}
	});

	</script>
		
	


</body>
</html>