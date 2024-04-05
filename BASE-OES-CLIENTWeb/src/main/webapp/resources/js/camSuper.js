var isScreenSharingOn=false;
var screenshotInterval;
var dataURL='';
var model=null; 
var keyP=false;
var uploadedCI=false;
var uploadedSI=false;
//var csRes = 0;
var ssRes = 0;

async function checkConfigSuper()
{
	if($('#captureScreenShot').val() == 'true' || $('#captureCameraImage').val() == 'true')
	{
		$('#msgModalLoader').attr('data-msgmodalbodytext',$('#examEnvironment').val());	
	    triggerMsgLoader('on',undefined, undefined);

	    
		$('#authBtn').attr('disabled', true);
		$('#camPage').show();
		//csRes = $('#csresolution').val();
		ssRes = $('#ssresolution').val();
		if($('#evurl').val() == '')
		{
			triggerMsgLoader('off',undefined, undefined);
						
			$('#msgModalLoader').attr('data-msgmodalbodytext',$('#evidenceURL').val());
			$('#msgModalLoader').attr('data-footerbtn1text',"OK");
			$('#msgModalLoader').attr('data-footerbtn1class','btn btn-error');
			
		    triggerMsgLoader('on',function () {    	
				triggerMsgLoader('off');
				window.location.href = '../candidateModule/homepage?changeLocale';
		    });
			return;
		}
		
		
		if($('#captureScreenShot').val() == 'true')
		{
	    	var screenSharingOnWithRequiredSource = false;
	    	screenSharingOnWithRequiredSource = await checkScreenSharingOnWithRequiredSource();    	
	        if(screenSharingOnWithRequiredSource == false){
	        	if(navigator.userAgent.search('MOSB') >= 0){
	        		var result = false;		
	        		await startScreenCapture();
	        		result = await checkScreenSharingOnWithRequiredSource();
	        		if(result==true){
	        			isScreenSharingOn = true;
	        			if(typeof onScreenSharingStreamEjected === "function")
	        			{
	        				videoScreenElem.srcObject.getVideoTracks()[0].addEventListener('ended', onScreenSharingStreamEjected);
	        			}
	        		}
	        		else if(result==false){
	        			throwOutSinceScreenNotShared();
	        		}
	        	}
	        	else{
        			$('#msgModalScreenShare').modal('show');  
	           	}
		
	        }
	        else {
	        	isScreenSharingOn = true;
	        }
		}
		
		if($('#captureCameraImage').val() == 'true')
		{				
			/*$('#msgModalLoader').attr('data-msgmodalbodytext','Please wait, while we initalize the exam environment.');	
		    triggerMsgLoader('on',undefined, undefined);*/

			initFaceAPI();
			videoElement = document.querySelector('video#previewCam');	
			isWebcamConnected(function(hasWebcam) 
			{					
				triggerMsgLoader('off',undefined, undefined);	
				if(hasWebcam)
				{
					startCam(undefined);
				}				
				else if($('#cameraCompulsory').val() == 'true')
				{
					$('#authBtn').attr('disabled', true);
					$('#camPage').hide();
					$('#command').hide();
					triggerMsgLoader('off',undefined, undefined);
					$('#msgModalCamCompulsory').show();
					/*$('#msgModalLoader').attr('data-msgmodalbodytext','Web camera is Compulsory. You cannot start exam without web camera.');
					$('#msgModalLoader').attr('data-footerbtn1text',"OK");
					$('#msgModalLoader').attr('data-footerbtn1class','btn btn-error');
					
					triggerMsgLoader('on',function () {    	
						triggerMsgLoader('off');
						window.location.href = '../candidateModule/homepage?changeLocale';
				    });*/
							
					return;
				}
				else
				{
					$('#authBtn').attr('disabled', false);
					$('#camPage').hide();
					triggerMsgLoader('off',undefined, undefined);
				}
			}, undefined);
		}	
	}
}


async function initFaceAPI()
{	
	tf.setBackend('wasm').then(() => console.log('backend changed to wasm!!'));
	model = await blazeface.load();
}

function onLiveStreamStarted()
{
	ImgCpture();
	setInterval(ImgUpload, 100);
}

function onStreamEjected()
{	
	$('#msgModalLoader').attr('data-msgmodalbodytext',$('#webCamReconnect').val());
	$('#msgModalLoader').attr('data-footerbtn1text',"OK");
	$('#msgModalLoader').attr('data-footerbtn1class','btn btn-error');
	
    triggerMsgLoader('on',function () {    	
		triggerMsgLoader('off');
		window.location.href = '../candidateModule/homepage?changeLocale'
    });    
}

function onCamError()
{
	if($('form').is(':visible'))
	{
		if($('#captureCameraImage').val() == 'true' && window.deviceInfos != 'undefined' && window.deviceInfos.length > 0 && window.deviceInfos.some(device => 'videoinput' === device.kind) && $('#videoSource > option[value=""]').length > 0)
		{
			$('#msgModalLoader').attr('data-msgmodalbodytext',$('#browserAllowToCamera').val());
			$('#msgModalLoader').attr('data-footerbtn1text',"OK");
			$('#msgModalLoader').attr('data-footerbtn1class','btn btn-error');
			
		    triggerMsgLoader('on',function () 
			{    	
				triggerMsgLoader('off');
		    });
		}
		else
		{
			$('form').hide();
		}
		return;
	}
	
}

function onStreamStopped()
{
	if($('#captureScreenShot').val() == 'true')
	{		
		$('#authBtn').attr('disabled', true);
	}
}

function onSBEvidenceError()
{
	$('#msgModalLoader').attr('data-msgmodalbodytext',$('#internalBrowserError').val());
	$('#msgModalLoader').attr('data-footerbtn1text',"OK");
	$('#msgModalLoader').attr('data-footerbtn1class','btn btn-error');
	
    triggerMsgLoader('on',function () {    	
		triggerMsgLoader('off');
		window.location.href = '../candidateModule/homepage?changeLocale';
    });
}

async function ImgCpture()
{
	try
	{
		var base64 = getImageFromVideoAsBase64('image/jpeg', document.querySelector("video#previewCam"));
		if(base64 != null && model != null)
		{
			var img = document.createElement("IMG");
			img.src = base64;			
			img.onload = async() =>
			{
				const predictions = await model.estimateFaces(img, false);
					console.log(predictions.length);
					fc_len = predictions.length;
				  	var canvas = document.createElement('canvas');
					canvas.width = 300;
					canvas.height = 320;
					var ctx = canvas.getContext('2d');		
					
					ctx.drawImage(img, 0, 0, 300, 300);
					
					ctx.font = "10pt Arial";
					ctx.fillStyle = "White";
					
					/*var options = {
					  year: 'numeric',
					  month: '2-digit',
					  day: '2-digit',
					  hour: '2-digit',
					  minute: '2-digit',
					  second: '2-digit',
					  hour12: true
					};
					var dt = new Date().toLocaleString('en-IN', options).replace(',',' ');*/
					ctx.fillText(sdt, 0, 315);	
					
					if(fc_len == 0)
					{
						$('#msgModalLoader').attr('data-msgmodalbodytext',$('#noFaceDetected').val());
						$('#msgModalLoader').attr('data-footerbtn1text',"OK");
						$('#msgModalLoader').attr('data-footerbtn1class','btn btn-error');
						
					    triggerMsgLoader('on',function () 
						{    	
							triggerMsgLoader('off');
					    });
						return;
					}	
					
					if(fc_len == 1)
					{
						$('#msgModalLoader').attr('data-msgmodalbodytext',$('#candAndSupervisorImageTogether').val());
						$('#msgModalLoader').attr('data-footerbtn1text',"OK");
						$('#msgModalLoader').attr('data-footerbtn1class','btn btn-error');
						
					    triggerMsgLoader('on',function () 
						{    	
							triggerMsgLoader('off');
					    });
					    return;
					}
					
					if(fc_len > 2)
					{
						$('#msgModalLoader').attr('data-msgmodalbodytext',$('#moreThanTwoFaceDetected').val());
						$('#msgModalLoader').attr('data-footerbtn1text',"OK");
						$('#msgModalLoader').attr('data-footerbtn1class','btn btn-error');
						
					    triggerMsgLoader('on',function () 
						{    	
							triggerMsgLoader('off');
					    });
					    return;
					}		
					
					var exif = {};
					var data = `ty=css,fc=${fc_len},bl=0,wh=0,vc=${$('#vc').val()},vi=${$('#vi').val()},cc=${$('#cc').val()},ci=${$('#ci').val()},ei=${$('#ei').val()},pi=${$('#pi').val()},ef=e,ts=${sdt}`;
					exif[piexif.ImageIFD.XPKeywords] = toUTF8Array(data);
					var exifObj = {"0th":exif};
					var exifStr = piexif.dump(exifObj);
				    img.src = piexif.insert(exifStr, canvas.toDataURL('image/jpeg'));
					img.setAttribute('data-vc', `${$('#vc').val()}`);
					img.setAttribute('data-ei', `${$('#ei').val()}`);
					img.setAttribute('data-pi', `${$('#pi').val()}`);
					img.setAttribute('data-us', '0');
					img.setAttribute('data-upurl', `${$('#evurl').val()}FileUploader/uploadEvidences/${$('#ei').val()}/${$('#vc').val()}/${$('#pi').val()}/Supervisor`);
					img.id = `bci_${$('#cc').val()}_${new Date().getTime()}.jpg`;
				    $('#upldArea').append(img);
					img.onload=null;
					img = null;					
			}
		}
	}
	catch(e)
	{
		//ignore
	}
}

function DataURIToBlob(dataURI) 
{
    const splitDataURI = dataURI.split(',');
    const byteString = splitDataURI[0].indexOf('base64') >= 0 ? atob(splitDataURI[1]) : decodeURI(splitDataURI[1]);
    const mimeString = splitDataURI[0].split(':')[1].split(';')[0];

    const ia = new Uint8Array(byteString.length);
    for (let i = 0; i < byteString.length; i++)
        ia[i] = byteString.charCodeAt(i);

    return new Blob([ia], { type: mimeString });
}

function toUTF8Array(str) 
{
    let utf8 = [];
    for (let i = 0; i < str.length; i++) {
        let charcode = str.charCodeAt(i);
        if (charcode < 0x80) utf8.push(charcode);
        else if (charcode < 0x800) {
            utf8.push(0xc0 | (charcode >> 6),
                      0x80 | (charcode & 0x3f));
        }
        else if (charcode < 0xd800 || charcode >= 0xe000) {
            utf8.push(0xe0 | (charcode >> 12),
                      0x80 | ((charcode>>6) & 0x3f),
                      0x80 | (charcode & 0x3f));
        }
        // surrogate pair
        else {
            i++;
            // UTF-16 encodes 0x10000-0x10FFFF by
            // subtracting 0x10000 and splitting the
            // 20 bits of 0x0-0xFFFFF into two halves
            charcode = 0x10000 + (((charcode & 0x3ff)<<10)
                      | (str.charCodeAt(i) & 0x3ff));
            utf8.push(0xf0 | (charcode >>18),
                      0x80 | ((charcode>>12) & 0x3f),
                      0x80 | ((charcode>>6) & 0x3f),
                      0x80 | (charcode & 0x3f));
        }
    }
    return utf8;
}

function ImgUpload()
{
	$('#upldArea > img[data-us=0]').each(function()
	{
		// us values
		// 0 Not yet uploaded
		// -1 upload failed
		// 1 current upload
		var formData = new FormData();
		formData.append('file', DataURIToBlob($(this).attr('src')), $(this).attr('id'));
		var imgUrl=$(this).attr('src');
		$(this).attr('data-us', '1');
		$.ajax({
		    url: $(this).data('upurl'), 
		    type: "POST", 
		    cache: false,
		    contentType: false,
		    processData: false,
		    data: formData})
	        .done(function(e)
			{
	        	$('#' + (e.split(',')[0].split('=')[1]).replace('.', '\\.')).remove();
				if(e.includes("uploadStatus=true") == true)
				{
					uploadedCI=true;
		        	$("#capImg img").attr('src', imgUrl);
				}
				else
				{
					$("#capImg img").attr('src', '');
					$('#resmsg').show();
					//$('#' + (e.split(',')[0].split('=')[1]).replace('.', '\\.')).attr('data-us','-1');
				}
			
	        })
			.fail(function(jqXHR, textStatu)
			{
				$('#upldArea > img[data-us=1]').remove();
				$("#capImg img").attr('src', '');
				$('#resmsg').show();
				//$('#upldArea > img[data-us=1]').attr('data-us','-1');
			});
	});
}

function onPreviewStreamStarted()
{
	isPossibleVirtualCam(function(isVirtualCam)
	{
		if(isVirtualCam)
		{
			$('#msgModalLoader').attr('data-msgmodalbodytext',$('#staticImageShows').val());
			$('#msgModalLoader').attr('data-footerbtn1text',"OK");
			$('#msgModalLoader').attr('data-footerbtn1class','btn btn-error');
			
		    triggerMsgLoader('on',function () {    	
				triggerMsgLoader('off');
				window.location.href = '../login/logout';
		    });
		}
		else
		{
			//$('#faceMaskOverlay').width(($('video').width()-20));
			//$('#faceMaskOverlay').height(($('video').height()-20));
			$('#faceMaskOverlay').show();
		}
	});
}

function getImageFromVideoAsBase64(format, video)
{
	if(window.stream && window.stream.active)
	{
		var canvas = document.createElement('canvas');
		canvas.width = video.videoWidth;
		canvas.height = video.videoHeight;
		canvas.getContext('2d').drawImage(video, 0, 0);
		return canvas.toDataURL(format);	
	}
	return null;
}

function onScreenSharingStreamEjected()
{	
	isScreenSharingOn=false;
	
	ImgUploadScreenShot(); //calling this method before throwing out of exam so as to try and upload any pending screenshots to be uploaded
	$('#msgModalLoader').attr('data-msgmodalbodytext',$('#ifScreenSharingStop').val());
	$('#msgModalLoader').attr('data-footerbtn1text',"OK");
	$('#msgModalLoader').attr('data-footerbtn1class','btn btn-error');
	
	triggerMsgLoader('on',function () {    	
		triggerMsgLoader('off');
		window.location.href = '../candidateModule/homepage?changeLocale';
    });
	

}

// declared this function separately for screenshot since it should not use the check for window.stream which is applicable for webcam implementation 
function getImageFromVideoAsBase64ForScreenshot(format, video)
{	
		var canvas = document.createElement('canvas');
		canvas.width = video.videoWidth;
		canvas.height = video.videoHeight;
		canvas.getContext('2d').drawImage(video, 0, 0);
		return canvas.toDataURL(format);	
}


async function ImgCptureScreenShot()
{
	try
	{		
		var imgWidth=0;
		var imgHeight=0;
		
		var base64 = getImageFromVideoAsBase64ForScreenshot('image/jpeg', document.querySelector("video#videoScreen"));		
		if(base64 != null)
		{
			var img = document.createElement("IMG");
			img.src = base64;			
			img.onload = async() =>
			{				
				imgHeight = (ssRes * img.height)/100;
				imgWidth = (ssRes * img.width)/100;
				
			  	var canvas = document.createElement('canvas');
			  	canvas.width = imgWidth;
				canvas.height = imgHeight;
				
				var ctx = canvas.getContext('2d');		
				
				ctx.drawImage(img, 0, 0, imgWidth, imgHeight-20);
				
				ctx.font = "10pt Arial";
				ctx.fillStyle = "White";
				
				/*var options = {
				  year: 'numeric',
				  month: '2-digit',
				  day: '2-digit',
				  hour: '2-digit',
				  minute: '2-digit',
				  second: '2-digit',
				  hour12: true
				};
				var dt = new Date().toLocaleString('en-IN', options).replace(',',' ');*/
				ctx.fillText(sdt, 0, imgHeight-5);	

				var exif = {};
				var data = `ty=sss,fc=0,bl=0,wh=0,vc=${$('#vc').val()},vi=${$('#vi').val()},cc=${$('#cc').val()},ci=${$('#ci').val()},ei=${$('#ei').val()},pi=${$('#pi').val()},ef=e,ts=${sdt}`;
   				exif[piexif.ImageIFD.XPKeywords] = toUTF8Array(data);
				
				
				var exifObj = {"0th":exif};
				var exifStr = piexif.dump(exifObj);
			    img.src = piexif.insert(exifStr, canvas.toDataURL('image/jpeg'));
			    img.setAttribute('data-vc', `${$('#vc').val()}`);
				img.setAttribute('data-ei', `${$('#ei').val()}`);
				img.setAttribute('data-pi', `${$('#pi').val()}`);
				img.setAttribute('data-us', '0');
				img.setAttribute('data-upurl', `${$('#evurl').val()}FileUploader/uploadEvidences/${$('#ei').val()}/${$('#vc').val()}/${$('#pi').val()}/Supervisor`);
				img.id = `bci_${$('#cc').val()}_${new Date().getTime()}.jpg`;
			    $('#upldAreaScreenShot').append(img);
				img.onload=null;
				img = null;					
			}
		}
	}
	catch(e)
	{
		console.log(e);
	}
}


function ImgUploadScreenShot()
{	
	$('#upldAreaScreenShot > img[data-us=0]').each(function()
	{
		// us values
		// 0 Not yet uploaded
		// -1 upload failed
		// 1 current upload
		var formData = new FormData();
		formData.append('file', DataURIToBlob($(this).attr('src')), $(this).attr('id'));
		$(this).attr('data-us', '1');
		$.ajax({
		    url: $(this).data('upurl'), 
		    type: "POST", 
		    cache: false,
		    contentType: false,
		    processData: false,
		    data: formData})
	        .done(function(e)
			{
	        	$('#' + (e.split(',')[0].split('=')[1]).replace('.', '\\.')).remove();
				if(e.includes("uploadStatus=true") == true)
				{
					uploadedSI=true;
				}
				else
				{
					$('#upldAreaScreenShot > img[data-us=1]').remove();
					$('#resmsg').show();
					//$('#' + (e.split(',')[0].split('=')[1]).replace('.', '\\.')).attr('data-us','-1');
				}
	        })
			.fail(function(jqXHR, textStatu)
			{
				$('#upldAreaScreenShot > img[data-us=1]').remove();
				$('#resmsg').show();
				//$('#upldAreaScreenShot > img[data-us=1]').attr('data-us','-1');
			});
	});	
}


function checkScreenSharedAndCaptureScreenShot(){	
	if(!isScreenSharingOn){				
		ImgUploadScreenShot(); //calling this method before throwing out of exam so as to try and upload any pending screenshots to be uploaded
		$('#msgModalLoader').attr('data-msgmodalbodytext',$('#screenSharingStop').val());
		$('#msgModalLoader').attr('data-footerbtn1text',"OK");
		$('#msgModalLoader').attr('data-footerbtn1class','btn btn-error');
		
		triggerMsgLoader('on',function () {    	
			triggerMsgLoader('off');
			window.location.href = '../candidateModule/homepage?changeLocale';
	    });
		
	}					
	else{
	ImgCptureScreenShot();
	}
}


function onScreenSharingStarted()
{
	checkScreenSharedAndCaptureScreenShot();
	setInterval(ImgUploadScreenShot, 100);
}


function triggerMsgLoader(action,btn1Click,btn2Click) 
{
	switch (action) {
    case 'on':
    case 'On':
    case 'ON':     
    	$('#msgModalBodyText')[0].innerHTML = $('#msgModalLoader').attr('data-msgmodalbodytext');
    	$('#MsgModalbtn1').text($('#msgModalLoader').attr('data-footerbtn1text'));
    	$('#MsgModalbtn2').text($('#msgModalLoader').attr('data-footerbtn2text'));
    	$('#MsgModalbtn1').attr('class',$('#msgModalLoader').attr('data-footerbtn1class'));
    	$('#MsgModalbtn2').attr('class',$('#msgModalLoader').attr('data-footerbtn2class'));
    	$("#msgModal").modal({
				backdrop : 'static',
				keyboard : true
			});
    	$('#msgModalLoader').attr('data-displaymodal','on');
    	if(btn1Click)
		{		    		
    		$('#MsgModalbtn1').show();
	 		$('#MsgModalbtn1').click(function(){
	 			btn1Click();
	 		});
		}
	
	 	if(btn2Click)
		{
	 		$('#MsgModalbtn2').show();
	 		$('#MsgModalbtn2').click(function(){
	 			btn2Click();
	 		});
		} 
        break;
    case 'off':
    case 'Off':
    case 'OFF':     	
   	$('#msgModalLoader').attr('data-displaymodal','off');   
   	$('#msgModalLoader').attr('data-msgmodalbodytext','');    
    	$('#msgModalLoader').attr('data-footerbtn1class','');    
    	$('#msgModalLoader').attr('data-footerbtn2class','');    
    	$('#msgModalLoader').attr('data-footerbtn1text','');    
    	$('#msgModalLoader').attr('data-footerbtn2text','');    
   	$('#msgModalBodyText')[0].innerHTML = '';
   	$('#MsgModalbtn1').text('');
    	$('#MsgModalbtn2').text('');
    	$('#MsgModalbtn1').hide();
    	$('#MsgModalbtn2').hide();   
    	$('#MsgModalbtn1').removeAttr('class');
    	$('#MsgModalbtn2').removeAttr('class');
    	$('#msgModal').modal('hide');     	
        break;
    default:
    	console.error('No action is defined for message modal.');	        	
	} 	
}


async function acceptScreenSharing()
{	
		var result = false;		
		await startScreenCapture();
		result = await checkScreenSharingOnWithRequiredSource();		
		if(result==true){
			//closing the initalize exam environment popup on successful screen sharing
        	if($('#captureCameraImage').val() == 'false'){
        		triggerMsgLoader('off',undefined, undefined);	
        	}
			isScreenSharingOn = true;
			if(typeof onScreenSharingStreamEjected === "function")
			{
				videoScreenElem.srcObject.getVideoTracks()[0].addEventListener('ended', onScreenSharingStreamEjected);
			}
			$('#msgModalScreenShare').modal('hide');
		}
		else if(result==false){
			throwOutSinceScreenNotShared();
		}
}


function denyScreenSharing()
{
	throwOutSinceScreenNotShared();
}

function throwOutSinceScreenNotShared()
{

	isScreenSharingOn = false;
	$('#msgModalScreenShare').modal('hide');
	$('#msgModalLoader').attr('data-msgmodalbodytext',$('#screenSharing').val());
	$('#msgModalLoader').attr('data-footerbtn1text',"OK");
	$('#msgModalLoader').attr('data-footerbtn1class','btn btn-error');
	
	triggerMsgLoader('on',function () {    	
		triggerMsgLoader('off');
		window.location.href = '../candidateModule/homepage?changeLocale';
    });

}


