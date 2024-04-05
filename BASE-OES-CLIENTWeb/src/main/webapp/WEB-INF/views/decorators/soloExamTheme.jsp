<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html lang="en">
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="icon" href="<c:url value="/resources/images/favicon.ico"></c:url>">
<title><sitemesh:write property='title' /></title>

<spring:theme code="curdetailtheme" var="curdetailtheme"/>
<link rel="stylesheet" href="<c:url value='${curdetailtheme}'></c:url>" type="text/css"/>
<link rel="stylesheet" href="<c:url value='/resources/style/jquery.scrollbar.css'></c:url>" type="text/css"/>
<link rel="stylesheet" href="<c:url value='/resources/style/selectFix.css'></c:url>" type="text/css" />
<link rel="stylesheet" href="<c:url value='/resources/style/calclayout.css'></c:url>" type="text/css" />

<link rel="stylesheet" href="<c:url value='https://cdnjs.cloudflare.com/ajax/libs/MaterialDesign-Webfont/5.8.55/css/materialdesignicons.min.css'></c:url>" type="text/css" />
<script src="https://www.wiris.net/demo/plugins/app/WIRISplugins.js?viewer=image"></script>
<!--[if IE 7]>
<style>
.exam-info .exam-ins .span5 {margin-left:0}
.exam-info .exam-ins .span7 .btn {margin-top: 4px; padding-top: 0; height:5px}
.quick-ques > .btn {border:1px solid #ccc}
</style>
<![endif]-->
<script src="<c:url value='/resources/js/jquery-1.12.0.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/EvidenceTimer.js?${jsTime}'></c:url>"></script>
<script src="<c:url value='/resources/js/bootstrap.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/jquery.scrollbar.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/selectFix.js'></c:url>"></script>
<script	src="<c:url value='/resources/js/darkModeTheme.js?${jsTime}'></c:url>"></script>
<sitemesh:write property='head' />
 <script type="module">
	

 import SpeedTest from 'https://cdn.skypack.dev/@cloudflare/speedtest';


    const engine = new SpeedTest({
        autoStart: false,
        measurements: [ 
            { type: 'download', bytes: 1e5, count: 1, bypassMinDuration: true }, // initial download estimation  
            { type: 'download', bytes: 1e5, count: 5 }
        ]
    });

    let checkDownloadSpeedInterval;
	let isOffline = false; // Track network status
    function checkDownloadSpeed() {
      
       if (navigator.connection && navigator.connection.downlink) {
	        var connectionSpeed = navigator.connection.downlink;
	        $("#speedDisplay").text(connectionSpeed + ' Mbps');
      		offlineOnlineStyle(isOffline);
	    } else {
	    	if(!isOffline){
 				engine.restart();
			}
	    }
    }

    engine.onFinish = results => {
        setResult(results.getDownloadBandwidth());
        console.log(results.getSummary());
        console.log(results.getScores());
    };

    function setResult(obj) {  
        var downloadSpeed = JSON.stringify(obj, null, 2);
        downloadSpeed = downloadSpeed / 1000000;
        downloadSpeed = downloadSpeed.toFixed(2); 
		if (!isOffline && downloadSpeed!=0.00) {
			if(downloadSpeed>10.00){
				$("#speedDisplay").text(10 + ' Mbps');
			}else{
				$("#speedDisplay").text(downloadSpeed + ' Mbps');
			}
      		offlineOnlineStyle(isOffline);
    	}else{
			offlineOnlineStyle(isOffline);
		}
    }	

    function startSpeedTest() {
        checkDownloadSpeed();
        checkDownloadSpeedInterval = setInterval(checkDownloadSpeed, 30000);
    }

    window.addEventListener("online", (event) => {
  		isOffline = false;
		startSpeedTest(); // Start the test immediately when back online
    });
    
    window.addEventListener("offline", (event) => {
 		isOffline = true;
        offlineOnlineStyle(isOffline);
    });

	 function offlineOnlineStyle(isOffline) {
       if(isOffline){
		    $("#speedDisplay").text('Offline');
 			$("#speedDisplayDiv").css('background-color', '#ffcccc');
 			$("#speedDisplayDiv .icon-signal").removeClass("icon-signal").addClass("icon-screenshot");        
	   }else{
			$("#speedDisplayDiv").css('background-color', '#abf3f3e8');
      		$("#speedDisplayDiv .icon-screenshot").removeClass("icon-screenshot").addClass("icon-signal");
	   }
    }
	
	
    startSpeedTest(); // Start the first test immediately

  </script>
<script>




	$(document).ready(function() {
		/* var isFirefox = navigator.userAgent.toLowerCase().indexOf('firefox') > -1;
		function checkConnectionSpeed() {
			
			if(!isFirefox){
				if (navigator.onLine && navigator.connection && navigator.connection.downlink) {
			        var connectionSpeed = navigator.connection.downlink;
			        $('#speedDisplay').text( connectionSpeed + ' Mbps'); 
			       // $('#speedDisplay').show();
			    }else{
			    	 $('#speedDisplay').text('Offline'); 
			    }
			}
		    
		}
		checkConnectionSpeed();
		var intervalId = setInterval(checkConnectionSpeed, 2000); */

		if(navigator.userAgent.search('MOSB') >= 0){
	    	$('select').each(function(){
	    		$(this).fixCEFSelect();
	    	});
		}

		var isDarkModeOn=$('#isDarkModeOn').val();
		if(isDarkModeOn=="true"){
			var isBodyDark =$(document.body).hasClass("dark-mode");
			$("#darkModeSlider").attr("checked",true);
			if(!isBodyDark){
				$(document.body).addClass("dark-mode");
			}
		}
		
		$("#darkmodebtn").change(function(e) {
			darkModeFunction();
		});
   });
function darkModeFunction(){
	var element = document.body;
	   element.classList.toggle("dark-mode");
	   isDarkModeOn=$(element).hasClass("dark-mode");
	   $("#isDarkModeOn").val(isDarkModeOn);
	   darkModeCheck();
}


</script>
<style>
body {
  -webkit-user-select: none;  /* Chrome all / Safari all */
  -moz-user-select: none;     /* Firefox all */
  -ms-user-select: none;      /* IE 10+ */
 
  /* No support for these yet, use at own risk */
  -o-user-select: none;
  user-select: none;
}
.overlayS {
    opacity:0.7;
    filter: alpha(opacity=20);
    background-color:#000; 
    width:100%; 
    height:100%; 
    z-index:10;
    top:0; 
    left:0; 
    position:fixed; 
}
.overlayS-content{
	position:fixed;
	top:1%;
	left:0.5%;
    z-index:21;
}

.footer-text {
font-size:11px; 
color:#333;
}

.footer p{   padding-top: 0px !important;
}
:root {
    --light: #fcfcfc;
    --dark: #000000;
    --skyblue: #022129;
    --brightYellow:#fffbe7;

  }

  .toggle-switch {
    position: relative;
    width: 45px;
    /*top: 80px;*/
  }

  .toggle-switch label {
   /* position: absolute;*/
    width: 100%;
    height: 24px;
    background-color: var(--dark);
    border-radius: 50px;
    cursor: pointer;
  }

 .toggle-switch input {
    position: absolute;
    display: none;
  }

 .toggle-switch .slider {
    /* position: absolute;
    width: 100%;
    height: 100%; */
    border-radius: 50px;
    transition: 0.3s;
  }

  .toggle-switch input:checked ~ .slider {
    background-color: var(--skyblue);
  }

  /* .toggle-switch .slider::before {
    content: "";
    position: absolute;
    top: 4px;
    left: 8px;
    width: 24px;
    height: 24px;
    border-radius: 50%;
    box-shadow: inset 8px -4px 0px 0px var(--light);
    background-color: var(--dark);
    transition: 0.3s;
  }

  .toggle-switch input:checked ~ .slider::before {
    transform: translateX(36px);
    background-color: var(--brightYellow);
    box-shadow: none;
  } */
  .toggle-switch input:checked ~ .slider::before {
    content: "";
    position: absolute;
    top: 1px;
    left: 60px;
    width: 20px;
    height: 20px;
    border-radius: 50%;
    box-shadow: inset 8px -4px 0px -1px var(--light);
    background-color: var(--dark);
    transition: 0.3s;
  }

  .toggle-switch .slider::before {
  	content: "";
    position: absolute;
    top: 4px;
    left: 42px;
    width: 16px;
    height: 16px;
    border-radius: 50%;
  	box-shadow: inset 8px -4px 0px 0px var(--light);
    background-color: var(--dark);
    transition: 0.3s;
  	transform: translateX(-36px);
    background-color: var(--brightYellow);
  }
 .text-center {
  text-align:center;}
  .icon-area label {
  margin-bottom:0px; display:inline;}

  
  .wifi-btn {border: 1px solid #6daaaf91;
    background-color: #abf3f3e8;
    border-radius: 4px ;}
    .event-title{
    padding-left:215px;
   }
    
    label{
    margin-bottom:0px;}
    .m-2 {
    margin-right:10px}
 /*mobile css */ 
 
 @media only screen and (max-width: 435px) {
  .ml-2 {
    margin-left: 10px;
  }
    .mr-2 {
    margin-right: 15px;
  }
  .event-title{
    padding-left:7px;
  line-height: 34px;
   }
}
    
i.icon-greyer.icon-signal {
    margin-top: 4px;
    padding-right: 10px;
}

.icon-screenshot {
   background-position: -141px -96px;
    width: 20px;
}

.red1 {
background-color:red;}
</style>
</head>
<body class="exampage">
<!-- <div class="text-center"><label id="message"></label></div> -->
<div class="main container-fluid">
    <div class="row-fluid">
        <div class="content span12">
            <div class="main-content">
                <fieldset class="well">
                    <div class="header">
                    <input type="hidden" id="serverDateTime" value="${serverDateTime}">                   
                  	<c:if test="${isCopyRightEnabled}">
                        <img class="oes-logo"  src="<c:url value="/resources/images/${clientid}_inner-mkcloeslogo.png"></c:url>"  alt="">
					
					</c:if>
						
						
						<img class="mkcl-logo" src="<c:url value= "/resources/images/${clientid}_companylogo.png"></c:url>" alt="">
								<div class="span2 pull-right" style="padding-top:4px;">
						<div id="speedDisplayDiv" class=" btn wifi-btn ml-2">
						 
						
						 <%-- <img class="wifi-icon" src="<c:url value="/resources/images/wifi-icon.png"></c:url>"  alt=""> --%>
						  <div class=""> <i class="icon-greyer icon-signal"></i> <div id="speedDisplay" style="display:inline"></div>  </div> </div>
						    <div class = 'toggle-switch pull-right mr-2'>
							<label id="darkmodebtn">
						    	<input type = 'checkbox' id="darkModeSlider">
						        <span class = 'slider'></span>
						    </label>
						    
						   
					    </div>
						</div>
							<div class="event-title">${paper.name }</div>
					
					    
					    
					    
					    
                     </div>
                      <sitemesh:write property='body'/>
                    </fieldset>
            </div>            
         <div class="footer span12">
                <div class="holder">
                    <p class="pull-left footer-text">
                    <spring:message code="global.Copyright"/> 
                     <spring:message code="global.footerCompanyName"/> 
                     <!--Ekhtibar powered by TETCO &nbsp; <img src="<c:url value= "/resources/images/Ekhtibar-logo.png"></c:url>" alt="MKCL"> --></p>
                    <!-- <a id="to-top" class="btn btn-grey pull-right" href="#"><i class="icon-chevron-up icon-greyer"></i></a> -->
                </div>
            </div> 
        </div>
    </div>
</div>   
</body>