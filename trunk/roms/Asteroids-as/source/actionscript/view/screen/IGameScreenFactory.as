
package view.screen
{
	
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
