package fubar.ui.player;

import js.Browser.document;
import js.Browser.window;
import js.html.Element;
import js.html.ImageElement;

/**
    Abstract base class for control groups.
*/
class ControlMenu {

    public var element(default,null) : Element;
    public var isVisible(default,null) : Bool;

    function new( id : String ) {

        element = document.createDivElement();
        element.classList.add( 'menu', id, 'visible' );

        isVisible = true;
    }

    public function show() {
        isVisible = true;
        element.classList.add( 'visible' );
    }

    public function hide() {
        isVisible = false;
        element.classList.remove( 'visible' );
    }

    public function toggle() {
        isVisible ? hide() : show();
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
