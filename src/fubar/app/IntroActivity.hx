package fubar.app;

import om.html.ImageElement;

class IntroActivity extends om.app.Activity {

    override function onCreate() {

        super.onCreate();

        //TODO var banner = new ImageElement( res.image.giphy-badge );
        var banner = new ImageElement( 'image/giphy-badge-640.gif' );
        banner.once( 'animationend', function(e) {
            replace( new PlayActivity( trending ) );
        });
        element.append( banner );
    }
}
