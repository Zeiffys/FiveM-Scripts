/*
	This code contains part of the code from "Synn's loadingscreen"
	https://github.com/Syntasu/synn-loadscreen
*/

var types = [/*"INIT_CORE",*/ "INIT_BEFORE_MAP_LOADED", "INIT_MAP", "INIT_AFTER_MAP_LOADED", "INIT_SESSION"];
var stateCount = 4;
var states = {};
var statetext = "Loading FiveM"

function UpdateStateText(s) {
}

function GetPrecentageLikeGta() {
	var p = Math.floor(GetTotalProgress()/10)*10;
	return ((p > 100) && 100 || p);
}

function SetPercentage() {
	var precent = GetPrecentageLikeGta() + "%";
	document.querySelector("#loading-text").innerHTML = statetext + " (" + precent + ")";
	//document.querySelector(".loading-bar").style.width = precent;
}

function SetLogLine(text) {
	document.querySelector(".newsblock-onlinetip").innerHTML = text || "";
	//console.log(text)
}

function GetTypeProgress(type) {
	if(states[type] != null) {
		var doneCount = states[type].done;
		var totalCount = states[type].count;

		if(doneCount <= 0 || isNaN(doneCount) || totalCount <= 0 || isNaN(totalCount)) {
			return 0;
		}

		var progress = states[type].done / states[type].count;
		return Math.round(progress * 100);
	}

	return 0;
}

function GetTotalProgress() {
	var totalProgress = 0;
	var totalStates = 0;
	
	for(var i = 0; i < types.length; i++) {
		var key = types[i];
		totalProgress += GetTypeProgress(key);
		totalStates++;
	}

	if(totalProgress <= 0 || isNaN(totalProgress) || totalStates <= 0 || isNaN(totalStates) ) {
		return 0;
	}

	return Math.round(totalProgress / totalStates);
}

const handlers = {
	startInitFunction(data) {
		SetLogLine(`Running ${data.type} init functions`);

		if(states[data.type] == null) {
			states[data.type] = {};
			states[data.type].count = 0;
			states[data.type].done = 0;   

			if(data.type == types[0]) {
				stateCount++;
			}
		}
	},

	startInitFunctionOrder(data) {
		if(states[data.type] != null) {
			states[data.type].count += data.count;
		}
		SetPercentage()
		SetLogLine(`Running ${data.type} functions of order ${data.order} (${data.count} total)`)
	},

	initFunctionInvoking(data) {
		SetPercentage()
		SetLogLine(`Invoking ${data.name} ${data.type} init (${states[data.type].done} of ${states[data.type].count})`)
	},

	initFunctionInvoked(data) {
		if(states[data.type] != null) {
			states[data.type].done++;
		}
		SetPercentage()
		SetLogLine(`Invoked ${data.name} ${data.type} init (${states[data.type].done} of ${states[data.type].count})`)
	},

	endInitFunction(data) {
		SetPercentage()
		SetLogLine(`Done running ${data.type} init functions`)
	},

	startDataFileEntries(data) {
		SetLogLine(`Start data loading`)
		states["INIT_MAP"] = {};
		states["INIT_MAP"].count = data.count;
		states["INIT_MAP"].done = 0;
	},

	onDataFileEntry(data) {
		SetPercentage()
		SetLogLine(`Loading ${data.name}`)
	},

	endDataFileEntries() {
		SetPercentage()
		SetLogLine(`Done data loading`)
	},

	performMapLoadFunction(data) {
		SetPercentage()
		states["INIT_MAP"].done++;
	},

	onLogLine(data) {
		statetext = data.message;
		SetPercentage()
		//SetLogLine(data.message)
	}
};

window.addEventListener("message", function(e){(handlers[e.data.eventName] || function() {})(e.data);});
