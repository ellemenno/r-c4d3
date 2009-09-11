package com.pixeldroid.r_c4d3.interfaces;

extern interface IGameScoresProxy {
	var gameId(default,null) : String;
	var length(default,null) : UInt;
	var totalScores : Int;
	function closeScoresTable() : Void;
	function getInitials(p0 : Int) : String;
	function getScore(p0 : Int) : Float;
	function insert(p0 : Float, p1 : String) : Bool;
	function isEligible(p0 : Float) : Bool;
	function openScoresTable(p0 : String) : Void;
	function reset() : Void;
	function store() : Void;
	function testInsert(p0 : Array<Dynamic>) : Array<Dynamic>;
	function toString() : String;
}
