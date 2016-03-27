package fubar;

import js.Browser.console;
import js.Browser.document;
import js.Browser.window;
import js.html.Element;
import js.html.DivElement;
import thx.semver.Version;
import fubar.app.IntroActivity;
import om.Time;
import om.api.Giphy;

typedef Config = {
	var version : String;
	var limit : Int;
	var rating : Rating;
	var autoplay : Int;
	var maxGifSize : Int;
}

/*
typedef State = {
	var mode : PlayMode;
	var search : String;
	var autoplay : Bool;
}
*/

@:build(fubar.macro.BuildApp.build())
class App {

	public static var isMobile(default,null) : Bool;
	public static var element(default,null) : Element;
	public static var service(default,null) : Service;
	public static var config(default,null) : Config;
	//public static var state(default,null) : fubar.State;

	static var animationFrameId : Int;

	static inline function init( element : Element, config : Config ) {

		App.element = element;
		App.config = config;

		trace( config, 'debug' );

		service = new Service( fubar.macro.Build.getGiphyAPIKey() );

		//new fubar.app.PlayActivity( trending ).boot( container );
		new fubar.app.IntroActivity().boot( element );
		//new fubar.app.AboutActivity().boot( element );

		#if !chrome
		window.addEventListener( 'beforeunload', handleBeforeUnload, false );
		#end

		animationFrameId = window.requestAnimationFrame( update );
	}

	static function update( time : Float ) {
		animationFrameId = window.requestAnimationFrame( update );
		om.app.Activity.current.update( Time.now() );
	}

	static function end() {
		cancelAnimationFrame();
	}

	static function handleBeforeUnload(e) {
		cancelAnimationFrame();
		saveConfig();
    }

	static function cancelAnimationFrame() {
		if( animationFrameId != null ) {
			window.cancelAnimationFrame( animationFrameId );
			animationFrameId = null;
		}
	}

	static inline function loadConfig( callback : Config->Void ) Storage.get( 'config', callback );
	static inline function saveConfig() Storage.set( 'config', App.config );

	//static inline function loadState( callback : State->Void ) Storage.get( 'state', callback );
	//static inline function saveState() Storage.set( 'state', App.state );

	static function main() {

		#if debug
		haxe.Log.trace = _trace;
		#end

		trace( '$NAME-$PLAFORM-$VERSION', 'info' );

		isMobile =
			#if android true;
			#else om.System.isMobile();
			#end

		window.onload = function() {

			document.body.innerHTML = '';

			var element = document.createDivElement();
			element.id = App.NAME;
			document.body.appendChild( element );

			loadConfig( function(config) {
				if( config == null || config.version < VERSION ) {
					trace( 'First start of new fubar version: '+VERSION );
					Storage.clear();
					config = {
						version: VERSION,
						rating: null,
						limit: 300,
						autoplay: 7,
						maxGifSize: (isMobile ? 2 : 3) * 1024 * 1024,
					}
					saveConfig();
				}
				init( element, config );
			});
		}
	}

	static function _trace( v : Dynamic, ?info : haxe.PosInfos ) {

		console.log("FUbar");
		console.debug("FUbar");
		console.info("FUbar");
		console.warn("FUbar");
		console.error("FUbar");

		#if debug
		var str = info.fileName+':'+info.lineNumber+': '+v;
		if( info.customParams != null && info.customParams.length > 0 ) {
			switch info.customParams[0] {
				case 'log': console.log( str );
				case 'debug': console.debug( str );
				case 'warn': console.warn( str );
				case 'info': console.info( str );
				case 'error': console.error( str );
				default: console.log( str );
			}
		} else {
			console.log( str );
		}
		#end
	}
}
