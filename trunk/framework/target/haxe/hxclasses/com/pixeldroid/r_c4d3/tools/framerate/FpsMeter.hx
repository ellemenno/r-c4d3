package com.pixeldroid.r_c4d3.tools.framerate;

extern class FpsMeter extends flash.display.Sprite {
	function new() : Void;
	function setFpsInterval(p0 : UInt, p1 : Float) : Void;
	function setFpsTarget(p0 : Float) : Void;
	function startMonitoring() : Void;
	function stopMonitoring() : Void;
}
