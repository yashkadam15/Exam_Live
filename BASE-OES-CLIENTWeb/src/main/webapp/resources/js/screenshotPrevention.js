window.onload = async function() {
    // Retrieve the screenshotCount from session storage or initialize it to 0
    var screenshotCount = await getSessionStorageItem('screenshotCount');
    console.log("screenshotCount in scrrenshotPrevention: ", screenshotCount);
    if (screenshotCount === null) {
        screenshotCount = 0;
    } else {
        // Convert to a number
        screenshotCount = parseInt(screenshotCount);
    }
    // Your JavaScript code here
    document.addEventListener('keyup', async function(e) {
        screenshotCount = await getSessionStorageItem('screenshotCount');
        // Your keyup event handling code here
        console.log("Key pressed:", e.key);
        // Example: Check if the 'Enter' key is pressed
        if (e.key === 'PrintScreen') {
            // Perform actions when the 'Enter' key is pressed
            alert("Screenshot not allowed!");
            screenshotCount++;
            console.log("Scrrenshot Count: ", screenshotCount);
            // Store the updated screenshotCount in session storage
            await setSessionStorageItem('screenshotCount', screenshotCount);
            console.log("screenshotCount after set: ", screenshotCount);

            if (screenshotCount >= 3) {
                var pi = await getSessionStorageItem('pi');
                var ei = await getSessionStorageItem('ei');
                console.log("PaperId: ", pi);
                console.log("Exam event ID: ", ei);

                // Dispatch a custom event to trigger redirection in the parent page
                var redirectEvent = new CustomEvent('redirectEvent', {
                    detail: {
                        pi: pi,
                        ei: ei
                    }
                });
                window.parent.document.dispatchEvent(redirectEvent);
            }
        }
    });
};

async function getSessionStorageItem(key) {
    return new Promise((resolve, reject) => {
        try {
            const item = sessionStorage.getItem(key);
            resolve(item);
        } catch (error) {
            reject(error);
        }
    });
};

async function setSessionStorageItem(key, value) {
    return new Promise((resolve, reject) => {
        try {
            sessionStorage.setItem(key, value);
            resolve();
        } catch (error) {
            reject(error);
        }
    });
};