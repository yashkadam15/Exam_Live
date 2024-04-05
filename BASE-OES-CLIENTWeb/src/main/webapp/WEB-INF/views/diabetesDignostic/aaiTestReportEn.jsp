<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>

<head>
	<script src="../resources/js/jquery-3.5.1.min.js"></script>
	<script src="../resources/js/bootstrap.bundle.min.js"></script>
	<link rel="stylesheet" href="../resources/stylesheet/bootstrap.css">    
	<link rel="stylesheet" href="../resources/stylesheet/stylesheet.css">
	<link rel="stylesheet" href="../resources/stylesheet/print-style.css">  
	<script src="https://www.wiris.net/demo/plugins/app/WIRISplugins.js?viewer=image"></script>
	<script	src="<c:url value="../resources/js/jquery-1.9.0.min.js"></c:url>"></script>
	<title><spring:message code="diabetesDignosticResult.healthAwarenessProgram"/></title>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<script type="text/javascript">
	$(document).ready(function(){
		$('#printbtn').click(function(e){
			window.print();
		});
	});
	</script>
<style type="text/css">
  
  @media print {
  #printbtn {
    display: none;
  }
  #backbtn{
  display: none;
  }
}​
</style>
</head>
<body>
	<main class="main-content">
	<div style="margin-bottom:10px;">
	 	<c:choose>
			<c:when test="${sessionScope.user.object != null and sessionScope.user.isThirdPartySession == true and sessionScope.user.object.rUrl !=null and oesPartnerMaster != null}">
				<a class="btn-sm btn-primary"
					href="<c:url value="/gateway/backtopartner"></c:url>"><spring:message
					code="oesp.backto" />&nbsp;${oesPartnerMaster.partnerName}</a>
					<input type="hidden" id="eraSentFlag" name="eraSentFlag" value="true" />
			</c:when>
			<c:otherwise>
				<a href="../candidateModule/homepage" id="backbtn" class="btn-sm btn-primary"><spring:message code="diabetesDiagnosticTestEnResult.backToDashboard"/></a>
			</c:otherwise>
		 </c:choose>
	 </div>
		<div class="content-wrapper">
			<div class="header">
				<div class="row header-top">
					<div class="col-sm-3 brand-logo brand-logo-left">
             			<img src="../resources/images/aai-logo.png" alt="AAI Logo" class="img-fluid">
           			</div>
           			<div class="col-sm-6">
              			<h1 class="header-title"><spring:message code="diabetesTest.riskAssesmentReport"/></h1>
            		</div>
            		<div class="col-sm-3 brand-logo brand-logo-right">
              			<img src="../resources/images/logo_mkcl.svg" alt="MKCL Logo" class="img-fluid">
           			</div>
           		</div>
				<c:if test="${candidateExam.candidateExamID == null}">
					<div class="row header-info">
						<spring:message code="supPassChange.noRecordFound"/>
					</div>
				</c:if>
				<c:if test="${candidateExam.candidateExamID != null}">
					<div class="row header-info">
           				<div class="col-8 header-label">
							<strong><spring:message code="diabetesDiagnosticTestEnResult.participantName"/></strong>
							 ${candidateExam.candidate.candidateFirstName} ${candidateExam.candidate.candidateMiddleName}  ${candidateExam.candidate.candidateLastName}
						</div>
						<div class="col-2 header-label">
			              <strong><spring:message code="diabetesTest.sex"/></strong>
			              <c:if test="${candidateExam.candidate.candidateGender=='M'}"><spring:message code="diabetesDiagnosticTestEnResult.male"/></c:if>
			              <c:if test="${candidateExam.candidate.candidateGender=='F'}"><spring:message code="diabetesDiagnosticTestEnResult.female"/></c:if>
			            </div>  
			            <div class="col-2 header-label">
			              <strong><spring:message code="diabetesTest.age"/></strong>
			              <c:choose>
			              	<c:when test="${age==0}">
			              		<spring:message code="diabetesTest.NA"/>
			              	</c:when>
			              	<c:otherwise>
			              		${age} <spring:message code="diabetesTest.years"/>
			              	</c:otherwise>
			              </c:choose>
			            </div>  
					</div>
					<div class="row header-info">
			            <div class="col-4 header-label">
			              <strong><spring:message code="diabetesDiagnosticTestEnResult.centerCode"/></strong>
			               ${candidateExam.examVenue.examVenueCode}
			            </div>  
			            <div class="col-4 header-label">
			              <strong><spring:message code="diabetesDiagnosticTestEnResult.centerName"/></strong>
			               ${candidateExam.examVenue.examVenueName}
			            </div>  
			            <div class="col-4 header-label">
			              <strong><spring:message code="diabetesDiagnosticTestEnResult.district"/></strong>
			               ${candidateExam.examVenue.examVenuePinCode}
			            </div>  
			          </div>
			          <div class="row header-info">
			          	<div class="col header-label">
			              <strong><spring:message code="diabetesTest.address"/></strong>
			              ${candidateExam.candidate.candidateAddress}
			          	</div>
			          </div>
				</c:if>
			</div>
			<div class="content-area">
				<div class="content-text"><spring:message code="diabetesTest.dear"/> 
           			<span class="content-username"> ${candidateExam.candidate.candidateFirstName} </span>,
          		</div>
          		 <div class="content-text">
            		<spring:message code="diabetesTest.mainContent"/>
            		<strong><spring:message code="diabetesTest.subContent"/></strong>
				</div>
          		<div class="content-text content-text-alt">
	          		<c:if test="${candidateSuggestionViewModelList!=null && fn:length(candidateSuggestionViewModelList) != 0}">
			            <strong><spring:message code="diabetesTest.result"/></strong>
			        </c:if>
		            <div class="state-area">
		          	<c:set var="maxRiskCategory" value="0"></c:set>
		          
		            <c:forEach items="${candidateSuggestionViewModelList}" var="suggestionMaster">
		            	 <c:if test="${suggestionMaster.suggestionMaster.riskCategory.ordinal()>= maxRiskCategory }">
		            		 <c:set var="maxRiskCategory" value="${suggestionMaster.suggestionMaster.riskCategory.ordinal()}"></c:set>
		          		 </c:if>
		            </c:forEach>
		         		            
		            	<c:choose>
		            		<c:when test="${maxRiskCategory==1 }">
		            		<div class="state-holder">
				                <img src="../resources/images/G.png" alt="green" class="img-fluid">
			              	</div>
		              		<div class="state-name" ><spring:message code="diabetesTest.veryLow"/></div>
		            		</c:when>
		            		<c:when test="${maxRiskCategory==2 }">
		            		<div class="state-holder">
				               <img src="../resources/images/Y.png" alt="yellow" class="img-fluid">
			              	</div>
		              		<div class="state-name" ><spring:message code="diabetesTest.low"/></div>
		            		</c:when>
		            		<c:when test="${maxRiskCategory==3 }">
		            		<div class="state-holder">
				                <img src="../resources/images/O.png" alt="orange" class="img-fluid">
			              	</div>
		              		<div class="state-name" ><spring:message code="diabetesTest.moderate"/></div>
		            		</c:when>
		            		<c:when test="${maxRiskCategory==4 }">
			            	<div class="state-holder">
				                <img src="../resources/images/B.png" alt="brown" class="img-fluid">
			              	</div>
		              		<div class="state-name" ><spring:message code="diabetesTest.high"/></div>
		            		</c:when>
		            		<c:when test="${maxRiskCategory==5 }">
		            		<div class="state-holder">
				                <img src="../resources/images/R.png" alt="red" class="img-fluid">
			              	</div>
		              		<div class="state-name" ><spring:message code="diabetesTest.veryHigh"/></div>
		            		</c:when>
		            	</c:choose>
		              	
					</div>
		        </div>
		        <c:if test="${candidateSuggestionViewModelList!=null && fn:length(candidateSuggestionViewModelList) != 0}">
		         <div class="content-text">
          			<div class="content-heading"><spring:message code="diabetesTest.advoice"/></div>
         		 </div>
			        <c:forEach items="${categoryList}" var="category">
			        	<c:forEach items="${candidateSuggestionViewModelList}" var="sm" varStatus="i" >
			        		<c:if test="${sm.suggestionMaster.fkCategoryID == category.categoryID}">
			        		<b> ${i.index+1} : ${category.enCategoryName}</b>
			        			<div class="content-text content-text-answers">
			        				${sm.suggestionMaster.enSuggestionText}
			        			</div>
			        		</c:if>
			        	</c:forEach>
			        </c:forEach>
		        </c:if>
		       
		        <div class="content-text content-text-note">
	            	<span><spring:message code="diabetesTest.dueDate"/></span>
	            		${dueDate}
	          </div>
		      <div class="content-text content-text-info">
		          <span><spring:message code="diabetesTest.disclaimer"/></span>
		          <spring:message code="diabetesTest.disclaimerContent"/>
		      </div>
			  <div class="content-text content-citation">
		          <div class="col-md-4 cite-info">
		              <span class="cite-helper"><spring:message code="diabetesTest.aiGeneratedReport"/></span>
		              <span class="cite-helper"><spring:message code="diabetesTest.doesNotNeedSignature"/></span>
		              <div class="cite-main">
		              	<div class="cite-main-info"><spring:message code="diabetesTest.catchDMYoung"/></div>
		              </div>
		          </div>
	          </div>
			</div>	
		 </div>	
		 <div style="margin-top:10px;" class="row align-items-start">
		 	<div class="col">
		 	<c:choose>
				<c:when test="${sessionScope.user.object != null and sessionScope.user.isThirdPartySession == true and sessionScope.user.object.rUrl !=null and oesPartnerMaster != null}">
					<a class="btn-sm btn-primary"
						href="<c:url value="/gateway/backtopartner"></c:url>"><spring:message
						code="oesp.backto" />&nbsp;${oesPartnerMaster.partnerName}</a>
						<input type="hidden" id="eraSentFlag" name="eraSentFlag" value="true" />
				</c:when>
				<c:otherwise>
					<a href="../candidateModule/homepage" id="backbtn" class="btn-sm btn-primary"><spring:message code="diabetesDiagnosticTestEnResult.backToDashboard"/></a>
				</c:otherwise>
			 </c:choose>
			 </div>
			  <div class="col">
			 <c:if test="${fn:length(candidateSuggestionViewModelList) != 0}">
				 <button id="printbtn" class="btn-sm btn-success">
				<spring:message code="shortArtInclination.print"></spring:message>
				</button>
			</c:if>
			</div>
		</div>
	</main>		
</body>

</html>