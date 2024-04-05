<!DOCTYPE html>
<%@ page isErrorPage="true" import="java.io.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="<c:url value='/resources/style/template.css?v=04042023A'></c:url>" rel="stylesheet">


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
<script>
	$(document).ready(function() {
		/* 	$('.field-options a.btn').tooltip(); */

		$('#to-top').click(function() {
			$('html, body').animate({
				scrollTop : 0
			}, 600);
			return false;
		});
	});
</script>
<!-- Main Page head and title -->
<title><sitemesh:write property='title' /></title>
<sitemesh:write property='head' />
</head>

<body class="inner">
	<div class="main container">
		<!--[if IE 7]>
    <span class="sidebg"></span>
    <![endif]-->
		<div class="row">
			<div class="left-sidebar span3">
				<div id="logo">
					<img src="<c:url value="../resources/images/logo.png"></c:url>"
						alt="OES">
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
						<div class="profile">
							<div class="holder">
								<div class="display-pic">
									<c:choose>
										<c:when
											test="${user != null && fn:length(user.userPhoto) > 0}">

											<div class="dp">
												<img src="${imgPath}${user.userPhoto}">
											</div>
										</c:when>

										<c:otherwise>

											<div class="dp">
												<img
													src="${imgPath}<spring:message code="instruction.defaultPhoto"/>">
											</div>


										</c:otherwise>
									</c:choose>
								</div>
								<div class="display-info">
									<p>${user.firstName}&nbsp;${user.lastName}</p>
									<div class="btn-group">
										<a class="btn btn-orange dropdown-toggle"
											data-toggle="dropdown" href="#"><spring:message code="detailsThemeDashboard.settings"/></a>
										<ul class="dropdown-menu">
											<!-- <li><a href="#">Profile</a></li>
											<li><a href="#">General Use</a></li> -->
											<c:if test="${sessionScope.user!=null }">
												<li><a href="../login/changePassword"><spring:message code="jspError.changePassword"/></a></li>
												<li><a href="../login/logout" class="btn btn-info"><font><spring:message code="detailsThemeDashboard.logout"/></font></a></li>
											</c:if>
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
					<div class="holder"></div>
				</div>

				<div class="main-content">
					<%@include file="../parts/message.jsp"%>
					<!-- Main Page Body -->

					<fieldset class="well">
						<legend>
			<span><spring:message code="global.error.notavailable"/>
		</span></legend>
		
		<p style="padding: 10px;font-size: 16px">
		<spring:message code="global.error.sorrymsg"/>
		</p>
						<div class="accordion" id="accordion2">
							<div class="accordion-group">
								<div class="accordion-heading" id="clickDiv">
									<a class="accordion-toggle" data-toggle="collapse"
										data-parent="#accordion2" href="#collapseOne"> <i
										class="icon-plus-sign" id="the-icon-element"></i> <spring:message code="global.error.moreinfo"/>
									</a>
								</div>
								<div id="collapseOne" class="accordion-body collapse">
									<div class="accordion-inner">
										<b><spring:message code="global.error.exceptions"/></b><br> <font color="red"><%=exception.getMessage()%>
										</font><br> 
										
									</div>
								</div>
							</div>
						</div>
						<script type="text/javascript">
							$(function() {
								$('#close').click(function() {
									var win = window.open("", "_self");
									win.close();
								});
							});
						</script>

						<script type="text/javascript">
							$("#clickDiv").click(
									function() {
										$('#the-icon-element').toggleClass(
												'icon-plus-sign').toggleClass(
												'icon-minus-sign');
									});
						</script>
					</fieldset>
				</div>
				<br>

				<!-- Footer -->

				<div class="footer span9">
					<div class="holder">
						<p class="pull-left">&copy; <spring:message code="jspError.error"/></p>
					<br><c:set var="IPvar" value="${fn:substringAfter(pageContext.request.localAddr,'.' )}" />

					<label style="font-size:12px; ">${fn:substringAfter(IPvar,'.')}</label>
						<a id="to-top" class="btn btn-grey pull-right" href="#"><i
							class="icon-chevron-up icon-greyer"></i></a>
					</div>
				</div>
			</div>
		</div>
	</div>

</body>
</html>