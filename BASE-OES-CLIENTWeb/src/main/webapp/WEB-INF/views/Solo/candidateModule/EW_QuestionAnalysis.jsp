<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page errorPage="../common/jsperror.jsp"%>

							<c:forEach var="EW" items="${examViewModel.essayWritingList}">
								<b> <spring:message code="questionByquestion.question"></spring:message>
									${itemNo}:&nbsp;
								</b><p class="question-wrap">${EW.itemText }</p>
								<c:if test="${fn:length(EW.itemImage)!=0}">
										<img src="../exam/displayImage?disImg=${EW.itemImage}" class="resize" />							
								</c:if>
								<%-- <p class="question-wrap">
                 				<b>Correct Answer(s):</b></p>
                 				<table class="table table-bordered" style="background-color: white">
                 					<tr>
										<th style="width: 40px;"><spring:message
												code="questionByquestion.sr.no"></spring:message></th>
										<th>
												Answer
										</th>
									</tr>
                 					<c:forTokens items="${EW.correctAnswer }" delims="|||" var="ans" varStatus="i">
                 						<tr>
                 						<td>${i.count}</td>
                 						<td><c:out value="${ans}"/></td>
									   </tr>
									</c:forTokens>
                 				</table> --%>
                 				
                 				<c:if test="${itemstatus==9}">
                 					<b><spring:message code="questionAnalysis.candidateAnswer"></spring:message></b><br />
	                 				<%-- <c:if test="${itemstatus==1 || itemstatus==11}">
	                 					<img src="${resourcespath}images/tick.png">&nbsp;
	                 				</c:if>
	                 				<c:if test="${itemstatus==0 || itemstatus==10}">
	                 					<img src="${resourcespath}images/wrong.png">&nbsp;
	                 				</c:if> --%>
	                 				${examViewModel.candidateAnswer.typedText }
                 				</c:if>
                 				
							</c:forEach>
						<!-- end View Model MCSC -->
							<br />
