package com.pixeldroid.r_c4d3.scores;

extern class RemoteHighScores extends HighScores, implements flash.events.IEventDispatcher {
	var remoteUrl : String;
	function new(?p0 : String, ?p1 : Int, ?p2 : String) : Void;
	function addEventListener(p0 : String, p1 : Dynamic, ?p2 : Bool, ?p3 : Int, ?p4 : Bool) : Void;
	function dispatchEvent(p0 : flash.events.Event) : Bool;
	function hasEventListener(p0 : String) : Bool;
	function load() : Void;
	function removeEventListener(p0 : String, p1 : Dynamic, ?p2 : Bool) : Void;
	function toJson() : String;
	function willTrigger(p0 : String) : Bool;
}
