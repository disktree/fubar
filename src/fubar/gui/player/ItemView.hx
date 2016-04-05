package fubar.gui.player;

import js.Browser.document;
import js.Browser.window;
import js.html.Element;
import js.html.DivElement;
import js.html.ImageElement;
import js.html.VideoElement;
import fubar.net.ImageLoader;

using StringTools;

class ItemView {

	static inline var ITEM_ANIMATION_PREFIX = 'item_';

    public dynamic function onLoad() {}
    public dynamic function onLoadProgress( bytes : Int, total : Int ) {}
	//public dynamic function onSlugSelect( word : String ) {}

    public var element(default,null) : DivElement;
    //public var gif(default,null) : ImageElement;
    //public var media(get,null) : Element;

	/*
	public var scaleMode(default,set)  : ScaleMode;
	inline function set_scaleMode( m : ScaleMode ) {
		trace(m);
			switch m {
			case original:
				gif.style.width = gif.width+'px';
				gif.style.height = gif.height+'px';
				gif.style.transform = 'translate( '+(window.innerWidth/2-gif.width/2)+'px, '+(window.innerHeight/2-gif.height/2)+'px)';
			case fit:
				gif.style.width = window.innerWidth+'px';
				gif.style.height = window.innerHeight+'px';
				gif.style.transform = '';
			case full:
				var scaleFactorWidth = window.innerWidth / gif.width;
				var scaleFactorHeight = window.innerHeight / gif.height;
				var scaleFactor = (scaleFactorWidth < scaleFactorHeight) ? scaleFactorHeight : scaleFactorWidth;
				var scaledWidth = Std.int( gif.width * scaleFactor );
				var scaledheight = Std.int( gif.height * scaleFactor );
				gif.style.width = scaledWidth+'px';
				gif.style.height = scaledheight+'px';
				gif.style.transform = 'translate( '+(window.innerWidth/2-scaledWidth/2)+'px, '+(window.innerHeight/2-scaledheight/2)+'px)';
			case letterbox:
				var scaleFactorWidth = window.innerWidth / gif.width;
				var scaleFactorHeight = window.innerHeight / gif.height;
				var scaleFactor = (scaleFactorWidth > scaleFactorHeight) ? scaleFactorHeight : scaleFactorWidth;
				var scaledWidth = Std.int( gif.width * scaleFactor );
				var scaledheight = Std.int( gif.height * scaleFactor );
				gif.style.width = scaledWidth+'px';
				gif.style.height = scaledheight+'px';
				gif.style.transform = 'translate( '+(window.innerWidth/2-scaledWidth/2)+'px, '+(window.innerHeight/2-scaledheight/2)+'px)';
			}
		return scaleMode = m;
	}
	*/

    //var video : VideoElement;
    var gif : ImageElement;
    var still : ImageElement;
	var loader : ImageLoader;
	var caption : DivElement;
	var slug : DivElement;

    public function new( item : om.api.Giphy.Item, scaleMode : String ) {

        element = document.createDivElement();
        element.classList.add( 'item', 'inc', scaleMode );
        element.addEventListener( 'animationend', function(e) {
            switch e.animationName {
            case 'item_inc':
                element.classList.remove( 'inc' );
            case 'item_out':
                element.remove();
			default:
				if( e.animationName.startsWith( ITEM_ANIMATION_PREFIX ) )
					element.classList.remove( e.animationName.substr( ITEM_ANIMATION_PREFIX.length ) );
            }
        }, false );

        gif = document.createImageElement();
        gif.classList.add( 'media', 'gif' );
		gif.onload = function(){
			still.style.display = 'none';
			//resize();
			gif.style.display = 'inline-block';
        gif.classList.add( 'playing' );
            onLoad();
        }
        element.appendChild( gif );

        still = document.createImageElement();
		still.onload = function(){
			still.style.display = 'inline-block';
			gif.src = item.images.original.url;
		};
		still.src = item.images.original_still.url;
		//var stillLoader = new fubar.net.ImageLoader();
        //element.appendChild( still );

		/*
		video = document.createVideoElement();
		//video.onclick = function(){ trace("cc"); video.play(); }
		video.classList.add( 'media', 'video' );
		video.autoplay = true;
		video.loop = true;
		video.controls = false;
		video.src = item.images.original.mp4;
		element.appendChild( video );
		*/

		caption = document.createDivElement();
		caption.classList.add( 'caption' );
		if( item.caption != null ) {
			trace(item.caption);
			caption.textContent = item.caption;
		}
		element.appendChild( caption );

		slug = document.createDivElement();
		slug.classList.add( 'slug' );
		if( item.slug != null ) {
			var slugs = item.slug.split('-');
			slugs.pop();
			for( word in slugs ) {
				var e = document.createSpanElement();
				e.onclick = function(){
					//onSlugSelect( word );
				}
				e.textContent = word;
				slug.appendChild(e);
			}
			//slug.textContent = slugs.join(' | ');
		}
		element.appendChild( slug );

		/*
		loader = new fubar.net.ImageLoader();
        loader.onProgress = function(t,l) {
            //var percent = l/t*100;
            //loadbar.style.width = percent+'px';
            onLoadProgress( l, t );
        }
        loader.onComplete = function(src) {
            //loadbar.remove();
			still.remove();
            gif.src = src;
        }
        loader.load( item.images.original.url );
		*/
    }

	/*
	public function resize( width : Int, height : Int, scaleMode : ScaleMode ) {
		switch scaleMode {
		case original:
			gif.style.width = gif.width+'px';
			gif.style.height = gif.height+'px';
			gif.style.transform = 'translate( '+(window.innerWidth/2-gif.width/2)+'px, '+(window.innerHeight/2-gif.height/2)+'px)';
		case fit:
			gif.style.width = window.innerWidth+'px';
			gif.style.height = window.innerHeight+'px';
			gif.style.transform = '';
		case full:
			var scaleFactorWidth = window.innerWidth / gif.width;
			var scaleFactorHeight = window.innerHeight / gif.height;
			var scaleFactor = (scaleFactorWidth < scaleFactorHeight) ? scaleFactorHeight : scaleFactorWidth;
			var scaledWidth = Std.int( gif.width * scaleFactor );
			var scaledheight = Std.int( gif.height * scaleFactor );
			gif.style.width = scaledWidth+'px';
			gif.style.height = scaledheight+'px';
			gif.style.transform = 'translate( '+(window.innerWidth/2-scaledWidth/2)+'px, '+(window.innerHeight/2-scaledheight/2)+'px)';
		case letterbox:
			var scaleFactorWidth = window.innerWidth / gif.width;
			var scaleFactorHeight = window.innerHeight / gif.height;
			var scaleFactor = (scaleFactorWidth > scaleFactorHeight) ? scaleFactorHeight : scaleFactorWidth;
			var scaledWidth = Std.int( gif.width * scaleFactor );
			var scaledheight = Std.int( gif.height * scaleFactor );
			gif.style.width = scaledWidth+'px';
			gif.style.height = scaledheight+'px';
			gif.style.transform = 'translate( '+(window.innerWidth/2-scaledWidth/2)+'px, '+(window.innerHeight/2-scaledheight/2)+'px)';
		}
	}
	*/

    public function remove( immediately = false ) {
		//loader.abort();
		if( immediately ) {
			element.remove();
		} else {
			element.classList.remove( 'playing' );
			element.classList.add( 'out' );
		}
    }

}
