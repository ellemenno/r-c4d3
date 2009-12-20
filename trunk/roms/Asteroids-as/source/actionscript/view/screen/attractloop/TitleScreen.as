

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
		
		
		override protected function onFirstScreen():void
		{
			backgroundColor = 0x777777;
			var title:TextField = addChild(FontAssets.createTextField("ASTEROIDS", FontAssets.deLarge(120, 0xffffff, TextFormatAlign.CENTER), width)) as TextField;
			title.x = width*.5 - title.width*.5;
			title.y = height*.5 - title.height*.75;
		}
		
		override public function onScreenUpdate(dt:int):void
		{
			super.onScreenUpdate(dt);
			
			if (timeElapsed > 3*1000) timeOut();
		}
		
		
		private function timeOut():void
		{
			C.out(this, "timeOut - sending SCREEN_GO_NEXT signal");
			Notifier.send(Signals.SCREEN_GO_NEXT);
		}
		
	}
}
