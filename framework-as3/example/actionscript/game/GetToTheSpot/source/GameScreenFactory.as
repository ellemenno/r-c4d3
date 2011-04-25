

package
{
	
	import com.pixeldroid.r_c4d3.game.view.screen.ScreenBase;
	import com.pixeldroid.r_c4d3.game.view.screen.ScreenFactory;
	import com.pixeldroid.r_c4d3.game.view.screen.ScreenType;
	import com.pixeldroid.r_c4d3.game.view.screen.ScreenTypeEnumerator;
	
	import screen.GameScreen;
	import screen.HelpScreen;
	import screen.ScoresScreen;
	import screen.TitleScreen;
	
	
	
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
				case ScreenType.TITLE  : screen = screens.retrieve(TitleScreen, type) as ScreenBase; break;
				case ScreenType.HELP   : screen = screens.retrieve(HelpScreen, type) as ScreenBase; break;
				case ScreenType.GAME   : screen = screens.retrieve(GameScreen, type) as ScreenBase; break;
				case ScreenType.SCORES : screen = screens.retrieve(ScoresScreen, type) as ScreenBase; break;
				
				default: screen = super.retrieveScreen(type); break;
			}
			return screen;
		}
		
	}
}