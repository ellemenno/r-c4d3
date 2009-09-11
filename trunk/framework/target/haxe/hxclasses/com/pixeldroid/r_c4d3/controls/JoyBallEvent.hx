package com.pixeldroid.r_c4d3.controls;

extern class JoyBallEvent extends flash.events.Event {
	var ball : Int;
	var displacement : flash.geom.Point;
	var which : Int;
	var xrel(default,null) : Float;
	var yrel(default,null) : Float;
	function new(p0 : Int, p1 : Int, p2 : Float, p3 : Float, ?p4 : Bool, ?p5 : Bool) : Void;
	static var JOY_BALL_MOTION : String;
}
