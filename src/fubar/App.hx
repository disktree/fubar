package fubar;

import js.Browser.document;
import js.Browser.window;
import fubar.app.IntroActivity;
import om.api.Giphy;
import fubar.app.ItemActivity;

typedef Config = {
	var limit : Int;
	var rating : Rating;
}

typedef State = {
	var mode : PlayMode;
	var search : String;
}

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

	public static var config(default,null) : Config;
	public static var service(default,null) : Service;
	public static var state(default,null) : fubar.State;

	static function init() {

		config = {
			rating: null,
			limit: 100
		};

		loadState( function(s){

			if( s == null ) {
				s = {
					mode: PlayMode.trending,
					search: null
				};
			} else {
				if( s.search == null || s.search.length == 0 )
					s.mode = trending;
			}

			state = s;
			saveState();

			service = new Service( fubar.macro.Build.getGiphyAPIKey() );

			new fubar.app.PlayActivity( state.mode ).boot();

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

			*/
			#if !chrome
			window.addEventListener( 'beforeunload', handleBeforeUnload, false );
			#end

		});
	}

	static function handleBeforeUnload(e) {
		//js.Browser.getLocalStorage().setItem( 'fubar_state', haxe.Json.stringify(state) );
        saveState();
    }

	static inline function loadState( callback : State->Void )
		Storage.get( 'state', callback );

	static inline function saveState()
		Storage.set( 'state', App.state );

	static function main() {
		window.onload = function(){
			document.body.innerHTML = '';
			init();
		}
	}
}
