

package com.pixeldroid.r_c4d3.game.view.screen
{
	
	import com.pixeldroid.r_c4d3.data.ResourcePool;
	import com.pixeldroid.r_c4d3.game.view.screen.DebugScreen;
	import com.pixeldroid.r_c4d3.game.view.screen.NullScreen;
	import com.pixeldroid.r_c4d3.game.view.screen.ScreenBase;
	import com.pixeldroid.r_c4d3.interfaces.IGameScreenFactory;
	
	import view.screen.attractloop.GameScreen;
	import view.screen.attractloop.HelpScreen;
	import view.screen.attractloop.ScoresScreen;
	import view.screen.attractloop.SetupScreen;
	import view.screen.attractloop.TitleScreen;
	
	
	
	public class ScreenFactory implements IGameScreenFactory
	{
		
		private var screens:ResourcePool = new ResourcePool();
		
		public function get GAME():String { return "GAME" }
		public function get HELP():String { return "HELP" }
		public function get NULL():String { return "NULL" }
		public function get SCORES():String { return "SCORES" }
		public function get SETUP():String { return "SETUP" }
		public function get TITLE():String { return "TITLE" }
		public function get DEBUG():String { return "DEBUG" }
		
		public function getScreen(type:String):ScreenBase
		{
			var screen:ScreenBase;
			switch (type)
			{
				case GAME   : screen = screens.retrieve(GameScreen, type) as ScreenBase; break;
				case HELP   : screen = screens.retrieve(HelpScreen, type) as ScreenBase; break;
				case NULL   : screen = screens.retrieve(NullScreen, type) as ScreenBase; break;
				case SCORES : screen = screens.retrieve(ScoresScreen, type) as ScreenBase; break;
				case SETUP  : screen = screens.retrieve(SetupScreen, type) as ScreenBase; break;
				case TITLE  : screen = screens.retrieve(TitleScreen, type) as ScreenBase; break;
				case DEBUG  : screen = screens.retrieve(DebugScreen, type) as ScreenBase; break;
				
				default: throw new Error("unsupported screen type: " +type); break;
			}
			
			screen.name = type;
			C.out(this, "getScreen() - " +type);
			
			return screen;
		}
		
	}
}