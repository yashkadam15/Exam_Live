 // Top-level variable keeps track of whether we are recording or not.
    let recording = false;
 $(document).ready(function()
 {
    var isMicrophoneAvailale = false;
    
      const recordAudio = () =>
        new Promise(async resolve => {
		try {
          const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
          const mediaRecorder = new MediaRecorder(stream);
          let audioChunks = [];

          mediaRecorder.addEventListener('dataavailable', event => {
            audioChunks.push(event.data);
          });

          const start = () => {
            audioChunks = [];
            mediaRecorder.start();
          };

          const stop = () =>
            new Promise(resolve => {
              mediaRecorder.addEventListener('stop', () => {

            	const audio = new Audio();
                   
                const audioBlob = new Blob(audioChunks, { type: 'audio/mpeg' });

                var formData = new FormData();        
                formData.append("audio", audioBlob);
                formData.append("candidateUserId", $('#ci').val());
                formData.append("candidateCode", $('#cc').val());
                formData.append("paperId", $('#pi').val());
                formData.append("examEventId", $('#ei').val());
                formData.append("examVenueCode", $('#vc').val());
                formData.append("examVenueId", $('#vi').val());
                formData.append("isVoiceRecordingEnabled", $('#isVoiceRecordingEnabled').val());

    			$.ajax({
    	              type: "POST",
    	              enctype: 'multipart/form-data',
    	              url: `${$('#evurl').val()}FileUploader/uploadEvidencesAudioRec`,
    	              data: formData,
    	              processData: false,
    	              contentType: false,
    	              cache: false,
    	              timeout: 600000,
    	              success: function (data) {
    	                  console.log("SUCCESS : ", data);
    	              },
    	              error: function (e) {
    	                  console.log("ERROR : ", e);
    	              }
    	          });
    	          // Clear the `chunks` buffer so that you can record again.
    	          chunks = [];
    	          resolve({ audioBlob});
    	          
              });

              mediaRecorder.stop();
            });

          resolve({ start, stop });
		 } catch(err) {
        	 throwOutSinceMicrophonePermsNotGiven();
          }
        });

      var recorder;
      var audio;

	 if($('#isVoiceRecordingEnabled').val() == 'true') {	
		
		// Firefox 1.0+
		var isFirefox = typeof InstallTrigger !== 'undefined';
		
		if(isFirefox) {
		isMicrophoneAvailale = true;
			navigator.mediaDevices.getUserMedia({audio: true}).then( ( stream ) => {
	           // microphone available
	           // Start Recording on load
			  (async() => {
				  //if($('#isVoiceRecordingEnabled').val() == 'true') {
			      recorder = await recordAudio();
			      recorder.start();
			      recording = true;
				//}	  
			  })();
	      },
	      e => {
	           // microphone not available
			   throwOutSinceMicrophonePermsNotGiven();
	      } );
		} else {
			isMicrophoneAvailale = true;
			 // Start Recording on load
			  (async() => {
				  //if($('#isVoiceRecordingEnabled').val() == 'true') {
			      recorder = await recordAudio();
			      recorder.start();
			      recording = true;
				//}	  
			  })();
		}
	}
	
	  const myTimeout = setInterval(async () => {
		  if($('#isVoiceRecordingEnabled').val() == 'true') {
		  if (recording) {
        	 recorder.stop();
        	 recording = false;
    	  }
    	  
    	  // Check while attending exam If user deny Microphone
    	 /* navigator.mediaDevices.enumerateDevices().then(devices => 
		  	devices.forEach(device => {

			if(!device.label.includes("Microphone")) {
		  		throwOutSinceMicrophonePermsNotGiven();
			}	
			
		  }));*/
		  
		  recorder = await recordAudio();
          recorder.start();
          recording = true;
		  }
    	}, $('#audioRecordingTimeInterval').val());
  

		// On Browser Closed Upload chunks
    	//$(window).on('unload',async() => {
    	//	if($('#isVoiceRecordingEnabled').val() == 'true' && isMicrophoneAvailale) {
    	//	audio = await recorder.stop();
    	//	}
		//});
		
		// For Firefox Close Event
		//window.onbeforeunload = async (e) => {
		//	e = e || window.event;
		//	audio = await recorder.stop();
		//};
  });
  
 function throwOutSinceMicrophonePermsNotGiven()
{

	$('div.questions-area, div.palette').hide();
	$('#msgModalLoader').attr('data-msgmodalbodytext',$('#microphoneCompulsory').val());
	$('#msgModalLoader').attr('data-footerbtn1text',"OK");
	$('#msgModalLoader').attr('data-footerbtn1class','btn btn-error');
	
	triggerMsgLoader('on',function () {    	
		triggerMsgLoader('off');
		window.location.href = '../candidateModule/homepage?changeLocale';
    });

}