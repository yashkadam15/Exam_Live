<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<!--[if IEMobile 7]><html dir="ltr" lang="en"class="iem7"><![endif]-->
<!--[if IE 7]><html dir="ltr" lang="en" class="ie7"><![endif]-->
<!--[if IE 8]><html dir="ltr" lang="en" class="ie8"><![endif]-->
<!--[if IE 9]><html dir="ltr" lang="en" class="ie9"><![endif]-->
<!--[if (gte IE 9)|(gt IEMobile 7)|!(IEMobile)|!(IE)]><!-->
<html dir="ltr" lang="en">
<!--<![endif]-->
<head>
<title><spring:message code="Exam.Title" /></title>
<link rel="stylesheet" href="<c:url value='/resources/style/rating.css'></c:url>" type="text/css" />

<style type="text/css">
/* .examineeImageResize{
width: 40px;
height: 40px;
}

#examineeImageRef{
margin-left: 5px;
margin-top: -14px;
} */
.br-wrapper {
display: inline-block;
}

.title{
	display: inline-block;
    float: left;
    padding: 2px 10px 0 0;
}

</style>
</head>

<body class="osp exam exam-page osp-user-one">

<script src="<c:url value='/resources/js/RestrictActions.js?${jsTime }'></c:url>"></script>
<script src="<c:url value='/resources/js/Timer.js?${jsTime }'></c:url>"></script>
<script src="<c:url value='/resources/js/exam.js?${jsTime }'></c:url>"></script>
<script src="<c:url value='/resources/js/jquery.jplayer.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/oesplayer.js?${jsTime }'></c:url>"></script>
<script src="<c:url value='/resources/js/jquery.barrating.js?${jsTime }'></c:url>"></script>
<script src="<c:url value='/resources/js/examples.js?${jsTime }'></c:url>"></script>
		<div class="osp-content">
		<input type="hidden" id="testType" value="group"/>
		<input type="hidden" id="GroupEndTest" value="${GroupEndTest }">
		<input type="hidden" id="SelectOption" value="${SelectOption }">
		<input type="hidden" id="SelectConfLevel" value="${SelectConfLevel }">
		<input type="hidden" id="SoloEndConfirm" value="<spring:message code="Exam.SoloEndConfirm" />">
			<div class="container">
				<div class="row">
					<div class="span12 main-content">
						<div class="content-holder">
							<div class="reported cols">
								<div class="col1-3 osp-question-details">
									<h3><spring:message code="Exam.QuestionDetails" /> - <strong>${sessionScope.user.groupMaster.groupName}</strong></h3>
									<p><span id="itemSequenaceNumberText">0</span>/<span id="ttlcount">${paper.totalItem}</span></p>
                                    <input type="hidden" value="" id="itemSequenaceNumberValue"/>
                                    <!--  FIXME TODO ghisada solution to support one question in paper need to change. find supporting JS in Legends.js-->
                                    <input type="hidden" value="0" id="noTimesQuestionAsked"/> 
								</div>
								<div class="col1-3 white osp-timer">
									<h3><spring:message code="Exam.TimeRemaining" /></h3>
  									<div class="text-center">
                                   		<img id="clkImg" class="osp-timerimg" src=" <c:url value="../resources/images/clock.gif"></c:url>" alt=""/>
                                   		<img id="clkImgWarn" style="display: none" class="osp-timerimg" src=" <c:url value="../resources/images/clock-warning.gif"></c:url>" alt=""/>
                                    		<div class="digital-clock">
													<span id="time-text"></span>
									       </div>
                               		 </div>
								</div>
								
							
							<c:forEach var="logInUser" items="${loggedInUsers}" varStatus="k">					
								<div  id="${logInUser.object}" class="col1-3 osp-question-for" style="display: none;" data-seq="${k.index}">
								<!-- <b><span class="examineeJudgefor" style="margin-left:110px;position:absolute;color:white;padding-left: 10px;padding-right: 10px;background: black;display: inline;"></span></b> -->
									<h4><spring:message code="Exam.QuestionFor" /> - <strong  class="examineeJudgefor"></strong></h4>
									<div class="osp-user">

										<c:choose>
											<c:when test="${not empty logInUser.userPhoto and fn:length(logInUser.userPhoto) > 0}">
												<div class="img">
													<img src="${imgPath}${logInUser.userPhoto}"  onerror="this.src='${imgPath}<spring:message code="instruction.defaultPhoto"/>';">
												</div>
											</c:when>
											<c:otherwise>
												<div class="img">
													<img src="${imgPath}<spring:message code="instruction.defaultPhoto"/>" alt="default">
												</div>
											</c:otherwise>
										</c:choose>
										<p style="padding-top: 0px;">
											${logInUser.firstName} ${logInUser.middleName} ${logInUser.lastName}
										</p>
										<%-- <span class="ex-info">${sessionScope.user.groupMaster.groupName}<br></span> --%>
										<span class="doyouagreeQ question" style="display: none;" ><spring:message code="Exam.doyouagreeQ"/> &nbsp;<a class="btn btn-mini" onclick="$('#QuestionContainer')[0].contentWindow.doYouAgreeAnswer(1,'${logInUser.object}');"><spring:message code="Exam.Yes" /></a>&nbsp;<a class="btn btn-mini" onclick="$('#QuestionContainer')[0].contentWindow.doYouAgreeAnswer(0,'${logInUser.object}');"><spring:message code="Exam.No" /></a></span>
										<span class="doyouagreeQ yes" style="display: none;"><spring:message code="Exam.youAgreedQ"/> <b><spring:message code="Exam.submitAnswer"/></b></span>
									    <span class="doyouagreeQ no" style="display: none;"><spring:message code="Exam.youNotAgreeQ"/> <b><spring:message code="Exam.submitAnswer"/></b></span> 
									</div>
								</div>
								<input type="hidden" id="candidateName${logInUser.object}" value="${logInUser.firstName }&nbsp;${logInUser.middleName}&nbsp;${logInUser.lastName}">
								<input type="hidden" id="sequenceNo${logInUser.object}" value="${userColors[k.index]}">
								<input type="hidden" id="candidateExamID${logInUser.object}" value="${candidateExamMap[logInUser.object]}">
								<input type="hidden" id="hidRecordedFileName${logInUser.object}" value="${logInUser.userName }_${paper.code}" />
							</c:forEach>   
										
							</div>
							  <div class="question-overlay"></div>
							<div class="holder">
								<form:form action="../groupendexam/FrmendTest" method="post" id="frmendTest">

									<!-- Hidden Start -->
									<input type="hidden" id="languageID" value="${languageID}" /> 
									<input type="hidden" id="hidTtlDuration" value="${paper.duration}" /> 
									<input type="hidden" id="timeLeft" value="${timeLeft}" /> 
									<input type="hidden" id="updateElapsedTime" value="${updateElapsedTime}" /> 
									<input type="hidden" id="endExamEnablePercentage" name="endExamEnablePercentage" value="${sessionScope.exampapersetting.endTestEnablePercentage}" /> 
									<%-- <input type="hidden" id="candidateExamID" name="candidateExamID" value="${candidateExam.candidateExamID}" /> --%>
									<input type="hidden" id="examEventID" name="examEventID" value="${examEvent.examEventID }" /> 
									<input type="hidden" id="paperID" name="paperID" value="${paper.paperID }" />
									<input type="hidden" id="hidelapsedTimeDuration" value="${candidateExam.elapsedTime}" />
									<!-- Hidden End -->
                                    <label class="alert-error" id="error"></label>  
                                    <!-- Hidden Frame   -->                              
                                    <iframe data-candidateexamid="0"  data-paperid="${paper.paperID }" data-exameventid="${examEvent.examEventID }" src="" id="hidOperations"> </iframe>
                                    <!-- Q Container Frame -->
                                    <iframe src="../groupExam/QuestionContainer?examEventID=${examEvent.examEventID}&paperID=${paper.paperID}&selectedLang=${selectedLang}&secID=${activeSec}" id="QuestionContainer" name="QuestionContainer"></iframe>                            
									 <div class="ops-end-test">
										
										<!-- <table>
										<tr>
										   <td><b>&nbsp;EXAMINEE FOR THIS QUESTION :&nbsp;&nbsp;&nbsp;&nbsp; </b></td>
										   <td><img class="examineeImageResize pull-left" src="" /></td>
										   <td>&nbsp;&nbsp;<span class="showExamineeName"></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
										   <td class="showExamineeChosenOption" style="border-left: 1px solid #ddd;"><b>&nbsp;&nbsp;SELECTED OPTION NO : </b></td>
										   <td class="showExamineeChosenOption examineeOptonSeqNo"></td>
										   <td class="showExamineeChosenOption examineeConfLevel"></td>
										   </tr>
										</table> -->
										<div class="row-fluid">
										<div id="examineeImageRef" class="span10">
												<img class="examineeImageResize pull-left" src="">
												<p class="examineeForThis pull-left"><strong><spring:message code="Exam.examineeforQ"/> : </strong> <span class="showExamineeName"></span></p>
												<%-- <p class="showExamineeChosenOption pull-left"><strong><spring:message code="Exam.selectedOptionQ"/> : </strong> <span class="showExamineeChosenOption examineeOptonSeqNo"></span> <span class="showExamineeChosenOption examineeConfLevel"></span></p> --%>
										</div>
										<div class="span2 pull-right">
											<button class="btn btn-danger pull-right" type="button" id="endTest" name="endTest" ><spring:message code="Exam.EndTest" /></button>
									    </div>
										</div> 
										
									</div>
									
								</form:form>
							</div>
						
							<!-- End Test Modal -->
							<div id="endTestConfirmModal" class="modal hide fade in" style="display: none;">
								<div class="modal-header">
									<a class="close" data-dismiss="modal">×</a>
									<h3><spring:message code="Exam.Modal.ConfrimEndTest" /></h3>
								</div>
								<div class="modal-body">
									<p id="endTestConfirmTest"></p>
								</div>
								<div class="modal-footer">
									<a id="submitTestBeforetimesUp" href="../groupendexam/FrmendTestGet?candidateExamID=0&examEventID=${examEvent.examEventID }&paperID=${paper.paperID }" class="btn btn-success"><spring:message code="Exam.modal.OK" /> </a> <a class="btn" data-dismiss="modal"><spring:message code="Exam.Modal.close" /> </a>
								</div>
							</div>

							<div id="modalEndTest" class="modal hide fade in" style="display: none;">
								<div class="modal-header"></div>
								<div id="modalEndTestMSG" class="modal-body"><spring:message code="Exam.modal.Yourtimeisup" /></div>
								<div class="modal-footer">
									<%-- <a id="closemodal" href="../groupendexam/showTestResult?candidateExamID=0&examEventID=${examEvent.examEventID }&paperID=${paper.paperID }" class="btn" data-dismiss="modal" aria-hidden="true"> <spring:message code="Exam.modal.OK" /> </a> --%>
									<a id="closemodal" href="../groupendexam/FrmendTestGet" class="btn" data-dismiss="modal" aria-hidden="true"><spring:message code="Exam.modal.OK" /></a>
								</div>
							</div>
							<div style="display: none;">
								<a id="BtnmodalEndTest" href="#modalEndTest" data-toggle="modal" data-backdrop="static"></a>
							</div>
							<div id="playCandVdoModal" class="modal fade" data-backdrop="static">
								<div class="modal-body">
								<!-- Video Player -->
									<div id="MMplayer_1" data-mediamode="exam" data-mediatype="video" data-mediaurl="" data-mediaext="" data-medialoadonready="false" data-mediatitle=""></div>		
								</div>		
							</div>
							<div id="ratepeer" class="modal fade" data-backdrop="static">
								<div class="modal-header"><h3><spring:message code="chatWindow.ratePeer" /></h3></div>
								<div class="modal-body">
									<c:forEach var="logInUser" items="${loggedInUsers}" varStatus="k">	
										<div class="stars stars-example-css">
							                <div class="br-wrapper br-theme-css-stars">
							                  <span class="title">${logInUser.firstName} ${logInUser.middleName} ${logInUser.lastName} :</span>
								                <select id="conf${logInUser.object}" class="example-css" name="rating" autocomplete="off" style="display: none;">
								                  <option value="None">#conf${logInUser.object}</option>
								                  <option value="Low">#conf${logInUser.object}</option>
								                  <option value="Partial">#conf${logInUser.object}</option>
								                  <option value="Full">#conf${logInUser.object}</option>
								                  <option value="FiveStars">#conf${logInUser.object}</option>
								                </select>								                
							                </div>							              
							            </div>
									</c:forEach>									
								</div>
								<div class="modal-footer">
									<a href="#" class="btn btn-success" id="ratingfinish"><spring:message code="takeTest.submit"/></a>
								</div>		
							</div>						
						</div>
					</div>
				</div>
			</div>
		</div>
</body>
</html>