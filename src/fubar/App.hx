package fubar;

import js.Browser.document;
import js.Browser.window;
import thx.semver.Version;
import fubar.app.IntroActivity;
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

class App {

	public static inline var VERSION = '3.0.0';

	public static var config(default,null) : Config;
	public static var service(default,null) : Service;
	//public static var state(default,null) : fubar.State;

	static inline function init() {

		service = new Service( fubar.macro.Build.getGiphyAPIKey() );

		var container = document.createDivElement();
		container.id = 'fubar';
		document.body.appendChild( container );

		loadConfig( function(c){

			if( c != null && c.version == VERSION ) config = c else {
				config = {
					version: VERSION,
					rating: null,
					limit: 100,
					autoplay: 7,
					maxGifSize: 4*1024*1024,
				}
				saveConfig();
			}

			new fubar.app.PlayActivity( trending ).boot( container );

			/*
			loadState( function(s){

				if( s == null ) {

					s = {
						mode: PlayMode.trending,
						search: null,
						autoplay: true
					};
					} else {
						if( s.search == null || s.search.length == 0 )
						s.mode = trending;
					}

					state = s;
					saveState();

					service = new Service( fubar.macro.Build.getGiphyAPIKey() );

					var container = document.createDivElement();
					container.id = 'fubar';
					document.body.appendChild( container );

					//var vignetteElement = document.createDivElement();
					//vignetteElement.id = 'vignette';
					//document.body.appendChild( vignetteElement );

					new fubar.app.PlayActivity( state.mode ).boot( container );
					//new fubar.app.AboutActivity().boot( activityElement );

					/*
					#if web
					var params = haxe.web.Request.getParams();
					if( params.exists( 'id' ) )
					new ItemActivity( params.get( 'id' ) ).boot();
					else
					new IntroActivity().boot();
					#else
					new IntroActivity().boot();
					#end

					* /
					#if !chrome
					window.addEventListener( 'beforeunload', handleBeforeUnload, false );
					#end

				}
			);
			*/
		});
	}

	static function handleBeforeUnload(e) {
		saveConfig();
        //saveState();
    }

	static inline function loadConfig( callback : Config->Void ) Storage.get( 'config', callback );
	static inline function saveConfig() Storage.set( 'config', App.config );

	//static inline function loadState( callback : State->Void ) Storage.get( 'state', callback );
	//static inline function saveState() Storage.set( 'state', App.state );

	static function main() {
		window.onload = function(){
			document.body.innerHTML = '';
			init();
		}
	}
}
