# haxe-env-tool
Helper tool to work with environment variables

### What it does
This tool might become useful if you're not a fan of messing with env vars on our dev machine and want to rather mock them in you code. While keeping your dev variables in code you can also replace them with env variables at runtime without even changing syntax.

### How to use
Imagine you have a config with your network params primed for local testing

```haxe
class Config
{
	public static final DATABASE_HOST:String = "localhost";
	public static final DATABASE_PORT:String = 3306;
	public static final DATABASE_NAME:String = "my_database";
}
```

And you want to use it in same way but with environmental variables. Just add build on top:

```haxe
@:build(EnvTool.build())
class Config

```

Now you can provide `environment` in your docker-compose like this:

```yml
environment:
    - DATABASE_HOST=prod_database
```
Note that variables that were not set though env will remain unchanged as they specified.

### Dependencies
[tink_macro](https://github.com/haxetink/tink_macro)
