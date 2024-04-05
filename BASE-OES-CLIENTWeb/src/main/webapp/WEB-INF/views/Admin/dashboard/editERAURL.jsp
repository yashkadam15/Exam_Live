<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib  uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<title><spring:message code="editERAURL.Edit" /></title>
</head>
<body>
	<fieldset class="well">
		<legend>
			<span><spring:message code="editERAURL.EditERAURL" /></span>
		</legend>
		<div class="holder">
			<form:form  action="editERAURL" method="POST" class="form-horizontal" id="urlform">
				<div class="control-group">
					<label class="control-label" id="lbl"><spring:message code="editERAURL.ERAURL" />&nbsp;:</label>
				<div class="controls">
						<input type="text" id="eraURL" value="${eraAPIURL}" name="eraURL" style="width:70%;" placeholder="ERA Server IP Or ERA Server Name"/>
					</div>
				</div>
				<div style="padding-left: 200px;padding-top: 20px;">
					<button type="button" class="btn btn-blue" id="btnUpdate"	name="btnUpdate">
						<spring:message code="editERAURL.Update" />
					</button>
				</div>
			</form:form>
		</div>
	</fieldset>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#btnUpdate").click(function(){
				
				var url = $("#eraURL").val();
				if(url.length===0)
				{
					alert('<spring:message code="admindashboard.EnterValidERAURL" />');
					return false;
				}
				else
				{
					url='http://'+url+':4337/o/checkstatus'
					var dat = JSON.stringify({
						"name" : url
					});
					$.ajax({
					    type: 'POST',
					    url: "checkERAURL.ajax",
					    data: dat,
					    contentType : "application/json",
						dataType : "json",
					    success: function(response){
					        
					        console.log("success block: "+response);
							if(response)
							{
								$("#urlform").submit();
								return true;
							}
							else
							{
								alert('<spring:message code="admindashboard.EnterValidERAURL" />');
						    	return false;
							}
					    },
					    error: function(jqXHR, textStatus, errorThrown) {
					    	console.log('Status Code: '+jqXHR.status);
					    	console.log('Text Status: '+textStatus);
					    	console.log('Error: '+errorThrown);
					    	alert('<spring:message code="admindashboard.EnterValidERAURL" />');
					    	return false;
					    }
					});
				}
				//return false;
			});
		});
	</script>
</body>

</html>