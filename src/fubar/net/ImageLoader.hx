package fubar.net;

import js.Error;
import js.html.ImageElement;
import js.html.XMLHttpRequest;

class ImageLoader {

    public dynamic function onProgress( total : Int, loaded : Int ) {}
    public dynamic function onComplete( src : String ) {}
    public dynamic function onError( e : Error ) {}

    var xhr : XMLHttpRequest;

    public function new() {}

    public function load( url : String ) {
        xhr = new js.html.XMLHttpRequest();
        xhr.responseType = BLOB;
        xhr.open( 'GET', url, true );
        xhr.onload = function(e){
            onComplete( untyped window.URL.createObjectURL( xhr.response ) );
            xhr = null;
        };
        xhr.onprogress = function(e){
            onProgress( e.total, e.loaded );
        };
        xhr.onerror = function(e){
            onError(e);
            xhr = null;
        };
        xhr.send();
    }

    public function abort() {
        if( xhr != null ) {
            trace( 'aborting image load' );
            xhr.abort();
        }
    }

}
