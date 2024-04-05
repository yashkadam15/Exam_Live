
			<div class="tab-content holder" class="difficultyLevelWise">
				<div id="tab1" class="tab-pane active" >
						<p style="text-align: center;font-size: 20px;">
						<b><spring:message code="difficultylevelwise.heading" /> </b>
					</p>
								

					<table class="table  table-bordered table-condenesed" style="background-color: white">
					<thead>
						<tr class="info">
							<th><spring:message code="difficultylevelwise.DifficultyLevel" /></th>
							<th><spring:message code="difficultylevelwise.Total" /></th>
							<th><spring:message code="difficultylevelwise.Correct_Attempt" /></th>
							<th><spring:message code="viewtestscore.evaluationPending"/></th>
							<th><spring:message code="difficultylevelwise.Accuracy" /></th>							
							
						</tr>
						</thead>
						<tbody>
						<tr>
							<c:choose>
								<c:when
									test="${fn:length(itemBankAndDifficultyLevelViewModelObj_DiffLevel.listResultAnalysisViewModel)> 0}">
									<c:forEach var="ResultAnalysisViewModel"
										items="${itemBankAndDifficultyLevelViewModelObj_DiffLevel.listResultAnalysisViewModel}" varStatus="itemBankWise">
										<tr class="percentage">
											<td>${ResultAnalysisViewModel.difficultyLevel}</td>
											<td>${ResultAnalysisViewModel.totalItem}</td>
											<td>${ResultAnalysisViewModel.totalCorrectAnswer}/${ResultAnalysisViewModel.totalAttemptedItem}</td>
											<td>${ResultAnalysisViewModel.totalEvaluationPendingItem}</td>
											<td class="accuracy"><c:choose>
													<c:when	test="${ResultAnalysisViewModel.totalCorrectAnswer==null || ResultAnalysisViewModel.totalCorrectAnswer==0 }">
														<div class="progress" data-toggle="tooltip"	title="Acccuracy : 0%">
															<div class="bar  bar-success" style="width: 0%;color:black;">0%</div>
														</div>														
														</c:when>
													<c:otherwise>
													<!-- Set color to black if percentage less than equal to 0 -->
														<c:choose>
															<c:when test="${((ResultAnalysisViewModel.totalCorrectAnswer/(ResultAnalysisViewModel.totalAttemptedItem-ResultAnalysisViewModel.totalEvaluationPendingItem))*100)<=0}">
																<div class="progress" data-toggle="tooltip"	title="Acccuracy : ${(ResultAnalysisViewModel.totalCorrectAnswer/(ResultAnalysisViewModel.totalAttemptedItem-ResultAnalysisViewModel.totalEvaluationPendingItem))*100}%">
																	<div class="bar  bar-success" style="width: ${(ResultAnalysisViewModel.totalCorrectAnswer/(ResultAnalysisViewModel.totalAttemptedItem-ResultAnalysisViewModel.totalEvaluationPendingItem))*100}%;color:black;"><fmt:formatNumber type="number" maxFractionDigits="2" value="${(ResultAnalysisViewModel.totalCorrectAnswer/(ResultAnalysisViewModel.totalAttemptedItem-ResultAnalysisViewModel.totalEvaluationPendingItem))*100}" />%</div>
																</div>	
															</c:when>
															<c:otherwise>
																<div class="progress" data-toggle="tooltip"	title="Acccuracy : ${(ResultAnalysisViewModel.totalCorrectAnswer/(ResultAnalysisViewModel.totalAttemptedItem-ResultAnalysisViewModel.totalEvaluationPendingItem))*100}%">
																	<div class="bar  bar-success" style="width: ${(ResultAnalysisViewModel.totalCorrectAnswer/(ResultAnalysisViewModel.totalAttemptedItem-ResultAnalysisViewModel.totalEvaluationPendingItem))*100}%;"><fmt:formatNumber type="number" maxFractionDigits="2" value="${(ResultAnalysisViewModel.totalCorrectAnswer/(ResultAnalysisViewModel.totalAttemptedItem-ResultAnalysisViewModel.totalEvaluationPendingItem))*100}" />%</div>
																</div>
															</c:otherwise>
														</c:choose>
																											
													</c:otherwise>
												</c:choose>
											</td>												
										</tr>
										</c:forEach>
								</c:when>
							</c:choose>
						</tr>						
						</tbody>
					</table>

				

				</div>
				<!-- tab close -->
			</div>
			
			<!-- PDF Button -->