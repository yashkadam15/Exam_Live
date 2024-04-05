<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%-- <%@ page errorPage="../common/jsperror.jsp"%> --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib  uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
<title>EventWiseDataDeletion</title>
<spring:message code="project.resources" var="resourcespath" />

<link rel="stylesheet" type="text/css" href="<c:url value='/resources/style/dataTable.css'></c:url>" />
<style type="text/css">
#myModal{
	    width: 750px !important;
	   
}
#myModalbody{
max-height:250px !important;
}
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
				<span>Event Wise Data Deletion</span>
			</legend>
		</div>
		
		<div class="holder" id="tabs">
		
		<div class="tab-content">
		 <div  class="tab-pane active">
			<form:form  class="form-horizontal" id="eventDeletionForm"  action="expiredEventList" method="get">
			
				  <c:choose>
					<c:when test="${eventArchivalStatus!=null}">
						<c:if test="${eventArchivalStatus.status=='Started'}">
							<h4>${examEventName}: Exam Event Data Archival is going on...</h4>
							<!-- <h5>${examEventName}</h5>
							 show Event name -->
						</c:if>		
					</c:when>
					<c:otherwise> 
						 <c:if test="${eventArchivalStatus!=null && eventArchivalStatus.status=='Exceptionallyclosed'}">
							<h4>${examEventName}: Event Data Archival is Exceptionally Closed</h4>
							<!-- show Event name -->
						</c:if> 
						<div class="control-group">
							<label class="control-label" for="inputEmail">Exam Event</label>
							<div class="controls">
								<select class="span4" id="examEventSelect" name="examEventSelect">
									<option value="-1" selected="selected">Select Exam Event</option>
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
								</select>&nbsp;&nbsp;<button type="button" class="btn btn-success" id="btnEventwiseDeleteData" name="btnEventwiseDeleteData">Proceed</button>
							<!-- Trigger the modal with a button -->
							  <button type="button" class="btn btn-success" id="archivalStatusid" name="btnEventwiseDeleteData" data-toggle="modal" data-target="#myModal">See Status</button>
							</div>
						</div>
					 </c:otherwise>
				</c:choose> 
			<input type="hidden" id="isActiveEvent" name="isActiveEvent" value="${isActiveEvent}"/>
 		</form:form>
 			 
		 <div id="myModal" class="modal fade" role="dialog" aria-labelledby="myModalLabel" data-keyboard="true" data-backdrop="static">
		  <div class="modal-dialog model-lg" role="document">
		    <div class="modal-content">
		      <div class="modal-header">
		        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
		        <h4 class="modal-title" id="gridSystemModalLabel">List of Event Archival Status</h4>
		     	 </div>
		     		 <div id="myModalbody" class="modal-body">
		       			 <div class="container-fluid">
		          			 <table class="table table-bordered-new2 table-striped">
								<thead>
									<tr>
										<th width=20%>EXAMEVENTID</th>
										<th width=20%>STARTTIME</th>
										<th width=20%>ENDTIME</th>
										<th width=20%>STATUS</th>
										<th width=20%>ARCHIVEDBY</th>
									</tr>
								</thead>
								<tbody id="statusTable1">
								</tbody>
							</table>
		       			 </div>
		     		 </div>
		     	 <div class="modal-footer">
		      		  <button type="button" class="btn btn-success" data-dismiss="modal">Close</button>       
		     	 </div>
		    </div><!-- /.modal-content -->
		  </div><!-- /.modal-dialog -->
		</div><!-- /.modal -->

			<%-- <div id="statusdiv1" style="border: 1px solid #297176;">
				 <table class="table table-bordered-new2 table-striped">
					<thead>
						<tr>
							<th width="10%">fkExamEventId</th>
							<th width="20%">STARTTIME</th>
							<th width="20%">ENDTIME</th>
							<th width="20%">STATUS</th>
							<th width="20%">ARCHIVEDBY</th>									
						</tr>
						</thead>
						<tbody id="statusTable1">
						<tr>
							<td>${eventArchivalStatus.eventArchivalStatusId}</td>
							<td>${eventArchivalStatus.fkExamEventId}</td>
							<td>${eventArchivalStatus.startDate}</td>
							<td>${eventArchivalStatus.endDate}</td>
							<td>${eventArchivalStatus.status}</td>
							<td>${eventArchivalStatus.archivedBy}</td>
						</tr>
					</tbody>
				</table> 
				</div> --%>
				<br><br>
				
			<div id="statusdiv2" style="border: 1px solid #297176; display:none;" >
				<table class="table table-bordered-new2 table-striped">
					<thead>
						<tr>
							<th width="20%">Table Name</th>
							<th width="20%">Status</th>																												
						</tr>
					</thead>
						<tbody id="tables">
							<c:forEach var="tableName" items="${enumExamEventDataDeletionTables}">
								<tr>
									<td id="tablemName">${tableName}</td>
									<td id="st_${tableName.ordinal()}"></td>														
								</tr>
							</c:forEach>
						</tbody>
				</table>
			</div>
		</div>		
	</div>
</fieldset>
	
	
		

<script type="text/javascript">
	var examEventID=0;
	var refreshInterval = null;
	 $(document).ready(function(){
		 
		if(${eventArchivalStatus!=null && eventArchivalStatus.status=='Started'}){
			examEventID='${eventArchivalStatus.fkExamEventId}';
			refreshInterval = setInterval(callDeletionStatus, 5000);
		}
		 
		// $("#statusdiv1").hide();
		 $("#statusdiv2").hide();
		 
		//if any event is active then not abled to delete
		/* if($('#isActiveEvent')){
				alert("Scheduled exam are going on so you can not delete any event data now");
				$('#examEventSelect').prop("disabled",true);
				$('#btnEventwiseDeleteData').prop("disabled",true);
				
			}
		else{
			$('#examEventSelect').prop("disabled",false);
			$('#btnEventwiseDeleteData').prop("disabled",true);
			} */
		// end of any event is active then not abled to delete
		
		// Click event for see status button
			$('#archivalStatusid').click(function(event){
				callEventArchivalStatusList();
				})
		
		// Click event for proceed button	
		 $('#btnEventwiseDeleteData').click(function(event) {
			 
			 if ($('#examEventSelect').val() == '-1') {
					alert('<spring:message code="DisplayCategory.selectExamEvent"/>');
					return false;
			}else{
				 $("#btnEventwiseDeleteData").prop('disabled',true);
				 $("#examEventSelect").prop("disabled",true);
			}  
			//$("#statusdiv1").show();
			$("#statusdiv2").show();
			
			 examEventID = $('#examEventSelect').val();
				
				var dat = JSON.stringify({
					"examEventID" : examEventID
				});
				if(examEventID!=-1)
				{
					callEventDataDeletionAjax(dat);	
					refreshInterval = setInterval(callDeletionStatus, 2000);
				
				}
			}); // end of proceed button change event

		});
				// call to start data archival event
				function callEventDataDeletionAjax(dat) { 
		 		
					$.ajax({
						url : "eventDataDeletion.ajax",									
						type : "POST",
						data : dat,
						contentType : "application/json",
						dataType : "json",
						success : function(response) {
							
							alert("data Archived successfully");
							setInterval('location.reload()',5000);
							
						},
						error : function() {
							 alert("Error in Data Deletion.....Please try again"); 
						}
					}); /* end of ajax */
				}


		// call to get a list of archived events with status
	   function callEventArchivalStatusList() {
		
		 $.ajax({
			url : "eventDeletionStatusList.ajax",									
			type : "GET",
			success: function (result) {
				 $('#statusTable1').empty();
				 var tableRow;
			       result.forEach(function(resultRow){
			    	   
			           tableRow =tableRow+ "<tr>"+
				          				"<td>"+resultRow.fkExamEventId+"</td>"+
				          				"<td>"+resultRow.startDateStr+"</td>"+
				          				"<td>"+resultRow.endDateStr+"</td>"+
				          				"<td>"+resultRow.status+"</td>"+
				          				"<td>"+resultRow.archivedBy+"</td>"+
			                           "</tr>";
			                          
			      			 });
			       
			       $('#statusTable1').append(tableRow);
			    },	
			error : function() {
				 alert("error in getting Archival Event list..."); 
			}
		}); 
	}
	
	  // to show status of on going event archival 
	  function callDeletionStatus() {

		 $("#statusdiv2").show();
			 var dat = JSON.stringify({
				"examEventID" : examEventID
			}); 
			
			 $.ajax({
				url : "deletionStatus.ajax",						
				type : "POST",
				data : dat,
				contentType : "application/json",
				dataType : "json",
				success : function(response) {
					 console.log("obj: "+response);
					if(response!=null){
						
					 	$.each(response, function(i, tableObj) {
						 	if(tableObj.tableName!='LAST_TABLE' && tableObj.endDate!=null)
							 {
						 		var css1= $('#st_'+tableObj.tableOrdinal).text("Completed");
						 		$(css1).css('color', 'green');
							 } else if(tableObj.tableName!='LAST_TABLE' && tableObj.endDate==null) {
							 		var css2=$('#st_'+tableObj.tableOrdinal).text("InProgress");
							 		$(css2).css('color', 'yellow');
							}else if(tableObj.tableName=="LAST_TABLE"){
								 	
							 		$('#st_'+tableObj.tableOrdinal).text("Archival is Completed");
							 		console.log("all Data Archival is Completed ");
							 		clearInterval(refreshInterval);
							 		//setInterval('location.reload()',2000);
							}	
						});	
					}
				},
				
				error : function() {
					alert("Error occured in getting deletionStatus of the tables.....");
					clearInterval(refreshInterval);
					setInterval('location.reload()',5000);
				}
				
			}); /* end of ajax */
				
		}
		
	</script>


</body>
</html>