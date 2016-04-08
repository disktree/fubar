package fubar.macro;

import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;

class BuildApp {

	static function build() : Array<Field> {

		var fields = Context.getBuildFields();
		var pos = Context.currentPos();

		var config = fubar.macro.Build.config;

		trace( config );

		addConstStringField( fields, 'PLAFORM', config.platform );
		addConstStringField( fields, 'NAME', config.name );
		addConstStringField( fields, 'VERSION', config.version );

        return fields;
    }

	static inline function addConstStringField<T>( fields : Array<Field>, name : String, value : String ) {
		addConstField( fields, name, macro:String, macro $v{value} );
	}

	static function addConstField( fields : Array<Field>, name : String, type : ComplexType, expr : Expr) {
		fields.push({
			access: [APublic,AStatic,AInline],
			name: name,
			kind: FVar( type, expr ),
			pos: Context.currentPos()
		});
	}

}
