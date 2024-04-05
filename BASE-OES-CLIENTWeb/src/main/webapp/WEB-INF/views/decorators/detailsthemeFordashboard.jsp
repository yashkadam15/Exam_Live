<!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<%--
<link href="<c:url value='/resources/style/bootstrap.css'></c:url>" rel="stylesheet">
<link href="<c:url value='/resources/style/responsive.css'></c:url>" rel="stylesheet">
<link href="<c:url value='/resources/style/style.css'></c:url>" rel="stylesheet">
<link href="<c:url value='/resources/style/template.css'></c:url>" rel="stylesheet">
--%>
<spring:theme code="curdetailtheme" var="curdetailtheme"/>
<link rel="stylesheet" href="<c:url value='${curdetailtheme}'></c:url>" type="text/css"/>
<link rel="stylesheet" href="<c:url value='/resources/style/selectFix.css'></c:url>" type="text/css" />
<!--[if lte IE 9]>
<style>
.side-menu li a:hover, .side-menu li a:hover a:focus {background-color: #000}
</style>
<![endif]-->
<!--[if IE 7]>
<style>
.profile {max-width:180px}
.profile .display-info .btn-orange {margin-top: -10px; padding-top: 0; padding-bottom: 5px;}
legend {margin-left: -7px}
.quick-nav .btn-grey {border:1px solid #ccc}
</style>
<![endif]-->
<script src="<c:url value='/resources/js/jquery-1.12.0.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/bootstrap.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/selectFix.js'></c:url>"></script>
<script src="https://www.wiris.net/demo/plugins/app/WIRISplugins.js?viewer=image"></script>
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
		$.ajaxSetup({ cache: false });

		$('.field-options a.btn').tooltip();

		$('#to-top').click(function() {
			$('html, body').animate({
				scrollTop : 0
			}, 600);
			return false;
		});
		if(navigator.userAgent.search('MOSB') >= 0){
	    	$('select').each(function(){
	    		$(this).fixCEFSelect();
	    	});
		}
	});
</script>
<!-- Main Page head and title -->
<title><sitemesh:write property='title' /></title>
<sitemesh:write property='head' />
</head>

<body class="dashboard">
	<div id="ajaxLoading" style="position: fixed;top: 0; right: 0; bottom: 0; left: 0;background-color: black; opacity: 0.5; display: none; z-index: 100; ">
		<img style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%);" src="<c:url value='/resources/images/ajaxload.svg'></c:url>"/>
	</div>
	<div class="main container">
		<!--[if IE 7]>
    <span class="sidebg"></span>
    <![endif]-->
		<div class="row">
			<div class="left-sidebar span3">
				<div id="logo">
					<img src="<c:url value='/resources/images/logo.png'></c:url>" alt="OES">
				</div>
				
				<!-- Navigation Bar -->
				<div class="navbar">
					<div class="navbar-inner">
						<div class="container">
						
						<!-- Left Menu -->
						<%@include file="../parts/leftmenu.jsp"%>
							
						</div>
					</div>
				</div>
			</div>
			<div class="content span9">
				<div class="content-above">
					<div class="holder">
						<form:form id="search">
							<input type="text" placeholder="Search ...">
							<button class="btn btn-orange" type="button">
								<i class="icon-search icon-white"></i>
							</button>
						</form:form>
						<div class="profile">
							<div class="holder">
								<div class="display-pic">
								
									<img src="<c:url value="../resources/images/dp.png"></c:url>" alt="">
								</div>
								<div class="display-info">
									<p><spring:message code="detailsThemeDashboard.chrisMartin"/></p>
									<div class="btn-group">
										<a class="btn btn-orange dropdown-toggle"
											data-toggle="dropdown" href="#"><spring:message code="detailsThemeDashboard.settings"/></a>
										<ul class="dropdown-menu">
											<li><a href="#"><spring:message code="detailsThemeDashboard.profile"/></a></li>
											<li><a href="#"><spring:message code="detailsThemeDashboard.generalUse"/></a></li>
											<li><a href="#"><spring:message code="detailsThemeDashboard.signature"/></a></li>
											<li><a href="login.html"><spring:message code="detailsThemeDashboard.logout"/></a></li>
										</ul>
									</div>
								</div>
							</div>
						</div>
						<div class="language">
							<div class="btn-group">
								<a class="btn btn-green dropdown-toggle" data-toggle="dropdown"
									href="#"><spring:message code="detailsThemeDashboard.language"/></a>
								<ul class="dropdown-menu">
									<li><a href="#"><spring:message code="detailsThemeDashboard.english"/></a></li>
									<li><a href="#"><spring:message code="detailsThemeDashboard.hindi"/></a></li>
								</ul>
							</div>
						</div>
					</div>
				</div>
				
				<!-- Top Menu -->
				
				<div class="content-top">
					<div class="holder">
						<a class="btn btn-grey" href="#"><i
							class="icon-signal icon-greyer"></i> <spring:message code="detailsThemeDashboard.reports"/></a> <a
							class="btn btn-grey" href="#"><i
							class="icon-random icon-greyer"></i> <spring:message code="detailsThemeDashboard.testSchedular"/></a>
						<div class="btn-group">
							<a class="btn btn-grey dropdown-toggle" data-toggle="dropdown"
								href="#"><i class="icon-check icon-greyer"></i> <spring:message code="detailsThemeDashboard.myTests"/> <i
								class="icon-dd"></i></a>
							<ul class="dropdown-menu">
								<li><a href="#"><spring:message code="detailsThemeDashboard.profile"/></a></li>
								<li><a href="#"><spring:message code="detailsThemeDashboard.generalUse"/></a></li>
								<li><a href="#"><spring:message code="detailsThemeDashboard.signature"/></a></li>
								<li><a href="#"><spring:message code="detailsThemeDashboard.logout"/></a></li>
							</ul>
						</div>
						<a class="btn btn-grey" href="#"><i
							class="icon-plus icon-greyer"></i> <spring:message code="detailsThemeDashboard.addNew"/></a>
					</div>
				</div>
				
				<div class="main-content">
				
				<!-- Main Page Body -->
	
				  <sitemesh:write property='body'/>
				</div>
				<br>
				
				<!-- Footer -->
				
				<div class="footer span9">
					<div class="holder">
						<p class="pull-left">&copy; <spring:message code="jspError.error"/></p>
						<a id="to-top" class="btn btn-grey pull-right" href="#"><i
							class="icon-chevron-up icon-greyer"></i></a>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>