package fubar.app;

import om.html.ImageElement;
import js.html.Event;

class IntroActivity extends om.app.Activity {

	var banner : ImageElement;

    override function onCreate() {

        super.onCreate();

        banner = new ImageElement( 'image/giphy-badge-640.gif' );
		banner.on( 'animationend', function(e:Event) {
			e.stopPropagation();
        	replace( new PlayActivity( trending ) );
    	}, false );
    }

	override function onStart() {
		super.onStart();
		element.append( banner );
	}

	override function onStop() {
		super.onStop();
		banner.remove();
	}
}
