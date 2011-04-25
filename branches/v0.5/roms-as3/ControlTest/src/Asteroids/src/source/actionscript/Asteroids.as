
/*

Asteroids

*/

package
{

	import com.pixeldroid.r_c4d3.game.GameBase;
	import com.pixeldroid.r_c4d3.interfaces.IGameScreenFactory;
	
	import view.screen.AsteroidsScreenFactory;
	
	
	
	public class Asteroids extends GameBase
	{
		
		// constructor
		public function Asteroids()
		{
			C.out(this, "Asteroids constructor");
			super();
		}
		
		
		// factory method overrides
		override protected function createGameScreenFactory():IGameScreenFactory
		{
			return new AsteroidsScreenFactory();
		}
		
	}

}
