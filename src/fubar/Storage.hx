package fubar;

import haxe.Json;

class Storage {

    static inline var PREFIX = 'fubar_';

    #if chrome
    static var storage = chrome.Storage.local;
    #else
    static var storage = js.Browser.getLocalStorage();
    #end

    public static function get<T>( id : String, callback : T->Void ) {

        #if chrome
        storage.get( PREFIX + id, callback );

        #else
        var item = storage.getItem( PREFIX + id );
        callback( (item == null) ? null : Json.parse( item ) );

        #end
    }

    public static inline function set<T>( id : String, data : T ) {

        #if chrome
        chrome.Storage.local.set( data );

        #else
        storage.setItem( PREFIX + id, Json.stringify( data ) );

        #end
    }

    public static inline function clear() {
        storage.clear();
    }
}
