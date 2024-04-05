<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<title><spring:message code="homepage.PageTitle" /></title>
<%-- <link rel="stylesheet" href="<c:url value='/resources/style/template_darkmode.css'></c:url>" type="text/css" /> --%>
<spring:message code="project.resources" var="resourcespath" />
<style type="text/css">


a {
	cursor: pointer;
}

tab_text {
	text-transform: uppercase;
	font-weight: normal;
	font-family: Lucida Sans Unicode Lucida Grande sans-serif;
	text-shadow: 1px 1px 0 #ffffff;
	font-size: 1.071em;
}

.label-attempt {
	background-color: #fff;
	padding: 1px 2px;
	color: #666;
	border: solid 1px;
	border-color: #666;
	text-shadow: 0 0px 0 rgba(0, 0, 0, 0);
	font-weight: normal;
}

/* .dark-mode .label-attempt {
	background-color: #000;
	padding: 1px 2px;
	color: #fff;
	border: solid 1px;
	border-color: #333;
	text-shadow: 0 0px 0 rgba(0, 0, 0, 0);
	font-weight: normal;
}
.dark-mode .panel {
     background-color: #707070f0;
    border: 1px solid #333;
    border-radius: 10px;
    border-color: #333;
 }
 .dark-mode .panel-primary .panel-heading {
	color: white;
    background-color: #505050;
    border-color: #333;
}

 */
</style>
<style type="text/css">


.table {
margin-bottom: 12px;
}
.panel {
padding-bottom:0.6px;
padding-top:5px;
padding-left:10px;
padding-right:10px;
margin-bottom: 20px;
background-color: none;
border: 1px solid #c09300;
border-radius: 10px;
/* border-color: #c09300; */
-webkit-box-shadow: 0 1px 1px rgba(0, 0, 0, 0.05);
box-shadow: 0 1px 1px rgba(0, 0, 0, 0.05);
}
.panel-title {
margin-top: 0;
margin-bottom: 0;
font-size: 17.5px;
font-weight: 500;
}
/* .panel-primary .panel-heading {
color: white;
background-color:#c09300;
border-color: #916921;
} */
.panel-heading {
padding: 10px 15px;
margin: -15px -11px 15px;
background-color: whiteSmoke;
border-bottom: 1px solid #DDD;
border-top-right-radius: 12px;
border-top-left-radius: 12px;
}

.dashboardform{
	display: inline-block;
	margin:0px;
}

</style>
</head>
<body>


	<c:set value="dd-MMM-yyyy" var="dateFormatForAllPapers" />
	<fieldset class="well">
     
     	<legend>
			<span><img src="<c:url value="../resources/images/dashboard.png"></c:url>" alt=""> <spring:message code="homepage.MyHome" />
		</legend> 


		<div class="holder candidate-dashboard">
		<div class="panel-color-border panel-primary">
        <div class="panel-heading">
          <h4 class="panel-title" style="text-align: center">
          <spring:message code="homepage.CandidateInformation" /></h4>
         
          </div>
        
         <!--  <button onclick="myFunction()">Toggle dark mode</button> -->
          <table class="table table-bordered table-complex">
						
						<tbody>
						<tr>
						<td rowspan="2" width="" style="text-align:center;vertical-align: middle;">
						<c:choose>
							<c:when test="${sessionScope.user.venueUser[0]!= null && fn:length(sessionScope.user.venueUser[0].userPhoto) > 0 && fn:startsWith(sessionScope.user.venueUser[0].userPhoto, 'http')}">
					 			<img style="max-height: 150px;max-width:150px;" src="${sessionScope.user.venueUser[0].userPhoto}">
							</c:when>
							<c:when test="${sessionScope.user.venueUser[0]!= null && fn:length(sessionScope.user.venueUser[0].userPhoto) > 0}">
					 			<img style="max-height: 150px;max-width:150px;" src="${imgPath}${sessionScope.user.venueUser[0].userPhoto}">
							</c:when>
							<c:otherwise>
							 	<img style="max-height: 150px;max-width:150px;" src="${imgPath}<spring:message code="instruction.defaultPhoto"/>">
							</c:otherwise>
						</c:choose>
						</td>
						<td class="highlight" style="color: #297DBC"><b><font
										size="2"><spring:message code="incompleteexams.CandidateName" /></font> </b></td>
						<td width="" style="word-wrap: break-word;"><font size="2">${sessionScope.user.venueUser[0].firstName}&nbsp;${sessionScope.user.venueUser[0].middleName}&nbsp;${sessionScope.user.venueUser[0].lastName}</font></td>
						<td class="highlight"  style="color: #297DBC"><b><font size="2"><spring:message code="incompleteexams.CandidateCode" /></font></b></td>
						<td width=""><font size="2">${sessionScope.user.venueUser[0].mkclIdentificationNumber}</font></td>
						</tr>
						<tr>
						<!-- <td></td> -->
						<td class="highlight"  style="color: #297DBC"><b><font size="2"><spring:message code="QuestionUsageReport.selectVenueHeader" /></font> </b></td>
						<td ><font size="2">${examcenter.examVenueName} (${examcenter.examVenueCode})	</font></td>
						<td class="highlight" style="color: #297DBC"><b><font size="2"><spring:message code="incompleteexams.Username" /></font></b></td>
						<td ><font size="2">${sessionScope.user.venueUser[0].userName}</font></td>
						</tr>
						</tbody>
					</table>
          
          
          </div>
					

			<div id="tabbable">
				<ul class="nav nav-tabs" id="myTab">
					<li class="active"><a href="#" data-toggle="tab" class="tab_text" style="text-transform: uppercase; font-weight: normal; text-shadow: 1px 1px 0 #ffffff;"><spring:message code="homepage.activetests" /></a></li>
				</ul>
			</div>
			<div id="showScheduledPapers">
				<c:choose>
					<c:when test="${fn:length(activePapers) != 0}">
						<div class="box">
							<!-- <div class="box-header">
								<h4>
									
								</h4>
								<br> <br>
							</div> -->
							<div class="box-body">
								<table class="table table-bordered table-complex" style="border-top: 0;">

									<!-- get exam event map -->
									<%-- <c:forEach var="examMap" items="${examEventMap}"> --%>
									<thead>
										<tr>
											<th colspan="3" class="text-left">${currentExamEvent.name}</th>
										</tr>
									</thead>
									<tbody>
										<!-- relate exam-display Category -->
										<c:forEach var="displayCategoryName" items="${displayCategoryMap}" varStatus="status">
											<%-- 	<c:if test="${displayCategoryID==displayCategoryName.key }"> --%>
											<tr>
												<td class="highlight span3 disremo">${displayCategoryName.value}</td>
												<c:choose>
													<c:when test="${status.first}">
														<td class="highlight text-center span1 disremo">&nbsp;&nbsp;&nbsp;<spring:message code="homepage.exiresOn" />&nbsp;&nbsp;&nbsp;
														</td>
													</c:when>
													<c:otherwise>
														<td class="highlight span1 "></td>
													</c:otherwise>
												</c:choose>

											</tr>

											<c:forEach var="paper" items="${activePapers}">

												<c:choose>
											 		<c:when test="${paper.supervisorPwdStartExam == true}"> <c:set var="formAction" value="../exam/AuthenticationGet" /></c:when>
											 		<c:otherwise><c:set var="formAction" value="../exam/instruction" /></c:otherwise>
											 	</c:choose>
												
											
												<!-- get paper from corresponding exam And display Category -->
												<c:if test="${paper.examEvent.examEventID==currentExamEvent.examEventID and paper.displayCategoryLanguage.fkDisplayCategoryID==displayCategoryName.key }">
													<tr>
														<td><c:choose>
																<c:when test="${paper.assessmentType=='Solo' and paper.freePaperStatus == 0}">
																	<i class="icon-user "></i>
																</c:when>
																<c:when test="${paper.assessmentType=='Group' and paper.freePaperStatus == 0 }">
																	<i class="icon-def-group"></i>
																</c:when>
																<c:when test="${paper.assessmentType=='Solo' and paper.freePaperStatus == 1}">
																	<i class="icon-user "></i>
																</c:when>
																<c:when test="${paper.freePaperStatus==1}">
																	<i class="icon-user "></i>
																</c:when>


															</c:choose> &nbsp;&nbsp;${paper.paper.name}&nbsp;&nbsp;<!-- show attempt number --> <!-- show paper status : new,not complete or complete --> <c:choose>
																<c:when test="${paper.examEventPaperDetails != null and paper.examEventPaperDetails.noOfAttempts == 2}">
																	<span class="label label-attempt"><spring:message code="homepage.Attempt" /> #${paper.candidateExam.attemptNo}</span>
																</c:when>
															</c:choose> <c:choose>
																<c:when test="${paper.paperStatus == 3 and paper.assessmentType!='Group'}">
																	<span class="label label-important">Exam Withheld</span>
																</c:when>
																<c:when test="${paper.paperStatus==0 and paper.assessmentType!='Group'}">
																	<span class="label label-success"><spring:message code="homepage.new" /></span>
																</c:when>
																<c:when test="${paper.paperStatus!=0 and paper.assessmentType!='Group'}">
																	<span class="label label-important"><spring:message code="homepage.incomplete" /></span>
																</c:when>
																<c:when test="${paper.paperStatus == 0 and paper.assessmentType =='Group' && paper.expiryDate != null}">
																	<span class="label label-success"><spring:message code="viewActivityCalendar.new" /></span>
																</c:when>
																<c:when test="${paper.paperStatus == 2 and paper.assessmentType =='Group' && paper.expiryDate != null}">
																	<span class="label label-important"><spring:message code="homepage.incomplete" /></span>
																</c:when>
																<c:when test="${paper.freePaperStatus==1}">
																	<span class="label label-success"><spring:message code="homepage.new" /></span>
																</c:when>
																
															</c:choose></td>
														<td class="text-center"><c:if test="${paper.expiryDate != null}">
																<div class="testL"><div class="showOnMobile "><spring:message code="homepage.exiresOn" />:</div> <fmt:formatDate pattern="${dateFormatForAllPapers}" value="${paper.expiryDate}" /></div>
																<c:choose>


																<c:when test="${paper.expiryDate != null && (paper.examEventPaperDetails.assessmentType=='Group' or paper.examEventPaperDetails.assessmentType=='Both') && paper.assessmentType=='Group' }">
																	<!--candidate which are not in Group but have group Paper  : disable it -->
																	<a class="btn btn-purple" href="#modalGroup-group" data-toggle="modal" data-backdrop="static"><spring:message code="homepage.GroupTest" /></a>
																</c:when>
																<%-- <c:when test="${paper.expiryDate != null && paper.examEventPaperDetails.assessmentType=='Group' && paper.labSessionGroupID > 0 }">
																	<a class="btn btn-purple" href="#modalGroup-group" data-toggle="modal" data-backdrop="static"> <spring:message code="homepage.GroupTest" /></a>
																</c:when>
																<c:when test="${paper.expiryDate != null && paper.examEventPaperDetails.assessmentType=='Both' && paper.labSessionGroupID > 0 && paper.assessmentType=='Group'}">
																	<a class="btn btn-purple" href="#modalGroup-group" data-toggle="modal" data-backdrop="static"><spring:message code="homepage.GroupTest" /></a>
																</c:when> --%>
																
																<c:when test="${paper.expiryDate != null and paper.freePaperStatus==0}">
																	<c:choose>	
																		<c:when test="${paper.paperStatus == 3 and paper.assessmentType!='Group'}">
																			<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-greener lnkTakeTestbtn" data-lnk="#" disabled="true"><spring:message code="homepage.takeATest" /></a>
																		</c:when>																	
																		<c:when test="${paper.paper.paperType == 'Typing'}">
																				 <a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-greener lnkTakeTestbtn typingTest"  data-lnk="typ:url?ceid=${paper.candidateExam.candidateExamID}&se=${paper.expiryDate.time}&clientid=${clientId}"><spring:message code="homepage.takeATest" /></a>
																		</c:when>
																		<c:when test="${paper.paper.paperType == 'DifficultyLevelWiseExam'}">
																		
																			<form:form class="dashboardform examform testR" action="${formAction}" method="POST">	
																				<input type="hidden" name="ceid" value="${paper.candidateExam.candidateExamID}" />
																		    	<input type="hidden" name="se" value="${paper.expiryDate.time}" />
																				<%-- <button class="btn btn-greener practicalTest " type="submit" id="btnTakeATest"><spring:message code="homepage.takeATest" /></button> --%>
																				<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-greener lnkTakeTestbtn practicalTest" data-lnk="../exam/Authentication?ceid=${paper.candidateExam.candidateExamID}&se=${paper.expiryDate.time}"><spring:message code="homepage.takeATest" /></a>
																			</form:form>
																		</c:when>
																		<c:otherwise>
																			
																			<form:form class="dashboardform examform" action="${formAction}" method="POST">	
																				<input type="hidden" name="ceid" value="${paper.candidateExam.candidateExamID}" />
																		    	<input type="hidden" name="se" value="${paper.expiryDate.time}" />
																		    	<%-- <button class="btn btn-greener" type="submit" id="btnTakeATest"><spring:message code="homepage.takeATest" /></button> --%>
																		    	<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-greener lnkTakeTestbtn" data-lnk="../exam/Authentication?ceid=${paper.candidateExam.candidateExamID}&se=${paper.expiryDate.time}"><spring:message code="homepage.takeATest" /></a>
																			</form:form>
																		</c:otherwise>
																		
																	</c:choose>																	
																</c:when>
																<c:when test="${paper.expiryDate != null and paper.freePaperStatus==1 and paper.assessmentType=='Solo'}">
																	<c:choose>
																		<c:when test="${paper.paperStatus == 3 and paper.assessmentType!='Group'}">
																			<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-greener lnkTakeTestbtn" data-lnk="#" disabled="true"><spring:message code="homepage.takeATest" /></a>
																		</c:when>
																		<c:when test="${paper.paper.paperType == 'Typing'}">
																			<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-greener lnkTakeTestbtn typingTest" data-lnk="typ:url?ceid=${paper.candidateExam.candidateExamID}&se=${paper.expiryDate.time}&clientid=${clientId}"><spring:message code="homepage.takeATest" /></a>
																		</c:when>
																		<c:when test="${paper.paper.paperType == 'DifficultyLevelWiseExam'}">
																		
																			<form:form class="dashboardform examform" action="${formAction}" method="POST">	
																				<input type="hidden" name="ceid" value="${paper.candidateExam.candidateExamID}" />
																		    	<input type="hidden" name="se" value="${paper.expiryDate.time}" />
																		    	<%-- <button class="btn btn-greener  practicalTest" type="submit" id="btnTakeATest"><spring:message code="homepage.takeATest" /></button> --%>
																		    	<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-greener lnkTakeTestbtn practicalTest" 
																				data-lnk="../exam/Authentication?ceid=${paper.candidateExam.candidateExamID}&se=${paper.expiryDate.time}"><spring:message code="homepage.takeATest" /></a>
																			</form:form>																			
																		</c:when>
																		<c:otherwise>
																		
																			<form:form class="dashboardform examform" action="${formAction}" method="POST">		
																				<input type="hidden" name="ceid" value="${paper.candidateExam.candidateExamID}" />
																		    	<input type="hidden" name="se" value="${paper.expiryDate.time}" />
																		    	<%-- <button class="btn btn-greener " type="submit" id="btnTakeATest"><spring:message code="homepage.takeATest" /></button> --%>
																		    	<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-greener lnkTakeTestbtn" 
																				data-lnk="../exam/Authentication?ceid=${paper.candidateExam.candidateExamID}&se=${paper.expiryDate.time}"><spring:message code="homepage.takeATest" /></a>
																			</form:form>
																		</c:otherwise>
																	</c:choose>																	
																</c:when>
																<c:when test="${paper.candidateExam != null && paper.freePaperStatus==1}">
																	<!-- b=0 :dcid is present hence update  
																		 b=1 :dcid is not present hence insert -->
																	<c:choose>
																		<c:when test="${displayCategoryWiseAttemptsMap[paper.displayCategoryLanguage.fkDisplayCategoryID] > 0}">
																			<c:choose>
																				<c:when test="${paper.paperStatus == 3 and paper.assessmentType!='Group'}">
																					<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-greener lnkTakeTestbtn" data-lnk="#" disabled="true"><spring:message code="homepage.takeATest" /></a>
																				</c:when>
																				<c:when test="${paper.paper.paperType == 'Typing'}">
																				  <a id="lnkFreeTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" data-dcidcnt="${displayCategoryWiseAttemptsMap[paper.displayCategoryLanguage.fkDisplayCategoryID]}" class="btn btn-greener lnkFreeTakeTest typingTest"
																						data-lnk="typ:url?ceid=${paper.candidateExam.candidateExamID}&dcid=${paper.displayCategoryLanguage.fkDisplayCategoryID}&b=false&clientid=${clientId}"><spring:message code="homepage.takeATest" /></a>
																				</c:when>
																				<c:when test="${paper.paper.paperType == 'DifficultyLevelWiseExam'}">
																				<div class="testR">
																						<form:form class="dashboardform examform" action="${formAction}" method="POST">	
																							<input type="hidden" name="ceid" value="${paper.candidateExam.candidateExamID}" />
																					    	<input type="hidden" name="dcid" value="${paper.displayCategoryLanguage.fkDisplayCategoryID}" />
																					    	<input type="hidden" name="b" value="false" />
																					    	<%-- <button class="btn btn-greener lnkFreeTakeTest practicalTest" type="submit" id="btnTakeATest"><spring:message code="homepage.takeATest" /></button> --%>
																					    	<a id="lnkFreeTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" data-dcidcnt="${displayCategoryWiseAttemptsMap[paper.displayCategoryLanguage.fkDisplayCategoryID]}" class="btn btn-greener lnkFreeTakeTest practicalTest"
																							data-lnk="../exam/Authentication?ceid=${paper.candidateExam.candidateExamID}&dcid=${paper.displayCategoryLanguage.fkDisplayCategoryID}&b=false"><spring:message code="homepage.takeATest" /></a>
																						</form:form>		
																					
																				</c:when>
																				<c:otherwise>
																					
																					<form:form class="dashboardform examform" action="${formAction}" method="POST">	
																						<input type="hidden" name="ceid" value="${paper.candidateExam.candidateExamID}" />
																				    	<input type="hidden" name="dcid" value="${paper.displayCategoryLanguage.fkDisplayCategoryID}" />
																				    	<input type="hidden" name="b" value="false" />
																				    	<%-- <button class="btn btn-greener lnkFreeTakeTest" type="submit" id="btnTakeATest"><spring:message code="homepage.takeATest" /></button> --%>
																				    	<a id="lnkFreeTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" data-dcidcnt="${displayCategoryWiseAttemptsMap[paper.displayCategoryLanguage.fkDisplayCategoryID]}" class="btn btn-greener lnkFreeTakeTest"
																						data-lnk="../exam/Authentication?ceid=${paper.candidateExam.candidateExamID}&dcid=${paper.displayCategoryLanguage.fkDisplayCategoryID}&b=false"><spring:message code="homepage.takeATest" /></a>
																				 
																					</form:form>	
																					
																				</c:otherwise>
																			</c:choose>																			
																		</c:when>
																		<c:otherwise>
																			<c:choose>
																				<c:when test="${paper.paperStatus == 3 and paper.assessmentType!='Group'}">
																					<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-greener lnkTakeTestbtn" data-lnk="#" disabled="true"><spring:message code="homepage.takeATest" /></a>
																				</c:when>
																				<c:when test="${paper.paper.paperType == 'Typing'}"> 
																					<a id="lnkFreeTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" data-dcidcnt="${displayCategoryWiseAttemptsMap[paper.displayCategoryLanguage.fkDisplayCategoryID]}" class="btn btn-greener lnkFreeTakeTest typingTest"
																							data-lnk="typ:url?ceid=${paper.candidateExam.candidateExamID}&dcid=${paper.displayCategoryLanguage.fkDisplayCategoryID}&b=true& clientid=${clientId}"><spring:message code="homepage.takeATest" /></a>
																				</c:when>
																				<c:when test="${paper.paper.paperType == 'DifficultyLevelWiseExam'}">
																				
																					<form:form class="dashboardform examform" action="${formAction}" method="POST">	
																						<input type="hidden" name="ceid" value="${paper.candidateExam.candidateExamID}" />
																				    	<input type="hidden" name="dcid" value="${paper.displayCategoryLanguage.fkDisplayCategoryID}" />
																				    	<input type="hidden" name="b" value="true" />
																				    	
																				    	<%-- <button class="btn btn-greener lnkFreeTakeTest practicalTest" type="submit" id="btnTakeATest"><spring:message code="homepage.takeATest" /></button> --%>
																				    	<a id="lnkFreeTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" data-dcidcnt="${displayCategoryWiseAttemptsMap[paper.displayCategoryLanguage.fkDisplayCategoryID]}" class="btn btn-greener lnkFreeTakeTest practicalTest"
																						data-lnk="../exam/Authentication?ceid=${paper.candidateExam.candidateExamID}&dcid=${paper.displayCategoryLanguage.fkDisplayCategoryID}&b=true"><spring:message code="homepage.takeATest" /></a>
																					</form:form>	
																					
																				</c:when>
																				<c:otherwise>
																					
																					<form:form  class="dashboardform examform" action="${formAction}" method="POST">	
																						<input type="hidden" name="ceid" value="${paper.candidateExam.candidateExamID}" />
																				    	<input type="hidden" name="dcid" value="${paper.displayCategoryLanguage.fkDisplayCategoryID}" />
																				    	<input type="hidden" name="b" value="true" />
																				    	<%-- <button class="btn btn-greener lnkFreeTakeTest" type="submit" id="btnTakeATest"><spring:message code="homepage.takeATest" /></button> --%>
																				    	<a id="lnkFreeTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" data-dcidcnt="${displayCategoryWiseAttemptsMap[paper.displayCategoryLanguage.fkDisplayCategoryID]}" class="btn btn-greener lnkFreeTakeTest"
																						data-lnk="../exam/Authentication?ceid=${paper.candidateExam.candidateExamID}&dcid=${paper.displayCategoryLanguage.fkDisplayCategoryID}&b=true"><spring:message code="homepage.takeATest" /></a>
																					</form:form>	
																					
																				</c:otherwise>
																			</c:choose>																			
																		</c:otherwise>
																	</c:choose>
																</c:when>
															</c:choose>
															</c:if>
															
															</div></td>
													</tr>
												</c:if>

											</c:forEach>

											<%-- </c:if> --%>

										</c:forEach>
										<%-- 	</c:forEach>
												</c:if>

											</c:forEach> --%>
										<%-- </c:forEach> --%>
									</tbody>

								</table>
							</div>
						</div>
					</c:when>
					<c:otherwise>
						<br />
						<div class="alert alert-info">
							<a class="close" data-dismiss="alert" href="#">&times;</a> <span><spring:message code="homepage.NoAvailabelTilte" /> : </span>
							<spring:message code="homepage.NoAvailabelInfo" />
						</div>
					</c:otherwise>
				</c:choose>




				<!-- common history page -->
				<%@include file="viewActivityHistory_Confidential.jsp"%>



			</div>

		</div>


	</fieldset>

	<!-- common home  page -->
	<%@include file="commonhomepage.jsp"%>
	
	<script>
	function myFunction() {
	   var element = document.body;
	   element.classList.toggle("dark-mode");
	}
	/* $('document').ready(function(){
		 var element = document.body;
		 element.classList.toggle("dark-mode");
	}); */
</script>
	
	<!-- script added for exam client; contact amoghs b4 modification -->
	<script type="text/javascript">
	$('document').ready(function(){
		/* var suspendflag=${suspendFlag};
		if(suspendflag){
$('#lnkFreeTakeTest').attr('disabled', true); 
			}*/
		if(navigator.userAgent.search('MOSB') >= 0 && typeof js != "undefined"){
			js.getEventId($('#eventId').val());	
		}	
	});

	
	</script>

</body>
</html>
