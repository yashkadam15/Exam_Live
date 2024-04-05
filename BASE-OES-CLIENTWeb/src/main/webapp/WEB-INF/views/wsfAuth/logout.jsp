<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html dir="ltr" lang="en">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><spring:message code="soloLoginPage.Title"/></title>
<script type="text/javascript">
$(document).ready(function(){	 	
		if(window != window.parent && window.parent.opener && !window.parent.opener.closed)
		{
			window.parent.opener.location.href = window.location.href;
			window.parent.close();
		}
		else if(window != window.parent && window.parent.opener==null)
		{
			window.parent.location.href = window.location.href;
		}
		else if(window == window.parent && window.parent.opener && !window.parent.opener.closed)
		{
			window.opener.location.href = window.location.href;
			window.close();
		}
});
</script>
</head>
<body>

<div style="text-align: center;height:260px;">
 <iframe src="${wsflogouturl}" style="display: none;"></iframe> 
<c:choose>
<c:when test="${isDualLogin!=null && isDualLogin=='1'}">
<input type="hidden" id="dl" value="1"/>
<h2 style="padding-top: 45px;"><spring:message code="multipleLoginMsg"/>&nbsp;${host}.
<br>
<a href="${wsflogouturl}"><spring:message code="wsAuth.loginMsg1"/></a>&nbsp; <spring:message code="wsAuth.loginMsg2"/>
</h2>
</c:when>
<c:otherwise>
<h2 style="padding-top: 95px;"><spring:message code="logoutmessage"/></h2>
</c:otherwise>
</c:choose>
</div>

			<p class="version" style="text-align: center;">
			<b>
			
				<%-- <a class="pull-left" href="../login/eventSelection"><spring:message code="soloLoginPage.SingleUserLogin"/></a> --%>
				<c:if test="${webVersion !=null}">
					<spring:message code="adminLogin.version"></spring:message> <fmt:formatNumber type="number" maxFractionDigits="2" minFractionDigits="1" value="${webVersion}" />
				</c:if>
				<%-- <a class="pull-right" href="../adminLogin/loginpage"><spring:message code="EventSelection.WebAdmin"/></a> --%></b>
			</p>
  
    

</body>
</html>