package fubar.app;

import js.Browser.document;
import js.Browser.window;
import js.html.DivElement;
import om.input.Keycode;
import om.Time.now;
import om.api.Giphy;
import fubar.gui.Player;
import fubar.gui.TouchInput;
import fubar.gui.player.Controls;
import fubar.gui.player.ControlMenuMode;
import fubar.App.config;
import fubar.App.service;

class PlayActivity extends om.app.Activity {

    var mode : PlayMode;
    var player : Player;
	//var preloader : DivElement;
	var statusbar : DivElement;
    var controls : Controls;
    var touchInput : TouchInput;

	var timeLastImageChange : Float;
	var timeLastUpdate : Float;
	var timeImageShown : Float;
	var timePauseStart : Float;
	var timeInvisibleStart : Float;

    public function new( mode : PlayMode ) {
        super();
        this.mode = mode;
    }

    override function onCreate() {

        super.onCreate();

        player = new Player();
        element.append( player.element );
		//player.scaleMode = fit;

		//preloader = document.createDivElement();
		//preloader.classList.add( 'loader' );
		//preloader.innerHTML = '<div class="ani"><div></div></div>';
		//element.append( preloader );

		controls = new Controls( false);
        element.append( controls.element );

		statusbar = document.createDivElement();
        statusbar.classList.add( 'statusbar' );
        element.append( statusbar );
    }

    override function onStart() {

        super.onStart();

		timeLastImageChange = 0;
		timeLastUpdate = now();
		timeImageShown = 0;
		timePauseStart = 0;

		player.onView = function(item){
			player.resize( window.innerWidth, window.innerHeight );
			timeLastImageChange = now();
			controls.share.item = item;
		}

		controls.mode.onChange = function(change:PlaySettingsChange){

			switch change {
			case PlaySettingsChange.mode(m):
				switch m {
				case trending:
					loadTrendingItems();
				case search:
					var term = controls.mode.searchTerm;
					if( term.length == 0 ) {
						trace( "no search input", 'debug' );
					} else {
						//var terms = ~/(\\s+)/.split( term ); //TODO
						loadItems( term.split('') );
					}
				}
			case PlaySettingsChange.search(term):
				var terms = ~/(\s+)/.split( term ); //TODO
				loadItems( terms );
			}
		}
		controls.play.onChange = function(play){
			if( play ) {
				if( timePauseStart > 0 ) {
					timeImageShown -= now() - timePauseStart;
					timePauseStart = 0;
				}
				statusbar.style.display = 'block';
			} else {
				timePauseStart = now();
				statusbar.style.display = 'none';
			}
		}

		switch mode {
		case trending:
			loadTrendingItems();
		case search:
			//TODO
			//loadItems();
		default:
			loadItem( mode );
		}

		/*
		#if web
		var params = haxe.web.Request.getParams();
		if( params.exists( 'id' ) ) {
			loadItem( params.get( 'id' ) );
		} else
			loadTrendingItems();

		#else
		loadTrending();
		#end

		#if android
		touchInput = new TouchInput( player.element );
		touchInput.onGesture = handleTouchGesture;
		#elseif chrome
		#elseif web
		if( om.System.supportsTouchInput() ) {
			touchInput = new TouchInput( player.element );
			touchInput.onGesture = handleTouchGesture;
		} else {
		}
		#end
		*/

		touchInput = new TouchInput( player.container );
		touchInput.onGesture = handleTouchGesture;
		//touchInput.onStart = handleTouchStart;

		player.element.addEventListener( 'dblclick', handleDoubleClickPlayer, false );
		window.addEventListener( 'keydown', handleKeyDown, false );
		document.addEventListener( 'visibilitychange', handleVisibilityChange, false );
    }

    override function onStop() {

        super.onStop();

		touchInput.dispose();

		player.element.removeEventListener( 'dblclick', handleDoubleClickPlayer );
        window.removeEventListener( 'keydown', handleKeyDown );
        window.removeEventListener( 'resize', handleWindowResize );
		document.removeEventListener( 'visibilitychange', handleVisibilityChange );
    }

	override function update( time : Float ) {

		if( !document.hidden ) {

			timeImageShown += time - timeLastUpdate;

			if( controls.play.autoplay ) {
				if( timeImageShown/1000 >= config.autoplay ) {
					timeImageShown = 0;
					statusbar.style.width = '0px';
					player.next();
				} else {
					var percent = timeImageShown / config.autoplay / 10;
					statusbar.style.width =  Std.int( window.innerWidth * percent / 100 ) + 'px';
					//statusbar.style.left =  Std.int( window.innerWidth * percent / 100 ) + 'px';
				}
			}
		}

		timeLastUpdate = time;
    }

	function loadItem( id : String ) {
		service.get( id, function(e,i) handleItemsLoad( e, [i] ) );
	}

	function loadItems( q : Array<String> ) {
		service.search( q, config.limit, 0, config.rating, handleItemsLoad );
	}

	function loadTrendingItems() {
		service.trending( config.limit, config.rating, handleItemsLoad );
	}

	function handleItemsLoad( e : om.Error, items : Array<Item> ) {
		if( e != null ) {
			//TODO
			//replace( new ErrorActivity(e) );
		} else {
			var filteredItems = new Array<Item>();
			for( item in items ) {
				if( Std.parseInt( item.images.original.size ) < App.config.maxGifSize ) {
					filteredItems.push( item );
				}
			}
			/*
			var itemsReceived = items.length;
			var i = 0;
			for( item in items ) {
				//trace(item.images.original.size +' : '+ App.config.maxGifSize  );
				if( Std.parseInt( item.images.original.size ) > App.config.maxGifSize ) {
					trace(item.images.original.size);
					//trace( 'max gif size exceeded '+item.images.original.size+' '+item.images.original.url );
                	//items.splice( i, 1 );
					items.remove( item );
				}
				i++;
			}
			var n = itemsReceived - items.length;
			if( n > 0 ) trace( n+' items filtered' );
			player.load( items );
			*/
			trace( 'loading '+filteredItems.length+' items ('+(items.length-filteredItems.length)+' filtered)' );
			player.load( filteredItems );
		}
	}

	function handleTouchGesture( gesture : TouchGesture ) {
		//trace(gesture);
		switch gesture {
        case tap:
            controls.toggle();
        case up(v):
			controls.show();
            //TODO show image info
        case down(v):
			controls.hide();
            //TODO hide image info
        case left(v):
            player.next();
        case right(v):
            player.prev();
        }
	}

	function handleClickContainer(e) {
		if( e.pageX < window.innerWidth/2 ) {
			player.prev();
		} else {
			player.next();
		}
	}

	function handleDoubleClickPlayer(e) {
		om.app.Window.toggleFullscreen();
	}

    function handleKeyDown(e) {
        //trace(e.keyCode);
        switch e.keyCode {
        case arrow_up:
        case arrow_right:
            player.next();
        case arrow_down:
        case arrow_left:
            player.prev();
		default:
			//player.next();
        }
    }

	function handleWindowResize(e) {
		player.resize( window.innerWidth, window.innerHeight );
	}

	function handleVisibilityChange(e) {
        if( document.hidden ) {
			if( controls.play.autoplay )
				timeInvisibleStart = now();
        } else {
			if( timeInvisibleStart > 0 ) {
				timeImageShown -= now() - timeInvisibleStart;
				timeInvisibleStart = 0;
			}
        }
    }
}
