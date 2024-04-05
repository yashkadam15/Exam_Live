<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page errorPage="../common/jsperror.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<title><spring:message code="exploriments.title" /></title>
<spring:message code="project.resources" var="resourcespath" />
</head>
<body>
	<fieldset class="well" style="margin-top: -10px;">
		<div id="headingDiv">
			<legend>
				<span><spring:message code="exploriments.heading" /></span>
			</legend>
		</div>

		<div class="holder" style="padding:0px;margin:0px;">
			<div id="tree-view">			
			</div>			
		</div>
		<div id="iframeDiv" style="margin-top: 15px;">
		
		
		</div>
		<div align="center" id="divBtnBack">
			<button type="button" id="btnBack" class="btn btn-blue" ><spring:message code="exploriments.back" /></button>
		</div>
		<%-- <div class="holder" id="contentDiv">
			<iframe id="contentFrame" name="contentFrm" style="height: 750px">
			
			</iframe>
			
			<div align="center">
				<button type="button" id="btnBack" class="btn btn-blue" ><spring:message code="exploriments.back" /></button>
			</div>
		</div> --%>
	</fieldset>

	<script type="text/javascript">
	 $(document).ready(function(){
		/* $("#contentDiv").hide(); */
		$("#tree-view").show();
		$("#headingDiv").show();
		$("#divBtnBack").hide();
		$("#iframeDiv").hide();
		
		var contentFolderPath="../resources/content/Exploriments-OES/";
		 var jsFilePath = "../resources/content/Exploriments-OES/course/162/1/tree.js";
			var xmlhttp;
			if (window.XMLHttpRequest) {
				// code for IE7+, Firefox, Chrome, Opera, Safari
				xmlhttp = new XMLHttpRequest();
			} else {
				// code for IE6, IE5
				xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
			}
			xmlhttp.onreadystatechange = function() {
				if (xmlhttp.readyState == 4) {
                                                                        // set content of js file to a div or iframe.
					$("#tree-view").html(xmlhttp.responseText);
				} else if (xmlhttp.status == 404) {
					$("#tree-view").html('<spring:message code="explorimentsTree.fileNotFound"/>');
				} else {
					$("#tree-view").html('<spring:message code="explorimentsTree.createTree"/>');
				}
			};

			xmlhttp.open("GET", jsFilePath, false);
			xmlhttp.send(null);
			
			
			// show or hide divs
			$("#tree-view li > a").click(function(event){
				event.preventDefault();
				var contentPath=$(this).attr("href");
				var actualContentPath=contentFolderPath+contentPath;
				
				casif(actualContentPath);
				
				$("#contentFrame").css({"min-height":"625px"});
				
				/* $("#contentDiv").show(); */
				$("#tree-view").hide();
				$("#headingDiv").hide();
				$("#divBtnBack").show();
				$("#iframeDiv").show();
			});
			
			$("#btnBack").click(function(){
				/* $("#contentDiv").hide(); */
				$("#tree-view").show();
				$("#headingDiv").show();
				$("#divBtnBack").hide();
				$("#iframeDiv").hide();
			});
			
			// tree collapse and expand
			/* anchors = $("#tree-view").find("a");
			for ( var i = 0; i < anchors.length; i++) {
				$(anchors[i]).bind("click", showToggle);
			} */


		
	 
	 }); /* End of document ready */

	 	/* function showToggle() {
			$(this).parentsUntil("li").each(function(){
				$(this).siblings().toggle();
			});
		} */
		
		
		function casif(src) {
			var oldframe = document.getElementById('contentFrame');
			var iframeHeaderCell = document.getElementById('iframeDiv');
			var iframeHeader = document.createElement('iframe');
			iframeHeader.id = 'contentFrame';
			iframeHeader.src = src;			
			if (oldframe) {
				iframeHeaderCell.replaceChild(iframeHeader, oldframe);
			} else {
				iframeHeaderCell.appendChild(iframeHeader);
			}
		}
	</script>

</body>
</html>