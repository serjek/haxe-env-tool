package com.macro;

import haxe.macro.Context;
import haxe.macro.Expr;
import tink.macro.ClassBuilder;

class EnvTool
{
	macro public static function build():Array<Field>
	{
		var builder = new ClassBuilder();
		var fields = Context.getBuildFields();

		for (m in builder) {
			var PROP = m.name.toUpperCase();
			var GETTER = 'get_'+PROP;
			var mvar =  switch m.getVar() {
				case Success(mvar): mvar.expr;
				case _: throw('not a valiable');
			};

			var expr = macro Sys.getEnv($v{PROP}) != null 
				? Sys.getEnv($v{PROP}) 
				: $e{mvar};
			
			builder.removeMember(m);

			builder.addMembers(macro class {
				public static var $PROP(get, never):String;
				static function $GETTER():String return $expr;
			});
		}

		return builder.export();
	}
}