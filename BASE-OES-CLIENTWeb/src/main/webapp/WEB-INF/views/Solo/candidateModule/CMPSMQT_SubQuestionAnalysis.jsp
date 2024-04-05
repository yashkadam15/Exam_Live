<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

		<!-- show marks obtained of each subitem -->
		<c:forEach items="${examViewModel.candidateItemAssociationList}" var="candidateItemAssociationObj">
			<c:if test="${(candidateItemAssociationObj.itemStatus == 'Answered') && subitemObj.itemLanguage.fkItemID== candidateItemAssociationObj.fkItemID}">
				<c:choose>
					<c:when test="${candidateItemAssociationObj.isCorrect == true}">
						<legend style="color: green;">
							<span><spring:message code="questionByquestion.correct"></spring:message></span>
							<span class="pull-right"><spring:message code="questionByquestion.marksObtainedForItem" /> :
								${candidateItemAssociationObj.marksObtained}</span>
						</legend>
					</c:when>
					<c:otherwise>
						<c:choose>
							<c:when test="${candidateItemAssociationObj.isCorrect == false}">
								<legend style="color: red;">
									<span><spring:message code="questionByquestion.incorrect"></spring:message></span> 
										<span class="pull-right"><spring:message code="questionByquestion.marksObtainedForItem" />
										:${candidateItemAssociationObj.marksObtained}</span>
								</legend>
							</c:when>
							<c:otherwise>
								<!-- if mark for reviewed then show not attepted and isCorrect is null-->
								<legend style="color: grey;">
									<span><spring:message code="questionByquestion.notattempted"></spring:message></span>
								</legend>
							</c:otherwise>
						</c:choose>
					</c:otherwise>
				</c:choose>
			</c:if>
			<c:if test="${(candidateItemAssociationObj.itemStatus == 'NotAnswered' ||  candidateItemAssociationObj.itemStatus== 'NoStatus') &&  subitemObj.itemLanguage.fkItemID==candidateItemAssociationObj.fkItemID}">
				<legend style="color: grey;">
					<span><spring:message code="questionByquestion.notattempted"></spring:message></span>
				</legend>
			</c:if>
		</c:forEach>
		<!--end  show marks obtained of each subitem -->		
		
		<b><spring:message code="questionByquestion.question"></spring:message>	${lineCnt} : </b>
		<p class="question-wrap">${subitemObj.itemText}</p>
		
		<c:if test="${subitemObj.itemImage!=null && fn:length(subitemObj.itemImage)!=0}">
			<br />
			<img src="../exam/displayImage?disImg=${subitemObj.itemImage}" class="resize" />
			<br />
		</c:if>
		
		<b><br/> <spring:message code="questionByquestion.option"></spring:message></b>
		
		<table class="table table-bordered">
			<tr>
				<th style="width: 40px;"><spring:message code="questionByquestion.sr.no"></spring:message></th>
				<th><spring:message code="questionByquestion.optiontext"></spring:message>		</th>
				<th style="width: 150px; float: rigth;"><spring:message	code="questionByquestion.candidateselection"></spring:message></th>
			<tr>
				<c:forEach var="suboptionObj" items="${subitemObj.optionList}" 	varStatus="i">

					<c:choose>
						<c:when test="${suboptionObj.optionLanguage.option.isCorrect==true}">
							<tr>
								<td>${i.count}&nbsp;<img src="${resourcespath}images/tick.png"></td>
								<td>
									<p class="question-wrap">${suboptionObj.optionText}</p> 
									 <c:if test="${fn:length(suboptionObj.optionImage)!=0}">
										<br />
										<img src="../exam/displayImage?disImg=${suboptionObj.optionImage}" />
									</c:if> 
								</td>
								<td><c:if test="${fn:length(examViewModel.candidateAnswerList)!=0 && examViewModel.candidateAnswerList!=null}">
										<c:forEach var="candidateAnsObj" items="${examViewModel.candidateAnswerList}">
											<c:if test="${candidateAnsObj.fkItemID==subitemObj.itemLanguage.fkItemID && candidateAnsObj.optionID==suboptionObj.optionLanguage.fkOptionID}">
												<c:choose>
													<c:when test="${candidateAnsObj.isCorrect==true}">
														<center>
															<i class="icon-user"></i>&nbsp; <img src="${resourcespath}images/tick.png">
														</center>
													</c:when>
													<c:otherwise>
														<center>
															<i class="icon-user"></i>&nbsp; <img src="${resourcespath}images/wrong.png">
														</center>
													</c:otherwise>
												</c:choose>
											</c:if>
										</c:forEach>
									</c:if>
								</td>
							</tr>
						</c:when>
						<c:otherwise>
							<tr>
								<td>${i.count}&nbsp;</td>
								<td>
									<p class="question-wrap">${suboptionObj.optionText} </p> 
									 <c:if test="${fn:length(suboptionObj.optionImage)!=0}">
										<br />
										<img src="../exam/displayImage?disImg=${suboptionObj.optionImage}" />
									</c:if> 
								</td>
								 <td>
									<c:if test="${fn:length(examViewModel.candidateAnswerList)!=0 && examViewModel.candidateAnswerList!=null}">
										<c:forEach var="candidateAnsObj" items="${examViewModel.candidateAnswerList}">
											<c:if test="${candidateAnsObj.fkItemID==subitemObj.itemLanguage.fkItemID && candidateAnsObj.optionID==suboptionObj.optionLanguage.fkOptionID}">
												<c:choose>
													<c:when test="${candidateAnsObj.isCorrect==true}">
														<center>
															<i class="icon-user"></i>&nbsp; <img src="${resourcespath}images/tick.png">
														</center>
													</c:when>
													<c:otherwise>
														<center>
															<i class="icon-user"></i>&nbsp; <img src="${resourcespath}images/wrong.png">
														</center>
													</c:otherwise>
												</c:choose>
											</c:if>
										</c:forEach>
									</c:if>
								</td> 
							</tr>
						</c:otherwise>
					</c:choose>
				</c:forEach>
		</table>
		
		
			<!-- Answer Explanation -->
		<c:set var="Occured" value="0" />
		<c:forEach var="suboptionObj" items="${subitemObj.optionList}" varStatus="i">

			<c:if test="${Occured!=1 && ((suboptionObj.optionLanguage.justification !=null && fn:length(suboptionObj.optionLanguage.justification)!=0)|| (suboptionObj.optionLanguage.justificationImage!=null && fn:length(suboptionObj.optionLanguage.justificationImage)!=0))}">
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
					<c:if test="${suboptionObj.optionLanguage.justificationImage!=null && fn:length(suboptionObj.optionLanguage.justificationImage)!=0}">
						<img src="../exam/displayImage?disImg=${suboptionObj.optionLanguage.justificationImage}" />
						<br />
					</c:if>
				</c:if>
			</c:if>


			<c:if test="${fn:length(examViewModel.candidateAnswerList)!=0 && examViewModel.candidateAnswerList!=null}">
				<c:forEach var="candidateAnsObj" items="${examViewModel.candidateAnswerList}">
					<c:if test="${candidateAnsObj.fkItemID==subitemObj.itemLanguage.item.itemID && candidateAnsObj.optionID==suboptionObj.optionLanguage.fkOptionID && candidateAnsObj.isCorrect==false}">

						<c:if test="${(suboptionObj.optionLanguage.justification !=null && fn:length(suboptionObj.optionLanguage.justification)!=0)    || (suboptionObj.optionLanguage.justificationImage!=null && fn:length(suboptionObj.optionLanguage.justificationImage)!=0)}">
							<b> <spring:message code="questionByquestion.option"></spring:message>
								${i.count}
							</b>
							<br />
							<p class="question-wrap">${suboptionObj.optionLanguage.justification}</p>
							<c:if test="${suboptionObj.optionLanguage.justificationImage!=null && fn:length(suboptionObj.optionLanguage.justificationImage)!=0}">

								<img src="../exam/displayImage?disImg=${suboptionObj.optionLanguage.justificationImage}" /> <br />
							</c:if>
						</c:if>
						<!-- check whetherjustification image or text is exist or not -->
					</c:if>
				</c:forEach>
			</c:if>

		</c:forEach>