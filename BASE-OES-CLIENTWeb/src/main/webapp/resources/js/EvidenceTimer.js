var sdateTime;
var sMonthName;
var sTodayDate;
var sYear;
var sTime;
var sHr;
var sMin;
var sSec;
var sCurrentDT;
var sTimeZone;
var isAM;
var sdt="";
var monthNames = {"Jan": "01","Feb": "02", "Mar": "03", "Apr": "04", "May": "05", "Jun": "06", "Jul": "07", "Aug": "08", "Sep": "09", "Oct": "10", "Nov": "11", "Dec": "12"};

$(document).ready(function(){
	sdateTime = $('#serverDateTime').val().split(" ");
	if(sdateTime != null && sdateTime.length==6){
		sMonthName = monthNames[sdateTime[1]];
		sTodayDate = parseInt(sdateTime[2]);
		sTimeZone = sdateTime[4];
		sYear = parseInt(sdateTime[5]);
		sTime = sdateTime[3].split(":");
		sHr = parseInt(sTime[0]);
		sMin = parseInt(sTime[1]);
		sSec = parseInt(sTime[2]);
		sCurrentDT = new Date(sYear, Object.keys(monthNames).indexOf(sdateTime[1]), sTodayDate, sHr, sMin, sSec);
		isAM = sHr < 12;
		setTimeout(updateClock, 1);
		setInterval(updateClock, 1000);
	}
});

function formatTime(hours, minutes, seconds) {
	var period = isAM ? "am" : "pm";
	var formattedHours = hours % 12 || 12;
	return `${(formattedHours < 10 ? "0" : "")}${formattedHours}:${(minutes < 10 ? "0" : "")}${minutes}:${(seconds < 10 ? "0" : "")}${seconds} ${period}`;
}
	
function updateClock() {
	sCurrentDT.setSeconds(sCurrentDT.getSeconds() + 1);
	sYear = sCurrentDT.getFullYear();
	sMonthName = monthNames[Object.keys(monthNames)[sCurrentDT.getMonth()]];
	sTodayDate = sCurrentDT.getDate();
	sHr = sCurrentDT.getHours();
	sMin = sCurrentDT.getMinutes();
	sSec = sCurrentDT.getSeconds();
	isAM = sHr < 12;
	var sec1 = sSec < 10 ? "0" + sSec : sSec;
	var min1 = sMin < 10 ? "0" + sMin : sMin;
	
	//Print Formate : '14/08/2023  06:26:58 pm'
	sdt=`${sTodayDate}/${sMonthName}/${sYear} ${formatTime(sHr, sMin, sSec)}`;
	$("#sct").text(`${sdt} ${sTimeZone}`);
}