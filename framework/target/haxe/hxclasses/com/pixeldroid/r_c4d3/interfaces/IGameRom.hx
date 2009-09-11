package com.pixeldroid.r_c4d3.interfaces;

extern interface IGameRom {
	function enterAttractLoop() : Void;
	function setControlsProxy(p0 : IGameControlsProxy) : Void;
	function setScoresProxy(p0 : IGameScoresProxy) : Void;
}
