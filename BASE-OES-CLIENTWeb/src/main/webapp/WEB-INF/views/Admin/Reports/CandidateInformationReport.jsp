<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib  uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<title><spring:message code="CandidateInfoReport.title" /></title>
<spring:message code="project.resources" var="resourcespath" />
<link rel="stylesheet" type="text/css" href="<c:url value='/resources/style/dataTable.css'></c:url>" />
	
<style type="text/css">

.panel-primary {
border-color: #4e9ea3;
}
.table {
margin-bottom: 12px;
}
.panel {
padding-bottom:0.6px;
padding-top:5px;
padding-left:10px;
padding-right:10px;
margin-bottom: 20px;
background-color: white;
border: 1px solid #DDD;
border-radius: 10px;
border-color: #4e9ea3;
-webkit-box-shadow: 0 1px 1px rgba(0, 0, 0, 0.05);
box-shadow: 0 1px 1px rgba(0, 0, 0, 0.05);
}
.panel-title {
margin-top: 0;
margin-bottom: 0;
font-size: 17.5px;
font-weight: 500;
}
.panel-primary .panel-heading {
color: white;
background-color: #4e9ea3;
border-color: #4e9ea3;
}
.panel-heading {
padding: 10px 15px;
margin: -15px -11px 15px;
background-color: whiteSmoke;
border-bottom: 1px solid #DDD;
border-top-right-radius: 12px;
border-top-left-radius: 12px;
}
</style>	
</head>
<body>
	<fieldset class="well">
		<div>
			<legend>
				<span><spring:message code="CandidateInfoReport.title" /></span>
			</legend>
		</div>
		
		<div class="holder">
			<form:form  class="form-horizontal"  action="CandidateInformationReport" method="post" onsubmit="return validate();">
						
				<div class="control-group">
					<label class="control-label"><spring:message code="candidateTestReport.examEvent"></spring:message></label>
					<div class="controls">
						<select class="span4" id="examEventSelect" name="examEventSelect">							
							<option value="-1" selected="selected"><spring:message code="candidateTestReport.selectExamEvent"></spring:message></option>							
							<c:forEach items="${activeExamEventList }" var="eObj">
								<c:choose>
									<c:when test="${eObj.examEventID==examEventId}">
										<option value="${eObj.examEventID}" selected="selected">${eObj.name}</option>
									</c:when>
									<c:otherwise>
										<option value="${eObj.examEventID}">${eObj.name}</option>
									</c:otherwise>	
								</c:choose>
							</c:forEach>
						</select>
					</div>
				</div>

				<div  >
					<label class="control-label" for="paperName" id="paper-lbl"><spring:message code="passwordchange.username" /></label>
					<div class="controls">
						<input type="text" id="userName" name="userName" required="required" placeholder="Username">
					</div>
				</div>
				
				<br>				
				<div>
					<div class="controls">
						<button type="submit" class="btn btn-blue" ><spring:message code="examWiseMarkDetials.ViewReport" /></button>
					</div>
				</div>
				
			</form:form>
			</div>
	</fieldset>
	
		<fieldset class="well">
			<div class="holder">			
			
			<c:if test="${listCandidateInformationReport !=null && fn:length(listCandidateInformationReport) != 0}">
			
			<!--candidate list data table  -->
			
			<table class="table table-striped table-bordered" id="tblCandidateList">
				<tr>
					<td colspan="4"><b><spring:message code="attemptReport.candidateName" /></b><br> ${listCandidateInformationReport[0].candidate.candidateFirstName}&nbsp; ${listCandidateInformationReport[0].candidate.candidateLastName}</td>
					<td colspan="2"><b><spring:message code="syncExamData.UserName" />:</b><br> ${listCandidateInformationReport[0].candidate.candidateUserName}</td>
					<td colspan="2"><b><spring:message code="candidateTestReport.Password" />:</b><br> ${listCandidateInformationReport[0].candidate.candidatePassword}</td>
				</tr>
				<tr>
						<th><spring:message code="CandidateInfoReport.PaperId" /></th>
						<th><spring:message code="attemptReport.paperName" /></th>
						<th><spring:message code="scoreCard.ExamStatus" /></th>
						<th><spring:message code="CandidateInfoReport.ExamCompletionDate" /></th>
						<th><spring:message code="questAtmptCntReport.timeTaken" /></th>
						<th><spring:message code="CandidateInfoReport.MediaPlayCount" /></th>
						<th><spring:message code="viewtestscore.TotalQuestions" /></th>
						<th><spring:message code="CandidateInfoReport.TotalAttempted" /></th>							
				</tr>
				
				<c:if test="${listCandidateInformationReport !=null && fn:length(listCandidateInformationReport) != 0}">
					<tbody>
						<c:forEach var="CandidateInformation" items="${listCandidateInformationReport}">
							<tr>
								<td>${CandidateInformation.paper.paperID}</td>
								<td>${CandidateInformation.paper.name} <spring:message code="attemptnumber.label" />${CandidateInformation.candidateExam.attemptNo}<spring:message code="closingbracket.symbol" /></td>
								<td><c:choose>
										<c:when test="${CandidateInformation.candidateExam.isExamCompleted==true}">
											<spring:message code="scoreCard.Completed" />
										</c:when>
										<c:when test="${CandidateInformation.candidateExam.isExamCompleted==false}">
											<spring:message code="scoreCard.InComplete" />
										</c:when>
										<c:otherwise>
											<spring:message code="homepage.new" />
										</c:otherwise>
									</c:choose>
								</td>
								<td>
									<fmt:formatDate type="both" dateStyle="short" timeStyle="short" pattern="dd-MM-yyyy hh:mm:ss" value="${CandidateInformation.candidateExam.endDate}" />
								</td>
								<td>${CandidateInformation.candidateExam.elapsedTime}</td>
								<td width="30%">
									<c:if test="${CandidateInformation.candidateExam.isExamCompleted!=null && CandidateInformation.listSectionWiseMediaPlayCount !=null && fn:length(CandidateInformation.listSectionWiseMediaPlayCount) != 0}">
										<c:forEach var="SectionMediaPlay" items="${CandidateInformation.listSectionWiseMediaPlayCount}">
											<c:if test="${ SectionMediaPlay !=null && SectionMediaPlay.itemText !=null}">
												${SectionMediaPlay.itemText}
											</c:if> : ${SectionMediaPlay.mediaPlayCount}<br>
										</c:forEach>
									</c:if>
								</td>
								<td>
								  ${CandidateInformation.totalQue}
								</td>
								<td>
								  ${CandidateInformation.attemptedQueCount}
								</td>
							</tr>
						</c:forEach>
					</tbody>

				</c:if>
			</table>			
			<br><br>
			<!-- </div> -->
			</c:if> 	
			</div>
		</fieldset>
	
	<script type="text/javascript">
	 $(document).ready(function(){
		 
		 
							
	 }); /* End of document ready */
		
		function validate() {
			
			if($('#examEventSelect').val()==-1 || $('#examEventSelect').val()=='')
			{
				alert('<spring:message code="DisplayCategory.selectExamEvent" />');
				$("#examEventSelect").focus();
				return false;
			} 
			 
			return true;
		}
				
	</script>
	
	
	
</body>
</html>