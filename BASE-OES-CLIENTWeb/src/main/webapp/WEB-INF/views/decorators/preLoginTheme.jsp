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
<!-- <link rel="icon" href="../resources/images/favicon.ico"> -->
<link rel="icon" href="<c:url value='/resources/images/favicon.ico'></c:url>">

<%-- <link href="<c:url value='/resources/style/template.css'></c:url>" rel="stylesheet"> --%>
<spring:theme code="curdetailtheme" var="curdetailtheme"/>
<link rel="stylesheet" href="<c:url value='${curdetailtheme}'></c:url>" type="text/css"/>
<link rel="stylesheet" href="<c:url value='/resources/style/selectFix.css'></c:url>" type="text/css" />
<script src="<c:url value='/resources/js/jquery-1.12.0.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/bootstrap.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/equalize.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/selectFix.js'></c:url>"></script>
<script src="https://www.wiris.net/demo/plugins/app/WIRISplugins.js?viewer=image"></script>
<%--
<spring:theme code="playertheme" var="playertheme"/>
<link rel="stylesheet" href="<c:url value='${playertheme}'></c:url>" type="text/css"/>
<script src="<c:url value='/resources/js/jquery.jplayer.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/oesplayer.js'></c:url>"></script>
--%>
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
	$(document).ready(function() {	
		if(navigator.userAgent.search('MOSB') >= 0){
	    	$('select').each(function(){
	    		$(this).fixCEFSelect();
	    	});
		}
	});
/* 	function playaudio(){
		$('#oes_MMplayer_1').jPlayer("play");
	} */
</script>
<title><sitemesh:write property='title' /></title>
<sitemesh:write property='head' />
</head>
<body class="osp inner loginpage division-group">
	<div id="ajaxLoading" style="position: fixed;top: 0; right: 0; bottom: 0; left: 0;background-color: black; opacity: 0.5; display: none; z-index: 100; ">
		<img style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%);" src="<c:url value='/resources/images/ajaxload.svg'></c:url>"/>
	</div>
	<div class="main">
		<div class="osp-header">
			<div class="container">
				<div class="row"></div>
			</div>
		</div>
		<div class="osp-content">
		<%-- <c:if test="${loginType!=null && examEventID!=null }">
			 <div style="float: right;padding-right: 20px;z-index: 10;position: relative;">
				 <a href="#" id="audioclick" onclick="playaudio()">  <img  alt="Sample Audio" src="<c:url value="/resources/images/speaker-sm2.png"></c:url>"></a>
				 <div id="MMplayer_1" data-mediamode="exam" data-mediatype="audio" data-mediaurl="<c:url value="/resources/images/sampleaudio.mp3"></c:url>" data-mediaext="mp3" data-medialoadonready="true" style="display: none;"></div>
			 </div>
		</c:if> --%>
			<div class="container">
				<div class="row">
					<div class="span12 main-content">
						<div class="content-holder">
							<div class="well">
								<div class="logo-holder text-center" style="padding-bottom : 10px;">
								<c:choose>
								<c:when test="${clientid==0}">
									
								</c:when>
								<c:otherwise>
									<img src="<c:url value='/resources/images/${clientid}_mkcloeslogo.png'></c:url>" alt="OES School Project">
								</c:otherwise>
								</c:choose>
								<hr id="dtSeprator" style="border-top: 1px solid #999;margin-bottom:10px; display: none;">
									<div style="text-align: center;">
				<b><span id="Date"></span></b>
				</div>	
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
						
						<c:choose>
						
						<c:when test="${clientid==0}">
							 
						</c:when>
						<c:otherwise>
							<c:if test="${isCopyRightEnabled}">
								<spring:message code="global.Copyright" /> &nbsp;&nbsp;
								<spring:message code="global.footerCompanyName" /> 
							</c:if>
							&nbsp;&nbsp;&nbsp; <c:set var="IPvar" value="${fn:substringAfter(pageContext.request.localAddr,'.' )}" />${fn:substringAfter(IPvar,'.')}
						</c:otherwise>
						</c:choose>
							
							
						</div>
					</div>
					<div class="span4 scroll-to-top">
						<div class="holder">
							<a id="to-top" class="btn" href="#"><i class="icon-osp-small icon-upper"></i></a>
							<a class="pull-right admintext" href="../adminLogin/loginpage"><spring:message code="preLoginTheme.administrator" /></a>							
						</div>
					</div>
					
				</div>
			</div>
		</div>
	</div>

</body>
</html>

