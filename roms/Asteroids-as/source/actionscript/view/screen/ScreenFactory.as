

package view.screen
{
	
	import flash.utils.Dictionary;
	
	import view.screen.NullScreen;
	import view.screen.ScreenBase;
	import view.screen.attractloop.GameScreen;
	import view.screen.attractloop.HelpScreen;
	import view.screen.attractloop.ScoresScreen;
	import view.screen.attractloop.SetupScreen;
	import view.screen.attractloop.TitleScreen;
	import view.screen.debug.DebugScreen;
	
	
	
	public class ScreenFactory
	{
		static public const GAME:String = "GAME";
		static public const HELP:String = "HELP";
		static public const NULL:String = "NULL";
		static public const SCORES:String = "SCORES";
		static public const SETUP:String = "SETUP";
		static public const TITLE:String = "TITLE";
		static public const DEBUG:String = "DEBUG";
		
		static private var screens:Dictionary = new Dictionary();
		
		
		
		static public function get gameScreen():ScreenBase
		{
			C.out(ScreenFactory, "get gameScreen()");
			return retrieveScreen(GameScreen, GAME);
		}
		
		static public function get helpScreen():ScreenBase
		{
			C.out(ScreenFactory, "get helpScreen()");
			return retrieveScreen(HelpScreen, HELP);
		}
		
		static public function get nullScreen():ScreenBase
		{
			C.out(ScreenFactory, "get nullScreen()");
			return retrieveScreen(NullScreen, NULL);
		}
		
		static public function get scoresScreen():ScreenBase
		{
			C.out(ScreenFactory, "get scoresScreen()");
			return retrieveScreen(ScoresScreen, SCORES);
		}
		
		static public function get setupScreen():ScreenBase
		{
			C.out(ScreenFactory, "get setupScreen()");
			return retrieveScreen(SetupScreen, SETUP);
		}
		
		static public function get titleScreen():ScreenBase
		{
			C.out(ScreenFactory, "get titleScreen()");
			return retrieveScreen(TitleScreen, TITLE);
		}
		
		static public function get debugScreen():ScreenBase
		{
			C.out(ScreenFactory, "get debugScreen()");
			return retrieveScreen(DebugScreen, DEBUG);
		}
		
		
		static private function retrieveScreen(screenClass:Class, name:String):ScreenBase
		{
			// resource pooling; only instantiate once
			if (screens[name] == null)
			{
				var screen:IScreen = new screenClass() as ScreenBase;
				screen.name = name;
				screens[name] = screen;
			}
			return screens[name] as ScreenBase;
		}
		
	}
}