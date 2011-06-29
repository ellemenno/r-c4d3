

package view.screen
{
	
	import com.pixeldroid.r_c4d3.game.view.screen.ScreenBase;
	import com.pixeldroid.r_c4d3.game.view.screen.ScreenFactory;
	
	import view.screen.attractloop.GameScreen;
	import view.screen.attractloop.HelpScreen;
	import view.screen.attractloop.ScoresScreen;
	import view.screen.attractloop.SetupScreen;
	import view.screen.attractloop.TitleScreen;
	
	
	
	public class AsteroidsScreenFactory extends ScreenFactory
	{
		
		override public function getScreen(type:String):ScreenBase
		{
			var screen:ScreenBase;
			switch (type)
			{
				case GAME   : screen = screens.retrieve(GameScreen, type) as ScreenBase; break;
				case HELP   : screen = screens.retrieve(HelpScreen, type) as ScreenBase; break;
				case SCORES : screen = screens.retrieve(ScoresScreen, type) as ScreenBase; break;
				case SETUP  : screen = screens.retrieve(SetupScreen, type) as ScreenBase; break;
				case TITLE  : screen = screens.retrieve(TitleScreen, type) as ScreenBase; break;
				
				case NULL   : 
				case DEBUG  : screen = super.getScreen(type); break;
				
				default: throw new Error("unsupported screen type: " +type); break;
			}
			
			screen.name = type;
			C.out(this, "getScreen() - " +type);
			
			return screen;
		}
		
	}
}