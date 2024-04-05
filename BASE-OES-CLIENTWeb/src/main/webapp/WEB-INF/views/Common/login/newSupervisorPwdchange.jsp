<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>


<html>
<head>
<title><spring:message code="passwordchange.title"/></title>
<spring:message code="project.resources" var="resourcespath" />

<style type="text/css">
 input[type="text"] {
	width: 90px;
} 

.notfound{
  display: none;
}

</style>

<script type="text/javascript" src="<c:url value='/resources/js/md5_encrypt.js'></c:url>"></script>
</head>

<body>

	<c:if test="${listOfFailedVenueCode !=null && fn:length(listOfFailedVenueCode)!=0 }">
		<div class=" alert alert-failed form-group" style="display: flex;">
	     	<label id="papertime-lbl" for="" class="col-sm-2 required">
				<b><spring:message code="supPassChange.failedCenterCodeList"/> &nbsp :&nbsp</b>
			</label>
			<div class="col-sm-10">
		  		<b>${listOfFailedVenueCode}</b>
		  	</div>
		 </div>	
     </c:if>
		
	<fieldset class="well">
		<legend>
			<span><spring:message code="menu.supervisorPwdChange"/></span>
		</legend>
		
	<div class="holder">
	<!-- 	waiting image -->
	<div class="modal fade" id="userMessage" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-body text-center">
	       	<h5><spring:message code="importTemplate.waitingmsg"/> </h5>
			<img style="width: 300px; height: 190px;"
				src="<c:url value="../resources/images/wait.gif"  >
	  			</c:url>"
				alt="OES">
	      </div>
	    </div>
	  </div>
	</div>
	<!-- Start Export & import to change bulk of supervisor password --> 
		<form:form action="importTemplate" method="post" enctype="multipart/form-data" class="form-horizontal form-normal" id="getform" > 
			 <div class="form-action text-right">
				<a href="../login/exportSupervisorPwdTemplate" class="btn btn-success btn-rounded btn-long btn-sm" > <spring:message code="exportTemplate.downloadDataTemplate"/></a> 
			 </div>
			  <div class="form-group row align-items-center" style="margin-left: 10px;">
                	<label for="file" class="col-sm-4 col-form-label">
                       <spring:message code="importTemplate.selectExcelFile"/></label>
                   <div class="col-sm-8">
                       <input type="file" class="form-control-file" name="file" id="file">
                   </div>
              
				 <div class="form-action text-left">
					<button type="submit" class="btn btn-success btn-rounded btn-long btn-sm " id="importBtn">
						<spring:message code="importTemplate.importDataButton"/>
					</button >
				</div>
			</div>
			
		</form:form>
		<!-- end Export & import to change bulk of supervisor password --> 
		
			<form:form modelAttribute="examCenterSupervisorAssociationViewModel" id="frmPasswordChng">
				<input type="hidden" name="supervisorPwd"  id="supervisorPwd" value="" />
				<input type="hidden" name="audioResetPwd" id="audioResetPwd" value="" />
				<input type="hidden" name="closeBrowserPwd" id="closeBrowserPwd" value="" />
				<input type="hidden" name="examVenueID" id="examVenueID" value="" />
				
				
				
				<!-- enter center code to search -->
				 <input type="text" id="search" placeholder="Enter center code" style="width: 196px;margin-bottom: 4px;margin-left: 621px;" class="input-medium search-query">
				
				<table class="table table-striped table-bordered" id="chngpwdtblid">
					<thead>
						<tr>
							<!-- Change from inline to external css by Apoorv  -->
							<th class="dark-blue" colspan="8"><spring:message  code="passwordchange.centerDetails"></spring:message></th>
						</tr>
						
						<tr>
							<th><spring:message  code="passwordchange.srNo"></spring:message></th>
							<th><spring:message  code="passwordchange.centerCode"></spring:message></th>
							<th><spring:message  code="passwordchange.centerName"></spring:message></th>
							<th><spring:message  code="passwordchange.superPwd"></spring:message></th>
							<th><spring:message  code="passwordchange.audioPwd"></spring:message></th>
							<th><spring:message  code="SupervisorPwdChange.closeBrowserpassword"/></th>
							<th></th>
							<th></th>
						</tr>
						</thead>
							<c:forEach var="examCenterSupervisorAssociationList" items="${examCenterSupervisorAssociationViewModel.examCenterSupervisorAssociationList}" varStatus="i">
						<tbody>
						<tr>
							<td>${i.index+1}.</td>
													
							<td>${examCenterSupervisorAssociationList.examVenueCode } <form:hidden path="examCenterSupervisorAssociationList[${i.index }].examVenueCode" /></td>
							<td>${examCenterSupervisorAssociationList.examVenueName}<form:hidden path="examCenterSupervisorAssociationList[${i.index }].examVenueName" /></td>

 							<td><form:password htmlEscape="true" path="examCenterSupervisorAssociationList[${i.index }].supervisorPassword" id="supervisorPassword${i.index }" disabled="true" placeholder="*********" style="width:90px" /></td>
							<td><form:password htmlEscape="true" path="examCenterSupervisorAssociationList[${i.index }].audioResetPassword" id="audioResetPassword${i.index }" disabled="true" placeholder="*********" style="width:90px"/></td>
							<td><form:password htmlEscape="true" path="examCenterSupervisorAssociationList[${i.index }].closeBrowserPassword" id="closeBrowserPassword${i.index }" disabled="true" placeholder="*********" style="width:90px"/></td>							
						  	
 							<td>
 								<form:input path="examCenterSupervisorAssociationList[${i.index }].fkExamVenueID" id="examVenueID${i.index }" style="display:none"/>		
 								 <form:hidden path="examCenterSupervisorAssociationList[${i.index }].fkExamVenueID" />
								<form:button type="button" class="btn" id="resetLink${i.index }"><spring:message code="supPassChange.change"/></form:button>
								<form:button class="btn btn-red" id="setLink${i.index }" style="display: none;"><spring:message code="supPassChange.set"/></form:button>
							</td>
							<td id="tdcnllinkid${i.index }"><form:button type="button" class="btn" id="cancelLink${i.index }"><spring:message code="supPassChange.cancel"/></form:button></td>
						</tr>
						</tbody>
						</c:forEach>
						 <!-- Display this <tr> when no record found while search -->
						<tr class='notfound'>
     						<td colspan='8'><spring:message code="supPassChange.noRecordFound"/></td>
   						</tr>
				</table>
				
				<p>
					<spring:message code="supPassChange.newPassStrong"/>
					<ul>
						<li><spring:message code="supPassChange.eightCharactersLong"/></li>
						<li><spring:message code="supPassChange.oneLowerCaseLetter"/></li>
						<li><spring:message code="supPassChange.oneUpperCaseLetter"/></li>
						<li><spring:message code="supPassChange.oneDigit"/></li>
						<li><spring:message code="supPassChange.oneSpecialCharacter"/></li>
					</ul>  
				</p>
			</form:form>
			
			</div>
			
	</fieldset>


	<script type="text/javascript">
	
		$(document).ready(function() {
			
		$('#search').keyup(function(){
		    var search = $(this).val();
			if(search==""){
				$('table tbody tr').show();
				return true;
			}
		    // Hide all table tbody rows
		    $('table tbody tr').hide();
		    $('.notfound').hide();
		    // Count total search result
		    var len = $('table tbody tr:not(.notfound) td:nth-child(2):contains("'+search+'")').length;

		    if(len > 0){
		      // Searching text in columns and show match row
		      $('table tbody tr:not(.notfound) td:contains("'+search+'")').each(function(){
		         $(this).closest('tr').show();
		      });
		    }else{
		    	$('.notfound').show();
		    }
		    
		  }); //search end here
		
		  $('#getform').submit(function(e){	
				var flag=0;
				var errorMsg="Please correct the following:";
				
				if($('#file').val()=="")
				{			
					flag=1;
					errorMsg+='\n -Please select File.';
				}
				else
				{			
				var FileUploadPath=$('#file').val();	
				var Extension = FileUploadPath.substring(FileUploadPath.lastIndexOf('.') + 1).toLowerCase();
				if(Extension!='xlsx' && Extension!='xls')
					{
					flag=1;
					errorMsg+='\n -Please select Excel File only.';
					}
				
				}
				if(parseInt(flag) > 0)
				{
					alert(errorMsg);
					return false;
				}
				
			
			 $("#userMessage").modal({ backdrop: 'static',
				    	  keyboard: false
				    	});	
			 //return true;			
			}); //get form end here
		
		  $(document).on('click', 'button[id^=resetLink]', function (e) {
		  	var id=$(this).attr("id");
		  	//alert("id  : "+id);
		  	var index = id.match(/\d+/); 	//resetLink123456 
	        //alert("index :"+index);
			$('#supervisorPassword'+index).prop("disabled",false).val("");
	        $('#audioResetPassword'+index).prop("disabled",false).val("");
			$('#closeBrowserPassword'+index).prop("disabled",false).val("");
			$(this).hide();
			$('#setLink'+index).show(true);
			
		}); 
		 
		
		  $(document).on('click', 'button[id^=cancelLink]', function (e) {
			  var id=$(this).attr("id");
			  	//alert("id  : "+id);
			  var index = id.match(/\d+/); 
			  
		  	$('#supervisorPassword'+index).attr("disabled","disabled");
			$('#audioResetPassword'+index).attr("disabled","disabled");
			$('#closeBrowserPassword'+index).attr("disabled","disabled");
			
			$('#resetLink'+index).show();
			$('#setLink'+index).hide();
		});
		  
		
		  $(document).on('click', 'button[id^=setLink]', function (e) {
			  var id=$(this).attr("id");
			  	//alert("id  : "+id);
			  var index = id.match(/\d+/); 
		        
		 	  let strongPassword = new RegExp('(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[^A-Za-z0-9])(?=.{8,})');
				if ($("#supervisorPassword"+index).val().trim().length==0) {
					alert('<spring:message code="passwordchange.enterSuperPwd" />');
					return false;
				}
				if ($("#audioResetPassword"+index).val().trim().length==0) {
					alert('<spring:message code="passwordchange.enterAudioPwd" />');
					return false;
				}
				if ($("#closeBrowserPassword"+index).val().trim().length==0) {
					alert('<spring:message code="SupervisorPwdChange.entercloseBrowserpassword" />');
					return false;
				}

				if(!strongPassword.test($("#supervisorPassword"+index).val().trim()))
				{
					alert('Supervisor password must be strong.');
					return false;
				}

				if(!strongPassword.test($("#audioResetPassword"+index).val().trim()))
				{
					alert('Audio reset password must be strong.');
					return false;
				}

				if(!strongPassword.test($("#closeBrowserPassword"+index).val().trim()))
				{
					alert('Close browser password must be strong.');
					return false;
				} 
				

				// hashed password related changes commited
				var hashMD5Sup = hex_md5($("#supervisorPassword"+index).val());
				var hashMD5audio = hex_md5($("#audioResetPassword"+index).val());
				var hashMD5closeBrowser = hex_md5($("#closeBrowserPassword"+index).val());
				
				//set to hidden field
				$('#supervisorPwd').val(hashMD5Sup);
				$('#audioResetPwd').val(hashMD5audio);
				$('#closeBrowserPwd').val(hashMD5closeBrowser);
				$('#examVenueID').val($("#examVenueID"+index).val());
				return true;
			});
			
					
		});//end of ready
		
	</script>


</body>
</html>
