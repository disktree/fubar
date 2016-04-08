package fubar.macro;

#if macro
import haxe.macro.Context;
import haxe.macro.Compiler;
import sys.FileSystem.*;
import sys.io.File.*;
import om.io.FileUtil;
import om.io.FileSync.*;
import om.macro.DefineUtil.*;
import om.build.Config;
using haxe.io.Path;
#end

class Build  {

	macro public static function getGiphyAPIKey() {
		var key = StringTools.trim( sys.io.File.getContent( 'GIPHY_API_KEY' ) );
		return macro $v{key};
	}

	#if macro

	public static inline var OUT = 'out';

	public static var config(default,null) : Config;

    // PARAMS
    public static var out(default,null) : String;
    public static var platform(default,null) : String;
    //public var clean(default,null) : Bool;
    //public var release(default,null) : Bool;
    //public var debug(default,null) : Bool;

	static function onAfterGenerate() {

		//var out = om.Build.out;
		//var platform = om.Build.platform;
		//trace(config);
		//trace(om.macro.DefineUtil.definedValue( 'less-include-path'));

		syncDirectory( 'res/font', '$out/font' );
		syncDirectory( 'res/icon', '$out/icon' );
		syncDirectory( 'res/image', '$out/image' );
		syncDirectory( 'res/worker', '$out/worker' );

		var lessSrc = config.name+'-'+platform+'.less';
		if( !exists( 'res/style/'+lessSrc ) ) lessSrc = config.name+'.less';
		if( !exists( 'res/style/'+lessSrc ) )
			Context.warning( 'no stylesheet found', Context.currentPos() );
		else {
			var includePaths = om.macro.DefineUtil.definedValue( 'less-include-path' );
			lessc( lessSrc, config.name + '.css', includePaths );
		}

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
    }

	static function syncTemplate( src : String, dst : String ) {

		if( !exists( src ) || isDirectory( src ) || !needsUpdate( src, dst ) )
			return false;

		var dir = dst.directory();
		if( !exists( dir ) ) createDirectory( dir );

		var html = new haxe.Template( getContent( src ) ).execute( config );
		saveContent( dst, html );

		return true;
	}

	static function lessc( srcName : String, ?dstName : String, ?includePaths : String ) {

		if( dstName == null ) dstName = srcName;
		var srcPath = 'res/style/$srcName';
		var dstPath = '$out/$dstName';

		var args = [ srcPath, dstPath, '--no-color' ];
		if( config.release ) {
			args.push( '-x' );
			args.push( '--clean-css' );
		}
		if( includePaths != null ) {
			args.push( '--include-path='+includePaths );
		}
		var lessc = new sys.io.Process( 'lessc', args );
		var e = lessc.stderr.readAll().toString();
		if( e.length > 0 )
			Context.error( e.toString(), Context.currentPos() );
	}

	static function app() {

		platform = definedValue( 'platform' );

		out = definedValue( 'out' );
		if( out == null ) out = '$OUT/'+platform;

		var clean = defined( 'clean' );
		if( clean ) {
			if( exists( out ) ) FileUtil.deleteDirectory( out );
		}

		config = om.Hxon.read( 'project.hxon' );

		Compiler.setOutput( '$out/'+config.name+'.js' );

		Context.onAfterGenerate( onAfterGenerate );
	}

	#end
}
