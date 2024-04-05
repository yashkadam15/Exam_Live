<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page errorPage="../common/jsperror.jsp"%>
<spring:theme code="playertheme" var="playertheme"/>
<link rel="stylesheet" href="<c:url value='${playertheme}'></c:url>" type="text/css" />
<script type="text/javascript" src="<c:url value='/resources/js/jquery-1.12.0.min.js'></c:url>"></script> 
<script src="<c:url value='/resources/js/jquery.jplayer.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/oesplayer.js'></c:url>"></script>
<c:if test="${examViewModel.multimedia!=null}">
	<br>
	<b> <spring:message code="questionByquestion.mainQuestion" />
		${itemNo}:&nbsp;
	</b>
	<p class="question-wrap">${examViewModel.multimedia.itemText }</p>	
	
	<!-- Code to show media Player -->
	<c:if test="${fn:length(examViewModel.multimedia.itemFilePath)!=0 }">		
	 <%-- <div id="MMplayer_1" data-mediamode="open" data-mediatype="${fn:toLowerCase(examViewModel.multimedia.multimediaType)}" data-mediaurl="../exam/getmedia?f=${examViewModel.multimedia.itemFilePath}&e=${examViewModel.multimedia.fileTypeExtension}" data-mediaext="${examViewModel.multimedia.fileTypeExtension}"
	   data-medialoadonready="true" ></div> --%>
	</c:if>
	
	
	<hr class="lineColor" />
	<c:set var="lineCnt" value="0" />
	<c:forEach var="subitemObj"
		items="${examViewModel.multimedia.subItemList}" varStatus="i1">

		<!-- show marks obtained of each subitem -->
		<c:forEach items="${examViewModel.candidateItemAssociationList}"
			var="candidateItemAssociationObj">
			
			<c:if
				test="${(candidateItemAssociationObj.itemStatus == 'Answered') && subitemObj.itemLanguage.item.itemID== candidateItemAssociationObj.fkItemID}">
				<c:choose>
					<c:when test="${examViewModel.multimedia.subItemType=='NOOPT'}">
						<legend style="color: grey">
							<span><spring:message code="viewtestscore.evaluationPending"/></span>		
							<span class="pull-right"><spring:message code="questionByquestion.marksObtainedForItem" /> :NA</span>					
						</legend>
					</c:when>
					<c:when test="${candidateItemAssociationObj.isCorrect == true}">
						<legend style="color: green;">
							<span><spring:message code="questionByquestion.correct"></spring:message></span>
							<span class="pull-right"><spring:message
									code="questionByquestion.marksObtainedForItem" /> :
								${candidateItemAssociationObj.marksObtained}</span>
						</legend>
					</c:when>
					<c:otherwise>
						<c:choose>
							<c:when test="${candidateItemAssociationObj.isCorrect == false}">
								<legend style="color: red;">
									<span><spring:message
											code="questionByquestion.incorrect"></spring:message></span> <span
										class="pull-right"><spring:message
											code="questionByquestion.marksObtainedForItem" />
										:${candidateItemAssociationObj.marksObtained}</span>
								</legend>
							</c:when>
							<c:otherwise>
								<!-- if mark for reviewed then show not attepted and isCorrect is null-->
								<legend style="color: grey;">
									<span><spring:message
											code="questionByquestion.notattempted"></spring:message></span>
								</legend>
							</c:otherwise>
						</c:choose>
					</c:otherwise>
				</c:choose>
			</c:if>
			<c:if
				test="${(candidateItemAssociationObj.itemStatus == 'NotAnswered' ||  candidateItemAssociationObj.itemStatus== 'NoStatus') &&  subitemObj.itemLanguage.item.itemID== candidateItemAssociationObj.fkItemID}">
				<legend style="color: grey;">
					<span><spring:message code="questionByquestion.notattempted"></spring:message></span>
				</legend>
			</c:if>
		</c:forEach>
		<!--end  show marks obtained of each subitem -->


		<b><spring:message code="questionByquestion.question"></spring:message>		${i1.count} : </b>
		<p class="question-wrap">${subitemObj.subItemText}</p>
		<c:if
			test="${subitemObj.subItemImage!=null && fn:length(subitemObj.subItemImage)!=0}">
			<br />
			<img src="../exam/displayImage?disImg=${subitemObj.subItemImage}"
				class="resize" />
			<br />
		</c:if>
		
		
		<c:choose>
			<c:when test="${examViewModel.multimedia.subItemType=='MCMC'}">
				<b><br /> <spring:message code="questionByquestion.option"></spring:message></b>
		<table class="table table-bordered">
			<tr>
				<th style="width: 40px;"><spring:message code="questionByquestion.sr.no"></spring:message></th>
				<th><spring:message code="questionByquestion.optiontext"></spring:message>		</th>
				<th style="width: 150px; float: rigth;"><spring:message	code="questionByquestion.candidateselection"></spring:message></th>
			<tr>
				<c:forEach var="suboptionObj" items="${subitemObj.optionList}" 			varStatus="i">

					<c:choose>
						<c:when
							test="${suboptionObj.optionLanguage.option.isCorrect==true}">
							<tr>
								<td>${i.count}&nbsp;<img
									src="${resourcespath}images/tick.png"></td>
								<td>
									<p class="question-wrap">${suboptionObj.subOptionText}</p> <c:if
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
												test="${candidateAnsObj.fkItemID==subitemObj.itemLanguage.item.itemID && candidateAnsObj.optionID==suboptionObj.optionLanguage.fkOptionID}">

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
									<p class="question-wrap">${suboptionObj.subOptionText}</p> <c:if
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
												test="${candidateAnsObj.fkItemID==subitemObj.itemLanguage.item.itemID && candidateAnsObj.optionID==suboptionObj.optionLanguage.fkOptionID}">

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
			</c:when>
			<c:otherwise>
				<br><b><spring:message code="MSCITExam.Answer"></spring:message> </b>
				<br> <c:if
										test="${fn:length(examViewModel.candidateAnswerList)!=0 && examViewModel.candidateAnswerList!=null}">
										<c:forEach var="candidateAnsObj"
											items="${examViewModel.candidateAnswerList}">
											<c:if
												test="${candidateAnsObj.fkItemID==subitemObj.itemLanguage.item.itemID}">
													
												${candidateAnsObj.optionFilePath}
											</c:if>
										</c:forEach>
									</c:if><br>
			</c:otherwise>
		</c:choose>
		

		<!-- Answer Explanation -->
		<c:set var="Occured" value="0" />
		<c:forEach var="suboptionObj" items="${subitemObj.optionList}"
			varStatus="i">

			<c:if
				test="${Occured!=1 && ((suboptionObj.optionLanguage.justification !=null && fn:length(suboptionObj.optionLanguage.justification)!=0)|| (suboptionObj.optionLanguage.justificationImage!=null && fn:length(suboptionObj.optionLanguage.justificationImage)!=0))}">
				<c:set var="Occured" value="1" />
				<p>
					<b> <spring:message code="questionByquestion.answerexplanation"></spring:message></b>
				</p>
			</c:if>

			<c:if test="${suboptionObj.optionLanguage.option.isCorrect==true}">
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

						<img src="../exam/displayImage?disImg=${suboptionObj.optionLanguage.justificationImage}" />
						<br />
					</c:if>
				</c:if>
			</c:if>


			<c:if
				test="${fn:length(examViewModel.candidateAnswerList)!=0 && examViewModel.candidateAnswerList!=null}">
				<c:forEach var="candidateAnsObj"
					items="${examViewModel.candidateAnswerList}">
					<c:if
						test="${candidateAnsObj.fkItemID==subitemObj.itemLanguage.item.itemID && candidateAnsObj.optionID==suboptionObj.optionLanguage.fkOptionID && candidateAnsObj.isCorrect==false}">

						<c:if
							test="${(suboptionObj.optionLanguage.justification !=null && fn:length(suboptionObj.optionLanguage.justification)!=0)    || (suboptionObj.optionLanguage.justificationImage!=null && fn:length(suboptionObj.optionLanguage.justificationImage)!=0)}">
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

		</c:forEach>
		<c:if
			test="${fn:length(examViewModel.multimedia.subItemList)!=i1.count}">
			<hr class="lineColor" />
		</c:if>

	</c:forEach>

</c:if>