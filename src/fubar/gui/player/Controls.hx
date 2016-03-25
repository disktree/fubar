package fubar.gui.player;

import js.Browser.document;
import js.Browser.window;
import js.html.Element;

class Controls {

    //public dynamic function onInput<T>( key : String, value : T ) {}

    public var element(default,null) : Element;
    public var hidden(default,null) : Bool;

    public var mode(default,null) : ControlMenuMode;
    public var play(default,null) : ControlMenuAutoplay;
    public var share(default,null) : ControlMenuShare;

	var menus : Array<ControlMenu>;

    public function new( autoplay : Bool ) {

        hidden = false;

		menus = [];

        element = document.createDivElement();
        element.classList.add( 'controls', 'shown' );
        /*
        element.addEventListener( 'animationend', function(e){
            switch e.animationName {
            case 'hide':
                element.style.display = 'none';
            }
        }, false );
        */

		this.play = addControlMenu( new ControlMenuAutoplay( autoplay ) );
		this.mode = addControlMenu( new ControlMenuMode() );
		this.share = addControlMenu( new ControlMenuShare() );
    }

    public function show() {
		hidden = false;
		element.classList.add( 'shown' );
        element.classList.remove( 'hidden' );
		for( m in menus ) m.show();
    }

    public function hide() {
        hidden = true;
		element.classList.remove( 'shown' );
		element.classList.add( 'hidden' );
		for( m in menus ) m.hide();
    }

    public inline function toggle() {
        hidden ? show() : hide();
    }

	public function dispose() {
		for( m in menus ) m.dispose();
		menus = [];
	}

	function addControlMenu<T:ControlMenu>( menu : T ) : T {
		element.appendChild( menu.element );
		menus.push( menu );
		return menu;
	}
}
