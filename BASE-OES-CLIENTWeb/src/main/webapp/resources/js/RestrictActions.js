$(document).ready(function(){
	$('#viewLang').parent('div.pull-right').hide()
	window.history.forward(-1); 
	document.oncontextmenu = function() {return false;};
});

/*$(document).mousedown(function(event) {
	return false;
});*/

$(document).keydown(function(e)
{
	if(e.target.id!='takepwd' && e.target.name != 'enbedTag' && !$(e.target).hasClass('answerdata') && e.target.id!='notepadText' && !$(e.target).hasClass('ck-editor__editable')  && !$(e.target).hasClass('nfib-typedText')){	
	e.preventDefault();
	}	
});

$(document).mouseup(function(){
	if(document.selection)
	{
	document.selection.empty();
	}		
});