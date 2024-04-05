<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page errorPage="../common/jsperror.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>

<title><spring:message code="viewtestscoreForKlick.PrintCertificate"/></title>
<spring:theme code="curdetailtheme" var="curdetailtheme" />
<link rel="stylesheet" href="<c:url value='${curdetailtheme}'></c:url>" type="text/css" />
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
.page {
	width: 20cm;
	min-height: 29.7cm;
	padding: 2cm;
	margin: 2cm;
	margin-right: 2cm;
	margin-left: 2cm;
	/* border: 1px #D3D3D3 solid; */
	/* border-radius: 5px; */
	background: white;
	/* box-shadow: 0 0 5px rgba(0, 0, 0, 0.1); */
}
</style>
<script src="<c:url value='/resources/js/jquery-1.12.0.min.js'></c:url>"></script>
<script type="text/javascript">

$(document).ready(function(){	
		window.print();    

});
</script>
</head>
<body style="background-color: white;padding-right: 10px;padding-left: 10px;padding-right: 10px;">
	<fieldset class="well">
		
	   
				<div class="holder" style="margin: 10px;border:1px solid black;padding: 1px;" >
				<div style="border:1px solid black;padding: 15px;">
				
               <input type="hidden" id="candExamID" name="candExamID" value="${candExamID}">
				<div class="holder" class="page">

					<div style="border-color: blue; margin-left: 1px">
				
					
				 	 <div style="text-align: center; height: 35px;width: 100%;background-color: #ED7D31;padding-top: 12px;">
				      <font color="white" face="Calibri" size="6" ><spring:message code="printScoreCard.provisionalMarks"/>
				     </font></div>   
					
					 <!-- <div style="text-align: center; height:45px;width: 100%;margin-top: 5px;">				
					 <img style="height:100%;width: 100%" src="../resources/images/backgroundImg.PNG"/>    
					</div>
		 -->
					 <br/>
				
                    <div style="text-align: center;"><h4>  ${paper.name }</h4></div>
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
								<td style="text-align: center;">
								<fmt:formatNumber value="${map.value}" type="number" pattern="#"/><c:if test="${map.key=='SUPW' }">*</c:if></td>												
							    </tr>
							    </c:forEach>						
							
								<tr >
									<th colspan="3" style="text-align: center;"><spring:message code="printScoreCard.resultStatus"/>
									<c:choose>
									<c:when
										test="${resultAnalysisViewModelObj.minimumPassingMarks==null}">										
										<font color="grey"><spring:message code="viewtestscore.NA" /></font>
									</c:when>
									<c:when
										test="${resultAnalysisViewModelObj.totalObtainedMarks >= resultAnalysisViewModelObj.minimumPassingMarks}">
										<font color="green" ><spring:message	code="viewtestscore.Pass" />*</font>
									</c:when>
									<c:when
										test="${resultAnalysisViewModelObj.totalObtainedMarks < resultAnalysisViewModelObj.minimumPassingMarks}">
										<font color="red" ><spring:message code="viewtestscore.Fail" />*</font>
									</c:when></c:choose>	</th>								
								</tr>								 	
								
								</tbody>
							</table>					
						
                       <p><b><spring:message code="printScoreCard.dateExam"/> </b> <fmt:formatDate pattern="dd-MM-yyyy HH:mm:ss"   value="${resultAnalysisViewModelObj.candidateExam.endDate}" />	</p>
                      <br/>
	                   
							  
					 <div><b><spring:message code="printScoreCard.note"/></b> 
                      <ul class="featureList">
                      <li><spring:message code="printScoreCard.ycmouMarkSheet"/></li>
                      <li><spring:message code="printScoreCard.supw"/></li>
                      <li><spring:message code="printScoreCard.mkclExpertCertificate"/></li>
                      </ul> 
                      </div>
							    <br/>
							  <!-- <img src="../resources/images/Logo strip.png" width="90%" height="30%"> -->
							<table style="width: 100%;height: 25%;">
							<tr align="center">
							<td><img src="../resources/images/1_3_Klic.png"  height="100%"></td>
							<td><img src="../resources/images/1_4_KickSeal&Signature.gif"  height="100%">							
							</td></tr>
							</table>  
							  
                    </div>
				</div>
              </div>	
          </div>
	</fieldset>
</body>
</html>