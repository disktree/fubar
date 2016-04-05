package fubar.gui;

import om.Error;
import js.Browser.console;
import js.Browser.document;
import js.Browser.window;
import js.html.Element;
import js.html.DivElement;
import js.html.ImageElement;
import om.Time;
import om.api.Giphy;
import fubar.net.ImagePreloader;
import fubar.gui.player.*;

class Player {

    public dynamic function onView( item : om.api.Giphy.Item ) {}

    public var element(default,null) : Element;
    public var container(default,null) : DivElement;

    public var index(default,null) : Int;
    public var items(default,null) : Array<om.api.Giphy.Item>;
	public var pagination(default,null)  : Pagination;//TODO

	public var scaleMode(default,set)  : ScaleMode;
	inline function set_scaleMode( m : ScaleMode ) {
		if( currentView != null ) {
			//currentView.scaleMode = m;
		}
		return scaleMode = m;
	}

	public var backgroundColor(default,set) : String;
	inline function set_backgroundColor( v : String ) return backgroundColor = element.style.backgroundColor = v;

	//var background : DivElement;
    var currentView : ItemView;
	var nextView : ItemView;
	var preloader : ImagePreloader;

    public function new( ?scaleMode : ScaleMode, backgroundColor = '#000' ) {

		if( scaleMode == null ) scaleMode = fit;

        element = document.createDivElement();
        element.classList.add( 'player' );

		this.scaleMode = scaleMode;
        this.backgroundColor = backgroundColor;

		//trace(this.scaleMode);

        index = 0;

		//background = document.createDivElement();
        //background.classList.add( 'background' );
        //element.appendChild( background );

        container = document.createDivElement();
        container.classList.add( 'media' );
        element.appendChild( container );

		preloader = new ImagePreloader();
    }

	public function resize( width : Int, height : Int ) {
		if( currentView != null ) {

			//currentView.resize( width, height, letterbox );
		}
	}

    public function load( items : Array<om.api.Giphy.Item>, index = 0, ?pagination : Pagination ) {

        if( this.items != null )
            clear();

        this.items = items;
        this.pagination = pagination;

		goto( index );
    }

    public function goto( i : Int ) {

        if( i > items.length || i < 0 ) {
            //TODO
            return;
        }

		var item = items[i];
		if( item == null ) {
			trace( 'item == null', 'error' );
			return;
		}

		//if( item.images.original.size > )

        var isNext = this.index+1 == i;
        var isPrev = this.index-1 == i;

        //var item = items[index];

		trace( 'goto $i' );
		//trace( item );

		this.index = i;

		if( nextView != null ) {
			nextView.remove( true );
		}

        nextView = new ItemView( item, 'full-width' );
		nextView.onLoadProgress = function(bytes,total){

		}
        nextView.onLoad = function(){

            if( nextView == null ) {
                return;
            }

            //nextView.onSlugSelect = function(){

			//nextView.gif.classList.add( 'full-width' );

			nextView = null;

            onView( item );

            //TODO preload
			if( isNext && index < items.length-1 ) preload( items[index+1] );
			if( isPrev && index > 0 ) preload( items[index-1] );

        }
        container.appendChild( nextView.element );

        if( currentView != null ) {
            currentView.remove();
        }

        currentView = nextView;
    }

    public function prev() {
        if( index > 0 ) {
            goto( index-1 );
        } else {
            //TODO show a 'load more' button if pagination allows it
        }
    }

    public function next() {
        if( index < items.length-1 ) {
            goto( index+1 );
        } else {
            //TODO show a 'load more' button if pagination allows it
        }
    }

    public function clear() {
        while( container.firstChild != null )
            container.removeChild( container.firstChild );
        items = [];
        index = 0;
		preloader.dispose();
    }

	public function dispose() {
		if( currentView != null ) currentView.remove( true );
		if( nextView != null ) nextView.remove( true );
    }

	function preload( item : om.api.Giphy.Item, ?callback : Error->Void ) {
		var url = item.images.original.url;
		//trace( 'preloading: '+url );
		preloader.preload( url, callback );
	}

	/*
	function preloadRange( start : Int, end : Int, callback : Void->Void ) {
		for( i in start...end ) {
			preload( items[i] );
		}
	}
	*/
}
