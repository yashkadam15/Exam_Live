<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page errorPage="../common/jsperror.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>

<title><spring:message code="viewtestscoreForKlick.header"/></title>

<style type="text/css">
.featureList, .featureList ul {
  margin-top: 0;
  padding-left: 2em;
  list-style-type: none;
}
.featureList li:before {
  position: absolute;
  margin-left: -1.3em;
  font-weight: bold;
}
.featureList li:before {
  content: "\2713"; 
}

</style>
<script type="text/javascript">

$(document).ready(function(){
	$("#printbtn").click(function(e){	
	
        var ceid=$("#candExamID").val();
		var paperID=$("#paperID").val();
		var sectionMarks=$("#sm").val();
 
	window.open("../endexam/printScoreCard?ceid="+ceid+"&paperID="+paperID+"&sm="+sectionMarks,'<spring:message code="viewtestscoreForKlick.PrintCertificate"/>', "scrollbars=yes");
		
	});
});


</script>
</head>
<body>
	<fieldset class="well">	
				
              
				<div class="holder" style="margin: 10px;border:1px solid black;padding: 1px;">
				<div style="border:1px solid black;padding: 15px;">
				
					 <input type="hidden" id="candExamID" name="candExamID" value="${candExamID}">
					  <input type="hidden" id="paperID" name="paperID" value="${paperId}">
					  <input type="hidden" id="sm" name="sm" value="${sectionMarks}">
					  
			
			 <div style="text-align: center; height: 35px;width: 100%;background-color: #ED7D31;padding-top: 12px;">
				<font color="white" face="Calibri" size="6" ><spring:message code="printScoreCard.provisionalMarks"/>
				</font></div> 
				
			<!-- 	 <div style="text-align: center; height: 45px;width: 100%;margin-top: 5px;">
				
					 <img style="height:100%;width: 100%" src="../resources/images/backgroundImg.PNG"/>    
					</div> -->
					 <br/>
                               <div style="text-align: center;"><h5>  ${paper.name }</h5></div>
                     
                      <br/>
                       <table style="width: 100%;margin-bottom: 5px;">
                     <tr><td style="width: 50%;"><b><spring:message code="viewtestscoreForKlick.LearnerCode"/>:</b> ${resultAnalysisViewModelObj.candidate.candidateCode}
                     </td>
                     <td style="width: 50%;"><b><spring:message code="viewtestscoreForKlick.LearnerName"/>:</b>  ${resultAnalysisViewModelObj.candidate.candidateFirstName } </td>
                     </tr> 
                     <tr>     
                     <td style="width: 50%;"><b><spring:message code="viewtestscoreForKlick.CenterCode"/>:</b> ${resultAnalysisViewModelObj.examVenue.examVenueCode}</td>   
                     <td style=" right;width: 50%;"><b><spring:message code="viewtestscoreForKlick.CenterName"/>:</b> ${resultAnalysisViewModelObj.examVenue.examVenueName}</td>
                      </tr>                    
                     </table>    
                     
                 <br/>
                               
						<table class="table table-bordered table-condenesed">
								<tbody>
								
								<tr>
									<th  style="text-align: center;"><spring:message code="candidateTestReport.srNo"/></th>
									<th style="text-align: center;"><spring:message code="attemptReport.sectionName"/></th>
									<th  style="text-align: center;"><spring:message code="scoreCard.MarksObtained"/></th>
								</tr>
							
								<c:forEach items="${sectionNameMarkMap}" var="map" varStatus="i">							
								<tr>	
								<td style="text-align: center;">${i.index+1}</td>		
								<td style="width: 50%;">${map.key}</td>
								<td style="text-align: center;">${map.value}<c:if test="${map.key=='SUPW' }">*</c:if>
								</td>												
							    </tr>
							    </c:forEach>	
								<tr >
									<th colspan="3" style="text-align: center;"><spring:message code="viewtestscoreForKlick.ResultStatus"/> :
									<c:choose>
									<c:when
										test="${resultAnalysisViewModelObj.minimumPassingMarks==null}">										
										<font color="grey"><spring:message code="viewtestscore.NA" />*</font>
									</c:when>
									<c:when
										test="${resultAnalysisViewModelObj.totalObtainedMarks >= resultAnalysisViewModelObj.minimumPassingMarks}">
										<font color="green" ><spring:message	code="viewtestscore.Pass" /></font>
									</c:when>
									<c:when
										test="${resultAnalysisViewModelObj.totalObtainedMarks < resultAnalysisViewModelObj.minimumPassingMarks}">
										<font color="red" ><spring:message code="viewtestscore.Fail" />*</font>
									</c:when></c:choose>	</th>								
								</tr>								 	
								
								</tbody>
							</table>					
						
                      <p><b><spring:message code="printScoreCard.dateExam"/> </b><fmt:formatDate pattern="dd-MM-yyyy HH:mm:ss"   value="${resultAnalysisViewModelObj.candidateExam.endDate}" />	</p>
                      <br/>
                      
                      <div><b><spring:message code="printScoreCard.note"/></b> 
                      <ul class="featureList">
                      <li><spring:message code="printScoreCard.ycmouMarkSheet"/></li>
                      <li><spring:message code="printScoreCard.supw"/></li>
                      <li><spring:message code="printScoreCard.mkclExpertCertificate"/></li>
                      </ul> 
                      </div>                      		
                      			<table style="width: 100%;height: 25%;">
								<tr align="center">
								<td><img src="../resources/images/1_3_Klic.png"  height="100%"></td>
								<td ><img src="../resources/images/1_4_KickSeal&Signature.gif"  height="100%">							
								</td></tr>
								</table>                      		
                      	                          			
	                              <%--  <c:choose>
									<c:when test="${resultAnalysisViewModelObj.totalObtainedMarks >= resultAnalysisViewModelObj.minimumPassingMarks}">
										<p><b><spring:message code="global.error.note"/>:</b> <spring:message code="viewtestscoreForKlick.passNote"/></p>
									</c:when>
									<c:when test="${resultAnalysisViewModelObj.totalObtainedMarks < resultAnalysisViewModelObj.minimumPassingMarks}">
									    <p><b><spring:message code="global.error.note"/>:</b> <spring:message code="viewtestscoreForKlick.failNote"/></p>
									</c:when></c:choose> --%>	                   
	               
                       
                    
                     <div style="text-align: center;"><button  class="btn btn-blue" id="printbtn"><spring:message code="careerInclination.print"/></button></div>
                     
                    

					<c:if test="${sessionScope.user.loginType =='Group'}">
						<center>
							<a class="btn btn-blue "
								href="../GroupResultAnalysis/groupScoreCardCandidateList?examEventId=${examEventId}&paperId=${paperId}&attemptNo=${attemptNo}">Back</a>
						</center>
					</c:if>					
					</div>
				</div>
             
	
	<div id="sb_info_div">		
		<input type="hidden" id="sbHidpid" value="${paperId }"/>
		<input type="hidden" id="sbHidcnm" value="${sessionScope.user.venueUser[0].userName }"/>
	</div>	
	
	
	</fieldset>
	
	<script type="text/javascript">
	$(document).ready(
			function() {
			
				/*26 Apr 2016 : RIFORM Item Type File Upload */
				if (navigator.userAgent.search('MOSB') >= 0
						&& typeof js != "undefined") {
					
					js.stopEvidenceCapture();
				}
			});

	</script>
</body>
</html>