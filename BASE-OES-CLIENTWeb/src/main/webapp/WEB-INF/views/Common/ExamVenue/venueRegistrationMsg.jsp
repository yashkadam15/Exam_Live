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
<br>
			<div id="eventSelectionformdiv">
				
					<div  style="text-align: center;height:150px;padding-top: 50px;">
						<h2><spring:message code="EventSelection.Venueregisteredsuccessfully"/></h2>
						<div class="text">
							<span><spring:message code="EventSelection.PleasesynchronizeEventdata"/></span>
							</div>
						
						</div>
				
				<p class="version">
				<b>
					<a class="pull-left" href="../login/eventSelection"><spring:message code="soloLoginPage.SingleUserLogin"/></a>
					<c:if test="${webVersion !=null}">
						<spring:message code="adminLogin.version"></spring:message> <fmt:formatNumber type="number" maxFractionDigits="2" minFractionDigits="1" value="${webVersion}" />
					</c:if>
					<%-- <a class="pull-right" href="../adminLogin/loginpage"><spring:message code="EventSelection.WebAdmin"/></a> --%></b>
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
					});
</script>
		</body>
		</html>

		