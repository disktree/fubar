package fubar.app;

class ErrorActivity extends om.app.ErrorActivity<om.Error> {

    override function onCreate() {
        super.onCreate();
        element.text = error.toString();
    }

}
