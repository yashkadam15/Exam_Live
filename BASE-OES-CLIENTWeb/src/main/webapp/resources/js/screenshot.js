'use strict';

var displayMediaOptions = {
		  video: {
		    cursor: "always"
		  },
		  audio: false
		};

const videoScreenElem = document.querySelector('video#videoScreen');


async function startScreenCapture() {
	  try {		  
		  videoScreenElem.srcObject = await navigator.mediaDevices.getDisplayMedia(displayMediaOptions);
		  return true;
	  } catch(err) {
	    console.log("Error: " + err);
	    return false;
	  }
	}


function stopScreenCapture() {
	if(videoScreenElem.srcObject!=null){
	  let tracks = videoScreenElem.srcObject.getTracks();

	  tracks.forEach(track => track.stop());
	  videoScreenElem.srcObject = null;
	  }
	}


async function checkScreenSharingOnWithRequiredSource() {	
	var checkSuccessful = false;
	if(videoScreenElem.srcObject!=null){
	const videoTrack = videoScreenElem.srcObject.getVideoTracks()[0];
	// checking whether entire screen is shared and not just a specific window or a browser tab
	if(videoTrack.getSettings().displaySurface == 'monitor' || videoTrack.label == 'Primary Monitor'){
		checkSuccessful = true;
	}
	}
	return checkSuccessful;
	}