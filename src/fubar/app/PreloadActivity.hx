package fubar.app;

import fubar.App.giphy;

class PreloadActivity extends om.app.Activity {

    /*
    override function onCreate() {
        super.onCreate();
    }
    */

    override function onStart() {

        super.onStart();

        /*
        giphy.trending( 10, function(e,r){
            if( e != null ) {
                replace( new ErrorActivity( Std.string(e) ) );
            } else {
                replace( new MediaSetActivity( r.data ) );
            }
        });
        */
    }
}
