<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib  uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
<title><spring:message code="MSCITExam.Title" /></title>
<link rel="stylesheet" href="<c:url value='/resources/style/bootstrap_mscit.min.css'></c:url>" type="text/css" />
<link rel="stylesheet" href="<c:url value='/resources/style/style_mscit.css'></c:url>" type="text/css" />
</head>
<body>
    <script src="<c:url value='/resources/js/jquery-1.12.0.min.js'></c:url>"></script>
    <script src="<c:url value='/resources/js/bootstrap.min.js'></c:url>"></script>
    <script src="<c:url value='/resources/js/Timer.js?${jsTime }'></c:url>"></script>
    <script src="<c:url value='/resources/js/mscitexam.js?${jsTime }'></c:url>"></script>
    <script src="<c:url value='/resources/js/RestrictActions.js?${jsTime }'></c:url>"></script>

    <div class="main">
    <form:form action="../endexam/FrmendTest" method="post" id="frmendTest">
    <input type="hidden" id="MSCITEndExamConfirm1" value="<spring:message code="MSCITExam.EndExamConfirm1" />">
     <input type="hidden" id="MSCITEndExamConfirm2" value="<spring:message code="MSCITExam.EndExamConfirm2" />">
      <input type="hidden" id="MSCITEndExamConfirm3" value="<spring:message code="MSCITExam.EndExamConfirm3" />">
        <div class="section headerSection">
            <div class="container">
                <div class="row">
                    <div class="col-md-3 col-sm-6 col-xs-8 student_details">
                    <c:choose>
                    <c:when test="${fn:length(candidate.userPhoto) > 0}">
                        <img class="photoId" src="${imgPath}${candidate.userPhoto}">                        
                        </c:when>
                        <c:otherwise>
                        <img class="photoId" src="${imgPath}<spring:message code="instruction.defaultPhoto"/>">  
                        </c:otherwise>
                        </c:choose>
                        <div class="col-md-6  userinfo">
                            <p><spring:message code="MSCITExam.LearnerName" />
                                <br>
                                <span>${candidate.firstName } ${candidate.middleName } ${candidate.lastName }</span>
                            </p>
                            <p><spring:message code="MSCITExam.MKCLLearnerID" />
                                <br>
                                <span>${candidate.userName }</span>
                            </p>
                            <p><spring:message code="MSCITExam.AttemptNo" />
                                <br>
                                <span>${sessionScope.exampapersetting.attemptNo}</span>
                            </p>
                        </div>
                    </div>
                    <div class="col-md-2 col-sm-6 col-xs-4" id="evidencePreview">
                        <div class="video-wrapper" >
                             <img  src="../resources/images/movie.jpg" class="img-responsive" />  </div>
                    </div>
                    <div class="col-md-5 col-sm-8">
                        <table class="table table-bordered questionInfoTable" id="qusInfoTable">
                            <thead>
                                <tr>
                                    <th></th>
                                    <th colspan="3" align="center"><spring:message code="MSCITExam.ObjectiveQuestions" /></th>
                                    <th colspan="3" align="center"><spring:message code="MSCITExam.PracticalQuestions" /></th>
                                </tr>
                                <tr>
                                    <th><spring:message code="MSCITExam.Questions" /></th>
                                    <th><spring:message code="MSCITExam.Total" /></th>
                                    <th><spring:message code="MSCITExam.Attempted" /></th>
                                    <th><spring:message code="MSCITExam.Remaining" /></th>
                                    <th><spring:message code="MSCITExam.Total" /></th>
                                    <th><spring:message code="MSCITExam.Attempted" /></th>
                                    <th><spring:message code="MSCITExam.Remaining" /></th>
                                </tr>
                            </thead>
                            <tbody> 
                            <c:set var="sumTotalQuestn" value="0"></c:set>
                            <c:set var="sumTotalQuestnP" value="0"></c:set>
                            <c:set var="sumAttemptedQuestn" value="0"></c:set>
                            <c:set var="sumAttemptedQuestnP" value="0"></c:set>
                            <c:set var="sumRemainQuestn" value="0"></c:set>
                            <c:set var="sumRemainQuestnP" value="0"></c:set>
                            <c:forEach var="i" begin="0" end="${fn:length(difficultyLevelWiseCount)-4}">
                                <tr id='lvl${i+1}'>
                                    <td>Level${i+1}</td>                                    
                                	<td class='OBJECTIVE-Ttl'>${difficultyLevelWiseCount[i].totalQuestion} <c:set var="sumTotalQuestn" value="${sumTotalQuestn+ difficultyLevelWiseCount[i].totalQuestion}"></c:set></td>
                                    <td class='OBJECTIVE-Atmpt'>${difficultyLevelWiseCount[i].attemptedQuestion}<c:set var="sumAttemptedQuestn" value="${sumAttemptedQuestn+difficultyLevelWiseCount[i].attemptedQuestion }"></c:set></td>
                                    <td class='OBJECTIVE-Remain'>${difficultyLevelWiseCount[i].remaingQuestion} <c:set var="sumRemainQuestn" value="${sumRemainQuestn+ difficultyLevelWiseCount[i].remaingQuestion}"></c:set></td>
                                    <td class='PRACTICAL-Ttl'>${difficultyLevelWiseCount[i+3].totalQuestion}<c:set var="sumTotalQuestnP" value="${sumTotalQuestnP+ difficultyLevelWiseCount[i+3].totalQuestion}"></c:set></td>
                                    <td class='PRACTICAL-Atmpt'>${difficultyLevelWiseCount[i+3].attemptedQuestion}<c:set var="sumAttemptedQuestnP" value="${sumAttemptedQuestnP+difficultyLevelWiseCount[i+3].attemptedQuestion }"></c:set></td>
                                    <td class='PRACTICAL-Remain'>${difficultyLevelWiseCount[i+3].remaingQuestion} <c:set var="sumRemainQuestnP" value="${sumRemainQuestnP+ difficultyLevelWiseCount[i+3].remaingQuestion}"></c:set></td>                                   
                                </tr>
                                </c:forEach>
                                <tr id="lvlSum">
                                    <td><spring:message code="MSCITExam.Total" /></td>
                                    <td class='OBJECTIVE-TtlSum'>${sumTotalQuestn}</td>
                                    <td class='OBJECTIVE-AtmptSum'>${sumAttemptedQuestn}</td>
                                    <td class='OBJECTIVE-RemainSum'>${sumRemainQuestn}</td>
                                    <td class='PRACTICAL-TtlSum'>${sumTotalQuestnP}</td>
                                    <td class='PRACTICAL-AtmptSum'>${sumAttemptedQuestnP}</td>
                                    <td class='PRACTICAL-RemainSum'>${sumRemainQuestnP}</td>   
                                </tr>
                                </tbody>                    
                        </table>
                    </div>
                    <div class="col-md-2 col-sm-4 text-center ">
                    
                        <div class="counterBlock">
                            <p style="color:#ffea01; "><spring:message code="MSCITExam.TotalTime" />
                                 <!-- added reena --><span style="color:white;">
                                 ${fn:substringBefore(paper.duration/60, '.')} min
                                </span>
                            </p>
                            <p class="counterText"><spring:message code="MSCITExam.Countdown" /></p>
                            <p class="counterText"><span id="time-text"></span></p>
                            <p class="counter-hh-mm"><spring:message code="MSCITExam.RemainingTimeInfo" /></p>
                        </div>
                        <!-- added reena -->
                        <input type="hidden" id="hidTtlDuration" value="${paper.duration}"/>
						<input type="hidden" id="hidelapsedTimeDuration" value="${candidateExam.elapsedTime}"/>
						<input type="hidden" id="timeLeft" value="${timeLeft}"/>
						<input type="hidden" id="updateElapsedTime" value="${updateElapsedTime}"/>
                    </div>
                </div>
            </div>
        </div>
        <div class="section questions-details">
            <div class="container">
                <div class="row">
                    <div class="lightBlueHeader clearfix">
                        <div class="col-md-2 col-sm-3">
                            <p class="blockBlue"><spring:message code="MSCITExam.TotalQuestions" />
                                <span id="ttlQues">${fn:length(candidateItemAssociations)}</span>
                            </p>
                        </div>
                        <div class="col-md-2 col-sm-3">
                            <p class="blockBlue"><spring:message code="MSCITExam.TotalMarks" />
                                <span>${sessionScope.exampapersetting.totalMarks}</span>
                            </p>
                        </div>
                        <hr class="hr-hide">
                        <div id="ObjectiveInfo">
                        <div class="col-md-3 col-md-offset-2 col-sm-3">                          
                                <div class="form-group">
                                    <div class="col-sm-11">
                                        <div class="checkbox">
                                            <label class="blockBlue radio-inline">
                                                <input type="radio" disabled="true"><spring:message code="MSCITExam.DenotesSC" /></label>
                                        </div>
                                    </div>
                                </div>
                          </div>
                        <div class="col-md-3 col-sm-3">
                         <div class="form-group">
                                    <div class=" col-sm-11">
                                        <div class="checkbox">
                                            <label class="blockBlue checkbox-inline">
                                                <input type="checkbox" disabled="true"><spring:message code="MSCITExam.DenotesMC" /></label>
                                        </div>
                                    </div>
                                </div>
                           </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="section difficulty-section">
            <div class="container">
                <div class="row">
                    <div class="col-sm-4 ">
                        <div class="box left-box">
                            <h4 class="text-center"><spring:message code="MSCITExam.Lvl1Header" /></h4>
                            <p class="text-center">
                                <a class="lvlbtn btn btn-red" data-active="1" data-level="0" data-qtype="OBJECTIVE" data-displaylvl="1" id="lnkObjective_0" href="0"><spring:message code="MSCITExam.Objective" /></a>
                                <a class="lvlbtn btn btn-blue" data-active="0" data-level="0" data-qtype="PRACTICAL" data-displaylvl="1" id="lnkPractical_0" href="0"><spring:message code="MSCITExam.Practical" /></a>
                            </p>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="box middle-box">
                            <h4 class="text-center"><spring:message code="MSCITExam.Lvl2Header" /></h4>
                            <p class="text-center">
                                <a class="lvlbtn btn btn-blue" data-active="0" data-level="1" data-qtype="OBJECTIVE" data-displaylvl="2" id="lnkObjective_1" href="1" ><spring:message code="MSCITExam.Objective" /></a>
                                <a class="lvlbtn btn btn-blue" data-active="0" data-level="1" data-qtype="PRACTICAL" data-displaylvl="2" id="lnkPractical_1" href="1"><spring:message code="MSCITExam.Practical" /></a>
                            </p>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="box right-box">
                            <h4 class="text-center"><spring:message code="MSCITExam.Lvl3Header" /></h4>
                            <p class="text-center">
                                <a class="lvlbtn btn btn-blue" data-active="0" data-level="2" data-qtype="OBJECTIVE" data-displaylvl="3" id="lnkObjective_2" href="2"><spring:message code="MSCITExam.Objective" /></a>
                                <a class="lvlbtn btn btn-blue" data-active="0" data-level="2" data-qtype="PRACTICAL" data-displaylvl="3" id="lnkPractical_2" href="2"><spring:message code="MSCITExam.Practical" /></a>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>      
        <div class="section question-section">
            <div class="container">
                <div class="row">
                    <div class="col-md-12">
                    <iframe src="" id="hidOperations"> </iframe>
                    <iframe class="embed-responsive-item question_iframe" src="../MSCITExam/QuestionContainer?selectedLang=${selectedLang}&secID=${activeSec}&start" id="QuestionContainer" name="QuestionContainer" allowfullscreen=""></iframe>                    
                    </div>
                </div>
            </div>
        </div>
        <div class="section">
            <div class="container instruction">
                <div class="row">
                    <div class="col-md-8 col-sm-8">
                        <p  id="instrcutionInfo" class="text-danger"><spring:message code="MSCITExam.ObjInstruction" /></p>
                    </div>
                    <div class="col-md-4 col-sm-4">
                        <button class="btn btn-sm-red pull-right-sm" type="button" id="endMSCITTest" name="endMSCITTest"><spring:message code="MSCITExam.EndExam" /></button>
                    </div>
                </div>
            </div>
        </div>
        </form:form>
        <div class="section">
            <div class="container">
                <div class="row" id="footer">
                    <div class="col-sm-2">
                        <img src="../resources/images/mkcl-logo.png" class="img-responsive mkcl-logo">
                        <img src="../resources/images/mscit-logo.png" class="img-responsive mscit-logo-h">
                    </div>
                    <div class="col-sm-8 ">
                    <c:if test="${isCopyRightEnabled}">
                        <p class="text-center" style="margin:14px 0;"><spring:message code="global.Copyright" />
							<spring:message code="global.footerCompanyName" /></p>
					</c:if>
                    </div>
                    <div class="col-sm-2">
                        <img src="../resources/images/mscit-logo.png" class="img-responsive mscit-logo">
                    </div>
                </div>
            </div>
        </div>
    </div>
<a id="msgModalLoader" data-msgmodalbodytext="" data-footerbtn1class="" data-footerbtn2class="" data-footerbtn1text="<spring:message code="Exam.Yes" />" data-footerbtn2text="<spring:message code="Exam.No" />" data-displaymodal="off"></a>
<div id="msgModal" class="modal fade " style="display: none;" role="dialog" aria-labelledby="myLargeModalLabel">
	<div class="modal-dialog modal-md">
        <div class="modal-content">
	<div class="modal-body">
		<label id="msgModalBodyText"></label>
	</div>
	
	<div class="modal-footer">
		<a class="btn" id="MsgModalbtn1" style="display: none"></a>
		<a class="btn" id="MsgModalbtn2" style="display: none"></a>
	</div>
	</div>
	</div>
</div>
<div id="modal-endMSCITTest1" class="modal fade " style="display: none;" role="dialog" aria-labelledby="myLargeModalLabel">
	<div class="modal-dialog modal-md">
        <div class="modal-content">
	<div class="modal-body">
		 <label id="msgModalBodyText1"></label> 		
	</div>	
	<div class="modal-footer">
		<a class="btn btn-default" id="btnConfirm1"><spring:message code="Exam.modal.OK" /></a>		
		<a id="btnCancel1" href="#" class="btn btn-default" data-dismiss="modal" aria-hidden="true"><spring:message code="global.cancel" /></a>
	</div>
	</div>
	</div>
</div>
<div id="modal-endMSCITTest2" class="modal fade " style="display: none;" role="dialog" aria-labelledby="myLargeModalLabel">
	<div class="modal-dialog modal-md">
        <div class="modal-content">
	<div class="modal-body">
		<label id="msgModalBodyText2"></label>
	</div>	
	<div class="modal-footer">
		<a class="btn btn-default" id="btnConfirm2" ><spring:message code="Exam.modal.OK" /></a>		
		<a id="btnCancel3" href="#" class="btn btn-default" data-dismiss="modal" aria-hidden="true"><spring:message code="global.cancel" /></a>
	</div>
	</div>
	</div>
</div>
<div id="modal-endMSCITTest3" class="modal fade " style="display: none;" role="dialog" aria-labelledby="myLargeModalLabel">
	<div class="modal-dialog modal-md">
        <div class="modal-content">
	<div class="modal-body">
		<label id="msgModalBodyText3"></label>
	</div>	
	<div class="modal-footer">
		<a class="btn btn-default" id="btnConfirm3" data-dismiss="modal" aria-hidden="true"><spring:message code="Exam.modal.OK" /></a>		
		<a id="btnCancel3" href="#" class="btn btn-default" data-dismiss="modal" aria-hidden="true"><spring:message code="global.cancel" /></a>
	</div>
	</div>
	</div>
</div>
<script>
// 08 Dec 2016 : Added method to send evidence preview position and size as per holder to SB
$(document).ready(function(){
	
	if(navigator.userAgent.search('MOSB') >= 0 && typeof js != "undefined"){	
	
		js.displayPreview(parseInt($('#evidencePreview').position().left),parseInt($('#evidencePreview').position().top),parseInt($('#evidencePreview .video-wrapper img').height()),parseInt($('#evidencePreview .video-wrapper img').width()));
		
	}
});
// - end -
</script>
</body>
</html>