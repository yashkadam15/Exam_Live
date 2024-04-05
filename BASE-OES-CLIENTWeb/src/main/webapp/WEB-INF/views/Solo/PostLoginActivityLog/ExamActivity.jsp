<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib  uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title><spring:message code="examlog.title"/></title>
<style type="text/css">
.input-mini {
  width: 50px;  
}

</style>
<script src="<c:url value='/resources/js/utilities.js'></c:url>"></script>
</head>
<body>
<c:choose>
			<c:when test="${isAdmin==1 }">
<fieldset class="well">
		<legend>
			<span><spring:message code="examlog.subtitle"/></span>
			
		</legend>
		<div class="holder">		
		<form:form  action="examActivityLogSearch" method="GET" class="form-horizontal">
				<div class="control-group " style="background:none;">
				<div class="control-label" style="width:250px;">
					<label  id="lbl"><spring:message code="resetExamStatus.CandidateUsername/LoginId"/>&nbsp;:&nbsp;</label></div>
				<div class="controls">
						<input type="text" id="username" value="${fn:escapeXml(username)}" name="username"/>
						
				</div>
				</div>
				<div class="control-group " style="background:none;">
					<div class="control-label" style="width:250px;"></div>
				<div class="controls" >
				<button type="submit" class="btn btn-blue" id="proceed">
							<spring:message code="global.proceed"/>
						</button>		
				</div>
				</div>				
		</form:form>
		<c:if test="${fn:length(candidateAttemptedExamList) != 0}">		
		
		<c:forEach var="viewModel" items="${candidateAttemptedExamList}" varStatus="i">	
	
		</c:forEach>	
		<table class="table table-striped table-bordered table-condensed" id="demotable" style="font-size:10pt;">
		<c:forEach var="viewModel" items="${candidateAttemptedExamList}" varStatus="i">	
		
		       <c:if test="${i.index==0}">			       
				<thead>					 
											
					<tr>
						<th><spring:message code="examlog.examevent"/></th>
						<th><spring:message code="examlog.paper"/></th>						
						<th><spring:message code="examlog.examactivitylog"/></th>						
					</tr>
				</thead>	
					</c:if>	
				<tbody>
			
					<tr>
					<td>${viewModel.examEvent.name}</td>
					<td>${viewModel.paper.name}</td>
					<td> 
					<c:choose>
			<c:when test="${viewModel.examEvent.enableLog==true }">
					<a href="examActivityLog?examEventId=${viewModel.candidateExam.fkExamEventID}&paperId=${viewModel.candidateExam.fkPaperID}&candidateId=${viewModel.candidateExam.fkCandidateID}&attemptNo=${viewModel.candidateExam.attemptNo}&username=${username}"><spring:message code="examlog.viewexamlog"/></a> 
				</c:when>
				<c:otherwise>
				<strong style="color: red; line-height: 10px;"><spring:message code="examlog.logDisabled"/></strong>				
				</c:otherwise>
				</c:choose>	
					</td>

					</tr>	
				   	
					</tbody>
				</c:forEach>	
			</table>			
		
		</c:if>
		<c:if test="${fn:length(candidateAttemptedExamList) == 0 && username!=null && username!=''}">	
		<div class="alert alert-info" style="height: 40%;"><b><spring:message code="global.42.warning"/></b></div>
		</c:if>	
		</div>

	</fieldset>
	</c:when>
			<c:otherwise>
			<fieldset class="well">
		<div>
			<legend>
				<span><spring:message code="bulkEndExam.notauthorized" /></span>
			</legend>
		</div>
		</fieldset>
			</c:otherwise>
			
			</c:choose>
	<script type="text/javascript">
		$(document).ready(function() {
			$('#proceed').click(function() {
			if($.trim($('#username').val())=='')
				{
					alert('<spring:message code="scoreCard.PleaseenterthecandidateLoginID"/>');
					return false;
				}
			return true;
			});
			
			
		});			
		
	</script>
</body>
</html>