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
//class App implements om.App {
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

		//service = new Service( fubar.macro.Build.getGiphyAPIKey() );
		service = new Service( "dc6zaTOxFJmzC" );

		new fubar.app.IntroActivity().boot( element );
		//new fubar.app.PlayActivity( trending ).boot( element );
		//new fubar.app.AboutActivity().boot( element );

		#if !chrome
		//window.addEventListener( 'beforeunload', handleBeforeUnload, false );
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

		window.onload = function() {

			#if debug
			haxe.Log.trace = _trace;
			#end

		//	trace( '$NAME-$PLAFORM-$VERSION', 'info' );

			document.body.innerHTML = '';

			isMobile =
				#if android true;
				#else om.System.isMobile();
				#end

			var defaultConfig = {
				version: '',//TODO temp! VERSION,
				rating: null,
				limit: 300,
				autoplay: 7,
				maxGifSize: (isMobile ? 2 : 3) * 1024*1024,
			}

			var element = document.createDivElement();
		//	element.id = App.NAME;
			document.body.appendChild( element );

			loadConfig( function(config) {

				if( config == null )
					trace( 'FUbar first run '+VERSION, 'info' );
				else if( config.version < VERSION )
					trace( 'FUbar version update from '+config.version+' to '+VERSION, 'info' );

				if( config == null || config.version < VERSION ) {
					config = defaultConfig;
					saveConfig();
				}

				init( element, config );
			});
		}
	}
}
