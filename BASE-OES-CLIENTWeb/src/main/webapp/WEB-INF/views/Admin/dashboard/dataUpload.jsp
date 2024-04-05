<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<input type="hidden" id="autoUpload" value="${autoUpload == null ? 0 : autoUpload}"/>
<script type="text/javascript">
	$(document).ready(function() 
	{
		if($('#autoUpload').val()=='1')
		{
			ajaxUploadData(-1, -1);
		}
		$(".uploadBtn").click(function() 
		{
			ajaxUploadData($(this).data('paperid'), $(this).data('eventid'));
		});
	});
	
	function ajaxUploadData(paperId, eventID)
	{
		$.ajax({
			type : "GET",
			timeout : 1200000,
			url : '../upload/AjaxPerformUpload',					
			data : {
			    "paperID" : paperId,
			    "examEventID" : eventID
		    },
			global: false,
			success : function(data) 
			{
				console.log("success");
				console.log(data);
				if (data == 0) {
					showNoConnection();
				} else if (data == 6) {
					showDataUploadActiveInbackground();
				}else if (data == 3) {
					showErrorUpload();
				} else if (data == 4) {
					showNoDataAlreadyUplaoded();
				} else if (data == 5) {
					showServerNotResponding();
				} else if (data == 2) {
					showSuccessUpload();
				} else {
				   $("#modal-pleaseWait").modal('hide');
				}						
			},
			error : function(data)
			{
				console.log("error");
				console.log(data);
				showErrorUpload();
			}
		});
		$('#modal-pleaseWait').modal({
			  show : true,
			  keyboard: false
		});
		showPleasWait();
	}
	function showPleasWait(){
		hideAll();
		$("#plaesewait").show();
	}
	function showSuccessUpload(){
		hideAll();
		$(".successUpoad").show();
	}
	function showNoConnection(){
		hideAll();
		$("#noconnection").show();
		$("#commanfooter").show();
	}
	function showErrorUpload(){
		hideAll();
		$("#erroroccured").show();
		$("#commanfooter").show();
	}
	function showNoDataAlreadyUplaoded(){
		hideAll();
		$("#noDataToUploaded").show();
		$("#commanfooter").show();
	}
	function showServerNotResponding(){
		hideAll();
		$("#notResponding").show();
		$("#commanfooter").show();
	}
	function showDataUploadActiveInbackground(){
		hideAll();
		$("#uploadAlreadyInProgress").show();
		$("#commanfooter").show();
	}
	function hideAll(){
		$(".successUpoad").hide();
		$("#erroroccured").hide();
		$("#noconnection").hide();
		$("#commanfooter").hide();
		$("#plaesewait").hide();
		$("#noDataToUploaded").hide();
		$("#notResponding").hide();
	}
</script>

<div id="modal-pleaseWait" Class="modal hide fade" tabindex="-1"
	role="dialog" aria-labelledby="myModalLabel" aria-hidden="false"
	data-keyboard="true" data-backdrop="static" style="margin-top:9%">
	<div class="modal-header Group alert-error text-center">
		<h5>
			<p><spring:message code="dataupload.8"/></p>
		</h5>
	</div> 
	<div class="modal-body" id="plaesewait" style="display: none;text-align: center;" >
		
		<img alt="" src="../resources/images/progressbar.gif" style="width: 50%;"/>		
		<h4><spring:message code="dataupload.1"/><h4>
	</div>
	<div class="modal-body successUpoad"  style="display: none;text-align: center;">
		<h4><spring:message code="dataupload.2"/></h4>
	</div>
	<div class="modal-body" id="noconnection" style="display: none;text-align: center;">
		<h4><spring:message code="dataupload.3"/></h4>
	</div>
	<div class="modal-body" id="erroroccured" style="display: none;text-align: center;">
		<h4><spring:message code="dataupload.4"/></h4>
	</div>
	<div class="modal-body" id="noDataToUploaded" style="display: none;text-align: center;">
		<h4><spring:message code="dataupload.5"/></h4>
	</div>
	<div class="modal-body" id="notResponding" style="display: none;text-align: center;">
		<h4><spring:message code="dataupload.6"/></h4>
	</div>
	<div class="modal-body" id="uploadAlreadyInProgress" style="display: none;text-align: center;">
		<h4><spring:message code="dataupload.11"/></h4>
	</div>
	<div class="modal-footer successUpoad"  style="display: none;text-align: center;">
		<button class="btn text-center" style="text-align: center;" data-dismiss="modal"
			aria-hidden="true" id="btnok"><spring:message code="dataupload.7"/></button>
	</div>

	<div class="modal-footer" id="commanfooter" style="display: none;text-align: center;">
		<button class="btn text-center" style="text-align: center;" data-dismiss="modal"
			aria-hidden="true"><spring:message code="homepage.Exit"/></button>
	</div>
</div>
