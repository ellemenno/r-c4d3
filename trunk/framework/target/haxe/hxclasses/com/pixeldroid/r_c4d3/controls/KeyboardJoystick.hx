package com.pixeldroid.r_c4d3.controls;

extern class KeyboardJoystick implements com.pixeldroid.r_c4d3.interfaces.IJoystick {
	var index(default,null) : Int;
	var systemName(default,null) : String;
	function new(p0 : Int) : Void;
	function getAxis(p0 : Int) : Int;
	function getButton(p0 : Int) : Bool;
	function getHat(p0 : Int) : Int;
	function setAxis(p0 : Int, p1 : Int) : Void;
	function setButton(p0 : Int, p1 : Bool) : Void;
	function setHat(p0 : Int, p1 : Int) : Void;
}