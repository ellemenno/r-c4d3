

package view.screen.game
{
	
	import com.pixeldroid.r_c4d3.game.view.screen.ScreenBase;
	
	
	
	public class AsteroidsScreen extends ScreenBase
	{
		
		
		public function AsteroidsScreen():void
		{
			C.out(this, "constructor");
			super();
		}
		
		
		override public function onScreenUpdate(dt:int):void
		{
			super.onScreenUpdate(dt);
		}
		
	}
}
