package com.pixeldroid.r_c4d3.controls;

extern class JoyButtonEvent extends flash.events.Event {
	var button : Int;
	var pressed : Bool;
	var which : Int;
	function new(p0 : String, p1 : Int, p2 : Int, p3 : Bool, ?p4 : Bool, ?p5 : Bool) : Void;
	static var BTN_A : Int;
	static var BTN_B : Int;
	static var BTN_C : Int;
	static var BTN_X : Int;
	static var JOY_BUTTON_DOWN : String;
	static var JOY_BUTTON_MOTION : String;
	static var JOY_BUTTON_UP : String;
	static var PRESSED : Bool;
	static var RELEASED : Bool;
}
