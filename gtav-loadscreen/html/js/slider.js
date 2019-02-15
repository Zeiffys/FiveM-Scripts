var news = [
	{ // All fields can be empty.
		"title":"FXServer",
		"subtitle":"Welcome!",
		"row1":"FiveM allows servers to use custom cars, maps, weapons, and more.",
		"row2":"FiveM allows servers to keep the original game AI, so you'll never be alone. You can also PvE!",
		"row3":"FiveM uses the GTA:O network code with improvements, so you'll have the best sync around.",
		"banner":"",
		"bannerSize":"" // auto, contain, cover, 0-100%
	},
	{
		"title":"GTA Online",
		"subtitle":"Yes, this shit is still alive!",
		"row1":"Double payouts in GTA $ and RP for the \"Battle on the shit\" series continue until April 14 2035.",
		"row2":"In addition, during the same time you will receive twice the inconvenience from the cheaters that we can not ban.",
		"row3":"If you are going to play it with friends, prepare anal lubricant...",
		"banner":"https://media.rockstargames.com/rockstargames-newsite/uploads/36173bb36b7cc02ff5a0e002243a6f75694f8d5b.jpg",
		"bannerSize":"cover"
	},
	{
		"title":"FiveM",
		"subtitle":"The GTA V multiplayer modification you have dreamt of",
		"row1":"FiveM is a modification for Grand Theft Auto V enabling you to play multiplayer on customized dedicated servers.",
		"row2":"Building upon years of development on the CitizenFX framework, which has existed in various forms since 2014, FiveM is the original community-driven GTA V multiplayer modification project. We strive to put the community ― both players, server owners, and the greater GTA mod community ― first.",
		"row3":"FiveM is a multiplayer modification framework providing many tools to personalize your server's gameplay experience. Using our advanced features, you can make whatever you wish: roleplay, drifting, racing, deathmatch, or something entirely unique? Your skills are the limit!",
		"banner":"images/fivem.svg",
		"bannerSize":"75%"
	}
];

var newsToggle = true
var newsDuration = 20000

var newsCurrent = 0
var newsCount = news.length - 1
function newsChange() {
	if(newsToggle) {
		newsCurrent++;
		if(newsCurrent > newsCount) newsCurrent = 0;
		$(".newsblock-title").text(news[newsCurrent].title)
		$(".newsblock-subtitle").text(news[newsCurrent].subtitle)
		$("#newsblock-row1").text(news[newsCurrent].row1)
		$("#newsblock-row2").text(news[newsCurrent].row2)
		$("#newsblock-row3").text(news[newsCurrent].row3)
		if(news[newsCurrent].banner) {
			$(".newsblock-banner").css("background-image", "url(" + news[newsCurrent].banner + ")");
			if(news[newsCurrent].bannerSize) {
				$(".newsblock-banner").css("background-size", news[newsCurrent].bannerSize);
			}
		} else {
			$(".newsblock-banner").css("background-image", "");
			$(".newsblock-banner").css("background-size", "");
		}
		setTimeout(newsChange, newsDuration)
	} else {
		$(".newsblock").css("display", "none");
	};
};

newsChange()

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
