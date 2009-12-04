

package view.screen
{
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	import FontAssets;
	
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
			
			graphics.beginFill(0x330000);
			graphics.drawRect(0,0, stage.stageWidth,stage.stageHeight);
			graphics.endFill();
			
			var format:TextFormat = FontAssets.deLarge;
			format.size = 120;
			
			var title:TextField = addChild(new TextField()) as TextField;
			title.selectable = false;
			title.embedFonts = true;
			title.autoSize = TextFieldAutoSize.LEFT;
			title.width = stage.stageWidth;
			title.text = "ASTEROIDS";
			title.setTextFormat(format);
			title.x = stage.stageWidth*.5 - title.width*.5;
			title.y = stage.stageHeight*.5 - title.height*.75;
			
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
