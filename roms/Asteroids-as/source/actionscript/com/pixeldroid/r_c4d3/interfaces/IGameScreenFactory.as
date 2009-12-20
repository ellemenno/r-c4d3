
package com.pixeldroid.r_c4d3.interfaces
{
	import com.pixeldroid.r_c4d3.game.view.screen.ScreenBase;
	
	public interface IGameScreenFactory
	{
		function get GAME():String;
		function get HELP():String;
		function get NULL():String;
		function get SCORES():String;
		function get SETUP():String;
		function get TITLE():String;
		function get DEBUG():String;
		
		function getScreen(type:String):ScreenBase;
	}
}
