<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<!--[if IEMobile 7]><html dir="ltr" lang="en"class="iem7"><![endif]-->
<!--[if IE 7]><html dir="ltr" lang="en" class="ie7"><![endif]-->
<!--[if IE 8]><html dir="ltr" lang="en" class="ie8"><![endif]-->
<!--[if IE 9]><html dir="ltr" lang="en" class="ie9"><![endif]-->
<!--[if (gte IE 9)|(gt IEMobile 7)|!(IEMobile)|!(IE)]><!-->
<html dir="ltr" lang="en">
<!--<![endif]-->
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login</title>
<link href="<c:url value='/resources/style/template.css?v=04042023A'></c:url>" rel="stylesheet">
<script src="<c:url value='/resources/js/jquery-1.12.0.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/bootstrap.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/equalize.min.js'></c:url>"></script>
 <script>
$('#btnSave').click(function() 
{
var userid=$("#userid").val();
var pass=$("#pass").val();
var msg="";
var i=0;
if(userid=='')
	{
		msg+="Plese enter Username \n";
		i=1;
	}
	if(pass=='')
	{
		msg+="Plese enter Password \n";
		i=1;
	}
	if(i==1)
	{
		alert(msg);
		return false;
	}
	return true;
});
</script>
 </head>

<body class="login-page">


<div class="main">

    <fieldset class="well">
        <legend><img src="<c:url value="../resources/images/logo-grey.png"></c:url>" alt="OES"></legend>
        <%@include file="../../parts/message.jsp"%>
				      


        <form:form modelAttribute="user" action="../login/loginpage" method="POST" id="loginform">
        	<!-- <div class="intro">
				<img alt="ERA Introduction" src="../resources/images/login-img.jpg">
			</div> -->
            <div class="login-form">
            	<div class="holder">
            		<h2><spring:message code="selectEvent.select"></spring:message></h2>
            		<table >
            		<tr>
            		<td> <spring:message code="event.Event1"></spring:message>  </td>
            		<td> <button type="submit" class="btn btn-blue" id="btnSave">
                		<i class="icon-check icon-white"></i><spring:message code="event.Select"></spring:message>
                		</button> 
                	</tr>
            		</table>
            		         		
            	</div>             
            </div> 
        </form:form>
        <c:if test="${webVersion !=null}">
				<spring:message code="adminLogin.version"></spring:message> <fmt:formatNumber type="number" maxFractionDigits="2" minFractionDigits="1" value="${webVersion}" />
			</c:if>
    </fieldset>
</div>
</body>
</html>