<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page errorPage="../common/jsperror.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<title><spring:message code="topicwise.title" /></title>
<style type="text/css">
img.resize {
	height: auto;
	width: 50px;
}

img.resize {
	height: 50px;
	width: auto;
}
</style>
<spring:message code="project.resources" var="resourcespath" />

</head>
<body>
	<fieldset class="well">
	<a style="display: none;" id="lnk" href="#" download><spring:message code="difficultylevelwise.clickMe" /></a>
	<legend>
			<span><spring:message code="viewtestscore.YourScoreCard" /> - ${candidateName}</span> <span class="pull-right"> 
			<%-- <a class="btn btn-blue btn-small"
				href="../ResultAnalysis/AnalysisBooklet_${fn:replace(examDisplayCategoryPaperViewModelObj.paper.name,' ','')}_${fn:replace(candidateLoginId,' ','')}.pdf?examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&candidateLoginId=${candidateLoginId}&attemptNo=${attemptNo}"
				target="blank"><spring:message code="global.exportToPDF" /></a> --%>
				<a class="btn btn-blue btn-small" id="generatepdfBtn1" href="#"> <spring:message code="global.exportToPDF" /></a>
				<c:if test="${sessionScope.user.object != null and sessionScope.user.isThirdPartySession == true and oesPartnerMaster != null and sessionScope.user.object.rUrl !=null}"> 
				<a class="btn btn-purple lnkbackpbtn btn-small" href="<c:url value="/gateway/backtopartner"></c:url>" ><spring:message code="oesp.backto" />&nbsp;${oesPartnerMaster.partnerName}</a>
			</c:if>  
			</span>
		</legend>
		
		<c:if test="${examDisplayCategoryPaperViewModelObj.paper.isSectionRequired == true}">
		 <!-- Section list -->
		 <form:form action="topicwise" method="POST">
		 <div class="control-group form-horizontal">
					<label class="control-label" for="inputEmail"><b><spring:message code="topicwise.selectSection"/></b></label>
					<div class="controls">
						<select class="span4" id="sectionId" name="sectionId">
							<option value="0" selected="selected" ><spring:message code="questionByquestion.all"/></option>	
							<c:forEach items="${sectionList}" var="section">
								 <c:choose>
									<c:when test="${section.sectionID==sectionId}">
										<option value="${section.sectionID}" selected="selected">${section.sectionName}</option>
									</c:when>
									<c:otherwise>
										<option value="${section.sectionID}">${section.sectionName}</option>
									</c:otherwise>	
								</c:choose> 								
							
							</c:forEach>
						</select>
					&nbsp;<button type="submit" class="btn btn-blue"><spring:message code="questionByquestion.proceed"/></button>	
					</div>				
				</div>		
				  	<input type="hidden" name="sectionId" id="sectionId" value="${sectionId}">
			        <input type="hidden" name="examEventId" id="examEventId" value="${examEventId}">
					<input type="hidden" name="paperId" id="paperId" value="${paperId}">
					<input type="hidden" name="candidateId" id="candidateId" value="${candidateId}">
					<input type="hidden" name="loginType" id="loginType" value="${loginType}">
					<input type="hidden" name="displayCategoryId" id="displayCategoryId" value="${displayCategoryId}">
					<input type="hidden" name="collectionId" id="collectionId" value="${collectionId}">	
					<input type="hidden" name="attemptNo" id="attemptNo" value="${attemptNo}">
					<input type="hidden" name="showBriefAnalysis" id="showBriefAnalysis" value="1">	
		 </form:form>
		 </c:if>

		<div id="tabbable" class="holder">
			<ul class="nav nav-tabs" id="myTab">
				<c:if test="${sectionId=='0'}">
					<li ><a href="../ResultAnalysis/viewtestscore?examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&loginType=${loginType}&attemptNo=${attemptNo}" > 
					<spring:message code="viewtestscore.BriefAnalysis" /></a></li>
				</c:if>
				
				<li><a href="../ResultAnalysis/questionByquestion?examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&loginType=${loginType}&attemptNo=${attemptNo}&sectionId=${sectionId}">
				<spring:message code="viewtestscore.QuestionWiseAnalysis" /></a></li>
				
				<li class="active"><a href="../ResultAnalysis/topicwise?examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&loginType=${loginType}&attemptNo=${attemptNo}&sectionId=${sectionId}" data-toggle="tab">
				<spring:message code="viewtestscore.TopicWiseAnalysis" /></a></li>
				
				<li><a href="../ResultAnalysis/difficultylevelwise?examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&loginType=${loginType}&attemptNo=${attemptNo}&sectionId=${sectionId}">
				<spring:message code="viewtestscore.LevelwiseAnalysis" /> </a></li>
				
				
				
			</ul>
			<fieldset><legend style="line-height: 12px;"><span></span></legend> </fieldset>

			<div class="tab-content">
				<div id="tab1" class="tab-pane active">
					<%@include file="testdetails.jsp"%>
					
					<p>
						<b><spring:message code="topicwise.Topic-wiseAnalysis" /> </b>
					</p>
                    <div style="background-color: white"style="background-color: white">

					<table class="table table-striped table-condensed table-bordered" id="tblTopicWiseResultAnalysis">
						<thead>
							<tr class="info">

								<th><spring:message code="topicwise.Topics" /></th>
								<th><spring:message code="topicwise.Total" /></th>
								<th><spring:message code="topicwise.Correct_Attempt" /></th>
								<th><spring:message code="viewtestscore.evaluationPending"/></th>
								<th><spring:message code="topicwise.Accuracy" /></th>
							</tr>
						</thead>
						<tbody>
							<c:choose>
								<c:when
									test="${fn:length(itemBankAndDifficultyLevelViewModelObj.listResultAnalysisViewModel)> 0}">
									<c:forEach var="ResultAnalysisViewModel"
										items="${itemBankAndDifficultyLevelViewModelObj.listResultAnalysisViewModel}" varStatus="itemBankWise">
										<tr class="percentage">
											<td>
												<p id="Topic_perc${itemBankWise.index }">${ResultAnalysisViewModel.itemBank.name}</p>											
											</td>
											<td>${ResultAnalysisViewModel.totalItem}</td>
											<td>${ResultAnalysisViewModel.totalCorrectAnswer}/${ResultAnalysisViewModel.totalAttemptedItem}</td>
											<td>${ResultAnalysisViewModel.totalEvaluationPendingItem}</td>
											<td class="accuracy"><c:choose>
													<c:when	test="${ResultAnalysisViewModel.totalCorrectAnswer==null || ResultAnalysisViewModel.totalCorrectAnswer==0 }">
														<div class="progress" data-toggle="tooltip"	title="Acccuracy : 0%">
															<div class="bar  bar-success" style="width: 0%;color:black;">0%</div>
														</div>
														<input type="hidden" id="perc${itemBankWise.index}" name="perc${itemBankWise.index}" value="0" />
														</c:when>
													<c:otherwise>
													<!-- Set color to black if percentage less than equal to 0 -->
														<c:choose> 
															<c:when test="${((ResultAnalysisViewModel.totalCorrectAnswer/(ResultAnalysisViewModel.totalAttemptedItem-ResultAnalysisViewModel.totalEvaluationPendingItem))*100)<=0}">
																<div class="progress" data-toggle="tooltip"	title="Acccuracy : ${(ResultAnalysisViewModel.totalCorrectAnswer/(ResultAnalysisViewModel.totalAttemptedItem-ResultAnalysisViewModel.totalEvaluationPendingItem))*100}%">
																	<div class="bar  bar-success" style="width: ${(ResultAnalysisViewModel.totalCorrectAnswer/(ResultAnalysisViewModel.totalAttemptedItem-ResultAnalysisViewModel.totalEvaluationPendingItem))*100}%;color:black;"><fmt:formatNumber type="number" maxFractionDigits="2" value="${(ResultAnalysisViewModel.totalCorrectAnswer/ResultAnalysisViewModel.totalAttemptedItem)*100}" />%</div>
																</div>
															</c:when>
															<c:otherwise>
																<div class="progress" data-toggle="tooltip"	title="Acccuracy : ${(ResultAnalysisViewModel.totalCorrectAnswer/(ResultAnalysisViewModel.totalAttemptedItem-ResultAnalysisViewModel.totalEvaluationPendingItem))*100}%">
																	<div class="bar  bar-success" style="width: ${(ResultAnalysisViewModel.totalCorrectAnswer/(ResultAnalysisViewModel.totalAttemptedItem-ResultAnalysisViewModel.totalEvaluationPendingItem))*100}%;"><fmt:formatNumber type="number" maxFractionDigits="2" value="${(ResultAnalysisViewModel.totalCorrectAnswer/(ResultAnalysisViewModel.totalAttemptedItem-ResultAnalysisViewModel.totalEvaluationPendingItem))*100}" />%</div>
																</div>
															</c:otherwise>
														</c:choose>
														
														<input type="hidden" id="perc${itemBankWise.index }" name="perc${itemBankWise.index }" value="<fmt:formatNumber type="number" maxFractionDigits="2" value="${(ResultAnalysisViewModel.totalCorrectAnswer/(ResultAnalysisViewModel.totalAttemptedItem-ResultAnalysisViewModel.totalEvaluationPendingItem))*100}" />" />
													</c:otherwise>
												</c:choose>
											</td>												
										</tr>
										</c:forEach>
								</c:when>
							</c:choose>
						</tbody>
					</table>
					

					<p>
						<b><spring:message code="topicwise.ObservationMsg" /></b>
					</p>
					<div>
						<div class="row-fluid">

							<div class="alert alert-info">
								<div class="row-fluid">
									<div class="span3">
										<b><spring:message code="topicwise.BestArea" /></b>
									</div>
									<div class="span9">
										<!-- <input type="text" id="txtBestArea" value=""  readonly="readonly"> -->
										<label id="txtBestArea"></label>
									</div>
								</div>
								<div class="row-fluid">
									<div class="span3">
										<b><spring:message code="topicwise.WeakArea" /></b>
									</div>
									<div class="span9">
										<!-- <input type="text" id="txtWeakArea" value=""  readonly="readonly"> -->
										<label  id="txtWeakArea"></label>
									</div>
								</div>
								
						</div>
					</div>
			
					<!-- Display Back to result button to admin -->
					<c:if test="${isAdmin==1 || isAdmin==2}">
					<center>
						<a class="btn btn-blue" href="../TestReport/AttemptedPaperTestReport?examEventId=${examEventId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&candidateId=${candidateId}&attemptNo=${attemptNo}"><spring:message code="global.backToSearch" /></a>
					</center>
					</c:if>
					
					<!-- Display back button for Group analysis -->
				<c:if test="${loginType=='Group'}">
					<center>
						<a class="btn btn-blue"
							href="../GroupResultAnalysis/groupAnalysisCandidateList?examEventId=${examEventId}&paperId=${paperId}"><spring:message code="global.back" /></a>
					</center>
				</c:if>
				
					</div>
					
				</div>
			</div>
			
			<!-- PDF Button -->
			<div class="pull-right">
					<%-- <a class="btn btn-blue btn-small"
						href="../ResultAnalysis/AnalysisBooklet_${fn:replace(examDisplayCategoryPaperViewModelObj.paper.name,' ','')}_${fn:replace(candidateLoginId,' ','')}.pdf?examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&candidateLoginId=${candidateLoginId}&attemptNo=${attemptNo}" target="blank"><spring:message code="global.exportToPDF" /></a> --%>
						
						<a class="btn btn-blue btn-small" id="generatepdfBtn2" href="#"> <spring:message code="global.exportToPDF" /></a>
			<c:if test="${sessionScope.user.object != null and sessionScope.user.isThirdPartySession == true and oesPartnerMaster != null and sessionScope.user.object.rUrl !=null}"> 
				<a class="btn btn-purple lnkbackpbtn btn-small" href="<c:url value="/gateway/backtopartner"></c:url>" ><spring:message code="oesp.backto" />&nbsp;${oesPartnerMaster.partnerName}</a>
			</c:if> 
			</div>
		</div>
		
				<form:form id="generatepdf" target="blank"  action="../ResultAnalysis/generateAnalysisBookletReport" >
			<input type="hidden" id="examEventId" name="examEventId" value="${examEventId}">
			<input type="hidden" id="paperId" name="paperId" value="${paperId}">
			<input type="hidden" id="candidateId" name="candidateId" value="${candidateId}">
			<input type="hidden" id="collectionId" name="collectionId" value="${collectionId}">
			<input type="hidden" id="loginType" name="loginType" value="${loginType}">
			<input type="hidden" id="attemptNo" name="attemptNo" value="${attemptNo}">
			<input type="hidden" id="sectionId" name="sectionId" value="${sectionId}">
			<input type="hidden" id="displayCategoryId" name="displayCategoryId" value="${displayCategoryId}">
			
			<%-- examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&candidateLoginId=${candidateLoginId}&attemptNo=${attemptNo} --%>
			
		</form:form>
		
	</fieldset>
	<script type="text/javascript">
$(document).ready(function(){
	
	// generate pdf
	$('[id^=generatepdfBtn]').click(function(){ 
				var examEventId = $('#examEventId').val();
				var paperId=$('#paperId').val();
				var candidateId=$("#candidateId").val();
				var collectionId=$("#collectionId").val();
				var loginType=$("#loginType").val();
				var attemptNo = $("#attemptNo").val();
				var displayCategoryId = $("#displayCategoryId").val();
				var sectionId = $("#sectionId").val();
			
				//String candidateId,String examEventID,String attemptNO,String paperID,String candidateLoginId,String attemptNo
				//examEventId=69&paperId=1223&candidateId=464215&collectionId=276&displayCategoryId=0&loginType=&attemptNo=1&sectionId=0
				//?examEventId=69&paperId=1223&candidateId=464215&collectionId=276&displayCategoryId=0&loginType=&attemptNo=1&sectionId=0
				var dat = JSON.stringify({ "examEventID" : examEventId, "paperID":paperId, "candidateId":candidateId, "collectionId":collectionId, "displayCategoryId":displayCategoryId,"attemptNo":attemptNo,"sectionId":0 }); 
				// console.log(dat);
				$.ajax({
					url : "generateAnalysisBookletReport",
					type : "POST",
					data : dat,
					contentType : "application/json",
					/* dataType : "json", */
					success : function(response) {
						if(response)
						{
							  $('#lnk').attr('href', "../" + response);
				            $('#lnk')[0].click();
						}
						else
						{
							alert('<spring:message code="candidateAttempt.noDataFound"/>');
						}
					},
					error : function() {
						alert('<spring:message code="candidateAttempt.errorGeneratingPDF"/>');
					}
				}); /* end of ajax */	
				
				
			});
	
	
	
	// set best area and weak area
	var maxPercentage=0.0;
	var minPercentage=-1.0;
		$('#tblTopicWiseResultAnalysis tr.percentage').each(function() {		
		var tempPer=0.0;
		$(this).find('td.accuracy').each(function() {
			tempPer=parseFloat($(this).find("input[type='hidden']").val());			
					if (tempPer>maxPercentage) {
						maxPercentage=tempPer;
					}
					if(minPercentage==-1.0){
						minPercentage=tempPer
					}else if(tempPer<minPercentage){
						minPercentage=tempPer;
					}
		}); /* end td */		
	}); /* end tr */
	
	var bestArea="";
	var weakArea="";	
	$('#tblTopicWiseResultAnalysis tr.percentage').each(function() {
		var tempPer=0.0;
		$(this).find('td.accuracy').each(function() {
			tempPer=parseFloat($(this).find("input[type='hidden']").val());
			// get topic name for best area
			if (tempPer==maxPercentage && maxPercentage!=0) {
				var accuracyHdnID=$(this).find("input[type='hidden']").attr("id")				
				var topicNameLblID='Topic_'+accuracyHdnID;				
				var topicName=$('#'+topicNameLblID).text();			
				bestArea=bestArea+topicName+', ';
			}
			// get topic names for weak area
			if (tempPer==minPercentage) {
				var accuracyHdnID=$(this).find("input[type='hidden']").attr("id");			
				var topicNameLblID='Topic_'+accuracyHdnID;				
				var topicName=$('#'+topicNameLblID).text();				
				weakArea=weakArea+topicName+', ';
			}
		}); /* end td */		
	}); /* end tr */
	// remove , from best area list
	if (bestArea.length>0) {
		var lastChar = bestArea.substr(bestArea.length - 2);		
		if (lastChar==', ') {			
			bestArea=bestArea.substring(0,bestArea.length - 2)
		}
	}else{
		bestArea="--";
	}
	
	// remove , from weak area list
	if (weakArea.length>0) {
	var lastChar = weakArea.substr(weakArea.length - 2);	
	if (lastChar==', ') {		
		weakArea=weakArea.substring(0,weakArea.length - 2)
	}
	}else{
		weakArea="--";
	}
	
	$("#txtBestArea").text(bestArea);
	$("#txtWeakArea").text(weakArea);
});
</script>
	
	
</body>
</html>