package com.pixeldroid.r_c4d3.data;

extern class JsonLoader extends flash.events.EventDispatcher {
	var bytesLoaded(default,null) : UInt;
	var bytesTotal(default,null) : UInt;
	var percent(default,null) : UInt;
	function new(?p0 : flash.net.URLRequest) : Void;
	function load(p0 : flash.net.URLRequest) : Void;
}
