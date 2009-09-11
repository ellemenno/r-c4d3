package com.pixeldroid.r_c4d3.scores;

extern class HighScores implements com.pixeldroid.r_c4d3.interfaces.IGameScoresProxy {
	var gameId(default,null) : String;
	var length(default,null) : UInt;
	var totalScores : Int;
	function new(?p0 : String, ?p1 : Int) : Void;
	function closeScoresTable() : Void;
	function getInitials(p0 : Int) : String;
	function getScore(p0 : Int) : Float;
	function initialize(?p0 : String) : Void;
	function insert(p0 : Float, p1 : String) : Bool;
	function isEligible(p0 : Float) : Bool;
	function openScoresTable(p0 : String) : Void;
	function reset() : Void;
	function store() : Void;
	function testInsert(p0 : Array<Dynamic>) : Array<Dynamic>;
	function toString() : String;
	private var initials : Array<Dynamic>;
	private var scores : Array<Dynamic>;
}
