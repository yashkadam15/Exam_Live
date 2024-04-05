var startTime;
var elapsedTime = 0;
var previousTime = 0; // Variable to store previous time
var timerInterval;

function startStopwatch() {
	startTime = Date.now() - elapsedTime;
	timerInterval = setInterval(updateStopwatch, 1000);
}

function stopStopwatch() {
	elapsedTime = Math.floor((Date.now() - startTime) / 1000); // Convert milliseconds to seconds
	previousTime = elapsedTime; // Save previous time before stopping
	// sessionStorage.setItem('previousTime', previousTime);
	// Store previousTime value in the hidden input field

	var ceid = sessionStorage.getItem('ceid');

	var userId = sessionStorage.getItem('userId');

	var fkItemID = document.getElementById('fkItemID').value;

	console.log("ceid: ", ceid);
	console.log("userId: ", userId);
	console.log('fkItemID:', fkItemID);

	console.log("Previous Time: ", previousTime);

	clearInterval(timerInterval);
	// Send previousTime1 to the controller using AJAX
	var xhr = new XMLHttpRequest();
	xhr.open('POST', '/OES-CLIENTWeb/exam/TakeTest1', true);
	xhr.setRequestHeader('Content-Type', 'application/json');

	var dataToSend = {
		ceID: ceid,
		userID: userId,
		previousTime: previousTime,
		fkItemId: fkItemID

	};

	// Prepare the data to send
	var jsonData = JSON.stringify(dataToSend);

	// Handle the response from the server
	xhr.onload = function() {
		if (xhr.status >= 200 && xhr.status < 300) {
			// Request was successful
			console.log('Data sent to controller successfully');
		} else {
			// Error handling
			console.error('Failed to send data to controller');
		}
	};

	// Send the request with the data to the controller
	xhr.send(jsonData);
}

function resetStopwatch() {
	stopStopwatch();
	elapsedTime = 0;
	previousTime = 0; // Reset previous time as well
	startStopwatch();

}

function updateStopwatch() {
	var elapsedTimeInSeconds = Math.floor((Date.now() - startTime) / 1000);
	var hours = Math.floor(elapsedTimeInSeconds / 3600);
	var minutes = Math.floor((elapsedTimeInSeconds % 3600) / 60);
	var seconds = elapsedTimeInSeconds % 60;

}

function pad(value) {
	return value < 10 ? '0' + value : value;
}

startStopwatch();