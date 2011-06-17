

package
{

	import com.pixeldroid.r_c4d3.game.GameBase;
	import com.pixeldroid.r_c4d3.game.screen.IGameScreenFactory;
	
	import screens.GameScreenFactory;
	
	
	
	public class GetToTheSpot extends GameBase
	{
		
		// constructor
		public function GetToTheSpot()
		{
			C.out(this, "GetToTheSpot constructor");
			super();
		}
		
		
		// parent overrides
		override public function enterAttractLoop():void
		{
			super.enterAttractLoop();
		}
		
		override protected function createGameScreenFactory():IGameScreenFactory
		{
			return new GameScreenFactory();
		}
		
	}

}
