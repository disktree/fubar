package fubar.app;

import js.Browser.window;
import om.input.Keycode;
import om.api.Giphy;
import fubar.App.service;

class ItemLoadActivity extends om.app.Activity {

	var itemId : String;

	var animationFrameId : Int;
	var tetroid : fubar.ui.Tetroid;

	public function new( itemId : String ) {
		super();
		this.itemId = itemId;
	}

	override function onCreate() {
		
        super.onCreate();
		//lement.text = '####';

		tetroid = new fubar.ui.Tetroid( 400, 20, '#ffffff' );
		tetroid.canvas.style.background = '#0000ff';
		element.append( tetroid.canvas );
	}

	override function onStart() {

        super.onStart();

		animationFrameId = window.requestAnimationFrame( update );

		/*
		service.get( itemId, function(e,item) {
			if( e != null )
				replace( new ErrorActivity( e ) );
			else
				replace( new ItemActivity( item ) );
		});
		*/
	}


	override function onStop() {
	    super.onStop();
		window.cancelAnimationFrame( animationFrameId );
	}

	function update( time : Float ) {
		animationFrameId = window.requestAnimationFrame( update );
		tetroid.update();
		tetroid.draw();
	}
}
