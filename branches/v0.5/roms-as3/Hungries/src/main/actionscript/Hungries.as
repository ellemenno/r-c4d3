
/*

Hungries, main class / compiler entry point

*/

package
{

	import com.pixeldroid.r_c4d3.game.GameBase;
	import com.pixeldroid.r_c4d3.interfaces.IGameScreenFactory;
	
	import model.GlobalModel;
	import view.screen.GameScreenFactory;
	
	
	
	public class Hungries extends GameBase
	{
		
		// constructor
		public function Hungries()
		{
			C.out(this, "Hungries constructor");
			super();
		}
		
		
		// parent overrides
		override public function enterAttractLoop():void
		{
			super.enterAttractLoop();
			
			GlobalModel.stageWidth = stage.stageWidth;
			GlobalModel.stageHeight = stage.stageHeight;
		}
		
		override protected function createGameScreenFactory():IGameScreenFactory
		{
			return new GameScreenFactory();
		}
		
	}

}
