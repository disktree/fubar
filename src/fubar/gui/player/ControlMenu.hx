package fubar.gui.player;

import js.Browser.document;
import js.Browser.window;
import js.html.Element;
import js.html.ImageElement;

/**
    Abstract base class for control groups.
*/
class ControlMenu {

	public var hidden(default,null) : Bool;
    public var element(default,null) : Element;

    function new( id : String ) {

		hidden = false;

        element = document.createDivElement();
        element.classList.add( 'menu', id, 'shown' );
    }

    public function show() {
        hidden = false;
        element.classList.add( 'shown' );
        element.classList.remove( 'hidden' );
    }

    public function hide() {
        hidden = true;
		element.classList.remove( 'shown' );
        element.classList.add( 'hidden' );
    }

    public inline function toggle() {
        hidden ? show() : hide();
    }

	public function dispose() {
	}

	function addIconButton( id : String ) : ImageElement {
        var e = createIconButton( id );
        element.appendChild( e );
        return e;
    }

    function createIconButton( id : String ) : ImageElement {
        var img = document.createImageElement();
        img.classList.add( 'button', id );
        img.src = 'image/ic_$id.png';
        return img;
    }
}
