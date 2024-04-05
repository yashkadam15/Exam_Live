<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html lang="en">
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><sitemesh:write property='title' /></title>
<sitemesh:write property='head' />
<link href="<c:url value='/resources/style/template_DS.css?=v04042023A'></c:url>" rel="stylesheet">
<link rel="stylesheet" href="<c:url value='/resources/style/jquery.scrollbar.css'></c:url>" type="text/css"/>
<link rel="stylesheet" href="<c:url value='/resources/style/selectFix.css'></c:url>" type="text/css" />
<link rel="stylesheet" href="<c:url value='/resources/style/calclayout.css'></c:url>" type="text/css" />
<!--[if IE 7]>
<style>
.exam-info .exam-ins .span5 {margin-left:0}
.exam-info .exam-ins .span7 .btn {margin-top: 4px; padding-top: 0; height:5px}
.quick-ques > .btn {border:1px solid #ccc}
</style>
<![endif]-->
<script src="<c:url value='/resources/js/jquery-1.12.0.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/bootstrap.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/jquery.scrollbar.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/selectFix.js'></c:url>"></script>
<script src="https://www.wiris.net/demo/plugins/app/WIRISplugins.js?viewer=image"></script>
<script>
	$(document).ready(function() {	
		if(navigator.userAgent.search('MOSB') >= 0){
	    	$('select').each(function(){
	    		$(this).fixCEFSelect();
	    	});
		}
	});
</script>
<style>
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
</style>
</head>
<body class="exampage digital-school">
<div class="main container-fluid">


    <div class="row-fluid">
        <div class="content span12">
            <div class="main-content">
            			
                <fieldset class="well">
                    <div class="header">                   
                     
                        <img class="oes-logo"  src="<c:url value="../resources/images/logo-inner.png"></c:url>"  alt="">
                        <img class="mkcl-logo" src="<c:url value= "../resources/images/companylogo.png"></c:url>" alt="">
                        <div class="event-title">${paper.name }</div>
                     </div>
                     
                      <sitemesh:write property='body'/>
                     
                    </fieldset>
            </div>            
           <%--  <div class="footer span12">
                <div class="holder">
                    <p class="pull-left"><spring:message code="global.Copyright"/> <spring:message code="global.footerCompanyName"/></p>
                    <a id="to-top" class="btn btn-grey pull-right" href="#"><i class="icon-chevron-up icon-greyer"></i></a>
                </div>
            </div> --%>
        </div>
    </div>
</div>   
</body>