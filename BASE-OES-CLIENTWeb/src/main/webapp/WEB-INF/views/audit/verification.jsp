<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>

<html dir="ltr" lang="en">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><spring:message code="soloLoginPage.Title" /></title>
</head>
<body>


								<form:form id="messageDiv">
									<div>
										<div class="intro">
											<!--  <img alt="ERA Introduction" src="../resources/images/login-img.jpg"> -->
										</div>
										<div class="login-form">
											<div class="holder">
												<legend id="lblMessage">${message} </legend>
												<p style="text-align: center;">
													<b><spring:message code="global.contactadmin" /></b>
												</p>
												<br>
												<div class="text-center">
													<a class="btn btn-inverse active btn-small"  href="../../"><spring:message code="verfication.reload" /></a>
												</div>
											</div>
										</div>
									</div>
								</form:form>

</body>
</html>