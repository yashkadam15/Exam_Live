<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>

<script	src="<c:url value='/resources/js/jquery-1.12.0.min.js'></c:url>"></script>

<title><spring:message code="diabetesDignosticResult.healthAwarenessProgram"/></title>
<style type="text/css">
 u {
    text-decoration: none;
    border-bottom: 3px solid orange;
  }
  .pageborder{
  border-style: double;
  margin: 20px;
  page-break-after: auto;
  
  }
  
  @media print {
  #printbtn {
    display: none;
  }
  #backbtn{
  display: none;
  }
}​
</style>

<script type="text/javascript">
$(document).ready(function(){
	$('#printbtn').click(function(e){
		//$(this).hide();
		window.print();
	});
	
	
});
</script>
</head>
<body style="font-size: 11px;" >
	<div style="margin-right: 5%;margin-top: 1%;" align="center;">
			<c:choose>
				<c:when test="${sessionScope.user.object != null and sessionScope.user.isThirdPartySession == true and sessionScope.user.object.rUrl !=null and oesPartnerMaster != null}">
				<a class="btn btn-success"
					href="<c:url value="/gateway/backtopartner"></c:url>"><spring:message
						code="oesp.backto" />&nbsp;${oesPartnerMaster.partnerName}</a>
						<!-- Added on 08 Dec 2016 By Reena here to avoid extra condition based on hardcoded partner id =1 and make it generic for different partners   -->
						<input type="hidden" id="eraSentFlag" name="eraSentFlag" value="true" />
				</c:when>
				<c:otherwise>
					<a href="../candidateModule/homepage" id="backbtn" class="btn btn-success"><spring:message code="diabetesDiagnosticTestEnResult.backToDashboard"/></a>
				</c:otherwise>
			</c:choose>
	</div>
	<div class="pageborder" >
		<c:if test="${candidateSuggestionViewModelList==null || fn:length(candidateSuggestionViewModelList) == 0}">
			<spring:message code="supPassChange.noRecordFound"/>
		</c:if>
		<c:if test="${fn:length(candidateSuggestionViewModelList) != 0}">
		<div class="holder" style="padding:20px 20px 0 20px;">
		
		<div style="width: 100%;height:150px; font-weight:bold;vertical-align: middle;">
		
			<div style="text-align:center;width:100%;">
				<h2 style="padding-top: 30px;"><u><spring:message code="diabetesDiagnosticTestEnResult.awarenessPrgm"/></u></h2>
			</div>
			<div style="width:20%; position: absolute;right: 40;top: 40px;">
				<img alt="MKCL Logo" src="../resources/images/mkcllogoDDT.png" width="150px;">
			</div>
				
		
		</div>
		<center>
		<div style="width: 70%; border: solid #C7C9CB 3px;padding: 10px; border-radius: 15px;font-size:13;text-align: left; margin-top: -35px;">
			<b><spring:message code="diabetesDiagnosticTestEnResult.participantName"/></b> ${candidateExam.candidate.candidateFirstName} ${candidateExam.candidate.candidateMiddleName}  ${candidateExam.candidate.candidateLastName}
			<br><b><spring:message code="diabetesDiagnosticTestEnResult.centerCode"/></b> ${candidateExam.examVenue.examVenueCode}
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b><spring:message code="diabetesDiagnosticTestEnResult.centerName"/></b> ${candidateExam.examVenue.examVenueName}
			<br><b><spring:message code="diabetesDiagnosticTestEnResult.district"/></b> ${candidateExam.examVenue.examVenuePinCode}
		</div>
		</center>
		<br>
		<br>
		<br>
		<div style="width: 100%;font-weight: bold;"><spring:message code="diabetesDiagnosticTestEnResult.instruAccordingToGivenAns"/></div>
		
				
			
			
				<c:forEach items="${categoryList}" var="category">
				
					<c:set var="firstEle" value="1"></c:set>
					
					
					<c:forEach items="${candidateSuggestionViewModelList}" var="sm">						
						
						
						<c:if test="${sm.suggestionMaster.fkCategoryID == category.categoryID}">
							<c:if test="${firstEle=='1'}">
								<!-- <br> -->
								<p style="width: 100%;text-decoration: underline;font-weight: bold;"><b>${category.enCategoryName}</b></p>
								<c:set var="firstEle" value="0"></c:set>
							</c:if>
							<ul type="square" style="padding-left:15px;"><li>${sm.suggestionMaster.enSuggestionText} </li></ul>
						</c:if>
					</c:forEach>
			</c:forEach>
			
			<br><br>
			<div style="width: 100%;padding-bottom: 40px;"><b><spring:message code="diabetesDiagnosticTestEnResult.disclaimer"/></b> <spring:message code="diabetesDiagnosticTestEnResult.activityMsg"/></div>
			
			<div style="width: 100%;margin-bottom: 0px;">${candidateExam.candidate.candidateCode} / <fmt:formatDate type = "both" value = "${candidateExam.attemptDate}" /> / <c:if test="${candidateExam.candidate.candidateGender=='M'}"><spring:message code="diabetesDiagnosticTestEnResult.male"/></c:if><c:if test="${candidateExam.candidate.candidateGender=='F'}"><spring:message code="diabetesDiagnosticTestEnResult.female"/></c:if> / ${candidateExam.paper.name}</div>
		</div>
		</c:if>
	</div>
			<div style="margin-right: 5%;margin-top: 1%;" align="center;">
			<c:choose>
				<c:when test="${sessionScope.user.object != null and sessionScope.user.isThirdPartySession == true and sessionScope.user.object.rUrl !=null and oesPartnerMaster != null}">
					<a class="btn btn-success"
						href="<c:url value="/gateway/backtopartner"></c:url>"><spring:message
						code="oesp.backto" />&nbsp;${oesPartnerMaster.partnerName}</a>
						<!-- Added on 08 Dec 2016 By Reena here to avoid extra condition based on hardcoded partner id =1 and make it generic for different partners   -->
						<input type="hidden" id="eraSentFlag" name="eraSentFlag" value="true" />
				</c:when>
				<c:otherwise>
					<a href="../candidateModule/homepage" id="backbtn" class="btn btn-success"><spring:message code="diabetesDiagnosticTestEnResult.backToDashboard"/></a>
				</c:otherwise>
			</c:choose> 
				<c:if test="${fn:length(candidateSuggestionViewModelList) != 0}">
					<center> <button id="printbtn" class="btn btn-success">
					<spring:message code="shortArtInclination.print"></spring:message></button>
					</center>
				</c:if>
			</div>	
</body>
</html>