package fubar.net;

import om.Error;
import js.html.ImageElement;
import js.html.XMLHttpRequest;

class ImagePreloader {

	public var maxPreloads : Int;

	var map : Map<String,XMLHttpRequest>;
	var numPreloads : Int;

	public function new( maxPreloads = 4 ) {
		this.maxPreloads = maxPreloads;
		map = new Map();
		numPreloads = 0;
	}

	public function preload( url : String, ?callback : Error->Void ) {

		if( map.exists( url ) ) {
			return;
		}
		if( numPreloads == maxPreloads ) {
			trace('max preload size reached');
			return;
		}

		var xhr = new XMLHttpRequest();
		map.set( url, xhr );
		numPreloads++;

	    xhr.responseType = BLOB;
	    xhr.open( 'GET', url, true );
	    xhr.onload = function(e){
			map.remove( url );
			numPreloads--;
			if( callback != null ) callback( null );
	        //onComplete( untyped window.URL.createObjectURL( xhr.response ) );
	    };
		/*
	    xhr.onprogress = function(e){
	        onProgress( e.total, e.loaded );
	    };
		*/
	    xhr.onerror = function(e){
			map.remove( url );
			numPreloads--;
			if( callback != null ) callback( e );
	    };

	    xhr.send();
	}

	public function dispose() {
		for( xhr in map ) xhr.abort();
		map = new Map();
	}

}
