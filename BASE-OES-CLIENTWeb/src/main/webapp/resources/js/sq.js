$(function() {

	var celldata=$("#celldata").val();
	//celldata='[{"rno":0,"column":[{"cno":0,"cvalue":"grass","sequenceno":"1"},{"cno":1,"cvalue":"green","sequenceno":"3"},{"cno":2,"cvalue":"is","sequenceno":"2"}]}]';
	
	
	if(celldata !='')
	{ // if celldata not empty or null
		

	/* 	var qtype=$('#qtype').val(); */
		var jsonCellData=jQuery.parseJSON(celldata);
		var editrestrict=$("#editrestrict").val();
		var sequencingType=$("#sequencingType").val();
		let mapImg = new Map();
		
		if($('#itype').val()=='SQ' && sequencingType=='IMAGE'){
			$.each(jsonCellData, function(key,value) {
				$.each(value.column, function(key,value) {
					  mapImg.set(value.cno,value.cvalue);
				});
			});
		}
		
		//this is for edit item
		//var answerdata="grass is green";
		var answerdata=$("#answerdata").val();
		//answerdata="";
		var answeArr=[];
		if(answerdata.length>0)
		{
			/* disable reset button if edit restrict */
			if(editrestrict)
			{
				$("#btnReset").prop("disabled",true);
			}
			else
			{
				$("#btnReset").prop("disabled",false);
			}
			
			if($('#itype').val()=='SQ' && sequencingType=='IMAGE'){
				answeArr=answerdata.split(",");
			}else{
				answeArr=answerdata.split(" ");
			}
			
	    	if(answeArr.length>0)
	    	{
	    		for(var col=0;col<answeArr.length;col++)
	    		{
	    			/* finding column no from celldata */
	    			var colno;
	    			$.each(jsonCellData, function(key,value) 
	    			{
						var rowno=value.rno;
						$.each(value.column, function(key,value) 
						{
							var colVal="";
							if($('#itype').val()=='SQ' && sequencingType=='IMAGE'){
								colVal=value.cno;
								colVal=colVal.toString();
							}else{
								colVal=value.cvalue;
							}
							
							if(answeArr[col]===colVal)
							{
								colno=value.cno;
							}
						});
	    			});
	    			/* prepare the answer matrics*/
	    			var parentDiv;
					if($('#itype').val()=='SQ' && sequencingType=='IMAGE'){
						parentDiv= $(document.createElement('div')).attr("draggable","false").attr("id",'opt'+colno+'').attr("class","noborder custum").attr("column",colno).attr("ondragstart","drag(event)").css("margin","0px 5px 0px 5px").css("height","100px").css("background-size","contain").css("width","100px").css("background-repeat","no-repeat").css("background-image", "url(../exam/displayImage?disImg="+mapImg.get(Number(answeArr[col]))+ ")");
					}else{
						parentDiv= $(document.createElement('div')).attr("draggable","false").attr("id",'opt'+colno+'').attr("class","noborder custum").attr("column",colno).attr("ondragstart","drag(event)");
						parentDiv.append('<span class="numberCircle"><span class="text-center">'+answeArr[col]+'</span></span>');
					}
					
					if(!editrestrict)
					{
						parentDiv.append('<span class="close"><i class="fa fa-remove" onclick="removeOption(this)"></i></span>');
					}
					
					$("#div"+col).append(parentDiv);
					$("#div"+col).addClass('emptyDiv');
	    		}
	    		
	    	}
		}
		
		
		/* prepare the question matrics */
		$("#circleTable").remove();
		var table = $(document.createElement('table')).attr("id",'circleTable').attr("class","borders");
			$.each(jsonCellData, function(key,value) 
			{
				  var newTr = $(document.createElement('tr'));
				  var rowno=value.rno;
				  $.each(value.column, function(key,value) 
					{
						var colmnno=value.cno;
						var newTd = $(document.createElement('td'));

						var mainDiv= $(document.createElement('div')).attr("id",'div'+rowno+''+colmnno+'').attr("class","border").attr("pcolumn",colmnno);
						
						/* checking value is present in answer data */
						var cvalue="";
						if($('#itype').val()=='SQ' && sequencingType=='IMAGE'){
							cvalue=value.cno;
							cvalue=cvalue.toString();
						}else{
							cvalue=value.cvalue;
						}
						
						if($.inArray(cvalue,answeArr)<0)
						{
							if(sequencingType=='IMAGE'){
								var parentDiv;
								parentDiv= $(document.createElement('div')).attr("draggable","true").attr("id",'opt'+rowno+''+colmnno+'').attr("class","noborder custum").attr("column",colmnno).attr("ondragstart","drag(event)").css("margin","0px 5px 0px 5px").css("height","100px").css("background-size","contain").css("background-repeat","no-repeat").css("width","100px").css("background-image", "url(../exam/displayImage?disImg="+value.cvalue+ ")");
								mainDiv.append(parentDiv);
							}else {
								var parentDiv;
								parentDiv= $(document.createElement('div')).attr("draggable","true").attr("id",'opt'+rowno+''+colmnno+'').attr("class","noborder custum").attr("column",colmnno).attr("ondragstart","drag(event)");
				   				parentDiv.append('<span class="numberCircle text-center"><span>'+value.cvalue+'</span></span>');
			   					mainDiv.append(parentDiv);
							}
						}
						else
						{
							mainDiv.addClass('addCircle');
						}
						newTd.append(mainDiv);
						newTr.append(newTd);
					});
					table.append(newTr);
		});
		
		$("#matrixDiv").append(table);
	}
	
});

    function allowDrop(ev) {
    	if($('#AllowAnswerUpdate',window.parent.document).val()=='false' && $('#mode').val()!='off') {
			return false;
		}
        ev.preventDefault();
    }

    function drag(ev) {
    	if($('#AllowAnswerUpdate',window.parent.document).val()=='false' && $('#mode').val()!='off') {
			return false;
		}
        ev.dataTransfer.setData("text", ev.target.id);
    }

    function drop(ev) 
    {
    	if($('#AllowAnswerUpdate',window.parent.document).val()=='false' && $('#mode').val()!='off') {
			return false;
		}
        ev.preventDefault();
        //console.log($(ev.target).attr("id"));
        if (!ev.target.children.length > 0 && $(ev.target).attr("id")) 
        { // if div is empty
            $(ev.target).addClass('emptyDiv');
			//get id of div
            var data = ev.dataTransfer.getData("text");
            ev.target.appendChild(document.getElementById(data));

            // Add close button to dragged element
            $(ev.target).find('div').append('<span class="close"><i class="fa fa-remove" onclick="removeOption(this)"></i></span>');
            $(ev.target).find('div').attr("draggable", "false");
            $(ev.target).find('div').css("cursor", "default");

            // Remove draggable attribute for column
             var col = document.getElementById(data).getAttribute("column");
            var len = $("#matrixDiv").find("div[column='" + col + "']").length;
            $("#matrixDiv").find("#div0"+ col + "").addClass('addCircle');
/*              $("#matrixDiv").find("div[column='" + col + "']").each(function() {
                if (len == 5) {
                    $(this).attr("draggable", "true");
                } else {
                    $(this).attr("draggable", "false");
                    $(this).css("cursor", "not-allowed");
                }
            });   */

        }

    }

    // remove option
    function removeOption(elem) {
    	if($('#AllowAnswerUpdate',window.parent.document).val()=='false' && $('#mode').val()!='off') {
			return false;
		}
        // create copy of option selected for remove
        var optionCopy = $(elem).parent().parent();
        $(optionCopy).parent().removeClass('emptyDiv');

        // set draggable attribute to true
        $(optionCopy).attr("draggable", "true");
        // remove close button span
        $(optionCopy).find('.close').remove();
        // remove div bg-color  
        $(optionCopy).css("background-color", "");
        
        $(optionCopy).css("cursor", "move");

        // set copied element to original column cell
        var columnNo = $(optionCopy).attr("column");
         $("#matrixDiv").find("#div0"+ columnNo + "").removeClass('addCircle');
        $("#matrixDiv").find("div[pcolumn='" + columnNo + "']").each(function() {
            if ($(this).find('div').length == 0) {
                $(this).append(optionCopy);
            }
            // make all cell in that column draggable
            $(this).find('div').attr("draggable", "true");
            $(this).find('div').css("cursor", "move");
        });
        // remove actual option selected for remove
        $(elem).parent().parent().remove();
    }

    // reset all options
    function resetOptions() {
    	if($('#AllowAnswerUpdate',window.parent.document).val()=='false' && $('#mode').val()!='off') {
			return false;
		}
        $('#ans.ansCircle').find('div').each(function() {
            // create copy of option selected for remove
            var optionCopy = $(this);
             $(this).removeClass('emptyDiv');

            // set draggable attribute to true
            $(optionCopy).attr("draggable", "true");
            // remove close button span
            $(optionCopy).find('.close').remove();

            // remove div bg-color  
            $(optionCopy).css("background-color", "");

            // set copied element to original column cell
            var columnNo = $(optionCopy).attr("column");
            $("#matrixDiv").find("#div0"+ columnNo + "").removeClass('addCircle');
            $("#matrixDiv").find("div[pcolumn='" + columnNo + "']").each(function() 
            {
                if ($(this).find('div').length == 0) {
                    $(this).append(optionCopy);
                }
                // make all cell in that column draggable
                $(this).find('div').attr("draggable", "true");
                $(this).find('div').css("cursor", "move");
            });
            // remove actual option selected for remove
            //$(this).children().remove();
        });
    }
