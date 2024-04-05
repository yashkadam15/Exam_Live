<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><spring:message code="EventSelection.Title"/></title>

</head>
<body>

			<div id="eventSelectionformdiv">
				<form:form class="form-horizontal" action="../wsfAuth/eventSelection" method="POST" id="eventSelectionform">				
				<br>
					<!-- Form 1 Start -->
					<c:if test="${fn:length(examVenueExamEventAssociationList)!=0 }">
						<input type="hidden" name="user" value="${user }">
						<h3><spring:message code="EventSelection.PleaseSelectExamEvent"/></h3>
						<table class="table table-bordered-new table-striped">
							<thead>
								<tr>
									<th width="10%"><spring:message code="EventSelection.Sr"/></th>
									<th width="38%"><spring:message code="EventSelection.ExamEventName"/></th>
									<th width="45%"><spring:message code="EventSelection.Description"/></th>
									<th width="7%"><spring:message code="EventSelection.Select"/></th>
								</tr>
							</thead>
							<tbody>
							<c:set var="srcnt" value="0"></c:set>
								<c:forEach var="examVenueExamEventAssociation" items="${examVenueExamEventAssociationList}" varStatus="i">
									<c:if test="${examVenueExamEventAssociation.isEventEnabled==true }">
									<c:set var="srcnt" value="${srcnt+1}"></c:set>
										<tr>
											<td>${srcnt}</td>
											<td>${examVenueExamEventAssociation.examEvent.name}</td>
											<td>${examVenueExamEventAssociation.examEvent.description}</td>
											<td><label class="radio"> <input type="radio" name="examEventID" id="eventRad${examVenueExamEventAssociation.examEvent.examEventID }" class="eventRadio" value="${examVenueExamEventAssociation.examEvent.examEventID }" />
											</label></td>
										</tr>

									</c:if>
								</c:forEach>
							</tbody>
						</table>
						<div class="text-center">
							<button class="btn btn-primary"><spring:message code="EventSelection.Proceed"/></button>
						</div>

					</c:if>
					<!-- Form 1 End -->

					<%-- <c:if test="${(examVenueExamEventAssociationList==null || fn:length(examVenueExamEventAssociationList)==0) && examEvent==null && error==null}">
					<div  style="text-align: center;height:150px;">
						<h2>
						
							<span><spring:message code="EventSelection.PleasesynchronizeEventdata"/></span>
							</h2>
						
						</div>
					</c:if> --%>
					<c:if test="${error!=null && error==1}">
					<div  style="text-align: center;height:150px;">
						<h2>
							<span><spring:message code="wsfAuth.loginFaildmsg"/> <a href="${wsflogouturl}"><spring:message code="wsAuth.loginMsg1"/></a>&nbsp; <spring:message code="wsAuth.loginMsg2"/></span>
							</h2>
						<iframe src="${wsflogouturl}" style="display: none;"></iframe> 
						</div>
					</c:if>
					<c:if test="${error!=null && error==2}">
					<div  style="text-align: center;height:150px;">
						<h2>
							<span><spring:message code="wsAuth.loginNotAllowed"/></span>
							</h2>						
						</div>
					</c:if>
					<!-- Form 2 Start -->
					<c:if  test="${secureBrowserCompatible eq false}">
						<iframe src="${wsflogouturl}" style="display: none;"></iframe> 
						<h2 style="text-align: center;color:#ec3a0f;">${examEvent.name}</h2>
						<div>
							<!-- <div class="intro">
								 <img alt="Introduction" src="../resources/images/login-img.jpg">
							</div> -->
							<div class="login-form">
								<div class="holder">
									<p style="text-align: center;">
										<b><spring:message code="audit.accessrestricted" /></b><br>
									</p>
									<%-- <h3>Your are currently using browser <b style="text-decoration:underline;">${browser} ${version}</b></h3> --%>
									 <spring:message code="audit.secureinstall.2" /><b style="text-decoration: underline;">  <spring:message code="audit.secureinstall.3" /> </b>   <spring:message code="audit.secureinstall.4" /> 
									<br><br> 
									<spring:message code="audit.secureinstall.1" /> <br> <br>
									<a href="${wsflogouturl}"><spring:message code="wsAuth.loginMsg1"/></a>&nbsp; <spring:message code="wsAuth.loginMsg2"/>
								</div>
							</div>
						</div>
					</c:if>
					<!-- Form 2 End -->
				</form:form>
				<p class="version">
				<b>
					<%-- <c:if test="${examEvent!=null }">
					<a class="pull-left" href="../login/eventSelection"><spring:message code="groupLoginPage.Back"/></a>
					</c:if> --%>
					<c:if test="${webVersion !=null}">
						<spring:message code="adminLogin.version"></spring:message> <fmt:formatNumber type="number" maxFractionDigits="2" minFractionDigits="1" value="${webVersion}" />
					</c:if>
					<%-- <a class="pull-right" href="../adminLogin/loginpage"><spring:message code="EventSelection.WebAdmin"/></a> --%>  </b>
				</p>


			</div>
<script type="text/javascript">
	$(document)
			.ready(
					function(e) {
					$(document).ready(function() {
							$('#to-top').click(function() {
								$('html, body').animate({
									scrollTop : 0
								}, 600);
								return false;
							});
						});

						

						$('#eventSelectionform').submit(function() {
							if ($('input:radio:checked').length > 0) 
							{
								return true;
							} 
							else 
							{
								alert('<spring:message code="EventSelection.PleaseselectappropriateExamevent"/>');
								return false;
							}
						});

					});
</script>
		</body>
		</html>

		