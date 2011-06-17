

package screens
{
	
	import com.pixeldroid.r_c4d3.game.screen.ScreenBase;
	import com.pixeldroid.r_c4d3.game.screen.ScreenFactory;
	import com.pixeldroid.r_c4d3.game.screen.ScreenType;
	import com.pixeldroid.r_c4d3.game.screen.ScreenTypeEnumerator;
	
	import screens.GameScreen;
	import screens.HelpScreen;
	import screens.ScoresScreen;
	import screens.TitleScreen;
	
	
	
	public class GameScreenFactory extends ScreenFactory
	{

		override public function get gameStartScreenType():ScreenTypeEnumerator { return ScreenType.GAME; }		
		
		override public function getNextScreenType(currentType:ScreenTypeEnumerator):ScreenTypeEnumerator
		{
			var nextType:ScreenTypeEnumerator;
			switch (currentType)
			{
				case ScreenType.NULL  : nextType = ScreenType.TITLE;  break;
				case ScreenType.TITLE : nextType = ScreenType.HELP;   break;
				case ScreenType.HELP  : nextType = ScreenType.GAME;   break;
				case ScreenType.GAME  : nextType = ScreenType.SCORES; break;
				case ScreenType.SCORES: nextType = ScreenType.TITLE;  break;
				
				default:
				throw new Error("unrecognized screen type '" +currentType +"'");
				break;
			}
			return nextType;
		}

		override protected function retrieveScreen(type:ScreenTypeEnumerator):ScreenBase
		{
			var screen:ScreenBase;
			switch (type)
			{
				case ScreenType.TITLE  : screen = screenCache.retrieve(TitleScreen, type) as ScreenBase; break;
				case ScreenType.HELP   : screen = screenCache.retrieve(HelpScreen, type) as ScreenBase; break;
				case ScreenType.GAME   : screen = screenCache.retrieve(GameScreen, type) as ScreenBase; break;
				case ScreenType.SCORES : screen = screenCache.retrieve(ScoresScreen, type) as ScreenBase; break;
				
				default: screen = super.retrieveScreen(type); break;
			}
			return screen;
		}
		
	}
}