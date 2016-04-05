package fubar.gui.player;

import js.Browser.document;
import js.Browser.window;
import js.html.AnchorElement;
import js.html.DivElement;
import js.html.ImageElement;
import js.html.SpanElement;
import haxe.Timer;

using StringTools;

class ControlMenuShare extends ControlMenu {

	static inline var MENU_TIMEOUT = 3000;

    public var item(default,set) : om.api.Giphy.Item;
	function set_item(n:om.api.Giphy.Item) {

		item = n;

		if( item == null ) {

			optLink.href = null;

			optDownload.href = null;
			optDownload.download = null;

			optShare.style.display = 'none';
			optLink.style.display = 'none';
			optDownload.style.display = 'none';

		} else {
			var sourceUrl = item.source_post_url;
			if( sourceUrl == null || sourceUrl.length == 0 ) {
				optLink.href = null;
				optLink.style.display = 'none';
			} else {
				optLink.href = sourceUrl;
				optLink.style.display = 'inline-block';
				var icon =
		            if( sourceUrl.indexOf( 'reddit.com' ) != -1 ) 'reddit';
		            else if( sourceUrl.indexOf( 'tumblr.com' ) != -1 ) 'tumblr';
		            else if( sourceUrl.indexOf( 'youtube.com' ) != -1 ) 'youtube';
		            else 'link';
				untyped optLink.children[0].src = 'image/ic_$icon.png';
			}

			#if web
			optDownload.href = item.images.original.url;
			optDownload.download = 'giphy-'+item.id+'.gif';
			#end
		}

		return item;
	}

	var isMenuOpen : Bool;
	var isMouseOver : Bool;

	var more : ImageElement;
	var menu : DivElement;
	var optDownload : AnchorElement;
	var optLink : AnchorElement;
	var optShare : AnchorElement;

	#if chrome
	//var buttonWallpaper : ImageElement;
	#end

	var timer : Timer;

    public function new() {

        super( 'share' );

		isMenuOpen = isMouseOver = false;
		timer = new Timer( MENU_TIMEOUT );

		menu = document.createDivElement();
		menu.classList.add( 'menu', 'closed' );
		element.onmouseenter = function() {
			isMouseOver = true;
		}
		element.onmouseleave = function() {
			isMouseOver = false;
			if( timer == null ) closeMenu();
		}
		element.appendChild( menu );

		optShare = addMenuOption( 'share', function(){

			closeMenu();

			if( item != null ) {

				#if android
				untyped AndroidApp.shareImage( item.images.original.url );

				#else
				//TODO show sub menu buttons for twitter,g+,facebook,...
				window.open( item.bitly_url, '_blank' );

				#end
			}
		});
		optShare.title = 'Share Image';

		optLink = addMenuOption( 'link', function(){});
		optLink.title = '';
		optLink.target = '_blank';

		optDownload =
			#if android
			addMenuOption( 'download', function(){
				closeMenu();
				var file = 'giphy-'+item.id+'.gif';
				untyped AndroidApp.downloadImage( item.images.original.url, file, item.images.original.url, file );
			});
			#else
			addMenuOption( 'download', function(){
				closeMenu();
			});
			#end

		optDownload.title = 'Download Image';

		more = createIconButton( 'more_vert' );
		more.onclick = toggleMenu;
		element.appendChild( more );

		/*
		if( om.System.supportsTouchInput() ) {
			App.element.addEventListener( 'touchstart', handleClickBody, false );
		} else {
			App.element.addEventListener( 'click', handleClickBody, false );
		}
		*/

        /*
        #if chrome
        buttonWallpaper = addIconButton( 'wallpaper' );
        buttonWallpaper.onclick = function(){
            if( item != null ) {
                chrome.Wallpaper.setWallpaper( {
                    url : item.images.original.url,
                    layout: CENTER,
                    filename: item.id+'.gif',

                }, function(thumbnail){
                    trace(thumbnail);
                });
            }
        }
        #end
        */
    }

	public function openMenu() : Bool {
		destroyTimer();
		isMenuOpen = true;
		menu.classList.remove( 'closed' );
		menu.classList.add( 'opened' );
		timer = new Timer( MENU_TIMEOUT );
		timer.run = function(){
			timer.stop();
			timer = null;
			if( !isMouseOver ) closeMenu();
		}
		return true;
	}

	public function closeMenu() : Bool {
		destroyTimer();
		isMenuOpen = false;
		menu.classList.remove( 'opened' );
		menu.classList.add( 'closed' );
		return false;
	}

	public inline function toggleMenu() : Bool {
		return isMenuOpen ? closeMenu() : openMenu();
	}

	public override function dispose() {

		super.dispose();

		destroyTimer();
		/*
		if( om.System.supportsTouchInput() ) {
			App.element.removeEventListener( 'touchstart', handleClickBody );
		} else {
			App.element.removeEventListener( 'click', handleClickBody );
		}
		*/

		menu.remove();
		more.remove();
	}

	function addMenuOption( id : String, ?onSelect : Void->Void ) : AnchorElement {

		var a = document.createAnchorElement();
		a.classList.add( 'option' );

		var icon = document.createImageElement();
		icon.src = 'image/ic_$id.png';
		icon.classList.add( 'button' );
		a.appendChild( icon );

		menu.appendChild( a );

		if( onSelect != null ) {
			a.onclick = onSelect;
			a.ontouchstart = onSelect;
		}

		return a;
	}

	function destroyTimer() {
		if( timer != null ) {
			timer.stop();
			timer = null;
		}
	}

	/*
	function handleClickBody(e) {
		trace(e);
		if( isMenuOpen && e.target != more ) {
			closeMenu();
		}
	}
	*/
}
