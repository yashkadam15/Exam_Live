

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<html>
<head>
<title>Candidate Attempt Report</title>
<script src="<c:url value='/resources/js/jquery-1.12.0.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/bootstrap.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/selectFix.js'></c:url>"></script>

<script type="text/javascript">

$(document).ready(function(){
	$('[id^=refMatrixDiv]').each(function() {
		createMatrix(this.id.split("_")[1]);
	});
});


function createMatrix(itemID){
	var refCellData = $("#cellData_"+itemID).text();
	if(refCellData !='' && refCellData !=undefined){ // if celldata not empty or null
		var jsonCellData=jQuery.parseJSON(refCellData);
		//$("."+idCellData[0]+"tblRefMatrix").remove();
		//var table = $(document.createElement('table')).attr("class",+itemID+'tblRefMatrix').attr("class", "table table-bordered");
		var table = $(document.createElement('table')).attr("id",itemID).attr("class","questionArea");
		$.each(jsonCellData, function(key,value) {
			  var newTr = $(document.createElement('tr'));
			  /* console.log("rno:"+value.rno); */
			  var rowno=value.rno;
			  $.each(value.column, function(key,value) {
				
				  var colmnno=value.cno;					  
				  var newTd = $(document.createElement('td'));
					var newDiv= $(document.createElement('div')).attr("id",'div'+rowno+''+colmnno+'');
					//newDiv.append(value.cvalue);
					
					var sequencingType=$('#sequencingType_'+itemID).val();
					
                    if(sequencingType=='TEXT')
                    {
                         newDiv.append(value.cvalue);  
                    }
                    else
                    {
                    		/* <img src="../ItemRepository/../exam/displayImage?disImg=${option.optionImage}" /> */
							newDiv.append('<img src="../exam/displayImage?disImg='+value.cvalue+'" class="resize" style="max-width:100px; max-height:100px;"  />');
                    	/* newDiv.append('<img src="../exam/../exam/displayImage?disImg='+value.cvalue+'" class="resize" />'); */
                    }
					
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

<style type="text/css">
/* table {
	border-collapse: collapse;
} */

tr {
	page-break-inside: avoid;
	page-break-after: auto
}

table, td, th {
    border: 1pt solid gray;
    padding: 5px;
}

table.questionArea {
    border-collapse: collapse;
   font-family: ArabicTypesetting;
    font-size: 12px;
    /*  border:2px solid gray; */
}
table.basicInfo {
    border-collapse: collapse;
   /*  border:2px solid gray; */
    font-family: Aparajita,ArabicTypesetting;
    font-size: 22px;
}
.directionRTL{
	direction: rtl;
}

/* .mainQuestionText {
    text-indent: -2em;
}
ul.b {
    list-style-type: none;
}

.reportTitleWidth{
width: 33%;
} */

</style>
</head>
<body style="font-family: Aparajita;font-size: 18px;">
<c:choose>
<c:when test="${locale =='messages_ar.properties' }">
<div style="padding: 10px;" dir="rtl">
</c:when>
<c:otherwise>
<div style="padding: 10px;">
</c:otherwise>
</c:choose>
	
		<table width="100%" class="basicInfo">
			<tr>
			<td colspan="4" style="background-color: gray;"><p style="text-align: center;font-size: 32px;"><spring:message code="attemptReport.pdftitle"></spring:message>
			&nbsp;${candidateAttemptDetails.lastName}
			&nbsp;${candidateAttemptDetails.middleName}
			&nbsp;${candidateAttemptDetails.firstName}
			
			<br/>
			<spring:message code="attemptReport.pdfSubtitle"></spring:message></p>
			</td>
			</tr>
			<tr>
			<td colspan="2" width="33%"><spring:message code="attemptReport.examEvent"/></td>
			<td colspan="2">${candidateAttemptDetails.eventName}</td>
			</tr>
			
			<tr>
			<td colspan="2"><spring:message code="attemptReport.pName"/></td>
			<td colspan="2">${candidateAttemptDetails.paperName}</td>
			</tr>
			
			<tr>
			<td colspan="2"><spring:message code="attemptReport.attemptNo"/></td>
			<td colspan="2">${candidateAttemptDetails.attemptNo}</td>
			</tr>
			
			<tr>
			<td colspan="2"><spring:message code="attemptReport.candidateCode"/></td>
			<td colspan="2">${candidateAttemptDetails.candidateCode}</td>
			</tr>
			
			<tr>
			<td colspan="2"><spring:message code="attemptReport.examStatus"/></td>
			<td colspan="2">
			<c:choose>
				<c:when test="${candidateAttemptDetails.examStatus==true}">
					<spring:message code="attemptReport.complete" />
				</c:when>
				<c:otherwise>
					<spring:message code="attemptReport.incomplete" />
				</c:otherwise>
			</c:choose>
			</td>
			</tr>
			
			<tr>	
			<td colspan="2"><spring:message code="attemptReport.totQues"/></td>
			<td colspan="2">${candidateAttemptDetails.totQuestions}</td>
			</tr>
			
			<tr>
			<td colspan="2"><spring:message code="attemptReport.atmptQues"/></td>
			<td colspan="2">${candidateAttemptDetails.attemptedQuestions}</td>
			</tr>
			
			<tr>
			<td colspan="2"><spring:message code="attemptReport.remainQues"/></td>
			<td colspan="2">${candidateAttemptDetails.remainingQuestios}</td>
			</tr>
			
			<tr>
			<td colspan="2"><spring:message code="attemptReport.markObt"/></td>
			<td colspan="2">${candidateAttemptDetails.marksObtained}</td>
			</tr>
			
			</table>

	
		<div style="padding-top: 20px;font-size: 18px;">
			#Note: &nbsp;
					<p style="color: blue;display: inline;">Blue</p>&nbsp;Color indicates 'Correct Answer' 
					&nbsp;&nbsp;<p style="color: red;display: inline;">Red</p>&nbsp;Color indicates 'Incorrect
					Answer' &nbsp;
					&nbsp;&nbsp;<p style="color: black;display: inline;"><b>Black</b></p>&nbsp;Color indicates 'Not Attempted' 
		</div>	
		
			<c:choose>
				<c:when test="${candidateAttemptDetails.candidatePaperLanguage=='40189c20-b1b6-4abb-bc9a-adf71fc44bb4' || candidateAttemptDetails.candidatePaperLanguage=='cd9daa9b-e66c-403f-8961-f0567d80f127'}">
					<table width="100%" class="questionArea directionRTL" id="tblCandidateAttempt">
				</c:when>
				<c:otherwise>
					<table width="100%" class="questionArea" id="tblCandidateAttempt">
				</c:otherwise>
			</c:choose>
			
			<c:forEach items="${candidateAttemptDetails.attemptPDFs}" var="candAttemptReport">
				<c:set var="itemCount" value="${candAttemptReport.itemSequenceNumber}"/>
				<c:if test="${not(candAttemptReport.sectionName=='Default') and candAttemptReport.itemSequenceNumber==1}">
					<tr style="background-color: gray;">
						<td align="center" colspan="4">
							${candAttemptReport.sectionName}
						</td>
					</tr>
				</c:if>	
					
				<tr style="border-bottom-style: 2px solid gray;">
					<td width="15%">
					 	<spring:message code="attemptReport.questionID"/>${candAttemptReport.itemID}
					</td>
					<td width="10%">
						<spring:message code="attemptReport.question"/>${candAttemptReport.itemSequenceNumber}.
					</td>
					<td colspan="2" >
					
						<c:if test="${not empty candAttemptReport.itemText}">
							<c:choose>
								<c:when test="${not(candAttemptReport.multimediaType eq null) and ( candAttemptReport.multimediaType eq 'AUDIO' or candAttemptReport.multimediaType eq 'VIDEO')}">
									<c:choose>
										<c:when test="${not(candAttemptReport.multimediaType eq null) and candAttemptReport.multimediaType eq 'AUDIO'}">
											<spring:message code='attemptReport.AudioQuestion' /> (${candAttemptReport.itemText})
										</c:when>
										<c:when test="${not(candAttemptReport.multimediaType eq null) and candAttemptReport.multimediaType eq 'VIDEO'}">
											<spring:message code='attemptReport.VideoQuestion' /> (${candAttemptReport.itemText})
										</c:when>
									</c:choose>
								</c:when>
								<c:otherwise>
									<%-- <label>${fn:escapeXml(candAttemptReport.itemText)}</label> --%>
									<label>${candAttemptReport.itemText}</label>
								</c:otherwise>
							</c:choose>
						</c:if>
						
						 <c:if test="${fn:length(candAttemptReport.itemImageList)>0}">
							<c:forEach items="${candAttemptReport.itemImageList}" var="itemImage">
							
								<img src="../exam/displayImage?disImg=${fn:split(itemImage, '/')[3]}"/>
								
								<%-- <c:if test="${not empty(itemImage) or not(itemImage==null) or fn:length(itemImage)>0 or not(itemImage=='')}">
									<img src="../exam/displayImage?disImg=${fn:split(itemImage, '/')[3]}"/>
								</c:if>	 --%>					
							</c:forEach>
						</c:if>
						<c:if test="${candAttemptReport.itemType=='SML'}">
						Simulation File
						</c:if>					
													
<!-- </td> -->	
<!-- </tr> -->
			
						<!-- OPTION ROW FOR MATCH THE COLUMN AND SEQUENCING -->
						<c:if test="${candAttemptReport.itemType=='MTC' or candAttemptReport.itemType=='SQ'}">
						
							<tr>
								<td colspan="2"><spring:message code="mtc.option"></spring:message></td>
								<td colspan="2"> 
								<input type="hidden" id="sequencingType_${candAttemptReport.itemID}" name="sequencingType" value="${candAttemptReport.sequencingType}"/>
									<div id="refMatrixDiv_${candAttemptReport.itemID}"></div> 
									<label id="cellData_${candAttemptReport.itemID}" hidden="true">${mtcItemIdAndCellDataMap[candAttemptReport.itemID]}</label>
								</td>
							</tr>
						</c:if> 
									
						<!-- display answer is correct or not for simulation-->
						<c:if test="${candAttemptReport.itemType=='SML'}">
							<tr>
								<td colspan="2">Is Correct</td>
								<td colspan="2">
									<c:out default="None" escapeXml="true" value="${candAttemptReport.correctIncorrectFlag ? 'YES' : 'NO'}" />
								</td>
							</tr>
						</c:if> 
									
								<!-- Correct Answer ID, Correct Answer -->
								<c:choose>								
									<c:when test="${not(candAttemptReport.itemType=='null') and (candAttemptReport.itemType=='EC' or candAttemptReport.itemType=='RWP' or candAttemptReport.itemType=='FQFA' or candAttemptReport.itemType=='MTC' or  candAttemptReport.itemType=='SQ')}">
									<c:choose>
									<c:when test="${candAttemptReport.itemType=='SQ' and candAttemptReport.sequencingType =='IMAGE'}">
									<c:if test="${not(candAttemptReport.corrrectAnsSQImage=='null') and fn:length(candAttemptReport.corrrectAnsSQImage) > 0 }">
									
								<c:forTokens items="${candAttemptReport.corrrectAnsSQImage }" delims="|||" var="ans" varStatus="cNO">
									<tr>
										<td colspan="2">
											<spring:message code='attemptReport.correctAns' /> ${cNO.count} 
										</td>										
										 <td colspan="2">
										  	<c:forTokens items="${ans}" delims="," var="ansImg">
									
												<img src="../exam/displayImage?disImg=${ansImg}" class="resize" style="max-width:100px; max-height:100px;" />
									
											</c:forTokens>
										 </td> 									
										
									</tr>
								</c:forTokens>
									
									<%--  <tr>
										<td colspan="2">
											<spring:message code='attemptReport.correctAns' /> 
										</td>										
										  
										<td colspan="2">
											
											<c:forEach items="${candAttemptReport.corrrectAnsSQImage}" var="correctAns" varStatus="i">
											
												<img src="../exam/displayImage?disImg=${correctAns}" class="resize" width="100px" height="100px" />
											
											</c:forEach>
											
										</td>
									</tr>  --%>
									</c:if>
									</c:when>
									<c:otherwise>
									<c:if test="${candAttemptReport.correctAnswerList!='null' and fn:length(candAttemptReport.correctAnswerList) > 0}">
									
										<c:forEach items="${candAttemptReport.correctAnswerList}" var="correctAns" varStatus="i">
											 <tr>
												<td colspan="2">
													<spring:message code='attemptReport.correctAns' /> 
													<%-- ${i.index} --%>											
												</td>										
												<td colspan="2">
														${correctAns}											
												</td>									
											</tr>
										</c:forEach>
									</c:if>
									</c:otherwise>
									</c:choose>
									</c:when>									
									<c:otherwise>
									
										<!-- Option ID, Option Sequence and Option text -->
										<c:if test="${candAttemptReport.itemType!='SML' and fn:length(candAttemptReport.optionText) > 0}">
										<c:forEach items="${candAttemptReport.optionText}" var="option" varStatus="loop">
											<tr>
												<td>
													<spring:message code='attemptReport.optID'/>&nbsp;${option.optionID}
												</td>
												
												<td>
													<spring:message code='attemptReport.option'/>${loop.index+1}. 
												</td>	
														
												<td text-align="left">
													<!-- check for Option Text -->
														<c:if test="${not empty option.optionText}">
															<%-- <label>${fn:escapeXml(option.optionText)}</label>  --%>
															<label>${option.optionText}</label> 
														</c:if>
		 
														<c:if test="${not empty option.optionImage}">
														<%-- <img src="../ItemRepository/../exam/displayImage?disImg=${option.optionImage}" /> --%>
															<img src="../exam/displayImage?disImg=${fn:split(option.optionImage, '/')[3]}" />
															
														</c:if>
												</td>
											</tr>
										</c:forEach>
										</c:if>
									</c:otherwise>	
								</c:choose>
								
								<!-- Correct option, Attempted OptionSequence, Attempted OptionID -->
										<c:choose>
											<c:when test="${not(candAttemptReport.itemType=='null') and (candAttemptReport.itemType=='PRT')}">
											<tr>
												<td text-align="left" colspan="2"></td>
													<td text-align="left"  >
														<c:choose>
													 	 	<c:when test="${candAttemptReport.correctIncorrectFlag=='true'}">
													 	 		<spring:message code="attemptReport.Correct" />
													 	 		</c:when>
													 	 		<c:otherwise>
													 	 			<c:choose>
													 	 				<c:when test="${candAttemptReport.correctIncorrectFlag=='false'}">
													 	 					<p style="color: red;">
													 	 						<spring:message code="attemptReport.InCorrect" />
													 	 					</p>
													 	 				</c:when>
													 	 				<c:otherwise>
													 	 					<spring:message code="attemptReport.notAttempted" />
													 	 				</c:otherwise>
													 	 			</c:choose>
												 		 		</c:otherwise>
													 	 </c:choose>
													</td>
												</tr>													 	 
											</c:when>

										<c:when
											test="${not(candAttemptReport.itemType=='null') and (candAttemptReport.itemType=='EC' or candAttemptReport.itemType=='RWP' or candAttemptReport.itemType=='FQFA')}">


											<tr>
												<td text-align="left" colspan="2"><spring:message
														code="attemptReport.candidateAnswer" />
													${candAttemptReport.correctIncorrectFlag}</td>

												<td text-align="left">
													<c:choose>
													<c:when test="${not empty candAttemptReport.correctIncorrectFlag and candAttemptReport.correctIncorrectFlag}">
														 	${candidateAnswer} 
													</c:when>
													<c:otherwise>
														<c:choose>
															<c:when
																test="candAttemptReport.correctIncorrectFlag=='false'">
																<p style="color: red;">
																	<b>${candAttemptReport.candidateAnswer}</b>
																</p>
															</c:when>
															<c:otherwise>
																<spring:message code="attemptReport.notAttempted" />
															</c:otherwise>
														</c:choose>
													</c:otherwise>

													</c:choose>
												</td>
											</tr>
											
										</c:when>
										<c:when test="${not(candAttemptReport.itemType=='null') and (candAttemptReport.itemType=='NFIB')}">
											<tr>
												<td text-align="left" colspan="2">
													<spring:message code="attemptReport.candidateAnswer" />
												</td>
												<td text-align="left">
													${candAttemptReport.candidateAnswer }
												</td>
											</tr>
										</c:when>
										<c:when test="${not(candAttemptReport.itemType=='null') and candAttemptReport.itemType=='EW' }">																				
											<tr>
												<td text-align="left" colspan="2" >												
													<spring:message code="attemptReport.candidateAnswer" /> 												 	
												</td>												
												<td text-align="left">
													<c:choose>
														<c:when test="${not empty candAttemptReport.candidateAnswer}">													
															<b>${candAttemptReport.candidateAnswer}</b>										 	 		
														</c:when>
														<c:otherwise>														
															<spring:message code="attemptReport.notAttempted" />													
														</c:otherwise>
													</c:choose>
												</td>									
											</tr>
										</c:when>
									
	 									<c:when test="${not(candAttemptReport.itemType=='null') and candAttemptReport.itemType=='SQ' }">
											<tr>
												<td text-align="left" colspan="2" >												
													<spring:message code="attemptReport.candidateAnswer" />
												</td>
		 	 									 <td text-align="left" colspan="2">
													<c:if test="${not empty candAttemptReport.candidateAnswerID || not(candAttemptReport.candidateAnswerID== 'null')}">	
														<c:choose>
															<c:when test="${candAttemptReport.sequencingType =='IMAGE' and not(candAttemptReport.candidateAnsSQImage=='null') and fn:length(candAttemptReport.candidateAnsSQImage) > 0 }"> 
																<c:forEach items="${candAttemptReport.candidateAnsSQImage}" var="correctAns" varStatus="i">
																
																	<img src="../exam/displayImage?disImg=${correctAns}" class="resize" style="max-width:100px; max-height:100px;"  />
																
																</c:forEach>
															</c:when>
															<c:otherwise>
																<c:if test="${candAttemptReport.candidateAnswer==null || candAttemptReport.candidateAnswer=='empty'}">
																	<spring:message code="attemptReport.notAttempted" />
																</c:if>												
																	<b>${candAttemptReport.candidateAnswer}</b>	
															</c:otherwise>	
														</c:choose>									 	 		
														</c:if>	
												 </td>
													
											</tr>
		
										</c:when> 
											
										<c:otherwise>

											<c:if test="${not(candAttemptReport.correctOptionSeqList=='null') and fn:length(candAttemptReport.correctOptionSeqList) > 0}">

												<tr>
													<td text-align="left" colspan="2">
														<spring:message code="attemptReport.correctOption" /> &nbsp; 
														<c:if test="${not(candAttemptReport.correctOptionSeqList=='null') and fn:length(candAttemptReport.correctOptionSeqList) > 0}">
															<c:forEach items="${candAttemptReport.correctOptionSeqList}" var="correctOption" varStatus="loop">
										 	 					${correctOption}${!loop.last ? ',' : ''}
										 	 	 		 
										 	 				</c:forEach>
														</c:if>
													</td>
													
													<td text-align="left">
													<c:choose>
														<c:when test="${not(candAttemptReport.correctIncorrectFlag=='null') and (candAttemptReport.correctIncorrectFlag=='true')}">
															<p style="color: blue;">
																<spring:message code="attemptReport.attemptedOption" />&nbsp;
																<c:if test="${not empty candAttemptReport.attemptedOptionSeqList}">
																	<c:forEach items="${candAttemptReport.attemptedOptionSeqList}" var="atmptOption" varStatus="loop">
									 	 								${atmptOption}${!loop.last ? ',' : ''}
									 	 							</c:forEach>
																</c:if>
																&nbsp; &nbsp;<spring:message code="attemptReport.attemptedOptionID" />&nbsp;

																<c:if test="${not empty candAttemptReport.attemptedOptionIDList}">
																	<c:forEach items="${candAttemptReport.attemptedOptionIDList}" var="attemptOptID" varStatus="loop">
								 	 									${attemptOptID}${!loop.last ? ',' : ''}
									 	 							</c:forEach>
																</c:if>

															</p>
														</c:when>
														<c:otherwise>
															<c:choose>
																<c:when test="${not empty candAttemptReport.attemptedOptionSeqList}">
																	<c:choose>
																		<c:when test="${candAttemptReport.correctIncorrectFlag=='true'}">
																			<p style="color: blue;">
																		</c:when>
																		<c:when test="${candAttemptReport.correctIncorrectFlag=='false'}">
																			<p style="color: red;">
																		</c:when>
																		<c:otherwise>
																			<p>
																		</c:otherwise>
																	</c:choose>
																	<spring:message code="attemptReport.attemptedOption" />&nbsp;
																	
																	<c:forEach items="${candAttemptReport.attemptedOptionSeqList}" var="atmptOption" varStatus="loop">
									 	 								${atmptOption}${!loop.last ? ',' : ''}
									 	 							</c:forEach>
										 	 						&nbsp; &nbsp;<spring:message code="attemptReport.attemptedOptionID" />&nbsp;
											
																<c:if test="${not empty candAttemptReport.attemptedOptionIDList}">
																	<c:forEach items="${candAttemptReport.attemptedOptionIDList}"
																		var="attemptOptID" varStatus="loop">
								 	 									${attemptOptID}${!loop.last ? ',' : ''}
									 	 							</c:forEach>
																</c:if>

																</p>
																</c:when>

																<c:otherwise>
																	<spring:message code="attemptReport.notAttempted" />
																</c:otherwise>

															</c:choose>
														</c:otherwise>

														</c:choose>
													</td>

												</tr>
											</c:if>
										</c:otherwise>
									</c:choose>
										
										
												
								<!-- For Comprehension Subitems -->
								
								<c:if test="${not(candAttemptReport.subItemViewModels=='null') and fn:length(candAttemptReport.subItemViewModels) > 0}">
									<c:forEach  items="${candAttemptReport.subItemViewModels}" var="subItem" varStatus="subitemCount">
										
										<tr >
											<td text-align="left"  border-top-width="0.4mm">
												<spring:message code="attemptReport.subQuestionID" />&nbsp;${subItem.subItemItemID}
											</td>
											<td text-align="left"  border-top-width="0.4mm">
												<spring:message code="attemptReport.subQuestion" />${itemCount}.${subitemCount.index+1}
											</td>
											<td text-align="left"  border-top-width="0.4mm">
												<c:if test="${not(subItem.subItemText == 'null')}">
													<label>${subItem.subItemText}</label>	
												</c:if>
												
												<c:if test="${not empty subItem.subItemImage}">
														<!-- check for Question Image -->
													<%-- <img src="../ItemRepository/../exam/displayImage?disImg=${subItem.subItemImage}" /> --%>
													<img src="../exam/displayImage?disImg=${fn:split(subItem.subItemImage, '/')[3]}" />
												</c:if>
											</td>
										</tr>
										
										<c:if test="${not(subItem.subItemOptionViewModel=='null') and fn:length(subItem.subItemOptionViewModel) > 0}">
											<c:forEach items="${subItem.subItemOptionViewModel}" var="subItemOption" varStatus="loop">
												<td text-align="left" >
													<spring:message code="attemptReport.optID" />&nbsp;${subItemOption.subOptionID}
												</td>
												<td text-align="left" >
													<p><spring:message code="attemptReport.option" />${loop.index+1}.</p>
												</td>
												<td text-align="left" >
													<p>
													 	<!-- check for Option Text -->
														<c:if test="${not(subItemOption.subOptionText == 'null')}">
															<label>${subItemOption.subOptionText}</label>
														</c:if>
		
														<c:if test="${not empty subItemOption.subOptionImage}">
															<%-- <img src="../ItemRepository/../exam/displayImage?disImg=${subItemOption.subOptionImage}" /> --%>
															<img src="../exam/displayImage?disImg=${fn:split(subItemOption.subOptionImage, '/')[3]}" />
														</c:if>
													
												</td>
											</tr>
										</c:forEach>
											
									<tr style="border-bottom: 4px solid gray;">
									<td text-align="left" colspan="2"  >
										
									 	 <spring:message code="attemptReport.correctOption" />&nbsp;
									 	 <c:forEach items="${subItem.correctOptSeq}" var="correctOptSeq"  varStatus="loop">
									 	 	 ${correctOptSeq}${!loop.last ? ',' : ''}
									 	 </c:forEach>
										
									</td>
																		
									<td text-align="left"  >
										<c:choose>
											<c:when test="${subItem.subItemCorrectInCorrect=='true'}">
												<p style="color: blue;">
													<spring:message code="attemptReport.attemptedOption" />&nbsp;
													 <c:forEach items="${subItem.attemptedOptSeq}" var="attemptedOptionSeq" varStatus="loop">
									 	 				${attemptedOptionSeq}${!loop.last ? ',' : ''}
									 	 			</c:forEach>
									 	 			
									 	 			&nbsp; &nbsp;
									 	 			<spring:message code="attemptReport.attemptedOptionID"/>
													&nbsp;
									 	 			 <c:forEach items="${subItem.attemptedOptionIDList}" var="attemptedOptionID" varStatus="loop">
									 	 				${attemptedOptionID}${!loop.last ? ',' : ''}
									 	 			</c:forEach>
									 	 			
												</p>
											</c:when>
											
											<c:otherwise>									
												<c:choose>
													<c:when test="${not(subItem.attemptedOptSeq=='null') and fn:length(subItem.attemptedOptSeq)>0}">
													<p style="color: red;">
														<spring:message code="attemptReport.attemptedOption" />
														&nbsp;
														 <c:forEach items="${subItem.attemptedOptSeq}" var="attemptedOptionSeq" varStatus="loop">
									 	 					${attemptedOptionSeq}${!loop.last ? ',' : ''}
										 	 			</c:forEach>
										 	 		
										 	 			&nbsp; &nbsp;
										 	 			<spring:message code="attemptReport.attemptedOptionID"/>
														&nbsp;
										 	 			 <c:forEach items="${subItem.attemptedOptionIDList}" var="attemptedOptionID" varStatus="loop">
										 	 				${attemptedOptionID}${!loop.last ? ',' : ''}
										 	 			</c:forEach>
										 	 		</p>
													</c:when>
													<c:otherwise>
														<spring:message code="attemptReport.notAttempted" />
													</c:otherwise>
												</c:choose>
												
											</c:otherwise>
											
										</c:choose>
										
									</td>
								</tr>
								</c:if>
								</c:forEach>
								</c:if><!-- End CMPS Subitems -->
								
								
								<!-- CMPSMQT Subitems Start -->
									
								<c:forEach items="${candAttemptReport.listCMPSMQTSubItems}" var="subItemCMPSMQT"  varStatus="subitemCount">
								
								<tr style="border-bottom-style: 2px solid gray;">
									<td style="text-align: left; border-top-width: 0.4mm;">
									 <spring:message code="attemptReport.questionID"/>${subItemCMPSMQT.itemID}
									</td>
									<td style="text-align: left; border-top-width: 0.4mm;">
									<spring:message code="attemptReport.subQuestion" />${itemCount}.${subitemCount.index+1}
									</td>
									<td style="text-align: left; border-top-width: 0.4mm;">
									
									
										<c:if test="${not empty subItemCMPSMQT.itemText}">
											<c:choose>
												<c:when test="${not(subItemCMPSMQT.multimediaType eq null) and ( subItemCMPSMQT.multimediaType eq 'AUDIO' or subItemCMPSMQT.multimediaType eq 'VIDEO')}">
													<c:if test="${subItemCMPSMQT.multimediaType eq 'AUDIO'}">
														<spring:message code='attemptReport.AudioQuestion' /> (${subItemCMPSMQT.itemText})
													</c:if>
													<c:if test="${subItemCMPSMQT.multimediaType eq 'VIDEO'}">
														 <spring:message code='attemptReport.VideoQuestion' /> (${subItemCMPSMQT.itemText})
													</c:if>													
												</c:when>
												<c:otherwise>												
											   		<label>${subItemCMPSMQT.itemText}</label>
											   </c:otherwise>
											</c:choose>
										</c:if>
									
									<c:if test="${not(subItemCMPSMQT.multimediaType eq null) and (subItemCMPSMQT.multimediaType eq 'IMAGE') and fn:length(subItemCMPSMQT.itemImageList)>0}">
										<c:forEach items="${subItemCMPSMQT.itemImageList}" var="itemImage">
										${itemImage}
											<img src="../exam/displayImage?disImg=${fn:split(itemImage, '/')[3]}" />						
										</c:forEach>
									</c:if>
									
												
								</tr>
								<!-- Correct Answer ID, Correct Answer -->
								<!-- Option ID, Option Sequence and Option text -->
								<c:if test="${ fn:length(subItemCMPSMQT.optionText) > 0}">
										<c:forEach items="${subItemCMPSMQT.optionText}" var="option" varStatus="loop">
											<tr>
												<td>
													<spring:message code='attemptReport.optID'/>&nbsp;${option.optionID}													
												</td>
												
												<td>													
													<spring:message code='attemptReport.option'/>
													${loop.index+1}. 													
												</td>	
														
												<td style="text-align: left;">
													<!-- check for Option Text -->
													<c:if test="${not empty option.optionText}">
														<label>${option.optionText}</label> 
													</c:if>
	 
													<c:if test="${not empty option.optionImage}">
														<img src="../exam/displayImage?disImg=${fn:split(option.optionImage, '/')[3]}" />															
													</c:if>													
												</td>
											</tr>
										</c:forEach>
								</c:if>

							<c:if test="${not(subItemCMPSMQT.itemType=='null') and subItemCMPSMQT.itemType=='EW' }">
								<tr>
									<td style="text-align: left;" colspan="2">
										<spring:message code="attemptReport.candidateAnswer" />
									</td>

									<td style="text-align: left;">
										<c:choose>
											<c:when test="${not empty subItemCMPSMQT.candidateAnswer}">
												<b>${subItemCMPSMQT.candidateAnswer}</b>
											</c:when>
											<c:otherwise>
												<spring:message code="attemptReport.notAttempted" />
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
							</c:if>

							<!-- Correct option, Attempted OptionSequence, Attempted OptionID -->
								<c:if test="${not(subItemCMPSMQT.correctOptionSeqList=='null') and fn:length(subItemCMPSMQT.correctOptionSeqList) > 0}">
									
									<tr>
										<td colspan="2" style="text-align: left;">
											
										 	 <spring:message code="attemptReport.correctOption" /> &nbsp;
										 	 <c:if test="${not(subItemCMPSMQT.correctOptionSeqList=='null') and fn:length(subItemCMPSMQT.correctOptionSeqList) > 0}">
										 	 	<c:forEach items="${subItemCMPSMQT.correctOptionSeqList}" var="correctOption" varStatus="loop">
										 	 		${correctOption}${!loop.last ? ',' : ''}										 	 	 		 
										 	 	</c:forEach>
										 	 </c:if>										
										</td>
																		
										<td style="text-align: left;">
											<c:choose>												
												<c:when test="${not(subItemCMPSMQT.correctIncorrectFlag=='null') and (subItemCMPSMQT.correctIncorrectFlag=='true')}">
													<p style="color:blue ;">
														<spring:message code="attemptReport.attemptedOption" />&nbsp;
														<c:if test="${not empty subItemCMPSMQT.attemptedOptionSeqList}">
															 <c:forEach items="${subItemCMPSMQT.attemptedOptionSeqList}" var="atmptOption" varStatus="loop">
										 	 					${atmptOption}${!loop.last ? ',' : ''}
										 	 				</c:forEach>
										 	 			</c:if>
										 	 			&nbsp; &nbsp;
										 	 			<spring:message code="attemptReport.attemptedOptionID"/>
														&nbsp;														
														<c:if test="${not empty subItemCMPSMQT.attemptedOptionIDList}">
											 	 			<c:forEach items="${subItemCMPSMQT.attemptedOptionIDList}" var="attemptOptID" varStatus="loop">
										 	 						${attemptOptID}${!loop.last ? ',' : ''}
											 	 			</c:forEach>
										 	 			</c:if>										 	 			
													</p>
												</c:when>												
												<c:otherwise>
													<c:choose>
													<c:when test="${not empty subItemCMPSMQT.attemptedOptionSeqList}">
														<c:choose>
															<c:when test="${subItemCMPSMQT.correctIncorrectFlag=='true'}">
																<p style="color: blue;">
															</c:when>
															<c:when test="${subItemCMPSMQT.correctIncorrectFlag=='false'}">
																<p style="color: red;">
															</c:when>
															<c:otherwise>
																<p>
															</c:otherwise>
														</c:choose>


														<spring:message code="attemptReport.attemptedOption" /> &nbsp;
														 <c:forEach items="${subItemCMPSMQT.attemptedOptionSeqList}" var="atmptOption" varStatus="loop">
										 	 					${atmptOption}${!loop.last ? ',' : ''}
										 	 			</c:forEach>
										 	 													 	 			
										 	 			&nbsp; &nbsp;
										 	 			<spring:message code="attemptReport.attemptedOptionID"/>
														&nbsp;
												
														<c:if test="${not empty subItemCMPSMQT.attemptedOptionIDList}">
											 	 			<c:forEach items="${subItemCMPSMQT.attemptedOptionIDList}" var="attemptOptID" varStatus="loop">
										 	 						${attemptOptID}${!loop.last ? ',' : ''}
											 	 			</c:forEach>
										 	 			</c:if>
										 	 			
										 	 		</p>
													</c:when>														
													<c:otherwise>
														<spring:message code="attemptReport.notAttempted" />														
													</c:otherwise>
													
													</c:choose>
												</c:otherwise>
												
											</c:choose>
										</td>
									</tr>		
								</c:if>	
								<%-- 
								<c:if test="${subItemCMPSMQT.candidateAnswer ne null}">
									<tr>
										<td text-align="left" colspan="2" >												
											<spring:message code="attemptReport.candidateAnswer" /> 												 	
										</td>										
										<td text-align="left">
											<c:choose>
												<c:when test="${not empty subItemCMPSMQT.candidateAnswer}">													
													<b>${subItemCMPSMQT.candidateAnswer}</b>										 	 		
												</c:when>
												<c:otherwise>														
													<spring:message code="attemptReport.notAttempted" />													
												</c:otherwise>
											</c:choose>
										</td>									
									</tr>
								</c:if> --%>
								
								</td>
								</tr>
						
								</c:forEach>					
								<!-- CMPSMQT Subitems End -->
							
					</td>
				</tr>
			
			</c:forEach>
			
		</table>
	</div>
</body>
</html>

