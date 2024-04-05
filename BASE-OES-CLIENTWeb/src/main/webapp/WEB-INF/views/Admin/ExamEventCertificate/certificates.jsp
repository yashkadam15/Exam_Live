<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<title><spring:message code="certificate.eligibilitycertslabel"/></title>
<style>
.noborder {
	border: 0px;
}

.page {
	width: 20cm;
	min-height: 29.7cm;
	padding: 2cm;
	margin: 2cm;
	margin-right: 2cm;
	margin-left: 2cm;
	/* border: 1px #D3D3D3 solid; */
	/* border-radius: 5px; */
	background: white;
	/* box-shadow: 0 0 5px rgba(0, 0, 0, 0.1); */
}

@page {
	size: A4;
	margin-top: 10px;
}

@media print {
	.page {
		margin: 0;
		border: initial;
		border-radius: initial;
		width: initial;
		min-height: initial;
		max-height: 25cm;
		box-shadow: initial;
		background: initial;
		page-break-after: always;
	}
}
</style>
<script src="<c:url value='/resources/js/jquery-1.12.0.min.js'></c:url>"></script>
<script type="text/javascript">
 window.print();  
</script>
<spring:message code="project.resources" var="resourcespath" />
<link rel="stylesheet" type="text/css" href="<c:url value='/resources/style/dataTable.css'></c:url>" />
</head>
<body>
	<div class="book">
		<fieldset class="well" style="border: 0px">


			<c:forEach items="${templateTextList}" var="templateText">
				<div class="page">
					${templateText}
					</div>
				</div>
			</c:forEach>


		</fieldset>
	</div>
</body>
</html>