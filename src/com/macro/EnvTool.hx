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
			var mvar = switch m.getVar() {
				case Success(mvar): 
					{
						expr: mvar.expr,
						type: switch (mvar.type) {
							case TPath(t): t.name;
							case _: throw ('not valid type');
						}
					};
				case _: throw('not a valiable');
			};

			var expr = if (mvar.type == "Int") 
					macro Sys.getEnv($v{PROP}) != null 
						? Std.parseInt(Sys.getEnv($v{PROP}))
						: $e{mvar.expr}
				else 
					macro Sys.getEnv($v{PROP}) != null 
						? Sys.getEnv($v{PROP})
						: $e{mvar.expr};

			builder.removeMember(m);

			if (mvar.type == "Int") 
				builder.addMembers(macro class {
					public static var $PROP(get, never):Int;
					static function $GETTER():Int return $expr;
				})
			else 
				builder.addMembers(macro class {
					public static var $PROP(get, never):String;
					static function $GETTER():String return $expr;
				});
		}

		return builder.export();
	}
}