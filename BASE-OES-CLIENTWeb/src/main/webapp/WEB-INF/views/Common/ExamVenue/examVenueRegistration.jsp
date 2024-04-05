<!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
 <%@ page errorPage="../Common/jsperror.jsp"%> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><spring:message code="examVenueActivation.title"></spring:message></title>

<script type="text/javascript" src="<c:url value='/resources/js/md5_encrypt.js'></c:url>"></script>

</head>

<body>

	   <br>
        <form:form method="post" style="border-top:0px;">
	
				<h3 align="center"><spring:message code="examVenueActivation.details"></spring:message></h3>
				<br>
				<div class="controls">
					<label class="control-label"><spring:message code="examVenueActivation.venueCode"></spring:message></label>
							<input type="text" id="venueCode" name="venueCode" required="required" value="" style="padding-left:5px;"/>
						
				</div>

				<div class="controls">
					<label class="control-label"><spring:message code="examVenueActivation.password" ></spring:message></label>
					
						<input type="password" id="password" name="password" required="required" value="" style="padding-left: 5px;"/>
					
				</div>
				<br>
				<div class="text-center">
						<button type="submit" class="btn btn-primary" id="btnSave"><spring:message code="examVenueActivation.activate"></spring:message></button>
				</div>
				<!-- <br> -->
				
		</form:form>
				<hr>
				<c:if test="${webVersion !=null}">
					<spring:message code="adminLogin.version"></spring:message> <fmt:formatNumber type="number" maxFractionDigits="2" minFractionDigits="1" value="${webVersion}" />
				</c:if>
		
  
<script type="text/javascript">
$('#btnSave').click(function() 
{
var userid=$("#venueCode").val();
var pass=$("#password").val();
var msg="";
var i=0;
if(userid=='')
	{
		msg+='<spring:message code="examVenueActivation.enterVenue" />';
		i=1;
	}
	if(pass=='')
	{
		msg+='\n\n<spring:message code="examVenueActivation.enterSubject" />';
		i=1;
	}
	if(i==1)
	{
		alert(msg);
		return false;
	}
	
	var hashMD5 = hex_md5($("#password").val());
	var salt = ${rnum};
	var saltHash = hex_md5(hashMD5+salt);
	$('#password').val(saltHash);
	
	return true;
	
	
});


</script>
  </body>
</html>