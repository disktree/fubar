package fubar.app;

import js.Browser.document;
import js.Browser.window;
import om.html.ImageElement;
import fubar.ui.Tetroid;

class AboutActivity extends om.app.Activity {

//	var animationFrameId : Int;
	//var tetroid : Tetroid;

    override function onCreate() {

        super.onCreate();

		var canvas = document.createCanvasElement();
		canvas.width = window.innerWidth;
		canvas.height = window.innerHeight;
		element.append( canvas );

		var colors = ['ffff99','ff6666','9933ff','0099bf','00ff99'];
		var height = Std.int( window.innerHeight / colors.length );
		var ctx = canvas.getContext2d();
		var y = 0;
		for( color in ['ffff99','ff6666','9933ff','0099bf','00ff99'] ) {
			ctx.fillStyle = "#"+color;
			ctx.fillRect( 0, y, window.innerWidth, height );
			y += height;
		}

		var eye = document.createImageElement();
		eye.src = 'image/eye.png';
		element.append( eye );

		//var version = document.createDivElement();
		//version.textContent = App.VERSION;
		/*
        //TODO var banner = new ImageElement( res.image.giphy-badge );
        var banner = new ImageElement( 'image/giphy-badge-640.gif' );
        banner.once( 'animationend', function(e) {
            replace( new PlayActivity( trending ) );
        });
        element.append( banner );
		*/

		/*
		tetroid = new Tetroid(360, 14, '#000', 2 );
		tetroid.canvas.classList.add( 'tetroid' );
		tetroid.context.lineWidth = 12;
		tetroid.context.lineCap="round";
		tetroid.context.lineJoin="round";
		element.append( tetroid.canvas );
		*/
    }

	override function onStart() {
        super.onStart();
		//animationFrameId = window.requestAnimationFrame( update );
	}

	override function onStop() {
        super.onStop();
		//window.cancelAnimationFrame( animationFrameId );
	}

	function update( time : Float ) {
		//animationFrameId = window.requestAnimationFrame( update );
		//tetroid.update();
		//tetroid.draw();
    }
}
