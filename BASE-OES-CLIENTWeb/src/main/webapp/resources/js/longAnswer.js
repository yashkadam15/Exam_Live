function uploadLongAnswerFile(selectedFilesArr)
{	
	var formData = new FormData();
	
	for(var i=0; i<selectedFilesArr.length; i++){
	formData.append("file", selectedFilesArr[i]);
	}  
	formData.append("candidateId", $('#ci',window.parent.document).val());
	formData.append("candidateCode", $('#cc',window.parent.document).val());
	formData.append("paperId", $('#pi',window.parent.document).val());
	formData.append("examEventId", $('#ei',window.parent.document).val());
	formData.append("examVenueCode", $('#vc',window.parent.document).val());
	formData.append("examVenueId", $('#vi',window.parent.document).val());
	formData.append("candidateExamID", $('#candidateExamID').val());
	formData.append("candidateExamItemID", $('#candidateExamItemID').val());

	 return $.ajax({
	  type: "POST",
	  enctype: 'multipart/form-data',	  
	  url: `${$('#evurl',window.parent.document).val()}FileUploader/uploadLongAnswer`,
	  data: formData,
	  processData: false,
	  contentType: false,
	  cache: false,
	  timeout: 600000,         
	  error: function(){showError($('#EW_FileUploadingFailed',window.parent.document).val());}
      });
    
}

function validateFileType(selectedFilesArr){
	if(selectedFilesArr == null || selectedFilesArr.length==0) {
	 return true; 
	 } // if no file is being uploaded,then returning true		
	
	var flag=0;
	for(var i=0; i<selectedFilesArr.length; i++){
		var file = selectedFilesArr[i];
		var fileName = file.name;			
		if (fileName.length > 0) {
        	var allowedFileTypes = $('#longAnswerAllowedFileTypes',window.parent.document).val();				 
			var _validFileExtensions;
                if (allowedFileTypes.indexOf(',') > -1) {
                    _validFileExtensions = allowedFileTypes.split(',');
                } else {
                _validFileExtensions = allowedFileTypes;
                }
            
            for (var j = 0; j < _validFileExtensions.length; j++) 
            {
                var curExtension = _validFileExtensions[j];
                if (fileName.substr(fileName.length - curExtension.length, curExtension.length).toLowerCase() == curExtension.toLowerCase()) {
                    ++flag;
                    break;
                }
            }
        } else {
			return false;
		}
	}
    if(flag==selectedFilesArr.length){
        return true;
    }else{
        return false;
    }	
            
}

function validateFileSize(selectedFilesArr){
	var longAnswerMaxFileSize = $('#longAnswerMaxFileSize',window.parent.document).val();
	var blnValid = false;
	if(selectedFilesArr == null || selectedFilesArr.length==0) { 
		return true; 
	} // if no file is being uploaded,then returning true
	let totalSize=0;
	for(var i=0; i<selectedFilesArr.length; i++){
		var file = selectedFilesArr[i];
		totalSize+=file.size;
	}
	if(totalSize > longAnswerMaxFileSize * 1048576){
		return false;
	}else{		
	return true;
	}
}

  