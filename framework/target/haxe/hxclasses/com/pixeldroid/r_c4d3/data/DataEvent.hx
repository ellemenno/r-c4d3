package com.pixeldroid.r_c4d3.data;

extern class DataEvent extends flash.events.Event {
	var data : Dynamic;
	var message : Dynamic;
	function new(p0 : String) : Void;
	static var ERROR : String;
	static var READY : String;
}
