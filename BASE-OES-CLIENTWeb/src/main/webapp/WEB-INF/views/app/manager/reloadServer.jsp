<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page errorPage="../common/jsperror.jsp"%>

<html>
<head>
<style type="text/css">
	.table-bordered {
	    border: 1px solid #2b2020;
	    border-left: 1;
	    border-left-width: 1px;
	    border-left-style: solid;
	    border-left-color: rgb(43, 32, 32);
	}
	table {
	    background-color: #927c7c14;s
	}
	
	#header{
		font-size: 16px;
		font-weight: 600;
		text-align: center;
		background-color: darkgray;
	}
	
	.container-fluid{
		margin-top: 32px;
	}	
</style>
<title>reload</title>
</head>
<body>
		<div class="modal hide fade " id="userMessage" aria-hidden="true" style="background-color: white;">
			<div class="modal-body" align="center">
				<h5>
					<spring:message code="server.restarting" />
				</h5>
				<img style="width: 300px; height: 150px;" align="center"
					src="<c:url value="../resources/images/wait.gif" ></c:url>"
					alt="OES">
			</div>
		</div>
	
		
	<div class="container-fluid">
	  <div class="row-fluid">
	    <div class="span6">
	     	<table class="table table-bordered">
			 	<tr>
			 		<td colspan="2" id="header"><spring:message code="server.hostDetails" /></td>
			 	</tr>
			 	<tr>
			 		<td><b><spring:message code="server.hostName" /></b></td>
			 		<td>${hostName}</td>
			 	</tr>
			 	<tr>
			 		<td><b><spring:message code="server.appName" /></b></td>
			 		<td>${applicationName}</td>
			 	</tr>
			</table>
	    </div>
	    <div class="span3" style="float: right;">
	      	 <div id="divMessage">
		 		<div>
			 		<p style="font-size: 15px;font-weight: 600"><spring:message code="server.restart"/></p>
			 	</div>
			 	<br>
				<div style="margin-left: 20px;">
						<button class="btn btn-primary" id="reload" onclick="showMessage(event);"><spring:message code="server.restartbtn"/></button>
				</div>
		 	</div>
	    </div>
	  </div>
	</div>
 	
	
<script type="text/javascript">
 $(document).ready(function(){
	 var reload = "true";
	 var interval=1000*15;
	 var myInterval = undefined;
	 
	// For when after properies update 
	if('${update}'){
		$('#divMessage').hide();
		callReloadAjax(reload);
		
		$("#userMessage").modal({
			backdrop : 'static',
			keyboard : false
		});	
		
		myInterval = setInterval(update, interval);		
	}
		
	$('#reload').click(function(event) {
		
		var r = confirm('<spring:message code="reloadServer.wantToRestartServer"/>');
		if (r == true) {
			callReloadAjax(reload);
			
			$("#userMessage").modal({
				backdrop : 'static',
				keyboard : false
			});	
			
			myInterval = setInterval(update, interval);
		} 		
		
	});
	
 });

	function callReloadAjax(dat) {
		$.ajax({
			url : "reloadApp.ajax",
			type : "POST",
			data : dat,
			contentType : "application/json",
			dataType : "json",
			success : function(response) {
				//console.log(response);
			},
			error : function() {
				alert('<spring:message code="reloadServer.reloadServerFailed"/>');
			}
		}); 
	}	
	
	function update() {	
		$.ajax({
				url : "afterReloadRefresh.ajax",
				type : "POST",
				data : "true",
				contentType : "application/json",
				dataType : "json",
				success : function(response) {
					window.location.href = 'reload?reload=true';					
				},
				error : function() {					
					alert('<spring:message code="reloadServer.failedRefreshedReloadServer"/>');
				}
			}); 
	}

</script>
</body>
</html>
