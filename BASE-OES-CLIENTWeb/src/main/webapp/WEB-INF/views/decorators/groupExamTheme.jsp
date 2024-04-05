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

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><sitemesh:write property='title' /></title>
<sitemesh:write property='head' />

<spring:theme code="curdetailtheme" var="curdetailtheme" />
<spring:theme code="playertheme" var="playertheme" />

<%-- <link href="<c:url value='/resources/style/template.css'></c:url>" rel="stylesheet"> --%>
<link rel="stylesheet" href="<c:url value='${curdetailtheme}'></c:url>" type="text/css"/>
<link rel="stylesheet" href="<c:url value='/resources/style/selectFix.css'></c:url>" type="text/css" />
<link rel="stylesheet" href="<c:url value='${playertheme}'></c:url>" type="text/css" />
<script src="<c:url value='/resources/js/jquery-1.12.0.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/bootstrap.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/equalize.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/selectFix.js'></c:url>"></script>
<script src="https://www.wiris.net/demo/plugins/app/WIRISplugins.js?viewer=image"></script>
<!--[if lt IE 10]>
<script src="<c:url value='/resources/js/jquery.placeholder.min.js'></c:url>"></script>
<script>
$(document).ready(function(){
    $('input, textarea').placeholder();
});
</script>
<![endif]-->
<script>
	$(document).ready(function() {	
		if(navigator.userAgent.search('MOSB') >= 0){
	    	$('select').each(function(){
	    		$(this).fixCEFSelect();
	    	});
		}
	});
</script>
</head>
<body class="osp exam">
	<div class="main">


		<!-- Header -->
		<div class="osp-header">
			<div class="container">
				<div class="row">
					<div class="span12">
						<div class="holder">
							<img class="oes-logo pull-left" src="<c:url value="../resources/images/${clientid}_inner-mkcloeslogo.png"></c:url>" alt="" style="width: 9%"> ${paper.name }<img class="mkcl-logo pull-right" style="width: 3%" src="<c:url value= "../resources/images/${clientid}_companylogo.png"></c:url>" alt="">
						</div>

					</div>
				</div>
			</div>
		</div>
		
		 <sitemesh:write property='body'/>
		
		<div class="osp-footer">
			<div class="container">
				<div class="row">
					<div class="span8 copyright">
						<c:if test="${isCopyRightEnabled}">
							<div class="holder">
								<spring:message code="global.Copyright"/> <spring:message code="global.footerCompanyName"/>
							</div>
						</c:if>
					</div>
					<div class="span4 scroll-to-top">
						<div class="holder">
							<a id="to-top" class="btn" href="#"><i class="icon-osp-small icon-upper"></i></a>
						</div>
					</div>
				</div>
			</div>
		</div>


	</div>
	</body>
</html>