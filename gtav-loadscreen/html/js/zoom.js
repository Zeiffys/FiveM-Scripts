function setZoomLevel() {
	const zoomLevel = Math.max(
		window.innerWidth / 1280,
		window.innerHeight / 720
	);
	document.querySelector("body").style.setProperty("zoom", zoomLevel);
}

setZoomLevel();
window.addEventListener("resize", setZoomLevel);
