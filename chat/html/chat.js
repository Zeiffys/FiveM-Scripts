var chatBoxHideTime;
var chatBoxInput = false;
var shouldBeHidden = false;
var hasNewMessages = false;
var isScrolling = false;
const twemojiset = {folder:"svg", ext:".svg"};

var inputHistory = {
	messages:[],
	max: 20,
	add: function(s) {
		if (!inputHistory.messages.includes(s)) {
			inputHistory.messages.unshift(s);
			if (inputHistory.messages.length > inputHistory.max) {
				inputHistory.messages.pop();
			}
			inputHistory.count = inputHistory.messages.length - 1;
		} else {
			var i = inputHistory.messages.indexOf(s);
			inputHistory.messages.splice(i, 1)
			inputHistory.messages.unshift(s);
			if (inputHistory.messages.length > inputHistory.max) {
				inputHistory.messages.pop();
			}
			inputHistory.count = inputHistory.messages.length - 1;
		}
	},
	get: function() {
		return inputHistory.messages[inputHistory.current] || "";
	},
	count: 0,
	current: -1
};

function formatMessage(message) {
	const styleRegex = /\^(\_|\*|\=|\~|\/|r)(.*?)(?=$|\^r|<\/span>)/;
	const styleDict = {
		'/': 'font-style: italic;',
		'*': 'font-weight: bold;',
		'_': 'text-decoration: underline;',
		'~': 'text-decoration: line-through;',
		'=': 'text-decoration: underline line-through;',
		'r': 'text-decoration: none; font-weight: normal;',
	};

	message = message
		.replace(/&/g, "&amp;")
		.replace(/</g, "&lt;")
		.replace(/>/g, "&gt;")
		.replace(/"/g, "&quot;")
		.replace(/'/g, "&#039;");

	// it seems awful and stupid
	message = message
		.replace(/\^([1-9bgypqocmwsu])/gi, "</span><span class=\"color-$1\">")
		.replace(/\^#([0-9A-F][0-9A-F])([0-9A-F][0-9A-F])([0-9A-F][0-9A-F])/gi, "</span><span style=\"color: #$1$2$3;\">")
		.replace(/\^#([0-9A-F])([0-9A-F])([0-9A-F])/gi, "</span><span style=\"color: #$1$2$3;\">")
		.replace(/\^0/g, "</span>");

	while (message.match(styleRegex)) {
		message = message.replace(styleRegex, (str, style, inner) => `<span style="${styleDict[style]}">${inner}</span>`);
	}

	return message.replace(/<span[^>]*><\/span[^>]*>/gi, "");
}


function showChatBox()
{
	if (!shouldBeHidden)
	{
		$("#chatBox").stop();
		$("#chatBoxBg").stop();

		$("#chatBox").animate({opacity: 1}, 500);
		$("#chatBoxBg").animate({opacity: 1}, 500);
	}
}

function hideChatBox(time)
{
	if (!time) time = 5000
	if (chatBoxHideTime) clearTimeout(chatBoxHideTime);
	chatBoxHideTime = setTimeout(function()
	{
		if (chatBoxInput) return;
		$("#chatBox").animate({opacity: 0}, 2500);
		$("#chatBoxBg").animate({opacity: 0}, 2500);
	}, time);
}

function showChatBoxInput()
{
	if (!shouldBeHidden)
	{
		chatBoxInput = true;
		$("#chatInputText").val("")
		$("#chatInput").stop();
		$("#chatInput").animate({opacity: 1}, 100);
		$("#chatInputText").focus();
		inputHistory.current = -1;
	}
}

function hideChatBoxInput()
{
	chatBoxInput = false;
	$("#chatInput").stop();
	$("#chatInput").animate({opacity: 0}, 100);
	$("#chatInputText").blur();
	setTimeout(function()
	{
		$("#chatInputText").val("")
	}, 150)
}

function outputChatBox(name, message)
{
	var chat = $("#chatBoxBuffer");
	var message = twemoji.parse(formatMessage(message), twemojiset);

	var nameStr = "";
	if (name != "") nameStr = "<font class=\"chatBoxName\">" + formatMessage(name) + "</font>: ";

	chat.find("ul").append("<li>" + nameStr + message + "</li>");

	chat.stop();
	chat.animate({scrollTop:chat[0].scrollHeight - chat.height()}, 150);
}

function SendResult(message)
{
	var content = {hasMessage: false}
	if (message)
	{
		content = {hasMessage: true, message: message}
	}
	$.post("http://chat/chatResult", JSON.stringify(content));
	hideChatBox()
	hideChatBoxInput()
}

function scrollChatBox(pos)
{
	if (!isScrolling) {
		isScrolling = true;

		var size = 24 * 2
		var chat = $("#chatBoxBuffer");

		if (pos == "up") {
			size = chat.scrollTop() - size
		} else if (pos == "down") {
			size = chat.scrollTop() + size
		}

		chat.stop();
		chat.animate({scrollTop: size}, 150, function(){isScrolling = false;});
	}
}

function onKeyUp(event)
{
	var key = event.keyCode;
	if (key == 13) {
		var result = $("#chatInputText").val();
		SendResult(result);
		if (result.length > 0) inputHistory.add(result);
	} else if (key == 27) {
		SendResult();
	}
}

function onKeyDown(event)
{

	var key = event.keyCode;
	if (key == 9 || key == 13) {
		cancelJsEvent(event);
		return false;
	} else if (key == 33) {
		scrollChatBox("up");
	} else if (key == 34) {
		scrollChatBox("down");
	} else if (key == 38) {
		cancelJsEvent(event);
		if (inputHistory.current < inputHistory.count) {
			inputHistory.current++
			$("#chatInputText").val(inputHistory.get());
		}
	} else if (key == 40) {
		cancelJsEvent(event);
		if (inputHistory.current > -1) {
			--inputHistory.current
			$("#chatInputText").val(inputHistory.get());
		}
	}
}

function cancelJsEvent(event)
{
	event.preventDefault();
	event.stopPropagation();
}

document.querySelector("body").onkeyup = function(e) {if (e.keyCode) onKeyUp(e);};
document.querySelector("body").onkeydown = function(e) {if (e.keyCode) onKeyDown(e);};
document.querySelector("body").onmouseup = function(e) {cancelJsEvent(e);};
document.querySelector("body").onmousedown = function(e) {cancelJsEvent(e);};

window.addEventListener("message", function(event) {
	var item = event.data;
	var meta = item.meta;

	if (meta)
	{
		if (meta == "openChatBox") {
			showChatBox();
			showChatBoxInput();
		} else if (meta == "closeChatBox") {
			hideChatBox();
			hideChatBoxInput();
		} else if (meta == "outputChatBox") {
			showChatBox();
			hideChatBox();
			outputChatBox(item.name, item.message);
			if (shouldBeHidden) hasNewMessages = true;
		} else if (meta == "shouldBeHidden") {
			$("#chatBox").css("opacity", 0);
			$("#chatBoxBg").css("opacity", 0);
			$("#chatInput").css("opacity", 0);
			$("#chatInputText").blur();
			$("#chatInputText").val("")
			if (chatBoxInput) SendResult();
			chatBoxInput = false;
			shouldBeHidden = true;
		} else if (meta == "shouldNotBeHidden") {
			shouldBeHidden = false;
			if (hasNewMessages) {
				showChatBox();
				hideChatBox();
				hasNewMessages = false;
			}
		}
	}
}, false);
