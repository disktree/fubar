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

        service.trending( config.limit, config.rating, function(e,items){
            if( e != null ) {
                //TODO
            } else {
                player.load( items );
            }
        });

        window.addEventListener( 'keydown', handleKeyDown, false );
		touchInput = new TouchInput( player.element );
		touchInput.onGesture = handleTouchGesture;

        animationFrameId = window.requestAnimationFrame( update );
    }

    override function onStop() {

        super.onStop();

        window.cancelAnimationFrame( animationFrameId );

        window.removeEventListener( 'keydown', handleKeyDown );
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
