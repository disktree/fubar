package fubar.gui.player;

import js.Browser.document;
import js.html.ImageElement;
//import fubar.App.state;

class ControlMenuAutoplay extends ControlMenu {

    public dynamic function onChange( autoplay : Bool ) {}

    //public var busy(null,set) : Bool;

    var autoplay : Bool;
    var buttonPlay : ImageElement;
    var buttonPause : ImageElement;
    var preload : ImageElement;

    public function new() {

        super( 'autoplay' );

		//Autoplay = autoplay;

        buttonPlay = addIconButton( 'play' );
        buttonPause = addIconButton( 'pause' );

        //preload = addIconButton( 'preloader' );
        //preload.style.display = 'none';

        //set( state.autoplay );
        set( false );

        element.addEventListener( 'click', handleClick, false );
    }

    function handleClick(e) {
        set( !autoplay );
    }

    function set( autoplay : Bool ) {
        this.autoplay = autoplay;
        if( autoplay ) {
            buttonPlay.style.display = 'none';
            buttonPause.style.display = 'inline-block';
        } else {
            buttonPlay.style.display = 'inline-block';
            buttonPause.style.display = 'none';
        }
        onChange( autoplay );
    }
}
