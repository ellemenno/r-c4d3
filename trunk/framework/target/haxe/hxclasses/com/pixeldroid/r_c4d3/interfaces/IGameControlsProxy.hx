package com.pixeldroid.r_c4d3.interfaces;

extern interface IGameControlsProxy implements flash.events.IEventDispatcher {
	function joystickClose(p0 : IJoystick) : Void;
	function joystickEventState(p0 : String, p1 : flash.display.Stage) : String;
	function joystickGetAxis(p0 : IJoystick, p1 : Int) : Int;
	function joystickGetBall(p0 : IJoystick, p1 : Int, p2 : flash.geom.Point) : Bool;
	function joystickGetButton(p0 : IJoystick, p1 : Int) : Bool;
	function joystickGetHat(p0 : IJoystick, p1 : Int) : Int;
	function joystickIndex(p0 : IJoystick) : Int;
	function joystickName(p0 : IJoystick) : String;
	function joystickNumAxes(p0 : IJoystick) : Int;
	function joystickNumBalls(p0 : IJoystick) : Int;
	function joystickNumButtons(p0 : IJoystick) : Int;
	function joystickNumHats(p0 : IJoystick) : Int;
	function joystickOpen(p0 : Int) : IJoystick;
	function joystickOpened(p0 : Int) : Bool;
	function numJoysticks() : Int;
}
