<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="en">
<head>
<link rel="stylesheet" href="<c:url value='/resources/style/template_darkmode.css'></c:url>" type="text/css" />
<style type="text/css">
.highlightText {
	color: red;
}

.links {
	width: 790px;
}

.languagearea {
	width: 200px;
}

.picsaction {
	width: 220px;
}

.picholder {
	margin-bottom: 10px;
	padding: 5px 5px;
	border: 1px solid #b5cee9;
	background-color: #e4edf7;
}

.instructionarea {
	height: 350px;
}

.span2 {
	width: 100px;
}

.exampage .profile-timer .dp {
	width: 50px;
	height: 65px;
	overflow: hidden;
	border: 1px solid #000;
	float: left;
}

img.resize {
	height: auto;
	width: 90px;
}

img.resize {
	height: 135px;
	width: auto;
}

.deviceTest {
	display: table;
	/* border-top: 1px solid #cfc7c0;  */
	width: 100%;
	color: #000;
	border-top: 1px solid #cccccc;
}

.line {
	padding-right: 10%; /* 20+1 */
	position: relative;
}

.line:after {
	content: '';
	position: absolute;
	right: 0;
	border-right: 1px solid #cfc7c0;
	top: 10%;
	bottom: 10%;
}

.first {
	display: table-cell;
	width: 30%;
	padding: 5px 5px 5px 0px;
	text-align: center;
}

.second {
	display: table-cell;
	width: 30%;
	padding: 5px 5px 5px 5px;
	text-align: center;
}

.third {
	display: table-row;
	width: 100%;
	padding: 5px 5px 5px 5px;
	text-align: left;
}

.imgDevice:hover {
	cursor: pointer;
	background: #ff4d4d;
	border-radius: 10px;
	-webkit-border-radius: 10px;
	-moz-border-radius: 10px;
	-webkit-transition: 500ms linear 0s;
	-moz-transition: 500ms linear 0s;
	-o-transition: 500ms linear 0s;
	transition: 500ms linear 0s;
}

.instructionInfo1 {
	display: table-cell;
	width: 20%;
	padding: 5px 5px 5px 0px;
}

.instructionInfo2 {
	display: table-cell;
	width: 60%;
	padding: 5px 5px 5px 0px;
}

.content-area1 {
	width: 50%;
	margin: 25px auto 0px;
	display: none;
}

.content-area2 {
	width: 50%;
	margin: 5px auto 0px;
	display: none;
}

.content-area3 {
	width: 50%;
	margin: 5px auto 0px;
}

.mt {
	margin-top: 20px;
}

.imgnotshow {
	display: none;
}

@media only screen and (max-device-width: 480px) {
	.content-area1 {
		padding: 15px;
		width: auto;
		margin: auto;
		display: none;
	}
	.content-area2 {
		padding: 15px;
		width: auto;
		margin: auto;
		display: none;
	}
	.content-area3 {
		padding: 15px;
		width: auto;
		margin: auto;
	}
	.select-area {
		margin: 10px auto 0px;
		display: flex;
		width: 220px;
	}
	.select-area1 {
		width: 280px;
		display: flex;
		margin: 0px auto;
		border: 1px solid;
	}
	.video-area {
		width: 290px;
		display: block;
		margin-left: auto;
		margin-right: auto;
	}
	.profile-img {
		position: absolute;
		display: none;
		padding: 10px;
	}
}
</style>
<title><spring:message code="Exam.Title" /></title>
<spring:theme code="playertheme" var="playertheme"/>
<link rel="stylesheet" href="<c:url value='${playertheme}'></c:url>" type="text/css"/>
<script src="<c:url value='/resources/js/jquery.jplayer.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/oesplayer.js'></c:url>"></script>
<script src="<c:url value='/resources/js/inspage.js?v=07042023A'></c:url>"></script>
</head>
<body class="exampage">

	<input type="hidden" id="eventId" value="${examEvent.examEventID }"/>
	<input type="hidden" id="paperType" value="${paper.paperType }"/>
	<input type="hidden" id="clientId" value="${clientid }"/>
	<input type="hidden" id="paperId" value="${paper.paperID }"/>
	<input type="hidden" id="candidateCode" value="${candidate.candidateCode}"/>
	<input type="hidden" id="candidateId" value="${candidate.candidateID}"/>
	<input type="hidden" id="vc" value="${ec.examVenueCode }">
	<input type="hidden" id="vi" value="${ec.examVenueID }">
	
	<input type="hidden" id="ins_confirmlan" value="<spring:message code="instruction.confirmlan" />">
	<input type="hidden" id="ins_chooselang" value="<spring:message code="instruction.chooselang" />">
	<input type="hidden" id="isRIFORMItem" value="${isRIFORMItem}">
	<input type="hidden" id="evurl" value="${evurl }">
	<input type="hidden" id="isVoiceRecordingEnabled" name="isVoiceRecordingEnabled" value="${examClientConfig.isVoiceRecordingEnabled}"/>
	<input type="hidden" id="ins_confirmMicrophone" value="<spring:message code="instruction.confirmMicrophone" />">
	<div class="holder">
		<div class="span8">
			<div id="firstPage" style="display: none;">
				<div style="padding-top: 20px; font-size: 1.286em;">
					<spring:message code="instruction.text" />
				</div>
				<div class="questions-area">
					<div class="question">
						<b><spring:message code="instruction.firstPageInstrution" /></b>
					</div>
					<div class="qanswer" style="overflow: auto; height: 300px">
						${instructions.intructionText}
					</div>
				</div>				
			
			<!-- end -->
				<div class="pull-right">
					<a id="instNext" class="next btn btn-blue" href=""> <spring:message code="instruction.next"></spring:message></a>
				</div>
			</div>
			
			<div id="secondPage" style="display:none;">				
				<div style="padding-top: 20px; font-size: 1.286em;">
					<spring:message code="instruction.text" />
				</div>
				<div class="questions-area">
					<div class="question" class="instructionarea">
						<b><spring:message code="instruction.otherImp"></spring:message></b>
					</div>
					<div class="qanswer" style="height: 250px; overflow: auto">
						${instructions.importantInstructions }
					</div>
				</div>	
				<form:form modelAttribute="instructions" action="TakeTest" method="POST" class="form-horizontal" style="padding: 0;position:relative" id="readyToBeginForm">
					
					<input type="hidden" value="${dcid}" name="dcid" />
					<input type="hidden" value="${b}" name="b" />
					<input type="hidden" value="${ceid}" name="ceid" />
					<input type="hidden" value="${se}" name="se" />
					<input type="hidden" value="${isDarkModeOn}" name="isDarkModeOn" id="isDarkModeOn"/>
					<div class="questions-area" style="height: auto;">						
						<div class="question" class="instructionarea" style=" border-bottom: 0px;">
							<div class="instructionInfo1">
								<spring:message code="instruction.language" />
							</div>
							<div class="instructionInfo1">
								<select name="language" id="language" style="/*width:90%;*/">
									<c:choose>
										<c:when test="${fn:length(mediumOfPapersList) == 1}">
											<c:forEach items="${mediumOfPapersList}" var="medium">
												<option value="${medium.language.id}" selected="selected">${medium.language.languageName}</option>
											</c:forEach>
										</c:when>
										<c:otherwise>
											<option value="0" selected="selected">
												<spring:message code="global.select" />
											</option>
											<c:forEach items="${mediumOfPapersList}" var="medium">
												<option value="${medium.language.id}">${medium.language.languageName}</option>
											</c:forEach>
										</c:otherwise>
									</c:choose>
								</select>
							</div>
							<div class="instructionInfo2 redText">
								<spring:message code="instruction.info" />							
							</div>	
							<c:if test="${fn:length(MMItemTypeList) > 0}">
								<div class="deviceTest">
									<div class="first${isRIFORMItem ? ' line' : ''}">
										<a href="#" id="configureAudio"><img class="imgDevice" style="height:30px; width:30px;" src="../resources/images/volume.png"/>															
										<p style="padding-top:5px;"><spring:message code="Exam.instruction.checkAudiodevice" /></p>
										</a>
									</div>
									<c:if test="${isRIFORMItem}">
										<div class="second line">
											<a href="#" id="configureMic"> <img class="imgDevice" style="height:40px; width:40px;" src="../resources/images/mic.png"/>
											<p ><spring:message code="Exam.instruction.checkMic" /> </p></a>
										</div>
										<div class="second ">
											<a href="#" id="configureWebCam"><img class="imgDevice" style="height:40px; width:40px;" src="../resources/images/webcam.png"/>
											<p ><spring:message code="Exam.instruction.checkWebcam" /></p></a>
										</div>
									</c:if>										
								</div>
								<p class="third redText declm"><spring:message code="Exam.instruction.deviceInfo" /></p>
							</c:if>														
						</div>
					</div>
					<div class="redText declm">
						<c:if test="${fn:length(MMItemTypeList) > 0}">
							<input type="checkbox" id="disclaimer" disabled/>
						</c:if>
						<c:if test="${fn:length(MMItemTypeList) == 0}">
							<input type="checkbox" id="disclaimer" />
						</c:if>							
						${instructions.disclaimerText}													
					</div>
					<br />
					<div class="pull-right">
						<a class="prev btn btn-blue" id="instPrev" href=""> <spring:message code="instruction.previous"></spring:message></a>
					</div>
					<form:button type="submit" class="btn btn-blue" id="proceed">
						<spring:message code="instruction.ready" />
					</form:button>
					<c:choose>
						<c:when test="${sessionScope.user.object != null and sessionScope.user.isThirdPartySession == true}">
							<a href="<c:url value="/gateway/backtopartner"></c:url>" id="cancelTest" class="btn btn-blue"><spring:message code="global.cancel" /></a>
						</c:when>
						<c:otherwise>
							<a href="../candidateModule/homepage?changeLocale" id="cancelTest" class="btn btn-blue"><spring:message code="global.cancel" /></a>
						</c:otherwise>
					</c:choose>
				</form:form>
			</div>
		</div>
		
		<div class="span4" id="profileinfopage" style="display: none;padding-top: 40px">
			<div>
				<c:choose>
					<c:when test = "${fn:length(candidate.candidatePhoto) > 0 && fn:startsWith(candidate.candidatePhoto, 'http')}">
						<img src="${candidate.candidatePhoto}" style="border: 1pt black solid;" alt="" class="resize">
					</c:when>
					<c:when test="${fn:length(candidate.candidatePhoto) > 0}">
						<img src="${imgPath}${candidate.candidatePhoto}" style="border: 1pt black solid;" alt="" class="resize">
					</c:when>
					<c:otherwise>
						<img src="${imgPath}<spring:message code="instruction.defaultPhoto"/>" style="border: 1pt black solid;" alt="" class="resize">
					</c:otherwise>
				</c:choose>
				<div style="display: inline-block;">
					<spring:message code="incompleteexams.CandidateName" />: ${sessionScope.user.venueUser[0].firstName}&nbsp;${sessionScope.user.venueUser[0].middleName}&nbsp;${sessionScope.user.venueUser[0].lastName}
					<br>
					<spring:message code="incompleteexams.CandidateCode" />: ${sessionScope.user.venueUser[0].mkclIdentificationNumber}
					<br>
					<spring:message code="incompleteexams.Username" />: ${sessionScope.user.venueUser[0].userName}
					<br>
				</div>				
			</div>
			<img src="" id="camPic" style="margin-top: 30px">
		</div>
	</div>
	
	<div id="intrAlertModal" class="modal hide fade in " style="display: none;" >
		<div class="modal-body">
			<span id="alertSpan"></span>
		</div>
		<div class="modal-footer">		
			<button class="btn" data-dismiss="modal" aria-hidden="true"><spring:message code="Exam.modal.OK" /></button>		
		</div>	
	</div>
	 
	<div id="modal-examclientallowed" Class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="false" data-keyboard="true" data-backdrop="static">
		<div class="modal-body">
			<h4>
				 <spring:message code="Exam.examclientforRiform" />
			</h4>
		</div>
		<div class="modal-footer" style="text-align: center;">
			<button class="btn text-center" data-dismiss="modal" aria-hidden="true"><spring:message code="homepage.ok" /></button>
		</div>
	</div>
	
	<div id="modal-MMplayer_1" Class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="false" data-keyboard="true" data-backdrop="static" style="width:50%;">
		<div class="modal-body">
		<h4>
		<spring:message code="Exam.instruction.checkAudiodeviceModal" /></h4>
		</div>
		<div class="modal-body">		
				<div id="MMplayer_1" data-mediamode="exam" data-mediatype="audio" data-mediaurl="<c:url value="../resources/images/sampleaudio.mp3"></c:url>" data-mediaext="mp3" data-medialoadonready="false" data-mediatitle="<spring:message code="Instruction.player.title"></spring:message>"></div>
			
		</div>
		<div class="modal-footer" style="text-align: center;">
			<button id="AudioOk"class="btn btn-green text-center" data-dismiss="modal" aria-hidden="true" disabled><spring:message code="Exam.instruction.audioOK" /></button>
			<button id="AudioNotOk"class="btn btn-red text-center" data-dismiss="modal" aria-hidden="true" disabled><spring:message code="Exam.instruction.audioNotOK" /></button>
		</div>
	</div>
	<div id="microphoneAlertModal" class="modal hide fade in " style="display: none;" >
		<div class="modal-body">
			<span id="alertSpanMicrophone"></span>
		</div>
		<div class="modal-footer">		
			<button class="btn" data-dismiss="modal" aria-hidden="true"><spring:message code="Exam.modal.OK" /></button>		
		</div>	
	</div>
	<script type="text/javascript">
		var isRIFORMItem = $('#isRIFORMItem').val() == 'true' ? true : false; 
	</script>
</body>
</html>
