<!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<html lang="en">
<head>

<meta name="viewport" content="width=device-width, initial-scale=1.0">


<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="<c:url value='/resources/style/selectFix.css'></c:url>" type="text/css" />
<%--
<link href="<c:url value='/resources/style/bootstrap.css'></c:url>" rel="stylesheet">
<link href="<c:url value='/resources/style/responsive.css'></c:url>" rel="stylesheet">
<link href="<c:url value='/resources/style/style.css'></c:url>" rel="stylesheet">
--%>
<link href="<c:url value='/resources/style/template_DS.css?=v04042023A'></c:url>" rel="stylesheet">


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
<script>
	$(document).ready(function() {
		$('.digital-school .main').append('<div class="sun-waves-bg"></div>');
	});
</script>
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
		/* 	$('.field-options a.btn').tooltip(); */
		$.ajaxSetup({
			cache : false
		});

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

<body class="inner digital-school">
	<div id="ajaxLoading" style="position: fixed;top: 0; right: 0; bottom: 0; left: 0;background-color: black; opacity: 0.5; display: none; z-index: 100; ">
		<img style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%);" src="<c:url value='/resources/images/ajaxload.svg'></c:url>"/>
	</div>
	<div class="main container">
	<input type="hidden" id="clientid" value="${clientid}"/>
		<!--[if IE 7]>
    <span class="sidebg"></span>
    <![endif]-->
		<div class="row">
			<div class="left-sidebar span3">
				<div id="logo">
					<img
						src="<c:url value='/resources/images/logo-inner.png'></c:url>"
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
										<c:when test="${sessionScope.user.groupMaster==null}">
											<c:choose>
												<c:when
													test="${venueUserList[0] != null && fn:length(venueUserList[0].userPhoto) > 0}">
													<div class="dp">
														<img src="${imgPath}${venueUserList[0].userPhoto}">
													</div>
												</c:when>
												<c:otherwise>
													<div class="dp">
														<img
															src="${imgPath}<spring:message code="instruction.defaultPhoto"/>">
													</div>
												</c:otherwise>
											</c:choose>
										</c:when>
										<c:otherwise>

										</c:otherwise>
									</c:choose>
								</div>
								<div class="display-info">
									<c:choose>
										<c:when test="${sessionScope.user.groupMaster==null }">
											<p>${venueUserList[0].firstName}&nbsp;${venueUserList[0].lastName}</p>
										</c:when>
										<c:otherwise>
											<p>${sessionScope.user.groupMaster.groupName}</p>
										</c:otherwise>
									</c:choose>
									<div class="btn-group">
										<c:if test="${sessionScope.user!=null }">
											<a href="../login/logout" class="btn btn-orange"><spring:message
													code="detailtheme.logout" /></a>
										</c:if>
										<%-- <a class="btn btn-orange dropdown-toggle"
											data-toggle="dropdown" href="#">settings</a>
										<ul class="dropdown-menu">
											<!-- <li><a href="#">Profile</a></li>
											<li><a href="#">General Use</a></li> -->
											<c:if test="${sessionScope.user!=null }">
												<c:if test="${sessionScope.user.groupMaster==null }">
													<li><a href="../login/changePassword">Change Password</a></li>
												</c:if>
												<li><a href="../login/logout" class="btn btn-info"><font>Logout</font></a></li>
                                            </c:if>	
			
										</ul> --%>
									</div>
								</div>
							</div>
						</div>
						<div class="language">
							<div class="btn-group">
								<!-- <a class="btn btn-green dropdown-toggle" data-toggle="dropdown"
									href="#">language</a>
								<ul class="dropdown-menu">
									<li><a href="#">English</a></li>
									<li><a href="#">Hindi</a></li>
								</ul> -->
								<c:if test="${sessionScope.user!=null }">
									<c:if test="${sessionScope.user.groupMaster==null }">
										<a href="../login/changePassword" class="btn changepswd-button"><spring:message
												code="detailtheme.chgpassword" /></a>
											&nbsp;|&nbsp;
										</c:if>
								</c:if>
							</div>
						</div>
					</div>
				</div>

				<!-- Top Menu -->
		<!-- reenak :Added on Dec 16 2014 -->
				<div class="content-top">
					<div class="holder">
						<c:if test="${loginType=='Admin'}">
							<!-- Menus for Administrator -->
							<%-- 	<c:if test="${roleID == 1}"> --%>
							<div class="quick-nav">
							<div class="btn-group">
									<a class="btn btn-grey dropdown-toggle" data-toggle="dropdown"
										href="#"><span><spring:message code="topmenu.Reports" /> <i class="icon-dd"
											style="vertical-align: middle;"></i></span>
									</a>
									<ul class="dropdown-menu pull-right">
										<c:if test="${roleID == 1 || roleID == 2}">
										<li style="text-align: left;"><a href="../loginReport/CandidateLoginReport"><i
													class="icon-list-alt" style="vertical-align: middle;"></i> <spring:message
														code="candidateloginReport.title" /></a></li>
											<li style="text-align: left;"><a href="../TestReport/CandidateTestReport"><i
													class="icon-list-alt" style="vertical-align: middle;"></i> <spring:message
														code="candidateTestReport.title" /></a></li>											
											<li style="text-align: left;"><a
												href="../candidateReport/CandidateAcademicSummaryReport"><i
													class="icon-list-alt" style="vertical-align: middle;"></i> <spring:message
														code="candidateAcademicSummaryReport.heading" /></a></li>											
											<c:if test="${roleID == 1}">
												<li style="text-align: left;"><a href="../adminLogin/scoreCard"><i
														class="icon-list-alt" style="vertical-align: middle;"></i> <spring:message
															code="leftmenu.CandidateScoreCard" /></a></li>
											</c:if>
											<c:if test="${sessionScope.eventgroupenable==true}">
												<li style="text-align: left;"><a href="../GroupReport/groupReport"><i
														class="icon-list-alt" style="vertical-align: middle;"></i> <spring:message
															code="GroupReport.header" /></a></li>
											</c:if>
											
											<!-- Peer assessment confidence report -->
											
												<c:if test="${roleID == 1}">
												<li style="text-align: left;"><a href="../peerAssessmentRpt/confidenceRpt"><i
														class="icon-list-alt" style="vertical-align: middle;"></i> <spring:message
															code="peerAssessment.confidenceLevelRpt" /></a></li>
											</c:if>
											
										</c:if>
									</ul>

								</div>
								
								<c:if test="${roleID == 1}">
								<div class="btn-group">
									<a class="btn btn-grey dropdown-toggle" data-toggle="dropdown"
										href="#"> <span><spring:message code="topmenu.BackupRestore" /> <i
											class="icon-dd" style="vertical-align: middle;"></i></span>
									</a>
									<ul class="dropdown-menu">
										
											<li style="text-align: left;"><a href="../syncData/dbBackupList"><i
													class="icon-download" style="vertical-align: middle;"></i>
												<spring:message code="leftmenu.DatabaseBackup" /></a></li>
											<li style="text-align: left;"><a href="../syncData/dbBackupRestoreList"><i
													class="icon-upload" style="vertical-align: middle;"></i>
												<spring:message code="leftmenu.RestoreDatabase" /></a></li>	
									</ul>

								</div>
									</c:if>
								
								
								<div class="btn-group">
									<a class="btn btn-grey dropdown-toggle" data-toggle="dropdown"
										href="#"><span><spring:message code="topmenu.TestScheduler" /> <i class="icon-dd"
											style="vertical-align: middle;"></i></span>
									</a>
									<ul class="dropdown-menu">
										<c:if test="${roleID == 1 || roleID == 2}">
											<li style="text-align: left;"><a href="../superviserModule/scheduleExam"><i
													class="icon-edit" style="vertical-align: middle;"></i> <spring:message
														code="menu.scheduleTests" /></a></li>
											<li style="text-align: left;"><a href="../superviserModule/viewExamSchedule"><i
													class="icon-list-alt" style="vertical-align: middle;"></i> <spring:message
														code="menu.viewSchedule" /></a></li>
											<c:if test="${sessionScope.eventgroupenable==true}">
												<li><a href="../groupSchedule/viewLabSessionSchedule"><i
														class="icon-list-alt" style="vertical-align: middle;"></i> <spring:message
															code="menu.viewGroupSchedule"></spring:message></a></li>
											</c:if>
										</c:if>
									</ul>

								</div>
							</div>
						</c:if>
						<!-- <a class="btn btn-grey" href="#"><i
							class="icon-signal icon-greyer"></i> Reports</a> -->
						<!--  <a
							class="btn btn-grey" href="#"><i
							class="icon-random icon-greyer"></i> Test Schedular</a> -->
						<!--<div class="btn-group">
							<a class="btn btn-grey dropdown-toggle" data-toggle="dropdown"
								href="#"><i class="icon-check icon-greyer"></i> My Tests <i
								class="icon-dd"></i></a>
							<ul class="dropdown-menu">
								<li><a href="#">Profile</a></li>
								<li><a href="#">General Use</a></li>
								<li><a href="#">Signature</a></li>
								<li><a href="#">Logout</a></li>
							</ul>
						</div>-->
						<!-- <a class="btn btn-grey" href="#"><i
							class="icon-plus icon-greyer"></i> Add New</a> -->
					</div>
				</div>

				<div class="main-content">
					<%@include file="../parts/message.jsp"%>
					<!-- Main Page Body -->

					<sitemesh:write property='body' />
				</div>
				<br>

				<!-- Footer -->

				<div class="footer span9">
					<div class="holder">
					<c:if test="${isCopyRightEnabled}">
						<p class="pull-left">
							<spring:message code="global.Copyright" />
							<spring:message code="global.footerCompanyName" />
						</p>
						</c:if>
						<a id="to-top" class="btn btn-grey pull-right" href="#"><i
							class="icon-chevron-up icon-greyer"></i></a>
					</div>
				</div>
			</div>
		</div>
	</div>

</body>
</html>