package fubar.app;

import js.Browser.document;
import js.Browser.window;
import js.html.DivElement;
import js.html.ImageElement;
import om.input.Keycode;
import om.api.Giphy;
import fubar.App.service;

class ItemActivity extends om.app.Activity {

	var item : Item;

	public function new( item : om.api.Giphy.Item ) {
		super();
		this.item = item;
	}

	override function onCreate() {

        super.onCreate();

		/*
		element = document.createDivElement();
        element.classList.add( 'item', 'inc' );
		element.addEventListener( 'animationend', function(e) {
            switch e.animationName {
            case 'item_inc':
                element.classList.remove( 'inc' );
            case 'item_out':
                element.remove();
            }
        }, false );
		*/

		var original = item.images.original;

		var gif = document.createImageElement();
		//gif.width = Std.parseInt( original.width );
		//gif.height = Std.parseInt( original.height );
        gif.classList.add( 'scale-fit' );
		gif.onload = function(){
            gif.classList.add( 'playing' );
            //onLoad();
        }
		gif.src = item.images.original.url;
        element.append( gif );

	}
}
