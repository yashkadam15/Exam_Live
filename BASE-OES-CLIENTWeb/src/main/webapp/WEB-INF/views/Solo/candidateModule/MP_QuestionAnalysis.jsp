<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page errorPage="../common/jsperror.jsp"%>

   <!-- Matching Pairs -->
				
				<c:if test="${examViewModel.matchingPairs!=null}">
							<br>
								 <b> <spring:message code="questionByquestion.mainQuestion"></spring:message>
									${itemNo}:&nbsp;
								</b><p class="question-wrap">${examViewModel.matchingPairs.itemText }</p><br/>
								
							<c:if test="${examViewModel.matchingPairs.itemImage!=null && fn:length(examViewModel.matchingPairs.itemImage)!=0}">						
								 <img src="../exam/displayImage?disImg=${examViewModel.matchingPairs.itemImage}" class="resize" />		<br/>						
								 </c:if>
								 
							 <b> <spring:message code="questionByquestion.option"></spring:message></b> 
								<table class="table table-bordered">
								<tr>
								<th style="width: 5%;"><spring:message
												code="questionByquestion.sr.no"></spring:message></th>
										<th> <spring:message code="questionByquestion.subItemText"></spring:message>									
										</th>		
										<th>
										<spring:message code="questionByquestion.optiontext"></spring:message>
										</th>									
										<th><spring:message code="questionByquestion.candidateanswer"/></th>	
										<th style="width: 22%;">
										<spring:message	code="questionByquestion.candidateselection"></spring:message>
										&nbsp;<i class="icon-user"></i>
										</th>	
										<th style="width: 15%;">Marks Obtained</th>																			
								</tr>								
								<c:forEach var="subitemObj" items="${examViewModel.matchingPairs.subItemList}" varStatus="i1">
								
							     <tr>
							     <td>${i1.count}</td>
							     <td><p class="question-wrap">${subitemObj.subItemText}</p>
							     <c:if test="${subitemObj.subItemImage!=null && fn:length(subitemObj.subItemImage)!=0}">						
								 <img src="../exam/displayImage?disImg=${subitemObj.subItemImage}" class="resize" />								
								 </c:if>
							     </td>
							     <td>
							    <p class="question-wrap"> ${subitemObj.optionList.get(0).subOptionText}</p>
							     <c:if test="${subitemObj.optionList.get(0).subOptionImage!=null && fn:length(subitemObj.optionList.get(0).subOptionImage)!=0}">						
								 <img src="../exam/displayImage?disImg=${subitemObj.optionList.get(0).subOptionImage}" class="resize" />								
								 </c:if>
							     </td>
							   <td>
							     <c:if test="${fn:length(examViewModel.candidateAnswerList)!=0 && examViewModel.candidateAnswerList!=null}">	
									<c:forEach var="candidateAnsObj" items="${examViewModel.candidateAnswerList}">		
								<c:forEach var="subitemObjForanswer" items="${examViewModel.matchingPairs.subItemList}" >							
								 <c:if test="${candidateAnsObj.fkItemID==subitemObj.itemLanguage.item.itemID && candidateAnsObj.optionID==subitemObjForanswer.optionList.get(0).optionLanguage.fkOptionID}">
								 	<p class="question-wrap">${subitemObjForanswer.optionList.get(0).subOptionText}</p> 
								 	<c:if test="${subitemObjForanswer.optionList.get(0).subOptionImage!=null && fn:length(subitemObjForanswer.optionList.get(0).subOptionImage)!=0}">						
								 <img src="../exam/displayImage?disImg=${subitemObjForanswer.optionList.get(0).subOptionImage}" class="resize" />								
								 </c:if>
									</c:if>
									</c:forEach>
									</c:forEach>
								 </c:if>
							    </td>
							     <td>
							     <c:if test="${fn:length(examViewModel.candidateAnswerList)!=0 && examViewModel.candidateAnswerList!=null}">	
									<c:forEach var="candidateAnsObj" items="${examViewModel.candidateAnswerList}">	
									<!-- && candidateAnsObj.optionID==subitemObj.optionList.get(0).optionLanguage.fkOptionID				 -->		
									<c:if test="${candidateAnsObj.fkItemID==subitemObj.itemLanguage.item.itemID }">
									
									<c:choose>
									<c:when test="${candidateAnsObj.isCorrect==true}">
										<center>
								 <!--  	<i class="icon-user"></i>&nbsp; -->
									<img src="${resourcespath}images/tick.png">
										</center> 									
									</c:when>
									<c:otherwise>
									<center>
								<!-- 	<i class="icon-user"></i>&nbsp; -->
									<img src="${resourcespath}images/wrong.png">
										</center>
									</c:otherwise>
									</c:choose>		
									</c:if>
									</c:forEach>
								 </c:if>
								</td>
								<td>
				<c:forEach items="${examViewModel.candidateItemAssociationList}" 	var="candidateItemAssociationObj">
			    <c:if 	test="${(candidateItemAssociationObj.itemStatus == 'Answered') && subitemObj.itemLanguage.item.itemID== candidateItemAssociationObj.fkItemID}">
				<c:choose>
					<c:when test="${candidateItemAssociationObj.isCorrect == true}">												
						<center>	<font color="green" >	${candidateItemAssociationObj.marksObtained}</font>	</center>				
					</c:when>
					<c:otherwise>
						<c:choose>
							<c:when test="${candidateItemAssociationObj.isCorrect == false}">
								<center>	<font color="red">	
										${candidateItemAssociationObj.marksObtained}
								   </font></center>
							</c:when>
							<c:otherwise>
								<!-- if mark for reviewed then show not attepted and isCorrect is null-->								
					<%-- <spring:message	code="questionByquestion.notattempted"></spring:message> --%>
											
							</c:otherwise>
						</c:choose>
						</c:otherwise>
							</c:choose>
							</c:if>
							<c:if
									test="${(candidateItemAssociationObj.itemStatus == 'NotAnswered' ||  candidateItemAssociationObj.itemStatus== 'NoStatus') &&  subitemObj.itemLanguage.item.itemID== candidateItemAssociationObj.fkItemID}">
									<%-- <legend style="color: grey;">
										<span><spring:message code="questionByquestion.notattempted"></spring:message></span>
									</legend> --%>
								</c:if>
							</c:forEach>
								</td>
							     </tr>
								</c:forEach>
								</table>								 
                            
                            <!-- Answer Explanation -->   
                             <c:set var="Occured" value="0"/>	
                           <c:forEach var="subitemObj" items="${examViewModel.matchingPairs.subItemList}" varStatus="subitem">  									     
							<c:forEach var="suboptionObj" items="${subitemObj.optionList}" varStatus="i">                     
								
								 <c:if test="${Occured!=1 && ((suboptionObj.optionLanguage.justification !=null && fn:length(suboptionObj.optionLanguage.justification)!=0)|| (suboptionObj.optionLanguage.justificationImage!=null && fn:length(suboptionObj.optionLanguage.justificationImage)!=0))}">	
									<c:set var="Occured" value="1"/>
									<p>
							       <b><spring:message
								 	code="questionByquestion.answerexplanation"></spring:message></b>
						           </p>							           
								 </c:if>								 				
								  
								<%-- <c:if test="${suboptionObj.optionLanguage.option.isCorrect==true}"> --%>
									
									<c:if test="${(suboptionObj.optionLanguage.justification !=null && fn:length(suboptionObj.optionLanguage.justification)!=0)
									|| (suboptionObj.optionLanguage.justificationImage!=null && fn:length(suboptionObj.optionLanguage.justificationImage)!=0)}">
																		
									<b> <spring:message code="questionByquestion.option"></spring:message> ${subitem.count} </b>
									<br/>
									<p class="question-wrap">${suboptionObj.optionLanguage.justification}</p>
									<c:if
										test="${suboptionObj.optionLanguage.justificationImage!=null && fn:length(suboptionObj.optionLanguage.justificationImage)!=0}">									

										<img src="../exam/displayImage?disImg=${suboptionObj.optionLanguage.justificationImage}" />

										<br />
									</c:if>
									</c:if>
								<%-- </c:if> --%>							 	
								
									<%--  <c:if test="${fn:length(examViewModel.candidateAnswerList)!=0 && examViewModel.candidateAnswerList!=null}">
										  <c:forEach var="candidateAnsObj" items="${examViewModel.candidateAnswerList}">
											<c:if test="${candidateAnsObj.fkItemID==subitemObj.itemLanguage.item.itemID  && candidateAnsObj.optionID==suboptionObj.optionLanguage.fkOptionID && candidateAnsObj.isCorrect==false}">
											
											<c:if test="${(suboptionObj.optionLanguage.justification !=null && fn:length(suboptionObj.optionLanguage.justification)!=0)
									    || (suboptionObj.optionLanguage.justificationImage!=null && fn:length(suboptionObj.optionLanguage.justificationImage)!=0)}">
												<b> <spring:message code="questionByquestion.option"></spring:message> ${i.count}</b>
												<br />
												<p class="question-wrap">${suboptionObj.optionLanguage.justification}</p>
												<c:if test="${suboptionObj.optionLanguage.justificationImage!=null && fn:length(suboptionObj.optionLanguage.justificationImage)!=0}">

												  <img src="../exam/displayImage?disImg=${suboptionObj.optionLanguage.justificationImage}" />
													<br />
												</c:if>	
										    </c:if><!-- check whetherjustification image or text is exist or not -->																						
										       </c:if>
										  </c:forEach> 
									  </c:if> --%>
								  
							</c:forEach>
							</c:forEach>
								
					</c:if><!-- End of matching pairs -->