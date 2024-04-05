<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html dir="ltr" lang="en">
<!--<![endif]-->
<head>

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<meta http-equiv="content-type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link href="<c:url value='/resources/style/template_DS.css?=v04042023A'></c:url>" rel="stylesheet">
<link rel="stylesheet" href="<c:url value='/resources/style/selectFix.css'></c:url>" type="text/css" />
<script src="<c:url value='/resources/js/jquery-1.12.0.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/bootstrap.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/equalize.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/selectFix.js'></c:url>"></script>
<script src="https://www.wiris.net/demo/plugins/app/WIRISplugins.js?viewer=image"></script>
<script type="text/javascript">
$(document).ready(function(){
    $('.osp.digital-school.loginpage .main').append('<div class="main-inner"></div>');
    if(navigator.userAgent.search('MOSB') >= 0){
    	$('select').each(function(){
    		$(this).fixCEFSelect();
    	});
	}
});
</script>
<title><sitemesh:write property='title' /></title>
<sitemesh:write property='head' />

</head>

<body class="osp digital-school inner loginpage division-group">
	<div class="main">
		<div class="osp-header">
			<div class="container">
				<div class="row"></div>
			</div>
		</div>
		<div class="osp-content">
			<div class="container">
				<div class="row">
					<div class="span12 main-content">
						<div class="content-holder">
							<div class="well">
								<div class="logo-holder text-center">
									<img
										src="<c:url value="/resources/images/logo-outer.png"></c:url>"
										alt="OES School Project">
								</div>
								<%@include file="../parts/message.jsp"%>

								<sitemesh:write property='body' />

							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="osp-footer">
			<div class="container">
				<div class="row">
					<div class="span8 copyright">
						<div class="holder">
							<c:if test="${isCopyRightEnabled}">
								<spring:message code="global.Copyright" />
								<spring:message code="global.footerCompanyName" />
							</c:if>
						</div>
					</div>
					<div class="span4 scroll-to-top">
						<div class="holder">
							<a id="to-top" class="btn" href="#"><i
								class="icon-osp-small icon-upper"></i></a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

</body>
</html>

