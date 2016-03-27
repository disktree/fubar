package fubar.gui.player;

@:enum abstract ScaleMode(String) from String to String {

	/** No scale */
    var original = "original";

	/** Stretch image to window */
	var fit = "fit";

	/** Scale image to window, parts of the image might be invisible */
	var full_width = "full-width";
	var full_height = "full-height";

	/** Scale to window, show bars if needed */
	var letterbox = "letterbox";
}
