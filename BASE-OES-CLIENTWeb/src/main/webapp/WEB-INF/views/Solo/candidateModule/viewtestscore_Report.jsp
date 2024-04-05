<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page errorPage="../common/jsperror.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<title><spring:message code="viewtestscore.title" /></title>

<link rel="stylesheet" href="<c:url value='/resources/style/template.css?v=04042023A'></c:url>" type="text/css" />
<link rel="stylesheet" href="<c:url value='/resources/style/selectFix.css'></c:url>" type="text/css" />
<!--[if lte IE 9]>
<style>
.side-menu li a:hover, .side-menu li a:hover a:focus {background-color: #000}
</style>
<![endif]-->
<!--[if IE 7]>
<style>
.profile {max-width:180px}
.profile .display-info .btn-orange {margin-top: -10px; padding-top: 0; padding-bottom: 5px;}
legend {margin-left: -7px}
.quick-nav .btn-grey {border:1px solid #ccc}
</style>
<![endif]-->
<script src="<c:url value='/resources/js/jquery-1.12.0.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/bootstrap.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/selectFix.js'></c:url>"></script>

<style type="text/css">
body{
	background: #fff;
}

  a.disablelink:hover {   
    color: #333;
    background-color: #E6E6E6;   
}
 .roundAnalysis {border-radius:50%; border:1px solid #A8A8A8  ;
  background-color: #A8A8A8  ;  
    }
 .lineColor 
{
border-color: #3A87AD;
}
.tab-content {
    overflow: inherit;
}

.directionRTL{
	direction: rtl;
	/* text-align: right; */
}

.directionRTL .table th {
text-align :right;
}

.directionRTL .table td {
text-align :right;
}

/* table {
	page-break-inside: avoid
} */

tr {
	page-break-inside: avoid;
	page-break-after: auto
}

thead {
	display: table-header-group
}

tfoot {
	display: table-footer-group
}

.difficultyLevelWise{
page-break-inside: avoid;
	page-break-after: auto
}



</style>
</head>
<body>

	<fieldset class="well">

		<legend>
			<span style="text-align: center;"><h3><spring:message code="viewTestScoreReport.analysisBooklet" /> - ${candidateName}</h3></span>
		</legend>

		

		<div id="tabbable" class="holder">

			<div class="tab-content">
				<div id="tab1" class="tab-pane active">

					<div style="border-color: blue; margin-left: 1px;">
						<%@include file="testdetails.jsp"%>
						<div style="background-color: white"
							style="background-color: white">
							<table class="table table-bordered table-condenesed"
								style="background-color: white" style="background-color: white">
								<tbody>
									<tr>
										<th colspan="6" style="text-align: center;background-color: #E6E6E6;"><spring:message code="viewtestscore.Questions" /></th>
									</tr>
								<c:choose>
									<c:when test="${resultAnalysisViewModelObj.paperContainCMPSItem==true}">
										<tr style="background-color: #FBFBFB;">
											<th colspan="2" width="170px;"><spring:message code="viewtestscore.Questions" /></th>
											<th><spring:message code="viewtestscore.Attempted" /></th>
											<th><spring:message code="viewtestscore.Correct" /></th>
											<th><spring:message code="viewtestscore.Incorrect" /></th>
											<th width="140px;"><spring:message code="viewtestscore.evaluationPending"/></th>
										</tr>
										<tr>
											<td style="text-align: center;" width="50px;"><b><spring:message code="viewtestscore.mainQuestions" /></b></td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalMainItem}</td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalAttemptedMainItem}</td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalMainItemCorrectAnswer}</td>
											<td style="text-align: center;">${(resultAnalysisViewModelObj.totalAttemptedMainItem-resultAnalysisViewModelObj.totalMainItemCorrectAnswer)-resultAnalysisViewModelObj.totalEvaluationPendingMainItem}</td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalEvaluationPendingMainItem}</td>
										</tr>
										<tr>
											<td style="text-align: center;"><b><spring:message code="viewtestscore.subQuestions" /></b></td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalSubItem}</td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalAttemptedSubItem}</td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalSubItemCorrectAnswer}</td>
											<td style="text-align: center;">${(resultAnalysisViewModelObj.totalAttemptedSubItem-resultAnalysisViewModelObj.totalSubItemCorrectAnswer)-resultAnalysisViewModelObj.totalEvaluationPendingSubItem}</td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalEvaluationPendingSubItem}</td>
										</tr>
										<tr>
											<td style="text-align: center;"><b><spring:message code="difficultylevelwise.Total" /></b></td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalMainItem+resultAnalysisViewModelObj.totalSubItem}</td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalAttemptedMainItem+resultAnalysisViewModelObj.totalAttemptedSubItem}</td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalMainItemCorrectAnswer+resultAnalysisViewModelObj.totalSubItemCorrectAnswer}</td>
											<td style="text-align: center;">${((resultAnalysisViewModelObj.totalAttemptedMainItem-resultAnalysisViewModelObj.totalMainItemCorrectAnswer)+(resultAnalysisViewModelObj.totalAttemptedSubItem-resultAnalysisViewModelObj.totalSubItemCorrectAnswer))-(resultAnalysisViewModelObj.totalEvaluationPendingMainItem+resultAnalysisViewModelObj.totalEvaluationPendingSubItem)}</td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalEvaluationPendingMainItem + resultAnalysisViewModelObj.totalEvaluationPendingSubItem}</td>
										</tr>
									</c:when>
									<c:otherwise>
										<tr style="background-color: #FBFBFB;">
											<th colspan="2"><spring:message code="viewtestscore.TotalQuestions" /></th>
											<th><spring:message code="viewtestscore.Attempted" /></th>
											<th><spring:message code="viewtestscore.Correct" /></th>
											<th><spring:message code="viewtestscore.Incorrect" /></th>
											<th><spring:message code="viewtestscore.evaluationPending"/></th>
										</tr>
										<tr>
											<td style="text-align: center;" colspan="2">${resultAnalysisViewModelObj.totalMainItem}</td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalAttemptedMainItem}</td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalMainItemCorrectAnswer}</td>
											<td style="text-align: center;">${(resultAnalysisViewModelObj.totalAttemptedMainItem-resultAnalysisViewModelObj.totalMainItemCorrectAnswer)-resultAnalysisViewModelObj.totalEvaluationPendingMainItem}</td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalEvaluationPendingMainItem}</td>
										</tr>
									</c:otherwise>
								</c:choose>
								<tr>
									<th colspan="6" style="text-align: center;background-color: #E6E6E6;"><spring:message code="viewtestscore.Marks" /></th>
								</tr>
								<tr style="background-color: #FBFBFB;">
									<th colspan="2"><spring:message code="viewtestscore.TotalMarks" /></th>
									<th><spring:message code="correctquestionmarks.lable" /></th>
									<th><spring:message code="incorrectquestionmarks.lable" /></th>
									<th><spring:message
											code="viewtestscore.MarksObtained" />&nbsp;&nbsp;<span
										class="text-error"><b>*</b></span></th>
									<th><spring:message code="viewtestscore.MinimumPassing" /></th>
								</tr>
								<tr>
									<td style="text-align: center;" colspan="2">${resultAnalysisViewModelObj.totalMarks}</td>
									<td style="text-align: center;">${resultAnalysisViewModelObj.totalMarksObtainedForCorrect}</td>
									<td style="text-align: center;">${resultAnalysisViewModelObj.totalMarksObtainedForInCorrect}</td>
									<td style="text-align: center;">
										${resultAnalysisViewModelObj.totalObtainedMarks}
									</td>
									<td style="text-align: center;"><c:choose>
											<c:when
												test="${resultAnalysisViewModelObj.minimumPassingMarks==null}">
												<spring:message code="viewtestscore.NA" />
											</c:when>
											<c:otherwise>
										${resultAnalysisViewModelObj.minimumPassingMarks}
										</c:otherwise>
										</c:choose></td>
								</tr>
								</tbody>
							</table>
							<p><span class="text-error"><b>*</b></span><spring:message code="viewtestscore.marksCalculationFormula" /></p>
							<br>


							<div class="row-fluid" style="background-color: white"style="background-color: white">
							<div class="span3">
								&nbsp;&nbsp;&nbsp;<b><spring:message code="viewtestscore.Percentage" /></b>
							</div>
							<div class="span3">
								<div class="progress" >
									<c:choose>
										<c:when test="${resultAnalysisViewModelObj.totalMarks==null || resultAnalysisViewModelObj.totalMarks==0 }">
											<div class="bar " style="width:0%;color:black;">0%</div>	
										</c:when>
										<c:otherwise>
										<!-- Set color to black if percentage less than equal to 0 -->
											<c:choose> 
												<c:when test="${((resultAnalysisViewModelObj.totalObtainedMarks/resultAnalysisViewModelObj.totalMarks)*100)<=0}">
													<div class="bar " style="width:${(resultAnalysisViewModelObj.totalObtainedMarks/resultAnalysisViewModelObj.totalMarks)*100}%;color:black;"><fmt:formatNumber type="number" maxFractionDigits="2" value="${(resultAnalysisViewModelObj.totalObtainedMarks/resultAnalysisViewModelObj.totalMarks)*100}" />% </div>
												</c:when>
												<c:otherwise>
													<div class="bar " style="width:${(resultAnalysisViewModelObj.totalObtainedMarks/resultAnalysisViewModelObj.totalMarks)*100}%;"><fmt:formatNumber type="number" maxFractionDigits="2" value="${(resultAnalysisViewModelObj.totalObtainedMarks/resultAnalysisViewModelObj.totalMarks)*100}" />% </div>
												</c:otherwise>
											</c:choose>
											
										</c:otherwise>
									</c:choose>
									
								</div>
							</div>
						</div>

							<div class="row-fluid">
								<div class="span3">
									<b><spring:message code="viewtestscore.ResultStatus" /></b>
								</div>
								<div class="span3">

									<c:choose>
										<c:when
											test="${resultAnalysisViewModelObj.minimumPassingMarks==null}">
											<font color="green"><spring:message
													code="viewtestscore.NA" /></font>
										</c:when>
										<c:when
											test="${resultAnalysisViewModelObj.totalObtainedMarks >= resultAnalysisViewModelObj.minimumPassingMarks}">
											<font color="green"><spring:message
													code="viewtestscore.Pass" /></font>
										</c:when>
										<c:when
											test="${resultAnalysisViewModelObj.totalObtainedMarks < resultAnalysisViewModelObj.minimumPassingMarks}">
											<font color="red"><spring:message
													code="viewtestscore.Fail" /></font>
										</c:when>
									</c:choose>

								</div>
							</div>

						</div>
					</div>

					<br>

				</div>

				
			</div>
			
	
		</div>
		

	

 <!-- topic wise -->
 <%@include file="topicwise_Report.jsp" %> 

<br><br>
<!-- difficulty level wise -->
<%@include file="difficultylevelwise_Report.jsp" %>

<br><br>
<!-- question by question analysis -->
<c:choose>
					<c:when test="${examDisplayCategoryPaperViewModelObj.candidateExam.candidatePaperLanguage=='40189c20-b1b6-4abb-bc9a-adf71fc44bb4' || examDisplayCategoryPaperViewModelObj.candidateExam.candidatePaperLanguage=='cd9daa9b-e66c-403f-8961-f0567d80f127'}">
						<div class="directionRTL">
					</c:when>
					<c:otherwise>
						<div>
					</c:otherwise>
				</c:choose>
<%@include file="questionByquestion_Report.jsp" %> 
</div>
</fieldset>
<link rel="stylesheet" href="<c:url value='/resources/style/jqcloud.min.css'></c:url>" type="text/css">
<script src="<c:url value='/resources/js/jqcloud.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/jquery.imagemapster.js'></c:url>"></script>
<script src="<c:url value='/resources/js/jquery.rwdImageMaps.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/ios-orientationchange-fix.min.js'></c:url>"></script>

</body>


</html>