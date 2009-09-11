package com.adobe.serialization.json;

extern class JSONTokenizer {
	function new(p0 : String, p1 : Bool) : Void;
	function getNextToken() : JSONToken;
	function parseError(p0 : String) : Void;
	function unescapeString(p0 : String) : String;
}
