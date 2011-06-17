

package view.screens
{
	
	import com.pixeldroid.r_c4d3.game.screen.ScreenBase;
	import com.pixeldroid.r_c4d3.game.screen.ScreenFactory;
	
	import view.screens.GameScreen;
	import view.screens.HelpScreen;
	import view.screens.ScoresScreen;
	import view.screens.TitleScreen;
	
	
	
	public class GameScreenFactory extends ScreenFactory
	{

		override public function get gameStartScreenType():String { return GAME; }		
		
		override public function getNextScreenType(currentType:String):String
		{
			var nextType:String;
			switch (currentType)
			{
				case NULL  : nextType = TITLE;  break;
				case TITLE : nextType = HELP;   break;
				case HELP  : nextType = GAME;   break;
				case GAME  : nextType = SCORES; break;
				case SCORES: nextType = TITLE;  break;
				
				default:
				throw new Error("unrecognized screen type '" +currentType +"'");
				break;
			}
			return nextType;
		}

		override protected function retrieveScreen(type:String):ScreenBase
		{
			var screen:ScreenBase;
			switch (type)
			{
				case TITLE  : screen = screenCache.retrieve(TitleScreen, type) as ScreenBase; break;
				case HELP   : screen = screenCache.retrieve(HelpScreen, type) as ScreenBase; break;
				case GAME   : screen = screenCache.retrieve(GameScreen, type) as ScreenBase; break;
				case SCORES : screen = screenCache.retrieve(ScoresScreen, type) as ScreenBase; break;
				
				case NULL   : 
				case DEBUG  : screen = super.retrieveScreen(type); break;
				
				default: throw new Error("unsupported screen type: " +type); break;
			}
			return screen;
		}
		
	}
}