package fubar.ui.player;

import js.Browser.document;
import js.Browser.window;
import js.html.Element;

class Controls {

    //public dynamic function onInput<T>( key : String, value : T ) {}

    public var element(default,null) : Element;
    public var isVisible(default,null) : Bool;

    public var mode(default,null) : ControlMenuMode;
    //public var play(default,null) : ControlMenuPlay;
    public var share(default,null) : ControlMenuShare;

    public function new() {

        isVisible = false;

        element = document.createDivElement();
        element.classList.add( 'controls' );
        /*
        element.addEventListener( 'animationend', function(e){
            switch e.animationName {
            case 'hide':
                element.style.display = 'none';
            }
        }, false );
        */

        //this.play = new ControlMenuPlay( false );
        //element.appendChild( play.element );

        this.mode = new ControlMenuMode();
        element.appendChild( mode.element );

        this.share = new ControlMenuShare();
        element.appendChild( share.element );
    }

    public function show() {
        isVisible = true;
        //element.style.display = 'block';
        element.classList.add( 'show' );
        element.classList.remove( 'hide' );
    }

    public function hide() {
        isVisible = false;
        element.classList.remove( 'show' );
        element.classList.add( 'hide' );
    }

    public function toggle() {
        isVisible ? hide() : show();
    }
}
