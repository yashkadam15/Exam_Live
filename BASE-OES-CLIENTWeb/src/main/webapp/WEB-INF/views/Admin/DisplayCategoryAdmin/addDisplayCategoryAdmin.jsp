<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page errorPage="../common/jsperror.jsp"%>
<html>
<head>
<title></title>
<spring:message code="project.resources" var="resourcespath" />
<style type="text/css">
.error {
	color: red;
}
</style>
</head>
<body>

	<fieldset class="well">
			<legend>
			<span><spring:message code="DisplayCategory.admin" /></span>
			</legend>
		<div class="holder">
				<%@include file="userDetails.jsp"%>		
				<form:form id="uDetails" action="proceed" method="GET" class="form-horizontal">
				<input type="hidden" id="userID" name="userID" value="${user.userID }"/>
				
				<div class="control-group">
					
					<label class="control-label" id="examEvent-lbl" for="examEvent"> <spring:message code="DisplayCategory.selectExamEvent" /> <span class="star">&#160;*</span>
					</label>

					<div class="controls">
						<select id="eventID" class="span4" name="eventID">
						<option value="-1" ><spring:message code="DisplayCategory.selectExamEvent" /></option>
							<c:forEach items="${listExamEvent}" var="examEvent">
							<c:choose>
							<c:when test="${eventid!=null && examEvent.examEventID==eventid}">
								<option selected="selected" value="${examEvent.examEventID}">${examEvent.name}</option>
							</c:when>
							<c:otherwise>
								<option value="${examEvent.examEventID}">${examEvent.name}</option>
							</c:otherwise>
							</c:choose>
								
							</c:forEach>
						</select>
					</div>
				</div>
				
				<div class="control-group">
					<div class="controls">
						
						<button type="submit" class="btn btn-blue" id="proceedbtn"
							name="proceedbtn">
							<spring:message code="DisplayCategory.proceed" />
						</button>
						
					</div>
				</div>
			
			</form:form>
	
			<c:if test="${viewModel != null }">
			<div id="displCategAss">
			<form:form modelAttribute="viewModel" action="saveUpdateDisplayCategoryAdmin"
				method="POST" class="form-horizontal" enctype="multipart/form-data">	
				<input type="hidden" id="userid" name="userid" value="${user.userID}"/>
				<input type="hidden" id="exameventid" name="exameventid" value="${eventid}"/>
				
				<table class="table table-striped table-bordered">
					<tr>
					<c:choose>
					<c:when test="${examEventCollectionType=='Division'}">
						<td><spring:message code="DisplayCategory.divisions" /></td>
						</c:when>
						<c:otherwise>
						<c:choose>
						<c:when test="${examEventCollectionType=='Batch'}">
						<td><spring:message code="DisplayCategory.batch" /></td>
						</c:when>
						</c:choose>
						</c:otherwise>
						
						</c:choose>
						<c:forEach items="${listDisplayCategoryLang}" var="sub">
							<td>${sub.displayCategoryName}</td>
						</c:forEach>
					</tr>
						<c:set var="counter" value="0"></c:set>
						<c:forEach items="${listCollectionMaster}" var="collectionMaster">
						<tr>
						<c:if test="${collectionMaster.collectionType!='None'}">
							<td>${collectionMaster.collectionName}</td>
							</c:if>
							<c:forEach items="${listDisplayCategoryLang}" var="sub">
							<c:set var="flag" value="0"></c:set>
							<%-- <c:set var="matchtext" value="BLANK"></c:set> --%>
							
							<c:forEach items="${viewModel.listAdminSubDivAssociation}" var="displaycategAdmin"> 
								<c:choose>
									<c:when test="${displaycategAdmin.fkCollectionID == collectionMaster.collectionID && displaycategAdmin.fkDisplayCategoryID == sub.fkDisplayCategoryID && flag==0}">										
										<c:set var="flag" value="1"></c:set>
										<%-- <c:set var="matchtext" value="${collectionMaster.divisionID}..${sub.fkDisplayCategoryID}=${displaycategAdmin.fkDivisionID}..${displaycategAdmin.fkDisplayCategoryID}"></c:set> --%>
									</c:when>		
															
								</c:choose>
							</c:forEach>
							<td>
							<c:choose>
								<c:when test="${flag==1}">
																  
								<input type="checkbox" id="listAdminSubDivAssociation[${counter}].fkDisplayCategoryID" name="listAdminSubDivAssociation[${counter}].fkDisplayCategoryID" value="${sub.fkDisplayCategoryID}" checked="checked" >
									<%-- <form:checkbox path="listAdminSubDivAssociation[${counter}].fkDisplayCategoryID" value="${sub.fkDisplayCategoryID}" checked="checked"/>	 --%>								
									
									<form:hidden path="listAdminSubDivAssociation[${counter}].fkCollectionID" value="${collectionMaster.collectionID}"/>
									<form:hidden path="listAdminSubDivAssociation[${counter}].fkUserID" value="${user.userID }"/>
									<form:hidden path="listAdminSubDivAssociation[${counter}].fkExamEventID" value="${eventid }"/>
								</c:when>
								<c:otherwise>
									<input type="checkbox" id="listAdminSubDivAssociation[${counter}].fkDisplayCategoryID" name="listAdminSubDivAssociation[${counter}].fkDisplayCategoryID" value="${sub.fkDisplayCategoryID}">
									<%-- <form:checkbox path="listAdminSubDivAssociation[${counter}].fkDisplayCategoryID" value="${sub.fkDisplayCategoryID}" /> --%>
									
									<form:hidden path="listAdminSubDivAssociation[${counter}].fkCollectionID" value="${collectionMaster.collectionID}" />
									<form:hidden path="listAdminSubDivAssociation[${counter}].fkUserID" value="${user.userID }"/>
									<form:hidden path="listAdminSubDivAssociation[${counter}].fkExamEventID" value="${eventid }"/>
							</c:otherwise>
							</c:choose>
							</td>
							<c:set var="counter" value="${counter+1}"></c:set>
							</c:forEach>
							
						</tr>
						</c:forEach>					
				</table>
				
				
				<!-- Button -->
				
				<div class="control-group">
					<div class="controls">
						
						<button type="submit" class="btn btn-blue" id="savebtn"
							name="savebtn">
							<spring:message code="global.save" />
						</button>
						
					</div>
				</div>
				
			</form:form>
			</div>
			</c:if>
			
		</div>
	</fieldset>
	
	
	
	
	<script type="text/javascript">
		$(document).ready(function() {
			$('#proceedbtn').click(function() {
				if($("#eventID").val()== -1){
					alert('<spring:message code="DisplayCategory.selectExamEvent" />');
					return false;
				}
			});

			$( "#eventID" ).change(function() {
				$('#displCategAss').hide();
				});
			
		});
	</script>
</body>
</html>
