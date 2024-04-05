<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%-- <%@ taglib uri="http://www.springframework.org/tags/form" prefix="sf"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@ page errorPage="../common/jsperror.jsp" %> --%>

<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page errorPage="../common/jsperror.jsp"%>
<html>
	<head>
		<title>Select Properties File</title>	
	</head>
	<body>	
	<div>
		<div class="main-header text-center">
			<h3><spring:message code="select.propertiesfile"/></h3>
		</div>
		
		<form:form method="post" action="showPropertiesPage" modelAttribute="propObj">
			
				<div class="container" style="margin-top:30px;">
  					<div class="row-fluid">
					  <div class="span4">
						  <label class="control-label" for="select" style="font-size: 18px;">
						  	<b><spring:message code="select.file"/></b>
						  </label>
					  </div>
					  <div class="span8">
						  <form:select path="selectedFile" size="1" id="select" style="width:90% ; height: 37px;font-size:16px;"  required="true">
							  <form:option selected="selected" value="-1"> <spring:message code="select.select"/></form:option>
							  <form:options items="${fileList}" />
						  </form:select>
					  </div>
					</div>
				</div>
				  <div class="control-group text-center" style="margin-top: 10px;">
					  <form:button class="btn btn-success btn-rounded btn-long btn-sm mt-3" type="submit" id="proceed" value="Update" >
						<spring:message code="select.proceed"/>
					</form:button> 
				</div>
			    
		</form:form> 
		
	<script type="text/javascript">
		$(document).ready(function() {
			
		
			$('#proceed').click(function(){
				
				if ($("#select").val() === "-1") {
					alert("Please select File");
					return false;
				}
				return true;
			});
			
		});
			
		</script>
	</body>
</html>
