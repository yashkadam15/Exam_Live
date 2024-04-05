<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%--  <%@ page errorPage="../common/jsperror.jsp"%>  --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib  uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<title><spring:message code="GroupReport.header"/></title>

<spring:message code="project.resources" var="resourcespath" />
<script type="text/javascript" src="<c:url value='/resources/js/jquery-ui.js'></c:url>"></script>
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
			<span><spring:message code="GroupReport.header"/></span>
	</legend>
	</div>	
	
	 <div class="holder" >
	<div id="divForPreviousSchedule"> 
			<form:form  class="form-horizontal"  action="groupReport" method="get" onsubmit="return validate(this);">
			<input type="hidden" id="examEventID" name="examEventID" value="${examEventID}">
			<input type="hidden" id="collectionID" name="collectionID" value="${collectionID}">
			<input type="hidden" id="weekID" name="weekID" value="${weekID}">
			<input type="hidden" id="type" name="type" value="${type}">
			<input type="hidden" id="reportSize" name="reportSize" value="${reportSize}">
			
			<c:set value="${fn:length(reportMap)}" var="reportSize" scope="page"></c:set>				
	        
	          <div class="control-group">
					<label class="control-label" for="inputEmail"><spring:message code="scheduleExam.examEvent"></spring:message></label>
					<div class="controls">
						<select class="span4" id="examEventSelect" name="examEventSelect">
							<option value="-1" selected="selected"><spring:message code="scheduleExam.selectExamEvent"></spring:message></option>
							<c:forEach items="${activeExamEventList }" var="eObj">
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

				<div class="control-group" id="collectionDiv">				    
					<label class="control-label" for="inputEmail" id="collection-lbl"><spring:message code="scheduleExam.collection"></spring:message></label>
					<div class="controls">
						<select class="span4" id="divisionSelect" name="divisionSelect">
						</select>
					</div>
				</div>

				<div class="control-group">
					<label class="control-label" for="inputEmail"><spring:message code="scheduleExam.week"></spring:message></label>
					<div class="controls">
						<select class="span4" id="weekSelect" name="weekSelect">
						</select>
					</div>
				</div>
			<div class="control-group ">
			<div class="controls">
			
		    <button type="submit"  class="btn btn-blue"><spring:message code="GroupReport.getGroup"/></button>
		    <button type="button" class="btn btn-blue" id="genpdfbutton1" name="genpdfbutton"><spring:message code="GroupReport.generatePDF"/></button> 
		
			</div>
	       </div>
		   </form:form>					
			</div>
			
		<div id="buttondiv">	
		<form:form  class="form-horizontal"  action="groupReport" method="GET" onsubmit="return validate(this);">
		<input type="hidden" id="examEventID" name="examEventID" value="${examEventID}">			
			<input type="hidden" id="type" name="type" value="${type}">
			<input type="hidden" id="reportSize" name="reportSize" value="${reportSize}">
		  <div class="control-group">
					<label class="control-label" for="inputEmail"><spring:message code="scheduleExam.examEvent"></spring:message></label>
					<div class="controls">
						<select class="span4" id="examEventSelect" name="examEventSelect">
							<option value="-1" selected="selected"><spring:message code="scheduleExam.selectExamEvent"></spring:message></option>
							<c:forEach items="${activeExamEventList }" var="eObj">
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
				
			<div class="control-group ">
			<div class="controls">	
			<button type="submit"  class="btn btn-blue"><spring:message code="GroupReport.getReport"/></button>					
			<a class="btn btn-blue" onclick="validateScheduling(this)" href="../GroupReport/groupReport?type=1"><spring:message code="GroupReport.getpreviousReport" /></a> 		 
		    <button type="button" class="btn btn-blue" id="genpdfbutton2" name="genpdfbutton"><spring:message code="GroupReport.generatePDF"/></button>		
			
	       </div>
			</div>	
			</form:form>
	    </div>
    		
	        <form:form id="generatepdf" target="blank"  action="../GroupReport/GroupReport.pdf" >
	        <input type="hidden" id="examEventIDPDF" name="examEventIDPDF" value="${examEventID}">
			<input type="hidden" id="collectionIDPDF" name="collectionIDPDF" value="${collectionID}">
			<input type="hidden" id="weekIDPDF" name="weekIDPDF" value="${weekID}">
			 <input type="hidden" id="typePDF" name="typePDF" value="${type}">
			</form:form>
    <div class="reportDiv">
	<c:choose>
	<c:when test="${fn:length(reportMap)!=0 && reportMap!=null}">	
	<center><h5>${event.name}</h5></center>
	<c:forEach var="scheduleMap" items="${reportMap}" varStatus="j">	
	<table class="table table-striped table-bordered">
	<%-- <tr><th colspan="5"><center>${event.name}</center></th></tr> --%>
	<c:set var="srNo" value="1" scope="page" />	
	<tr><th colspan="5"><center><spring:message code="GroupReport.grouploginfor"/><fmt:formatDate value="${scheduleMap.key.scheduleStart}" pattern="dd/M/yyyy"/></center></th></tr>	
	
	<c:forEach var="collectionMap" items="${scheduleMap.value}" >	
	<tr>
	<c:if test="${collectionMap.key.collectionType!='None' }">
	<th colspan="5"> 
	<c:if test="${collectionMap.key.collectionType =='Division'}">
	<spring:message code="groupLoginPage.Division" /> : ${collectionMap.key.collectionName} 
	</c:if>
	<c:if test="${collectionMap.key.collectionType =='Batch'}">
	<spring:message code="groupLoginPage.Batch" /> : ${collectionMap.key.collectionName} 
	</c:if>	
	</th>
	</c:if>
	</tr>
	<tr>
	<th width="7%"><spring:message code="GroupReport.srno"/></th>
	<th width="13%"><spring:message code="GroupReport.groupName"/></th>
	<th width="30%"><spring:message code="GroupReport.candidateName"/></th>
	<th width="25%"><spring:message code="GroupReport.loginId"/></th>
	<th ><spring:message code="GroupReport.candidatephoto"/></th>
	</tr>
	
    <c:forEach var="groupMap" items="${collectionMap.value}" >	
  
    <c:forEach var="candidateObj" items="${groupMap.value}" varStatus="i">      
    
    <tr>
    <td>${srNo}<c:set var="srNo" value="${srNo+1}" scope="page" /></td>       
   
    <!-- Show Group Name only once -->
    <c:if test="${i.index==0}">      
     <td rowspan="${fn:length(groupMap.value)}" style="vertical-align:middle" >${groupMap.key.groupName}</td>    
    </c:if>
       
    <td>${candidateObj.candidateFirstName}  ${candidateObj.candidateLastName}</td>
	<td>${candidateObj.candidateUserName}</td>
	<td>
	<c:choose>
		<c:when test="${not empty candidateObj.candidatePhoto and fn:length(candidateObj.candidatePhoto) > 0}">
		
		<div class="dp"><img  class="imageSize" src="<c:url value="../${candidateObj.candidatePhoto}"></c:url>" onerror="this.src='${imgPath}<spring:message code="instruction.defaultPhoto"/>';"></div>
		</c:when>
	<c:otherwise>
		<div class="dp"><img class="imageSize" src="${imgPath}<spring:message code="instruction.defaultPhoto"/>" alt="default"></div>
		</c:otherwise>
	</c:choose>	
	</td>
    </tr>
   
    </c:forEach><!-- candidateList -->   
	</c:forEach><!-- Group -->	   
	</c:forEach><!-- Collection -->
	</table>	
	</c:forEach><!-- Schedule -->		
	</c:when>
	<c:otherwise>
	<c:if test="${examEventID!=null && type!=1}">
	<legend><spring:message code="GroupReport.warningmsg"/></legend>
	</c:if> 
	<c:if test="${(fn:length(reportMap)==0) && type==1 && examEventID!=null && pdfMsg!=1}">
	<legend><spring:message code="GroupReport.warningmsg2"/></legend>
	</c:if>
	<c:if test="${(fn:length(reportMap)==0) && type==1 && pdfMsg==1}">
	<legend><spring:message code="GroupReport.warningmsg3"/></legend>
	</c:if>
	</c:otherwise>
	</c:choose>
	</div>
	</div>
	
</fieldset>
<script type="text/javascript">
	 $(document).ready(function(){
		
		var type=$("#type").val();	    
		  if(type==0)
		  {
			  $("#divForPreviousSchedule").hide();		
		  }		 
		 
		 if(type==1)
		  {
			 $("#buttondiv").hide();			
		  }
		 
		 /* populate division and weeks on load  */
		 	examEventID = $('#examEventSelect').val();
		 	collectionID = $('#collectionID').val();		 	
			weekID=$('#weekID').val();			
			
		
			$("#collectionDiv").hide();		
		  
		 if($('#examEventSelect').val()!=-1)
			{
				var dat = JSON.stringify({ "examEventID" : examEventID }); 
				callExamEventAjax(dat,collectionID);		
				
				var dat1 = JSON.stringify({"fkExamEventID" : examEventID , "fkCollectionID" : collectionID }); 
				callDivisionAjax(dat1,weekID);	
			}
            
		 
		 
		/* examEvent change event */
		$('#examEventSelect').change(function(event) {
			
			$('#WeekWiseSubjectsGrid').hide();
			
			examEventID = $('#examEventSelect').val();
			/* after change of exam event set divisionSelect and weekSelect to select position */
			$('#divisionSelect').val(-1);	
			$('#weekSelect').val(-1);
			$("#weekSelect").find("option").remove();
			var dat = JSON.stringify({
				"examEventID" : examEventID
			});
			callExamEventAjax(dat,undefined);
		}); // end of examEventSelect change event

		$('#divisionSelect').change(function(event) {
			
			$('#WeekWiseSubjectsGrid').hide();
			
			examEventID = $('#examEventSelect').val();
			divisionID = $('#divisionSelect').val();
			var dat = JSON.stringify({
				"fkExamEventID" : examEventID,
				"fkCollectionID" : divisionID
			});
			callDivisionAjax(dat,undefined);
		}); // end of examEventSelect change event

		$('#weekSelect').change(function(event) {
			$('#WeekWiseSubjectsGrid').hide();
		});
		
		$('#genpdfbutton1').click(function(){
			generatePDF();				
			});
	 	$('#genpdfbutton2').click(function(){	
	 		var reportsize=$("#reportSize").val();
	 		if(reportsize==0)	
	 		{
	 		alert("<spring:message code="GroupReport.cantCreatePdfmsg"/>");
	 		}
	 		else 
	 	     {	
	 		var val=$("#type").val();	 		
	 		$("#typePDF").val($("#type").val());	
	 		$("#examEventIDPDF").val($("#examEventID").val());
			$('#generatepdf').submit();		
	 	     }
		}); 
		
	 });
	 
	 var collectionType="";
	 function generatePDF() 
	 {
		 var reportsize=$("#reportSize").val();
		 var flag=0;  
		 if($("#examEventSelect").val()==-1){
			    flag=1;
				alert("<spring:message code="DisplayCategory.selectExamEvent"/>");
				return false;
			}
			if($("#divisionSelect").val()==-1)
			{   flag=1;
				alert('<spring:message code="GroupReport.select"/>'+collectionType);
				$("#divisionSelect").focus();
				return false;
			} 
			 if($("#weekSelect").val()==-1)
				{   flag=1;
					alert('<spring:message code="GroupReport.selectSchedule"/>');
					$("#weekSelect").focus();
					return false;
				} 
			$("#examEventIDPDF").val($('#examEventSelect option:selected').val());
			$("#collectionIDPDF").val($('#divisionSelect option:selected').val());
			$("#weekIDPDF").val($("#weekSelect option:selected").val());
			$("#typePDF").val($("#type").val());				
			
			if(flag==0 && reportsize!=0)
			{					
				$('#generatepdf').submit();
			}
			else
			{
				alert("<spring:message code="GroupReport.cantCreatePdfmsg"/>");
			}
	 		
	 }
	 
	 
	 
	 function callExamEventAjax(dat,selectedId) {
			$.ajax({
				url : "divisionAccEventRole.ajax",
				type : "POST",
				data : dat,
				contentType : "application/json",
				dataType : "json",
				success : function(response) {
					displayDivision(response, selectedId);
				},
				error : function() {
					alert("<spring:message code="candidateAcademicSummaryReport.errorMsg"/>");
				}
			}); /* end of ajax */
		}
		function callDivisionAjax(dat,selectedId) {
			$.ajax({
				url : "WeekAccEventDivision.ajax",
				type : "POST",
				data : dat,
				contentType : "application/json",
				dataType : "json",
				success : function(response) {
					displayWeek(response, selectedId);					
				},
				error : function() {
					alert("<spring:message code="candidateAcademicSummaryReport.errorMsg"/>");
				}
			}); /* end of ajax */
		}
		function displayDivision(response, selectedId) {
			
				
			$("#divisionSelect").find("option").remove();			
					 
			//collectionType=response[0].collectionType;
			
			 if(response[0].collectionType=='Division')
			  {
				 $("#collection-lbl").html("<spring:message code="groupLoginPage.Division" />");
				 collectionType=  "<spring:message code="groupLoginPage.Division" />";
			  }else if(response[0].collectionType=='Batch')
				  {
				  $("#collection-lbl").html("<spring:message code="groupLoginPage.Batch" />");
				  collectionType="<spring:message code="groupLoginPage.Batch" />";
				  }  
			
			
			
			 // If Collection type is None, disable collection ddl and call collection ajax
			 if(response !='NULL' && response[0].collectionType=='None'){
				 $("#divisionSelect").append("<option value='" + response[0].collectionID + "' selected='selected'>"
									+ response[0].collectionName + "</option>");
				
				 //$("#collectionDiv").hide();
				 
				 // call for collection ajax
				 examEventID = $('#examEventSelect').val();
				 collectionID = $('#divisionSelect').val();
				 weekID=$('#weekID').val();				 
				 var dat = JSON.stringify({"fkExamEventID" : examEventID,"fkCollectionID" : collectionID});
				 if(weekID!="")
				 {
				 callDivisionAjax(dat,weekID);
				 }
				 else
				 {
				 callDivisionAjax(dat,-1); 
				  }
			 }else{
				 if(response !='NULL'){
					 $("#collection-lbl").html(collectionType);
				 }
				 // If collection type is division or batch
				  $("#collectionDiv").show();
				// $("#collectionSelect").prop("disabled",false);
				 $("#divisionSelect").append("<option value='-1'>--"+"<spring:message code="GroupReport.select"/> "+ collectionType+"--</option>");
				if (selectedId==0) {
					 $("#divisionSelect").append("<option value='0' selected='selected'>"+"<spring:message code="questionByquestion.all"/>"+"</option>");
				}
			   else{
					$("#divisionSelect").append("<option value='0'>"+"<spring:message code="questionByquestion.all"/>"+"</option>");
					
				}
				
				 $.each(response, function(i, collectionMaster) {
						if (selectedId && selectedId == collectionMaster.collectionID) {
							$("#divisionSelect").append("<option value='" + collectionMaster.collectionID + "' selected='selected'>"
											+ collectionMaster.collectionName + "</option>");
						} else {
							$("#divisionSelect").append("<option value='" + collectionMaster.collectionID + "'>"
											+ collectionMaster.collectionName + "</option>");
						}
				});
			 }		 
		
			
			
		} /* end of displayDivision */

		function displayWeek(response, selectedId) {
			
			
			$("#weekSelect").find("option").remove();
			$("#weekSelect").append("<option value='-1'>"+"<spring:message code="GroupReport.selectSchedule"/>"+"</option>");  
			
			if (selectedId==0) {
				 $("#weekSelect").append("<option value='0' selected='selected'>"+"<spring:message code="questionByquestion.all"/>"+"</option>");
			}
		   else{
				$("#weekSelect").append("<option value='0'>"+"<spring:message code="questionByquestion.all"/>"+"</option>");				
			}					
			 
			$.each(response, function(i, item) {			
				if (selectedId && selectedId == item.scheduleID) {			
					
					$("#weekSelect").append("<option value='" + item.scheduleID + "' selected='selected'>"
							+ $.datepicker.formatDate('M dd, yy',new Date(item.scheduleStart)) + "</option>");
					}
				else{
					/* alert("hi" +item.scheduleStart);  */
					$("#weekSelect").append(
							"<option value='" + item.scheduleID + "'>"
							+ $.datepicker.formatDate('M dd, yy',new Date(item.scheduleStart)) 							
							+ "</option>");	
				}
			});
		} /* end of displayDivision */
		
		function validate(form) {
			var e = form.elements;
			if(e['examEventSelect'].value==-1)
			{
				alert('<spring:message code="DisplayCategory.selectExamEvent"/>');
				$("#examEventSelect").focus();
				return false;
			} 
			 if(e['divisionSelect'].value==-1)
			{
				alert('<spring:message code="GroupReport.select"/> '+collectionType);
				$("#divisionSelect").focus();
				return false;
			} 
			 if(e['weekSelect'].value==-1)
				{
					alert('<spring:message code="GroupReport.selectSchedule"/>');
					$("#weekSelect").focus();
					return false;
				} 
			 
			 $("#collectionID").val($("#divisionSelect").val());	 
			 
			return true;
		}	
	</script>
</body>	 
	
</html>