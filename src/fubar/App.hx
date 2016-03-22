package fubar;

import js.Browser.document;
import js.Browser.window;
import om.app.Activity;

/*
//TODO autobuild
typedef State = {
	var mode : String;
	var search : String;
	var time : Float;
}
*/

//class App implements samba.App {
class App {

	public static var config(default,null) : fubar.Config;
	public static var service(default,null) : fubar.Service;
	//public static var state(default,null) : fubar.State;

	static function init() {

		config = {
			rating: null,
			limit: 100
		};

		service = new fubar.Service( fubar.macro.Build.getGiphyAPIKey() );

		new fubar.app.IntroActivity().boot();
		//new fubar.app.AboutActivity().boot();
	}

	static function main() {
		window.onload = function(){
			document.body.innerHTML = '';
			init();
		}
	}
}
