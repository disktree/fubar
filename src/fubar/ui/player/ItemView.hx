package fubar.ui.player;

import js.Browser.document;
import js.html.DivElement;
import js.html.ImageElement;
import fubar.net.ImageLoader;

class ItemView {

    public dynamic function onLoad() {}

    public var element(default,null) : DivElement;

    var gif : ImageElement;
    var still : ImageElement;
	var loader : ImageLoader;

    public function new( item : om.api.Giphy.Item ) {

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

        gif = document.createImageElement();
        gif.classList.add( 'gif' );
		gif.onload = function(){
            gif.classList.add( 'playing' );
            onLoad();
        }
        element.appendChild( gif );

        still = document.createImageElement();
		still.src = item.images.original_still.url;
        element.appendChild( still );

		loader = new fubar.net.ImageLoader();
        loader.onProgress = function(t,l) {
            //var percent = l/t*100;
            //loadbar.style.width = percent+'px';
            //onLoadProgress( l, t );
        }
        loader.onComplete = function(src) {
            //loadbar.remove();
			still.remove();
            gif.src = src;
        }
        loader.load( item.images.original.url );
    }

    public function remove() {
		loader.abort();
        element.classList.remove( 'playing' );
        element.classList.add( 'out' );
    }

}
