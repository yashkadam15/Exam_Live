<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>


<spring:message code="project.resources" var="resourcespath" />
						<p style="text-align: center;font-size: 20px;">
						<b><spring:message code="Exam.QuestionDetails" /> </b>
					</p>
 <c:set var="count" value="0" scope="page" />
 <c:forEach items="${examViewModelList}" var="examViewModel">
 <c:set var="count" value="${count + 1}" scope="page"/>
 <div id="tabbable" class="holder">

	<div class="tab-content holder">
		<div id="tab1" class="tab-pane active">
<div id="tab1" class="tab-pane active" >


			<div style="background-color: white;">
		
						<p>
							<b><spring:message code="questionByquestion.question"></spring:message>
							${count}</b>
							<%-- <spring:message code="questionByquestion.outof"></spring:message>
							${fn:length(itemAnswerMap)} --%>
						</p>


						<!-- Show marks obtained -->

						<c:if test="${examViewModel.itemStatus==1 || examViewModel.itemStatus==11}">
							<legend style="color: green;">
								<span><spring:message code="questionByquestion.correct"></spring:message></span>
								<span class="pull-right"><spring:message
										code="questionByquestion.marksObtainedForItem" /> :
									${examViewModel.candidateItemAssociation.marksObtained}</span>
							</legend>
						</c:if>
						<c:if test="${examViewModel.itemStatus==0 || examViewModel.itemStatus==10}">
							<legend style="color: red;">
								<span><spring:message code="questionByquestion.incorrect"></spring:message></span>
								<span class="pull-right"><spring:message
										code="questionByquestion.marksObtainedForItem" /> :
									${examViewModel.candidateItemAssociation.marksObtained}</span>
							</legend>
						</c:if>
						<c:if test="${examViewModel.itemStatus==2 || examViewModel.itemStatus==21}">
							<legend style="color: grey;">
								<span><spring:message
										code="questionByquestion.notattempted"></spring:message></span>
							</legend>
						</c:if>

						<c:if test="${examViewModel.itemStatus==9 || examViewModel.itemStatus==91}">
							<legend style="color: grey">
								<span><spring:message
										code="viewtestscore.evaluationPending" /></span> <span
									class="pull-right"><spring:message
										code="questionByquestion.marksObtainedForItem" /> :NA</span>
							</legend>
						</c:if>

						<!-- end of Show marks obtained -->

						<!-- MCSC START -->

						<c:if test="${examViewModel!=null && fn:length(examViewModel.multipleChoiceSingleCorrects)!=0}">
							<c:if test="${examViewModel.itemType=='MCSC' || examViewModel.itemType=='TRUEFALSE' || examViewModel.itemType=='YN'}">
								<%@include file="MCSC_QuestionAnalysis.jsp"%>
							</c:if>
						</c:if>
						<!-- MCSC END-->

						<!-- MCMC START -->
						<c:if
							test="${examViewModel!=null && fn:length(examViewModel.multipleChoiceMultipleCorrects)!=0}">
							<c:if test="${examViewModel.itemType=='MCMC'}">
								<%@include file="MCMC_QuestionAnalysis.jsp"%>
							</c:if>
						</c:if>
						<!-- MCMC END-->


						<!--PI START  -->
						<c:if
							test="${examViewModel!=null && fn:length(examViewModel.pictureIdentifications)!=0}">
							<c:if test="${examViewModel.itemType=='PI'}">
								<%@include file="PI_QuestionAnalysis.jsp"%>
							</c:if>
						</c:if>
						<!-- PI END -->


						<!--  COMP START -->
						<c:if test="${examViewModel.itemType=='CMPS'}">
							<%@include file="COMP_QuestionAnalysis.jsp"%>
						</c:if>
						<!-- COMP END -->

						<!--  MM START -->
						<c:if test="${examViewModel.itemType=='MM'}">
							<%@include file="MM_QuestionAnalysis.jsp"%>
						</c:if>
						<!-- MM END -->


						<!-- Matching Pairs -->
						<c:if test="${examViewModel.itemType=='MP'}">
							<%@include file="MP_QuestionAnalysis.jsp"%>
						</c:if>
						<!-- Matching Pairs END-->

						<!-- Practical -->
						<c:if test="${examViewModel.itemType=='PRT'}">
							<%@include file="PRT_QuestionAnalysis.jsp"%>
						</c:if>
						<!-- Practical End-->

						<!-- Simulation -->
						<c:if test="${examViewModel.itemType=='SML'}">
							<%@include file="SML_QuestionAnalysis.jsp"%>
						</c:if>
						<!-- Simulation End-->

						<!-- ResponseIn Form of Recorded Media -->
						<c:if test="${examViewModel.itemType=='RIFORM'}">
							<%@include file="RIFORM_QuestionAnalysis.jsp"%>
						</c:if>
						<!-- ResponseIn Form of Recorded Media End-->

						<!-- Match The Column -->
						<c:if test="${examViewModel.itemType=='MTC' || examViewModel.itemType=='SQ'}">
							<%@include file="MTC_QuestionAnalysis.jsp"%>
						</c:if>
						<!-- Match The Column End -->

						<!-- Error Correction -->
						<c:if
							test="${examViewModel.itemType=='EC' || examViewModel.itemType=='RWP' || examViewModel.itemType=='FQFA'}">
							<%@include file="EC_QuestionAnalysis.jsp"%>
						</c:if>
						<!--Error Correction End -->

						<!-- Essay Writing -->
						<c:if test="${examViewModel.itemType=='EW'}">
							<%@include file="EW_QuestionAnalysis.jsp"%>
						</c:if>
						<!--Essay Writing End -->
						
						 <!-- Hot Spot -->
					 	<c:if test="${examViewModel.itemType=='HS'}">
				        <%@include file="HS_QuestionAnalysis.jsp"%> 
				        </c:if> 
				        <!--Hot Spot End -->
				        
				        <!-- Word Cloud -->
					 	<c:if test="${examViewModel.itemType=='WC'}">
				        <%@include file="WC_QuestionAnalysis.jsp"%> 
				        </c:if> 
				        <!--Word Cloud End -->

	 					<!--  CMPSMQT START -->
						<c:if test="${examViewModel.itemType=='CMPSMQT'}">
							<%@include file="CMPSMQT_QuestionAnalysis.jsp"%>
						</c:if>
						<!-- CMPSMQT END -->		
						
						<!--  NFIB START -->
						<c:if test="${examViewModel.itemType=='NFIB'}">
							<%@include file="NFIB_QuestionAnalysis.jsp"%>
						</c:if>
						<!-- NFIB END -->					

						<!-- Two Stage Reasoning -->
						<c:if test="${examViewModel.itemType=='TSR'}">
							<c:if test="${examViewModel.twoStageReasoning!=null}">
								<b> <spring:message code="questionByquestion.question"></spring:message>
									${itemNo}:&nbsp;
								</b>
								<p class="question-wrap">${examViewModel.twoStageReasoning.itemText }</p>
								<br />
								<c:if
									test="${examViewModel.twoStageReasoning.itemImage!=null && fn:length(examViewModel.twoStageReasoning.itemImage)!=0}">
									<img
										src="../exam/displayImage?disImg=${examViewModel.twoStageReasoning.itemImage}"
										class="resize" />
									<br />
								</c:if>

								<b><br /> <spring:message code="questionByquestion.option"></spring:message></b>
								<table class="table table-bordered">
									<tr>
										<th style="width: 40px;"><spring:message
												code="questionByquestion.sr.no"></spring:message></th>
										<th><spring:message code="questionByquestion.optiontext"></spring:message>
										</th>
										<th style="width: 150px; float: rigth;"><spring:message
												code="questionByquestion.candidateselection"></spring:message></th>
									</tr>
									<c:forEach var="twoStageOptionObj"
										items="${examViewModel.twoStageReasoning.optionList}"
										varStatus="i">
										<c:choose>
											<c:when
												test="${twoStageOptionObj.optionLanguage.option.isCorrect==true}">
												<tr>
													<td>${i.count}&nbsp;<img
														src="${resourcespath}images/tick.png"></td>
													<td>
														<p class="question-wrap">${twoStageOptionObj.optionText}</p>
														<c:if
															test="${fn:length(twoStageOptionObj.optionImage)!=0}">
															<br />
															<img
																src="../exam/displayImage?disImg=${twoStageOptionObj.optionImage}" />
														</c:if>
													</td>
													<td><c:if
															test="${fn:length(examViewModel.candidateAnswerList)!=0 && examViewModel.candidateAnswerList!=null}">

															<c:forEach var="candidateAnsObj"
																items="${examViewModel.candidateAnswerList}">
																<c:if
																	test="${candidateAnsObj.optionID==twoStageOptionObj.optionLanguage.fkOptionID}">
																	<c:choose>
																		<c:when test="${candidateAnsObj.isCorrect==true}">
																			<center>
																				<i class="icon-user"></i>&nbsp; <img
																					src="${resourcespath}images/tick.png">
																			</center>
																		</c:when>
																		<c:otherwise>
																			<center>
																				<i class="icon-user"></i>&nbsp; <img
																					src="${resourcespath}images/wrong.png">
																			</center>
																		</c:otherwise>
																	</c:choose>
																</c:if>
															</c:forEach>
														</c:if></td>
												</tr>
											</c:when>
											<c:otherwise>
												<tr>
													<td>${i.count}&nbsp;</td>
													<td>
														<p class="question-wrap">${twoStageOptionObj.optionText}
														</p> <c:if
															test="${fn:length(twoStageOptionObj.optionImage)!=0}">
															<br />
															<img
																src="../exam/displayImage?disImg=${twoStageOptionObj.optionImage}" />
														</c:if>
													</td>
													<td><c:if
															test="${fn:length(examViewModel.candidateAnswerList)!=0 && examViewModel.candidateAnswerList!=null}">
															<c:forEach var="candidateAnsObj"
																items="${examViewModel.candidateAnswerList}">
																<c:if
																	test="${candidateAnsObj.optionID==twoStageOptionObj.optionLanguage.fkOptionID}">

																	<c:choose>
																		<c:when test="${candidateAnsObj.isCorrect==true}">
																			<center>
																				<i class="icon-user"></i>&nbsp; <img
																					src="${resourcespath}images/tick.png">
																			</center>
																		</c:when>
																		<c:otherwise>
																			<center>
																				<i class="icon-user"></i>&nbsp; <img
																					src="${resourcespath}images/wrong.png">
																			</center>
																		</c:otherwise>
																	</c:choose>
																</c:if>
															</c:forEach>
														</c:if></td>
												</tr>
											</c:otherwise>
										</c:choose>
									</c:forEach>
									<!-- main item option list end here -->

								</table>

								<!-- Answer Explanation of main item options -->
								<c:set var="Occured" value="0" />
								<c:forEach var="subitemObj"
									items="${examViewModel.twoStageReasoning.optionList}"
									varStatus="j">
									<c:if
										test="${Occured!=1 && ((subitemObj.optionLanguage.justification !=null && fn:length(subitemObj.optionLanguage.justification)!=0)|| (subitemObj.optionLanguage.justificationImage!=null && fn:length(subitemObj.optionLanguage.justificationImage)!=0))}">
										<c:set var="Occured" value="1" />
										<p>
											<b><spring:message
													code="questionByquestion.answerexplanation"></spring:message></b>
										</p>
									</c:if>

									<c:if
										test="${subitemObj.optionLanguage.option.isCorrect==true}">
										<c:if
											test="${(subitemObj.optionLanguage.justification !=null && fn:length(subitemObj.optionLanguage.justification)!=0)
									|| (subitemObj.optionLanguage.justificationImage!=null && fn:length(subitemObj.optionLanguage.justificationImage)!=0)}">

											<b><spring:message code="questionByquestion.option"></spring:message>
												${i.count} </b>
											<br />
											<p class="question-wrap">${subitemObj.optionLanguage.justification}</p>
											<c:if
												test="${subitemObj.optionLanguage.justificationImage!=null && fn:length(subitemObj.optionLanguage.justificationImage)!=0}">

												<img
													src="../exam/displayImage?disImg=${subitemObj.optionLanguage.justificationImage}" />

												<br />
											</c:if>
										</c:if>
									</c:if>
									<c:if test="${examViewModel.itemStatus==0 || examViewModel.itemStatus==10}">

										<c:if
											test="${fn:length(examViewModel.candidateAnswerList)!=0 && examViewModel.candidateAnswerList!=null}">
											<c:forEach var="candidateAnsObj"
												items="${examViewModel.candidateAnswerList}">
												<c:if
													test="${candidateAnsObj.optionID==suboptionObj.optionLanguage.fkOptionID && candidateAnsObj.isCorrect==false}">

													<c:if
														test="${(subitemObj.optionLanguage.justification !=null && fn:length(subitemObj.optionLanguage.justification)!=0)
									    || (subitemObj.optionLanguage.justificationImage!=null && fn:length(subitemObj.optionLanguage.justificationImage)!=0)}">
														<b> <spring:message code="questionByquestion.option"></spring:message>
															${i.count}
														</b>
														<br />
														<p class="question-wrap">${subitemObj.optionLanguage.justification}</p>
														<c:if
															test="${subitemObj.optionLanguage.justificationImage!=null && fn:length(subitemObj.optionLanguage.justificationImage)!=0}">

															<img
																src="../exam/displayImage?disImg=${subitemObj.optionLanguage.justificationImage}" />
															<br />
														</c:if>
													</c:if>
													<!-- check whetherjustification image or text is exist or not -->
												</c:if>
											</c:forEach>
										</c:if>
									</c:if>
								</c:forEach>
								<hr class="lineColor" />


								<c:forEach var="twoStageOptionObj"
									items="${examViewModel.twoStageReasoning.optionList}"
									varStatus="i1">
									<c:set var="answer" value="0" scope="page" />
									<b>SubItem ${i1.count} : </b>
									<p class="question-wrap">
										${twoStageOptionObj.subItemID.subItemText}</p>
									<c:if
										test="${twoStageOptionObj.subItemID.subItemImage!=null && fn:length(twoStageOptionObj.subItemID.subItemImage)!=0}">
										<br />
										<img
											src="../exam/displayImage?disImg=${twoStageOptionObj.subItemID.subItemImage}"
											class="resize" />
									</c:if>

									<b><br /> <br />
									<spring:message code="questionByquestion.option"></spring:message></b>
									<table class="table table-bordered">
										<tr>
											<th style="width: 40px;"><spring:message
													code="questionByquestion.sr.no"></spring:message></th>
											<th><spring:message code="questionByquestion.optiontext"></spring:message>
											</th>
											<th style="width: 150px; float: rigth;"><spring:message
													code="questionByquestion.candidateselection"></spring:message></th>
										<tr>
											<c:forEach var="suboptionObj"
												items="${twoStageOptionObj.subItemID.optionList}"
												varStatus="i">

												<c:choose>
													<c:when
														test="${suboptionObj.optionLanguage.option.isCorrect==true}">
														<c:set var="answer" value="1" />
														<tr>
															<td>${i.count}&nbsp;<img
																src="${resourcespath}images/tick.png"></td>
															<td>
																<p class="question-wrap">${suboptionObj.subOptionText}</p>
																<c:if
																	test="${fn:length(suboptionObj.subOptionImage)!=0}">
																	<br />
																	<img
																		src="../exam/displayImage?disImg=${suboptionObj.subOptionImage}" />
																</c:if>
															</td>
															<td><c:if
																	test="${fn:length(examViewModel.candidateAnswerList)!=0 && examViewModel.candidateAnswerList!=null}">
																	<c:forEach var="candidateAnsObj"
																		items="${examViewModel.candidateAnswerList}">
																		<c:if
																			test="${candidateAnsObj.optionID==suboptionObj.optionLanguage.fkOptionID}">
																			<c:set var="answer" value="1" />
																			<c:choose>
																				<c:when test="${candidateAnsObj.isCorrect==true}">
																					<center>
																						<i class="icon-user"></i>&nbsp; <img
																							src="${resourcespath}images/tick.png">
																					</center>
																				</c:when>
																				<c:otherwise>
																					<center>
																						<i class="icon-user"></i>&nbsp; <img
																							src="${resourcespath}images/wrong.png">
																					</center>
																				</c:otherwise>
																			</c:choose>
																		</c:if>
																	</c:forEach>
																</c:if></td>
														</tr>
													</c:when>
													<c:otherwise>
														<tr>
															<td>${i.count}&nbsp;</td>
															<td>
																<p class="question-wrap">${suboptionObj.subOptionText}</p>
																<c:if
																	test="${fn:length(suboptionObj.subOptionImage)!=0}">
																	<br />
																	<img
																		src="../exam/displayImage?disImg=${suboptionObj.subOptionImage}" />
																</c:if>
															</td>
															<td><c:if
																	test="${fn:length(examViewModel.candidateAnswerList)!=0 && examViewModel.candidateAnswerList!=null}">
																	<c:forEach var="candidateAnsObj"
																		items="${examViewModel.candidateAnswerList}">
																		<c:if
																			test="${ candidateAnsObj.optionID==suboptionObj.optionLanguage.fkOptionID}">
																			<c:set var="answer" value="1" />
																			<c:choose>
																				<c:when test="${candidateAnsObj.isCorrect==true}">
																					<center>
																						<i class="icon-user"></i>&nbsp; <img
																							src="${resourcespath}images/tick.png">
																					</center>
																				</c:when>
																				<c:otherwise>
																					<center>
																						<i class="icon-user"></i>&nbsp; <img
																							src="${resourcespath}images/wrong.png">
																					</center>
																				</c:otherwise>
																			</c:choose>
																		</c:if>
																	</c:forEach>
																</c:if></td>
														</tr>
													</c:otherwise>
												</c:choose>
											</c:forEach>
									</table>

									<!-- Answer Explanation of sub item option -->
									<c:set var="Occured" value="0" />
									<c:forEach var="suboptionObj"
										items="${twoStageOptionObj.subItemID.optionList}"
										varStatus="i">

										<c:if
											test="${(Occured!=1  && answer==1) && ((suboptionObj.optionLanguage.justification !=null && fn:length(suboptionObj.optionLanguage.justification)!=0)|| (suboptionObj.optionLanguage.justificationImage!=null && fn:length(suboptionObj.optionLanguage.justificationImage)!=0))}">
											<c:set var="Occured" value="1" />
											<p>
												<b><spring:message
														code="questionByquestion.answerexplanation"></spring:message></b>
											</p>
										</c:if>

										<c:if
											test="${suboptionObj.optionLanguage.option.isCorrect==true}">
											<c:if
												test="${(suboptionObj.optionLanguage.justification !=null && fn:length(suboptionObj.optionLanguage.justification)!=0)
									|| (suboptionObj.optionLanguage.justificationImage!=null && fn:length(suboptionObj.optionLanguage.justificationImage)!=0)}">

												<b><spring:message code="questionByquestion.option"></spring:message>
													${i.count} </b>
												<br />
												<p class="question-wrap">${suboptionObj.optionLanguage.justification}</p>
												<c:if
													test="${suboptionObj.optionLanguage.justificationImage!=null && fn:length(suboptionObj.optionLanguage.justificationImage)!=0}">

													<img
														src="../exam/displayImage?disImg=${suboptionObj.optionLanguage.justificationImage}" />

													<br />
												</c:if>
											</c:if>
										</c:if>
										<c:if test="${examViewModel.itemStatus==0 || examViewModel.itemStatus==10}">

											<c:if
												test="${fn:length(examViewModel.candidateAnswerList)!=0 && examViewModel.candidateAnswerList!=null}">
												<c:forEach var="candidateAnsObj"
													items="${examViewModel.candidateAnswerList}">
													<c:if
														test="${candidateAnsObj.optionID==suboptionObj.optionLanguage.fkOptionID && candidateAnsObj.isCorrect==false}">

														<c:if
															test="${(suboptionObj.optionLanguage.justification !=null && fn:length(suboptionObj.optionLanguage.justification)!=0)
									    || (suboptionObj.optionLanguage.justificationImage!=null && fn:length(suboptionObj.optionLanguage.justificationImage)!=0)}">
															<b> <spring:message code="questionByquestion.option"></spring:message>
																${i.count}
															</b>
															<br />
															<p class="question-wrap">${suboptionObj.optionLanguage.justification}</p>
															<c:if
																test="${suboptionObj.optionLanguage.justificationImage!=null && fn:length(suboptionObj.optionLanguage.justificationImage)!=0}">

																<img
																	src="../exam/displayImage?disImg=${suboptionObj.optionLanguage.justificationImage}" />
																<br />
															</c:if>
														</c:if>
														<!-- check whetherjustification image or text is exist or not -->
													</c:if>
												</c:forEach>
											</c:if>
										</c:if>
									</c:forEach>

									<c:if
										test="${fn:length(examViewModel.twoStageReasoning.optionList)!=i1.count}">
										<hr class="lineColor" />
									</c:if>
								</c:forEach>


							</c:if>
						</c:if>


						<br />



				
			</div>






		</div>
	</div>
</div>


</c:forEach>

<script type="text/javascript">

function shuffle(array) 
{
	  var currentIndex = array.length, temporaryValue, randomIndex;
	
	  while (0 !== currentIndex) {
	
	    randomIndex = Math.floor(Math.random() * currentIndex);
	    currentIndex -= 1;
	
	    temporaryValue = array[currentIndex];
	    array[currentIndex] = array[randomIndex];
	    array[randomIndex] = temporaryValue;
	  }
	
	  return array;
}

function loadWords()
{
	$('div.wcDiv').each(function()
	{		var ca = $("#hdn" + $(this).attr('id')).val();
		var wc=[];
		var arr =shuffle($(this).data('text').split(","));
		$.each(arr,function(i,v) {
			wc.push({ text: v, weight: i, html:{class: v==ca ? 'wc-selectedAnswer' : '' , style: i%3==0 ? 'writing-mode: tb-rl' : ''} });
		});
		//console.log(wc);
		$(this).jQCloud(wc, {
			  height: 400,
			  removeOverflowing: false,
			  steps: 20,
			  colors: ["#e6194B", "#3cb44b", "#ffe119", "#4363d8", "#f58231", "#911eb4", "#42d4f4", "#f032e6", "#bfef45", "#fabebe", "#469990", "#e6beff", "#9A6324", "#800000", "#aaffc3", "#808000", "#ffd8b1", "#000075", "#a9a9a9", "#000000"],
			  fontSize: {
			        from: 0.05,
			        to: 0.02
			      },		  
			  center: {x: 0.5, y:0.5},
			  autoResize:	true,
			  afterCloudRender: function()
			  {
				  $(this).find('span.wc-selectedAnswer').each(function(){
					  $(this).css('background-color', $(this).css('color'));
					  $(this).css('color', 'rgb(255,255,255)');
				  });
			  }
		});
	});
}

$(document).ready(function() {
	loadWords();
	showSpotData();
	/* $('img[usemap]').each(function(){
		var img=$(this);
		console.log($(img).attr("id")+"OKK");
	}); */
	console.log("OKK");
	$('[id^=refMatrixDiv]').each(function() {
		createMatrix(this.id.split("_")[1]);
		console.log("OKK");
	});
});
</script>
<script type="text/javascript">
function showSpotData()
{
	$('img[usemap]').each(function(){
		var img=$(this);
		$(img).mapster({
		    areas: [
		        {
		            key: 'XX',
		            fillColor: '00ff00',
		            staticState: true,
		            stroke: true            
		        },
		        {
		            key: 'NV',
		            fillColor: 'ff0000',
		            staticState: true          
		        }
		   ],
		    mapKey: 'state'
		});
		//$('img[usemap]').rwdImageMaps();
	
		$('div.areaDivs'+$(img).attr('id')).each(function()
		{
			var di = document.createElement('div');
	        var im = document.createElement('img');
	        $(di).addClass("hs_pointer_di");
	        $(im).addClass("hs_pointer");
	        $(im).attr('src','../resources/images/hs_pointer.png')
	        $(di).css("left",parseInt($(this).find('input:hidden[id^="x1_"]').val())+Math.round($(img).position().left)-20);
	        $(di).css("top",parseInt($(this).find('input:hidden[id^="y1_"]').val())+Math.round($(img).position().top)-32);
	        $(di).css("position",'absolute');
	        $(di).attr("data-x1",$(this).find('input:hidden[id^="x1_"]').val());
	        $(di).attr("data-y1",$(this).find('input:hidden[id^="y1_"]').val());
	        $(di).append(im);
	        
	        $(img).after(di);
		});
	});
}

function createMatrix(itemID){
	var refCellData = $("#cellData_"+itemID).text();
	console.log(refCellData);
	if(refCellData !='' && refCellData !=undefined){ // if celldata not empty or null
		var jsonCellData=jQuery.parseJSON(refCellData);
		//$("."+idCellData[0]+"tblRefMatrix").remove();
		//var table = $(document.createElement('table')).attr("class",+itemID+'tblRefMatrix').attr("class", "table table-bordered");
		var table = $(document.createElement('table')).attr("id",itemID).attr("class","table table-bordered");
		$.each(jsonCellData, function(key,value) {
			  var newTr = $(document.createElement('tr'));
			  var count=0;
			  /* console.log("rno:"+value.rno); */
			  var rowno=value.rno;
			  $.each(value.column, function(key,value) {
				 
				  var colmnno=value.cno;					  
				  var newTd = $(document.createElement('td'));
					var newDiv= $(document.createElement('div')).attr("id",'div'+rowno+''+colmnno+'');
					var sequencingType=$('#sequencingType_'+itemID).val();
					
					if(sequencingType=='TEXT')
                    {
                         newDiv.append(value.cvalue);  
                    }
                    else
                    {
                         newDiv.append('<img src="../exam/displayImage?disImg='+value.cvalue+'" class="resize" style="max-width:150px; max-height:150px;"/>');
                    }
					count++;
					newTd.append(newDiv);
					/* if(value.checked){
						newTd.attr("style","background-color: #2ECCFA;");
					} */
					newTr.append(newTd);
			});
			  table.append(newTr);
		});
		$("#refMatrixDiv_"+itemID).append(table);
		
	} // end matrix generation
}

</script>
