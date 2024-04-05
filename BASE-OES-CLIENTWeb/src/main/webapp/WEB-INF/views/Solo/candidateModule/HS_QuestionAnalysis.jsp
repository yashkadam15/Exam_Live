<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page errorPage="../common/jsperror.jsp"%>

		<c:set var="hotspotList"
								value="${examViewModel.hotSpotList}" />
							<c:forEach var="hs" items="${hotspotList}">
								<b> <spring:message code="questionByquestion.question"></spring:message>
									${itemNo}:&nbsp;
								</b><p class="question-wrap">${hs.itemText }</p>
								<c:if test="${fn:length(hs.itemImage)!=0}">
										<img id="${hs.fkItemLanguageID }" src="../exam/displayImage?disImg=${hs.itemImage}" style="max-width: 800px; max-height: 600px;" usemap="#${hs.itemImage}" /><!-- </a> -->
										<map name="${hs.itemImage}">
											<c:forEach var="options" items="${hs.optionList}" varStatus="i">
												<area shape="rect" href="#" state="XX" coords="${options.coordinates}" alt="area${i.index}">
											</c:forEach>
										</map>						
								</c:if>
								<br />
								<c:forEach var="candAnswer" items="${examViewModel.candidateAnswerList}">
									<div class="areaDivs${hs.fkItemLanguageID }">
										<input type="hidden" value="${candAnswer.candidateTopLeftCoordinate }" id="x1_${hs.fkItemLanguageID }"/>
										<input type="hidden" value="${candAnswer.candidateTopRightCoordinate}" id="y1_${hs.fkItemLanguageID }"/>
										<input type="hidden" value="${candAnswer.candidateBottomLeftCoordinate}" id="x2_${hs.fkItemLanguageID }"/>
										<input type="hidden" value="${candAnswer.candidateBottomRightCoordinate}" id="y2_${hs.fkItemLanguageID }"/>
									</div>
								</c:forEach>
							</c:forEach>
						<!-- end View Model MCSC -->
						
										
						<c:set var="Occured" value="0"/>	
						<c:forEach var="hs" items="${hotspotList}">
							<c:forEach var="optionHotSpot" items="${hs.optionList }" varStatus="i">                                  
								
								<c:if test="${Occured!=1 && ((optionHotSpot.optionLanguage.justification !=null && fn:length(optionHotSpot.optionLanguage.justification)!=0) || (optionHotSpot.optionLanguage.justificationImage!=null && fn:length(optionHotSpot.optionLanguage.justificationImage)!=0))}">	
									<c:set var="Occured" value="1"/>
									<p>
							       <b><spring:message
								 	code="questionByquestion.answerexplanation"></spring:message></b>
						           </p>	
									</c:if>						
								
								<c:if
									test="${optionHotSpot.optionLanguage.option.isCorrect==true}">
									
									<c:if test="${(optionHotSpot.optionLanguage.justification !=null && fn:length(optionHotSpot.optionLanguage.justification)!=0)
									|| (optionHotSpot.optionLanguage.justificationImage!=null && fn:length(optionHotSpot.optionLanguage.justificationImage)!=0)}">
									 									
									<b> <spring:message code="questionByquestion.option"></spring:message> ${i.count} </b>
									<br/>
									<p class="question-wrap">${optionHotSpot.optionLanguage.justification}</p>
									<c:if
										test="${optionHotSpot.optionLanguage.justificationImage!=null  && fn:length(optionHotSpot.optionLanguage.justificationImage)!=0}">																											

										<img src="../exam/displayImage?disImg=${optionHotSpot.optionLanguage.justificationImage}" />

										<br />
									</c:if>
									</c:if>
								</c:if>
								<c:if test="${itemstatus==0 || itemstatus==10}">
									<c:if test="${fn:length(userAnswerMap)!=0 && userAnswerMap!=null}">
										  <c:forEach var="useranswer" items="${userAnswerMap}">
											<c:if test="${useranswer.key== optionHotSpot.optionLanguage.fkOptionID && useranswer.value==false }">
											
											<c:if test="${(optionHotSpot.optionLanguage.justification !=null && fn:length(optionHotSpot.optionLanguage.justification)!=0)
									    || (optionHotSpot.optionLanguage.justificationImage!=null && fn:length(optionHotSpot.optionLanguage.justificationImage)!=0)}">
												<b> <spring:message code="questionByquestion.option"></spring:message> ${i.count}</b>
												<br />
												<p class="question-wrap">${optionHotSpot.optionLanguage.justification}</p>
												<c:if test="${optionHotSpot.optionLanguage.justificationImage!=null && fn:length(optionHotSpot.optionLanguage.justificationImage)!=0}">

													<img src="../exam/displayImage?disImg=${optionHotSpot.optionLanguage.justificationImage}" />

													<br />
												</c:if>	
										    </c:if><!-- check whetherjustification image or text is exist or not -->																						
										       </c:if>
										  </c:forEach> 
									  </c:if>
								  </c:if>
							</c:forEach>
						</c:forEach>


										