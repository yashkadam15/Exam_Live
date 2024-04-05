<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page errorPage="../common/jsperror.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib  uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<title><spring:message code="bdRestoreList.RestoreDatabase"/></title>
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
fieldset.fieldset-border {
    border: 1px groove #ddd !important;
    padding: 0 1.4em 1.4em 1.4em !important;
    margin: 0 0 1.5em 0 !important;
   /* -webkit-box-shadow:  0px 0px 0px 0px #000;
     box-shadow:  0px 0px 0px 0px #000; */
    border-radius: 6px;
}

    legend.fieldset-border {
        font-size: 1.2em !important;
        font-weight: bold !important;
        text-align: left !important;
        line-height:0;
        width:auto;
        padding:0 10px;
        border-bottom:none;
        margin-bottom: 0px;
    }
</style>
</head>
<body>
	<fieldset class="well">
		<div>
			<legend>
				<span><spring:message code="bdRestoreList.RestoreDatabase"/></span>
			</legend>
		</div>
 <div class="holder">
 	<div id="confirmModal" Class="modal hide fade confirmModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">

						<div class="modal-header">
							<h3 id="myModalLabel">
								<spring:message code="bdRestoreList.RestoreConfirmation"/>
							</h3>
						</div>
						<div class="modal-body">
							<b><spring:message code="bdRestoreList.Areyousure"/></b>
							<label id="lblFileName" style="font-weight: bold;"></label>
						</div>
						<div class="modal-footer">
							<button class="btn btn-success" data-dismiss="modal" aria-hidden="true">
								<spring:message code="bdRestoreList.No"/>
							</button>
							<button id="btnyes" class="btn btn-success" data-dismiss="modal" aria-hidden="true">
								<spring:message code="bdRestoreList.Yes"/>
							</button>
						</div>
					</div>
	
 

<!-- <div class="holder" id="tabs"> -->
<ul class="nav nav-tabs" id="myTab">
    <li class="active"><a data-toggle="tab" href="#auto"><spring:message code="bdRestoreList.Auto"/></a></li>
    <li><a data-toggle="tab" href="#manual"><spring:message code="bdRestoreList.Manual"/></a></li>
  </ul>

  <div class="tab-content">
    <div id="auto" class="tab-pane active">
    <br><br>
    	<table class="table table-bordered-new2 table-striped" id="filelisttbl">
			<thead>
			<tr>
			<th colspan="4" style="text-align: center;">
			<spring:message code="bdRestoreList.AvailableDatabaseBackupFilesforRestore"/>
			</th>
			</tr>
				<tr>
					<th width="10%"><spring:message code="databasebackup.SrNo"/></th>
					<th><spring:message code="databasebackup.BackupFileName"/></th>
					<th width="25%"><spring:message code="databasebackup.DatabaseBackupDate"/></th>
					<th width="15%"><spring:message code="bdRestoreList.Restore"/></th>
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
							<td><a href="${fileName.key}" class="btn btn-blue rstrbtn" data-toggle="modal" data-backdrop="static"><spring:message code="bdRestoreList.Restore"/></a> </td>
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
    <div id="manual" class="tab-pane">
    <br>
      <fieldset class="fieldset-border">
		<%-- <legend class="fieldset-border"><spring:message code="bdRestoreList.ManualRestore"/></legend> --%>
			<form:form method="POST" enctype="multipart/form-data" class="form-horizontal">
				<div class="control-group">
					<b><spring:message code="bdRestoreList.SelectBackupFile"/> :</b>
					
						<input type="file" name="bkpFile" id="bkpFile" required/>
					
				</div>
				<br>
				<div class="controls">
					<button type="submit" class="btn btn-blue" id="manbtnrstr" name="manbtnrstr"><spring:message code="bdRestoreList.RestoreDatabase"/></button>
				</div>
			</form:form>
		</fieldset>
    </div>
    
  </div>
<!-- </div> --> 
	<br>

		<div id="statusdiv" style="border: 1px solid #297176;">
				<table class="table table-bordered-new2 table-striped">
					<thead>
						<tr>
							<th width="30%">
							<spring:message code="bdRestoreList.DatabaseRestoreStatus"/>
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
		
		</div>	
		
	</fieldset>
	

<script type="text/javascript">
$(document).ready(function()
{
	
	$.ajax({
		url : '../syncDataSMC/readDBRestoreStatusAjax',
		data : '',
		success : function(data) 
		{
			if (data.toString().indexOf("^^^") >= 0 || data=='')
			{
				$("#statusdiv").hide();
			}
			else
				
			{
				$("#statusdiv").show();
				$("#incompletediv").show();
				$(".rstrbtn").addClass('disabled');
				$("#manbtnrstr").addClass('disabled');
				$("#completediv").hide();
				getRestoreStatus();
			}
			
		},error :function(data) {
			alert("error"+data);
		}
	});
	
	
	var href="";
	var lbltext="";
			$(".rstrbtn").click(function(e)
			{
				href=$(this).attr('href');
				$("#lblFileName").text(href);
				$("#confirmModal").modal('show');
			});
			
			$("#btnyes").click(function()
			{
				$("#statusdiv").show();
				$("#incompletediv").show();
				$("#completediv").hide();
				$(".rstrbtn").addClass('disabled');
				$("#manbtnrstr").addClass('disabled');
				window.scrollTo(0,document.body.scrollHeight);
				$.ajax({
					url : '../syncDataSMC/readDBRestoreStatusAjax',
					data : '',
					success : function(data) {
						if (data.toString().indexOf("^^^") >= 0 || data=='')
						{
							lbltext=$("#lblFileName").text();
							setDBRestore(lbltext);
							setTimeout(getRestoreStatus, 2000);
						}
						else
						{
							alert('<spring:message code="bdRestoreList.DatabaseRestoreisalreadyinprocess"/>');
						}

					},error :function(data) {
						alert("error"+data);
						
					}

				});
				
			});
			
			
			
			$("#manbtnrstr").click(function(e)
			{
				if($('#bkpFile').val()==='')
				{
					alert('<spring:message code="bdRestoreList.Pleaseselectdatabasebackupfile"/>');
					return false;
				}
				var bkpFile=$('#bkpFile').val();
				var bkpFileExt=bkpFile.substring(bkpFile.lastIndexOf('.'),bkpFile.length)
				if(bkpFileExt.toLowerCase()!='.sql')
				{
					alert('<spring:message code="bdRestoreList.Pleaseselectvaliddatabasebackupfile"/>');
					$('#bkpFile').val('');
					return false;
				}
				
				e.preventDefault(); 
				var formData = new FormData();
			    formData.append('file', $('input[type=file]')[0].files[0]);
			    //console.log("form data " + formData);
			    $.ajax({
			        url : '../syncDataSMC/uploadDBBkpFile',
			        data : formData,
			        processData : false,
			        contentType : false,
			        type : 'POST',
			        success : function(data) 
			        {
			        	$("#statusdiv").show();
			        	$("#incompletediv").show();
			        	$("#completediv").hide();
			        	$(".rstrbtn").addClass('disabled');
			        	$("#manbtnrstr").addClass('disabled');
			        	$('#syncMessages').html('');
						$('#syncMessages').append('<spring:message code="debRestorList.fileUploadingInProgress"/>');
						window.scrollTo(0,document.body.scrollHeight);
				        callManualDBRestore(data);
			        },
			        error : function(err) {
			        	 alert(err);
			        }
			    });
				
						
			});
			
		});

		
function setDBRestore(filename) {
	$.ajax({
		url : '../syncDataSMC/dbRestoreTask',
		data : 'filename='+filename
		
	});
}

function setManualDBRestore(filename) {
	$.ajax({
		url : '../syncDataSMC/dbManualRestoreTask',
		data : 'filename='+filename
	});
}



function callManualDBRestore(filename)
{
/* 	$("#statusdiv").show();
	$("#incompletediv").show();
	$("#completediv").hide();
	$(".rstrbtn").addClass('disabled');
	 */
	
	$.ajax({
		url : '../syncDataSMC/readDBRestoreStatusAjax',
		data : '',
		success : function(data) {
			if (data.toString().indexOf("^^^") >= 0 || data=='')
			{
				setManualDBRestore(filename);
				setTimeout(getRestoreStatus, 2000);
			}
			else
			{
				alert('<spring:message code="bdRestoreList.DatabaseRestoreisalreadyinprocess"/>');
			}

		},error :function(data) {
			alert("error"+data);
			
		}

	});
	
}

function getRestoreStatus() {
	
	$.ajax({
		url : '../syncDataSMC/readDBRestoreStatusAjax',
		data : '',
		success : function(data) {
			if (data.toString().indexOf("^^^") >= 0)
			{
				$('#syncMessages').html('');
				$('#syncMessages').append('<br>');
				$('#syncMessages').append(data.toString().replace("^^^", " "));
				$("#incompletediv").hide();
				$("#completediv").show();
				$(".rstrbtn").removeClass('disabled');
				$("#manbtnrstr").removeClass('disabled');
				$('#bkpFile').val('');

			}
			else
			{
				$('#syncMessages').html('');
				$('#syncMessages').append('<br>');
				$('#syncMessages').append(data);
				setTimeout(getRestoreStatus, 1000);
			}
			
		},
		error : function(errdata) {alert('<spring:message code="dbRestore.wrong"/>');}
	});
	
}

</script>
</body>
</html>