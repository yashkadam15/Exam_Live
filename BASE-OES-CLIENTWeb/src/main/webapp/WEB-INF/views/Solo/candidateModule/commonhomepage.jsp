
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>



<input type="hidden" value="${currentExamEvent.noofBonusWeek}" name="noOfBonusWeek" id="noOfBonusWeek" />
<input type="hidden" value="${currentExamEvent.maxPapersforBonusWeek}" name="maxPapersForBonusWeek" id="maxPapersForBonusWeek" />
<input type="hidden" value="${currentExamEvent.maxPapersScheduleByCandidate}" name="maxPapersScheduleByCandidate" id="maxPapersScheduleByCandidate" />
<input type="hidden" value="${availableNumberOfBonusWeek}" name="availableNumberOfBonusWeek" id="availableNumberOfBonusWeek" />
<input type="hidden" value="${isBonusWeek}" name="isBonusWeek" id="isBonusWeek" />

<script type="text/javascript">
	$(document).ready(function() {
		
		//schedule paper
		$('.lnkTakeTestbtn').click(function(e) {
			
			if(e.which!=2)
			{
				e.preventDefault();
				proceed(this);
			}
			else
			{
				e.preventDefault();
			}
		});
		
		
		
	});
	
	function checkForExamClient(obj){
		//if paper is typing and browser is Secured
		//then allow for test
		//otherwise prevent for test
		if(($(obj).hasClass("typingTest") || $(obj).hasClass("practicalTest")) && navigator.userAgent.search('MOSB') < 0){
			$('#modal-examclientallowed').modal('show');
			return false;
		}
		return true;
	}

	function proceed(object) {		
		 if(checkForExamClient(object)){
			//This is no more need because freamwork itself start in popup window from homepage.;changedBy amoghs; 
			
			 /*if ($(object).data('mode') === 'FullScreen') {
				window.open($(object).data('lnk'), "ExamPage", "fullscreen=yes,scrollbars=yes,location=no");
			} else if ($(object).data('mode') === 'NormalScreen') {
				window.location.href = $(object).data('lnk');
			}*/
			
			//window.location.href = $(object).data('lnk');			
			$(object).parent(".examform").submit();
			
		} 
		
	}
	
	//refresh page
	function refreshPage(){
		//this method is called only from EXAM Client	
		setInterval(function(){$.ajax({ cache : false , url : "../examClient/keepAlive" });},600000);
	}
	
</script>
<script type="text/javascript">
	$(document).ready(function() {

		//free paper
		$('.lnkFreeTakeTest').click(function(e) {

			var dcidcnt = parseInt($(this).data('dcidcnt')) || 0;
			var noOfBonusWeek = parseInt($("#noOfBonusWeek").val()) || 0;
			var maxPapersScheduleByCandidate = parseInt($("#maxPapersScheduleByCandidate").val()) || 0;
			var maxPapersForBonusWeek = parseInt($("#maxPapersForBonusWeek").val()) || 0;
			var availableNumberOfBonusWeek = parseInt($("#availableNumberOfBonusWeek").val()) || 0;
			var isBonusWeek = $("#isBonusWeek").val();

			//set values to modal
			$(".mxPaperByWeek").text(maxPapersForBonusWeek);
			$(".mxPaperByCand").text(maxPapersScheduleByCandidate);
			$(".mxBonusWeeks").text(noOfBonusWeek);

			//set if empty
			if (!dcidcnt) {
				dcidcnt = 0;
			}

			//set if empty
			if (!noOfBonusWeek) {
				noOfBonusWeek = 0;
			}

			//if display category count is less than allocated
			//display category allocated count
			if (dcidcnt < maxPapersScheduleByCandidate) {
				proceed(this);
				return true;
			}

			//check whether bonus weeks present
			if (noOfBonusWeek == 0) {
				$('#modal-noBonusallowed').modal('show');
				return false;
			}

			//check all papers for bonus week are utilised or not
			if (dcidcnt < maxPapersForBonusWeek && isBonusWeek === "true") {				
				proceed(this);
				return true;
			} else if (isBonusWeek === "true") {
				$('#modal-allBonusPapersUsed').modal('show');
				return false;
			}

			//check whether all bonus weeks used or not
			if (availableNumberOfBonusWeek == noOfBonusWeek && dcidcnt == maxPapersForBonusWeek) {
				$('#modal-allBonusUsed').modal('show');
				return false;
			}

			//check allowed for bonus week and show dialog
			if (dcidcnt == maxPapersScheduleByCandidate && isBonusWeek === "false") {
				$('#replicateAnchore').data('lnk', $(this).data('lnk'));
				$('#replicateAnchore').data('mode', $(this).data('mode'));
				$('#modal-bonusallowed').modal('show');
				return false;
			}
			return false;
		});

		//close modal
		$("#replicateAnchore").click(function(e) {
			$('#modal-bonusallowed').modal('hide');
		});
		
		//view syllabus
		
		$(".viewSyllabusBtn").click(function(e) {
			$("#hiddenIframe").hide();
			 $("#loadingsyllabus").show();
			$('#modal-viewSyllabus').modal('show');
			 var paperID = $(this).data("value");
			 var url =$("#syllabusIframeURL").val();
			 $("#hiddenIframe").prop("src","").prop("src",url+"?paperID="+paperID);
			 $('#hiddenIframe').load(function() {
				 $("#loadingsyllabus").hide();
				 $("#hiddenIframe").show();
			 });
		});

	});

	function post_to_url(param1, param2) {
		var params = {
			examEventID : param1,
			inCollapse : param2,
		};
		var method = "post"; // Set method to post by default, if not specified.
		var path = "viewActivityCalendar";
		var form = $(document.createElement("form")).attr({
			"method" : method,
			"action" : path
		});
		$.each(params, function(key, value) {
			$.each(value instanceof Array ? value : [ value ], function(i, val) {
				$(document.createElement("input")).attr({
					"type" : "hidden",
					"name" : key,
					"value" : val
				}).appendTo(form);
			});
		});
		form.appendTo(document.body).submit();
	}
</script>

<input type="hidden" id="reqUserAgent" value="${reqUserAgent}" />
<!-- all papers syllabus Modal -->
<input id="syllabusIframeURL"  type="hidden"  value="<c:url value="/candidateModule/viewPaperSyllabus"></c:url>" />
<div id="modal-viewSyllabus" Class="modal hide fade"  tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="false" data-keyboard="true" data-backdrop="static">
			<div class="modal-header">
				<h3 id="syllabusHeaderPart"></h3>
			</div> 
			<div class="modal-body" style="padding: 10px;">
				<h4 style="text-decoration: underline;">
					<spring:message code="Candidate.syllabus" />
				</h4> 
                <label id="loadingsyllabus" ><spring:message code="homapage.loadingsyllabus" /></label>
				<!-- iframe -->
				<iframe src="" style="display: none;margin: 2px 0 0 0;width: 100%;border: none;height: 10% !important;" id="hiddenIframe" ></iframe>
			</div>
			<div class="modal-footer">
				<button class="btn" data-dismiss="modal" aria-hidden="true">
					<spring:message code="homepage.Exit" />
				</button>
			</div>
		</div>


<!-- Modal for group Login Message -->
<c:choose>
	<c:when test="${labSessionGroupInfo!=null}">
		<div id="modalGroup-group" Class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="false" data-keyboard="true" data-backdrop="static">
			<div class="modal-header Group alert-error text-center">
				<h5>
					<spring:message code="homepage.grouploginrequired" />
				</h5>
			</div>
			<div class="modal-body">
				<spring:message code="homepage.youarein" />
				<b>${labSessionGroupInfo.groupMaster.groupName}</b>.
				<spring:message code="homepage.memebersare" />
				<br> <br>
				<table class="table table-striped table-complex table-condensed table-bordered">
					<tr>
						<th></th>
						<th><spring:message code="homepage.memebername" /></th>
						<th><spring:message code="homepage.loginid" /></th>
					</tr>
					<c:forEach var="candidate" items="${labSessionGroupInfo.groupCandidateAssociations}" varStatus="i">
						<tr>
							<td>${i.index+1}</td>
							<td>${candidate.candidate.candidateFirstName}&nbsp;${candidate.candidate.candidateMiddleName}&nbsp;${candidate.candidate.candidateLastName}</td>
							<td>${candidate.candidate.candidateUserName}</td>
						</tr>
					</c:forEach>
				</table>
			</div>
			<div class="modal-footer">
				<button class="btn" data-dismiss="modal" aria-hidden="true">
					<spring:message code="homepage.Exit" />
				</button>
			</div>
		</div>
	</c:when>
	<c:otherwise>
		<div id="modalGroup-group" Class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="false" data-keyboard="true" data-backdrop="static">
			<div class="modal-header Group alert-error text-center">
				<h5>
					<spring:message code="homepage.grouploginrequired" />
				</h5>
			</div>
			<div class="modal-body">
				<h4>
					<spring:message code="homepage.notloginyet" />
				</h4>
			</div>
			<div class="modal-footer">
				<button class="btn" data-dismiss="modal" aria-hidden="true">
					<spring:message code="homepage.Exit" />
				</button>
			</div>
		</div>
	</c:otherwise>
</c:choose>

<div id="modal-noBonusallowed" Class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="false" data-keyboard="true" data-backdrop="static">
	<!-- <div class="modal-header Group alert-block text-center">
			<h5>
				No Bonus Week allowed
			</h5>
		</div> -->
	<div class="modal-body">
		<h4>
			<spring:message code="homepage.bonuswkinfo.warnings.1" />
		</h4>
	</div>
	<div class="modal-footer" style="text-align: center;">
		<button class="btn text-center" data-dismiss="modal" aria-hidden="true"><spring:message code="homepage.ok" /></button>
	</div>
</div>

<div id="modal-allBonusUsed" Class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="false" data-keyboard="true" data-backdrop="static">
	<!-- <div class="modal-header Group alert-block text-center">
			<h5>
				No Bonus Week allowed
			</h5>
		</div> -->
	<div class="modal-body">
		<h4>
			<spring:message code="homepage.bonuswkinfo.warnings.2" />
		</h4>
	</div>
	<div class="modal-footer" style="text-align: center;">
		<button class="btn text-center" data-dismiss="modal" aria-hidden="true"><spring:message code="homepage.ok" /></button>
	</div>
</div>

<div id="modal-allBonusPapersUsed" Class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="false" data-keyboard="true" data-backdrop="static">
	<!-- <div class="modal-header Group alert-block text-center">
			<h5>
				No Bonus Week allowed
			</h5>
		</div> -->
	<div class="modal-body">
		<h4>
			<spring:message code="homepage.bonuswkinfo.warnings.3" />
		</h4>
	</div>
	<div class="modal-footer" style="text-align: center;">
		<button class="btn text-center" data-dismiss="modal" aria-hidden="true"><spring:message code="homepage.ok" /></button>
	</div>
</div>

<div id="modal-bonusallowed" Class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="false" data-keyboard="true" data-backdrop="static">
	<div class="modal-header Group alert-error text-center">
		<h5>
			<spring:message code="homepage.bonuswkinfo.warnings.4" />
		</h5>
	</div>
	<div class="modal-body">
	  <spring:message code="homepage.bonuswkinfo.warnings.5" />
	</div>
	<div class="modal-footer">
		<a data-mode="" class="btn lnkTakeTestbtn" data-lnk="" id="replicateAnchore"><spring:message code="homepage.bonuswkinfo.warnings.6" /></a>
		<button class="btn" data-dismiss="modal" aria-hidden="true"><spring:message code="homepage.bonuswkinfo.warnings.7" /></button>
	</div>
</div>

<div id="modal-examclientallowed" Class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="false" data-keyboard="true" data-backdrop="static">
	<div class="modal-body">
		<h4>
			 <spring:message code="homepage.examclinetfortyping" />
		</h4>
	</div>
	<div class="modal-footer" style="text-align: center;">
		<button class="btn text-center" data-dismiss="modal" aria-hidden="true"><spring:message code="homepage.ok" /></button>
	</div>
</div>

