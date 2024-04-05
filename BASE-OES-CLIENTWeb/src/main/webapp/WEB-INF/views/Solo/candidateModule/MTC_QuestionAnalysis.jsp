<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page errorPage="../common/jsperror.jsp"%>
<script src="<c:url value='/resources/js/jquery-1.12.0.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/bootstrap.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/selectFix.js'></c:url>"></script>
		<%-- <c:set var="mcsclist"
								value="${examViewModel.multipleChoiceSingleCorrects}" /> --%>
							<c:forEach var="mtc" items="${examViewModel.matchTheColumnList}" varStatus="i">
							<input type="hidden" id="lengthColumnList" value="${examViewModel.matchTheColumnList}"/>
								<b> <spring:message code="questionByquestion.question"></spring:message>
									${itemNo}:&nbsp;
								</b><p class="question-wrap">${mtc.itemText }</p>
								<c:if test="${fn:length(mtc.itemImage)!=0}">
										<img src="../exam/displayImage?disImg=${mtc.itemImage}" class="resize" />							
								</c:if>
								
								
								<!-- Show MTC Matrix -->
								<%-- <c:set var="cellData" value="${mtc.cellData}" />
								 <div class="refMatrixDiv" >
                 				</div> --%>
                 				<div id="refMatrixDiv_${mtc.fkItemLanguageID}"></div> 
                 				<label id="cellData_${mtc.fkItemLanguageID}" style="display: none;">${mtc.cellData}</label>
                 				<input type="hidden" id="sequencingType_${mtc.fkItemLanguageID}" name="sequencingType" value="${mtc.sequencingType}"/>
              
                 				<b><spring:message code="questionAnalysis.correctAnswer"></spring:message></b>
                 				
                 				<table class="table table-bordered" style="background-color: white">
                 				<tbody>
                 					<tr>
										<th style="width: 40px;"><spring:message
												code="questionByquestion.sr.no"></spring:message></th>
										<th>
												<spring:message code="questionAnalysis.answer"></spring:message>
										</th>
									</tr>
									
                 					<c:forTokens items="${mtc.correctAnswer }" delims="|||" var="ans" varStatus="j">
                 					<%-- <input type="hidden" id="correctAnswer_${i.index}" value="${mtc.correctAnswer }" />
                 					<input type="hidden" id="candidateAnswer_${i.index}" value="${examViewModel.candidateAnswer.typedText}" /> --%>
                 						<tr>
                 						
                 						<td>${j.count}</td>
                 						<td>
                 						<div>
	                 				<span>
	                 				  <c:choose>
	                 					<c:when test="${mtc.sequencingType=='IMAGE'}">
	                 					<%-- <c:forTokens items="${{mtc.correctAnswer}" delims="|||" var="answerset"> --%>
												<c:forTokens items="${ans}" delims=" ," var="ansImg">
													
															<img src="../exam/displayImage?disImg=${ansImg}" class="resize" style="max-width:150px; max-height:150px;">
													&nbsp;&nbsp;
												
												</c:forTokens>
										<%-- </c:forTokens> --%>
													<br/>
												<%-- </c:forEach> --%>
	                 					</c:when>
	                 						
	                 					<c:otherwise>
	                 						<c:out value="${ans}"/>
	                 					</c:otherwise>
	                 				</c:choose> 
	                 				
	                 				</span>
	                 				</div>
                 						</td>
									   </tr>
									</c:forTokens>
									</tbody>
                 				</table>
                 				
                 				<c:if test="${itemstatus==1 || itemstatus==11 || itemstatus==0 || itemstatus==10}">
                 					<b><spring:message code="questionAnalysis.candidateAnswer"></spring:message></b><br />
	                 				<c:if test="${itemstatus==1 || itemstatus==11}">
	                 					<img src="${resourcespath}images/tick.png">&nbsp;
	                 				</c:if>
	                 				<c:if test="${itemstatus==0 || itemstatus==10}">
	                 					<img src="${resourcespath}images/wrong.png">&nbsp;
	                 				</c:if>	
	                 				<div>
	                 				<span>
	                 				
	                 				 <c:choose>
	                 					<c:when test="${mtc.sequencingType=='IMAGE'}">   
	                 						<%-- <c:forTokens items="${examViewModel.candidateAnswer.typedText}" delims="|||" var="answerset"> --%>
	                 							<c:forTokens items="${examViewModel.candidateAnswer.typedText}" delims=" ," var="candAnsSQImg">
	                 								<img src="../exam/displayImage?disImg=${candAnsSQImg}" class="resize" style="max-width:150px; max-height:150px;">
						   							&nbsp;&nbsp;
												</c:forTokens>
												<br>
										<%-- 	</c:forTokens> --%>
												
                 					
	                 					</c:when>
	                 					<c:otherwise>
	                 						${examViewModel.candidateAnswer.typedText}
	                 					</c:otherwise>
	                 				</c:choose> 
	                 				
	                 				</span>
	                 				</div>
                 				</c:if>
                 			
							</c:forEach>
						<!-- end View Model MCSC -->
							<br />
									
						<c:set var="Occured" value="0"/>	
								

		
		


		