<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page isErrorPage="true" import="java.io.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<html>
<head>
<style>
</style>
</head>

<body>
	<div style="padding-top: 25px; padding-left: 25px; align-self: center;">
		<p style="font-size: 22px; color: #E47911;"><spring:message code="http403.prohibitSection"/></p>
		<br>

		<p style="font-size: 16px; color: #999999;"><spring:message code="http403.notAuthorized"/></p>
		<p style="font-size: 14px;"><spring:message code="http.techDetails"/> ${errorMessage}</p>
		<p style="font-size: 16px; color: #999999;">
			<spring:message code="http.goTo"/> <a href="../"><spring:message code="http.home"/></a> <spring:message code="http.page"/>
		</p>

	</div>
</body>

</html>