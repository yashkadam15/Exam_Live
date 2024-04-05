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
<title>Error</title>
<link href="<c:url value='/resources/style/template.css?v=04042023A'></c:url>" rel="stylesheet">
<script src="<c:url value='/resources/js/jquery-1.12.0.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/bootstrap.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/equalize.min.js'></c:url>"></script>
<style type="text/css">
h6 {
	font-size: 1.4em;
	font-weight: normal;
	color: #0088CC;
	font-family: "Lucida Sans Unicode", "Lucida Grande", sans-serif;
}
</style>
</head>
<body class="osp loginpage prelogin">

	<div class="main">
		<div class="well">
			<div class="logo-holder text-center">
				<%@include file="../../parts/message.jsp"%>
			</div>
		</div>
	</div>
</body>
</html>
