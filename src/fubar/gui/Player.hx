package fubar.gui;

import js.Error;
import js.Browser.console;
import js.Browser.document;
import js.html.Element;
import js.html.DivElement;
import js.html.ImageElement;
import om.Time;
import om.api.Giphy;
import fubar.net.ImagePreloader;
import fubar.gui.player.*;
import fubar.App.config;
import fubar.App.service;

class Player {

    public dynamic function onView( item : om.api.Giphy.Item ) {}

    public var element(default,null) : Element;
    public var container(default,null) : DivElement;
    public var index(default,null) : Int;
    public var items(default,null) : Array<om.api.Giphy.Item>;
	public var pagination(default,null)  : Pagination;
	public var controls(default,null) : Controls;
	//public var input(default,null)  : TouchInput;
	//public var rating : Rating;
	//public var limit : Int;

	public var autoplay(default,set) : Int;
	function set_autoplay(v:Int) {
		if( v > 0 && lastImageChangeTime > 0 ) {
			var now = Time.now();
			var elapsed = (now - lastImageChangeTime)/1000;
			if( elapsed > v ) {
				next();
			} else {
				lastImageChangeTime = now - (v-elapsed);
			}
		}
		return autoplay = v;
	}

	public var backgroundColor(default,set) : String;
	inline function set_backgroundColor( v : String ) return backgroundColor = element.style.backgroundColor = v;

	var background : DivElement;

    var currentView : ItemView;
	var nextView : ItemView;
	var preloader : ImagePreloader;
	var lastImageChangeTime : Float;

    //public function new( ?autoplay = 0, ?rating : Rating, ?limit : Int, backgroundColor = '#000' ) {
    public function new( ?autoplay = 0, backgroundColor = '#000' ) {

        element = document.createDivElement();
        element.classList.add( 'player' );

        this.backgroundColor = backgroundColor;
        this.autoplay = autoplay;
        //this.rating = rating;
        //this.limit = limit;

        index = 0;
		lastImageChangeTime = 0;

		background = document.createDivElement();
        background.classList.add( 'background' );
        element.appendChild( background );

        container = document.createDivElement();
        container.classList.add( 'media' );
        element.appendChild( container );

        controls = new Controls();
		controls.play.onChange = function(yes) {

		}
		controls.mode.onChange = function(change) {
			switch change {
			case mode(m):
				switch m {
				case trending:
					service.trending( config.limit, config.rating, function(e,items){
						if( e != null ) {
							//TODO
						} else {
							setItems( items );
						}
					});
				case search:
					//currentView.style.display = 'none';
					var term = controls.mode.searchTerm;
					if( term.length == 0 ) {
						trace("NO INPUT");
					} else {

					}
					/*
					service.search( 10, function(e,items){
						if( e != null ) {
							//TODO
						} else {
							load( items );
						}
					});
					*/
				}
			case search(term):
				service.search( [term], config.limit, config.rating, function(e,items){
					if( e != null ) {
						//TODO
					} else {
						setItems( items );
					}
				});
			}
		}
        element.appendChild( controls.element );

		preloader = new ImagePreloader();

		//var touchX = 0;
		//var touchY = 0;

		//input = new TouchInput( element );
		//input.onGesture = handleTouchGesture;
		/*
		input.onStart = function(e){
			var touch = e.touches[0];
			touchX = touch.pageX;
		}
		input.onMove = function(e){
			var touch = e.touches[0];
			var dx = touch.pageX - touchX;
			currentView.element.style.left = dx+'px';
		}
		input.onEnd = function(e){
			currentView.element.classList.add( 'back_to_init' );
		}
		*/
    }

    public function setItems( items : Array<om.api.Giphy.Item>, index = 0, ?pagination : Pagination ) {

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

        var isNext = this.index+1 == i;
        var isPrev = this.index-1 == i;

        this.index = i;

        trace( 'goto $index' );

        var item = items[index];

		trace(item);

		if( nextView != null ) {
			nextView.remove( true );
		}

        nextView = new ItemView( item );
        nextView.onLoad = function(){

			nextView = null;
			lastImageChangeTime = Time.now();

			controls.share.item = item;

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
        lastImageChangeTime = 0;
    }

    public function update( time : Float ) {
		if( autoplay > 0 && lastImageChangeTime > 0 ) {
			var elapsed = (time - lastImageChangeTime)/1000;
			if( elapsed > autoplay ) {
                lastImageChangeTime = 0;
                next();
			}
		}
    }

	public function dispose() {
		//input.dispose();
		if( currentView != null ) currentView.remove( true );
		if( nextView != null ) nextView.remove( true );
		controls.dispose();
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
