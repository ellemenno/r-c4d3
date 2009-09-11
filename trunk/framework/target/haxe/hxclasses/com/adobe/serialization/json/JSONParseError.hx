package com.adobe.serialization.json;

extern class JSONParseError extends flash.Error {
	var location(default,null) : Int;
	var text(default,null) : String;
	function new(?p0 : String, ?p1 : Int, ?p2 : String) : Void;
}
