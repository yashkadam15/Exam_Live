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
				<form:form class="form-horizontal" action="../login/eventSelection" method="POST" id="eventSelectionform">
				<br>
				
				
					<!-- Form 1 Start -->
					<c:if test="${fn:length(examVenueExamEventAssociationList)!=0 }">
						<h3><spring:message code="EventSelection.PleaseSelectExamEvent"/></h3>
						<table class="table table-bordered-new table-striped">
							<thead>
								<tr class="showOffMobile">
									<th><spring:message code="EventSelection.Sr"/></th>
									<th><spring:message code="EventSelection.ExamEventName"/></th>
									<th><spring:message code="EventSelection.Description"/></th>
									<th><spring:message code="EventSelection.Select"/></th>
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
						
					 <c:if test="${examVenueExamEventAssociationList==null || fn:length(examVenueExamEventAssociationList)==0 }">
					<div  style="text-align: center;height:150px;">
						<h2>
						
							<span><spring:message code="EventSelection.PleasesynchronizeEventdata"/></span>
							</h2>
						
						</div>
					 </c:if> 
					
					<!-- Form 2 Start -->
					<c:if test="${examEvent!=null }">
						<c:choose>
							<c:when test="${secureBrowserCompatible eq false}">
								
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
												
											</div>
										</div>
									</div>
								
							</c:when>
							<c:otherwise>
							<input type="hidden" name="examEventID" value="${examEvent.examEventID}" />

						<h3><spring:message code="EventSelection.PleaseSelectLoginType"/></h3>

						<dl class="dl-horizontal">
							<dt><spring:message code="EventSelection.ExamEvent"/></dt>
							<dd>${examEvent.name}</dd>

						</dl>

						<table class="table table-complex">
							<tr>
								<c:forEach var="type" items="${loginType}">
									<c:if test="${admin!=type}">
										<c:choose>
											<c:when test="${type=='Solo' }">
												<td style="text-align: center;" align="center">
												<p><spring:message code="EventSelection.solo"/></p>
													<label>
													<span class="btn btn-login-type">
														<i class="icon-osp-xx-large icon-us-xx"></i>
														</span><br>
													<input type="radio" name="loginType" value="${type}" />
													</label>
												</td>
											</c:when>
											<c:when test="${type=='Group' }">
												<td style="text-align: center;">
												<p><spring:message code="EventSelection.group"/></p>	
												<label>
												<span class="btn btn-login-type">
													<i class="icon-osp-xx-large icon-usgroup-xx"></i>
													</span><br>													
													<input type="radio" name="loginType" value="${type}" />
												</label>
												</td>
											</c:when>
										</c:choose>
									</c:if>
								</c:forEach>
							</tr>
						</table>
						<div class="text-center">
							<button class="btn btn-primary"><spring:message code="EventSelection.Proceed"/></button>
						</div>
							</c:otherwise>
						</c:choose>						
						
					</c:if>
					<!-- Form 2 End -->
				</form:form>
				<p class="version">
				<b>
					<c:if test="${examEvent!=null }">
					<a class="pull-left" href="../login/eventSelection"><spring:message code="groupLoginPage.Back"/></a>
					</c:if>
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
							if ($('input:radio:checked').length > 0) {
								return true;
							} else {
								
								if($('input:radio[name^=examEventID]').length > 0 && $('input:radio[name^=examEventID]:checked').length <= 0)
								{
									alert('<spring:message code="EventSelection.PleaseselectappropriateExamevent"/>');
								}
								else if ($('input:radio[name^=loginType]').length > 0 && $('input:radio[name^=loginType]:checked').length <= 0)
								{
									alert('<spring:message code="EventSelection.PleaseselecttheLoginType"/>');
								}
								return false;
							}
						});

					});
</script>
		</body>
		</html>

		