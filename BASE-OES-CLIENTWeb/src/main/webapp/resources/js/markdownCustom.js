window.addEventListener('load', (event) => {
    var x = document.getElementsByClassName("markdown");
	
	for (var i=0; i<x.length ; i++)
	{		
		var parentDiv = document.createElement("div");
		parentDiv.id = "markdown_div" + i;
		parentDiv.classList.add("parentMarkDown");
		var markDownCtrlDiv = document.createElement("div");
		markDownCtrlDiv.classList.add("markdownCtrl");
		
		var boldButton = document.createElement("button");
		boldButton.type = "button";
		
		var icon = document.createElement("i");
		icon.classList.add("fa");
		icon.classList.add("fa-bold");
		icon.myTextArea = x[i];
		boldButton.appendChild(icon);
		
		boldButton.myTextArea = x[i];
		boldButton.addEventListener('click', (e) => {			
			var start = e.target.myTextArea.selectionStart;			
			var finish = e.target.myTextArea.selectionEnd;
			var sel = e.target.myTextArea.value.substring(start, finish);			
			e.target.myTextArea.value = e.target.myTextArea.value.substring(0,start) + "**" + sel + "**" + e.target.myTextArea.value.substring(finish,e.target.myTextArea.value.length);	
			if(start==finish && sel=='')
			{
				e.target.myTextArea.selectionEnd=start + 2;
				e.target.myTextArea.focus();
			}
			renderMarkdown(e.target.myTextArea);
		});
		markDownCtrlDiv.appendChild(boldButton);
		
		var ItalicButton = document.createElement("button");
		ItalicButton.type = "button";
		
		
		var icon = document.createElement("i");
		icon.classList.add("fa");
		icon.classList.add("fa-italic");
		icon.myTextArea = x[i];
		ItalicButton.appendChild(icon);
		ItalicButton.myTextArea = x[i];
		
		ItalicButton.addEventListener('click', (e) => {
			var start = e.target.myTextArea.selectionStart;			
			var finish = e.target.myTextArea.selectionEnd;
			var sel = e.target.myTextArea.value.substring(start, finish);			
			e.target.myTextArea.value = e.target.myTextArea.value.substring(0,start) + "*" + sel + "*" + e.target.myTextArea.value.substring(finish,e.target.myTextArea.value.length);	
			if(start==finish && sel=='')
			{
				e.target.myTextArea.selectionEnd=start + 1;
				e.target.myTextArea.focus();
			}
			renderMarkdown(e.target.myTextArea);
		});
		markDownCtrlDiv.appendChild(ItalicButton);
		
		var underLineButton = document.createElement("button");
		underLineButton.type = "button";
		
		var icon = document.createElement("i");
		icon.classList.add("fa");
		icon.classList.add("fa-underline");
		icon.myTextArea = x[i];
		underLineButton.appendChild(icon);
		underLineButton.myTextArea = x[i];
		
		underLineButton.addEventListener('click', (e) => {
			var start = e.target.myTextArea.selectionStart;			
			var finish = e.target.myTextArea.selectionEnd;
			var sel = e.target.myTextArea.value.substring(start, finish);			
			e.target.myTextArea.value = e.target.myTextArea.value.substring(0,start) + "++" + sel + "++" + e.target.myTextArea.value.substring(finish,e.target.myTextArea.value.length);	
			if(start==finish && sel=='')
			{
				e.target.myTextArea.selectionEnd=start + 2;
				e.target.myTextArea.focus();
			}
			renderMarkdown(e.target.myTextArea);
		});
		markDownCtrlDiv.appendChild(underLineButton);
		
		
		var strikeThruButton = document.createElement("button");
		strikeThruButton.type = "button";
		
		var icon = document.createElement("i");
		icon.classList.add("fa");
		icon.classList.add("fa-strikethrough");
		icon.myTextArea = x[i];
		strikeThruButton.appendChild(icon);
		strikeThruButton.myTextArea = x[i];
		
		strikeThruButton.addEventListener('click', (e) => {
			var start = e.target.myTextArea.selectionStart;			
			var finish = e.target.myTextArea.selectionEnd;
			var sel = e.target.myTextArea.value.substring(start, finish);			
			e.target.myTextArea.value = e.target.myTextArea.value.substring(0,start) + "~~" + sel + "~~" + e.target.myTextArea.value.substring(finish,e.target.myTextArea.value.length);	
			if(start==finish && sel=='')
			{
				e.target.myTextArea.selectionEnd=start + 2;
				e.target.myTextArea.focus();
			}
			renderMarkdown(e.target.myTextArea);
		});
		markDownCtrlDiv.appendChild(strikeThruButton);
		
		var subScriptButton = document.createElement("button");
		subScriptButton.type = "button";

		var icon = document.createElement("i");
		icon.classList.add("fa");
		icon.classList.add("fa-subscript");
		icon.myTextArea = x[i];
		subScriptButton.appendChild(icon);
		subScriptButton.myTextArea = x[i];
		
		subScriptButton.addEventListener('click', (e) => {
			var start = e.target.myTextArea.selectionStart;			
			var finish = e.target.myTextArea.selectionEnd;
			var sel = e.target.myTextArea.value.substring(start, finish);			
			e.target.myTextArea.value = e.target.myTextArea.value.substring(0,start) + "~" + sel + "~" + e.target.myTextArea.value.substring(finish,e.target.myTextArea.value.length);	
			if(start==finish && sel=='')
			{
				e.target.myTextArea.selectionEnd=start + 1;
				e.target.myTextArea.focus();
			}
			renderMarkdown(e.target.myTextArea);
		});
		markDownCtrlDiv.appendChild(subScriptButton);
		
		var supScriptButton = document.createElement("button");
		supScriptButton.type = "button";
		
		var icon = document.createElement("i");
		icon.classList.add("fa");
		icon.classList.add("fa-superscript");
		icon.myTextArea = x[i];
		supScriptButton.appendChild(icon);
		supScriptButton.myTextArea = x[i];

		supScriptButton.addEventListener('click', (e) => {
			var start = e.target.myTextArea.selectionStart;			
			var finish = e.target.myTextArea.selectionEnd;
			var sel = e.target.myTextArea.value.substring(start, finish);			
			e.target.myTextArea.value = e.target.myTextArea.value.substring(0,start) + "^" + sel + "^" + e.target.myTextArea.value.substring(finish,e.target.myTextArea.value.length);	
			if(start==finish && sel=='')
			{
				e.target.myTextArea.selectionEnd=start + 1;
				e.target.myTextArea.focus();
			}
			renderMarkdown(e.target.myTextArea, document.getElementById('markdown_output'+i));
		});
		markDownCtrlDiv.appendChild(supScriptButton);
		
		parentDiv.appendChild(markDownCtrlDiv);
		x[i].parentNode.insertBefore(parentDiv, x[i]);
		parentDiv.appendChild(x[i]);	
		var outputDiv = document.createElement("div");
		outputDiv.id= "markdown_output" + i;
		parentDiv.appendChild(outputDiv);
		renderMarkdown(x[i]);
	}
});

var md = window.markdownit();
md.use(window.markdownitSub);
md.use(window.markdownitSup);
md.use(window.markdownitIns);

function renderMarkdown(Tarea)
{
	Tarea.nextSibling.innerHTML = md.render(Tarea.value);	
}

/*$(function(){
	$('label').each(function() {
		$(this).html(md.render($(this).html()));
	});
});*/