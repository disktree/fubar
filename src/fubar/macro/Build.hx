package fubar.macro;

#if macro
import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;
import sys.io.File.*;
import sys.FileSystem.*;
import om.io.FileSync.*;
import Sys.println;
using haxe.io.Path;
#end

typedef Window = Dynamic;

typedef Config = {

	var name : String;
	var version : String;

	var debug : Bool;
	var release : Bool;

	@:optional var window : Window;
	@:optional var description : String;
};

class Build<T:Config> {

	macro public static function getGiphyAPIKey() {
		var key = StringTools.trim( sys.io.File.getContent( 'GIPHY_API_KEY' ) );
		return macro $v{key};
	}

	#if macro

	public static inline var OUT = 'out';

	public static var platform(default,null) : String;
	public static var out(default,null) : String;

	public var config(default,null) : T;

	function new() {}

	function app( config : T ) {

		this.config = config;

		Compiler.setOutput( '$out/${config.name}.js' );

		Context.onAfterGenerate(function(){

			syncDirectory( 'res/font', '$out/font' );
			syncDirectory( 'res/image', '$out/image' );

			lessc( config.name+'-'+platform, config.name );

			syncTemplate( 'res/html/index.html', '$out/index.html' );

			#if android

			#elseif chrome
			syncDirectory( 'res/icon', '$out/icon' );
			syncFile( 'res/chrome/background.js', '$out/background.js' );
			syncTemplate( 'res/chrome/manifest.json', '$out/manifest.json' );

			#elseif web
			syncDirectory( 'res/icon', '$out/icon' );
			syncTemplate( 'res/web/manifest.json', '$out/manifest.json' );

			#end

			println( config.name +'-'+platform+'-'+config.version );
		});
	}

	function syncTemplate( src : String, dst : String ) {

		if( !exists( src ) || isDirectory( src ) || !needsUpdate( src, dst ) )
			return false;

		var dir = dst.directory();
		if( !exists( dir ) ) createDirectory( dir );
		var html = new haxe.Template( getContent( src ) ).execute( config );
		saveContent( dst, html );

		return true;
	}

	function lessc( srcName : String, ?dstName : String, debug = false ) {

		if( dstName == null ) dstName = srcName;
		var srcPath = 'res/style/$srcName.less';
		var dstPath = '$out/$dstName.css';

		var args = [ srcPath, dstPath, '--no-color' ];
		if( !debug ) {
			args.push( '-x' );
			args.push( '--clean-css' );
		}
		var lessc = new sys.io.Process( 'lessc', args );
		var e = lessc.stderr.readAll().toString();
		if( e.length > 0 )
			Context.error( e.toString(), Context.currentPos() );
	}

	static function project() {

		platform =
			#if android 'android'
			#elseif chrome 'chrome'
			#elseif web 'web'
			#else throw 'no platform specified'
			#end;

		out = Context.definedValue( 'out' );
		if( out == null ) out = '$OUT/'+platform;

		var config = om.Hxon.read( 'project.hxon' );
		Reflect.setField( config, platform, true );

		new Build().app( config );
    }

	#end

}
