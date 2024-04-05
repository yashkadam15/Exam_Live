<!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<html lang="en">
<head>

<meta name="viewport" content="width=device-width, initial-scale=1.0">



<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<!-- <link rel="icon" href="../resources/images/favicon.ico"> -->
<link rel="icon" href="<c:url value='/resources/images/favicon.ico'></c:url>">

<%--
<link href="<c:url value='/resources/style/bootstrap.css'></c:url>" rel="stylesheet">
<link href="<c:url value='/resources/style/responsive.css'></c:url>" rel="stylesheet">
<link href="<c:url value='/resources/style/style.css'></c:url>" rel="stylesheet">
<link href="<c:url value='/resources/style/template.css'></c:url>" rel="stylesheet">
--%>

<spring:theme code="curdetailtheme" var="curdetailtheme" />
<link rel="stylesheet" href="<c:url value='${curdetailtheme}'></c:url>" type="text/css" />
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
	
	$(document).ajaxError(function(e) {
		$('#ajaxLoading').hide();
	  	alert('Error in fetching data.');
	  	console.log(e);
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
		if (navigator.userAgent.search('MOSB') >= 0) {
			$('select').each(function() {
				$(this).fixCEFSelect();
			});
		}
	});
</script>
<!-- Main Page head and title -->
<title><sitemesh:write property='title' /></title>
<sitemesh:write property='head' />
</head>

<body class="inner">
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
						src="<c:url value='/resources/images/${clientid}_inner-mkcloeslogo.png'></c:url>"
						alt="OES">

				</div>

				<!-- Navigation Bar -->
				<div class="navbar">
					<div class="navbar-inner">
						<div class="container">

							<!-- Left Menu -->
							<!-- Following condition comments as per requirement:: Ticket ID: 144489 : 19-Jan-2018 -->
							<%-- <c:if test="${clientid!=14 || (sessionScope.user.loginType!=null && sessionScope.user.loginType=='Admin')}"> --%>
								<%@include file="../parts/leftmenu.jsp"%>
							<%-- </c:if> --%>

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
												<c:when test = "${venueUserList[0] != null && fn:length(venueUserList[0].userPhoto) > 0 && fn:startsWith(venueUserList[0].userPhoto, 'http')}">
													<div class="dp">
														<img style="max-height: 50px; max-width: 25px;" src="${venueUserList[0].userPhoto}">
													</div>
												</c:when>
												<c:when	test="${venueUserList[0] != null && fn:length(venueUserList[0].userPhoto) > 0}">
													<div class="dp">
														<img style="max-height: 50px; max-width: 25px;" src="${imgPath}${venueUserList[0].userPhoto}">
													</div>
												</c:when>
												<c:otherwise>
													<div class="dp">
														<img style="max-height: 50px; max-width: 25px;" src="${imgPath}<spring:message code="instruction.defaultPhoto"/>">
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
										<!-- Following condition comments as per requirement:: Ticket ID: 144489 : 19-Jan-2018 -->
										<%-- <c:if test="${clientid!=14 || (sessionScope.user.loginType!=null && sessionScope.user.loginType=='Admin')}"> --%>
											<a href="../login/logout" class="btn btn-orange"><spring:message
													code="detailtheme.logout" /></a>
										<%-- </c:if> --%>
													
										</c:if>
										<%--get logout & change password buttons to outside of the dropdown-by Yograj 17-Sept-2014
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
								<!--replaced  language button with change password By Yograj 17-sep-2014 <a class="btn btn-green dropdown-toggle" data-toggle="dropdown"
									href="#">language</a>
								<ul class="dropdown-menu">
									<li><a href="#">English</a></li>
									<li><a href="#">Hindi</a></li>
								</ul> -->
								<c:if test="${sessionScope.user!=null }">
									<c:if
										test="${sessionScope.user.groupMaster==null && (roleID==1 || roleID==2)}">
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
						<c:if test="${loginType=='Admin' && roleID!=5}">
							<!-- Menus for Administrator -->
							<%-- 	<c:if test="${roleID == 1}"> --%>
							<div class="quick-nav">
								<div class="btn-group">
									<a class="btn btn-grey dropdown-toggle" data-toggle="dropdown"
										href="#"><span><spring:message
												code="topmenu.Reports" /> <i class="icon-dd"
											style="vertical-align: middle;"></i></span> </a>
									<ul class="dropdown-menu pull-right">
										<c:if test="${roleID == 1 || roleID == 2}">
											<li style="text-align: left;"><a
												href="../loginReport/CandidateLoginReport"><i
													class="icon-list-alt" style="vertical-align: middle;"></i>
													<spring:message code="candidateloginReport.title" /></a></li>
											<li style="text-align: left;"><a
												href="../TestReport/CandidateTestReport"><i
													class="icon-list-alt" style="vertical-align: middle;"></i>
													<spring:message code="candidateTestReport.title" /></a></li>
											<li style="text-align: left;"><a
												href="../candidateReport/CandidateAcademicSummaryReport"><i
													class="icon-list-alt" style="vertical-align: middle;"></i>
													<spring:message
														code="candidateAcademicSummaryReport.heading" /></a></li>
											<c:if test="${roleID == 1}">
												<li style="text-align: left;"><a
													href="../adminLogin/scoreCard"><i class="icon-list-alt"
														style="vertical-align: middle;"></i> <spring:message
															code="leftmenu.CandidateScoreCard" /></a></li>
														<li style="text-align: left;"><a
													href="../examEventClosure/examActivityLogSearch"><i class="icon-list-alt"
														style="vertical-align: middle;"></i> <spring:message
															code="examlog.title" /></a></li>				
															
											</c:if>
											
											
											<c:if test="${sessionScope.eventgroupenable==true}">
												<li style="text-align: left;"><a
													href="../GroupReport/groupReport"><i
														class="icon-list-alt" style="vertical-align: middle;"></i>
														<spring:message code="GroupReport.header" /></a></li>
											</c:if>
											<li style="text-align: left;"><a href="../report/prAbsReport"><i
													class="icon-list-alt"></i><spring:message code="presentreport.label"/></a></li>

											<li style="text-align: left;"><a href="../TestReport/sectionwisemarks"><i
													class="icon-list-alt"></i><spring:message code="MarkDistributionReport.title"/></a></li>
											<li style="text-align: left;"><a href="../ExamReports/markDetailsReport"><i
													class="icon-list-alt" style="vertical-align: middle;"></i><spring:message code="examWiseMarkDetials.menuName"/></a></li>
											<li style="text-align: left;"><a href="../TestReport/questAtmptCntRpt"><i
													class="icon-list-alt" style="vertical-align: middle;"></i><spring:message code="questAtmptCntReport.menuName"/></a></li>		
											
											<li style="text-align: left;"><a href="../candidateAttempt/attemptDetails"><i
													class="icon-list-alt" style="vertical-align: middle;"></i><spring:message code="attemptReport.title"/></a></li>		

										</c:if>
										<!-- Added one more role i.e. Call Center(4) for that added condition Yograj 24-Jun-2016 -->
										<c:if test="${roleID == 4}">
											<li style="text-align: left;">
												<a href="../loginReport/CandidateLoginReport"><i class="icon-list-alt" style="vertical-align: middle;"></i>
												<spring:message code="candidateloginReport.title" /></a>
											</li>
											<li style="text-align: left;">
												<a href="../report/prAbsReport"><i class="icon-list-alt"></i>
												<spring:message code="presentreport.label"/></a>
											</li>
											<li style="text-align: left;"><a href="../TestReport/questAtmptCntRpt"><i
													class="icon-list-alt" style="vertical-align: middle;"></i>
													<spring:message code="questAtmptCntReport.menuName"/></a></li>	
											
										</c:if>
										<c:if test="${roleID == 1 || roleID == 4}">
												<li style="text-align: left;"><a
												href="../CandidateInformation/CandidateInformationReport"><i
													class="icon-list-alt" style="vertical-align: middle;"></i>
													<spring:message code="CandidateInfoReport.title" /></a></li>
										</c:if>
										
									</ul>

								</div>

								<c:if test="${roleID == 1}">
									<div class="btn-group">
										<a class="btn btn-grey dropdown-toggle" data-toggle="dropdown"
											href="#"> <span><spring:message
													code="leftmenu.DatabaseBackup" /> <i class="icon-dd"
												style="vertical-align: middle;"></i></span>
										</a>
										<ul class="dropdown-menu">

											<li style="text-align: left;"><a
												href="../syncDataSMC/dbBackupList"><i class="icon-download"
													style="vertical-align: middle;"></i> <spring:message
														code="leftmenu.DatabaseBackup" /></a></li>
										</ul>

									</div>
								</c:if>

							<c:if test="${roleID == 1 || roleID == 2}">
								<div class="btn-group">
									<a class="btn btn-grey dropdown-toggle" data-toggle="dropdown"
										href="#"><span><spring:message
												code="topmenu.TestScheduler" /> <i class="icon-dd"
											style="vertical-align: middle;"></i></span> </a>
									<ul class="dropdown-menu">
										
											<li style="text-align: left;"><a
												href="../superviserModule/scheduleExam"><i
													class="icon-edit" style="vertical-align: middle;"></i> <spring:message
														code="menu.scheduleTests" /></a></li>
											<li style="text-align: left;"><a
												href="../superviserModule/viewExamSchedule"><i
													class="icon-list-alt" style="vertical-align: middle;"></i>
													<spring:message code="menu.viewSchedule" /></a></li>
											<c:if test="${sessionScope.eventgroupenable==true}">
												<li><a href="../groupSchedule/viewLabSessionSchedule"><i
														class="icon-list-alt" style="vertical-align: middle;"></i>
														<spring:message code="menu.viewGroupSchedule"></spring:message></a></li>
											</c:if>
										
									</ul>

								</div>
							</c:if>
							</div>
						</c:if>
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
						<p class="pull-left">
							<c:if test="${isCopyRightEnabled}">
								<spring:message code="global.Copyright" /> &nbsp;&nbsp;
								<spring:message code="global.footerCompanyName" />
							</c:if>
							&nbsp;&nbsp;<c:set var="IPvar" value="${fn:substringAfter(pageContext.request.localAddr,'.' )}" />${fn:substringAfter(IPvar,'.')}
						</p>
						<a id="to-top" class="btn btn-grey pull-right" href="#"><i
							class="icon-chevron-up icon-greyer"></i></a>
					</div>
				</div>
			</div>
		</div>
	</div>
<!--Exam Client data -->
<input type="hidden" id="eventId" value="${sessionScope.user.examEvent.examEventID}"/>
</body>
</html>