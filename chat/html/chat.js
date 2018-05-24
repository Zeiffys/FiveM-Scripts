function colorize(str)
{
	let s = "<span>" + (str.replace(/\^([0-9])/g, (str, color) => `</span><span class="color-${color}">`)) + "</span>";

	const styleDict = {
		'*': 'font-weight: bold;',
		'_': 'text-decoration: underline;',
		'~': 'text-decoration: line-through;',
		'=': 'text-decoration: underline line-through;',
		'r': 'text-decoration: none;font-weight: normal;',
	};

	const styleRegex = /\^(\_|\*|\=|\~|\/|r)(.*?)(?=$|\^r|<\/span>)/;
	while (s.match(styleRegex)) {
		s = s.replace(styleRegex, (str, style, inner) => `<span style="${styleDict[style]}">${inner}</span>`);
	}

	return s.replace(/<span[^>]*><\/span[^>]*>/g, "");
}

function escape(unsafe) {
	return unsafe
		.replace(/&/g, '&amp;')
		.replace(/</g, '&lt;')
		.replace(/>/g, '&gt;')
		.replace(/"/g, '&quot;')
		.replace(/'/g, '&#039;');
}

$(function()
{
	var chatHideTimeout;
	var inputShown = false;

	function startHideChat()
	{
		if (chatHideTimeout)
		{
			clearTimeout(chatHideTimeout);
		}

		if (inputShown)
		{
			return;
		}

		chatHideTimeout = setTimeout(function()
		{
			if (inputShown)
			{
				return;
			}

			$("#chat").animate({ opacity: 0 }, 2500);
			$("#chatBackground").animate({ opacity: 0 }, 2500);
		}, 5000);
	}

	handleResult = function(elem, wasEnter)
	{
		inputShown = false;

		//$("#chatInputHas").hide();
		$("#chatInputHas").animate({ opacity: 0 }, 100);
		

		startHideChat();

		var obj = {};

		if (wasEnter)
		{
			obj = { message: $(elem).val() };
		}

		$(elem).val("");

		$.post("http://chat/chatResult", JSON.stringify(obj), function(data)
		{
			//console.log(data);
		});
	};

	$("#chatInput").fakeTextbox();

	$("#chatInput")[0].onPress(function(e)
	{
		if (e.which == 13)
		{
			handleResult(this, true);
		}
	});

	$(document).keyup(function(e)
	{
		if (e.keyCode == 27)
		{
			handleResult($("#chatInput")[0].getTextBox(), false);
		}
	});

	$(document).keydown(function(e)
	{
		var scrollSize = 57 // 3 messages // 1 msg = 19px with 16px text size
		if (e.keyCode == 9)
		{
			e.preventDefault();
			return false;
		}
		else if (e.keyCode == 33)
		{
			let buf = $("#chatBuffer");
			//buf.scrollTop(buf.scrollTop() - scrollSize);
			buf.animate({scrollTop:buf.scrollTop()-scrollSize}, 100);
		}
		else if (e.keyCode == 34)
		{
			let buf = $("#chatBuffer");
			//buf.scrollTop(buf.scrollTop() + scrollSize);
			buf.animate({scrollTop:buf.scrollTop()+scrollSize}, 100);
		}
	});

	window.addEventListener("message", function(event)
	{
		var item = event.data;

		if (item.meta && item.meta == "openChatBox")
		{
			inputShown = true;

			$("#chatBackground").stop();
			$("#chatBackground").animate({ opacity: 1 }, 500);

			$("#chat").stop();
			$("#chat").animate({ opacity: 1 }, 500);

			$("#chatInputHas").show();
			$("#chatInputHas").animate({ opacity: 1 }, 100);
			$("#chatInput")[0].doFocus();

			return;
		}

		var name = colorize(escape(item.name));
		var message = colorize(escape(item.message));

		var buf = $("#chatBuffer");

		var nameStr = "";

		if (name != "")
		{
			nameStr = name + ": ";
		}

		buf.find("ul").append("<li>" + nameStr + message + "</li>");
		//buf.scrollTop(buf[0].scrollHeight - buf.height());
		buf.animate({scrollTop:buf[0].scrollHeight - buf.height()}, 100);
		

		$("#chatBackground").stop();
		$("#chatBackground").animate({ opacity: 1 }, 500);

		$("#chat").stop();
		$("#chat").animate({ opacity: 1 }, 500);

		startHideChat();
	}, false);
});
