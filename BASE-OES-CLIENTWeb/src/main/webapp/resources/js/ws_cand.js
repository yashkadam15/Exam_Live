var stompClient = null;
var uid = null;
var room = null;
var seluid=null;
var wspoint = null;

$(document).ready(function()
{
	uid = $('#uid').val();
	room = $('#room').val();
	wspoint = $('#wspoint').val();
	if($('#isProctored').val() == 'true')
	{
		connectWS();		
	}
});

function connectWS() 
{
    var socket = new SockJS(wspoint + 'pms');
    stompClient = Stomp.over(socket);
	stompClient.debug = null;
    stompClient.connect({ 'userid' : uid, 'roomid' : room }, stompSuccess, stompFailure);
}

function stompSuccess(frame)
{
    stompClient.subscribe('/user/queue/getMessage', processMessage);

	stompClient.send("/app/hello", {}, JSON.stringify({'body': uid }));
}

function stompFailure(error)
{
	//console.log("Lost connection to WebSocket! Reconnecting in 10 seconds...");
    setTimeout(connectWS, 10000);
}

function disconnectWS() 
{
    if (stompClient !== null) 
	{
        stompClient.disconnect();
    }
}

function processMessage(response) 
{
	
	let message = JSON.parse(response.body);

	switch(message.type)
	{
		case "ACTION":
			performActions(message);
		break;
		case "INFO":
		case "WARN":
			showMessage(message);
		break;
	}
}

function performActions(message)
{
	switch(message.actions)
	{
		
	}
}

function showMessage(message)
{
	console.log(message);
	if(message.from == "SYSTEM")
	{
		console.log(message.body);
	}
	else
	{
		$('#proctorMsgModelBodyText')[0].innerHTML = message.body;
     	$("#proctorMsgModel").modal({
				backdrop : 'static',
				keyboard : true
		});
     	$('#proctorMsgModel').modal('show');
     	
		setTimeout(function()
		{ 
			processImage('cswp',0);
	    	processImage('sswp',0);
	  	}, 300);
	}
}

function hideMessage()
{
	setTimeout(function()
	{ 
		$('#proctorMsgModel').modal('hide');
		$('#proctorMsgModelBodyText')[0].innerHTML='';
  	}, 300);
}
