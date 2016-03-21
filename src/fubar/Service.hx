package fubar;

import js.html.XMLHttpRequest;
import haxe.Json;
import om.Error;
import om.api.Giphy;

class Service {

    static inline var API_URL = 'http://api.giphy.com/v1/gifs';

    //var giphy : Giphy;
    var apiKey : String;

    public function new( apiKey : String ) {
        //giphy = new Giphy( giphyKey );
        this.apiKey = apiKey;
    }

    public function random( n : Int ) {
		//TODO
    }

    public function search( q : Array<String>, ?limit : Int, ?offset : Int, ?rating : Rating, callback : Error->Array<Item>->Void ) {
		var path = '/search?q='+q.join('+');
        if( limit != null ) path += '&limit=$limit';
        if( offset != null ) path += '&offset=$offset';
        if( rating != null ) path += '&rating=$rating';
        request( path, function(e,r){
			if( e != null ) callback(e,null) else {
				callback( null, r.data );
			}
		});
    }

    public function trending( ?limit : Int, ?rating : Rating, callback : Error->Array<Item>->Void ) {
        var path = '/trending?';
        if( limit != null ) path += '&limit=$limit';
        if( rating != null ) path += '&rating=$rating';
        request( path, function(e,r){
            if( e != null ) callback( e, null ) else {
                callback( null, r.data );
            }
        });
    }

    function request<T>( params : String, callback : Error->T->Void ) {
        var req = new XMLHttpRequest();
        req.open( 'GET', '$API_URL$params&api_key=$apiKey', true );
        req.onerror = function(e) callback( e, null );
        req.onload = function(e) callback( null, Json.parse( req.responseText ) );
        req.send();
    }

}
