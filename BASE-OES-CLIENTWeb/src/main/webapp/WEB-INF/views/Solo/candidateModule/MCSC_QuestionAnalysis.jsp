<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page errorPage="../common/jsperror.jsp"%>

		<c:set var="mcsclist"
								value="${examViewModel.multipleChoiceSingleCorrects}" />
							<c:forEach var="mcsc" items="${mcsclist}">
								<b> <spring:message code="questionByquestion.question"></spring:message>
									${itemNo}:&nbsp;
								</b><p class="question-wrap">${mcsc.itemText }</p>
								<c:if test="${fn:length(mcsc.itemImage)!=0}">
										<img src="../exam/displayImage?disImg=${mcsc.itemImage}" class="resize" />		<br />							
								</c:if>
								
								<br />
								<b> <spring:message code="questionByquestion.option"></spring:message></b>
								<table class="table table-bordered" style="background-color: white">
									<tr>
										<th style="width: 40px;"><spring:message
												code="questionByquestion.sr.no"></spring:message></th>
										<th>
												<spring:message code="questionByquestion.optiontext"></spring:message>
											</th>
										<th style="width: 150px; float: rigth;"><spring:message
												code="questionByquestion.candidateselection"></spring:message></th>

									</tr>
									<c:forEach var="option" items="${mcsc.optionList }"
										varStatus="i">
									<c:choose>
									<c:when test="${option.optionLanguage.option.isCorrect==true}">
                                    <tr>
										<td>${i.count}&nbsp;<img src="${resourcespath}images/tick.png"></td>
										<td >
										<p class="question-wrap">${option.optionText }</p>
										<c:if test="${fn:length(option.optionImage)!=0}">
										<br />
								  <img src="../exam/displayImage?disImg=${option.optionImage}" />
										</c:if>
										</td>
										<td>
									<c:if test="${fn:length(userAnswerMap)!=0 && userAnswerMap!=null}">	
									<c:forEach var="useranswer" items="${userAnswerMap}">
									<c:if test="${useranswer.key==option.optionLanguage.fkOptionID}">
									<c:choose>
									<c:when test="${useranswer.value==true}">
										<center>
									<i class="icon-user"></i>&nbsp;
									<img src="${resourcespath}images/tick.png">
										</center>
									
									</c:when>
									<c:otherwise>
									<center>
									<i class="icon-user"></i>&nbsp;
									<img src="${resourcespath}images/wrong.png">
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
										<p class="question-wrap">${option.optionText }</p>
										<c:if test="${fn:length(option.optionImage)!=0}">
										<br />

								  <img src="../exam/displayImage?disImg=${option.optionImage}" />
										</c:if>
										</td>
										<td><c:if test="${fn:length(userAnswerMap)!=0 && userAnswerMap!=null}">
									<c:forEach var="useranswer" items="${userAnswerMap}">									
									<c:if test="${useranswer.key==option.optionLanguage.fkOptionID}">
									<c:choose>
									<c:when test="${useranswer.value==true }">
										<center>
									<i class="icon-user"></i>&nbsp;
									<img src="${resourcespath}images/tick.png">
										</center>
									
									</c:when>
									<c:otherwise>
									<center>
									<i class="icon-user"></i>&nbsp;
									<img src="${resourcespath}images/wrong.png">
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
							</c:forEach>
						<!-- end View Model MCSC -->
					
										
						<c:set var="Occured" value="0"/>	
						<c:forEach var="mcsc" items="${mcsclist}">
							<c:forEach var="optionsinglecorrect" items="${mcsc.optionList }" varStatus="i">                                  
								
								<c:if test="${Occured!=1 && ((optionsinglecorrect.optionLanguage.justification !=null && fn:length(optionsinglecorrect.optionLanguage.justification)!=0) || (optionsinglecorrect.optionLanguage.justificationImage!=null && fn:length(optionsinglecorrect.optionLanguage.justificationImage)!=0))}">	
									<c:set var="Occured" value="1"/>
									<p>
							       <b><spring:message
								 	code="questionByquestion.answerexplanation"></spring:message></b>
						           </p>	
									</c:if>						
								
								<c:if
									test="${optionsinglecorrect.optionLanguage.option.isCorrect==true}">
									
									<c:if test="${(optionsinglecorrect.optionLanguage.justification !=null && fn:length(optionsinglecorrect.optionLanguage.justification)!=0)
									|| (optionsinglecorrect.optionLanguage.justificationImage!=null && fn:length(optionsinglecorrect.optionLanguage.justificationImage)!=0)}">
									 									
									<b> <spring:message code="questionByquestion.option"></spring:message> ${i.count} </b>
									<br/>
									<p class="question-wrap">${optionsinglecorrect.optionLanguage.justification}</p>
									<c:if
										test="${optionsinglecorrect.optionLanguage.justificationImage!=null  && fn:length(optionsinglecorrect.optionLanguage.justificationImage)!=0}">																											

										<img src="../exam/displayImage?disImg=${optionsinglecorrect.optionLanguage.justificationImage}" />

										<br />
									</c:if>
									</c:if>
								</c:if>
								<c:if test="${itemstatus==0 || itemstatus==10}">
									<c:if test="${fn:length(userAnswerMap)!=0 && userAnswerMap!=null}">
										  <c:forEach var="useranswer" items="${userAnswerMap}">
											<c:if test="${useranswer.key== optionsinglecorrect.optionLanguage.fkOptionID && useranswer.value==false }">
											
											<c:if test="${(optionsinglecorrect.optionLanguage.justification !=null && fn:length(optionsinglecorrect.optionLanguage.justification)!=0)
									    || (optionsinglecorrect.optionLanguage.justificationImage!=null && fn:length(optionsinglecorrect.optionLanguage.justificationImage)!=0)}">
												<b> <spring:message code="questionByquestion.option"></spring:message> ${i.count}</b>
												<br />
												<p class="question-wrap">${optionsinglecorrect.optionLanguage.justification}</p>
												<c:if test="${optionsinglecorrect.optionLanguage.justificationImage!=null && fn:length(optionsinglecorrect.optionLanguage.justificationImage)!=0}">

													<img src="../exam/displayImage?disImg=${optionsinglecorrect.optionLanguage.justificationImage}" />

													<br />
												</c:if>	
										    </c:if><!-- check whetherjustification image or text is exist or not -->																						
										       </c:if>
										  </c:forEach> 
									  </c:if>
								  </c:if>
							</c:forEach>
						</c:forEach>					