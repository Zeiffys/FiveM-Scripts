var background = $(".background")

function backgroundFadeIn() {
	background.fadeIn(5000, function(){setTimeout(backgroundFadeOut, 10000)});
}

function backgroundFadeOut() {
	background.fadeOut(2500, backgroundChange);
}

function backgroundChange() {
	background.css({"background-image":"url(images/loadingnewsscreenbg/" + (Math.floor(Math.random() * 15) + 3)  + ".jpg)"});
	backgroundFadeIn();
}

background.fadeOut(0, backgroundChange)
