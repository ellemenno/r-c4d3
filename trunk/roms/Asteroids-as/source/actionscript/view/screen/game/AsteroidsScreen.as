

package view.screen.game
{
	
	import view.screen.ScreenBase;
	
	
	
	public class AsteroidsScreen extends ScreenBase
	{
		
		
		public function AsteroidsScreen():void
		{
			C.out(this, "constructor");
			super();
		}
		
		
		override public function onFrameUpdate(dt:int):void
		{
			super.onFrameUpdate(dt);
		}
		
	}
}