package fubar.app;

import js.Browser.window;
import om.input.Keycode;
import om.api.Giphy;
import fubar.ui.Player;
import fubar.ui.TouchInput;
import fubar.App.config;
import fubar.App.service;
import fubar.ui.Tetroid;

class PlayActivity extends om.app.Activity {

    var mode : PlayMode;
    var player : Player;
    var animationFrameId : Int;
    var touchInput : TouchInput;
	//var tetroid : Tetroid;

    public function new( mode : PlayMode ) {
        super();
        this.mode = mode;
    }

    override function onCreate() {

        super.onCreate();

        player = new Player( config.autoplay );
        element.append( player.element );
    }

    override function onStart() {

        super.onStart();

		switch mode {
		case trending:
			loadTrendingItems();
		case search:
			//TODO
			//loadItems();
		default:
			loadItem( mode );
		}

		/*
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

		/*
		tetroid = new Tetroid( 40, 4, '#e0e0e0', 4 );
		tetroid.canvas.classList.add( 'tetroid' );
		tetroid.context.lineWidth = 1;
		element.append( tetroid.canvas );
		*/

		touchInput = new TouchInput( player.container );
		touchInput.onGesture = handleTouchGesture;
		//touchInput.onStart = handleTouchStart;

		container.addEventListener( 'click', handleClickContainer, false );

		window.addEventListener( 'keydown', handleKeyDown, false );

        animationFrameId = window.requestAnimationFrame( update );
    }

    override function onStop() {

        super.onStop();

        window.cancelAnimationFrame( animationFrameId );

		//touchInput.dispose();

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
		trace(gesture);
		switch gesture {
        case tap:
            player.controls.toggle();
        case up(v):
			player.controls.show();
            //TODO show image info
            //player.showImageInfo();
        case down(v):
			player.controls.hide();
            //TODO hide image info
            //player.showImageInfo();
        case left(v):
            player.next();
        case right(v):
            player.prev();
        }
	}

	function handleClickContainer(e) {
		if( e.pageX < window.innerWidth/2 ) {
			player.prev();
		} else {
			player.next();
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
