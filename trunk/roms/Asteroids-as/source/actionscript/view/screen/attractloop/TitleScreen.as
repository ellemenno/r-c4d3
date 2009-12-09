

package view.screen.attractloop
{
	
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	
	import FontAssets;
	
	import control.Signals;
	import util.f.Message;
	import view.screen.ScreenBase;
	
	
	public class TitleScreen extends ScreenBase
	{
		
		
		public function TitleScreen():void
		{
			C.out(this, "constructor");
			super();
		}
		
		
		override public function initialize():Boolean
		{
			if (!super.initialize()) return false;
			
			var w:int = stage.stageWidth;
			var h:int = stage.stageHeight;
			
			graphics.beginFill(0x777777);
			graphics.drawRect(0,0, w,h);
			graphics.endFill();
			
			var title:TextField = addChild(FontAssets.createTextField("ASTEROIDS", FontAssets.deLarge(120, 0xffffff, TextFormatAlign.CENTER), w)) as TextField;
			title.x = w*.5 - title.width*.5;
			title.y = h*.5 - title.height*.75;
			
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
