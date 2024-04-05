<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
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

	<div class="well">
		<legend>
			<span><spring:message code="DisplayCategory.updateAdmin" /></span>
		</legend>
		<div class="holder">


			<form:form modelAttribute="viewModel" action="update"
				method="POST" class="form-horizontal" enctype="multipart/form-data">

				<form:hidden path="user.userID" name="userID" id="userID" />


				<div class="control-group">
					<label id="division-lbl" class="control-label required"
						for="division"><spring:message code="DisplayCategory.uName" /></label>
					<div class="controls">
						<form:input path="user.uname" name="uname" id="uname" value=""
							class="text" size="25" required="required"
							placeholder="${typeSomething}" />
						<form:errors path="user.uname" cssClass="error"></form:errors>
					</div>
				</div>
				
				<div class="control-group">
					<label id="division-lbl" class="control-label required"
						for="division"><spring:message code="DisplayCategory.userEmail" /></label>
					<div class="controls">
						<form:input path="user.email" name="email" id="email" value=""
							class="text" size="25" required="required"
							placeholder="${typeSomething}" />
						<form:errors path="user.email" cssClass="error"></form:errors>
					</div>
				</div>
				
				<div class="control-group">
					<label id="division-lbl" class="control-label required"
						for="division"><spring:message code="DisplayCategory.userMobileNumber" /></label>
					<div class="controls">
						<form:input path="user.mobileNumber" name="mobileNumber" id="mobileNumber" value=""
							class="text" size="25" required="required"
							placeholder="${typeSomething}" />
						<form:errors path="user.mobileNumber" cssClass="error"></form:errors>
					</div>
				</div>

				<div class="control-group">
					<label id="division-lbl" class="control-label required"
						for="division"><spring:message code="DisplayCategory.userName" /></label>
					<div class="controls">
						<form:input path="user.userName" name="userName" id="userName" value=""
							class="text" size="25" required="required"
							placeholder="${typeSomething}" />
						<form:errors path="user.userName" cssClass="error"></form:errors>
					</div>
				</div>
				
				<%-- <div class="control-group">
					<label id="division-lbl" class="control-label required"
						for="division"><spring:message code="DisplayCategory.userPassword" /></label>
					<div class="controls">
						<form:input path="user.password" name="password" id="password" value=""
							class="text" size="25" required="required"
							placeholder="${typeSomething}" />
						<form:errors path="user.password" cssClass="error"></form:errors>
					</div>
				</div> --%>
				
				<div class="control-group">
					<label id="division-lbl" class="control-label required"
						for="division"><spring:message code="DisplayCategory.userPhoto" /></label>
					<div class="controls">
						<form:input type="file" name="file" id="file" path="" ></form:input>
					</div>
					<div class="controls">
						<img alt="Not available" src="${relativeFolderPath}" width="50" height="50">
					</div>
					<form:hidden path="user.userPhoto" name="userPhoto" id="userPhoto" value="${viewModel.user.userPhoto}"/>
				</div>
				
				
				<table class="table table-striped table-bordered">
					<tr>
						<th><spring:message code="DisplayCategory.divisions" /></th>
						<c:forEach items="${listSub}" var="sub">
						<th>${sub.subjectName}</th>
						</c:forEach></tr>
						<c:set var="counter" value="0"></c:set>
						
						<c:forEach items="${listDivMaster}" var="divMaster">
						<tr>
							<td>${divMaster.division}</td>
							<c:forEach items="${listSub}" var="sub">
							<c:set var="flag" value="0"></c:set>
							<c:forEach items="${viewModel.listAdminSubDivAssociation }" var="subAdmin"> 
								<c:choose>
									<c:when test="${subAdmin.fkDivisionID == divMaster.divisionID && subAdmin.fkSubjectID == sub.fkSubjectID && flag==0}">
										<c:set var="flag" value="1"></c:set>
									</c:when>		
															
								</c:choose>
							</c:forEach>
							${flag}
							<c:choose>
								<c:when test="${flag==1}">
									<td><form:checkbox path="listAdminSubDivAssociation[${counter }].fkSubjectID" value="${sub.fkSubjectID}" checked="checked"/>
									<form:hidden path="listAdminSubDivAssociation[${counter }].fkDivisionID" value="${divMaster.divisionID}"/>closed ck</td>
								</c:when>
								<c:otherwise> 
									<td>
									<form:checkbox path="listAdminSubDivAssociation[${counter}].fkSubjectID" value="${sub.fkSubjectID}"/>${sub.fkSubjectID}
									<form:hidden path="listAdminSubDivAssociation[${counter}].fkDivisionID" value="${divMaster.divisionID}" /></td>
							 </c:otherwise>
							</c:choose> 
							<c:set var="counter" value="${counter+1 }"></c:set>
							
							</c:forEach>
							
						</tr>
						</c:forEach>
					<!-- </tr>
				 -->
				</table>
				
				
				<!-- Button -->
				<div class="control-group">
					<div class="controls">
						<button type="submit" class="btn btn-blue">
							<spring:message code="global.save" />
						</button>
					</div>
				</div>
			</form:form>
		</div>
	</div>
	
	
	
	
	<script type="text/javascript">
		$(document).ready(function() {
			$('#changeLayout').click(function() {
				$(".toggleableForm").toggleClass("form-horizontal");
				return false;
			});

		});
	</script>
</body>
</html>
