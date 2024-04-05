<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html>
<html lang="en">
<spring:theme code="flag" var="langflag" />
<head>
<title><spring:message code="Exam.Title" /></title>
<link rel="stylesheet"
	href="<c:url value='/resources/style/template_darkmode.css'></c:url>"
	type="text/css" />
    
<style>

.CamVideo-area {
	margin: 0 auto;
	text-align: center;
}

.redText {
	padding: 5px 38px;
}

.Div_camPrcd {
	margin-left: 42%;
}
</style>
</head>

<body class="exampage">
	<!--
<script src="https://cdn.jsdelivr.net/npm/@tensorflow/tfjs"></script>
<script src="https://cdn.jsdelivr.net/npm/@tensorflow/tfjs-backend-wasm/dist/tf-backend-wasm.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@tensorflow-models/blazeface"></script>
<script src="https://cdn.jsdelivr.net/npm/@tensorflow-models/coco-ssd"></script>
-->

	<!-- TO GET AN EXACT/STATIC VERSION (RECOMMENDED) -->
	<script
		src="https://cdn.jsdelivr.net/npm/@tensorflow/tfjs@4.2.0/dist/tf.min.js"
		integrity="sha256-J9iK/e7dz7abCBHQvsXk9N47NKMDpSb+d/pnOpF3DsA="
		crossorigin="anonymous"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/@tensorflow/tfjs-backend-wasm@4.2.0/dist/tf-backend-wasm.min.js"
		integrity="sha256-p3xSYmQa5utn/f7we2s/lNE348lF3fonR7p0V+gfVw4="
		crossorigin="anonymous"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/@tensorflow-models/blazeface@0.0.7/dist/blazeface.min.js"
		integrity="sha256-+A2N5er2W+y5eq5LwiwA6KCQNp4Tf0IUfPNwyYtvm+o="
		crossorigin="anonymous"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/@tensorflow-models/coco-ssd@2.2.2/dist/coco-ssd.min.js"
		integrity="sha256-37b6iXyjQMu0EPoWyZUb5jgAirPcOddX0kPWjxBEMFs="
		crossorigin="anonymous"></script>

	<script src="<c:url value='/resources/js/md5_encrypt.js'></c:url>"></script>
	<script src="<c:url value='/resources/js/piexif.js'></c:url>"></script>
	<script src="<c:url value='/resources/js/Timer.js?${jsTime }'></c:url>"></script>
	<script src="<c:url value='/resources/js/exam.js?${jsTime }'></c:url>"></script>
	<script
		src="<c:url value='/resources/js/RestrictActions.js?${jsTime }'></c:url>"></script>
	<script
		src="<c:url value='/resources/js/scientificCalc.js?${jsTime }'></c:url>"></script>
	<script
		src="<c:url value='/resources/js/DraggableCalculator.js?${jsTime }'></c:url>"></script>
	<script
		src="<c:url value='/webjars/sockjs-client/1.5.1/sockjs.min.js'></c:url>"></script>
	<script
		src="<c:url value='/webjars/stomp-websocket/2.3.4/stomp.min.js'></c:url>"></script>
	<script
		src="<c:url value='/resources/js/ws_cand.js?${jsTime }'></c:url>"></script>
	<script
		src="<c:url value='/resources/js/voiceRecorder.js?${jsTime }'></c:url>"></script>

	<input type="hidden" id="isPRTItem" name="isPRTItem">
	<input type="hidden" id="testType" value="solo" />
	<input type="hidden" id="anscnt" name="anscnt" value="0" />
	<input type="hidden" id="langflag" name="langflag" value="${langflag}" />
	<div id="quesChangeModal" class="modal hide fade in examModal"
		style="display: none;" data-keyboard="true" data-backdrop="static">
		<div class="modal-body">
			<p id="quesChangeModalText"></p>
		</div>
		<div class="modal-footer">
			<a id="quesChangeModalYes" data-item="0" data-subitem="0"
				class="btn btn-red"><spring:message
					code="Exam.QuesChange.ModelYesBtn" /></a> <a class="btn btn-success"
				data-dismiss="modal"><spring:message
					code="Exam.QuesChange.ModelNoBtn" /></a>
		</div>
	</div>
	<input type="hidden" id="ins_confirmlan"
		value="<spring:message code="instruction.confirmlan" />">
	<input type="hidden" id="AttemptWithoutSaving"
		value="<spring:message code="Exam.AttemptWithoutSaving" />">
	<input type="hidden" id="EndTestWithoutSaving"
		value="<spring:message code="Exam.EndTestWithoutSaving" />">
	<input type="hidden" id="SoloEndConfirm"
		value="<spring:message code="Exam.SoloEndConfirm" />">
	<input type="hidden" id="GroupEndTest"
		value="<spring:message code="Exam.GroupEndTest" />">
	<input type="hidden" id="NotAnswered"
		value="<spring:message code="Exam.NotAnswered" />">
	<input type="hidden" id="Marked"
		value="<spring:message code="Exam.Marked" />">
	<input type="hidden" id="Answered"
		value="<spring:message code="Exam.Answered" />">
	<input type="hidden" id="PartiallyAnswered"
		value="<spring:message code="Exam.PartiallyAnswered" />">
	<input type="hidden" id="SelectOption"
		value="<spring:message code="Exam.SelectOption" />">
	<input type="hidden" id="inputLimit"
		value="<spring:message code="Exam.inputLimit" />">
	<input type="hidden" id="SelectMTC_SQ"
		value="<spring:message code="Exam.SelectMTC_SQ" />">
	<input type="hidden" id="SelectEC_EW"
		value="<spring:message code="Exam.SelectEC_EW" />">
	<input type="hidden" id="EW_FileTypeNotAllowed"
		value="<spring:message code="Exam.EW_FileTypeNotAllowed" />">
	<input type="hidden" id="EW_FileSizeExceed"
		value="<spring:message code="Exam.EW_FileSizeExceed" />">
	<input type="hidden" id="EW_FileUploadingFailed"
		value="<spring:message code="Exam.EW_FileUploadingFailed" />">
	<input type="hidden" id="SelectHS"
		value="<spring:message code="Exam.SelectHS" />">
	<input type="hidden" id="SelectConfLevel"
		value="<spring:message code="Exam.SelectConfLevel" />">
	<input type="hidden" id="resetConfirmMsg"
		value="<spring:message code="Exam.Reset.Modal.Message" />">
	<input type="hidden" id="resetYesButton"
		value="<spring:message code="Exam.Reset.Model.YesButton" />">
	<input type="hidden" id="resetNoButton"
		value="<spring:message code="Exam.Reset.Model.NoButton" />">
	<input type="hidden" id="AllowAnswerUpdate"
		value="${sessionScope.exampapersetting.allowAnswerUpdate}">
	<input type="hidden" id="includesSubItems"
		value="${sessionScope.exampapersetting.includesSubItems}">
	<input type="hidden" id="autoSaveItem" name="autoSaveItem"
		value="${sessionScope.exampapersetting.autoSaveItem}" />
	<input type="hidden" id="mediaRepeatCount" name="mediaRepeatCount"
		value="${sessionScope.exampapersetting.mediaRepeatCount}" />
	<input type="hidden" id="palletFwdOnly" name="palletFwdOnly"
		value="${sessionScope.exampapersetting.palletFwdOnly}" />
	<input type="hidden" id="replaceNotAttemptedQ"
		name="replaceNotAttemptedQ"
		value="${sessionScope.exampapersetting.replaceNotAttemptedQ}" />
	<input type="hidden" id="showWatermark" name="showWatermark"
		value="${sessionScope.exampapersetting.showWatermark}" />
	<input type="hidden" id="stayOnSameQ"
		value="<spring:message code="Exam.modal.stayOnSameQ" />">
	<input type="hidden" id="ProceedToNextQ"
		value="<spring:message code="Exam.modal.ProceedToNextQ" />">
	<input type="hidden" id="Partialsolve"
		value="<spring:message code="Exam.Partialsolve" />">
	<input type="hidden" id="SectionCmplt"
		value="<spring:message code="Exam.SectionCmplt" />">
	<input type="hidden" id="sectionRequired" name="sectionRequired"
		value="${paper.isSectionRequired}" />
	<input type="hidden" id="hidRecordedFileName"
		name="hidRecordedFileName"
		value="${candidate.userName }_${paper.code}" />
	<input type="hidden" id="PartialsolveFIB"
		value="<spring:message code="Exam.PartialsolveFIB" />">
	<input type="hidden" id="EW_exceededAllowedLimit"
		value="<spring:message code="Exam.EW_exceededAllowedLimit" /> ${longAnswerMaxNoOfFilesAllowed } files">

	<input type="hidden" id="vc" value="${ec.examVenueCode }">
	<input type="hidden" id="vi" value="${ec.examVenueID }">
	<input type="hidden" id="cc"
		value="${candidate.mkclIdentificationNumber }">
	<input type="hidden" id="ci" value="${candidate.userID }">
	<input type="hidden" id="pi" value="${paper.paperID }">
	<input type="hidden" id="ei" value="${examEvent.examEventID }">
	<input type="hidden" id="evurl" value="${evurl }">
	<input type="hidden" id="ceid"
		value="${candidateExam.candidateExamID }">
	<input type="hidden" id="screenShotCaptureInterval"
		value="${examClientConfig.screenShotCaptureInterval }" />
	<input type="hidden" id="cameraCompulsory"
		value="${examClientConfig.cameraCompulsory }" />
	<input type="hidden" id="captureScreenShot" name="captureScreenShot"
		value="${examClientConfig.captureScreenShot }" />
	<input type="hidden" id="captureCameraImage" name="captureCameraImage"
		value="${examClientConfig.captureCameraImage }" />
	<input type="hidden" id="deviceId" name="deviceId" value="" />
	<input type="hidden" id="cameraImageCaptureInterval"
		name="cameraImageCaptureInterval"
		value="${examClientConfig.cameraImageCaptureInterval }" />
	<input type="hidden" id="isProctored" name="isProctored"
		value="${examClientConfig.isProctored}" />
	<input type="hidden" id="isVoiceRecordingEnabled"
		name="isVoiceRecordingEnabled"
		value="${examClientConfig.isVoiceRecordingEnabled}" />
	<input type="hidden" id="isIDCardRequired" name="isIDCardRequired"
		value="${examClientConfig.isIDCardRequired}" />
	<input type="hidden" id="audioRecordingTimeInterval"
		value="${audioRecordingTimeInterval}" />
	<input type="hidden" id="evidencePackageType"
		value="${examClientConfig.examEventEvidenceConfigurationType.ordinal()}" />
	<input type="hidden" id="uid" value="${uid }">
	<input type="hidden" id="room" value="${room }">
	<input type="hidden" id="wspoint" value="${wspoint }">
	<input type="hidden" id="longAnswerAllowedFileTypes"
		value="${longAnswerAllowedFileTypes }">
	<input type="hidden" id="longAnswerMaxFileSize"
		value="${longAnswerMaxFileSize }">
	<input type="hidden" id="longAnswerMaxNoOfFilesAllowed"
		value="${longAnswerMaxNoOfFilesAllowed }">
	<!-- Piyusha -->
	<input type="hidden" id="csresolution" value="${camshotResolution}">
	<input type="hidden" id="ssresolution" value="${screenshotResolution}">
	<input type="hidden" id="showMultiFaceNoFacePopup"
		value="${showMultiFaceNoFacePopup}">
	<input type="hidden" id="onSkipWarningMsg"
		value="<spring:message code="Exam.onSkipWarningMsg" />">
	<input type="hidden" id="NoFaceWarningMsg"
		value="<spring:message code="Exam.NoFaceWarningMsg" />">
	<input type="hidden" id="MultiFaceWarningMsg"
		value="<spring:message code="Exam.MultiFaceWarningMsg" />">
	<input type="hidden" id="isDarkModeOn" value="${isDarkModeOn}">
	<!-- RahulP -->
	<input type="hidden" id="cameraAndPosition"
		value="<spring:message code="candidateInstruction.cameraAndPosition"/>">
	<input type="hidden" id="holdId"
		value="<spring:message code="candidateInstruction.holdId"/>">
	<input type="hidden" id="screenSharing"
		value="<spring:message code="candidateInstruction.screenSharing"/>">
	<input type="hidden" id="examEnvironment"
		value="<spring:message code="candidateInstruction.examEnvironment"/>">
	<input type="hidden" id="evidenceURL"
		value="<spring:message code="candidateInstruction.evidenceURL"/>">
	<input type="hidden" id="webCamMust"
		value="<spring:message code="candidateInstruction.webCamMust"/>">
	<input type="hidden" id="webCamReconnect"
		value="<spring:message code="candidateInstruction.webCamReconnect"/>">
	<input type="hidden" id="browserAllowToCamera"
		value="<spring:message code="candidateInstruction.browserAllowToCamera"/>">
	<input type="hidden" id="webCamDisconnectedDuetoHalted"
		value="<spring:message code="candidateInstruction.webCamDisconnectedDuetoHalted"/>">
	<input type="hidden" id="internalBrowserError"
		value="<spring:message code="candidateInstruction.internalBrowserError"/>">
	<input type="hidden" id="staticImageShows"
		value="<spring:message code="candidateInstruction.staticImageShows"/>">
	<input type="hidden" id="awayFromExam"
		value="<spring:message code="candidateInstruction.awayFromExam"/>">
	<input type="hidden" id="ifScreenSharingStop"
		value="<spring:message code="candidateInstruction.ifScreenSharingStop"/>">
	<input type="hidden" id="screenSharingStop"
		value="<spring:message code="candidateInstruction.screenSharingStop"/>">
	<input type="hidden" id="noFaceDetected"
		value="<spring:message code="candidateInstruction.noFaceDetected"/>">
	<input type="hidden" id="candAndSupervisorImageTogether"
		value="<spring:message code="candidateInstruction.candAndSupervisorImageTogether"/>">
	<input type="hidden" id="moreThanTwoFaceDetected"
		value="<spring:message code="candidateInstruction.moreThanTwoFaceDetected"/>">
	<input type="hidden" id="candCapturedImg"
		value="<spring:message code="candidateInstruction.candCapturedImg"/>">
	<input type="hidden" id="imgCapturedSuccessfully"
		value="<spring:message code="candidateInstruction.imgCapturedSuccessfully"/>">
	<input type="hidden" id="candIdCaptured"
		value="<spring:message code="candidateInstruction.candIdCaptured"/>">
	<input type="hidden" id="idCardCapturedSuccessfully"
		value="<spring:message code="candidateInstruction.idCardCapturedSuccessfully"/>">
	<input type="hidden" id="retakeId"
		value="<spring:message code="candidateInstruction.retakeId"/>">
	<input type="hidden" id="allowScreenSharing"
		value="<spring:message code="candidateInstruction.allowScreenSharing"/>">
	<input type="hidden" id="reCaptureImg"
		value="<spring:message code="candidateInstruction.reCaptureImg"/>">
	<input type="hidden" id="imgCaptured"
		value="<spring:message code="candidateInstruction.imgCaptured"/>">
	<input type="hidden" id="microphoneCompulsory"
		value="<spring:message code="instruction.microphoneCompulsory"/>">
	<!-- RahulP -->
	<input type="hidden" id="partnerId" value="${partnerId}" />
	<input type="hidden" id="refKey1" value="" />
	<input type="hidden" id="refKey2" value="" />
	<input type="hidden" id="refKey3" value="" />
	<input type="hidden" id="refKey4" value="" />
	<input type="hidden" id="refKey5" value="" />
	<input type="hidden" id="refKey6" value="" />
	<input type="hidden" id="refKey7" value="" />
	<input type="hidden" id="refKey8" value="" />
	<input type="hidden" id="refKey9" value="" />
	<input type="hidden" id="refKey10" value="" />


	<span id="waterMarkTxt" style="font: 20px arial; display: none;">${candidate.userName }</span>
	<div id="endTestConfirmModal" class="modal hide fade in examModal"
		style="display: none;">
		<div class="modal-header">
			<a class="close" data-dismiss="modal">x</a>
			<h3>
				<spring:message code="Exam.Modal.ConfrimEndTest" />
			</h3>
		</div>
		<div class="modal-body">
			<p id="endTestConfirmTest"></p>
			<label id="pleasewaiteld" style="display: none;"><spring:message
					code="Exam.Pleasewaitwhileprocessing" /></label>
			<iframe src=""
				style="display: none; margin: 0 0 0 0; width: 100%; border: none; height: 140px !important;"
				id="verifypswIframe"></iframe>
		</div>
		<div class="modal-footer">
			<c:if
				test="${sessionScope.exampapersetting.supervisorPwdEndExam==false and sessionScope.exampapersetting.candidatePwdtoEnd==false}">
				<a id="submitTestBeforetimesUp" href="../endexam/FrmendTestGet"
					class="btn btn-success"><spring:message code="Exam.Yes" /></a>
			</c:if>
			<c:if
				test="${sessionScope.exampapersetting.supervisorPwdEndExam==true or sessionScope.exampapersetting.candidatePwdtoEnd==true}">
				<a class="btn btn-success" id="askforpswGet"><spring:message
						code="Exam.Yes" /></a>
				<a class="btn btn-success" id="askforpswPost" style="display: none;"><spring:message
						code="Exam.Yes" /></a>
				<a id="submitTestBeforetimesUp" href="../endexam/FrmendTestGet"></a>
			</c:if>
			<%-- <a class="btn" data-dismiss="modal"><spring:message code="Exam.Modal.close" /></a> --%>
			<a class="btn endTestConfirmModalClose"><spring:message
					code="Exam.No" /></a>
		</div>
	</div>
	<form:form action="../endexam/FrmendTest" method="post" id="frmendTest">
		<div id="camPage" style="margin: 20px 20px 0px 20px; display: none;">

			<div class="span12" style="padding: 0px 70px;">
				<table class="table table-bordered table-complex">
					<tbody>
						<tr>
							<td style="text-align: center; vertical-align: middle;"
								class="profileimage"><c:choose>
									<c:when
										test="${sessionScope.user.venueUser[0]!= null && fn:length(sessionScope.user.venueUser[0].userPhoto) > 0}">
										<img style="max-height: 140px; max-width: 150px;"
											src="${imgPath}${sessionScope.user.venueUser[0].userPhoto}">
									</c:when>
									<c:otherwise>
										<img style="max-height: 140px; max-width: 150px;"
											src="${imgPath}<spring:message code="instruction.defaultPhoto"/>">
									</c:otherwise>
								</c:choose></td>

							<td style="font-size: 14px">
								<div
									style="font-size: 25pt; word-wrap: break-word; line-height: 40px;"
									class="heading">${sessionScope.user.venueUser[0].firstName}&nbsp;${sessionScope.user.venueUser[0].middleName}&nbsp;${sessionScope.user.venueUser[0].lastName}</div>

								<div style="display: inline-block;" class="vtext">
									<spring:message code="auth.UserName"></spring:message>
								</div>
								<div style="display: inline-block;" class="vtext">
									<b>${sessionScope.user.venueUser[0].userName}</b>
								</div> <br />

								<div style="display: inline-block;" class="vtext">
									<spring:message code="auth.EventName"></spring:message>
								</div>
								<div style="display: inline-block;" class="vtext">
									<b>${sessionScope.user.examEvent.name}</b>
								</div>

							</td>
						</tr>
					</tbody>
				</table>
			</div>





			<c:set value="1" var="msg_id"></c:set>
			<c:choose>
				<c:when
					test="${examClientConfig.captureScreenShot && examClientConfig.captureCameraImage && examClientConfig.cameraCompulsory}">
					<c:set value="1" var="msg_id"></c:set>
				</c:when>
				<c:when
					test="${examClientConfig.captureScreenShot && examClientConfig.captureCameraImage && !examClientConfig.cameraCompulsory}">
					<c:set value="2" var="msg_id"></c:set>
				</c:when>
				<c:when
					test="${examClientConfig.captureScreenShot && !examClientConfig.captureCameraImage}">
					<c:set value="3" var="msg_id"></c:set>
				</c:when>
				<c:when
					test="${(!examClientConfig.captureScreenShot && examClientConfig.captureCameraImage && examClientConfig.cameraCompulsory)}">
					<c:set value="4" var="msg_id"></c:set>
				</c:when>
				<c:when
					test="${!examClientConfig.captureScreenShot && examClientConfig.captureCameraImage && !examClientConfig.cameraCompulsory}">
					<c:set value="4" var="msg_id"></c:set>
				</c:when>
			</c:choose>
			<div style="padding: 0px 72px;">
				<p id="CamDis1">
					<spring:message code="instruction.cam_scr_desc${msg_id }" />
				</p>
			</div>

			<div id="agreeEvDiv" class="span11 redText">
				<input type="checkbox" id="cbCam" />
				<spring:message code="instruction.desclaim${msg_id }" />
				<br>

				<p id="CamDis2">
					<spring:message code="instruction.selCam" />
				</p>
			</div>
			<div class="span11" style="margin-bottom: 3px; margin-left: 143px;">
				<div class="span3" style="float: left;">
					<div id="caphold"
						style="color: black; font-weight: 600; font-size: 15px; margin-top: 11px; text-align: center">
						<spring:message code="candidateInstruction.candCapturedImg" />
					</div>
					<div id="capImg"
						style="border: 1px solid; border-color: #d76616; width: 317px; height: 237px; margin-top: 23px;">
						<img src="" style="width: 315px; height: 235px; display: none;">
					</div>
					<span id="cmsg"
						style="color: green; display: none; font-weight: 600; font-size: 13px;"><spring:message
							code="candidateInstruction.imgCapturedSuccessfully" /></span>
				</div>

				<div class="span5"
					style="float: left; margin: 0 auto; text-align: center;">
					<c:choose>
						<c:when
							test="${examClientConfig.captureScreenShot && !examClientConfig.captureCameraImage}">
							<br />
						</c:when>
						<c:otherwise>
							<div id="CamSrcDiv" class="select-area" style="margin-top: 8px;">
								<select id="videoSource" style="width: 320px;"></select>
							</div>
							<div id="vidDiv" class="CamVideo-area">
								<video autoplay muted playsinline id="previewCam"
									class="video-area" onplaying="onPreviewStreamStarted()"
									style="width: 317px; height: 237px;"></video>
								<img id="faceMaskOverlay"
									src="../resources/images/cam_person_overlay.png"
									class="faceMaskOverlay">
							</div>
						</c:otherwise>
					</c:choose>

				</div>



				<c:if test="${examClientConfig.isIDCardRequired==true}">
					<div class="span3" style="float: left; margin-left: -16px;">
						<div id="idhold"
							style="color: black; font-weight: 600; font-size: 15px; text-align: center; margin-top: 11px;">
							<spring:message code="candidateInstruction.candIdCaptured" />
						</div>
						<div id="capId"
							style="border: 1px solid; border-color: #d76616; width: 317px; height: 237px; margin-top: 23px;">
							<img src="" style="width: 315px; height: 235px; display: none;">
						</div>
						<span id="imsg"
							style="color: green; display: none; font-weight: 600; font-size: 13px;"><spring:message
								code="candidateInstruction.idCardCapturedSuccessfully" /></span>
					</div>
				</c:if>
			</div>
			<div class="Div_camPrcd">
				<button type="button" class="btn btn-blue" name="takeCE" id="takeCE">
					<spring:message code="candidateInstruction.imgCaptured" />
				</button>
				<button type="button" class="btn btn-blue" name="takeID" id="takeID"
					style="display: none">
					<spring:message code="candidateInstruction.retakeId" />
				</button>
				<a id="camPrcd" disabled="disabled" class="btn btn-blue" href=""
					style="margin-right: 12px;">Proceed</a>
			</div>
		</div>
		<div id="examPage" style="display: none;">
			<div class="span3">
				<div class="holder">
					<div class="profile-timer">
						<c:choose>
							<c:when
								test="${fn:length(candidate.userPhoto) > 0 && fn:startsWith(candidate.userPhoto, 'http')}">
								<div class="dp">
									<img style="max-height: 75px;" src="${candidate.userPhoto}">
								</div>
							</c:when>
							<c:when test="${fn:length(candidate.userPhoto) > 0}">

								<div class="dp">
									<img style="max-height: 75px;"
										src="${imgPath}${candidate.userPhoto}">
								</div>
							</c:when>

							<c:otherwise>
								<div class="dp">
									<img style="max-height: 75px;"
										src="${imgPath}<spring:message code="instruction.defaultPhoto"/>">
								</div>
							</c:otherwise>
						</c:choose>
						<div id="evidencePreview" class="dp">
							<video autoplay muted playsinline id="livecam"
								style="width: 90px" onplaying="onLiveStreamStarted()"></video>
							<div id="upldArea" style="display: none;"></div>
						</div>

						<video id="videoScreen" style="display: none;" autoplay
							onplaying="onScreenSharingStarted()"></video>

						<div id="upldAreaScreenShot" style="display: none;"></div>

						 <spring:message code="Exam.TimeRemaining" />
						<span id="time-text"></span> 
						<!-- Start by harshadd -->
						<input type="hidden" id="endExamEnablePercentage"
							name="endExamEnablePercentage"
							value="${sessionScope.exampapersetting.endTestEnablePercentage}" />
						<!-- End by Harshadd-->

						<input type="hidden" id="hidTtlDuration" value="${paper.duration}" />
						<input type="hidden" id="hidelapsedTimeDuration" value="${candidateExam.elapsedTime}" /> 
					    <input type="hidden" id="timeLeft" value="${timeLeft}" /> 
						<input type="hidden" id="updateElapsedTime" value="${updateElapsedTime}" /> <span></span>
					</div>
					<div style="padding: 0px 8px; margin-bottom: 4px;" class="totalq">
						<spring:message code="Exam.Username" />
						<b>${candidate.userName }</b>
					</div>
					<div class="totalq">
						<c:if test="${paper.isSectionRequired}">
							<span id="secName" style="font-weight: bold;"></span>
							<br />
							<hr>
						</c:if>
						<c:choose>
							<c:when
								test="${sessionScope.exampapersetting.includesSubItems == false}">
								<spring:message code="Exam.TotalnumberofQuestions" /> : <strong
									id="ttlcount">${fn:length(candidateItemAssociations)}</strong>
							</c:when>
							<c:otherwise>
								<spring:message code="Exam.TotalnumberofMainQuestions" /> : <strong
									id="ttlcount">${fn:length(candidateItemAssociations)}</strong>
								<br />
								<spring:message code="Exam.TotalnumberofQuestions" /> : <strong
									id="ttlSubcount">${fn:length(candidateItemAssociations)}</strong>
							</c:otherwise>
						</c:choose>
						<hr>
						<div class="legend">
							<span class="attempted"><span id="Cntans"
								class="btn btn-greener"></span> <spring:message
									code="Exam.Answered" />
									</span> <span class="current"><span
								id="CntNans" class="btn btn-red"></span> <spring:message
									code="Exam.NotAnswered" /></span>
									
									 <span class="unattempted"><span
								id="Cntntvisited" class="btn"></span> <spring:message
									code="Exam.NotVisited" /></span>
									
							<c:if test="${sessionScope.exampapersetting.includesSubItems}">
								<span class="current"><span id="CntPattempt"
									class="btn btn-dblue"></span> <spring:message
										code="Exam.PartiallyAnswered" /></span>
							</c:if>
						</div>
					</div>
					<div class="palette">
						<div class="quick-ques">
							<c:forEach items="${candidateItemAssociations}"
								var="candidateItemAssociation" varStatus="i">
								<c:if
									test="${candidateItemAssociation.itemStatus == 'NoStatus'}">
									<c:choose>
										<c:when test="${candidateItemAssociation.object == 0}">
											<a data-qid="${candidateItemAssociation.fkItemID}"
												data-type="${candidateItemAssociation.item.itemtype }"
												data-fwdlk="0"
												data-section="${candidateItemAssociation.fkSectionID }"
												data-status="nostatus"
												data-subcnt="${candidateItemAssociation.object}"
												class="btn ${candidateItemAssociation.isMarkedForReview ? 'forreview' : '' }"
												id="lnk${candidateItemAssociation.fkItemID}" href="">${candidateItemAssociation.itemSequenceNumber}</a>
										</c:when>
										<c:otherwise>
											<a data-qid="${candidateItemAssociation.fkItemID}"
												data-type="${candidateItemAssociation.item.itemtype }"
												data-fwdlk="0"
												data-section="${candidateItemAssociation.fkSectionID }"
												data-status="nostatus"
												data-subcnt="${candidateItemAssociation.object}"
												class="btn round ${candidateItemAssociation.isMarkedForReview ? 'forreview' : '' }"
												id="lnk${candidateItemAssociation.fkItemID}" href="">${candidateItemAssociation.itemSequenceNumber}</a>
										</c:otherwise>
									</c:choose>
								</c:if>
								<c:if
									test="${candidateItemAssociation.itemStatus == 'NotAnswered' or candidateItemAssociation.itemStatus == 'Skipped'}">
									<c:choose>
										<c:when test="${candidateItemAssociation.object == 0}">
											<a data-qid="${candidateItemAssociation.fkItemID}"
												data-type="${candidateItemAssociation.item.itemtype }"
												data-fwdlk="0"
												data-section="${candidateItemAssociation.fkSectionID }"
												data-status="noans"
												data-subcnt="${candidateItemAssociation.object}"
												class="btn btn-red ${candidateItemAssociation.isMarkedForReview ? 'forreview' : '' }"
												id="lnk${candidateItemAssociation.fkItemID}" href="">${candidateItemAssociation.itemSequenceNumber}</a>
										</c:when>
										<c:otherwise>
											<a data-qid="${candidateItemAssociation.fkItemID}"
												data-type="${candidateItemAssociation.item.itemtype }"
												data-fwdlk="0"
												data-section="${candidateItemAssociation.fkSectionID }"
												data-status="noans"
												data-subcnt="${candidateItemAssociation.object}"
												class="btn btn-red round ${candidateItemAssociation.isMarkedForReview ? 'forreview' : '' }"
												id="lnk${candidateItemAssociation.fkItemID}" href="">${candidateItemAssociation.itemSequenceNumber}</a>
										</c:otherwise>
									</c:choose>
								</c:if>
								<c:if
									test="${candidateItemAssociation.itemStatus == 'Answered'}">
									<c:choose>
										<c:when test="${candidateItemAssociation.object == 0}">
											<a data-qid="${candidateItemAssociation.fkItemID}"
												data-type="${candidateItemAssociation.item.itemtype }"
												data-fwdlk="0"
												data-section="${candidateItemAssociation.fkSectionID }"
												data-status="ans"
												data-subcnt="${candidateItemAssociation.object}"
												class="btn btn-greener ${candidateItemAssociation.isMarkedForReview ? 'forreview' : '' }"
												id="lnk${candidateItemAssociation.fkItemID}" href="">${candidateItemAssociation.itemSequenceNumber}</a>
										</c:when>
										<c:otherwise>
											<a data-qid="${candidateItemAssociation.fkItemID}"
												data-type="${candidateItemAssociation.item.itemtype }"
												data-fwdlk="0"
												data-section="${candidateItemAssociation.fkSectionID }"
												data-status="ans"
												data-subcnt="${candidateItemAssociation.object}"
												class="btn btn-greener round ${candidateItemAssociation.isMarkedForReview ? 'forreview' : '' }"
												id="lnk${candidateItemAssociation.fkItemID}" href="">${candidateItemAssociation.itemSequenceNumber}</a>
										</c:otherwise>
									</c:choose>
								</c:if>
								<c:if
									test="${sessionScope.exampapersetting.includesSubItems or  candidateItemAssociation.item.itemtype == 'NFIB'}">
									<c:choose>
										<c:when
											test="${candidateItemAssociation.itemStatus == 'PartiallyAnswered' && (candidateItemAssociation.item.itemtype == 'MP' or candidateItemAssociation.item.itemtype == 'NFIB')}">
											<a data-qid="${candidateItemAssociation.fkItemID}"
												data-type="${candidateItemAssociation.item.itemtype }"
												data-fwdlk="0"
												data-section="${candidateItemAssociation.fkSectionID }"
												data-status="parans"
												data-subcnt="${candidateItemAssociation.object}"
												class="btn btn-dblue ${candidateItemAssociation.isMarkedForReview ? 'forreview' : '' }"
												id="lnk${candidateItemAssociation.fkItemID}" href="">${candidateItemAssociation.itemSequenceNumber}</a>
										</c:when>
										<c:when
											test="${candidateItemAssociation.itemStatus == 'PartiallyAnswered'}">
											<a data-qid="${candidateItemAssociation.fkItemID}"
												data-type="${candidateItemAssociation.item.itemtype }"
												data-fwdlk="0"
												data-section="${candidateItemAssociation.fkSectionID }"
												data-status="parans"
												data-subcnt="${candidateItemAssociation.object}"
												class="btn round btn-dblue ${candidateItemAssociation.isMarkedForReview ? 'forreview' : '' }"
												id="lnk${candidateItemAssociation.fkItemID}" href="">${candidateItemAssociation.itemSequenceNumber}</a>
										</c:when>
										<c:otherwise>

										</c:otherwise>
									</c:choose>
								</c:if>
							</c:forEach>
						</div>
						<div class="actions">

							<c:if test="${sessionScope.exampapersetting.showViewQP}">
								<button class="btn btn-green" type="button"
									onclick="return showQuestionPaper(event)">
									<spring:message code="Exam.ViewQP" />
								</button>
							</c:if>
							<c:if test="${sessionScope.exampapersetting.showProfile}">
								<button class="btn btn-green" type="button"
									onclick="return showProfile(event)">
									<spring:message code="Exam.Profile" />
								</button>
							</c:if>
							<c:if
								test="${sessionScope.exampapersetting.showScientificCalculator}">
								<button class="btn btn-green" type="button" data-toggle="modal"
									data-target="#scientificCalc">
									<spring:message code="Exam.Profile" />
									Calculator
								</button>
							</c:if>
							<c:if test="${sessionScope.exampapersetting.showInstruction}">
								<button class="btn btn-green" type="button"
									onclick="return showInstruction(event)">
									<spring:message code="Exam.Instructions" />
								</button>
							</c:if>
							<c:if test="${sessionScope.exampapersetting.showNotepad}">
								<button class="btn btn-green" type="button"
									onclick="return showNotepad(event)">Notepad</button>
							</c:if>
							<button class="btn disabled btn-red" type="button" id="endTest"
								name="endTest">
								<spring:message code="Exam.EndTest" />
							</button>
							
							
							<!-- <button class="btn btn-green" type="button" id="toggledarkmode" onclick="myFunction()">Toggle dark mode</button> -->
							<!-- Added by Piyusha -->
							<!-- <div>
											    <input type="checkbox" class="checkbox" id="checkbox">
											  <label for="checkbox" class="label">
											    <i class="fas fa-moon"></i>
											    <i class='fas fa-sun'></i>
											    <div class='ball'>
											  </label>
											</div> -->
						</div>
					</div>
				</div>
			</div> 
			<div class="span9">
				<div class="holder">
					<c:set var="secTime" value="0"></c:set>
					<c:choose>
						<c:when
							test="${paper.isSectionRequired || sessionScope.exampapersetting.includesSubItems}">
							<div
								style="margin-top: 4px; padding: 0px 8px; margin-bottom: 4px;"
								id="HdrInfoDiv" class="totalq">
								<span><spring:message code="Exam.HeaderTotalMainQuestion" /><strong
									id="Hdrttlcount">0</strong></span> <span><spring:message
										code="Exam.HeaderAnswered" /><strong id="HdrttlAnscount"
									style="color: #00af7c">0</strong></span> <span id="sct"
									style="font-size: 12px; color: black; font-weight: 600; float: right;"></span>
							</div>
						</c:when>
						<c:otherwise>
							<div
								style="margin-top: 8px; padding: 0px 8px; margin-bottom: 8px; border: 0px none; background-color: transparent;"
								id="HdrInfoDiv" class="totalq">&nbsp;</div>
						</c:otherwise>
					</c:choose>

					<c:choose>
						<c:when test="${paper.isSectionRequired }">
							<div class="sections">
						</c:when>
						<c:otherwise>
							<div class="nosections">&nbsp;</div>
							<div class="sections" style="display: none;">
						</c:otherwise>
					</c:choose>
					<c:forEach items="${paper.sectionList}" var="section">
						<c:set var="secTime" value="${secTime+ section.sectionDuration}"></c:set>
						<c:if test="${activeSec == section.sectionID}">
							<a class="btn btn-lblue" data-lk="0"
								data-sq=${section.sequenceNo } data-active="1"
								id="secNM${section.sectionID }" data-ID=${section.sectionID }
								data-restrict=${section.isTimeBound } data-time=${secTime }>${section.sectionName}&nbsp;<i
								class="icon-time"></i></a>
						</c:if>
						<c:if test="${activeSec != section.sectionID}">
							<a class="btn btn-lblue" data-lk="0"
								data-sq=${section.sequenceNo } data-active="0"
								id="secNM${section.sectionID }" data-ID=${section.sectionID }
								data-restrict=${section.isTimeBound } data-time=${secTime }>${section.sectionName}&nbsp;<i
								class="icon-time"></i></a>
						</c:if>
					</c:forEach>
				</div>
				<iframe src="" id="hidOperations"> </iframe>
				<iframe src="" id="hidOperations_TimeUp"> </iframe>
				<div class="questions-area">
					<label class="alert-error" id="error"></label> <label
						class="alert-success" id="lblmessage"></label> <input
						type="hidden" id="frmLink"
						value="../exam/QuestionContainer?selectedLang=${selectedLang}&secID=${activeSec}">
					<iframe src="" id="QuestionContainer" name="QuestionContainer"></iframe>
					<div id="instruction" class="scrollable">
						<div class="question">
							<b><spring:message
									code="Exam.Pleasereadthefollowinginstructionscarefully" /></b>
						</div>
						<div class="qanswer">
							<c:if test="${fn:length(instructions.intructionText) != 0}">
		                                     ${instructions.intructionText}
		                                </c:if>
							<br /> <br /> <br />
							<c:if
								test="${fn:length(instructions.importantInstructions) != 0}">
								<b>Other important instructions :</b>
		                                     ${instructions.importantInstructions}
		                                </c:if>
							<br />
							<div class="title">
								<a href="" class="BackBtn btn btn-blue"><spring:message
										code="Exam.Back" /></a>
							</div>
						</div>
					</div>
					<div id="question" class="scrollable">
						<div class="question">
							<b><spring:message code="Exam.QuestionPaper" /></b>
							<div class="pull-right">
								<a href="" class="BackBtn btn btn-blue" class="btn-primary"><spring:message
										code="Exam.Back" /></a>
							</div>
						</div>


						<div class="qanswer">
							<div class="tabbable">
								<ul class="nav nav-tabs">
									<li class="active"><a class="filterQp btn"
										data-status='all' data-toggle="tab"><spring:message
												code="Exam.AllQuestions" /></a></li>
									<li><a class="filterQp btn" data-status='ans'
										data-toggle="tab"><spring:message code="Exam.Answered" /></a></li>
									<li><a class="filterQp btn" data-status='noans'
										data-toggle="tab"><spring:message code="Exam.NotAnswered" /></a></li>
									<li><a class="filterQp btn" data-status='marked'
										data-toggle="tab"><spring:message
												code="Exam.MarkedForReview" /></a></li>
									<li><a class="filterQp btn" data-status='nostatus'
										data-toggle="tab"><spring:message code="Exam.NotVisited" /></a></li>
									<li><a class="filterQp btn" data-status='parans'
										data-toggle="tab"><spring:message
												code="Exam.PartiallyAnswered" /></a></li>
								</ul>
								<c:forEach items="${questionPaperPartialViewModels}"
									var="questionPaper" varStatus="i">
									<div id="QP${questionPaper.itemid}">
										<b><a id="frmQP${questionPaper.itemid}"
											data-qpqid="${questionPaper.itemid}" href=""></a><label
											id="qpStatus${questionPaper.itemid}"></label> :</b>
										<c:if
											test="${questionPaper.itemText != null && fn:length(questionPaper.itemText) != 0}">
											<div class="question-wrap">${questionPaper.itemText}</div>
										</c:if>
										<c:if
											test="${questionPaper.itemImage != null && fn:length(questionPaper.itemImage) != 0}">
											<img
												src="../exam/displayImage?disImg=${questionPaper.itemImage}" />
										</c:if>
										<c:if
											test="${questionPaper.multimediaType != null && questionPaper.multimediaType=='AUDIO'}">
											<div class="question-wrap">
												<spring:message code="Exam.AudioQuestionQPTxt" />
											</div>
										</c:if>
										<c:if
											test="${questionPaper.multimediaType != null && questionPaper.multimediaType=='VIDEO'}">
											<div class="question-wrap">
												<spring:message code="Exam.VideoQuestionQPTxt" />
											</div>
										</c:if>

										<c:if
											test="${questionPaper.questionPaperPartialSubViewModels != null && fn:length(questionPaper.questionPaperPartialSubViewModels) > 0}">
											<br />
											<br />
											<c:forEach
												items="${questionPaper.questionPaperPartialSubViewModels }"
												var="QPsubitem" varStatus="j">
												<div>
													<span class="QPsubitem${questionPaper.itemid }"
														class="dashboard-header"
														style="color: #338d93; font-weight: bold;">Q
														@.${j.index+1 }</span>
													<c:if
														test="${QPsubitem.itemText != null && fn:length(QPsubitem.itemText) != 0}">
														<div class="question-wrap">${QPsubitem.itemText}</div>
														<br />
													</c:if>
													<c:if
														test="${QPsubitem.itemImage != null && fn:length(QPsubitem.itemImage) != 0}">
														<img
															src="../exam/displayImage?disImg=${QPsubitem.itemImage}" />
														<br />
														<br />
													</c:if>
												</div>
											</c:forEach>

										</c:if>
										<br />
										<div class="seperator"></div>

									</div>


									<label id="filterMsg"></label>
								</c:forEach>
							</div>
							<div class="pull-right">
								<a href="" class="BackBtn btn btn-blue" class="btn-primary"><spring:message
										code="Exam.Back" /></a>
							</div>
						</div>


					</div>
					<div id="profile" style="display: none; height: 430px;">
						<div class="question">
							<b><spring:message code="Exam.CandidateProfile" /></b>
						</div>
						<div class="qanswer">
							<center>
								<table class="table table-bordered table-striped"
									style="width: 60%">
									<tr>
										<td><spring:message code="Exam.CandidateName" /></td>
										<td><c:choose>
												<c:when
													test="${candidate.firstName != null || candidate.lastName != null}">
											 			${candidate.firstName} ${candidate.lastName}
											 		</c:when>
												<c:otherwise>
													<spring:message code="Exam.NotAvailable" />
												</c:otherwise>
											</c:choose></td>
									</tr>
									<tr>
										<td><spring:message code="Exam.Username" /></td>
										<td><c:choose>
												<c:when
													test="${candidate.userName  != null && candidate.userName != ''}">
											 			${candidate.userName }
											 		</c:when>
												<c:otherwise>
													<spring:message code="Exam.NotAvailable" />
												</c:otherwise>
											</c:choose></td>
									</tr>
									<tr>
										<td><spring:message code="Exam.Email" /></td>
										<td><c:choose>
												<c:when
													test="${candidate.email  != null && candidate.email != ''}">
											 			${candidate.email }
											 		</c:when>
												<c:otherwise>
													<spring:message code="Exam.NotAvailable" />
												</c:otherwise>
											</c:choose></td>
									</tr>
									<tr>
										<td><spring:message code="Exam.Contact" /></td>
										<td><c:choose>
												<c:when
													test="${candidate.mobileNumber  != null && candidate.mobileNumber != ''}">
											 			${candidate.mobileNumber }
											 		</c:when>
												<c:otherwise>
													<spring:message code="Exam.NotAvailable" />
												</c:otherwise>
											</c:choose></td>
									</tr>
								</table>
								<div class="title">
									<a href="" class="BackBtn btn btn-blue"><spring:message
											code="Exam.Back" /></a>
							</center>
						</div>
					</div>
				</div>
			</div>
		</div>
		</div>
	</form:form>

	<div id="modalEndTest" class="modal hide fade in examModal"
		style="display: none;" data-keyboard="false" data-backdrop="static">
		<div class="modal-header"></div>
		<div class="modal-body">
			<span id="TimeUpplzWait"><spring:message
					code="Exam.modal.YourtimeisupplzWait" /></span> <span id="TimeUpproceed"><spring:message
					code="Exam.modal.Yourtimeisupproceed" /></span>
		</div>
		<div class="modal-footer">
			<a id="closemodal"
				href="../endexam/showTestResult?candidateExamID=${candidateExam.candidateExamID}&examEventID=${examEvent.examEventID }&paperID=${paper.paperID }&attemptNo=${candidateExam.attemptNo}&isTimeUp=true"
				class="btn" data-dismiss="modal" aria-hidden="true"> <spring:message
					code="Exam.modal.OK" />
			</a>
		</div>
	</div>
	<!-- Modal -->
	<div id="calculatorWrapper">
		<div id="calculatorWrapperHeader">
			<div class="modal hide fade custommodal" id="scientificCalc"
				tabindex="-1" role="dialog" aria-hidden="true" data-keyboard="false"
				data-backdrop="false">
				<div class="modal-dialog modal-dialog-centered" role="document">
					<div class="modal-content">
						<div class="modal-body">
							<%@include file="../../Common/Calculator/GateCalculator.jsp"%>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div id="notepad" style="display: none;">
		<div id="notepadHeader">
			<span><spring:message code="takeTest.spaceForNote" /></span>
		</div>
		<div id="notepadText" contenteditable="true"></div>
	</div>

	<div style="display: none;">
		<a id="BtnmodalEndTest" href="#modalEndTest" data-toggle="modal"
			data-backdrop="static"></a>
	</div>

	<!-- Simulation ItemType Only -->
	<div class="overlayS flashContentOverleyDiv" style="display: none;"></div>
	<!-- content part -->
	<div class="mainFlashContentDiv"
		style="display: none; position: fixed; top: 0.5%; left: 0.5%; z-index: 15; background-color: white; width: 99%; height: 99%;">
		<div id="simbuttons"
			style="float: right; padding-top: 1px; padding-right: 1px; padding-bottom: 5px;">
			<button class="btn btn-lblue" name="Next" id="SimNext" type="button"
				onclick="$('#QuestionContainer').get(0).contentWindow.closeModel()">
				<spring:message code="takeTest.cancel" />
			</button>
			<button class="btn btn-dblue" name="Save" id="SimSave" style=""
				type="button"
				onclick="$('#QuestionContainer').get(0).contentWindow.closewithsave()">
				<spring:message code="takeTest.save" />
				&amp;
				<spring:message code="takeTest.next" />
			</button>
		</div>
		<div id="replaceObjectTag"></div>
		<b style="font-size: 15pt;"><spring:message
				code="takeTest.question" /></b>
		<div
			style="background-color: white; padding: 2px; display: inline; font-size: 14pt;"
			id="SimqText"></div>
	</div>
	<!-- Simulation ItemType Only -->

	<div id="modal-examclientallowed" class="modal hide fade in"
		style="display: none;" data-keyboard="false" data-backdrop="static">
		<!-- <div class="modal-header">					
		</div> -->
		<div class="modal-body">
			<spring:message code="Exam.ClientRequired" />
		</div>
		<div class="modal-footer">
			<a id="closemodal" href="#" class="btn" data-dismiss="modal"
				aria-hidden="true"> <spring:message code="Exam.modal.OK" />
			</a>
		</div>
	</div>
	<div id="msgModal" class="modal hide fade in" style="display: none;">
		<!-- <div class="modal-header">
		<a class="close" data-dismiss="modal">×</a>
		<h3 id="msgModalHeaderText"></h3>
	</div> -->
		<div class="modal-body">
			<label id="msgModalBodyText"></label>
		</div>
		<div class="modal-footer">
			<a class="btn" id="MsgModalbtn1" style="display: none"></a> <a
				class="btn" id="MsgModalbtn2" style="display: none"></a>
		</div>
	</div>
	<a id="msgModalLoader" data-msgmodalbodytext="" data-footerbtn1class=""
		data-footerbtn2class=""
		data-footerbtn1text="<spring:message code="Exam.Yes" />"
		data-footerbtn2text="<spring:message code="Exam.No" />"
		data-displaymodal="off"></a>
	<div style="display: none;">
		<a id="examclientallowedBtn" href="#modal-examclientallowed"
			data-toggle="modal" data-backdrop="static"></a>
	</div>


	<div id="msgModalScreenShare" class="modal hide fade in"
		style="display: none;" data-backdrop="static" data-keyboard="false">
		<div class="modal-body">
			<label id="msgModalScreenShareBodyText"><spring:message
					code="candidateInstruction.allowScreenSharing" /></label>
		</div>
		<div class="modal-footer">
			<!-- 		<a class="btn" onclick="acceptScreenSharing();">Yes</a> -->
			<button type="button" class="btn"
				onclick="this.disabled=true; acceptScreenSharing();">
				<spring:message code="takeTest.yes" />
			</button>
			<a class="btn" onclick="denyScreenSharing();"><spring:message
					code="takeTest.no" /></a>
		</div>
	</div>

	<div id="proctorMsgModel" class="modal hide fade in"
		style="display: none;">
		<div class="modal-body">
			<label id="proctorMsgModelBodyText"></label>
		</div>
		<div class="modal-footer">
			<a type="button" id="proctorMsgModelbtn1" class="btn"
				onclick="hideMessage();"><spring:message code="takeTest.ok" /></a>
		</div>
	</div>

	<script>
		dragElement(document.getElementById(("calculatorWrapper")));
		dragElement(document.getElementById(("notepad")));
	</script>
	<script
		src="<c:url value='/resources/js/screenshot.js?${jsTime}'></c:url>"></script>
	<script src="<c:url value='/resources/js/cam.js?${jsTime}'></c:url>"
		async onload="checkConfig();"></script>
		<script>
   
</script>


</body>
</html>