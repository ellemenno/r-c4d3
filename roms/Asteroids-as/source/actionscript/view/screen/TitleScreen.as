

package view.screen
{
	
	import control.Signals;
	import util.f.Message;
	import view.screen.ScreenBase;
	
	
	public class TitleScreen extends ScreenBase
	{
		
		private var timeElapsed:int;
		
		
		public function TitleScreen():void
		{
			C.out(this, "constructor");
			super();
		}
		
		
		override public function initialize():Boolean
		{
			timeElapsed = 0;
			
			graphics.beginFill(0xffaaaa);
			graphics.drawRect(0,0, stage.stageWidth,stage.stageHeight);
			graphics.endFill();
			
			return true;
		}
		
		override public function shutDown():Boolean
		{
			graphics.clear();
			return true;
		}
		
		override public function onFrameUpdate(dt:int):void
		{
			timeElapsed += dt;
			if (timeElapsed > 3*1000) timeOut();
		}
		
		
		private function timeOut():void
		{
			C.out(this, "timeOut - sending SCREEN_GO_NEXT signal");
			Message.send(null, Signals.SCREEN_GO_NEXT);
		}
		
	}
}
