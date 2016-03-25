package fubar.app;

import js.Browser.document;

class MainActivity extends om.app.Activity {

    override function onCreate() {
        super.onCreate();
        element.text = 'FUBAr';
    }

    override function onStart() {

        super.onStart();

        document.body.onclick = function() {
            //replace( new PreloadActivity( 'trending' ) );
            //replace( new PlayActivity( 'trending' ) );
            replace( new PlayActivity( trending ) );
        }
    }
}
