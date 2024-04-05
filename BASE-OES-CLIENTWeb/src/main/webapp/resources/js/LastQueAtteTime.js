var previousQuestionTime = new Date();

// Function to calculate the time difference between two questions
function calculateTimeDifference() {
	console.log("Inside calculateDifference")
    // Get the current time
    var currentTime = new Date();
    // Calculate the difference in milliseconds
    var timeDifference = currentTime - previousQuestionTime;
    // Convert the difference to seconds
    var secondsDifference = Math.floor(timeDifference / 1000);
    // Update the previous question time for the next calculation
    previousQuestionTime = currentTime;
    // Return the time difference in seconds
    return secondsDifference;
}

function updateTimeDifferenceDisplay() {
	console.log("Inside updateTimeDifferenceDisplay ")
    var timeBetweenQuestions = calculateTimeDifference();
    var displayElement = document.getElementById('timeDifferenceDisplay');
    console.log("time difference", timeBetweenQuestions);
    
    // Creating a form dynamically
    var form = document.createElement('form');
    form.method = 'post'; // or 'get'
    form.action = 'destinationPage.jsp'; // replace 'destinationPage.jsp' with your destination JSP page
    
    // Creating a hidden input field
    var hiddenInput = document.createElement('input');
    hiddenInput.type = 'hidden';
    hiddenInput.name = 'timeBetweenQuestions'; // name of the variable you want to send
    hiddenInput.value = timeBetweenQuestions; // value of the variable
    
    // Appending the hidden input field to the form
    form.appendChild(hiddenInput);
    
    // Appending the form to the document body
    document.body.appendChild(form);
    
    // Submitting the form
    form.submit();
}