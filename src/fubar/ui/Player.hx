package fubar.ui;

import js.Browser.document;
import js.html.Element;
import js.html.DivElement;
import js.html.ImageElement;
import om.Time;
import om.api.Giphy;
import fubar.ui.player.*;
import fubar.App.config;
import fubar.App.service;

class Player {

    public dynamic function onView( item : om.api.Giphy.Item ) {}

    public var element(default,null) : Element;
    public var backgroundColor(default,set) : String;
    public var index(default,null) : Int;
	public var controls(default,null) : Controls;
    public var items(default,null) : Array<om.api.Giphy.Item>;
	public var pagination(default,null)  : Pagination;

	var background : DivElement;
    var container : DivElement;
    var currentView : ItemView;

    public function new( backgroundColor = '#000' ) {

        element = document.createDivElement();
        element.classList.add( 'player' );

        this.backgroundColor = backgroundColor;

        index = 0;

		background = document.createDivElement();
        background.classList.add( 'background' );
        element.appendChild( background );

        container = document.createDivElement();
        container.classList.add( 'items' );
        element.appendChild( container );

        controls = new Controls();
		controls.mode.onChange = function(change) {
			switch change {
			case mode(m):
				switch m {
				case trending:
					service.trending( config.limit, config.rating, function(e,items){
						if( e != null ) {
							//TODO
						} else {
							load( items );
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
						load( items );
					}
				});
			}
		}
        element.appendChild( controls.element );
    }

    function set_backgroundColor(v:String) : String {
        return backgroundColor = element.style.backgroundColor = v;
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

        var isNext = this.index+1 == i;
        var isPrev = this.index-1 == i;

        this.index = i;

        trace( 'goto $index' );

        var item = items[index];

        var newView = new ItemView( item );
        newView.onLoad = function(){
            //lastImageChangeTime = Time.now();
            onView( item );
            //TODO preload
        }
        container.appendChild( newView.element );

        if( currentView != null ) {
            currentView.remove();
        }

        currentView = newView;
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
        //lastImageChangeTime = -1;
    }

    public function update( time : Float ) {
    }
}
