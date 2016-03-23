package fubar.ui.player;

import js.Browser.document;
import js.Browser.window;
import js.html.AnchorElement;
import js.html.ImageElement;

using StringTools;

class ControlMenuShare extends ControlMenu {

    public var item(default,set) : om.api.Giphy.Item;

    var buttonLink : ImageElement;
    var buttonDownload : ImageElement;
    var buttonShare : ImageElement;

    var linkWeb : AnchorElement;

    #if web
    var linkDownload : AnchorElement;
    #elseif chrome
    //var buttonWallpaper : ImageElement;
    #end

    public function new() {

        super( 'share' );

        buttonLink = createIconButton( 'link' );

        linkWeb = document.createAnchorElement();
        linkWeb.target = '_blank';
        linkWeb.appendChild( buttonLink );
        element.appendChild( linkWeb );

        buttonDownload = createIconButton( 'download' );
        #if web
        linkDownload = document.createAnchorElement();
        linkDownload.appendChild( buttonDownload );
        element.appendChild( linkDownload );
        #elseif android
        buttonDownload.onclick = function() {
            if( item != null ) {
                #if android
                var file = 'giphy-'+item.id+'.gif';
                untyped AndroidApp.downloadImage( item.images.original.url, file, item.images.original.url, file );
                #end
            }
        };
        element.appendChild( buttonDownload );
        #end

        buttonShare = addIconButton( 'share' );
        buttonShare.onclick = function(_) {
            if( item != null ) {
                #if android
                untyped AndroidApp.shareImage( item.images.original.url );
                #else
                window.open( item.bitly_url, '_blank' );
                #end
            }
        }

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

	/*
	public override function dispose() {
		super.dispose();
	}
	*/

    function set_item( item : om.api.Giphy.Item ) {

        var sourceUrl = item.source_post_url;
        if( sourceUrl == null || sourceUrl.length == 0 ) {
            linkWeb.href = null;
            linkWeb.style.visibility = 'hidden';
        } else {
            linkWeb.href = sourceUrl;
            linkWeb.style.visibility = 'visible';
            /*
            //if( item.source_post_url.startsWith( 'http://www.reddit.com' ) ) {
            var icon =
                if( url.indexOf( 'reddit.com' ) != -1 ) 'reddit';
                else if( url.indexOf( 'tumblr.com' ) != -1 ) 'tumblr';
                else 'link';
            buttonLink.src = 'image/$icon.png';
            */
        }

        #if web
        linkDownload.href = item.images.original.url;
        linkDownload.download = item.id+'.gif';
        #end

        if( isVisible ) element.classList.add( 'visible' );

        return this.item = item;
    }

    public function clear() {

        item = null;

        linkWeb.href = null;

        #if web
        linkDownload.href = linkDownload.download = null;
        #end

        element.classList.remove( 'visible' );
    }
}
