package com.pixeldroid.r_c4d3.scores;

extern class ScoreEvent extends flash.events.Event {
	var message : String;
	var success : Bool;
	function new(p0 : String) : Void;
	static var LOAD : String;
	static var SAVE : String;
}
