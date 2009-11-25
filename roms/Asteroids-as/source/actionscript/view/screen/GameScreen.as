

package view.screen
{
	
	import control.Signals;
	import util.f.Message;
	import view.sprite.Ship;
	import view.screen.ScreenBase;
	
	
	public class GameScreen extends ScreenBase
	{
		
		private var ship1:Ship;
		
		
		public function GameScreen():void
		{
			C.out(this, "constructor");
			super();
		}
		
		
		override public function initialize():Boolean
		{
			graphics.beginFill(0xaaffff);
			graphics.drawRect(0,0, stage.stageWidth,stage.stageHeight);
			graphics.endFill();
			
			//ship1 = addChild(new Ship) as Ship;
			
			return true;
		}
		
		override public function shutDown():Boolean
		{
			//removeChild(ship1);
			graphics.clear();
			return true;
		}
		
		override public function onFrameUpdate(dt:int):void
		{
		}
		
		
		private function gameOver():void
		{
			C.out(this, "gameOver - sending SCREEN_GO_NEXT signal");
			Message.send(null, Signals.SCREEN_GO_NEXT);
		}
		
	}
}
