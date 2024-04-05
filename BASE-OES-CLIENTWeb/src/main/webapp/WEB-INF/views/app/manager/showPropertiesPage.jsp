<%-- <%@ page contentType="text/html;charset=utf-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="sf"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page errorPage="../common/jsperror.jsp"%> --%>

<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page errorPage="../common/jsperror.jsp"%>

<html>
<head>
<style type="text/css">
.test-admin-portal .row-fluid [class*="span"]:first-child {
	display: none !important;
}

.test-admin-portal .row-fluid [class*="span"] {
	display: none !important;
}

#demotable_info {
	margin-left: 300px;
	font-size: 15px;
}

div.dataTables_paginate {
	margin-left: -42px !important;
}

ul li {
	margin-right: 4px;
}
</style>
<spring:message code="project.resources" var="resourcespath" />
<link rel="stylesheet" type="text/css" href="<c:url value='/resources/style/dataTable.css'></c:url>" />
<script type="text/javascript" src="<c:url value='/resources/js/gridDataTable.js'></c:url>"></script>

<title>Update Properties File</title>	

</head>



<body>

	<div class="main-header text-center">
		<h3><spring:message code="update.properties"/></h3>
	</div>


	<form:form action="updateProperty" modelAttribute="proMap" method="post" id="porpMapform">
		<!-- <input type="hidden" id="serverReload" name="serverReload" value=""> -->
		
		<div class="control-group">
		  <input type="text" id="search" placeholder="search here" class="input-medium search-query" style="width: 16%;">
		  <!-- <button type="button" id="go"  value="Go!" class="btn btn-secondary btn-rounded btn-long btn-sm">Search</button> -->
		  <button type="button" id="ShowAll" value="ShowAll" class="btn btn-primary btn-rounded btn-long btn-sm pull-right"><spring:message code="show.showAll"/></button>
		</div>

		<table id="table2" class="table table-bordered table-hover">
			

			<c:if test="${propertiesModel != null}">
				 
				 	<thead>
				     	<th><spring:message code="show.key"/></th>
				      	<th><spring:message code="show.value"/></th>
				       	<th><spring:message code="show.remove"/></th>
				        <th><spring:message code="show.undo"/></th>
				    </thead>
  					
				<c:forEach var="map" items="${propertiesModel}" varStatus="i">
				
					
					
					<tr id="tr_tdkey${i.index}">

						<td id="tdkey${i.index}">${map.key}</td>

						<td id="tdvalue${i.index}">
							<input type="text" name="map['${map.key}']" value="${fn:escapeXml(map.value)}" class="input-xlarge"  />
						</td>
						
						<td id="tdremove${i.index}">
							<input id="remove${i.index}" type="button" value="Remove"
								onClick="getKeyText()" class="btn btn-danger btn-rounded btn-long btn-sm"/>
						</td>
						<td id="tdundo${i.index}">
							<input id="undo${i.index}" type="button" value="Undo"
								onClick="doUndo()" class="btn btn-success btn-rounded btn-long btn-sm"/>
						</td>

					</tr>


				</c:forEach>


				<%--  <tr>
					<td><input type="text"
							name="map['${propertiesModel.key}']" value="6" style="width: 75%;" placeholder="Add Key" /></td>
					<td><input type="text"
							name="map['${propertiesModel.key}']" value="9" style="width: 75%;" placeholder="Add Value"/></td>
					
					 <td><input type="button" class="btn btn-success btn-rounded btn-long btn-sm"
					id="addMoreRows" value="Add More Data"/></td>
					</tr>  --%>

			</c:if>

		</table>

		
		<div class="control-group text-center">
			  <button type="submit" id="update" value="Update" class="btn btn-success btn-rounded btn-long btn-sm" onclick="showMessage(event);"><spring:message code="global.update"/></button>
			  <button type="button" id="addMoreRows"  value="Add More Data" class="btn btn-primary btn-rounded btn-long btn-sm"><spring:message code="scheduleExam.addMore"/></button>
		</div> 
	</form:form>


	<script type="text/javascript">
		$(document).ready(function() {
			
			
			$("[id^='undo']").attr('disabled',true);
			
			$("#search").on("keyup", function() {
			    var value = $(this).val().toLowerCase();
			    $("[id^='tr_tdkey']").filter(function() {
			      $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
			   });
			  });	

			/* $("#go").click(function() {
				
				var searchText = $('#search').val();
				
					$("[id^='tr_tdkey']").each(function() {
				
					var key = $(this).find("[id^='tdkey']").text();
					

					if (key.indexOf(searchText) != -1) {
						$(this).show();

					} else {

						$(this).hide();

					}

				}); // end Tr loop

			}); */
			

			$("#ShowAll").click(function() {

				$('#table2  tr').each(function() {

					$(this).show();
					$('#search').val('');

				});
			});
			
			$("#update").click(function(){
				
				//get selected removed key
				 $("[id^='tr_tdkey']").each(function() {
					 
				    var key = $(this).find("[id^='tdkey']").text();
				 	var theColorIs = $(this).find("[id^='tdkey']").css("color");
						if(theColorIs == "rgb(255, 0, 0)"){
				    		//var mix = "REMOVED_"+key;
				    		$(this).find("[id^='tdkey']").val("REMOVED_"+key);
				    	}else{
				    	$(this).find("[id^='tdkey']").val(key);
				    }
	
					var keyValue = $(this).find("[id^='tdkey']").val();
				
					$(this).find("[id^='tdvalue']").children().attr("name", "map['"+keyValue+"']"); 

			 	});  
			
				//for Add more data
				 $("[id^='new_tr_tdkey']").each(function() {
					    var key = $(this).find("[id^='new_tdkey']").val();
						$(this).find('input[name=hidevalue]').val(key);
						var hiddenValue = $(this).find("[id^='hidden_tdvalue']").val();
						$(this).find("[id^='new_tdvalue']").attr("name", "map['"+hiddenValue+"']");

				 }); // end Tr loop */ 

					/* var first = $("#new_tdkey").val();
					alert("first"+first);
					$('input[name=cheese]').val(first);
					var second = $("#hidden_tdvalue").val();
					
					$("#new_tdvalue").attr("name", "map['"+second+"']");
					var fourth = $("#new_tdvalue").val();
					
					
					alert("second..........."+second);
					
					alert("fourth..........."+fourth); */
					
				/* var r = confirm("Are You sure restart server, After save data.");
				if (r == true) {
					 $("#serverReload").val("true");
				}else{
					 $("#serverReload").val("false");
				}  */		

			}); 
			
			$("#addMoreRows").click(function() {
					
				var count=$("#table2 tr").length;
					
				$('#table2 ').each(function() {
						 
						var first ="<tr id=\"new_tr_tdkey";
						var second="\"><td><input type=\"text\" placeholder=\"key\" name=\"new_tdkey\" value=\"\" style=\"width:43%;\" required=\"true\" id=\"new_tdkey";
					   	var third ="\"></input></td><td><input type=\"text\" value=\"\"  placeholder=\"value\" name=\"map['']\" style=\"width:43%;\" required=\"true\" id=\"new_tdvalue";
					   	var fourth="\"></input><td id=\"\"><input type=\"button\" value=\"Remove\" onClick=\"removeRow()\" class=\"btn btn-danger btn-rounded btn-long btn-sm\" id=\"new_remove"
						var fifth="\"></input></td><td><input type=\"hidden\" value=\"\" name=\"hidevalue\" id=\"hidden_tdvalue";
						var sixth ="\"></input></td></tr>";
				          
					    markup = first+count+second+count+third+count+fourth+count+fifth+sixth; 

			            tableBody = $("#table2"); 
			            tableBody.append(markup); 
			        	count++;
			        	
					}); 
			 });	

		});
		

		function getKeyText() {
			
			var key = this.event.target.id;
			$("#td"+key).prevAll().css("color","red");
			$("#td"+key).prevAll().children().attr('readonly',true);
			$("#"+key).attr('disabled', true);
		//	var data = $("#td" + key).prevAll().eq(1).text();
		
			$("#td"+key).next().children().attr('disabled',false);
			$("#td"+key).next().children().attr('enabled',true);
			//alert("ttt "+tt);
			
			//$("#td"+key).next().attr('enabled',true);
			
			
			} 
	
		function doUndo() {
			
			var key = this.event.target.id;
			
		//	$("#td"+key).next().children().attr('disabled',false);
			
			$("#td"+key).prevAll().css("color","black");
			$("#td"+key).prevAll().children().attr('readonly',false);
			
			$("#td"+key).prevAll().children().attr('enabled',true);
			$("#td"+key).prevAll().children().attr('disabled',false);
		/* 	$("#"+key).prev().attr('enabled', true);
			$("#"+key).prev().attr('disabled', false); */
			
			$("#"+key).attr('disabled', true);
			
					
	} 	 

	function showMessage(e) {
		var r = confirm('<spring:message code="showPropertiesPage.afterUpdateFile"/>');
		if (r == true) {
			return true;
		} else {				
			e.preventDefault();
		}
	}
	
	function removeRow() {
		$('#table2').on('click', "[id^='new_remove']" , function(){
		    $(this).closest ('tr').remove ();
		});
				
	} 	 
	
	</script>

</body>

</html>




