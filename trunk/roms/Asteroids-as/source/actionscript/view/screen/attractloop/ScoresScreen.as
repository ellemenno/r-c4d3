

package view.screen.attractloop
{
	
	import flash.text.TextField;
	
	import control.Signals;
	import util.f.Message;
	import view.screen.ScreenBase;
	
	
	public class ScoresScreen extends ScreenBase
	{
		
		
		public function ScoresScreen():void
		{
			C.out(this, "constructor");
			super();
		}
		
		
		override public function initialize():Boolean
		{
			if (!super.initialize()) return false;
			
			var w:int = stage.stageWidth;
			var h:int = stage.stageHeight;
			
			graphics.beginFill(0x555555);
			graphics.drawRect(0,0, w,h);
			graphics.endFill();
			
			var title:TextField = addChild(FontAssets.createTextField("High Scores", FontAssets.blojbytesdepa())) as TextField;
			title.x = 15;
			title.y = 15;
			
			return true;
		}
		
		override public function shutDown():Boolean
		{
			graphics.clear();
			return super.shutDown();;
		}
		
		override public function onFrameUpdate(dt:int):void
		{
			super.onFrameUpdate(dt);
			
			if (timeElapsed > 3*1000) timeOut();
		}
		
		
		private function timeOut():void
		{
			C.out(this, "timeOut - sending SCREEN_GO_NEXT signal");
			Message.send(null, Signals.SCREEN_GO_NEXT);
		}
		
	}
}
