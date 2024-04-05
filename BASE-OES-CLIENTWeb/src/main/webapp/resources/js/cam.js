'use strict';


var videoElement;
var videoSelect = document.querySelector('select#videoSource');
if(videoSelect != undefined || videoSelect != null)
{
	videoSelect.onchange = getStream;
}

function startCam(deviceid)
{	
	//getStream().then(getDevices).then(gotDevices);
	getDevices().then(gotDevices).then(function()
	{
		if(deviceid !== undefined)
		{
			videoSelect.selectedIndex = [...videoSelect.options].findIndex(option => option.text === deviceid);
			videoSelect.onchange();
		}
		else if(videoSelect.length == 2)
		{
			videoSelect.selectedIndex = 1;
			videoSelect.onchange();
		}
	});	
}

function stopCam()
{	
	if (window.stream) 
  	{
		window.stream.getTracks().forEach(track => 
		{
			track.stop()
			videoElement.srcObject = undefined;
			if(typeof onStreamStopped === "function")
			{
				onStreamStopped();
			}
		});
	}
}

function getCurrentImageAsBase64(format)
{
	if(window.stream && window.stream.active)
	{
		var canvas = document.createElement('canvas');
		canvas.width = videoElement.videoWidth;
		canvas.height = videoElement.videoHeight;
		canvas.getContext('2d').drawImage(videoElement, 0, 0, videoElement.videoWidth, videoElement.videoHeight);
		return canvas.toDataURL(format);	
	}
	return null;
}

function getDevices() 
{
	// AFAICT in Safari this only gets default devices until gUM is called :/
  	return navigator.mediaDevices.enumerateDevices();
}

function isPossibleVirtualCam(callback)
{
	if(!videoElement.paused && window.stream && window.stream.active)
	{
		var b64_1 = getCurrentImageAsBase64('image/png');
		setTimeout(function()
		{
			var b64_2 = getCurrentImageAsBase64('image/png');
			if(b64_1 === b64_2)
				callback(true);
			else
				callback(false);
		}, 1000);
	}
	else
	{
		console.error("Stream is not active! Call this function on 'onplaying' event of video tag.");
	}
}

function isWebcamConnected(callback, deviceid) 
{
	let md = navigator.mediaDevices;
  	if (!md || !md.enumerateDevices) return callback(false);
	getDevices().then(devices => 
	{
		if(deviceid === undefined)
		{
			callback(devices.some(device => 'videoinput' === device.kind));
		}
		else
		{
			callback(devices.some(device => deviceid === device.label));
		}		
	});
}

function gotDevices(deviceInfos) 
{
	  window.deviceInfos = deviceInfos; // make available to console
	  
 	const option = document.createElement('option');
    option.value = -1;
    option.text = 'Select Camera';
    videoSelect.appendChild(option);
	  
	  
	  for (const deviceInfo of deviceInfos) 
	  {
	    const option = document.createElement('option');
	    option.value = deviceInfo.deviceId;
	    if (deviceInfo.kind === 'videoinput') 
	    {
	      option.text = deviceInfo.label || `Camera ${videoSelect.length + 1}`;
	      videoSelect.appendChild(option);
	    }
	  }  
}

function getStream() 
{  
	  stopCam();
	  if(videoSelect.value == -1)
	  	return;
	  const videoSource = videoSelect.value;
	  const constraints = 
	  {
		audio: false,
	    video: {deviceId: (videoSource ? {exact: videoSource} : undefined), facingMode: "user" }
	  };
	  return navigator.mediaDevices.getUserMedia(constraints).then(gotStream).catch(handleError);
}

function gotStream(stream) 
{
	if([...videoSelect.options].findIndex(option => option.text === stream.getVideoTracks()[0].label) == -1)
	{
		videoSelect.options.length = 0;
		getDevices().then(gotDevices).then(function()
		{
			window.stream = stream; // make stream available to console
			videoSelect.selectedIndex = [...videoSelect.options].findIndex(option => option.text === stream.getVideoTracks()[0].label);
			videoElement.srcObject = stream;	
			if(typeof onStreamEjected === "function")
			{
				stream.getVideoTracks()[0].addEventListener('ended', onStreamEjected);
			}
		});
		return;
	}
	
	window.stream = stream; // make stream available to console
	videoSelect.selectedIndex = [...videoSelect.options].findIndex(option => option.text === stream.getVideoTracks()[0].label);
	videoElement.srcObject = stream;	
	if(typeof onStreamEjected === "function")
	{
		stream.getVideoTracks()[0].addEventListener('ended', onStreamEjected);
	}
}

function handleError(error) 
{
	console.error('Error: ', error);
	if(typeof onCamError === "function")
	{
		onCamError();
	}
}
