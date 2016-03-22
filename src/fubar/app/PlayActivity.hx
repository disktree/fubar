package fubar.app;

import js.Browser.window;
import om.input.Keycode;
import om.api.Giphy;
import fubar.ui.Player;
import fubar.ui.TouchInput;
import fubar.App.config;
import fubar.App.service;

class PlayActivity extends om.app.Activity {

    var mode : PlayMode;
    var player : Player;
    var animationFrameId : Int;

    var touchInput : TouchInput;

    public function new( mode : PlayMode ) {
        super();
        this.mode = mode;
    }

    override function onCreate() {

        super.onCreate();

        player = new Player();
        element.append( player.element );
    }

    override function onStart() {

        super.onStart();

		//TODO show preloader

		switch mode {
		case trending:
			loadTrendingItems();
		case search:
			//loadItems();
		default:
			loadItem( mode );
		}

		/*
		trace(mode);

		#if web
		var params = haxe.web.Request.getParams();
		if( params.exists( 'id' ) ) {
			loadItem( params.get( 'id' ) );
		} else
			loadTrendingItems();

		#else
		loadTrending();

		#end


		#if android
		touchInput = new TouchInput( player.element );
		touchInput.onGesture = handleTouchGesture;

		#elseif chrome

		#elseif web
		if( om.System.supportsTouchInput() ) {
			touchInput = new TouchInput( player.element );
			touchInput.onGesture = handleTouchGesture;
		} else {
		}
		#end
		*/

		window.addEventListener( 'keydown', handleKeyDown, false );

        animationFrameId = window.requestAnimationFrame( update );
    }

    override function onStop() {

        super.onStop();

        window.cancelAnimationFrame( animationFrameId );

		touchInput.dispose();

        window.removeEventListener( 'keydown', handleKeyDown );
    }

	function loadItem( id : String ) {
		service.get( id, function(e,item){
			if( e != null ) {
				//TODO
			} else {
				player.setItems( [item] );
			}
		});
	}

	function loadItems( q : Array<String> ) {
		service.trending( config.limit, config.rating, function(e,items){
			if( e != null ) {
				//TODO
			} else {
				player.setItems( items );
			}
		});
	}

	function loadTrendingItems() {
		service.trending( config.limit, config.rating, function(e,items){
			if( e != null ) {
				//TODO
			} else {
				player.setItems( items );
			}
		});
	}

    function update( time : Float ) {
		animationFrameId = window.requestAnimationFrame( update );
        player.update( time );
    }

	function handleTouchGesture( gesture : TouchGesture ) {
		switch gesture {
        case tap:
            player.controls.toggle();
        case up(v):
            //TODO show image info
            //player.showImageInfo();
        case down(v):
            //TODO hide image info
            //player.showImageInfo();
        case left(v):
            player.next();
        case right(v):
            player.prev();
        }
	}

    function handleKeyDown(e) {
        //trace(e.keyCode);
        switch e.keyCode {
        case arrow_up:
        case arrow_right:
            player.next();
        case arrow_down:
        case arrow_left:
            player.prev();
        }
    }
}
