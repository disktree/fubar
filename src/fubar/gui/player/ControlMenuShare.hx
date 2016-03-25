package fubar.gui.player;

import js.Browser.document;
import js.Browser.window;
import js.html.AnchorElement;
import js.html.DivElement;
import js.html.ImageElement;
import js.html.SpanElement;

using StringTools;

class ControlMenuShare extends ControlMenu {

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

	var more : ImageElement;
	var menu : DivElement;
	var optDownload : AnchorElement;
	var optLink : AnchorElement;
	var optShare : AnchorElement;

	#if chrome
	//var buttonWallpaper : ImageElement;
	#end

    public function new() {

        super( 'share' );

		isMenuOpen = false;

		menu = document.createDivElement();
		menu.classList.add( 'menu' );
		element.appendChild( menu );

		optShare = addMenuOption( 'share', function(){

			if( item != null ) {

				#if android
				untyped AndroidApp.shareImage( item.images.original.url );

				#else
				//TODO show sub menu buttons for twitter,g+,facebook,...
				window.open( item.bitly_url, '_blank' );

				#end
			}
		});

		optLink = addMenuOption( 'link', function(){});
		optLink.target = '_blank';

		optDownload =
			#if android
			addMenuOption( 'download', function(){
				#if android
				var file = 'giphy-'+item.id+'.gif';
				untyped AndroidApp.downloadImage( item.images.original.url, file, item.images.original.url, file );
				#end
			});
			#else
			addMenuOption( 'download' );
			#end

		more = createIconButton( 'more_vert' );
		more.onclick = toggleMenu;
		element.appendChild( more );

		//document.body.addEventListener( 'click', handleClickBody, false );
		//document.body.addEventListener( 'touchstart', handleClickBody, false );

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
		isMenuOpen = true;
		menu.style.display = 'inline-block';
		return true;
	}

	public function closeMenu() : Bool {
		isMenuOpen = false;
		menu.style.display = 'none';
		return false;
	}

	public inline function toggleMenu() : Bool {
		return isMenuOpen ? closeMenu() : openMenu();
	}

	public override function dispose() {

		super.dispose();

		document.body.removeEventListener( 'click', handleClickBody );
		document.body.removeEventListener( 'touchstart', handleClickBody );

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

	function handleClickBody(e) {
		if( isMenuOpen && e.target != more ) {
			closeMenu();
		}
	}
}
