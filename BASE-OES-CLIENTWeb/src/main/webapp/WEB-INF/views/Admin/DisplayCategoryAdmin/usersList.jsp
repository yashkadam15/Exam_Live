<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page errorPage="../common/jsperror.jsp"%>

<html>
<head>
<title><spring:message code="DisplayCategory.usersList"/></title>
<spring:message code="project.resources" var="resourcespath" />

<link rel="stylesheet" type="text/css" href="<c:url value='/resources/style/dataTable.css'></c:url>" />
</head>

<body>

	<fieldset class="well">
	<div><legend><span><spring:message code="DisplayCategory.usersList"/></span></legend></div>
	<div class="holder">
		
		<div class="btn-group">
			<div style="float: left;" class="btn-group">
				<a class="btn btn-blue" href="../DisplayCategoryAdmin/createDisplayCategoryAdmin"><spring:message code="DisplayCategory.addUser"></spring:message></a>
			</div>
		</div>
		
	<br><br>
	<spring:message code="global.dateFormat" var="dateFormat" />
	<spring:message code="global.currencyCode" var="currencyCode" />
	<fmt:setTimeZone value="${sessionScope.timeZone}" />

	
		
		
		<c:if test="${fn:length(UserList) != 0}">
			<!--Integrated data table  -->
			<table class="table table-striped table-bordered" id="demotable">
				<thead>
					<tr>
						<th><spring:message code="DisplayCategory.uName"/></th>
						<th><spring:message code="DisplayCategory.userName"/></th>
						<th width="28%"><spring:message code="DisplayCategory.userEmail"/></th>
						<th><div class="visible-desktop">
								<spring:message code="global.update" />
							</div></th>
						<th width="27%"><div class="visible-desktop">
								<%-- <spring:message code="global.delete" /> --%><spring:message code="subadmin.changePermissions" /> 
							</div></th>
					</tr>
				</thead>
				<tfoot>
					<tr>
						<th><spring:message code="DisplayCategory.uName"/></th>
						<th><spring:message code="DisplayCategory.userName"/></th>
						<th><spring:message code="DisplayCategory.userEmail"/></th>
						<th><div class="visible-desktop">
								<spring:message code="global.update" />
							</div></th>
						<th><div class="visible-desktop">
								<spring:message code="subadmin.changePermissions" /> 
							</div></th>
					</tr>
				</tfoot>
				<c:if test="${fn:length(UserList) != 0}">
					<tbody>
						<c:forEach var="userobj" items="${UserList}">
							<tr>
								<td>${userobj.firstName} ${userobj.lastName}</td>
								<td>${userobj.userName}</td>
								<td>${userobj.email}</td>
								<td><a href="update?userID=${userobj.userID}"
									class="btn btn-blue"><spring:message code="global.update" /></a></td>
								
								<td><a href="changePermission?userID=${userobj.userID}"
									class="btn btn-blue"><spring:message code="subadmin.changePermissions" /></a>
								</td>
							</tr>
						</c:forEach>
					</tbody>

				</c:if>
			</table>
			<c:if test="${fn:length(UserList) != 0}">
				<!--Display count of records  -->
				<div class="span5">
					<spring:message code="global.pagination.showing"></spring:message>
					${pagination.start+1} - ${pagination.end}
					<spring:message code="global.pagination.of"></spring:message>
					<c:choose>
						<c:when test="${disableNext==true}">
							${pagination.end}
						</c:when>
						<c:otherwise>
							 <spring:message code="list.Many" />
						</c:otherwise>
					</c:choose>
				</div>

				<!--Display pagination buttons  -->
				<div class="dataTables_paginate paging_bootstrap pagination" align="right">
					<ul>
						<c:choose>
							<c:when
								test="${disablePrev==true || (fn:length(UserList)<=pagination.recordsPerPage && pagination.start==0)}">
								<li class="prev"><a href="#" id="prev_anchor_tag"
									style="display: none;">← <spring:message
											code="global.previous"></spring:message>
								</a></li>
							</c:when>
							<c:otherwise>
								<li class="prev"><a href="#" id="prev_anchor_tag">← <spring:message
											code="global.previous"></spring:message>
								</a></li>
							</c:otherwise>
						</c:choose>
						<c:choose>
							<c:when test="${disableNext==true}">
								<li class="next"><a href="#" id="next_anchor_tag"
									style="display: none;"><spring:message code="global.next"></spring:message>
										→ </a></li>
							</c:when>
							<c:otherwise>
								<li class="next"><a href="#" id="next_anchor_tag"><spring:message
											code="global.next"></spring:message> → </a></li>
							</c:otherwise>
						</c:choose>
					</ul>
					<!--Form For previous,next buttons  -->
					<form:form action="prev" method="POST" modelAttribute="pagination"
						id="prev_selector_for_the_form" name="prev_selector_for_the_form">
						<form:hidden path="end" />
						<form:hidden path="start" />
						<form:hidden path="recordsPerPage" />
						<input type="hidden" id="searchText" name="searchText"
							value="${searchText}" />
					</form:form>
					<form:form action="next" method="POST" modelAttribute="pagination"
						id="next_selector_for_the_form">
						<form:hidden path="end" />
						<form:hidden path="start" />
						<form:hidden path="recordsPerPage" />
						<input type="hidden" id="searchText" name="searchText"
							value="${searchText}" />
					</form:form>
				</div>
			</c:if>
		</c:if>
	</div>

	</fieldset>

	<script type="text/javascript" src="<c:url value='/resources/js/gridDataTable.js'></c:url>"></script>
	<script type="text/javascript">
		$(document).ready(function(){
			
			$("#prev_anchor_tag").click(function() {
				$("#prev_selector_for_the_form").submit();
				return false;
			});

			$("#next_anchor_tag").click(function() {
				$("#next_selector_for_the_form").submit();
				return false;
			});
			
							
		});

							

						
					
	</script>
 
 </body>
</html>