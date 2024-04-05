<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<html>
<head>
<title></title>
</head>
<body>
	<fieldset class="well">
		<legend>
			<span><img
				src="<c:url value="../resources/images/dashboard.png"></c:url>"
				alt=""> <spring:message code="homepage.MyHome" /></span>
			<%-- <span><spring:message code="subjectAdmin.name" /></span> --%>
		</legend>
		<div class="holder"></div>

		<!-- upload Data -->
		<%-- <%@include file="data --%>Upload.jsp"%>

		<script type="text/javascript">
			$(document).ready(function() {
				/*  added by YograjS Date 16 Aug 2014 */
				$("#btnok").click(function() {
					location.reload(true);
				});
			});
		</script>

	</fieldset>
</body>
</html>

