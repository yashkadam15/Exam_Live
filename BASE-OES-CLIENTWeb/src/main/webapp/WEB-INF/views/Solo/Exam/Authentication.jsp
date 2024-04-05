<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style type="text/css">
a {
	cursor: pointer;
}

tab_text {
	text-transform: uppercase;
	font-weight: normal;
	font-family: Lucida Sans Unicode Lucida Grande sans-serif;
	text-shadow: 1px 1px 0 #ffffff;
	font-size: 1.071em
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

/* .webcam-section {
	padding: 5px;
} */

h4 {
	margin-top: 0px;
	margin-bottom: 0px;
}

.panel-primary {
	border-color: #031a55;
}

.table {
	margin-bottom: 0px;
	margin-top: 0px;
}

.panel {
	/* 
	-webkit-box-shadow: 0 1px 1px rgba(0, 0, 0, 0.05);
	box-shadow: 0 1px 1px rgba(0, 0, 0, 0.05);
	border-color: #428BCA;
	background-color: white; 
	border: 1px solid #DDD;*/
	border-radius: 10px;
	margin-bottom: 20px;
	padding-bottom: 0.6px;
	padding-top: 5px;
	padding-left: 110px;
	padding-right: 110px;
}

.panel-title {
	margin-top: 0;
	margin-bottom: 0;
	font-size: 17.5px;
	font-weight: 500;
}

.panel-primary .panel-heading {
	color: #c09300;
	/*background-color: #039d8f;*/
	border-color: #c09300;
}

.panel-heading {
	padding: 10px 15px;
	margin: -37px 1px 3px;
	background-color: whiteSmoke;
	border-bottom: 1px solid #DDD;
	border-top-right-radius: 12px;
	border-top-left-radius: 12px;
}

.video-area {
	width: 317px;
	height: 237px;
}

.CamVideo-area {
	width: 317px;
	border: 1px solid;
	height: 237px;
}

.redText {
	padding: 50px 0px 0px 0px;
}

.faceMaskOverlay {
  margin: 28px 0px 0px -324px !important;
  width: 312px !important;
  height: 198px !important;
}

.table th, .table td {
  padding: 4px 8px;
}
.btn.disabled, .btn[disabled] {
color: #ffffff;
background-color: #039d8f;
}
</style>
<title><spring:message code="Exam.Title" /></title>

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

<script src="<c:url value='/resources/js/piexif.js'></c:url>"></script>
<script src="<c:url value='/resources/js/md5_encrypt.js'></c:url>"></script>
</head>

<body class="exampage">
	<c:if test="${messageText!=null}">
		<div id="system-message">
			<div class="alert alert-error">
				<a class="close" data-dismiss="alert">×</a>
				<h4 class="alert-heading">
					<spring:message code="global.error"></spring:message>
				</h4>
				<div>
					<p>	${ messageText}	</p>
				</div>
			</div>
		</div>	
	</c:if>
	<input type="hidden" id="ins_confirmlan" value="<spring:message code="instruction.confirmlan" />">
	<input type="hidden" id="vc" value="${ec.examVenueCode }">
	<input type="hidden" id="vi" value="${ec.examVenueID }">
	<input type="hidden" id="cc" value="${candidate.mkclIdentificationNumber }">
	<input type="hidden" id="ci" value="${candidate.userID }">
	<input type="hidden" id="pi" value="${paperId}">
	<input type="hidden" id="ei" value="${examClientConfig.fkExamEventId }">
	<input type="hidden" id="evurl" value="${evurl }">
	<input type="hidden" id="screenShotCaptureInterval" value="${examClientConfig.screenShotCaptureInterval }"/>
	<input type="hidden" id="cameraCompulsory" value="${examClientConfig.cameraCompulsory }"/>
	<input type="hidden" id="captureScreenShot" name="captureScreenShot" value="${examClientConfig.captureScreenShot }"/>
	<input type="hidden" id="captureCameraImage" name="captureCameraImage" value="${examClientConfig.captureCameraImage }"/>
	<input type="hidden" id="deviceId" name="deviceId" value=""/>
	<input type="hidden" id="cameraImageCaptureInterval" name="cameraImageCaptureInterval" value="${examClientConfig.cameraImageCaptureInterval }"/>
	<input type="hidden" id="csresolution" value="${camshotResolution}">
	<input type="hidden" id="ssresolution" value="${screenshotResolution}">
	<input type="hidden" id="evidencePackageType" value="${examClientConfig.examEventEvidenceConfigurationType.ordinal()}"/>
	
	<!-- RahulP -->
	<input type="hidden" id="cameraAndPosition" value="<spring:message code="candidateInstruction.cameraAndPosition"/>">
	<input type="hidden" id="holdId" value="<spring:message code="candidateInstruction.holdId"/>">
	<input type="hidden" id="screenSharing" value="<spring:message code="candidateInstruction.screenSharing"/>">
	<input type="hidden" id="examEnvironment" value="<spring:message code="candidateInstruction.examEnvironment"/>">
	<input type="hidden" id="evidenceURL" value="<spring:message code="candidateInstruction.evidenceURL"/>">
	<input type="hidden" id="webCamMust" value="<spring:message code="candidateInstruction.webCamMust"/>">
	<input type="hidden" id="webCamReconnect" value="<spring:message code="candidateInstruction.webCamReconnect"/>">
	<input type="hidden" id="browserAllowToCamera" value="<spring:message code="candidateInstruction.browserAllowToCamera"/>">
	<input type="hidden" id="webCamDisconnectedDuetoHalted" value="<spring:message code="candidateInstruction.webCamDisconnectedDuetoHalted"/>">
	<input type="hidden" id="internalBrowserError" value="<spring:message code="candidateInstruction.internalBrowserError"/>">
	<input type="hidden" id="staticImageShows" value="<spring:message code="candidateInstruction.staticImageShows"/>">
	<input type="hidden" id="awayFromExam" value="<spring:message code="candidateInstruction.awayFromExam"/>">
	<input type="hidden" id="ifScreenSharingStop" value="<spring:message code="candidateInstruction.ifScreenSharingStop"/>">
	<input type="hidden" id="screenSharingStop" value="<spring:message code="candidateInstruction.screenSharingStop"/>">
	<input type="hidden" id="noFaceDetected" value="<spring:message code="candidateInstruction.noFaceDetected"/>">
	<input type="hidden" id="candAndSupervisorImageTogether" value="<spring:message code="candidateInstruction.candAndSupervisorImageTogether"/>">
	<input type="hidden" id="moreThanTwoFaceDetected" value="<spring:message code="candidateInstruction.moreThanTwoFaceDetected"/>">
	<input type="hidden" id="candCapturedImg" value="<spring:message code="candidateInstruction.candCapturedImg"/>">
	<input type="hidden" id="imgCapturedSuccessfully" value="<spring:message code="candidateInstruction.imgCapturedSuccessfully"/>">
	<input type="hidden" id="candIdCaptured" value="<spring:message code="candidateInstruction.candIdCaptured"/>">
	<input type="hidden" id="idCardCapturedSuccessfully" value="<spring:message code="candidateInstruction.idCardCapturedSuccessfully"/>">
	<input type="hidden" id="retakeId" value="<spring:message code="candidateInstruction.retakeId"/>">
	<input type="hidden" id="allowScreenSharing" value="<spring:message code="candidateInstruction.allowScreenSharing"/>">
	<input type="hidden" id="reCaptureImg" value="<spring:message code="candidateInstruction.reCaptureImg"/>">
	<input type="hidden" id="imgCaptured" value="<spring:message code="candidateInstruction.imgCaptured"/>">

<div id="msgModalCamCompulsory" class="modal hide fade in" style="display: none;" data-backdrop="static" data-keyboard="false">	
	<div class="modal-body">
		<label id="msgModalCamCompulsoryBodyText"><spring:message code="candidateInstruction.webCamMust"/></label>
	</div>
	<div class="modal-footer">
		<button type="button" class="btn btn-error" onclick="window.location.href='../candidateModule/homepage?changeLocale'">OK</button>
	</div>
</div>	
	
<div id="msgModalScreenShare" class="modal hide fade in" style="display: none;" data-backdrop="static" data-keyboard="false">	
	<div class="modal-body">
		<label id="msgModalScreenShareBodyText"><spring:message code="candidateInstruction.allowScreenSharing"/></label>
	</div>
	<div class="modal-footer">
<!-- 		<a class="btn" onclick="acceptScreenSharing();">Yes</a> -->
		<button type="button" class="btn" onclick="this.disabled=true; acceptScreenSharing();">Yes</button>
		<a class="btn" onclick="denyScreenSharing();">No</a>
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
		<a class="btn" id="MsgModalbtn1" style="display: none"></a>
		<a class="btn" id="MsgModalbtn2" style="display: none"></a>
	</div>
</div>
<a id="msgModalLoader" data-msgmodalbodytext="" data-footerbtn1class="" data-footerbtn2class="" data-footerbtn1text="<spring:message code="Exam.Yes" />" data-footerbtn2text="<spring:message code="Exam.No" />" data-displaymodal="off"></a>
<div style="display:none;"><a id="examclientallowedBtn" href="#modal-examclientallowed" data-toggle="modal" data-backdrop="static"></a></div>

<div class="panel panel-primary" style="margin-top:34px;">

              <div class="span12">
              
              	<div class="panel-heading">
			          <h4 class="panel-title" style="text-align: center">
			      		 Supervisor Authentication
			         <%-- <spring:message code="homepage.CandidateInformation" /> --%></h4>         
			     </div>
			     
			      <table class="table table-bordered table-complex">						
				<tbody>
				<tr>
				<td  style="text-align:center;vertical-align: middle;" class="profileimage">
				<c:choose>
					<c:when test="${sessionScope.user.venueUser[0]!= null && fn:length(sessionScope.user.venueUser[0].userPhoto) > 0}">
			 			<img style="max-height: 140px;max-width:150px;" src="${imgPath}${sessionScope.user.venueUser[0].userPhoto}">
					</c:when>
					<c:otherwise>
					 	<img style="max-height: 140px;max-width:150px;" src="${imgPath}<spring:message code="instruction.defaultPhoto"/>">
					</c:otherwise>
				</c:choose>
				</td>
				
				<td style="font-size: 14px">
							<div style=" font-size: 25pt;word-wrap: break-word;line-height:40px;" class="heading">${sessionScope.user.venueUser[0].firstName}&nbsp;${sessionScope.user.venueUser[0].middleName}&nbsp;${sessionScope.user.venueUser[0].lastName}</div>
							
							<div style="display: inline-block;" class="vtext">
								<spring:message code="auth.UserName"></spring:message>
												
							</div>
							<div style="display: inline-block;" class="vtext"><b>${sessionScope.user.venueUser[0].userName}</b></div>
							<br/>	
							
							<div style="display: inline-block;" class="vtext">
								<spring:message code="auth.EventName"></spring:message>
								
							</div>
							<div style="display: inline-block;" class="vtext"><b>${sessionScope.user.examEvent.name}</b></div>
							<br/>
							<div style="display: inline-block;" class="vtext">
								<spring:message code="auth.PaperName"></spring:message>								
							</div>
							<div style="display: inline-block;" class="vtext"><b>${paperNm}</b></div>
							
							</td>
							</tr>
					</tbody>
		  </table>
		  </div>
		<div class="span12" id="camPage" style="margin: 0px; display: none;">       
                <c:set value="1" var="msg_id"></c:set>
				<c:choose>
					<c:when test="${examClientConfig.captureScreenShot && examClientConfig.captureCameraImage && examClientConfig.cameraCompulsory}">
						<c:set value="1" var="msg_id"></c:set>
					</c:when>
					<c:when test="${examClientConfig.captureScreenShot && examClientConfig.captureCameraImage && !examClientConfig.cameraCompulsory}">
						<c:set value="2" var="msg_id"></c:set>
					</c:when>
					<c:when test="${examClientConfig.captureScreenShot && !examClientConfig.captureCameraImage}">
						<c:set value="3" var="msg_id"></c:set>
					</c:when>
					<c:when test="${(!examClientConfig.captureScreenShot && examClientConfig.captureCameraImage && examClientConfig.cameraCompulsory)}">
						<c:set value="4" var="msg_id"></c:set>
					</c:when>
					<c:when test="${!examClientConfig.captureScreenShot && examClientConfig.captureCameraImage && !examClientConfig.cameraCompulsory}">
						<c:set value="4" var="msg_id"></c:set>
					</c:when>
				</c:choose>
						
				<%-- <p id="CamDis1" style="padding-top:10px;">
					<spring:message code="instruction.cam_scr_desc${msg_id }" />
				</p> --%>
				<!-- <div class=" webcam-section"> -->
                <div class="span4">
                           
				<div id="agreeEvDiv" class="redText">
					<input type="checkbox" id="cbCam"/>
						<spring:message code="instruction.desclaim${msg_id }" />					
					<%-- <br>
					
					<p id="CamDis2" style="padding-top:10px;">
						<spring:message code="instruction.selCam" /></p> --%>
				</div>
            </div>
            
			<div class="span4">
				<c:choose>
					<c:when test="${examClientConfig.captureScreenShot && !examClientConfig.captureCameraImage}">
						<br/>
					</c:when>
					<c:otherwise>
						<div id="CamSrcDiv" class="select-area" style="margin-top: 8px;">
						   <select id="videoSource" style="width: 320px;"></select>
						</div>
						<div id="vidDiv" class="CamVideo-area">
							<video autoplay muted playsinline id="previewCam" class="video-area" onplaying="onPreviewStreamStarted()"></video>
							 <img id="faceMaskOverlay" src="../resources/images/cam_two_person_overlay.png" class="faceMaskOverlay">
							<div id="evidencePreview" class="dp">
						 		<div id="upldArea" style="display: none;">						 		
						 		</div>
						 	</div>
							
						</div>
					</c:otherwise>
				</c:choose>
				<video id="videoScreen" style="display:none;" autoplay ></video>
				<div id="upldAreaScreenShot" style="display:none;">	</div>
					
				<p id="CamDis2" style="padding-top:5px; text-align: center;">
                 	<button type="button" class="btn btn-blue" name="takeImgAuth" id="takeImgAuth"><spring:message code="candidateInstruction.imgCaptured"/></button> 
                	 <span id="resmsg" style="color: red;display: none;font-weight: 600;font-size: 13px;"><spring:message code="candidateInstruction.reCaptureImg"/></span>
                </p>
			</div>
			  <div class="span4">
				 <div id="capImg" style="border: 1px solid;border-color: #d76616; width: 317px; height: 237px;margin-top: 50px;text-align: center;">
				 	<img src="" style="width: 315px;height: 235px;display: none;">
				 </div>
				 <span id="smsg" style="color: green;display: none;font-weight: 600;font-size: 13px;"><spring:message code="candidateInstruction.imgCapturedSuccessfully"/></span>
			 </div>
	</div>
	
	<div class="span12" style="text-align: center; background-color: #f1f1f1; ">
		<form:form id="command" action="instruction" method="post">

			<h4>
				<spring:message code="auth.EnterSupervisorPassword"></spring:message>
				<input type="password" id="pwd" autofocus="autofocus" name="pwd" style="margin-top: 10px;" />
				<button type="submit" class="btn btn-blue" name="authBtn" id="authBtn">
					<spring:message code="EventSelection.Proceed"></spring:message>
				</button>
				<input type="hidden" id="vid" name="vid" value="${vid}" /> 
				<input type="hidden" id="paperNm" name="paperNm" value="${paperNm}" /> 
				<input type="hidden" id="pid" name="pid" value="${paperId}" /> 
				<input type="hidden" name="ispw" value="true" /> 
				<input type="hidden" value="${dcid}" name="dcid" /> 
				<input type="hidden" value="${b}" name="b" /> 
				<input type="hidden" value="${ceid}" name="ceid" />
				<input type="hidden" value="${se}" name="se" />
			</h4>
		</form:form>
	</div>
</div>
      
<script type="text/javascript">
	var seu=false;
	$(document).ready(function()
	{
		$('#takeImgAuth').click(function(e)
		{
			e.preventDefault();
			if (!$("#cbCam").is(':checked')) 
			{			
				$('#msgModalLoader').attr('data-msgmodalbodytext',$('#ins_confirmlan').val());
				$('#msgModalLoader').attr('data-footerbtn1text',"OK");
				$('#msgModalLoader').attr('data-footerbtn1class','btn btn-error');
				
			    triggerMsgLoader('on',function () 
				{    	
					triggerMsgLoader('off');
			    });
						
				return;
			}
			if($('#cameraCompulsory').val() == 'false' && (window.stream === undefined || !window.stream.active || document.getElementById('previewCam').paused))
			{
				$('#captureCameraImage').val('false');
				
			}
			
			if($('#captureCameraImage').val()=='true' && (window.stream === undefined || !window.stream.active || document.getElementById('previewCam').paused))
			{
				$('#msgModalLoader').attr('data-msgmodalbodytext',$('#cameraAndPosition').val());
				$('#msgModalLoader').attr('data-footerbtn1text',"OK");
				$('#msgModalLoader').attr('data-footerbtn1class','btn btn-error');
				
			    triggerMsgLoader('on',function () 
				{    	
					triggerMsgLoader('off');
			    });
				
				return;
			}
			
			if(!seu && !uploadedCI && $('#captureCameraImage').val() == 'true'){
				onLiveStreamStarted();
			}
			if(!seu && !uploadedSI && $('#captureScreenShot').val() == 'true'){
				onScreenSharingStarted();
			}
			if(!seu){
				setInterval(authBtnEnable, 100);
				
			} 
		});


		$('form').submit(function()
		{
			var hashMD5 = hex_md5($("#pwd").val());
			var salt = ${Rnum};
			var saltHash = hex_md5(hashMD5 + salt);
			$('#pwd').val(saltHash);
		});
		
	});
	
	function authBtnEnable() {
		if(!seu && $('#captureScreenShot').val() == 'true' && $('#captureCameraImage').val() == 'true' && uploadedCI && uploadedSI){
			$('#authBtn').attr('disabled', false);
			seu=true;
		} else if(!seu && $('#captureScreenShot').val() == 'false' && $('#captureCameraImage').val() == 'true' && uploadedCI){
			$('#authBtn').attr('disabled', false);
			seu=true;
		}else if(!seu && $('#captureScreenShot').val() == 'true' && $('#captureCameraImage').val() == 'false' && uploadedSI){
			$('#authBtn').attr('disabled', false);
			seu=true;
		}
		
		if(seu){
			$('#takeImgAuth').attr('disabled', true);
			$('#smsg').show();
			$('#resmsg').hide();
			$("#capImg img").show();
		}
    }
	
</script>
<script src="<c:url value='/resources/js/cam.js?${jsTime }'></c:url>" async></script>
<script src="<c:url value='/resources/js/screenshot.js?${jsTime }'></c:url>"></script>
<script src="<c:url value='/resources/js/camSuper.js?${jsTime }'></c:url>" async onload="checkConfigSuper();"></script>
</body>
</html>
