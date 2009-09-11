package com.pixeldroid.r_c4d3.controls;

extern class JoyHatEvent extends flash.events.Event {
	var hat : Int;
	var isCentered(default,null) : Bool;
	var isDown(default,null) : Bool;
	var isLeft(default,null) : Bool;
	var isLeftDown(default,null) : Bool;
	var isLeftUp(default,null) : Bool;
	var isRight(default,null) : Bool;
	var isRightDown(default,null) : Bool;
	var isRightUp(default,null) : Bool;
	var isStrictlyDown(default,null) : Bool;
	var isStrictlyLeft(default,null) : Bool;
	var isStrictlyRight(default,null) : Bool;
	var isStrictlyUp(default,null) : Bool;
	var isUp(default,null) : Bool;
	var value : Int;
	var which : Int;
	function new(p0 : Int, p1 : Int, p2 : Int, ?p3 : Bool, ?p4 : Bool) : Void;
	function bit4ToString(p0 : Int) : String;
	static var HAT_CENTERED : Int;
	static var HAT_DOWN : Int;
	static var HAT_LEFT : Int;
	static var HAT_LEFTDOWN : Int;
	static var HAT_LEFTUP : Int;
	static var HAT_RIGHT : Int;
	static var HAT_RIGHTDOWN : Int;
	static var HAT_RIGHTUP : Int;
	static var HAT_UP : Int;
	static var JOY_HAT_MOTION : String;
}
