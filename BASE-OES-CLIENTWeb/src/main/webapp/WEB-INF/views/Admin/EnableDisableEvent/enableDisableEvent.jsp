<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page errorPage="../common/jsperror.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<html>
<head>
<title><spring:message code="enableDisableEvent.header"/></title>
<spring:message code="project.resources" var="resourcespath" />
<script type="text/javascript">
$(document).ready(function() {
    
    	 <c:choose>
		    <c:when test="${mode=='0'}">  		    	
			$( "#disable" ).removeClass( "tab-pane" ).addClass( "tab-pane active" );		
			$( "#enable" ).removeClass( "tab-pane active" ).addClass( "tab-pane" );
		    </c:when>
		    <c:otherwise>			
		    $( "#disable" ).removeClass( "tab-pane active" ).addClass( "tab-pane" );	
			$( "#enable" ).removeClass( "tab-pane active" ).addClass( "tab-pane active" );
		    </c:otherwise>
		    </c:choose>
	});
	function validateDisableForm() {

		var hdnExamEventID = "";		
		var count=0;
		// get all checked item bank id's
		$('#eventdiv input:checked').each(function() {
			var vals = $(this).val();
			if (!(typeof vals === 'undefined')) {
				if (vals != '' && vals != 'NULL') {
					hdnExamEventID = hdnExamEventID + vals + ',';
					count = count+1;
				}
			}
		});	
	var listSize=$('#enableEventListSize').val();
		if(count == listSize)
			{
			alert("<spring:message code="enableDisableEvent.AtleastoneExamEventshouldbeenable"/>");
			return false;
			}
		if(count==0)
			{
			alert("<spring:message code="enableDisableEvent.SelectatleastoneexamEventtoDisable"/>");
			return false;
			}
		
		//alert(hdnExamEventID);
		$('#hdnDisableExamEventId').val(hdnExamEventID);
		return true;
	}
	function validateEnableForm() {

		var hdnExamEventID = "";		
		var count=0;
		// get all checked item bank id's
		$('#eventdivEnable input:checked').each(function() {
			var vals = $(this).val();
			if (!(typeof vals === 'undefined')) {
				if (vals != '' && vals != 'NULL') {
					hdnExamEventID = hdnExamEventID + vals + ',';
					count = count+1;
				}
			}
		});	
			
		if(count==0)
			{
			alert("<spring:message code="enableDisableEvent.SelectatleastoneExamEventtoenable"/>");
			return false;
			}
		$('#hdnEnableExamEventId').val(hdnExamEventID);
		return true;
	}
	
</script>

</head>
<body>

<fieldset class="well">
   <div>
	<legend>
			<span><spring:message code="enableDisableEvent.header"/></span>
	</legend>
	</div>
	
	<div class="holder" id="tabs">
		<ul class="nav nav-tabs" id="myTab">		
		<c:choose>
		<c:when test="${mode=='0'}">	
			<li  id="litab2" class="active"><a href="#disable" data-toggle="tab" id="tab1"><spring:message code="enableDisableEvent.tab1header"/></a></li>
			<li id="litab3"><a href="#enable" data-toggle="tab" id="tab2"><spring:message code="enableDisableEvent.tab2header"/></a></li>
		</c:when>
		<c:otherwise>
		   <li  id="litab2" ><a href="#disable" data-toggle="tab" id="tab1"><spring:message code="enableDisableEvent.tab1header"/></a></li>
			<li id="litab3" class="active"><a href="#enable" data-toggle="tab" id="tab2" ><spring:message code="enableDisableEvent.tab2header"/></a></li>
		</c:otherwise>
		</c:choose>
			
		</ul>
		
		<div class="tab-content">
		 <div id="disable" class="tab-pane active">
		 
		 	<div class="holder">
		 <form:form 	action="manageExamEvent" method="POST" class="form-horizontal">
		<input type="hidden" id="hdnDisableExamEventId" name="hdnDisableExamEventId"/>	
		<input type="hidden" id="enableEventListSize" name="enableEventListSize" value="${fn:length(examEventList)}">

		<c:choose>
		<c:when test="${fn:length(examEventList) > 1 && fn:length(examEventList)!=0}">
		<div id="eventdiv">
			          	<h4><spring:message code="enableDisableEvent.selectexameventtoDisable"/></h4>
			          	<table class="table">		          					      
							<c:forEach items="${examEventList}" var="eObj">									
						<tr><td><td><td><label class="checkbox"><input type="checkbox" value="${eObj.examEventID}">${eObj.name} </label></td></tr>													
							</c:forEach>		
							</table>					
		</div>	
		
		<div class="control-group">
				<div class="controls">
					<button class="btn btn-blue" onclick="return validateDisableForm();">
						<spring:message code="enableDisableEvent.disable"/>
					</button>
				</div>
			</div>
		</c:when>
		<c:otherwise>
		<br/>			
		<c:if test="${fn:length(examEventList)!=0}">
		<p><b><spring:message code="enableDisableEvent.currentlyEnableExamEventis"/></b>
	    ${examEventList.get(0).name} </p>
		</c:if>
		<div>
		<legend><spring:message code="enableDisableEvent.noExamEventAvailabletoDisable"/></legend>
		</div>
		</c:otherwise>	  
		</c:choose>
			
		</form:form>
		</div>		
	    </div>
	     
	     <div id="enable" class="tab-pane">
		 	<div class="holder">
		  <form:form action="manageExamEvent" method="POST" class="form-horizontal">				
			<input type="hidden" id="hdnEnableExamEventId" name="hdnEnableExamEventId"/>	
			<input type="hidden" id="disableEventListSize" name="disableEventListSize" value="${fn:length(examEventList2)}">
		
		<c:choose>
		<c:when test="${fn:length(examEventList2)!=0}">
		<div id="eventdivEnable">
		<br/>
			          	 <h4><spring:message code="enableDisableEvent.selectexamEventtoEnable"/></h4> 
			          	<table class="table">				   					      
							<c:forEach items="${examEventList2}" var="eObj">									
						<tr><td></td><td><label class="checkbox"><input type="checkbox" value="${eObj.examEventID}">${eObj.name} </label></td></tr>													
							</c:forEach>		
							</table>											
		</div>	
		 <div class="control-group">
				<div class="controls">
					<button class="btn btn-blue" onclick="return validateEnableForm();">
						<spring:message code="enableDisableEvent.enable"/>
					</button>
				</div>
			</div>
		
		</c:when>
		<c:otherwise>
		<br/>
		<legend><spring:message code="enableDisableEvent.noExamEventAvailabletoEnable"/></legend>
		</c:otherwise>
		</c:choose>
			  	
			
		   </form:form> 
		  </div>		
	     </div><!--  enable tab close -->
	     </div>	
	</div>
	</fieldset>
</body>
</html>