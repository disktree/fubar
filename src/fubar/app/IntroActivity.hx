package fubar.app;

import om.html.ImageElement;
import js.html.AnimationEvent;

class IntroActivity extends om.app.Activity {

	//var title : ImageElement;
	var banner : ImageElement;

    override function onCreate() {

        super.onCreate();

		//title = new ImageElement( 'image/FUbar.png' );
	//	title.classList.add( 'title' );
		//element.append( title );

        banner = new ImageElement( 'image/giphy-badge-640.gif' );
		banner.classList.add( 'banner' );
		banner.on( 'animationend', function(e:AnimationEvent) {
			switch e.animationName {
			case 'fadeIn':
			case 'fadeOut':
				e.stopPropagation();
				replace( new PlayActivity( trending ) );
			}
    	}, false );
		element.append( banner );
    }

	override function onStart() {
		super.onStart();
	}

	override function onStop() {
		super.onStop();
		banner.remove();
	}
}
