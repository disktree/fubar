package fubar.net;

import om.Error;
import js.html.ImageElement;
import js.html.Worker;
import js.html.XMLHttpRequest;

class ImagePreloader {

	public var maxConcurrentPreloads : Int;

	var map : Map<String,XMLHttpRequest>;
	var numActivePreloads : Int;

	var worker : Worker;

	public function new( maxConcurrentPreloads = 10 ) {

		this.maxConcurrentPreloads = maxConcurrentPreloads;

		numActivePreloads = 0;
		map = new Map();

		worker = new Worker( 'worker/image-preloader.js' );
		worker.onmessage = function(e) {
			switch e.data.status {
			case 0:
				//trace(e.data.url);
			case 1:
				trace( e.info, 'error' );
			}
		}
		worker.onerror = function(e) {
			trace( e, 'error' );
		}
	}

	public function preload( url : String, ?onResult : Error->Void, useWorker = false ) {

		if( map.exists( url ) ) {
			trace( 'already preloaded: '+url, 'warn' );
			return;
		}
		if( numActivePreloads == maxConcurrentPreloads ) {
			trace( 'max concurrent preload size: '+maxConcurrentPreloads, 'warn' );
			return;
		}

		if( useWorker ) {
			worker.postMessage( { type: 0, url: url } );

		} else {

			var xhr = new XMLHttpRequest();
			map.set( url, xhr );
			numActivePreloads++;

			xhr.responseType = BLOB;
			xhr.open( 'GET', url, true );
			xhr.onload = function(e){
				map.remove( url );
				numActivePreloads--;
				if( onResult != null ) onResult( null );
				//onComplete( untyped window.URL.createObjectURL( xhr.response ) );
			};
			/*
			xhr.onprogress = function(e){
			onProgress( e.total, e.loaded );
			};
			*/
			xhr.onerror = function(e){
				map.remove( url );
				numActivePreloads--;
				if( onResult != null ) onResult( e );
			};

			xhr.send();
		}
	}

	public function dispose() {
		for( r in map ) r.abort();
		map = new Map();
		numActivePreloads = 0;
		if( worker != null ) {
			worker.postMessage( { type: 1 } );
			worker.terminate();
		}
	}

}
