$(document).ready(function() {
	//open SWF file on btn click
	$('.openFlashbtn').click(function(e) {
		$('#SimqText', window.parent.document).text($('p.question-wrap').text());
		$("#swfpassword").val("").val($(this).data("psw"));
		$(".flashContentOverleyDiv", window.parent.document).show();
		$(".mainFlashContentDiv", window.parent.document).show();
		createObjectTag($(this).data("src"));
	});
});

function executeCommands(command,param){
	if(command=="getPassword"){
		return getSWFPassword();
	}else if(command=="saveMarks"){
		saveMarks(param);
	}else if(command=="saveStepsSummary"){
		saveStepsSummary(param);
	}else if(command=="saveRightSteps"){
		saveRightSteps(param);
	}else if(command=="saveWrongSteps"){
		saveWrongSteps(param);
	}else if(command=="saveTotalSteps"){
		saveTotalSteps(param);
	}else if(command=="closeFlashAndSubmit"){
		closeFlashAndSubmit(param);
	}
}

// get SWF password
var getSWFPassword = function() { 
	return $("#swfpassword").val();
};

var saveStepsSummary = function(val) {
	if (val) {
		var parts = val.split("##");
		// save right steps
		saveRightSteps(parts[0]);
		// save wrong steps
		saveWrongSteps(parts[1] - parts[0]);
		// save total steps
		saveTotalSteps(parts[1]);
	}
};

var saveMarks = function(val) {
	saveMarksInPercentage(val);
};

// save marks in percentage
var saveMarksInPercentage = function(val) {
	if(val == "0" || val){		
		$(".ca-marksInPercentage").val(val);
		if(val > 0)
		{
			$(".ca-iscorrect").val(true);
		}
	}
};
// save wrong steps
var saveWrongSteps = function(val) {
	if (val == "0" || val) {
		$(".ca-wrongSteps").val(val);
	}
};
// save right steps
var saveRightSteps = function(val) {
	if (val == "0" || val) {
		$(".ca-rightSteps").val(val);
	}
};
// save attempted steps
var saveTotalSteps = function(val) {
	if (val == "0" || val) {
		$(".ca-totalSteps").val(val);
	}
};


var closeFlashAndSubmit = function(val) {
	//submit attributes after 3 seconds
	//#140017
	//setTimeout("closewithsave()",3000);
};

var closewithsave = function(val) {
	closeModel();
	
	//submit Question form
	$("#Save").click();
	//update side pallete
	applyCls(clsans);
};

var closeModel = function(val) {
	//remove created Object tag
	$("#objTag", window.parent.document).remove();
	var div = $("<div>", {id: "replaceObjectTag"},window.parent.document);
	//replace Object tag with <div> which is to be replaced later
	div.insertAfter($("#simbuttons", window.parent.document));
	
	//close overley and overley content
	$(".flashContentOverleyDiv", window.parent.document).hide();
	$(".mainFlashContentDiv", window.parent.document).hide();
};

var createObjectTag = function (url){
	   //create parent window document
	   var doc = parent.document;
	   
	   //check IE version
	   var isMSIE = navigator.appName.indexOf('Microsoft') != -1;
	   
	   //create object tag depends upon IE or Non-IE browser
	   var obj = (isMSIE) ? createIeObject(doc,url) : doc.createElement("object");
	   if (!isMSIE) {
		   //for non-IE browser
		 /*  $(obj).prop("type", "application/x-shockwave-flash");
		 //for Non-IE browser URL given through data attribute
		   $(obj).prop("data", url);*/
	   }
	   //other object tag attributes
	   $(obj).prop("id", "objTag");
	   $(obj).prop("name", "objTag");
	   $(obj).prop("width", "100%");
	   $(obj).prop("height", "87%");
	   $(obj).prop("codebase", "http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=10,0,0,0");
	   
	   //inline CSS 
	 /*  $(obj).css("z-index","15");
	   $(obj).css("top","1%");
	   $(obj).css("left","0.5%");
	   $(obj).css("position","fixed");*/
	   $(obj).addClass("flashContentDiv");
	   
	   //Object Tag <Param> attributes
	   createParamElement(doc,"flashvars","ver=alcera_1",obj);
	   createParamElement(doc,"quality","high",obj);
	   createParamElement(doc,"allowScriptAccess","always",obj);
	   createParamElement(doc,"bgcolor","#D8E0E8",obj);
	   createParamElement(doc,"scale","default",obj);
	   createParamElement(doc,"wmode","transparent",obj);
	   createParamElement(doc,"movie",url,obj);
	   
	   //create embed tag in Object tag
	   $(obj).append(createEmbedElement(doc,url));
	   
	   //get <div> which to be replaced by object Tag
	   var target_element = doc.getElementById("replaceObjectTag");
	   //replace targeted DOM element with our new <object>
	   target_element.parentNode.replaceChild(obj, target_element);
};	

//create <param> element for object tag
function createParamElement(doc,key,value,obj){
	var param = doc.createElement("param");
	$(param).prop("name",key);
	$(param).prop("value",value);
	$(obj).append(param);
}	

//create embed tag
//embed tag is nor W3C standard
function createEmbedElement(doc,url){
	var embed = doc.createElement("embed");
	$(embed).prop("name", "enbedTag");
	$(embed).prop("src", url);
	$(embed).prop("type", "application/x-shockwave-flash");
	$(embed).prop("width", "100%");
	$(embed).prop("height", "87%");
	$(embed).prop("scale", "default");
	$(embed).prop("allowscriptaccess", "always");
	$(embed).prop("quality", "high");
	$(embed).prop("wmode", "transparent");
	$(embed).prop("bgcolor", "#D8E0E8");
	$(embed).prop("flashvars", "ver=alcera_1");
	$(embed).prop("pluginspage", "http://www.macromedia.com/go/getflashplayer");
	$(embed).addClass("flashContentDiv");
	return embed;
}

//create Object Tag for IE
function createIeObject(doc,url){
	//IE requires classid attribute whci call Activex to play Flash
	var div = doc.createElement("div");
	div.innerHTML = "<object classid='clsid:D27CDB6E-AE6D-11cf-96B8-444553540000'><param name='movie' value='" +url + "'></object>";
	return div.firstChild;
}
