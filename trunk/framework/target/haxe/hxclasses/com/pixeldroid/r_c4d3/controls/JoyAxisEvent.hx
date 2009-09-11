package com.pixeldroid.r_c4d3.controls;

extern class JoyAxisEvent extends flash.events.Event {
	var axis : Int;
	var value : Int;
	var which : Int;
	function new(p0 : Int, p1 : Int, p2 : Int, ?p3 : Bool, ?p4 : Bool) : Void;
	static var AXIS_VALUE_CENTER : Int;
	static var AXIS_VALUE_MAX : Int;
	static var AXIS_VALUE_MIN : Int;
	static var AXIS_X : Int;
	static var AXIS_Y : Int;
	static var JOY_AXIS_MOTION : String;
}
