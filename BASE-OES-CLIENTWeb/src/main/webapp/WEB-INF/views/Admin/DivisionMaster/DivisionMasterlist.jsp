<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page errorPage="../common/jsperror.jsp"%>
<html>
<head>
<title><spring:message code="DivisionMasterlist.Title" /></title>
<spring:message code="project.resources" var="resourcespath" />
	
	
</head>

<body>

	<fieldset class="well">

   <legend><span><spring:message
						code="DivisionMasterlist.Title" /></span></legend>

		<div class="holder">
			<div style="float: left;" class="btn-group">
				<a class="btn btn-blue" href="DivisionMasteradd"><spring:message
						code="DivisionMasterlist.AddKey" /></a>
			</div>
		<br><br>

			<c:if test="${fn:length(DivisionMasterList) != 0}">
				<!--Integrated data table  -->
				
				<table class="table table-hover table-bordered" id="demotable">
					<thead>
						<tr>
							<th class="test-center"><spring:message code="DivisionMasterlist.divisionKey" /></th>
							<th class="span1"><div class="visible-desktop"><spring:message code="DivisionMasterlist.updateMaster"/></div></th>
							<th class="span1"><div class="visible-desktop"><spring:message code="DivisionMasterlist.deleteMaster"/></div></th>
						</tr>
					</thead>
					<tfoot>
						<tr>
							<th><spring:message code="DivisionMasterlist.divisionKey" /></th>
							<th><div class="visible-desktop"><spring:message code="DivisionMasterlist.updateMaster"/></div></th>
							<th><div class="visible-desktop"><spring:message code="DivisionMasterlist.deleteMaster"/></div></th>
						</tr>
					</tfoot>
					<c:if test="${fn:length(DivisionMasterList) != 0}">
						<tbody>
							<c:forEach var="listObj" items="${DivisionMasterList}">
								<tr>
									<td>${listObj.division}</td>
									<td><a href="update?divisionID=${listObj.divisionID}"
										class="btn btn-blue"><spring:message code="DivisionMasterlist.updateMaster"/></a></td>
									<td><a href="delete?divisionID=${listObj.divisionID}"
										class="btn btn-red"><spring:message code="DivisionMasterlist.deleteMaster"/></a></td>
								</tr>
							</c:forEach>
						</tbody>

					</c:if>
				</table>
				
				<!-------------------------------------------------New pagination------------------------->
			<c:if test="${fn:length(DivisionMasterList) != 0}">
				<div class="table-pagination row-fluid">
	                <div class="row-number  span5">
	                    <spring:message code="global.pagination.showing"></spring:message>
						${pagination.start+1} - ${pagination.end}
						<spring:message code="global.pagination.of"></spring:message>
						<c:choose>
							<c:when test="${disableNext==true}">
								${pagination.end}
							</c:when>
							<c:otherwise>
								<spring:message code="DivisionMasterlist.ManyKey"/>
							</c:otherwise>
						</c:choose>
	                </div>
	                <div class="pagination dataTables_paginate paging_bootstrap span7">
	                    <ul class="pull-right">
		                  	<c:choose>
								<c:when
									test="${disablePrev==true || (fn:length(DivisionMasterList)<=pagination.recordsPerPage && pagination.start==0)}">
									<li class="prev"><a href="#" id="prev_anchor_tag"
										style="display: none;">← <spring:message
												code="global.previous"></spring:message>
									</a></li>
								</c:when>
								<c:otherwise>
									<li class="prev"><a href="#" id="prev_anchor_tag">← <spring:message
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
	                    <form:form action="prev" method="POST" modelAttribute="pagination"
							id="prev_selector_for_the_form" name="prev_selector_for_the_form">
							<form:hidden path="end" />
							<form:hidden path="start" />
							<form:hidden path="recordsPerPage" />
							<input type="hidden" name="searchText" id="searchText" value="${searchText}" />
						</form:form>
						<form:form action="next" method="POST" modelAttribute="pagination"
							id="next_selector_for_the_form" name="next_selector_for_the_form">
							<form:hidden path="end" />
							<form:hidden path="start" />
							<form:hidden path="recordsPerPage" />
							<input type="hidden" name="searchText" id="searchText" value="${searchText}" />
						</form:form>
	                </div>
	            </div>
	     	</c:if>
            <!-------------------------------------------------New pagination------------------------->
				

			</c:if>
		</div>
	</fieldset>


	<script type="text/javascript">
		$(document).ready(function() {
			


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
