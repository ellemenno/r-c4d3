

package view.screen.attractloop
{
	
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	
	import FontAssets;
	
	import control.Signals;
	import util.Notifier;
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
			C.out(this, "initialize");
			
			backgroundColor = 0x777777;
			var title:TextField = addChild(FontAssets.createTextField("ASTEROIDS", FontAssets.deLarge(120, 0xffffff, TextFormatAlign.CENTER), width)) as TextField;
			title.x = width*.5 - title.width*.5;
			title.y = height*.5 - title.height*.75;
			
			return true;
		}
		
		override public function shutDown():Boolean
		{
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
			Notifier.send(Signals.SCREEN_GO_NEXT);
		}
		
	}
}
