package fubar;

import js.Browser.console;
import js.Browser.document;
import js.Browser.window;
import thx.semver.Version;
import fubar.app.IntroActivity;
import om.Time;
import om.api.Giphy;
import fubar.app.ItemActivity;

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

	public static inline var VERSION = '3.0.0';

	//public static var time(default,null) : Float;
	public static var isMobile(default,null) : Bool;
	public static var config(default,null) : Config;
	public static var service(default,null) : Service;
	//public static var state(default,null) : fubar.State;

	static var animationFrameId : Int;
	//static var time : Float;
	//static var timeStart : Float;
	//static var timePauseStart : Float;
	//static var timeOffset : Float;

	static inline function init( config : Config ) {

		if( config == null ) {
			config = {
				version: VERSION,
				rating: null,
				limit: 100,
				autoplay: 7,
				maxGifSize: (isMobile ? 2 : 3) * 1024 * 1024,
			}
			saveConfig();
		}

		App.config = config;

		//time = 0;
		//timeStart = Time.now();
		//timePauseStart = 0;
		//timeOffset = 0;

		#if android
		isMobile = true;
		#else
		isMobile = om.System.isMobile();
		#end

		service = new Service( fubar.macro.Build.getGiphyAPIKey() );

		var container = document.createDivElement();
		container.id = 'fubar';
		document.body.appendChild( container );

		//new fubar.app.PlayActivity( trending ).boot( container );
		new fubar.app.IntroActivity().boot( container );

		#if !chrome
		window.addEventListener( 'beforeunload', handleBeforeUnload, false );
		#end

		animationFrameId = window.requestAnimationFrame( update );
	}


	static function update( time : Float ) {
		animationFrameId = window.requestAnimationFrame( update );
		//App.time = Time.now() - timeOffset;
		//om.app.Activity.current.update( Time.now() - timeOffset );
		//time = Time.now() - timeStart;
		om.app.Activity.current.update( Time.now() );
	}

	static function end() {
		//cancelAnimationFrame();
	}

	/*
	static function handleVisibilityChange(e) {
        if( document.hidden ) {
			//cancelAnimationFrame();
			//timePauseStart = Time.now();
        } else {
			if( timePauseStart > 0 ) {
				timeStart += Time.now() - timePauseStart;
				//timeOffset += Time.now() - timePauseStart;
				//timeOffset += Time.now() - timePauseStart;
				timePauseStart = 0;
			}
            //animationFrameId = window.requestAnimationFrame( update );
        }
    }
	*/

	static function handleBeforeUnload(e) {
		cancelAnimationFrame();
		saveConfig();
        //saveState();
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

	static function _trace( v : Dynamic, ?info : haxe.PosInfos ) {
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

	static function main() {

		#if debug
		haxe.Log.trace = _trace;
		#end

		window.onload = function() {
			document.body.innerHTML = '';
			loadConfig( init );
		}
	}
}
