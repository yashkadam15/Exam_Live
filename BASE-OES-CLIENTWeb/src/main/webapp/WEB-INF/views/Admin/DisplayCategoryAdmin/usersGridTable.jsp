<!DOCTYPE html>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="sf"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page errorPage="../common/jsperror.jsp"%>

<html>
<head>
<title><spring:message code="gridTable.allRecords" /></title>
<spring:message code="project.resources" var="resourcespath" />
<link rel="stylesheet" type="text/css" href="<c:url value='/resources/style/dataTable.css'></c:url>" />
</head>

<body>

	<h1>
		<spring:message code="gridTable.heading" />
		<div class="btn-group">
			<a class="btn btn-blue" href="../common/home"><spring:message
					code="gridTable.home" /></a><br>
		</div>
	</h1>
	<div class="holder">
		<spring:message code="global.dateFormat" var="dateFormat" />
		<spring:message code="global.currencyCode" var="currencyCode" />
		<h2>
			<center></center>
		</h2>

		<br>
		<table class="table table-striped table-bordered" id="dataTableDemo">
			<thead>
				<tr>
					<th><spring:message code="DisplayCategory.uName" /></th>
					<th><spring:message code="DisplayCategory.userName" /></th>
					<th><spring:message code="DisplayCategory.userEmail" /></th>
					
				</tr>
			</thead>
			<tbody>
				<c:forEach var="userobj" items="${usersList}">
					<tr>
						<td>${userobj.uname}</td>
						<td>${userobj.userName}</td>
						<td>${userobj.email}</td>
						<%-- <td>${something.gender}</td>
						<td><fmt:formatDate value="${something.dateOfBirth}"
								type="both" timeStyle="long" dateStyle="long"
								pattern="${dateFormat}" /></td>
						<td><div class="visible-desktop">
								<fmt:formatNumber type="CURRENCY" currencyCode="${currencyCode}"
									currencySymbol="">${something.someCurrency}</fmt:formatNumber>
							</div></td>
						<td>${something.someNumber}</td> --%>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		<br>
		<a class="btn btn-primary" href="../common/home"><spring:message
				code="gridTable.home" /></a>
	</div>

	<script type="text/javascript">
		$(document)
				.ready(
						function() {
							$('#dataTableDemo')
									.dataTable(
											{
												"sDom" : "<'row-fluid'<'span6'T><'span6'f>r>t<'row-fluid'<'span6'><'span6'>T>",
												"iDisplayLength" : -1,
												"aoColumns" : [ null, null,
														null, null, {
															"sType" : "numeric"
														} ],

												"oTableTools" : {
													"sSwfPath" : "../resources/media/csv_xls_pdf.swf",
													"aButtons" : [
															"copy",
															"print",
															{
																"sExtends" : "collection",
																"sButtonText" : 'Save <span class="caret" />',
																"aButtons" : [
																		"csv",
																		"xls",
																		"pdf" ]
															} ]
												}
											});
						});
	</script>

	<script type="text/javascript" src="<c:url value='/resources/js/gridDataTable.js'></c:url>"></script>
</body>
</html>