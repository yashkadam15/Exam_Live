<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page errorPage="../common/jsperror.jsp"%>
<script src="<c:url value='/resources/js/simulation.js?${jsTime }'></c:url>"></script>
<script type="text/javascript">
function calllms(e) {
	var swfpswd=$("#swfpswd").val();
	return swfpswd;
}
</script> 
 
   <!-- Simulation -->
		
		
		
				
				<c:if test="${examViewModel.simulation!=null}">				
				<b><spring:message code="questionByquestion.question"></spring:message>&nbsp;${itemNo}:&nbsp; 				
				</b>
				<p class="question-wrap"></p> 
				<p class="question-wrap">${examViewModel.simulation.itemText}</p>				
				<c:if test="${examViewModel.simulation.itemFileImg != null && examViewModel.simulation.itemFileImg != ''  && fn:length(examViewModel.simulation.itemFileImg) > 0}">
		              	 	<img src="../exam/displayImage?disImg=${examViewModel.simulation.itemFileImg}"/><br>
		        </c:if>			
				<%-- <a class="btn openFlashbtn" data-src="../exam/decruptDecompressfile?encfile=${examViewModel.simulation.itemFilePath}" data-psw="${examViewModel.simulation.password}">Show swf</a>
			
				<a href="../exam/decruptDecompressfile?encfile=${examViewModel.simulation.itemFilePath}">Show swf</a> --%>
		
				 
				 <input type="hidden" id="swfpswd" name="swfpswd" value="${examViewModel.simulation.password}">
				 
						
				
				<object classid='clsid:d27cdb6e-ae6d-11cf-96b8-444553540000' 
				codebase='http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=10,0,0,0'
				id='objTag' name="objTag" width='800' height='600'  data="../exam/decruptDecompressfile?encfile=${examViewModel.simulation.itemFilePath}&fileExtension=swf">
				<param name='allowScriptAccess' value='always' />
				<param name='FlashVars' value="ver=alcera_1" />
				<param name='movie' value="../exam/decruptDecompressfile?encfile=${examViewModel.simulation.itemFilePath}&fileExtension=swf" />
				<param name='quality' value='high' />
				<param name='bgcolor' value='#ffffff' />
				<embed width="800" px height="600" px flashvars="ver=alcera_1"
					src="../exam/decruptDecompressfile?encfile=${examViewModel.simulation.itemFilePath}&fileExtension=swf" quality=high
					bgcolor=#FFFFFF width="800" height="600" name="myMovieName"
					type="application/x-shockwave-flash"
					pluginspage="http://www.macromedia.com/go/getflashplayer"
					href="/support/flash/ts/documents/myFlashMovie.swf" class="span8"></embed>
			    </object>			
			   	 
				</c:if>
				
				
				<!-- End of Simulation -->
				
				