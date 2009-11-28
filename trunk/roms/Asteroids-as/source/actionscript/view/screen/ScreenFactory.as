

package view.screen
{
	
	import flash.utils.Dictionary;
	
	import view.screen.ScreenBase;
	
	import view.screen.AsteroidsScreen;
	import view.screen.DebugScreen;
	import view.screen.GameScreen;
	import view.screen.HelpScreen;
	import view.screen.NullScreen;
	import view.screen.ScoresScreen;
	import view.screen.SetupScreen;
	import view.screen.TitleScreen;
	
	
	
	public class ScreenFactory
	{
		static public const GAME:String = "GAME";
		static public const HELP:String = "HELP";
		static public const NULL:String = "NULL";
		static public const SCORES:String = "SCORES";
		static public const SETUP:String = "SETUP";
		static public const TITLE:String = "TITLE";
		
		private var screens:Dictionary;
		
		
		public function ScreenFactory():void
		{
			screens = new Dictionary();
		}
		
		
		
		public function get gameScreen():ScreenBase
		{
			C.out(ScreenFactory, "get gameScreen()");
			return retrieveScreen(GameScreen, GAME);
		}
		
		public function get helpScreen():ScreenBase
		{
			C.out(ScreenFactory, "get helpScreen()");
			return retrieveScreen(HelpScreen, HELP);
		}
		
		public function get nullScreen():ScreenBase
		{
			C.out(ScreenFactory, "get nullScreen()");
			return retrieveScreen(NullScreen, NULL);
		}
		
		public function get scoresScreen():ScreenBase
		{
			C.out(ScreenFactory, "get scoresScreen()");
			return retrieveScreen(ScoresScreen, SCORES);
		}
		
		public function get setupScreen():ScreenBase
		{
			C.out(ScreenFactory, "get setupScreen()");
			return retrieveScreen(SetupScreen, SETUP);
		}
		
		public function get titleScreen():ScreenBase
		{
			C.out(ScreenFactory, "get titleScreen()");
			return retrieveScreen(TitleScreen, TITLE);
		}
		
		
		private function retrieveScreen(screenClass:Class, name:String):ScreenBase
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