<!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<head>

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<meta http-equiv="content-type" content="text/html; charset=utf-8">

<link href="<c:url value='/resources/style/bootstrap.css'></c:url>" rel="stylesheet">
<script	src="<c:url value='/resources/js/jquery-1.12.0.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/bootstrap.min.js'></c:url>"></script>


<script>
$(document).ajaxStart(function() {
  	$('#ajaxLoading').show();
});

$(document).ajaxSuccess(function() {
	$('#ajaxLoading').hide();
});

$(document).ajaxError(function() {
	$('#ajaxLoading').hide();
  	alert('<spring:message code="appManagerTheme.errorFetchingData"/>');
});
	
</script>

<style type="text/css">
.header-section {
    box-shadow: 0 2px 10px 0 rgba(0,0,0,.2);
    background-image: linear-gradient(to left,#248de4,#0c5397);
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    z-index: 3;
}

.main{
	 margin-left: 35px;
     margin-right: 35px;
}
.btn-space{
    margin-left: 30px;
    color: white;
    text-decoration: none !important;
}
</style>
<title><sitemesh:write property='title' /></title>
<sitemesh:write property='head' />
</head>
<body>
	<div id="ajaxLoading" style="position: fixed;top: 0; right: 0; bottom: 0; left: 0;background-color: black; opacity: 0.5; display: none; z-index: 100; ">
		<img style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%);" src="<c:url value='/resources/images/ajaxload.svg'></c:url>"/>
	</div>
	<div class="main">
		<div class="row header-section">				
			<div class="span3" style="margin-left: 30px">
				<h4>App Manager</h4>
			</div>
			<div class="span4"></div>
			<div class="span5" style="margin-top: 5px;float: right;">
				<a class="btn-space" href="../appmanager/selectPropertiesFile">Home</a>
				<a class="btn-space" href="../appmanager/reload">RestartServer</a>
				<c:choose>
					<c:when test="${loginStatus!=null}">
						<a class="btn-space btn btn-danger" href="../appmanager/logout">Logout</a>
					</c:when>
					<c:otherwise>
						<a class="btn-space btn btn-success" href="../appmanager/login">Login</a>
					</c:otherwise>
				</c:choose>
				
			</div>
		</div>

		<div class="row" id="home" style="margin-top: 45px;">
			<%@include file="../parts/message.jsp"%>
			<!-- Main Page Body -->
			<sitemesh:write property='body' />
		</div>
	</div>
</body>
</html>

