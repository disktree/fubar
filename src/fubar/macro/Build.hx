package fubar.macro;

#if macro
import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;
import sys.io.File;
import sys.FileSystem.*;
import om.io.FileSync;
import Sys.println;

using haxe.io.Path;
#end

class Build {

	#if macro

	static inline var OUT = 'out';

	var name : String;
	var version : String;
    var platform : String;
	var debug : Bool;
	var out : String;

	function new() {

		name = Context.definedValue( 'name' );
		version = Context.definedValue( 'version' );

		//platform = Context.definedValue( 'platform' );
		platform =
			#if android 'android'
			#elseif chrome 'chrome'
			#elseif web 'web'
			#else throw 'no platform specified'
			#end;

		debug = Context.definedValue( "debug" ) == "1";

		out = Context.definedValue( 'out' );
		if( out == null ) out = '$OUT/$platform';
	}

	function start() {

		Compiler.setOutput( '$out/$name.js' );

		Context.onAfterGenerate(function(){

			FileSync.syncDirectory( 'res/font', '$out/font' );
			FileSync.syncDirectory( 'res/image', '$out/image' );

			lessc( 'fubar-$platform', name );

			syncTemplate( 'res/html/index.html', '$out/index.html' );

			/*
			switch platform {
				case 'android':
				case 'chrome':
				case 'web':
			}
			*/

			println( '$name-$version-$platform' );
		});
	}

	function syncTemplate( src : String, dst : String ) {
		if( !exists( src ) || isDirectory( src ) || !FileSync.needsUpdate( src, dst ) )
			return false;
		var dir = dst.directory();
		if( !exists( dir ) ) createDirectory( dir );
		var html = new haxe.Template( File.getContent( src ) ).execute( this );
		File.saveContent( dst, html );
		return true;
	}

	function lessc( srcName : String, ?dstName : String ) {

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

	static function app() {
		var build = new Build();
		build.start();
    }

	#end

	macro public static function getGiphyAPIKey() {
		var key = StringTools.trim( sys.io.File.getContent( 'GIPHY_API_KEY' ) );
		return macro $v{key};
	}
}
