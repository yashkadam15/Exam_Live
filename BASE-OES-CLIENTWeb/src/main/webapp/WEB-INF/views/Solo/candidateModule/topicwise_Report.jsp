	<div id="tabbable" class="holder">
	


			<div class="tab-content">
				<div id="tab1" class="tab-pane active">
					
					
					<p style="text-align: center;font-size: 20px;">
						<b><spring:message code="topicwise.heading" /> </b>
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
									test="${fn:length(itemBankAndDifficultyLevelViewModelObj_TopicWise.listResultAnalysisViewModel)> 0}">
									<c:forEach var="ResultAnalysisViewModel"
										items="${itemBankAndDifficultyLevelViewModelObj_TopicWise.listResultAnalysisViewModel}" varStatus="itemBankWise">
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
			
			
			
				
					</div>
					
				</div>
			</div>
			
			<!-- PDF Button -->
		
		</div>
	</fieldset>
	<script type="text/javascript">
$(document).ready(function(){
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
				//console.log("accuracyHdnID "+accuracyHdnID);
				var topicNameLblID='Topic_'+accuracyHdnID;	
				//console.log("topicNameLblID :: "+topicNameLblID)
				var topicName=$('#'+topicNameLblID).text();		
				//console.log("topic name :: "+topicName);
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
	
	//console.log("best area "+bestArea);
	//console.log("weaK area "+weakArea);
	$("#txtBestArea").text(bestArea);
	$("#txtWeakArea").text(weakArea);
});
</script>
	