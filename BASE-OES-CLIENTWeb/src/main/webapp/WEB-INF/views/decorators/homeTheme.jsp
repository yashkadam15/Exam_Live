<!DOCTYPE html>
<!--[if IE 9]><html dir="ltr" lang="en" class="ie9"><![endif]-->
<!--[if (gte IE 9)|(gt IEMobile 7)|!(IEMobile)|!(IE)]><!--><html dir="ltr" lang="en"><!--<![endif]-->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<head>

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<meta http-equiv="content-type" content="text/html; charset=utf-8">
<link rel="icon" href="resources/images/favicon.ico">
<spring:theme code="homedetailtheme" var="homedetailtheme"/>
<link rel="stylesheet" href="<c:url value="${homedetailtheme}?v=04042023A"></c:url>" type="text/css" rel="stylesheet"/>

<%-- <link rel="stylesheet" href="<c:url value='/resources/style/template_home.css?v=04042023A'></c:url>" type="text/css" /> --%>
<script src="<c:url value='/resources/js/jquery-1.12.0.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/bootstrap.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/equalize.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/selectFix.js'></c:url>"></script>
<script src="https://www.wiris.net/demo/plugins/app/WIRISplugins.js?viewer=image"></script>

<spring:theme code="playertheme" var="playertheme"/>

<link rel="stylesheet" href="<c:url value='${playertheme}'></c:url>" type="text/css"/>
<script src="<c:url value='/resources/js/jquery.jplayer.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/oesplayer.js'></c:url>"></script>
<script>
$(document).ajaxStart(function() {
  	$('#ajaxLoading').show();
});

$(document).ajaxSuccess(function() {
	$('#ajaxLoading').hide();
});

$(document).ajaxError(function() {
	$('#ajaxLoading').hide();
  	alert('Error in fetching data.');
});
	$(document).ready(function() {	
		if(navigator.userAgent.search('MOSB') >= 0){
	    	$('select').each(function(){
	    		$(this).fixCEFSelect();
	    	});
		}
		
		
		
	});
	function playaudio(){
		$('#oes_MMplayer_1').jPlayer("play");
	}
</script>
<title><sitemesh:write property='title' /></title>
<sitemesh:write property='head' />
</head>
<body>
	<div id="ajaxLoading" style="position: fixed;top: 0; right: 0; bottom: 0; left: 0;background-color: black; opacity: 0.5; display: none; z-index: 100; ">
		<img style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%);" src="<c:url value='/resources/images/ajaxload.svg'></c:url>"/>
	</div>
	<div class="main">
	 <div style="float: right;padding-top: 20px;padding-right: 20px;z-index: 10;position: relative;">
		 <a href="#" id="audioclick" onclick="playaudio()">  <img  alt="Sample Audio" src="<c:url value="/resources/images/speaker-sm2.png"></c:url>"></a>
		 <div id="MMplayer_1" data-mediamode="exam" data-mediatype="audio" data-mediaurl="<c:url value="/resources/images/sampleaudio.mp3"></c:url>" data-mediaext="mp3" data-medialoadonready="true" style="display: none;"></div>
	 </div> 
    <div id="home">
		<sitemesh:write property='body' />
	</div>
	
	</div>
</body>
</html>

